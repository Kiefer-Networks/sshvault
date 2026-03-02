import 'package:flutter_test/flutter_test.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';

void main() {
  group('Success', () {
    test('isSuccess returns true', () {
      const result = Success(42);
      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
    });

    test('value returns data', () {
      const result = Success('hello');
      expect(result.value, 'hello');
    });

    test('fold calls onSuccess', () {
      const result = Success(10);
      final folded = result.fold(
        onSuccess: (data) => data * 2,
        onFailure: (f) => -1,
      );
      expect(folded, 20);
    });

    test('map transforms data', () {
      const result = Success(5);
      final mapped = result.map((d) => d.toString());
      expect(mapped.isSuccess, isTrue);
      expect(mapped.value, '5');
    });

    test('flatMapAsync transforms data', () async {
      const result = Success(5);
      final mapped = await result.flatMapAsync(
        (d) async => Success(d * 3),
      );
      expect(mapped.isSuccess, isTrue);
      expect(mapped.value, 15);
    });

    test('flatMapAsync can return Err', () async {
      const result = Success(5);
      final mapped = await result.flatMapAsync<int>(
        (d) async => const Err(ValidationFailure('bad')),
      );
      expect(mapped.isFailure, isTrue);
    });
  });

  group('Err', () {
    test('isFailure returns true', () {
      const result = Err<int>(ValidationFailure('test'));
      expect(result.isFailure, isTrue);
      expect(result.isSuccess, isFalse);
    });

    test('failure returns error', () {
      const result = Err<int>(NetworkFailure('timeout', statusCode: 408));
      expect(result.failure, isA<NetworkFailure>());
      expect(result.failure.message, 'timeout');
    });

    test('fold calls onFailure', () {
      const result = Err<int>(DatabaseFailure('not found'));
      final folded = result.fold(
        onSuccess: (data) => 'ok',
        onFailure: (f) => f.message,
      );
      expect(folded, 'not found');
    });

    test('map preserves error', () {
      const result = Err<int>(StorageFailure('full'));
      final mapped = result.map((d) => d.toString());
      expect(mapped.isFailure, isTrue);
      expect(mapped.failure.message, 'full');
    });

    test('flatMapAsync preserves error', () async {
      const result = Err<int>(CryptoFailure('key error'));
      final mapped = await result.flatMapAsync(
        (d) async => Success(d * 2),
      );
      expect(mapped.isFailure, isTrue);
      expect(mapped.failure.message, 'key error');
    });
  });

  group('Failure types', () {
    test('toString includes runtimeType and message', () {
      const f = AuthFailure('invalid token');
      expect(f.toString(), contains('AuthFailure'));
      expect(f.toString(), contains('invalid token'));
    });

    test('cause is preserved', () {
      final cause = Exception('root cause');
      final f = DatabaseFailure('query failed', cause: cause);
      expect(f.cause, cause);
    });

    test('SyncFailure has conflictVersion and statusCode', () {
      const f = SyncFailure(
        'conflict',
        conflictVersion: 5,
        statusCode: 409,
      );
      expect(f.conflictVersion, 5);
      expect(f.statusCode, 409);
    });

    test('NetworkFailure has statusCode', () {
      const f = NetworkFailure('server error', statusCode: 500);
      expect(f.statusCode, 500);
    });
  });
}
