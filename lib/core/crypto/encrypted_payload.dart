import 'dart:typed_data';

class EncryptedPayload {
  final Uint8List ciphertext;
  final Uint8List nonce;
  final Uint8List salt;

  const EncryptedPayload({
    required this.ciphertext,
    required this.nonce,
    required this.salt,
  });
}
