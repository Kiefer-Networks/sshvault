// Tests for the Linux drag-and-drop file import bridge.
//
// We exercise the classifier directly (it's a pure function on file content)
// and the high-level dispatcher via a test hook (`onDropForTest`) that
// captures the [ClassifiedDrop] without needing a real Navigator/MaterialApp.
//
// The MethodChannel side is platform-specific and is verified by the
// integration build, not these unit tests.

import 'package:flutter_test/flutter_test.dart';
import 'package:sshvault/core/services/file_drop_service.dart';

void main() {
  group('FileDropService.classifyContent', () {
    test('detects OpenSSH private key', () {
      const body = '''
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
-----END OPENSSH PRIVATE KEY-----
''';
      expect(FileDropService.classifyContent(body), DroppedFileKind.privateKey);
    });

    test('detects RSA private key', () {
      const body = '''
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA...
-----END RSA PRIVATE KEY-----
''';
      expect(FileDropService.classifyContent(body), DroppedFileKind.privateKey);
    });

    test('detects EC private key', () {
      const body = '''
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEIPQbJk6EQ...
-----END EC PRIVATE KEY-----
''';
      expect(FileDropService.classifyContent(body), DroppedFileKind.privateKey);
    });

    test('detects ssh-ed25519 public key', () {
      const body =
          'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB malte@kiefer.example\n';
      expect(FileDropService.classifyContent(body), DroppedFileKind.publicKey);
    });

    test('detects ssh-rsa public key', () {
      const body = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAB user@host\n';
      expect(FileDropService.classifyContent(body), DroppedFileKind.publicKey);
    });

    test('detects ecdsa-sha2-nistp256 public key', () {
      const body =
          'ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTY user@host\n';
      expect(FileDropService.classifyContent(body), DroppedFileKind.publicKey);
    });

    test('detects vault export JSON via magic key', () {
      const body = '{"sshvault_export_v1": {"servers": []}}';
      expect(
        FileDropService.classifyContent(body),
        DroppedFileKind.vaultExportJson,
      );
    });

    test('rejects malformed JSON even with the magic substring', () {
      // The magic appears as a substring but the document is not parseable.
      const body = '{"sshvault_export_v1": [oops not json}';
      expect(
        FileDropService.classifyContent(body),
        isNot(DroppedFileKind.vaultExportJson),
      );
    });

    test('detects ssh_config starting with Host', () {
      const body = '''
Host bastion
  HostName bastion.example.com
  User malte
  IdentityFile ~/.ssh/id_ed25519
''';
      expect(FileDropService.classifyContent(body), DroppedFileKind.sshConfig);
    });

    test('detects ssh_config with ServerAliveInterval', () {
      const body = '''
ServerAliveInterval 30
ServerAliveCountMax 3
''';
      expect(FileDropService.classifyContent(body), DroppedFileKind.sshConfig);
    });

    test('returns unsupported for random text', () {
      const body = 'just a random log line\nwith nothing interesting';
      expect(
        FileDropService.classifyContent(body),
        DroppedFileKind.unsupported,
      );
    });
  });

  group('FileDropService.handleDroppedPaths', () {
    late FileDropService sut;
    late List<ClassifiedDrop> captured;

    setUp(() {
      sut = FileDropService.instance;
      sut.resetForTest();
      captured = [];
      sut.onDropForTest = captured.add;
    });

    tearDown(() {
      sut.resetForTest();
    });

    Future<void> withFakeFiles(Map<String, String> files) async {
      sut.readFile = (path) async => files[path];
    }

    test('routes a private key drop to the SSH-key import flow', () async {
      await withFakeFiles({
        '/home/user/.ssh/id_ed25519': '''
-----BEGIN OPENSSH PRIVATE KEY-----
abc
-----END OPENSSH PRIVATE KEY-----
''',
      });

      await sut.handleDroppedPaths(['/home/user/.ssh/id_ed25519']);

      expect(captured, hasLength(1));
      expect(captured.single.kind, DroppedFileKind.privateKey);
      expect(captured.single.path, '/home/user/.ssh/id_ed25519');
    });

    test('routes a public key drop to the SSH-key import flow', () async {
      await withFakeFiles({
        '/tmp/id_rsa.pub': 'ssh-rsa AAAAB3NzaC1 user@host\n',
      });

      await sut.handleDroppedPaths(['/tmp/id_rsa.pub']);

      expect(captured.single.kind, DroppedFileKind.publicKey);
    });

    test('routes a vault export drop to the export/import flow', () async {
      await withFakeFiles({
        '/tmp/backup.json':
            '{"sshvault_export_v1": {"servers": [], "snippets": []}}',
      });

      await sut.handleDroppedPaths(['/tmp/backup.json']);

      expect(captured.single.kind, DroppedFileKind.vaultExportJson);
    });

    test('routes an ssh_config drop to the ssh-config import screen', () async {
      await withFakeFiles({
        '/etc/ssh/ssh_config':
            'Host *\n  ServerAliveInterval 60\n  IdentityFile ~/.ssh/id\n',
      });

      await sut.handleDroppedPaths(['/etc/ssh/ssh_config']);

      expect(captured.single.kind, DroppedFileKind.sshConfig);
    });

    test('drops only the first supported file when many are dropped', () async {
      await withFakeFiles({
        '/a': 'random text only',
        '/b': 'ssh-ed25519 AAA user@host',
        '/c': '''
-----BEGIN OPENSSH PRIVATE KEY-----
xxx
-----END OPENSSH PRIVATE KEY-----
''',
      });

      await sut.handleDroppedPaths(['/a', '/b', '/c']);

      // Two supported (b, c), but only the first one drives a navigation.
      expect(captured, hasLength(1));
      expect(captured.single.kind, DroppedFileKind.publicKey);
      expect(captured.single.path, '/b');
    });

    test('ignores unreadable / oversized files', () async {
      sut.readFile = (path) async => null; // simulate read rejection

      await sut.handleDroppedPaths(['/tmp/huge.bin']);

      expect(captured, isEmpty);
    });

    test('does nothing for an empty path list', () async {
      await sut.handleDroppedPaths(const []);
      expect(captured, isEmpty);
    });
  });
}
