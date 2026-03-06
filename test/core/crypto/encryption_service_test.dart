import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart' as crypto;
import 'package:flutter_test/flutter_test.dart';
import 'package:pointycastle/export.dart';
import 'package:sshvault/core/crypto/encryption_service.dart';
import 'package:sshvault/core/crypto/export_envelope.dart';

/// Build a v1 envelope (64 MiB Argon2id) for backward-compatibility testing.
Future<ExportEnvelope> _buildV1Envelope(
  String plaintext,
  String password,
) async {
  final rng = Random.secure();
  final salt = Uint8List.fromList(List.generate(32, (_) => rng.nextInt(256)));

  // v1 KDF: 64 MiB
  final argon2 = crypto.Argon2id(
    memory: 65536,
    iterations: 3,
    parallelism: 1,
    hashLength: 32,
  );
  final secretKey = await argon2.deriveKey(
    secretKey: crypto.SecretKey(utf8.encode(password)),
    nonce: salt,
  );
  final key = Uint8List.fromList(await secretKey.extractBytes());

  // Encrypt with AES-256-GCM
  final nonce = Uint8List.fromList(List.generate(12, (_) => rng.nextInt(256)));
  final plaintextBytes = Uint8List.fromList(utf8.encode(plaintext));
  final cipher = GCMBlockCipher(AESEngine());
  cipher.init(
    true,
    AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)),
  );
  final output = Uint8List(cipher.getOutputSize(plaintextBytes.length));
  final len = cipher.processBytes(
    plaintextBytes,
    0,
    plaintextBytes.length,
    output,
    0,
  );
  final finalLen = cipher.doFinal(output, len);
  final ciphertext = Uint8List.fromList(output.sublist(0, len + finalLen));

  // SHA-256 checksum
  final digest = SHA256Digest();
  final hash = digest.process(plaintextBytes);
  final checksum = hash.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

  return ExportEnvelope(
    version: 1,
    salt: base64Encode(salt),
    nonce: base64Encode(nonce),
    encryptedData: base64Encode(ciphertext),
    checksum: checksum,
  );
}

