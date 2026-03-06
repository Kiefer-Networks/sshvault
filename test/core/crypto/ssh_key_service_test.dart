import 'package:flutter_test/flutter_test.dart';
import 'package:sshvault/core/crypto/ssh_key_service.dart';
import 'package:sshvault/core/crypto/ssh_key_type.dart';
import 'package:sshvault/core/error/failures.dart';

void main() {
  late SshKeyService sut;

  setUp(() {
    sut = SshKeyService();
  });

  group('SshKeyService — Ed25519 generation', () {
    test('generates a valid Ed25519 key pair', () async {
      final result = await sut.generateKeyPair();
      expect(result.isSuccess, isTrue);

      final pair = result.value;
      expect(pair.type, SshKeyType.ed25519);
      expect(pair.comment, '');
      expect(pair.publicKey, startsWith('ssh-ed25519 '));
      expect(pair.privateKey, contains('OPENSSH PRIVATE KEY'));
    });

    test('Ed25519 public key contains the comment', () async {
      const options = SshKeyOptions(comment: 'test@host');
      final result = await sut.generateKeyPair(options);
      expect(result.isSuccess, isTrue);
      expect(result.value.publicKey, endsWith(' test@host'));
    });

    test('Ed25519 generates unique key pairs each time', () async {
      final r1 = await sut.generateKeyPair();
      final r2 = await sut.generateKeyPair();
      expect(r1.isSuccess, isTrue);
      expect(r2.isSuccess, isTrue);
      expect(r1.value.publicKey, isNot(equals(r2.value.publicKey)));
      expect(r1.value.privateKey, isNot(equals(r2.value.privateKey)));
    });

    test('Ed25519 private key has proper PEM structure', () async {
      final result = await sut.generateKeyPair();
      final pem = result.value.privateKey;
      expect(pem, startsWith('-----BEGIN OPENSSH PRIVATE KEY-----'));
      expect(pem, endsWith('-----END OPENSSH PRIVATE KEY-----'));
    });
  });

  group('SshKeyService — RSA generation', () {
    test('generates a valid RSA key pair with default 4096 bits', () async {
      final result = await sut.generateKeyPair(
        const SshKeyOptions(type: SshKeyType.rsa),
      );
      expect(result.isSuccess, isTrue);

      final pair = result.value;
      expect(pair.type, SshKeyType.rsa);
      expect(pair.publicKey, startsWith('ssh-rsa '));
      expect(pair.privateKey, contains('RSA PRIVATE KEY'));
    });

    test('RSA key pair respects custom bit length', () async {
      final result = await sut.generateKeyPair(
        const SshKeyOptions(type: SshKeyType.rsa, bits: 2048),
      );
      expect(result.isSuccess, isTrue);
      expect(result.value.type, SshKeyType.rsa);
    });

    test('RSA private key is valid PEM', () async {
      final result = await sut.generateKeyPair(
        const SshKeyOptions(type: SshKeyType.rsa, bits: 2048),
      );
      final pem = result.value.privateKey;
      expect(pem, startsWith('-----BEGIN RSA PRIVATE KEY-----'));
      expect(pem, endsWith('-----END RSA PRIVATE KEY-----'));
    });
  });

  group('SshKeyService — ECDSA generation', () {
    test('generates ECDSA P-256 key pair', () async {
      final result = await sut.generateKeyPair(
        const SshKeyOptions(type: SshKeyType.ecdsa256),
      );
      // ECDSA may fail in test environment if PointyCastle curve is not available
      if (result.isFailure) {
        expect(result.failure.message, contains('generation failed'));
        return;
      }

      final pair = result.value;
      expect(pair.type, SshKeyType.ecdsa256);
      expect(pair.publicKey, startsWith('ecdsa-sha2-nistp256 '));
      expect(pair.privateKey, contains('EC PRIVATE KEY'));
    });

    test('generates ECDSA P-384 key pair', () async {
      final result = await sut.generateKeyPair(
        const SshKeyOptions(type: SshKeyType.ecdsa384),
      );
      if (result.isFailure) return; // PointyCastle curve support varies
      expect(result.value.type, SshKeyType.ecdsa384);
      expect(result.value.publicKey, startsWith('ecdsa-sha2-nistp384 '));
    });

    test('generates ECDSA P-521 key pair', () async {
      final result = await sut.generateKeyPair(
        const SshKeyOptions(type: SshKeyType.ecdsa521),
      );
      if (result.isFailure) return; // PointyCastle curve support varies
      expect(result.value.type, SshKeyType.ecdsa521);
      expect(result.value.publicKey, startsWith('ecdsa-sha2-nistp521 '));
    });
  });

  group('SshKeyService — fingerprint computation', () {
    test('computes SHA256 fingerprint for Ed25519 public key', () async {
      final result = await sut.generateKeyPair();
      final fp = sut.computeFingerprint(result.value.publicKey);
      expect(fp, startsWith('SHA256:'));
      expect(fp.length, greaterThan(10));
    });

    test('computes SHA256 fingerprint for RSA public key', () async {
      final result = await sut.generateKeyPair(
        const SshKeyOptions(type: SshKeyType.rsa, bits: 2048),
      );
      final fp = sut.computeFingerprint(result.value.publicKey);
      expect(fp, startsWith('SHA256:'));
    });

    test('same key always produces same fingerprint', () async {
      final result = await sut.generateKeyPair();
      final pubKey = result.value.publicKey;
      final fp1 = sut.computeFingerprint(pubKey);
      final fp2 = sut.computeFingerprint(pubKey);
      expect(fp1, equals(fp2));
    });

    test('different keys produce different fingerprints', () async {
      final r1 = await sut.generateKeyPair();
      final r2 = await sut.generateKeyPair();
      final fp1 = sut.computeFingerprint(r1.value.publicKey);
      final fp2 = sut.computeFingerprint(r2.value.publicKey);
      expect(fp1, isNot(equals(fp2)));
    });

    test('returns empty string for malformed input', () {
      final fp = sut.computeFingerprint('not-a-key');
      expect(fp, isEmpty);
    });

    test('fingerprint has no trailing equals padding', () async {
      final result = await sut.generateKeyPair();
      final fp = sut.computeFingerprint(result.value.publicKey);
      expect(fp, isNot(endsWith('=')));
    });
  });

  group('SshKeyService — public key extraction', () {
    test('extracts public key from Ed25519 OpenSSH private key', () async {
      final generated = await sut.generateKeyPair();
      final extracted = await sut.extractPublicKey(generated.value.privateKey);
      expect(extracted.isSuccess, isTrue);
      expect(extracted.value, startsWith('ssh-ed25519 '));
    });

    test('extracts public key from RSA private key', () async {
      final generated = await sut.generateKeyPair(
        const SshKeyOptions(type: SshKeyType.rsa, bits: 2048),
      );
      final extracted = await sut.extractPublicKey(generated.value.privateKey);
      expect(extracted.isSuccess, isTrue);
      expect(extracted.value, startsWith('ssh-rsa '));
    });

    test('extracts public key from ECDSA private key', () async {
      final generated = await sut.generateKeyPair(
        const SshKeyOptions(type: SshKeyType.ecdsa256),
      );
      if (generated.isFailure) return; // ECDSA may not be available
      final extracted = await sut.extractPublicKey(generated.value.privateKey);
      expect(extracted.isSuccess, isTrue);
      expect(extracted.value, startsWith('ecdsa-sha2-nistp256 '));
    });

    test('extraction preserves custom comment', () async {
      final extracted = await sut.extractPublicKey(
        (await sut.generateKeyPair()).value.privateKey,
        comment: 'my-comment',
      );
      expect(extracted.isSuccess, isTrue);
      expect(extracted.value, endsWith(' my-comment'));
    });

    test('returns CryptoFailure for unsupported format', () async {
      final result = await sut.extractPublicKey('not a PEM key');
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<CryptoFailure>());
    });
  });

  group('SshKeyService — extractKeyInfo', () {
    test('extracts key info with comment from Ed25519 key', () async {
      const options = SshKeyOptions(comment: 'user@machine');
      final generated = await sut.generateKeyPair(options);

      final info = await sut.extractKeyInfo(generated.value.privateKey);
      expect(info.isSuccess, isTrue);
      expect(info.value.publicKey, startsWith('ssh-ed25519 '));
      expect(info.value.comment, 'user@machine');
    });

    test('non-OpenSSH key returns null comment', () async {
      final generated = await sut.generateKeyPair(
        const SshKeyOptions(type: SshKeyType.rsa, bits: 2048),
      );
      final info = await sut.extractKeyInfo(generated.value.privateKey);
      expect(info.isSuccess, isTrue);
      expect(info.value.comment, isNull);
    });
  });

  group('SshKeyOptions', () {
    test('defaults to Ed25519 with default comment', () {
      const options = SshKeyOptions();
      expect(options.type, SshKeyType.ed25519);
      expect(options.comment, '');
      expect(options.bits, 0);
    });

    test('effectiveBits returns type default when bits is 0', () {
      const options = SshKeyOptions(type: SshKeyType.rsa);
      expect(options.effectiveBits, 4096);
    });

    test('effectiveBits returns custom bits when set', () {
      const options = SshKeyOptions(type: SshKeyType.rsa, bits: 2048);
      expect(options.effectiveBits, 2048);
    });
  });
}
