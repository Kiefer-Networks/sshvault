import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sshvault/core/crypto/encryption_service.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/core/storage/database.dart';
import 'package:sshvault/core/storage/secure_storage_service.dart';
import 'package:sshvault/features/connection/data/repositories/export_import_repository_impl.dart';
import 'package:sshvault/features/connection/domain/repositories/export_import_repository.dart';
import 'package:sshvault/features/connection/data/repositories/server_repository_impl.dart';
import 'package:sshvault/features/connection/data/models/server_mapper.dart';
import 'package:sshvault/features/connection/domain/entities/server_credentials.dart';
import 'package:sshvault/features/connection/data/repositories/ssh_key_repository_impl.dart';
import 'package:sshvault/features/connection/domain/entities/ssh_key_entity.dart';
import 'package:sshvault/core/crypto/ssh_key_type.dart';

class _Storage extends Mock implements SecureStorageService {}

void main() {
  late AppDatabase db;
  late _Storage storage;
  late ExportImportRepositoryImpl repository;
  final now = DateTime(2026, 1, 1);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    storage = _Storage();
    repository = ExportImportRepositoryImpl(
      db.serverDao,
      db.groupDao,
      db.tagDao,
      db.sshKeyDao,
      db.snippetDao,
      db.appSettingsDao,
      storage,
      EncryptionService(),
    );
  });
  tearDown(() => db.close());

  Future<void> seed() async {
    await db.groupDao.insertGroup(
      GroupsCompanion.insert(
        id: 'g',
        name: 'Group',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await db.groupDao.insertGroup(
      GroupsCompanion.insert(
        id: 'child',
        name: 'Child',
        parentId: const Value('g'),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await db.tagDao.insertTag(
      TagsCompanion.insert(
        id: 'tag',
        name: 'Tag',
        color: const Value(1),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await db.serverDao.insertServer(
      ServersCompanion.insert(
        id: 'server',
        name: 'Original',
        hostname: 'host_with_underscore',
        username: 'user',
        groupId: const Value('g'),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await db.serverDao.setServerTags('server', ['tag']);
    await db.snippetDao.insertSnippet(
      SnippetsCompanion.insert(
        id: 'snippet',
        name: 'Snippet',
        content: 'echo 100%',
        groupId: const Value('g'),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await db.snippetDao.setSnippetTags('snippet', ['tag']);
    await db.snippetDao.setSnippetVariables('snippet', [
      SnippetVariablesCompanion.insert(
        id: 'variable',
        snippetId: 'snippet',
        name: 'value',
      ),
    ]);
  }

  test('explicit overwrite restores an older backup', () async {
    await seed();
    final backup = await repository.exportToJsonString();
    await (db.update(db.servers)..where((s) => s.id.equals('server'))).write(
      ServersCompanion(
        name: const Value('Newer'),
        updatedAt: Value(now.add(const Duration(seconds: 10))),
      ),
    );
    final result = await repository.importFromJsonString(
      backup.value,
      ImportConflictStrategy.overwrite,
    );
    expect(result.value.errors, isEmpty);
    expect((await db.serverDao.getServerById('server'))!.name, 'Original');
  });

  test('rename remaps folder and tag references and variable IDs', () async {
    await seed();
    final backup = await repository.exportToJsonString();
    final result = await repository.importFromJsonString(
      backup.value,
      ImportConflictStrategy.rename,
    );
    expect(result.value.errors, isEmpty);
    final groups = await db.groupDao.getAllGroups();
    final importedGroup = groups.singleWhere(
      (g) => g.name == 'Group (Imported)',
    );
    expect(
      groups.singleWhere((g) => g.name == 'Child (Imported)').parentId,
      importedGroup.id,
    );
    final importedServer = (await db.serverDao.getAllServers()).singleWhere(
      (s) => s.id != 'server',
    );
    expect(importedServer.groupId, importedGroup.id);
    expect(
      (await db.serverDao.getTagsForServer(importedServer.id)).single.id,
      isNot('tag'),
    );
    final importedSnippet = (await db.snippetDao.getAllSnippets()).singleWhere(
      (s) => s.id != 'snippet',
    );
    expect(
      (await db.snippetDao.getVariablesForSnippet(
        importedSnippet.id,
      )).single.id,
      isNot('variable'),
    );
    expect(await db.snippetDao.getVariablesForSnippet('snippet'), hasLength(1));
  });

  test('imported empty relations clear local tags and variables', () async {
    await seed();
    final data =
        jsonDecode((await repository.exportToJsonString()).value)
            as Map<String, dynamic>;
    for (final row in [
      ...data['servers'] as List,
      ...data['snippets'] as List,
    ]) {
      row['updatedAt'] = '2027-01-01T00:00:00.000';
      row['tagIds'] = [];
      row['variables'] = [];
    }
    await repository.importFromJsonString(
      jsonEncode(data),
      ImportConflictStrategy.overwrite,
    );
    expect(await db.serverDao.getTagsForServer('server'), isEmpty);
    expect(await db.snippetDao.getTagsForSnippet('snippet'), isEmpty);
    expect(await db.snippetDao.getVariablesForSnippet('snippet'), isEmpty);
  });

  test('deleting a folder reparents its contents to the root', () async {
    await seed();
    await db.groupDao.deleteGroupById('g');
    expect((await db.groupDao.getGroupById('child'))!.parentId, isNull);
    expect((await db.serverDao.getServerById('server'))!.groupId, isNull);
    expect((await db.snippetDao.getSnippetById('snippet'))!.groupId, isNull);
  });

  test('deleting a tag detaches it from snippets', () async {
    await seed();
    await db.tagDao.deleteTagById('tag');
    expect(await db.snippetDao.getTagsForSnippet('snippet'), isEmpty);
  });

  test('search treats underscore and percent as literal characters', () async {
    await seed();
    expect(
      await db.serverDao.getFilteredServers(searchQuery: '_'),
      hasLength(1),
    );
    expect(
      await db.snippetDao.getFilteredSnippets(searchQuery: '%'),
      hasLength(1),
    );
  });

  test('credential read failure aborts encrypted backup data export', () async {
    await seed();
    when(
      () => storage.getAllCredentials('server'),
    ).thenAnswer((_) async => const Err(StorageFailure('locked')));
    final result = await repository.exportToJsonString(
      includeCredentials: true,
    );
    expect(result.isFailure, isTrue);
  });

  test('saving a server reports secure storage write failure', () async {
    await seed();
    final server = ServerMapper.fromDrift(
      (await db.serverDao.getServerById('server'))!,
    );
    when(
      () => storage.savePassword(any(), any()),
    ).thenAnswer((_) async => const Err(StorageFailure('locked')));
    final servers = ServerRepositoryImpl(db.serverDao, storage);
    final result = await servers.createServer(
      server,
      const ServerCredentials(password: 'secret'),
    );
    expect(result.isFailure, isTrue);
    expect(await db.serverDao.getAllServers(), hasLength(1));
  });

  test('import reports secure storage write failure', () async {
    await seed();
    final data =
        jsonDecode((await repository.exportToJsonString()).value)
            as Map<String, dynamic>;
    (data['servers'] as List).first['credentials'] = {'password': 'secret'};
    (data['servers'] as List).first['name'] = 'Remote name';
    (data['servers'] as List).first['updatedAt'] = '2027-01-01T00:00:00.000';
    when(
      () => storage.savePassword(any(), any()),
    ).thenAnswer((_) async => const Err(StorageFailure('locked')));
    final result = await repository.importFromJsonString(
      jsonEncode(data),
      ImportConflictStrategy.overwrite,
      includeCredentials: true,
    );
    expect(result.value.errors, isNotEmpty);
    expect(result.value.serversImported, 0);
    expect((await db.serverDao.getServerById('server'))!.name, 'Original');
    expect((await db.serverDao.getServerById('server'))!.updatedAt, now);
  });

  test(
    'duplicating a server aborts if its credentials cannot be read',
    () async {
      await seed();
      when(
        () => storage.getAllCredentials('server'),
      ).thenAnswer((_) async => const Err(StorageFailure('locked')));
      final result = await ServerRepositoryImpl(
        db.serverDao,
        storage,
      ).duplicateServer('server', copySuffix: 'copy');
      expect(result.isFailure, isTrue);
      expect(await db.serverDao.getAllServers(), hasLength(1));
    },
  );

  test('failed key storage rolls back managed key metadata', () async {
    when(
      () => storage.saveSshKeyPrivateKey(any(), any()),
    ).thenAnswer((_) async => const Err(StorageFailure('locked')));
    final result = await SshKeyRepositoryImpl(db.sshKeyDao, storage)
        .createSshKey(
          SshKeyEntity(
            id: '',
            name: 'key',
            keyType: SshKeyType.ed25519,
            publicKey: 'public',
            fingerprint: 'fingerprint',
            createdAt: now,
            updatedAt: now,
          ),
          privateKey: 'private',
        );
    expect(result.isFailure, isTrue);
    expect(await db.sshKeyDao.getAllSshKeys(), isEmpty);
  });

  test(
    'deleted server tombstones never export lingering credentials',
    () async {
      await seed();
      await db.serverDao.deleteServerById('server');
      when(() => storage.getAllCredentials('server')).thenAnswer(
        (_) async => const Success({'password': 'lingering-secret'}),
      );
      final result = await repository.exportToJsonString(
        includeCredentials: true,
      );
      final data = jsonDecode(result.value) as Map<String, dynamic>;
      expect(
        (data['servers'] as List).single.containsKey('credentials'),
        isFalse,
      );
      expect(result.value, isNot(contains('lingering-secret')));
    },
  );

  test(
    'imported tombstones report failure to erase lingering server secrets',
    () async {
      await seed();
      final data =
          jsonDecode((await repository.exportToJsonString()).value)
              as Map<String, dynamic>;
      (data['servers'] as List).single['deletedAt'] = '2027-01-01T00:00:00.000';
      when(
        () => storage.deleteCredentials('server'),
      ).thenAnswer((_) async => const Err(StorageFailure('delete denied')));
      final result = await repository.importFromJsonString(
        jsonEncode(data),
        ImportConflictStrategy.overwrite,
      );
      expect(result.value.errors, isNotEmpty);
      expect(result.value.serversImported, 0);
    },
  );

  test(
    'deleted managed keys never export secrets and imported tombstones erase them',
    () async {
      await db.sshKeyDao.insertSshKey(
        SshKeysCompanion.insert(
          id: 'key',
          name: 'Key',
          keyType: 'ed25519',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await db.sshKeyDao.deleteSshKeyById('key');
      when(
        () => storage.getSshKeyPrivateKey('key'),
      ).thenAnswer((_) async => const Success('private-secret'));
      when(
        () => storage.getSshKeyPassphrase('key'),
      ).thenAnswer((_) async => const Success('passphrase-secret'));
      final result = await repository.exportToJsonString(
        includeCredentials: true,
      );
      final data = jsonDecode(result.value) as Map<String, dynamic>;
      final key = (data['sshKeys'] as List).single;
      expect(key.containsKey('privateKey'), isFalse);
      expect(key.containsKey('passphrase'), isFalse);
      when(
        () => storage.deleteSshKeySecrets('key'),
      ).thenAnswer((_) async => const Err(StorageFailure('delete denied')));
      final imported = await repository.importFromJsonString(
        result.value,
        ImportConflictStrategy.overwrite,
      );
      expect(imported.value.errors, isNotEmpty);
      expect(imported.value.sshKeysImported, 0);
    },
  );
}
