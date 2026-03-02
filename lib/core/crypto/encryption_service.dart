import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/crypto/encrypted_payload.dart';
import 'package:shellvault/core/crypto/export_envelope.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';

class EncryptionService {
  final Random _secureRandom = Random.secure();

  Uint8List _generateSecureBytes(int length) {
    return Uint8List.fromList(
      List.generate(length, (_) => _secureRandom.nextInt(256)),
    );
  }

  Uint8List _deriveKey(String password, Uint8List salt) {
    final argon2 = Argon2BytesGenerator();
    final params = Argon2Parameters(
      Argon2Parameters.ARGON2_id,
      salt,
      desiredKeyLength: AppConstants.aesKeyLength,
      iterations: AppConstants.argon2Iterations,
      memory: AppConstants.argon2MemoryKB,
      lanes: AppConstants.argon2Parallelism,
    );
    argon2.init(params);

    final key = Uint8List(AppConstants.aesKeyLength);
    argon2.deriveKey(Uint8List.fromList(utf8.encode(password)), 0, key, 0);
    return key;
  }

  String _sha256Hex(Uint8List data) {
    final digest = SHA256Digest();
    final hash = digest.process(data);
    return hash.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  EncryptedPayload _encrypt(Uint8List plaintext, Uint8List key) {
    final nonce = _generateSecureBytes(AppConstants.aesNonceLength);
    final cipher = GCMBlockCipher(AESEngine());
    cipher.init(
      true,
      AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)),
    );

    final output = Uint8List(cipher.getOutputSize(plaintext.length));
    final len = cipher.processBytes(plaintext, 0, plaintext.length, output, 0);
    cipher.doFinal(output, len);

    return EncryptedPayload(
      ciphertext: output,
      nonce: nonce,
      salt: Uint8List(0), // Salt managed at envelope level
    );
  }

  Uint8List _decrypt(Uint8List ciphertext, Uint8List key, Uint8List nonce) {
    final cipher = GCMBlockCipher(AESEngine());
    cipher.init(
      false,
      AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)),
    );

    final output = Uint8List(cipher.getOutputSize(ciphertext.length));
    final len = cipher.processBytes(
      ciphertext,
      0,
      ciphertext.length,
      output,
      0,
    );
    cipher.doFinal(output, len);

    return output;
  }

  Result<ExportEnvelope> encryptForExport(String jsonData, String password) {
    try {
      final salt = _generateSecureBytes(AppConstants.saltLength);
      final key = _deriveKey(password, salt);
      final plaintext = Uint8List.fromList(utf8.encode(jsonData));
      final checksum = _sha256Hex(plaintext);
      final payload = _encrypt(plaintext, key);

      return Success(
        ExportEnvelope(
          version: AppConstants.exportVersion,
          salt: base64Encode(salt),
          nonce: base64Encode(payload.nonce),
          encryptedData: base64Encode(payload.ciphertext),
          checksum: checksum,
        ),
      );
    } catch (e) {
      return Err(CryptoFailure('Encryption failed', cause: e));
    }
  }

  Result<String> decryptFromExport(ExportEnvelope envelope, String password) {
    try {
      final salt = envelope.saltBytes;
      final key = _deriveKey(password, salt);
      final plaintext = _decrypt(
        envelope.encryptedBytes,
        key,
        envelope.nonceBytes,
      );

      // Verify checksum
      final checksum = _sha256Hex(plaintext);
      if (checksum != envelope.checksum) {
        return const Err(
          CryptoFailure('Checksum verification failed — data may be corrupted'),
        );
      }

      return Success(utf8.decode(plaintext));
    } on ArgumentError {
      return const Err(
        CryptoFailure('Decryption failed — wrong password or corrupted data'),
      );
    } catch (e) {
      return Err(CryptoFailure('Decryption failed', cause: e));
    }
  }
}
