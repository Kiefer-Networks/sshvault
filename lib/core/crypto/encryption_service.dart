import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart' as crypto;
import 'package:pointycastle/export.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/crypto/encrypted_payload.dart';
import 'package:shellvault/core/crypto/export_envelope.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/services/logging_service.dart';

class EncryptionService {
  static final _log = LoggingService.instance;
  final Random _secureRandom = Random.secure();

  Uint8List _generateSecureBytes(int length) {
    return Uint8List.fromList(
      List.generate(length, (_) => _secureRandom.nextInt(256)),
    );
  }

  /// Derives an AES-256 key from [password] and [salt] using Argon2id.
  ///
  /// Uses the `cryptography` package which produces deterministic results
  /// regardless of parallelism setting (unlike pointycastle's implementation).
  Future<Uint8List> _deriveKey(String password, Uint8List salt) async {
    final argon2 = crypto.Argon2id(
      memory: AppConstants.argon2MemoryKB,
      iterations: AppConstants.argon2Iterations,
      parallelism: AppConstants.argon2Parallelism,
      hashLength: AppConstants.aesKeyLength,
    );

    final secretKey = await argon2.deriveKey(
      secretKey: crypto.SecretKey(utf8.encode(password)),
      nonce: salt,
    );

    final keyBytes = await secretKey.extractBytes();
    return Uint8List.fromList(keyBytes);
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
    final finalLen = cipher.doFinal(output, len);

    return EncryptedPayload(
      ciphertext: Uint8List.fromList(output.sublist(0, len + finalLen)),
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
    final finalLen = cipher.doFinal(output, len);

    return Uint8List.fromList(output.sublist(0, len + finalLen));
  }

  Future<Result<ExportEnvelope>> encryptForExport(
    String jsonData,
    String password,
  ) async {
    final sw = Stopwatch()..start();
    _log.info('Crypto', 'Encrypting data (${jsonData.length} chars)');

    try {
      final salt = _generateSecureBytes(AppConstants.saltLength);
      final key = await _deriveKey(password, salt);
      _log.debug('Crypto', 'Key derived in ${sw.elapsedMilliseconds}ms');

      final plaintext = Uint8List.fromList(utf8.encode(jsonData));
      final checksum = _sha256Hex(plaintext);
      final payload = _encrypt(plaintext, key);

      sw.stop();
      _log.info(
        'Crypto',
        'Encryption completed in ${sw.elapsedMilliseconds}ms '
            '(${plaintext.length} bytes → ${payload.ciphertext.length} bytes)',
      );

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
      sw.stop();
      _log.error(
        'Crypto',
        'Encryption failed after ${sw.elapsedMilliseconds}ms: $e',
      );
      return Err(CryptoFailure('Encryption failed', cause: e));
    }
  }

  Future<Result<String>> decryptFromExport(
    ExportEnvelope envelope,
    String password,
  ) async {
    final sw = Stopwatch()..start();
    _log.info(
      'Crypto',
      'Decrypting envelope v${envelope.version} '
          '(${envelope.encryptedData.length} chars base64)',
    );

    try {
      final salt = envelope.saltBytes;
      final key = await _deriveKey(password, salt);
      _log.debug('Crypto', 'Key derived in ${sw.elapsedMilliseconds}ms');

      final plaintext = _decrypt(
        envelope.encryptedBytes,
        key,
        envelope.nonceBytes,
      );
      _log.debug(
        'Crypto',
        'AES-GCM decrypt completed (${plaintext.length} bytes)',
      );

      // Verify checksum
      final checksum = _sha256Hex(plaintext);
      if (checksum != envelope.checksum) {
        sw.stop();
        _log.error(
          'Crypto',
          'Checksum mismatch after ${sw.elapsedMilliseconds}ms '
              '(expected ${envelope.checksum.substring(0, 8)}..., '
              'got ${checksum.substring(0, 8)}...)',
        );
        return const Err(
          CryptoFailure('Checksum verification failed — data may be corrupted'),
        );
      }

      sw.stop();
      _log.info(
        'Crypto',
        'Decryption completed in ${sw.elapsedMilliseconds}ms '
            '(${plaintext.length} bytes)',
      );
      return Success(utf8.decode(plaintext));
    } on ArgumentError catch (e) {
      sw.stop();
      _log.error(
        'Crypto',
        'Decryption failed (GCM auth tag mismatch) '
            'after ${sw.elapsedMilliseconds}ms: $e',
      );
      return const Err(
        CryptoFailure('Decryption failed — wrong password or corrupted data'),
      );
    } catch (e) {
      sw.stop();
      _log.error(
        'Crypto',
        'Decryption failed after ${sw.elapsedMilliseconds}ms: $e',
      );
      return Err(CryptoFailure('Decryption failed', cause: e));
    }
  }
}
