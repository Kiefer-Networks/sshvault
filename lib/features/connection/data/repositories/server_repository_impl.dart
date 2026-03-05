import 'package:uuid/uuid.dart';
import 'package:shellvault/core/crypto/ssh_key_service.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/storage/secure_storage_service.dart';
import 'package:shellvault/features/connection/data/datasources/group_dao.dart';
import 'package:shellvault/features/connection/data/datasources/server_dao.dart';
import 'package:shellvault/features/connection/data/models/group_mapper.dart';
import 'package:shellvault/features/connection/data/models/server_mapper.dart';
import 'package:shellvault/features/connection/data/models/tag_mapper.dart';
import 'package:shellvault/features/connection/data/repositories/group_repository_impl.dart';
import 'package:shellvault/features/connection/domain/entities/server_credentials.dart';
import 'package:shellvault/features/connection/domain/entities/server_entity.dart';
import 'package:shellvault/features/connection/domain/entities/server_filter.dart';
import 'package:shellvault/features/connection/domain/repositories/server_repository.dart';

class ServerRepositoryImpl implements ServerRepository {
  final ServerDao _serverDao;
  final GroupDao? _groupDao;
  final SecureStorageService _secureStorage;
  final SshKeyService _sshKeyService;
  final Uuid _uuid;

  ServerRepositoryImpl(
    this._serverDao,
    this._secureStorage, {
    GroupDao? groupDao,
    SshKeyService? sshKeyService,
    Uuid? uuid,
  }) : _groupDao = groupDao,
       _sshKeyService = sshKeyService ?? SshKeyService(),
       _uuid = uuid ?? const Uuid();

  @override
  Future<Result<List<ServerEntity>>> getServers({ServerFilter? filter}) async {
    try {
      List<String>? groupIds;
      if (filter?.groupId != null && _groupDao != null) {
        final allGroups = await _groupDao.getAllGroups();
        final allEntities = allGroups
            .map((row) => GroupMapper.fromDrift(row))
            .toList();
        groupIds = GroupRepositoryImpl.collectDescendantIds(
          filter!.groupId!,
          allEntities,
        );
      }

      final rows = await _serverDao.getFilteredServers(
        searchQuery: filter?.searchQuery,
        groupId: groupIds == null ? filter?.groupId : null,
        groupIds: groupIds,
        tagIds: filter?.tagIds.isEmpty ?? true ? null : filter?.tagIds,
        isActive: filter?.isActive,
      );

      final entities = <ServerEntity>[];
      for (final row in rows) {
        final tagRows = await _serverDao.getTagsForServer(row.id);
        final tags = tagRows.map((t) => TagMapper.fromDrift(t)).toList();
        entities.add(ServerMapper.fromDrift(row, tags: tags));
      }

      return Success(entities);
    } catch (e) {
      return Err(DatabaseFailure('Failed to load servers', cause: e));
    }
  }

  @override
  Future<Result<ServerEntity>> getServer(String id) async {
    try {
      final row = await _serverDao.getServerById(id);
      if (row == null) {
        return Err(NotFoundFailure('Server not found: $id'));
      }
      final tagRows = await _serverDao.getTagsForServer(id);
      final tags = tagRows.map((t) => TagMapper.fromDrift(t)).toList();
      return Success(ServerMapper.fromDrift(row, tags: tags));
    } catch (e) {
      return Err(DatabaseFailure('Failed to load server', cause: e));
    }
  }

  @override
  Future<Result<ServerEntity>> createServer(
    ServerEntity server,
    ServerCredentials? credentials,
  ) async {
    try {
      final now = DateTime.now();
      final id = _uuid.v4();
      final newServer = server.copyWith(id: id, createdAt: now, updatedAt: now);

      await _serverDao.insertServer(ServerMapper.toCompanion(newServer));

      if (server.tags.isNotEmpty) {
        await _serverDao.setServerTags(
          id,
          server.tags.map((t) => t.id).toList(),
        );
      }

      if (credentials != null) {
        await _saveCredentials(id, credentials);
      }

      return Success(newServer);
    } catch (e) {
      return Err(DatabaseFailure('Failed to create server', cause: e));
    }
  }

