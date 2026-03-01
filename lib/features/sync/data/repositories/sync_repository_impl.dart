import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/network/api_client.dart';
import 'package:shellvault/features/sync/domain/entities/vault_entity.dart';
import 'package:shellvault/features/sync/domain/repositories/sync_repository.dart';

class SyncRepositoryImpl implements SyncRepository {
  final ApiClient _apiClient;

  SyncRepositoryImpl(this._apiClient);

  @override
  Future<Result<VaultEntity>> getVault() async {
    final result = await _apiClient.get('/v1/vault');
    return result.fold(
      onSuccess: (data) {
        try {
          return Success(VaultEntity.fromJson(data));
        } catch (e) {
          return Err(SyncFailure('Invalid vault response', cause: e));
        }
      },
      onFailure: (f) {
        if (f is NetworkFailure && f.statusCode == 404) {
          return const Success(VaultEntity(version: 0));
        }
        return Err(SyncFailure(f.message, cause: f.cause));
      },
    );
  }

  @override
  Future<Result<VaultEntity>> putVault({
    required int version,
    required String blob,
    required String checksum,
  }) async {
    final result = await _apiClient.put(
      '/v1/vault',
      data: {
        'version': version,
        'blob': blob,
        'checksum': checksum,
      },
    );
    return result.fold(
      onSuccess: (data) {
        try {
          return Success(VaultEntity.fromJson(data));
        } catch (e) {
          return Err(SyncFailure('Invalid vault response', cause: e));
        }
      },
      onFailure: (f) {
        if (f is NetworkFailure && f.statusCode == 409) {
          return Err(SyncFailure('Conflict: server has a newer version',
              conflictVersion: version));
        }
        return Err(SyncFailure(f.message, cause: f.cause));
      },
    );
  }

  @override
  Future<Result<List<VaultEntity>>> getVaultHistory() async {
    final result = await _apiClient.get('/v1/vault/history');
    return result.fold(
      onSuccess: (data) {
        try {
          final list = (data['history'] as List<dynamic>?) ?? [];
          return Success(
            list
                .map((e) => VaultEntity.fromJson(e as Map<String, dynamic>))
                .toList(),
          );
        } catch (e) {
          return Err(SyncFailure('Invalid history response', cause: e));
        }
      },
      onFailure: (f) => Err(SyncFailure(f.message, cause: f.cause)),
    );
  }

  @override
  Future<Result<VaultEntity>> getVaultVersion(int version) async {
    final result = await _apiClient.get('/v1/vault/history/$version');
    return result.fold(
      onSuccess: (data) {
        try {
          return Success(VaultEntity.fromJson(data));
        } catch (e) {
          return Err(SyncFailure('Invalid vault response', cause: e));
        }
      },
      onFailure: (f) => Err(SyncFailure(f.message, cause: f.cause)),
    );
  }
}
