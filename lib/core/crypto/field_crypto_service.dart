import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:shellvault/core/constants/app_constants.dart';

/// Encrypts/decrypts individual database field values using AES-256-GCM.
///
/// Encrypted format: `v1:<nonce_base64>:<ciphertext_base64>`
/// The `v1:` prefix identifies already-encrypted fields.
class FieldCryptoService {
  final Uint8List _dek;
  final Random _secureRandom = Random.secure();

  static const _prefix = 'v1:';

  FieldCryptoService(this._dek) : assert(_dek.length == AppConstants.aesKeyLength);

  Uint8List _generateNonce() {
    return Uint8List.fromList(
      List.generate(AppConstants.aesNonceLength, (_) => _secureRandom.nextInt(256)),
    );
  }

  /// Encrypts a plaintext string. Returns the `v1:nonce:ciphertext` format.
  /// Returns the original value if null or empty.
  String encryptField(String plaintext) {
    if (plaintext.isEmpty) return plaintext;

    final nonce = _generateNonce();
    final cipher = GCMBlockCipher(AESEngine());
    cipher.init(
      true,
      AEADParameters(KeyParameter(_dek), 128, nonce, Uint8List(0)),
    );

    final input = Uint8List.fromList(utf8.encode(plaintext));
    final output = Uint8List(cipher.getOutputSize(input.length));
    final len = cipher.processBytes(input, 0, input.length, output, 0);
    cipher.doFinal(output, len);

    return '$_prefix${base64Encode(nonce)}:${base64Encode(output)}';
  }

  /// Decrypts a field value. If the value doesn't start with `v1:`, it's
  /// returned as-is (plaintext passthrough for unencrypted data).
  String decryptField(String value) {
    if (value.isEmpty || !value.startsWith(_prefix)) return value;

    final parts = value.substring(_prefix.length).split(':');
    if (parts.length != 2) return value;

    final nonce = base64Decode(parts[0]);
    final ciphertext = base64Decode(parts[1]);

    final cipher = GCMBlockCipher(AESEngine());
    cipher.init(
      false,
      AEADParameters(KeyParameter(_dek), 128, nonce, Uint8List(0)),
    );

    final output = Uint8List(cipher.getOutputSize(ciphertext.length));
    final len = cipher.processBytes(ciphertext, 0, ciphertext.length, output, 0);
    cipher.doFinal(output, len);

    return utf8.decode(output);
  }

  /// Encrypts a nullable field. Returns null if input is null.
  String? encryptNullableField(String? value) {
    if (value == null) return null;
    return encryptField(value);
  }

  /// Decrypts a nullable field. Returns null if input is null.
  String? decryptNullableField(String? value) {
    if (value == null) return null;
    return decryptField(value);
  }

  /// Returns true if the value appears to be encrypted (has `v1:` prefix).
  static bool isEncrypted(String? value) {
    return value != null && value.startsWith(_prefix);
  }
}
