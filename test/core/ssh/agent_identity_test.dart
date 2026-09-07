import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'external identity awaits signer and preserves the SSH signature blob',
    () async {
      final key = SSHAgentKeyPair(
        publicKey: Uint8List.fromList([0, 0, 0, 3, 114, 115, 97]),
        type: 'rsa-sha2-512',
        signer: (data) async {
          await Future<void>.delayed(Duration.zero);
          expect(data, [42, 43]);
          return Uint8List.fromList([0, 0, 0, 1, 99]);
        },
      );
      expect(await key.signAsync(Uint8List.fromList([42, 43])), [
        0,
        0,
        0,
        1,
        99,
      ]);
      expect(key.toPublicKey().encode(), [0, 0, 0, 3, 114, 115, 97]);
    },
  );
}
