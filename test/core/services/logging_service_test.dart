import 'package:flutter_test/flutter_test.dart';
import 'package:shellvault/core/services/logging_service.dart';

void main() {
  late LoggingService sut;

  setUp(() {
    sut = LoggingService.instance;
    sut.clear();
  });

  group('LoggingService — ring buffer', () {
    test('starts empty', () {
      expect(sut.isEmpty, isTrue);
      expect(sut.length, 0);
      expect(sut.entries, isEmpty);
    });

    test('log adds an entry', () {
      sut.info('TEST', 'hello');
      expect(sut.length, 1);
      expect(sut.entries.first.message, 'hello');
      expect(sut.entries.first.tag, 'TEST');
      expect(sut.entries.first.level, LogLevel.info);
    });

    test('convenience methods set correct levels', () {
      sut.debug('T', 'debug msg');
      sut.info('T', 'info msg');
      sut.warning('T', 'warning msg');
      sut.error('T', 'error msg');

      expect(sut.entries[0].level, LogLevel.debug);
      expect(sut.entries[1].level, LogLevel.info);
      expect(sut.entries[2].level, LogLevel.warning);
      expect(sut.entries[3].level, LogLevel.error);
    });

    test('entries are ordered oldest first', () {
      sut.info('T', 'first');
      sut.info('T', 'second');
      sut.info('T', 'third');

      expect(sut.entries[0].message, 'first');
      expect(sut.entries[2].message, 'third');
    });

    test('ring buffer evicts oldest when exceeding maxEntries', () {
      for (var i = 0; i < LoggingService.maxEntries + 50; i++) {
        sut.info('T', 'msg $i');
      }
      expect(sut.length, LoggingService.maxEntries);
      // First entry should be #50 (oldest 50 were evicted)
      expect(sut.entries.first.message, 'msg 50');
    });

    test('clear removes all entries', () {
      sut.info('T', 'hello');
      sut.info('T', 'world');
      sut.clear();
      expect(sut.isEmpty, isTrue);
      expect(sut.length, 0);
    });

    test('entries list is unmodifiable', () {
      sut.info('T', 'hello');
      expect(
        () => sut.entries.add(
          LogEntry(
            timestamp: DateTime.now(),
            level: LogLevel.info,
            tag: 'T',
            message: 'injected',
          ),
        ),
        throwsUnsupportedError,
      );
    });
  });

  group('LogEntry', () {
    test('levelLabel returns uppercase level name', () {
      final entry = LogEntry(
        timestamp: DateTime.now(),
        level: LogLevel.warning,
        tag: 'T',
        message: 'test',
      );
      expect(entry.levelLabel, 'WARNING');
    });

    test('toString formats correctly', () {
      final ts = DateTime(2025, 3, 15, 10, 30, 0);
      final entry = LogEntry(
        timestamp: ts,
        level: LogLevel.error,
        tag: 'AUTH',
        message: 'login failed',
      );
      expect(
        entry.toString(),
        '[${ts.toIso8601String()}] [ERROR] [AUTH] login failed',
      );
    });
  });

  group('LoggingService — export', () {
    test('exportAsText returns empty string when buffer is empty', () {
      expect(sut.exportAsText(), isEmpty);
    });

    test('exportAsText contains header and entries', () {
      sut.info('NET', 'connected');
      sut.error('DB', 'query failed');

      final text = sut.exportAsText();
      expect(text, contains('=== SSH Vault Log Export ==='));
      expect(text, contains('Entries: 2'));
      expect(text, contains('[INFO] [NET] connected'));
      expect(text, contains('[ERROR] [DB] query failed'));
    });
  });

  group('LogSanitizer — password patterns', () {
    test('redacts password=value', () {
      expect(
        LogSanitizer.sanitize('password=secret123'),
        contains('password=[REDACTED]'),
      );
    });

    test('redacts Password: value (case-insensitive)', () {
      expect(
        LogSanitizer.sanitize('Password: mySecret'),
        contains('Password=[REDACTED]'),
      );
    });

    test('redacts passwd, pass, pwd variants', () {
      expect(LogSanitizer.sanitize('passwd=abc'), contains('[REDACTED]'));
      expect(LogSanitizer.sanitize('pwd=xyz'), contains('[REDACTED]'));
    });
  });

  group('LogSanitizer — token patterns', () {
    test('redacts token=value', () {
      expect(LogSanitizer.sanitize('token=abc123'), contains('[REDACTED]'));
    });

    test('redacts api_key=value', () {
      expect(
        LogSanitizer.sanitize('api_key=sk-test-abc'),
        contains('[REDACTED]'),
      );
    });

    test('redacts secret=value', () {
      expect(LogSanitizer.sanitize('secret=mysecret'), contains('[REDACTED]'));
    });
  });

  group('LogSanitizer — PEM blocks', () {
    test('redacts RSA private key blocks', () {
      const pem =
          '-----BEGIN RSA PRIVATE KEY-----\nMIIEow...\n-----END RSA PRIVATE KEY-----';
      final result = LogSanitizer.sanitize('Key: $pem');
      expect(result, contains('[REDACTED:PRIVATE_KEY]'));
      expect(result, isNot(contains('MIIEow')));
    });

    test('redacts OPENSSH PRIVATE KEY blocks', () {
      const pem =
          '-----BEGIN OPENSSH PRIVATE KEY-----\nb3Blbn...\n-----END OPENSSH PRIVATE KEY-----';
      final result = LogSanitizer.sanitize(pem);
      expect(result, contains('[REDACTED:PRIVATE_KEY]'));
    });

    test('redacts certificate blocks', () {
      const cert =
          '-----BEGIN CERTIFICATE-----\nMIIC...\n-----END CERTIFICATE-----';
      final result = LogSanitizer.sanitize(cert);
      expect(result, contains('[REDACTED:CERTIFICATE]'));
    });
  });

  group('LogSanitizer — IP addresses', () {
    test('redacts IPv4 addresses', () {
      final result = LogSanitizer.sanitize('Connected to 192.168.1.100:22');
      expect(result, contains('[REDACTED:IP]'));
      expect(result, isNot(contains('192.168.1.100')));
    });

    test('redacts IPv6 addresses', () {
      final result = LogSanitizer.sanitize(
        'Host: 2001:0db8:85a3:0000:0000:8a2e:0370:7334',
      );
      expect(result, contains('[REDACTED:IP]'));
    });
  });

  group('LogSanitizer — JWT tokens', () {
    test('redacts JWT tokens', () {
      // Note: "Token: jwt" matches the KV pattern first (token=...).
      // Use a non-KV context to test JWT-specific redaction.
      const jwt =
          'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.dozjgNryP4J3jVmNHl0w5N_XgL0n3I9PlFUP0THsR8U';
      final result = LogSanitizer.sanitize('Received $jwt in response');
      expect(result, contains('[REDACTED'));
      expect(result, isNot(contains('eyJhbGci')));
    });
  });

  group('LogSanitizer — email addresses', () {
    test('redacts email addresses', () {
      final result = LogSanitizer.sanitize('User: admin@example.com logged in');
      expect(result, contains('[REDACTED:EMAIL]'));
      expect(result, isNot(contains('admin@example.com')));
    });
  });

  group('LogSanitizer — base64 and hex', () {
    test('redacts long base64 strings', () {
      final b64 = 'A' * 40; // 40 chars of base64-like content
      final result = LogSanitizer.sanitize('Data: $b64');
      expect(result, contains('[REDACTED'));
    });

    test('redacts long hex strings (SHA-256 etc.)', () {
      // 64 hex chars also match the long base64 pattern (applied first),
      // so we just check it's redacted.
      final hex = 'a' * 64;
      final result = LogSanitizer.sanitize('Hash: $hex');
      expect(result, contains('[REDACTED'));
      expect(result, isNot(contains(hex)));
    });
  });

  group('LogSanitizer — authorization headers', () {
    test('redacts Authorization header', () {
      final result = LogSanitizer.sanitize('Authorization: Bearer abc123');
      expect(result, contains('Authorization: [REDACTED]'));
    });
  });

  group('LogSanitizer — passthrough', () {
    test('does not alter safe messages', () {
      const msg = 'Server connection established on port 22';
      expect(LogSanitizer.sanitize(msg), msg);
    });

    test('does not alter short strings', () {
      const msg = 'OK';
      expect(LogSanitizer.sanitize(msg), msg);
    });
  });

  group('LogSanitizer — pin and passphrase', () {
    test('redacts pin=value', () {
      expect(LogSanitizer.sanitize('pin=1234'), contains('[REDACTED]'));
    });

    test('redacts passphrase=value', () {
      expect(
        LogSanitizer.sanitize('passphrase=my secret phrase'),
        contains('[REDACTED]'),
      );
    });
  });

  group('LogSanitizer — SSH fingerprints', () {
    test('redacts SSH fingerprints', () {
      final result = LogSanitizer.sanitize(
        'SHA256:uNiVztksCsDhcc0u9e8BujQXVUpKZIDTMczCvj3tD2s',
      );
      expect(result, 'SHA256:[REDACTED]');
    });
  });

  group('LoggingService — sanitization integration', () {
    test('log messages are sanitized before storage', () {
      sut.info('AUTH', 'Login with password=mysecret');
      expect(sut.entries.first.message, contains('[REDACTED]'));
      expect(sut.entries.first.message, isNot(contains('mysecret')));
    });
  });
}
