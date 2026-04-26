import 'package:flutter_test/flutter_test.dart';
import 'package:sshvault/core/utils/ssh_url_parser.dart';

void main() {
  group('SshUrl.parse', () {
    test('ssh://user@host', () {
      final url = SshUrl.parse('ssh://alice@example.com');
      expect(url, isNotNull);
      expect(url!.scheme, 'ssh');
      expect(url.username, 'alice');
      expect(url.hostname, 'example.com');
      expect(url.port, 22);
      expect(url.path, isNull);
      expect(url.isSftp, isFalse);
    });

    test('ssh://host (no user, no port)', () {
      final url = SshUrl.parse('ssh://example.com');
      expect(url, isNotNull);
      expect(url!.username, isNull);
      expect(url.hostname, 'example.com');
      expect(url.port, 22);
    });

    test('ssh://host:port', () {
      final url = SshUrl.parse('ssh://example.com:2222');
      expect(url, isNotNull);
      expect(url!.username, isNull);
      expect(url.hostname, 'example.com');
      expect(url.port, 2222);
    });

    test('ssh://user@host:port', () {
      final url = SshUrl.parse('ssh://bob@10.0.0.5:2200');
      expect(url, isNotNull);
      expect(url!.scheme, 'ssh');
      expect(url.username, 'bob');
      expect(url.hostname, '10.0.0.5');
      expect(url.port, 2200);
    });

    test('sftp://...', () {
      final url = SshUrl.parse('sftp://carol@files.example.com:2022');
      expect(url, isNotNull);
      expect(url!.scheme, 'sftp');
      expect(url.isSftp, isTrue);
      expect(url.username, 'carol');
      expect(url.hostname, 'files.example.com');
      expect(url.port, 2022);
    });

    test('with path component', () {
      final url = SshUrl.parse('sftp://dave@host.example/var/log');
      expect(url, isNotNull);
      expect(url!.path, 'var/log');
      expect(url.hostname, 'host.example');
    });

    test('IPv6 in brackets', () {
      final url = SshUrl.parse('ssh://eve@[2001:db8::1]:2200');
      expect(url, isNotNull);
      expect(url!.username, 'eve');
      expect(url.hostname, '2001:db8::1');
      expect(url.port, 2200);
    });

    test('IPv6 without brackets is rejected by Uri.parse semantics', () {
      // Without brackets the `:` becomes the port separator, so the URL is
      // structurally invalid — Uri.parse cannot pull a host out of it.
      final url = SshUrl.parse('ssh://2001:db8::1');
      expect(url, isNull);
    });

    test('case-insensitive scheme', () {
      expect(SshUrl.parse('SSH://example.com')?.scheme, 'ssh');
      expect(SshUrl.parse('Sftp://example.com')?.scheme, 'sftp');
    });

    test('default port is 22 for sftp too', () {
      expect(SshUrl.parse('sftp://example.com')?.port, 22);
    });

    test('rejects unsupported schemes', () {
      expect(SshUrl.parse('http://example.com'), isNull);
      expect(SshUrl.parse('telnet://example.com'), isNull);
      expect(SshUrl.parse('mosh://example.com'), isNull);
    });

    test('rejects malformed input', () {
      expect(SshUrl.parse('not a url'), isNull);
      expect(SshUrl.parse('ssh://'), isNull);
      expect(SshUrl.parse('ssh:/'), isNull);
      expect(SshUrl.parse('://example.com'), isNull);
      expect(SshUrl.parse('ssh//example.com'), isNull);
    });

    test('rejects empty / whitespace input', () {
      expect(SshUrl.parse(''), isNull);
      expect(SshUrl.parse('   '), isNull);
    });

    test('rejects port 0 and out-of-range', () {
      expect(SshUrl.parse('ssh://example.com:0'), isNull);
      expect(SshUrl.parse('ssh://example.com:65536'), isNull);
    });

    test('rejects empty username (ssh://@host)', () {
      expect(SshUrl.parse('ssh://@example.com'), isNull);
    });

    test('strips password half from userinfo', () {
      // We do not accept passwords; only the user is kept.
      final url = SshUrl.parse('ssh://alice:secret@example.com');
      expect(url, isNotNull);
      expect(url!.username, 'alice');
    });

    test('rejects invalid IPv4', () {
      expect(SshUrl.parse('ssh://999.1.1.1'), isNull);
      expect(SshUrl.parse('ssh://1.2.3.4.5'), isNull);
    });
  });
}
