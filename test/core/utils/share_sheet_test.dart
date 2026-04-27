// Tests for ShareSheet — verify we build the right ShareParams and write
// the temp `.pub` file with the OpenSSH single-line public key + comment.
//
// We never hit the real platform plugin: ShareSheet exposes
// `@visibleForTesting` hooks that swap the share invoker and the temp
// directory provider for in-memory recorders.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sshvault/core/crypto/ssh_key_type.dart';
import 'package:sshvault/core/utils/share_sheet.dart';
import 'package:sshvault/features/connection/domain/entities/ssh_key_entity.dart';

void main() {
  late Directory tmpRoot;
  late List<ShareParams> recorded;

  setUp(() {
    tmpRoot = Directory.systemTemp.createTempSync('sshvault_share_test_');
    recorded = [];
    ShareSheet.tempDirProvider = () async => tmpRoot;
    ShareSheet.shareInvoker = (params) async {
      recorded.add(params);
      return const ShareResult('mock', ShareResultStatus.success);
    };
  });

  tearDown(() {
    ShareSheet.resetForTesting();
    if (tmpRoot.existsSync()) tmpRoot.deleteSync(recursive: true);
  });

  SshKeyEntity makeKey({
    String name = 'work-laptop',
    String publicKey = 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample',
    String comment = 'me@host',
  }) {
    final now = DateTime(2026, 1, 1);
    return SshKeyEntity(
      id: 'k1',
      name: name,
      keyType: SshKeyType.ed25519,
      publicKey: publicKey,
      comment: comment,
      createdAt: now,
      updatedAt: now,
    );
  }

  group('sharePublicKey', () {
    test('writes OpenSSH line + comment to a .pub file in tempDir', () async {
      final key = makeKey();
      await ShareSheet.sharePublicKey(key);

      // One share invocation captured.
      expect(recorded.length, 1);
      final params = recorded.single;
      expect(params.subject, 'work-laptop');
      expect(params.files, isNotNull);
      expect(params.files!.length, 1);

      final xfile = params.files!.single;
      expect(xfile.path, endsWith('work-laptop.pub'));

      final body = await File(xfile.path).readAsString();
      // Trusts inline comment when present (token count >= 3) — the test
      // key only has 2 tokens so we should append `key.comment`.
      expect(
        body.trimRight(),
        'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample me@host',
      );
    });

    test(
      'keeps the existing inline comment if the public-key already has one',
      () async {
        final key = makeKey(
          publicKey:
              'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample inline@comment',
          comment: 'overridden@comment',
        );
        await ShareSheet.sharePublicKey(key);

        final body = await File(
          recorded.single.files!.single.path,
        ).readAsString();
        expect(body.trimRight().endsWith('inline@comment'), isTrue);
        expect(body.contains('overridden@comment'), isFalse);
      },
    );

    test(
      'sanitises the key name to avoid path traversal in the temp file',
      () async {
        final key = makeKey(name: '../../etc/passwd');
        await ShareSheet.sharePublicKey(key);

        final path = recorded.single.files!.single.path;
        // The basename should not contain any slashes; sanitiser folds them
        // to underscores.
        expect(path.split(Platform.pathSeparator).last, endsWith('.pub'));
        expect(path.split(Platform.pathSeparator).last.contains('/'), isFalse);
      },
    );

    test('no-ops silently when the key has no public material', () async {
      final key = makeKey(publicKey: '');
      await ShareSheet.sharePublicKey(key);
      expect(recorded, isEmpty);
    });
  });

  group('shareVaultExport', () {
    test('forwards the file path + basename through ShareParams', () async {
      final exportFile = File('${tmpRoot.path}/sshvault-export.json')
        ..writeAsStringSync('{}');

      await ShareSheet.shareVaultExport(exportFile);

      expect(recorded.length, 1);
      final params = recorded.single;
      expect(params.subject, 'sshvault-export.json');
      expect(params.files!.single.path, exportFile.path);
    });
  });
}
