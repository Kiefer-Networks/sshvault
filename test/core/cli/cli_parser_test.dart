// Pure-Dart parser test. We import `flutter_test` rather than `test` so the
// file fits the project's existing test layout (single `flutter test`
// invocation runs every test under `test/`); `flutter_test` re-exports the
// `test` package's `group`/`test`/`expect` so no Flutter binding is touched
// here.
import 'package:flutter_test/flutter_test.dart';
import 'package:sshvault/core/cli/cli_parser.dart';

void main() {
  group('CliParser.parse', () {
    test('no args → gui, no positional, not minimized', () {
      final r = CliParser.parse(const <String>[]);
      expect(r.kind, CliInvocationKind.gui);
      expect(r.minimized, isFalse);
      expect(r.hasPositional, isFalse);
      expect(r.remoteCommand, isEmpty);
      expect(r.usage, contains('Usage:'));
    });

    test('--minimized', () {
      final r = CliParser.parse(const ['--minimized']);
      expect(r.kind, CliInvocationKind.gui);
      expect(r.minimized, isTrue);
    });

    test('--version → version kind', () {
      final r = CliParser.parse(const ['--version']);
      expect(r.kind, CliInvocationKind.version);
    });

    test('-v alias for version', () {
      final r = CliParser.parse(const ['-v']);
      expect(r.kind, CliInvocationKind.version);
    });

    test('--help → help kind', () {
      final r = CliParser.parse(const ['--help']);
      expect(r.kind, CliInvocationKind.help);
    });

    test('-h alias for help', () {
      final r = CliParser.parse(const ['-h']);
      expect(r.kind, CliInvocationKind.help);
    });

    test('--quit → quit kind', () {
      final r = CliParser.parse(const ['--quit']);
      expect(r.kind, CliInvocationKind.quit);
    });

    test('--list-hosts → listHosts kind', () {
      final r = CliParser.parse(const ['--list-hosts']);
      expect(r.kind, CliInvocationKind.listHosts);
    });

    test('--import-config PATH', () {
      final r = CliParser.parse(const ['--import-config', '/tmp/ssh_config']);
      expect(r.kind, CliInvocationKind.gui);
      expect(r.importConfigPath, '/tmp/ssh_config');
    });

    test('--import-config=PATH (=-form)', () {
      final r = CliParser.parse(const ['--import-config=/tmp/ssh_config']);
      expect(r.kind, CliInvocationKind.gui);
      expect(r.importConfigPath, '/tmp/ssh_config');
    });

    test('--import-keys DIR', () {
      final r = CliParser.parse(const ['--import-keys', '/home/u/.ssh']);
      expect(r.kind, CliInvocationKind.gui);
      expect(r.importKeysDir, '/home/u/.ssh');
    });

    test('--export-vault PATH → exportVault kind', () {
      final r = CliParser.parse(const ['--export-vault', '/tmp/out.json']);
      expect(r.kind, CliInvocationKind.exportVault);
      expect(r.exportVaultPath, '/tmp/out.json');
    });

    test('positional HOSTNAME', () {
      final r = CliParser.parse(const ['prod-db-01']);
      expect(r.kind, CliInvocationKind.gui);
      expect(r.hostNameMatch, 'prod-db-01');
      expect(r.quickConnect, isNull);
      expect(r.sshUrl, isNull);
    });

    test('positional user@host', () {
      final r = CliParser.parse(const ['alice@example.com']);
      expect(r.kind, CliInvocationKind.gui);
      expect(r.quickConnect, isNotNull);
      expect(r.quickConnect!.username, 'alice');
      expect(r.quickConnect!.hostname, 'example.com');
      expect(r.quickConnect!.port, 22);
    });

    test('positional user@host:port', () {
      final r = CliParser.parse(const ['root@10.0.0.1:2222']);
      expect(r.kind, CliInvocationKind.gui);
      expect(r.quickConnect, isNotNull);
      expect(r.quickConnect!.username, 'root');
      expect(r.quickConnect!.hostname, '10.0.0.1');
      expect(r.quickConnect!.port, 2222);
    });

    test('positional user@[ipv6]:port', () {
      final r = CliParser.parse(const ['ops@[fe80::1]:2200']);
      expect(r.kind, CliInvocationKind.gui);
      expect(r.quickConnect!.hostname, 'fe80::1');
      expect(r.quickConnect!.port, 2200);
    });

    test('positional ssh:// URL', () {
      final r = CliParser.parse(const ['ssh://alice@example.com:2222']);
      expect(r.kind, CliInvocationKind.gui);
      expect(r.sshUrl, 'ssh://alice@example.com:2222');
      expect(r.hostNameMatch, isNull);
    });

    test('positional sftp:// URL', () {
      final r = CliParser.parse(const ['sftp://example.com/etc']);
      expect(r.sshUrl, 'sftp://example.com/etc');
    });

    test('"--" separates remote command', () {
      final r = CliParser.parse(const [
        'prod',
        '--',
        'tail',
        '-f',
        '/v/log/syslog',
      ]);
      expect(r.kind, CliInvocationKind.gui);
      expect(r.hostNameMatch, 'prod');
      expect(r.remoteCommand, ['tail', '-f', '/v/log/syslog']);
    });

    test('"--" with flags works', () {
      final r = CliParser.parse(const ['--minimized', 'host1', '--', 'uptime']);
      expect(r.kind, CliInvocationKind.gui);
      expect(r.minimized, isTrue);
      expect(r.hostNameMatch, 'host1');
      expect(r.remoteCommand, ['uptime']);
    });

    test('"--" alone with no command is fine', () {
      final r = CliParser.parse(const ['host1', '--']);
      expect(r.kind, CliInvocationKind.gui);
      expect(r.hostNameMatch, 'host1');
      expect(r.remoteCommand, isEmpty);
    });

    test('--import-config + positional HOSTNAME is allowed', () {
      final r = CliParser.parse(const [
        '--import-config',
        '/tmp/ssh_config',
        'prod-db-01',
      ]);
      expect(r.kind, CliInvocationKind.gui);
      expect(r.importConfigPath, '/tmp/ssh_config');
      expect(r.hostNameMatch, 'prod-db-01');
    });

    group('errors', () {
      test('--version with --quit conflicts', () {
        final r = CliParser.parse(const ['--version', '--quit']);
        expect(r.kind, CliInvocationKind.error);
        expect(r.errorMessage, contains('Conflicting flags'));
      });

      test('--export-vault with --help conflicts', () {
        final r = CliParser.parse(const ['--help', '--export-vault', '/tmp/x']);
        expect(r.kind, CliInvocationKind.error);
      });

      test('--quit with positional fails', () {
        final r = CliParser.parse(const ['--quit', 'host']);
        expect(r.kind, CliInvocationKind.error);
        expect(r.errorMessage, contains('does not accept a positional'));
      });

      test('--version with -- remote command fails', () {
        final r = CliParser.parse(const ['--version', '--', 'echo']);
        expect(r.kind, CliInvocationKind.error);
      });

      test('two positionals fail', () {
        final r = CliParser.parse(const ['host1', 'host2']);
        expect(r.kind, CliInvocationKind.error);
        expect(r.errorMessage, contains('At most one positional'));
      });

      test('--import-config with empty value fails', () {
        final r = CliParser.parse(const ['--import-config', '']);
        expect(r.kind, CliInvocationKind.error);
        expect(r.errorMessage, contains('--import-config'));
      });

      test('--export-vault with empty value fails', () {
        final r = CliParser.parse(const ['--export-vault', '   ']);
        expect(r.kind, CliInvocationKind.error);
      });

      test('unknown flag fails', () {
        final r = CliParser.parse(const ['--no-such-flag']);
        expect(r.kind, CliInvocationKind.error);
      });

      test('user@ with empty host fails', () {
        final r = CliParser.parse(const ['alice@']);
        expect(r.kind, CliInvocationKind.error);
        expect(r.errorMessage, contains('user@host'));
      });

      test('@host with empty user fails', () {
        final r = CliParser.parse(const ['@host']);
        expect(r.kind, CliInvocationKind.error);
      });

      test('user@host:invalidport fails', () {
        final r = CliParser.parse(const ['alice@host:abc']);
        expect(r.kind, CliInvocationKind.error);
      });

      test('user@host:0 fails (out of range)', () {
        final r = CliParser.parse(const ['alice@host:0']);
        expect(r.kind, CliInvocationKind.error);
      });

      test('user@host:99999 fails (out of range)', () {
        final r = CliParser.parse(const ['alice@host:99999']);
        expect(r.kind, CliInvocationKind.error);
      });

      test('HOSTNAME with whitespace fails', () {
        final r = CliParser.parse(const ['bad hostname']);
        expect(r.kind, CliInvocationKind.error);
      });

      test('HOSTNAME starting with - fails', () {
        // `args` would treat this as an unknown flag — also an error.
        final r = CliParser.parse(const ['-bogus']);
        expect(r.kind, CliInvocationKind.error);
      });
    });

    test('hasPositional reflects state', () {
      expect(CliParser.parse(const []).hasPositional, isFalse);
      expect(CliParser.parse(const ['hostX']).hasPositional, isTrue);
      expect(CliParser.parse(const ['u@h']).hasPositional, isTrue);
      expect(CliParser.parse(const ['ssh://h']).hasPositional, isTrue);
    });

    test('usage string mentions every public flag', () {
      final r = CliParser.parse(const ['--help']);
      expect(r.usage, contains('--help'));
      expect(r.usage, contains('--version'));
      expect(r.usage, contains('--minimized'));
      expect(r.usage, contains('--quit'));
      expect(r.usage, contains('--import-config'));
      expect(r.usage, contains('--import-keys'));
      expect(r.usage, contains('--export-vault'));
      // --list-hosts is hidden, but the long-form usage still works.
      expect(r.usage.contains('--list-hosts'), isFalse);
    });
  });
}