void main() {
  late EncryptionService sut;

  setUp(() {
    sut = EncryptionService();
  });

  group('EncryptionService', () {
    test('encryptForExport produces a valid envelope', () async {
      const password = 'test-password-123';
      const plaintext = '{"servers": []}';

      final result = await sut.encryptForExport(plaintext, password);
      expect(result.isSuccess, isTrue);

      final env = result.value;
      expect(env.version, equals(2));
      expect(env.salt, isNotEmpty);
      expect(env.nonce, isNotEmpty);
      expect(env.encryptedData, isNotEmpty);
      expect(env.checksum, isNotEmpty);
      expect(env.checksum.length, equals(64)); // SHA-256 hex
    });

    test('wrong password fails decryption', () async {
      const plaintext = 'secret data';
      final encrypted = await sut.encryptForExport(
        plaintext,
        'correct-password',
      );
      expect(encrypted.isSuccess, isTrue);

      final decrypted = await sut.decryptFromExport(
        encrypted.value,
        'wrong-password',
      );
      expect(decrypted.isFailure, isTrue);
    });

    test(
      'same plaintext produces different ciphertext (random nonce/salt)',
      () async {
        const password = 'password123';
        const plaintext = 'same-data';

        final enc1 = await sut.encryptForExport(plaintext, password);
        final enc2 = await sut.encryptForExport(plaintext, password);

        expect(enc1.isSuccess, isTrue);
        expect(enc2.isSuccess, isTrue);

        // Salts should differ (each call generates random salt)
        expect(enc1.value.salt, isNot(equals(enc2.value.salt)));
        // Nonces should differ
        expect(enc1.value.nonce, isNot(equals(enc2.value.nonce)));
        // Ciphertext should differ
        expect(
          enc1.value.encryptedData,
          isNot(equals(enc2.value.encryptedData)),
        );
      },
    );

    test('tampered checksum is detected on decryption', () async {
      const password = 'password123';
      final encrypted = await sut.encryptForExport('test data', password);
      expect(encrypted.isSuccess, isTrue);

      final env = encrypted.value;
      final tampered = ExportEnvelope(
        version: env.version,
        salt: env.salt,
        nonce: env.nonce,
        encryptedData: env.encryptedData,
        checksum: 'a' * 64, // Tampered checksum
      );

      final decrypted = await sut.decryptFromExport(tampered, password);
      // Either decryption itself fails or checksum verification fails
      expect(decrypted.isFailure, isTrue);
    });

    test('corrupted ciphertext fails decryption', () async {
      const password = 'password123';
      final encrypted = await sut.encryptForExport('test data', password);
      expect(encrypted.isSuccess, isTrue);

      final env = encrypted.value;
      final corrupted = ExportEnvelope(
        version: env.version,
        salt: env.salt,
        nonce: env.nonce,
        encryptedData: 'AAAA${env.encryptedData.substring(4)}', // Corrupt data
        checksum: env.checksum,
      );

      final decrypted = await sut.decryptFromExport(corrupted, password);
      expect(decrypted.isFailure, isTrue);
    });

    test('empty string produces valid envelope', () async {
      const password = 'password123';
      final result = await sut.encryptForExport('', password);
      expect(result.isSuccess, isTrue);
      expect(result.value.encryptedData, isNotEmpty);
    });

    test('large payload encryption succeeds', () async {
      const password = 'strongpassword';
      final plaintext = 'A' * 100000; // 100 KB

      final result = await sut.encryptForExport(plaintext, password);
      expect(result.isSuccess, isTrue);
      expect(result.value.encryptedData, isNotEmpty);
    });

    test('encrypt/decrypt round-trip preserves data', () async {
      const password = 'test-password-123';
      const plaintext = '{"servers": [{"name": "prod"}]}';

      final encrypted = await sut.encryptForExport(plaintext, password);
      expect(encrypted.isSuccess, isTrue);

      final decrypted = await sut.decryptFromExport(encrypted.value, password);
      expect(decrypted.isSuccess, isTrue);
      expect(decrypted.value, equals(plaintext));
    });
  });

  group('EncryptionService — v1 backward compatibility', () {
    test('decrypts v1 envelope (64 MiB Argon2id)', () async {
      const password = 'migration-test-pw';
      const plaintext = '{"servers": [{"name": "legacy"}]}';

      final v1Envelope = await _buildV1Envelope(plaintext, password);
      expect(v1Envelope.version, 1);

      final decrypted = await sut.decryptFromExport(v1Envelope, password);
      expect(decrypted.isSuccess, isTrue);
      expect(decrypted.value, equals(plaintext));
    });

    test('v1 envelope with wrong password still fails', () async {
      const plaintext = 'secret';

      final v1Envelope = await _buildV1Envelope(plaintext, 'correct-pw');
      final decrypted = await sut.decryptFromExport(v1Envelope, 'wrong-pw');
      expect(decrypted.isFailure, isTrue);
    });

    test('new encryption always produces v2 envelope', () async {
      const password = 'test';
      final result = await sut.encryptForExport('data', password);
      expect(result.isSuccess, isTrue);
      expect(result.value.version, 2);
    });

    test('v2 envelope cannot be decrypted with v1 KDF params', () async {
      const password = 'test-pw';
      const plaintext = 'v2 data';

      // Encrypt with current (v2) service
      final encrypted = await sut.encryptForExport(plaintext, password);
      expect(encrypted.isSuccess, isTrue);

      // Forge a v1 version tag on a v2-encrypted envelope
      final faked = ExportEnvelope(
        version: 1,
        salt: encrypted.value.salt,
        nonce: encrypted.value.nonce,
        encryptedData: encrypted.value.encryptedData,
        checksum: encrypted.value.checksum,
      );

      // v1 KDF (64 MiB) produces different key → decryption must fail
      final result = await sut.decryptFromExport(faked, password);
      expect(result.isFailure, isTrue);
    });
  });
}