  @override
  Future<Result<ServerEntity>> updateServer(
    ServerEntity server,
    ServerCredentials? credentials,
  ) async {
    try {
      final updated = server.copyWith(updatedAt: DateTime.now());
      await _serverDao.updateServer(ServerMapper.toCompanion(updated));

      await _serverDao.setServerTags(
        server.id,
        server.tags.map((t) => t.id).toList(),
      );

      if (credentials != null) {
        await _saveCredentials(server.id, credentials);
      }

      return Success(updated);
    } catch (e) {
      return Err(DatabaseFailure('Failed to update server', cause: e));
    }
  }

  @override
  Future<Result<void>> deleteServer(String id) async {
    try {
      await _serverDao.setServerTags(id, []);
      await _serverDao.deleteServerById(id);
      await _secureStorage.deleteCredentials(id);
      return const Success(null);
    } catch (e) {
      return Err(DatabaseFailure('Failed to delete server', cause: e));
    }
  }

  @override
  Future<Result<ServerEntity>> duplicateServer(
    String id, {
    required String copySuffix,
  }) async {
    final result = await getServer(id);
    return result.fold(
      onSuccess: (server) async {
        final newId = _uuid.v4();
        final now = DateTime.now();
        final duplicate = server.copyWith(
          id: newId,
          name: '${server.name} $copySuffix',
          createdAt: now,
          updatedAt: now,
        );

        try {
          await _serverDao.insertServer(ServerMapper.toCompanion(duplicate));
          if (server.tags.isNotEmpty) {
            await _serverDao.setServerTags(
              newId,
              server.tags.map((t) => t.id).toList(),
            );
          }

          // Copy credentials
          final creds = await _secureStorage.getAllCredentials(id);
          if (creds.isSuccess) {
            final credMap = creds.value;
            if (credMap['password'] != null) {
              await _secureStorage.savePassword(newId, credMap['password']!);
            }
            if (credMap['privateKey'] != null) {
              await _secureStorage.savePrivateKey(
                newId,
                credMap['privateKey']!,
              );
            }
            if (credMap['publicKey'] != null) {
              await _secureStorage.savePublicKey(newId, credMap['publicKey']!);
            }
            if (credMap['passphrase'] != null) {
              await _secureStorage.savePassphrase(
                newId,
                credMap['passphrase']!,
              );
            }
          }

          return Success(duplicate);
        } catch (e) {
          return Err(DatabaseFailure('Failed to duplicate server', cause: e));
        }
      },
      onFailure: (failure) async => Err(failure),
    );
  }

  @override
  Future<Result<void>> reorderServers(List<String> orderedIds) async {
    try {
      final idToOrder = <String, int>{};
      for (var i = 0; i < orderedIds.length; i++) {
        idToOrder[orderedIds[i]] = i;
      }
      await _serverDao.updateSortOrders(idToOrder);
      return const Success(null);
    } catch (e) {
      return Err(DatabaseFailure('Failed to reorder servers', cause: e));
    }
  }

  @override
  Future<Result<ServerCredentials>> getCredentials(String serverId) async {
    final result = await _secureStorage.getAllCredentials(serverId);
    return result.map(
      (credMap) => ServerCredentials(
        password: credMap['password'],
        privateKey: credMap['privateKey'],
        publicKey: credMap['publicKey'],
        passphrase: credMap['passphrase'],
      ),
    );
  }

  Future<void> _saveCredentials(
    String serverId,
    ServerCredentials credentials,
  ) async {
    if (credentials.password != null) {
      await _secureStorage.savePassword(serverId, credentials.password!);
    }
    if (credentials.privateKey != null) {
      await _secureStorage.savePrivateKey(serverId, credentials.privateKey!);

      // Auto-generate public key from private key if not provided
      String? publicKey = credentials.publicKey;
      if (publicKey == null || publicKey.isEmpty) {
        final extractResult = await _sshKeyService.extractPublicKey(
          credentials.privateKey!,
        );
        if (extractResult.isSuccess) {
          publicKey = extractResult.value;
        }
      }
      if (publicKey != null && publicKey.isNotEmpty) {
        await _secureStorage.savePublicKey(serverId, publicKey);
      }
    } else if (credentials.publicKey != null) {
      await _secureStorage.savePublicKey(serverId, credentials.publicKey!);
    }
    if (credentials.passphrase != null) {
      await _secureStorage.savePassphrase(serverId, credentials.passphrase!);
    }
  }
}
