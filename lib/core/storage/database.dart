import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/features/connection/data/models/drift_tables.dart';
import 'package:shellvault/features/connection/data/datasources/server_dao.dart';
import 'package:shellvault/features/connection/data/datasources/ssh_key_dao.dart';
import 'package:shellvault/features/connection/data/datasources/group_dao.dart';
import 'package:shellvault/features/connection/data/datasources/tag_dao.dart';
import 'package:shellvault/features/host_key/data/datasources/known_host_dao.dart';
import 'package:shellvault/features/settings/data/datasources/app_settings_dao.dart';
import 'package:shellvault/features/sftp/data/datasources/sftp_bookmark_dao.dart';
import 'package:shellvault/features/snippet/data/datasources/snippet_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    SshKeys,
    Servers,
    Groups,
    Tags,
    ServerTags,
    Snippets,
    SnippetTags,
    SnippetVariables,
    AppSettings,
    KnownHosts,
    SftpBookmarks,
  ],
  daos: [
    ServerDao,
    SshKeyDao,
    GroupDao,
    TagDao,
    AppSettingsDao,
    SnippetDao,
    KnownHostDao,
    SftpBookmarkDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => AppConstants.databaseVersion;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: AppConstants.databaseName);
  }

  /// Migrate database from Documents to Application Support on iOS/macOS.
  /// Must be called before opening the database for the first time.
  static Future<void> migrateDbLocationIfNeeded() async {
    if (!Platform.isIOS && !Platform.isMacOS) return;

    final documentsDir = await getApplicationDocumentsDirectory();
    final supportDir = await getApplicationSupportDirectory();
    const dbName = '${AppConstants.databaseName}.sqlite';

    final oldPath = p.join(documentsDir.path, dbName);
    final newPath = p.join(supportDir.path, dbName);

    final oldFile = File(oldPath);
    if (await oldFile.exists() && !await File(newPath).exists()) {
      await oldFile.copy(newPath);
      await oldFile.delete();
      // Also migrate WAL/SHM if present
      for (final suffix in ['-wal', '-shm']) {
        final old = File('$oldPath$suffix');
        if (await old.exists()) {
          await old.copy('$newPath$suffix');
          await old.delete();
        }
      }
    }
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(sshKeys);
          await m.addColumn(servers, servers.sshKeyId);
        }
        if (from < 3) {
          await m.createTable(snippets);
          await m.createTable(snippetTags);
          await m.createTable(snippetVariables);
        }
        if (from < 4) {
          await m.addColumn(servers, servers.distroId);
          await m.addColumn(servers, servers.distroName);
        }
        if (from < 5) {
          await m.addColumn(servers, servers.jumpHostId);
        }
        if (from < 7) {
          await m.addColumn(servers, servers.proxyType);
          await m.addColumn(servers, servers.proxyHost);
          await m.addColumn(servers, servers.proxyPort);
          await m.addColumn(servers, servers.proxyUsername);
          await m.addColumn(servers, servers.useGlobalProxy);
          await m.addColumn(servers, servers.requiresVpn);
        }
        if (from < 8) {
          await m.addColumn(servers, servers.postConnectCommands);
          await m.addColumn(servers, servers.isFavorite);
          await m.addColumn(servers, servers.lastConnectedAt);
        }
        if (from < 9) {
          await m.createTable(knownHosts);
        }
        if (from < 10) {
          await m.createTable(sftpBookmarks);
        }
      },
    );
  }

  Future<void> deleteAllData() async {
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }
}
