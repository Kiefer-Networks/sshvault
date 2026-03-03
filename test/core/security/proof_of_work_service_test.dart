import 'package:flutter_test/flutter_test.dart';
import 'package:shellvault/core/security/proof_of_work_service.dart';

void main() {
  late ProofOfWorkService sut;

  setUp(() {
    sut = ProofOfWorkService();
  });

  group('ProofOfWorkService — solve', () {
    test('solves challenge with difficulty 1', () async {
      const challenge = ProofOfWorkChallenge(
        prefix: 'test-prefix-12345',
        difficulty: 1,
      );

      final result = await sut.solve(challenge);
      expect(result.isSuccess, isTrue);
      expect(result.value.nonce, isNotEmpty);
      expect(result.value.hash, isNotEmpty);
      expect(result.value.iterations, greaterThan(0));
      expect(result.value.durationMs, greaterThanOrEqualTo(0));
    });

    test('solves challenge with difficulty 8 (1 leading zero byte)', () async {
      const challenge = ProofOfWorkChallenge(
        prefix: 'pow-challenge-v1-abc',
        difficulty: 8,
      );

      final result = await sut.solve(challenge);
      expect(result.isSuccess, isTrue);
      // Hash should start with "00" (1 zero byte = 2 hex chars)
      expect(result.value.hash, startsWith('00'));
    });

    test('solution hash length is 64 hex chars (SHA-256)', () async {
      const challenge = ProofOfWorkChallenge(prefix: 'test', difficulty: 1);

      final result = await sut.solve(challenge);
      expect(result.isSuccess, isTrue);
      expect(result.value.hash.length, 64);
    });

    test('different prefixes produce different solutions', () async {
      const c1 = ProofOfWorkChallenge(prefix: 'prefix-a', difficulty: 1);
      const c2 = ProofOfWorkChallenge(prefix: 'prefix-b', difficulty: 1);

      final r1 = await sut.solve(c1);
      final r2 = await sut.solve(c2);

      expect(r1.isSuccess, isTrue);
      expect(r2.isSuccess, isTrue);
      // Solutions can have the same nonce by coincidence, but hashes differ
      expect(r1.value.hash, isNot(equals(r2.value.hash)));
    });
  });

  group('ProofOfWorkService — verify', () {
    test('verifies a valid solution', () async {
      const challenge = ProofOfWorkChallenge(
        prefix: 'verify-test',
        difficulty: 4,
      );

      final result = await sut.solve(challenge);
      expect(result.isSuccess, isTrue);

      final valid = sut.verify(challenge, result.value);
      expect(valid, isTrue);
    });

    test('rejects solution with wrong nonce', () async {
      const challenge = ProofOfWorkChallenge(
        prefix: 'verify-test',
        difficulty: 4,
      );

      final result = await sut.solve(challenge);
      expect(result.isSuccess, isTrue);

      final tampered = ProofOfWorkSolution(
        nonce: '99999999',
        hash: result.value.hash,
        iterations: result.value.iterations,
        durationMs: result.value.durationMs,
      );

      final valid = sut.verify(challenge, tampered);
      expect(valid, isFalse);
    });

    test('rejects solution with wrong prefix', () async {
      const challenge = ProofOfWorkChallenge(
        prefix: 'correct-prefix',
        difficulty: 4,
      );

      final result = await sut.solve(challenge);
      expect(result.isSuccess, isTrue);

      const wrongChallenge = ProofOfWorkChallenge(
        prefix: 'wrong-prefix',
        difficulty: 4,
      );

      final valid = sut.verify(wrongChallenge, result.value);
      expect(valid, isFalse);
    });
  });

  group('ProofOfWorkChallenge', () {
    test('fromJson parses correctly', () {
      final json = {
        'prefix': 'test-prefix',
        'difficulty': 16,
        'expires_at': '2025-12-31T23:59:59Z',
      };

      final challenge = ProofOfWorkChallenge.fromJson(json);
      expect(challenge.prefix, 'test-prefix');
      expect(challenge.difficulty, 16);
      expect(challenge.expiresAt, isNotNull);
    });

    test('isExpired returns true for past dates', () {
      final challenge = ProofOfWorkChallenge(
        prefix: 'test',
        difficulty: 1,
        expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
      );
      expect(challenge.isExpired, isTrue);
    });

    test('isExpired returns false for future dates', () {
      final challenge = ProofOfWorkChallenge(
        prefix: 'test',
        difficulty: 1,
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );
      expect(challenge.isExpired, isFalse);
    });

    test('isExpired returns false when no expiry set', () {
      const challenge = ProofOfWorkChallenge(prefix: 'test', difficulty: 1);
      expect(challenge.isExpired, isFalse);
    });

    test('toJson round-trips correctly', () {
      final challenge = ProofOfWorkChallenge(
        prefix: 'test',
        difficulty: 8,
        expiresAt: DateTime.utc(2025, 12, 31),
      );

      final json = challenge.toJson();
      final parsed = ProofOfWorkChallenge.fromJson(json);

      expect(parsed.prefix, challenge.prefix);
      expect(parsed.difficulty, challenge.difficulty);
    });
  });

  group('ProofOfWorkSolution', () {
    test('toJson contains nonce and hash', () {
      const solution = ProofOfWorkSolution(
        nonce: '12345',
        hash: 'abcdef',
        iterations: 12345,
        durationMs: 100,
      );

      final json = solution.toJson();
      expect(json['nonce'], '12345');
      expect(json['hash'], 'abcdef');
      // iterations and durationMs are not serialized (client-only data)
      expect(json.containsKey('iterations'), isFalse);
    });
  });
}
