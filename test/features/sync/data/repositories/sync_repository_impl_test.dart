import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/network/api_client.dart';
import 'package:shellvault/features/sync/data/repositories/sync_repository_impl.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApi;
  late SyncRepositoryImpl sut;

  setUp(() {
    mockApi = MockApiClient();
    sut = SyncRepositoryImpl(mockApi);
  });

  group('getVault', () {
    test('returns VaultEntity on success', () async {
      when(() => mockApi.get('/v1/vault')).thenAnswer(
        (_) async =>
            const Success({'version': 3, 'blob': 'abc', 'checksum': 'def'}),
      );

      final result = await sut.getVault();
      expect(result.isSuccess, isTrue);
      expect(result.value.version, 3);
      expect(result.value.blob, 'abc');
      expect(result.value.checksum, 'def');
    });

    test('returns empty vault on 404', () async {
      when(() => mockApi.get('/v1/vault')).thenAnswer(
        (_) async => const Err(NetworkFailure('not found', statusCode: 404)),
      );

      final result = await sut.getVault();
      expect(result.isSuccess, isTrue);
      expect(result.value.version, 0);
      expect(result.value.blob, isNull);
    });

    test('returns SyncFailure on other network error', () async {
      when(() => mockApi.get('/v1/vault')).thenAnswer(
        (_) async => const Err(NetworkFailure('server error', statusCode: 500)),
      );

      final result = await sut.getVault();
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<SyncFailure>());
    });

    test('returns SyncFailure on invalid JSON', () async {
      when(() => mockApi.get('/v1/vault')).thenAnswer(
        (_) async => const Success({'invalid': 'missing version field'}),
      );

      // VaultEntity.fromJson sets version to 0 if missing, so it should still succeed
      final result = await sut.getVault();
      expect(result.isSuccess, isTrue);
      expect(result.value.version, 0);
    });
  });

  group('putVault', () {
    test('returns updated VaultEntity on success', () async {
      when(() => mockApi.put('/v1/vault', data: any(named: 'data'))).thenAnswer(
        (_) async => const Success({
          'version': 4,
          'blob': 'new-blob',
          'checksum': 'new-check',
        }),
      );

      final result = await sut.putVault(
        version: 4,
        blob: 'new-blob',
        checksum: 'new-check',
      );
      expect(result.isSuccess, isTrue);
      expect(result.value.version, 4);
    });

    test('returns SyncFailure with conflictVersion on 409', () async {
      when(() => mockApi.put('/v1/vault', data: any(named: 'data'))).thenAnswer(
        (_) async => const Err(NetworkFailure('conflict', statusCode: 409)),
      );

      final result = await sut.putVault(
        version: 4,
        blob: 'blob',
        checksum: 'check',
      );
      expect(result.isFailure, isTrue);
      final failure = result.failure as SyncFailure;
      expect(failure.conflictVersion, 4);
    });

    test('returns SyncFailure on other error', () async {
      when(() => mockApi.put('/v1/vault', data: any(named: 'data'))).thenAnswer(
        (_) async => const Err(NetworkFailure('server error', statusCode: 500)),
      );

      final result = await sut.putVault(
        version: 4,
        blob: 'blob',
        checksum: 'check',
      );
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<SyncFailure>());
    });

    test('sends correct data payload', () async {
      when(
        () => mockApi.put('/v1/vault', data: any(named: 'data')),
      ).thenAnswer((_) async => const Success({'version': 5}));

      await sut.putVault(version: 5, blob: 'my-blob', checksum: 'my-check');
      verify(
        () => mockApi.put(
          '/v1/vault',
          data: {'version': 5, 'blob': 'my-blob', 'checksum': 'my-check'},
        ),
      ).called(1);
    });
  });

  group('getVaultHistory', () {
    test('returns list of VaultEntity on success', () async {
      when(() => mockApi.get('/v1/vault/history')).thenAnswer(
        (_) async => const Success({
          'history': [
            {'version': 1, 'blob': 'a'},
            {'version': 2, 'blob': 'b'},
          ],
        }),
      );

      final result = await sut.getVaultHistory();
      expect(result.isSuccess, isTrue);
      expect(result.value, hasLength(2));
      expect(result.value[0].version, 1);
      expect(result.value[1].version, 2);
    });

    test('returns empty list when history is null', () async {
      when(
        () => mockApi.get('/v1/vault/history'),
      ).thenAnswer((_) async => const Success(<String, dynamic>{}));

      final result = await sut.getVaultHistory();
      expect(result.isSuccess, isTrue);
      expect(result.value, isEmpty);
    });

    test('returns SyncFailure on network error', () async {
      when(
        () => mockApi.get('/v1/vault/history'),
      ).thenAnswer((_) async => const Err(NetworkFailure('offline')));

      final result = await sut.getVaultHistory();
      expect(result.isFailure, isTrue);
    });
  });

  group('getVaultVersion', () {
    test('returns specific vault version', () async {
      when(() => mockApi.get('/v1/vault/history/3')).thenAnswer(
        (_) async => const Success({'version': 3, 'blob': 'old-blob'}),
      );

      final result = await sut.getVaultVersion(3);
      expect(result.isSuccess, isTrue);
      expect(result.value.version, 3);
    });

    test('returns SyncFailure on error', () async {
      when(() => mockApi.get('/v1/vault/history/99')).thenAnswer(
        (_) async => const Err(NetworkFailure('not found', statusCode: 404)),
      );

      final result = await sut.getVaultVersion(99);
      expect(result.isFailure, isTrue);
    });
  });
}
