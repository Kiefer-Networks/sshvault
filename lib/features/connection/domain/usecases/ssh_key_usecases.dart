import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/features/connection/domain/entities/ssh_key_entity.dart';
import 'package:sshvault/features/connection/domain/repositories/ssh_key_repository.dart';

class SshKeyUseCases {
  final SshKeyRepository _repository;

  SshKeyUseCases(this._repository);

  Future<Result<List<SshKeyEntity>>> getAllSshKeys() {
    return _repository.getAllSshKeys();
  }

  Future<Result<SshKeyEntity>> getSshKey(String id) {
    return _repository.getSshKey(id);
  }

  Future<Result<SshKeyEntity>> createSshKey(
    SshKeyEntity key, {
    required String privateKey,
    String? passphrase,
  }) {
    if (key.name.trim().isEmpty) {
      return Future.value(
        const Err(ValidationFailure('SSH key name cannot be empty')),
      );
    }
    if (privateKey.trim().isEmpty) {
      return Future.value(
        const Err(ValidationFailure('Private key cannot be empty')),
      );
    }
    return _repository.createSshKey(
      key,
      privateKey: privateKey,
      passphrase: passphrase,
    );
  }

  Future<Result<SshKeyEntity>> updateSshKey(SshKeyEntity key) {
    if (key.name.trim().isEmpty) {
      return Future.value(
        const Err(ValidationFailure('SSH key name cannot be empty')),
      );
    }
    return _repository.updateSshKey(key);
  }

  Future<Result<void>> deleteSshKey(String id) {
    return _repository.deleteSshKey(id);
  }

  Future<Result<int>> countServersUsingSshKey(String id) {
    return _repository.countServersUsingSshKey(id);
  }

  Future<Result<String?>> getSshKeyPrivateKey(String id) {
    return _repository.getSshKeyPrivateKey(id);
  }

  Future<Result<String?>> getSshKeyPassphrase(String id) {
    return _repository.getSshKeyPassphrase(id);
  }
}
