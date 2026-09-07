import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:sshvault/core/ssh/host_key_fingerprint.dart';

void main() {
  test('OpenSSH fingerprint resolves to the same stored raw digest', () {
    final wire = Uint8List.fromList(
      utf8.encode('SHA256:AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'),
    );
    expect(hostKeyDigest(wire), List<int>.filled(32, 0));
    expect(hostKeyDigest(Uint8List(32)), List<int>.filled(32, 0));
  });
  test('rejects malformed or unsupported fingerprints', () {
    expect(
      () => hostKeyDigest(Uint8List.fromList(utf8.encode('MD5:bad'))),
      throwsFormatException,
    );
  });
}
