import 'package:uuid/uuid.dart';
import 'package:shellvault/core/crypto/ssh_key_service.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/storage/secure_storage_service.dart';
import 'package:shellvault/features/connection/data/datasources/ssh_key_dao.dart';
import 'package:shellvault/features/connection/data/models/ssh_key_mapper.dart';
import 'package:shellvault/features/connection/domain/entities/ssh_key_entity.dart';
import 'package:shellvault/features/connection/domain/repositories/ssh_key_repository.dart';

class SshKeyRepositoryImpl implements SshKeyRepository {
  final SshKeyDao _sshKeyDao;
  final SecureStorageService _secureStorage;
  final SshKeyService _sshKeyService;
  final Uuid _uuid;

  SshKeyRepositoryImpl(
    this._sshKeyDao,
    this._secureStorage, {
    SshKeyService? sshKeyService,
    Uuid? uuid,
  })  : _sshKeyService = sshKeyService ?? SshKeyService(),
        _uuid = uuid ?? const Uuid();

  @override
  Future<Result<List<SshKeyEntity>>> getAllSshKeys() async {
    try {
      final rows = await _sshKeyDao.getAllSshKeys();
      final entities = <SshKeyEntity>[];
      for (final row in rows) {
        final count = await _sshKeyDao.countServersUsingSshKey(row.id);
        entities.add(SshKeyMapper.fromDrift(row, linkedServerCount: count));
      }
      return Success(entities);
    } catch (e) {
      return Err(DatabaseFailure('Failed to load SSH keys', cause: e));
    }
  }

  @override
  Future<Result<SshKeyEntity>> getSshKey(String id) async {
    try {
      final row = await _sshKeyDao.getSshKeyById(id);
      if (row == null) {
        return Err(NotFoundFailure('SSH key not found: $id'));
      }
      final count = await _sshKeyDao.countServersUsingSshKey(id);
      return Success(SshKeyMapper.fromDrift(row, linkedServerCount: count));
    } catch (e) {
      return Err(DatabaseFailure('Failed to load SSH key', cause: e));
    }
  }

  @override
  Future<Result<SshKeyEntity>> createSshKey(
    SshKeyEntity key, {
    required String privateKey,
    String? passphrase,
  }) async {
    try {
      final now = DateTime.now();
      final id = _uuid.v4();

      // Extract public key if not provided
      String publicKey = key.publicKey;
      if (publicKey.isEmpty) {
        final extractResult =
            await _sshKeyService.extractPublicKey(privateKey);
        if (extractResult.isSuccess) {
          publicKey = extractResult.value;
        } else {
          return Err(extractResult.failure);
        }
      }

      // Compute fingerprint
      String fingerprint = key.fingerprint;
      if (fingerprint.isEmpty && publicKey.isNotEmpty) {
        fingerprint = _sshKeyService.computeFingerprint(publicKey);
      }

      final newKey = key.copyWith(
        id: id,
        publicKey: publicKey,
        fingerprint: fingerprint,
        createdAt: now,
        updatedAt: now,
      );

      await _sshKeyDao.insertSshKey(SshKeyMapper.toCompanion(newKey));

      // Save private key and passphrase in SecureStorage
      await _secureStorage.saveSshKeyPrivateKey(id, privateKey);
      if (passphrase != null && passphrase.isNotEmpty) {
        await _secureStorage.saveSshKeyPassphrase(id, passphrase);
      }

      return Success(newKey);
    } catch (e) {
      return Err(DatabaseFailure('Failed to create SSH key', cause: e));
    }
  }

  @override
  Future<Result<SshKeyEntity>> updateSshKey(SshKeyEntity key) async {
    try {
      final updated = key.copyWith(updatedAt: DateTime.now());
      await _sshKeyDao.updateSshKey(SshKeyMapper.toCompanion(updated));
      return Success(updated);
    } catch (e) {
      return Err(DatabaseFailure('Failed to update SSH key', cause: e));
    }
  }

  @override
  Future<Result<void>> deleteSshKey(String id) async {
    try {
      final count = await _sshKeyDao.countServersUsingSshKey(id);
      if (count > 0) {
        return Err(ValidationFailure(
          'Cannot delete SSH key. It is used by $count server(s). '
          'Unlink from all servers first.',
        ));
      }
      await _sshKeyDao.deleteSshKeyById(id);
      await _secureStorage.deleteSshKeySecrets(id);
      return const Success(null);
    } catch (e) {
      return Err(DatabaseFailure('Failed to delete SSH key', cause: e));
    }
  }

  @override
  Future<Result<int>> countServersUsingSshKey(String id) async {
    try {
      final count = await _sshKeyDao.countServersUsingSshKey(id);
      return Success(count);
    } catch (e) {
      return Err(DatabaseFailure('Failed to count servers', cause: e));
    }
  }

  @override
  Future<Result<String?>> getSshKeyPrivateKey(String id) {
    return _secureStorage.getSshKeyPrivateKey(id);
  }

  @override
  Future<Result<String?>> getSshKeyPassphrase(String id) {
    return _secureStorage.getSshKeyPassphrase(id);
  }
}
