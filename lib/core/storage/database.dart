import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/features/connection/data/models/drift_tables.dart';
import 'package:shellvault/features/connection/data/datasources/server_dao.dart';
import 'package:shellvault/features/connection/data/datasources/ssh_key_dao.dart';
import 'package:shellvault/features/connection/data/datasources/group_dao.dart';
import 'package:shellvault/features/connection/data/datasources/tag_dao.dart';
import 'package:shellvault/features/settings/data/datasources/app_settings_dao.dart';
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
  ],
  daos: [ServerDao, SshKeyDao, GroupDao, TagDao, AppSettingsDao, SnippetDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => AppConstants.databaseVersion;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: AppConstants.databaseName);
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
      },
    );
  }
}
