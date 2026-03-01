import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/crypto/encryption_service.dart';
import 'package:shellvault/core/crypto/export_envelope.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/storage/secure_storage_service.dart';
import 'package:shellvault/features/connection/data/datasources/group_dao.dart';
import 'package:shellvault/features/connection/data/datasources/server_dao.dart';
import 'package:shellvault/features/connection/data/datasources/ssh_key_dao.dart';
import 'package:shellvault/features/connection/data/datasources/tag_dao.dart';
import 'package:shellvault/features/connection/data/models/group_mapper.dart';
import 'package:shellvault/features/connection/data/models/server_mapper.dart';
import 'package:shellvault/features/connection/data/models/ssh_key_mapper.dart';
import 'package:shellvault/features/connection/data/models/tag_mapper.dart';
import 'package:shellvault/features/connection/domain/entities/group_entity.dart';
import 'package:shellvault/features/connection/domain/entities/server_entity.dart';
import 'package:shellvault/features/connection/domain/entities/ssh_key_entity.dart';
import 'package:shellvault/features/connection/domain/entities/tag_entity.dart';
import 'package:shellvault/features/connection/domain/repositories/export_import_repository.dart';
import 'package:uuid/uuid.dart';

class ExportImportRepositoryImpl implements ExportImportRepository {
  final ServerDao _serverDao;
  final GroupDao _groupDao;
  final TagDao _tagDao;
  final SshKeyDao _sshKeyDao;
  final SecureStorageService _secureStorage;
  final EncryptionService _encryptionService;
  final Uuid _uuid;

  ExportImportRepositoryImpl(
    this._serverDao,
    this._groupDao,
    this._tagDao,
    this._sshKeyDao,
    this._secureStorage,
    this._encryptionService, {
    Uuid? uuid,
  })  : _uuid = uuid ?? const Uuid();

  Future<Map<String, dynamic>> _buildExportData({
    bool includeCredentials = false,
  }) async {
    final servers = await _serverDao.getAllServers();
    final groups = await _groupDao.getAllGroups();
    final tags = await _tagDao.getAllTags();
    final sshKeys = await _sshKeyDao.getAllSshKeys();

    final serverList = <Map<String, dynamic>>[];
    for (final server in servers) {
      final tagRows = await _serverDao.getTagsForServer(server.id);
      final entity = ServerMapper.fromDrift(
        server,
        tags: tagRows.map((t) => TagMapper.fromDrift(t)).toList(),
      );
      final json = entity.toJson();
      json['tagIds'] = tagRows.map((t) => t.id).toList();

      if (includeCredentials) {
        final credsResult = await _secureStorage.getAllCredentials(server.id);
        if (credsResult.isSuccess) {
          json['credentials'] = credsResult.value;
        }
      }

      serverList.add(json);
    }

    final sshKeyList = <Map<String, dynamic>>[];
    for (final sshKey in sshKeys) {
      final entity = SshKeyMapper.fromDrift(sshKey);
      final json = entity.toJson();
      if (includeCredentials) {
        final privResult =
            await _secureStorage.getSshKeyPrivateKey(sshKey.id);
        if (privResult.isSuccess && privResult.value != null) {
          json['privateKey'] = privResult.value;
        }
        final passResult =
            await _secureStorage.getSshKeyPassphrase(sshKey.id);
        if (passResult.isSuccess && passResult.value != null) {
          json['passphrase'] = passResult.value;
        }
      }
      sshKeyList.add(json);
    }

    return {
      'version': AppConstants.exportVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'servers': serverList,
      'groups': groups.map((g) => GroupMapper.fromDrift(g).toJson()).toList(),
      'tags': tags.map((t) => TagMapper.fromDrift(t).toJson()).toList(),
      'sshKeys': sshKeyList,
    };
  }

  @override
  Future<Result<String>> exportToJson() async {
    try {
      final data = await _buildExportData();
      final jsonString = const JsonEncoder.withIndent('  ').convert(data);

      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath =
          '${dir.path}/${AppConstants.exportFileName}_$timestamp.json';
      await File(filePath).writeAsString(jsonString);

      return Success(filePath);
    } catch (e) {
      return Err(ExportFailure('Failed to export JSON', cause: e));
    }
  }

