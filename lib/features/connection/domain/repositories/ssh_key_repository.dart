import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/features/connection/domain/entities/ssh_key_entity.dart';

abstract class SshKeyRepository {
  Future<Result<List<SshKeyEntity>>> getAllSshKeys();
  Future<Result<SshKeyEntity>> getSshKey(String id);
  Future<Result<SshKeyEntity>> createSshKey(
    SshKeyEntity key, {
    required String privateKey,
    String? passphrase,
  });
  Future<Result<SshKeyEntity>> updateSshKey(SshKeyEntity key);
  Future<Result<void>> deleteSshKey(String id);
  Future<Result<int>> countServersUsingSshKey(String id);
  Future<Result<String?>> getSshKeyPrivateKey(String id);
  Future<Result<String?>> getSshKeyPassphrase(String id);
}
