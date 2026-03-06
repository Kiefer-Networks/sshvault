import 'dart:io';

import 'package:sshvault/core/services/logging_service.dart';

/// Parsed SSH config host entry.
class SshConfigEntry {
  final String name;
  final String hostname;
  final int port;
  final String username;
  final String? identityFile;
  final String? proxyJump;

  const SshConfigEntry({
    required this.name,
    required this.hostname,
    this.port = 22,
    this.username = 'root',
    this.identityFile,
    this.proxyJump,
  });

  @override
  String toString() => 'SshConfigEntry($name → $username@$hostname:$port)';
}

/// Parses OpenSSH config files (~/.ssh/config).
class SshConfigParser {
  static final _log = LoggingService.instance;
  static const _tag = 'SSHConfig';

  SshConfigParser._();

  /// Returns the platform-appropriate path to ~/.ssh/config.
  static String get defaultConfigPath {
    final home = Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        '';
    return '$home${Platform.pathSeparator}.ssh${Platform.pathSeparator}config';
  }

  /// Whether the SSH config file exists.
  static bool get configExists => File(defaultConfigPath).existsSync();

  /// Parses the SSH config file and returns a list of host entries.
  ///
  /// Skips wildcard hosts (e.g. `Host *`) and entries without a
  /// HostName directive.
  static Future<List<SshConfigEntry>> parse({String? path}) async {
    final configPath = path ?? defaultConfigPath;
    final file = File(configPath);

    if (!file.existsSync()) {
      _log.warning(_tag, 'SSH config not found at $configPath');
      return [];
    }

    try {
      final lines = await file.readAsLines();
      return _parseLines(lines);
    } catch (e) {
      _log.error(_tag, 'Failed to parse SSH config: $e');
      return [];
    }
  }

  static List<SshConfigEntry> _parseLines(List<String> lines) {
    final entries = <SshConfigEntry>[];
    String? currentHost;
    String? hostname;
    int port = 22;
    String username = 'root';
    String? identityFile;
    String? proxyJump;

    void flushEntry() {
      if (currentHost != null && hostname != null) {
        entries.add(SshConfigEntry(
          name: currentHost!,
          hostname: hostname!,
          port: port,
          username: username,
          identityFile: identityFile,
          proxyJump: proxyJump,
        ));
      }
      currentHost = null;
      hostname = null;
      port = 22;
      username = 'root';
      identityFile = null;
      proxyJump = null;
    }

    for (final rawLine in lines) {
      final line = rawLine.trim();
      if (line.isEmpty || line.startsWith('#')) continue;

      // Split on first whitespace or '='
      final match = RegExp(r'^(\S+)\s*[=\s]\s*(.+)$').firstMatch(line);
      if (match == null) continue;

      final key = match.group(1)!.toLowerCase();
      final value = match.group(2)!.trim();

      if (key == 'host') {
        flushEntry();
        // Skip wildcard patterns
        if (value.contains('*') || value.contains('?')) continue;
        currentHost = value;
      } else if (currentHost != null) {
        switch (key) {
          case 'hostname':
            hostname = value;
          case 'port':
            port = int.tryParse(value) ?? 22;
          case 'user':
            username = value;
          case 'identityfile':
            identityFile = value;
          case 'proxyjump':
            proxyJump = value;
        }
      }
    }
    flushEntry();

    _log.info(_tag, 'Parsed ${entries.length} host(s) from SSH config');
    return entries;
  }
}
