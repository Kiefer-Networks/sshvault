import 'package:flutter_test/flutter_test.dart';
import 'package:shellvault/core/crypto/encryption_service.dart';
import 'package:shellvault/core/crypto/export_envelope.dart';

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
      expect(env.version, equals(1));
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
}
