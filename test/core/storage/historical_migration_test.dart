import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sshvault/core/storage/database.dart';

void main() {
  for (final oldVersion in [1, 2]) {
    test(
      'schema v$oldVersion upgrades without adding new-table columns twice',
      () async {
        final db = AppDatabase(NativeDatabase.memory());
        addTearDown(db.close);
        // Strip a generated schema to the shape predating the additive
        // migrations. Invoke the actual migration callback against SQLite.
        await db.customSelect('SELECT 1').get();
        for (final table in [
          'snippet_variables',
          'snippet_tags',
          'snippets',
          'known_hosts',
          'sftp_bookmarks',
        ]) {
          await db.customStatement('DROP TABLE $table');
        }
        if (oldVersion == 1) {
          await db.customStatement('DROP TABLE ssh_keys');
          await db.customStatement(
            'ALTER TABLE servers DROP COLUMN ssh_key_id',
          );
        } else {
          await db.customStatement(
            'ALTER TABLE ssh_keys DROP COLUMN deleted_at',
          );
        }
        for (final column in [
          'distro_id',
          'distro_name',
          'jump_host_id',
          'proxy_type',
          'proxy_host',
          'proxy_port',
          'proxy_username',
          'use_global_proxy',
          'requires_vpn',
          'post_connect_commands',
          'is_favorite',
          'last_connected_at',
        ]) {
          await db.customStatement('ALTER TABLE servers DROP COLUMN $column');
        }
        for (final table in ['servers', 'groups', 'tags']) {
          await db.customStatement('ALTER TABLE $table DROP COLUMN deleted_at');
        }
        await db.customStatement(
          "INSERT INTO groups(id, name, color, icon_name, sort_order, created_at, updated_at) VALUES ('preserved', 'Existing', 1, 'folder', 0, '2026-01-01T00:00:00.000Z', '2026-01-01T00:00:00.000Z')",
        );
        await db.migration.onUpgrade(Migrator(db), oldVersion, 11);
        expect((await db.groupDao.getAllGroups()).single.name, 'Existing');
        expect(await db.sshKeyDao.getAllSshKeys(), isEmpty);
        expect(await db.snippetDao.getAllSnippets(), isEmpty);
      },
    );
  }
}
