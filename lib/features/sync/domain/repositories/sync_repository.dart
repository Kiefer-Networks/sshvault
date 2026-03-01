import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/sync/domain/entities/vault_entity.dart';

abstract class SyncRepository {
  Future<Result<VaultEntity>> getVault();
  Future<Result<VaultEntity>> putVault({
    required int version,
    required String blob,
    required String checksum,
  });
  Future<Result<List<VaultEntity>>> getVaultHistory();
  Future<Result<VaultEntity>> getVaultVersion(int version);
}
