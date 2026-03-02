import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Log severity levels.
enum LogLevel { debug, info, warning, error }

/// A single log entry with timestamp, level, tag, and sanitized message.
class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String tag;
  final String message;

  const LogEntry({
    required this.timestamp,
    required this.level,
    required this.tag,
    required this.message,
  });

  String get levelLabel => level.name.toUpperCase();

  @override
  String toString() {
    final ts = timestamp.toIso8601String();
    return '[$ts] [$levelLabel] [$tag] $message';
  }
}

/// Aggressively sanitizes log messages to prevent credential leakage.
///
/// This is a security-first sanitizer — it intentionally over-redacts to ensure
/// no passwords, private keys, PINs, tokens, IP addresses, or other secrets
/// can appear in exported logs.
class LogSanitizer {
  LogSanitizer._();

  // Key-value patterns: password=xxx, token: xxx, etc.
  // Matches common delimiters: =, :, ":", ':', etc.
  static final _kvPatterns = [
    // password, passwd, pass, pwd variants
    RegExp(
      r'''(password|passwd|pass|pwd|passwort)\s*[:=]\s*\S+''',
      caseSensitive: false,
    ),
    // pin variants
    RegExp(
      r'''(pin|pin_code|pincode|pin_hash|pin_salt)\s*[:=]\s*\S+''',
      caseSensitive: false,
    ),
    // token, api_key, apikey, secret, auth
    RegExp(
      r'''(token|api[_-]?key|secret|auth[_-]?key|access[_-]?key|bearer|session[_-]?id|session[_-]?key|api[_-]?secret|client[_-]?secret)\s*[:=]\s*\S+''',
      caseSensitive: false,
    ),
    // private_key, privatekey, priv_key
    RegExp(
      r'''(private[_-]?key|priv[_-]?key)\s*[:=]\s*\S+''',
      caseSensitive: false,
    ),
    // passphrase
    RegExp(
      r'''(passphrase|pass[_-]?phrase)\s*[:=]\s*\S+''',
      caseSensitive: false,
    ),
    // credential, cred
    RegExp(
      r'''(credential|cred|credentials)\s*[:=]\s*\S+''',
      caseSensitive: false,
    ),
    // cookie
    RegExp(r'''(cookie|set-cookie)\s*[:=]\s*\S+''', caseSensitive: false),
  ];

  // PEM private key blocks (RSA, DSA, EC, OPENSSH, ENCRYPTED, generic PRIVATE KEY)
  static final _pemPrivateKey = RegExp(
    r'-----BEGIN\s+[\w\s]*PRIVATE\s+KEY-----[\s\S]*?-----END\s+[\w\s]*PRIVATE\s+KEY-----',
    caseSensitive: false,
  );

  // PEM certificate blocks (could contain sensitive info)
  static final _pemCert = RegExp(
    r'-----BEGIN\s+[\w\s]*CERTIFICATE-----[\s\S]*?-----END\s+[\w\s]*CERTIFICATE-----',
    caseSensitive: false,
  );

  // IPv4 addresses
  static final _ipv4 = RegExp(r'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b');

  // IPv6 addresses (simplified — catches most common forms)
  static final _ipv6 = RegExp(
    r'\b(?:[0-9a-fA-F]{1,4}:){2,7}[0-9a-fA-F]{1,4}\b'
    r'|'
    r'\b::(?:[0-9a-fA-F]{1,4}:){0,5}[0-9a-fA-F]{1,4}\b'
    r'|'
    r'\b(?:[0-9a-fA-F]{1,4}:){1,6}:\b',
  );

  // Base64-encoded strings that look like secrets (long base64 blocks, 32+ chars)
  static final _longBase64 = RegExp(r'\b[A-Za-z0-9+/]{32,}={0,2}\b');

  // JWT tokens
  static final _jwt = RegExp(
    r'\beyJ[A-Za-z0-9_-]+\.eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\b',
  );

  // SSH fingerprints (SHA256:...)
  static final _sshFingerprint = RegExp(
    r'SHA256:[A-Za-z0-9+/=]{43,}',
    caseSensitive: false,
  );

  // Email addresses (could be usernames)
  static final _email = RegExp(
    r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b',
  );

  // Authorization header values
  static final _authHeader = RegExp(
    r'(Authorization|Proxy-Authorization)\s*:\s*\S+',
    caseSensitive: false,
  );

  // Hex-encoded secrets (64+ hex chars, likely SHA-256 hashes or keys)
  static final _hexSecret = RegExp(r'\b[0-9a-fA-F]{64,}\b');