  @override
  Future<Result<String>> exportToEncryptedZip(String password) async {
    try {
      final data = await _buildExportData(includeCredentials: true);
      final jsonString = const JsonEncoder.withIndent('  ').convert(data);

      final envelopeResult =
          _encryptionService.encryptForExport(jsonString, password);
      if (envelopeResult.isFailure) {
        return Err(envelopeResult.failure);
      }

      final envelopeJson = jsonEncode(envelopeResult.value.toJson());
      final archive = Archive();
      archive.addFile(ArchiveFile.bytes(
        AppConstants.encryptedDataFile,
        utf8.encode(envelopeJson),
      ));

      final encoded = ZipEncoder().encode(archive);

      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath =
          '${dir.path}/${AppConstants.exportFileName}_$timestamp.zip';
      await File(filePath).writeAsBytes(encoded);

      return Success(filePath);
    } catch (e) {
      return Err(ExportFailure('Failed to export encrypted ZIP', cause: e));
    }
  }

  @override
  Future<Result<ImportResult>> importFromFile(
    String filePath,
    ImportConflictStrategy strategy, {
    String? password,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return const Err(ImportFailure('File not found'));
      }

      final bytes = await file.readAsBytes();
      Map<String, dynamic> data;

      if (filePath.endsWith('.zip') || _isZip(bytes)) {
        if (password == null) {
          return const Err(
              ImportFailure('Password required for encrypted import'));
        }
        final jsonResult = await _decryptZip(bytes, password);
        if (jsonResult.isFailure) return Err(jsonResult.failure);
        data = jsonDecode(jsonResult.value) as Map<String, dynamic>;
      } else {
        data = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      }

      return _importData(data, strategy, includeCredentials: password != null);
    } catch (e) {
      return Err(ImportFailure('Failed to import file', cause: e));
    }
  }

  bool _isZip(List<int> bytes) {
    return bytes.length >= 4 &&
        bytes[0] == 0x50 &&
        bytes[1] == 0x4B &&
        bytes[2] == 0x03 &&
        bytes[3] == 0x04;
  }

  Future<Result<String>> _decryptZip(List<int> bytes, String password) async {
    try {
      final archive = ZipDecoder().decodeBytes(bytes);
      final encFile = archive.files.firstWhere(
        (f) => f.name == AppConstants.encryptedDataFile,
        orElse: () => throw const FormatException('Missing encrypted data'),
      );

      final envelopeJson = utf8.decode(encFile.content as List<int>);
      final envelope = ExportEnvelope.fromJson(
          jsonDecode(envelopeJson) as Map<String, dynamic>);

      return _encryptionService.decryptFromExport(envelope, password);
    } catch (e) {
      if (e is FormatException) {
        return Err(ImportFailure(e.message));
      }
      return Err(ImportFailure('Failed to decrypt archive', cause: e));
    }
  }

  Future<Result<ImportResult>> _importData(
    Map<String, dynamic> data,
    ImportConflictStrategy strategy, {
    bool includeCredentials = false,
  }) async {
    var serversImported = 0;
    var groupsImported = 0;
    var tagsImported = 0;
    var skipped = 0;
    final errors = <String>[];

    // Import groups first
    final groups = (data['groups'] as List<dynamic>?) ?? [];
    for (final groupJson in groups) {
      try {
        final map = Map<String, dynamic>.from(groupJson as Map);
        final id = map['id'] as String;
        final existing = await _groupDao.getGroupById(id);

        if (existing != null) {
          switch (strategy) {
            case ImportConflictStrategy.skip:
              skipped++;
              continue;
            case ImportConflictStrategy.overwrite:
              final entity = GroupEntity.fromJson(map);
              await _groupDao
                  .updateGroup(GroupMapper.toCompanion(entity));
            case ImportConflictStrategy.rename:
              map['id'] = _uuid.v4();
              map['name'] = '${map['name']} (Imported)';
              final entity = GroupEntity.fromJson(map);
              await _groupDao
                  .insertGroup(GroupMapper.toCompanion(entity));
          }
        } else {
          final entity = GroupEntity.fromJson(map);
          await _groupDao.insertGroup(GroupMapper.toCompanion(entity));
        }
        groupsImported++;
      } catch (e) {
        errors.add('Group import error: $e');
      }
    }

    // Import tags
    final tags = (data['tags'] as List<dynamic>?) ?? [];
    for (final tagJson in tags) {
      try {
        final map = Map<String, dynamic>.from(tagJson as Map);
        final id = map['id'] as String;
        final existing = await _tagDao.getTagById(id);

        if (existing != null) {
          switch (strategy) {
            case ImportConflictStrategy.skip:
              skipped++;
              continue;
            case ImportConflictStrategy.overwrite:
              final entity = TagEntity.fromJson(map);
              await _tagDao.updateTag(TagMapper.toCompanion(entity));
            case ImportConflictStrategy.rename:
              map['id'] = _uuid.v4();
              map['name'] = '${map['name']} (Imported)';
              final entity = TagEntity.fromJson(map);
              await _tagDao.insertTag(TagMapper.toCompanion(entity));
          }
        } else {
          final entity = TagEntity.fromJson(map);
          await _tagDao.insertTag(TagMapper.toCompanion(entity));
        }
        tagsImported++;
      } catch (e) {
        errors.add('Tag import error: $e');
      }
    }

    // Import SSH keys (before servers, since servers may reference them)
    final sshKeysData = (data['sshKeys'] as List<dynamic>?) ?? [];
    var sshKeysImported = 0;
    for (final sshKeyJson in sshKeysData) {
      try {
        final map = Map<String, dynamic>.from(sshKeyJson as Map);
        final id = map['id'] as String;
        final existing = await _sshKeyDao.getSshKeyById(id);

        // Extract secrets before creating entity
        final privateKey = map.remove('privateKey') as String?;
        final passphrase = map.remove('passphrase') as String?;

        String sshKeyId = id;

        if (existing != null) {
          switch (strategy) {
            case ImportConflictStrategy.skip:
              skipped++;
              continue;
            case ImportConflictStrategy.overwrite:
              final entity = SshKeyEntity.fromJson(map);
              await _sshKeyDao
                  .updateSshKey(SshKeyMapper.toCompanion(entity));
            case ImportConflictStrategy.rename:
              sshKeyId = _uuid.v4();
              map['id'] = sshKeyId;
              map['name'] = '${map['name']} (Imported)';
              final entity = SshKeyEntity.fromJson(map);
              await _sshKeyDao
                  .insertSshKey(SshKeyMapper.toCompanion(entity));
          }
        } else {
          final entity = SshKeyEntity.fromJson(map);
          await _sshKeyDao
              .insertSshKey(SshKeyMapper.toCompanion(entity));
        }

        // Restore secrets
        if (includeCredentials) {
          if (privateKey != null) {
            await _secureStorage.saveSshKeyPrivateKey(sshKeyId, privateKey);
          }
          if (passphrase != null) {
            await _secureStorage.saveSshKeyPassphrase(sshKeyId, passphrase);
          }
        }

        sshKeysImported++;
      } catch (e) {
        errors.add('SSH key import error: $e');
      }
    }

    // Import servers
    final servers = (data['servers'] as List<dynamic>?) ?? [];
    for (final serverJson in servers) {
      try {
        final map = Map<String, dynamic>.from(serverJson as Map);
        final id = map['id'] as String;
        final existing = await _serverDao.getServerById(id);

        String serverId = id;

        if (existing != null) {
          switch (strategy) {
            case ImportConflictStrategy.skip:
              skipped++;
              continue;
            case ImportConflictStrategy.overwrite:
              final entity = ServerEntity.fromJson(map);
              await _serverDao
                  .updateServer(ServerMapper.toCompanion(entity));
            case ImportConflictStrategy.rename:
              serverId = _uuid.v4();
              map['id'] = serverId;
              map['name'] = '${map['name']} (Imported)';
              final entity = ServerEntity.fromJson(map);
              await _serverDao
                  .insertServer(ServerMapper.toCompanion(entity));
          }
        } else {
          final entity = ServerEntity.fromJson(map);
          await _serverDao
              .insertServer(ServerMapper.toCompanion(entity));
        }

        // Restore tags
        final tagIds =
            (map['tagIds'] as List<dynamic>?)?.cast<String>() ?? [];
        if (tagIds.isNotEmpty) {
          await _serverDao.setServerTags(serverId, tagIds);
        }

        // Restore credentials
        if (includeCredentials && map['credentials'] != null) {
          final creds = map['credentials'] as Map<String, dynamic>;
          if (creds['password'] != null) {
            await _secureStorage.savePassword(
                serverId, creds['password'] as String);
          }
          if (creds['privateKey'] != null) {
            await _secureStorage.savePrivateKey(
                serverId, creds['privateKey'] as String);
          }
          if (creds['publicKey'] != null) {
            await _secureStorage.savePublicKey(
                serverId, creds['publicKey'] as String);
          }
          if (creds['passphrase'] != null) {
            await _secureStorage.savePassphrase(
                serverId, creds['passphrase'] as String);
          }
        }

        serversImported++;
      } catch (e) {
        errors.add('Server import error: $e');
      }
    }

    return Success(ImportResult(
      serversImported: serversImported,
      groupsImported: groupsImported,
      tagsImported: tagsImported,
      sshKeysImported: sshKeysImported,
      skipped: skipped,
      errors: errors,
    ));
  }
}