  /// Sanitize a log message by replacing all sensitive patterns with [REDACTED].
  static String sanitize(String message) {
    var result = message;

    // 1. PEM private keys (do first, they're multiline)
    result = result.replaceAll(_pemPrivateKey, '[REDACTED:PRIVATE_KEY]');
    result = result.replaceAll(_pemCert, '[REDACTED:CERTIFICATE]');

    // 2. JWT tokens
    result = result.replaceAll(_jwt, '[REDACTED:TOKEN]');

    // 3. Authorization headers
    result = result.replaceAllMapped(_authHeader, (m) {
      final key = m.group(1) ?? 'Authorization';
      return '$key: [REDACTED]';
    });

    // 4. Key-value credential patterns
    for (final pattern in _kvPatterns) {
      result = result.replaceAllMapped(pattern, (m) {
        final key = m.group(1) ?? 'credential';
        return '$key=[REDACTED]';
      });
    }

    // 5. SSH fingerprints
    result = result.replaceAll(_sshFingerprint, 'SHA256:[REDACTED]');

    // 6. IP addresses
    result = result.replaceAll(_ipv4, '[REDACTED:IP]');
    result = result.replaceAll(_ipv6, '[REDACTED:IP]');

    // 7. Email addresses
    result = result.replaceAll(_email, '[REDACTED:EMAIL]');

    // 8. Long base64 strings (likely encoded secrets)
    result = result.replaceAll(_longBase64, '[REDACTED:BASE64]');

    // 9. Long hex strings (likely hashes/keys)
    result = result.replaceAll(_hexSecret, '[REDACTED:HEX]');

    return result;
  }
}

/// Singleton in-app logging service with an in-memory ring buffer.
///
/// All messages are sanitized before storage to prevent credential leakage.
/// Maximum buffer size is [maxEntries] (default 1000).
class LoggingService {
  LoggingService._();
  static final LoggingService instance = LoggingService._();

  /// Maximum number of log entries to keep in the ring buffer.
  static const int maxEntries = 1000;

  final Queue<LogEntry> _buffer = Queue<LogEntry>();

  /// Read-only view of current log entries (oldest first).
  List<LogEntry> get entries => List.unmodifiable(_buffer.toList());

  /// Number of entries currently in the buffer.
  int get length => _buffer.length;

  /// Whether the buffer is empty.
  bool get isEmpty => _buffer.isEmpty;

  /// Log a message at the given [level] with a [tag] for categorization.
  ///
  /// The [message] is sanitized before being stored.
  void log(LogLevel level, String tag, String message) {
    final sanitized = LogSanitizer.sanitize(message);
    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      tag: tag,
      message: sanitized,
    );

    _buffer.addLast(entry);
    while (_buffer.length > maxEntries) {
      _buffer.removeFirst();
    }

    // Also print to debug console in debug mode
    if (kDebugMode) {
      debugPrint(entry.toString());
    }
  }

  /// Convenience method: log at [LogLevel.debug].
  void debug(String tag, String message) => log(LogLevel.debug, tag, message);

  /// Convenience method: log at [LogLevel.info].
  void info(String tag, String message) => log(LogLevel.info, tag, message);

  /// Convenience method: log at [LogLevel.warning].
  void warning(String tag, String message) =>
      log(LogLevel.warning, tag, message);

  /// Convenience method: log at [LogLevel.error].
  void error(String tag, String message) => log(LogLevel.error, tag, message);

  /// Clear all log entries.
  void clear() => _buffer.clear();

  /// Export all log entries as a sanitized plain-text string.
  String exportAsText() {
    if (_buffer.isEmpty) return '';

    final sb = StringBuffer();
    sb.writeln('=== SSH Vault Log Export ===');
    sb.writeln('Exported: ${DateTime.now().toIso8601String()}');
    sb.writeln('Entries: ${_buffer.length}');
    sb.writeln('===========================');
    sb.writeln();

    for (final entry in _buffer) {
      sb.writeln(entry.toString());
    }

    return sb.toString();
  }

  /// Export logs to a temporary file and return its path.
  ///
  /// Returns `null` if there are no log entries.
  Future<String?> exportToFile() async {
    if (_buffer.isEmpty) return null;

    final text = exportAsText();
    final dir = await getTemporaryDirectory();
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');
    final file = File('${dir.path}/sshvault_logs_$timestamp.txt');
    await file.writeAsString(text);
    return file.path;
  }
}
