import 'package:drift/drift.dart';
import 'package:shellvault/core/storage/database.dart';
import 'package:shellvault/features/connection/data/models/drift_tables.dart';

part 'ssh_key_dao.g.dart';

@DriftAccessor(tables: [SshKeys, Servers])
class SshKeyDao extends DatabaseAccessor<AppDatabase> with _$SshKeyDaoMixin {
  SshKeyDao(super.db);

  Future<List<SshKey>> getAllSshKeys() => select(sshKeys).get();

  Future<SshKey?> getSshKeyById(String id) =>
      (select(sshKeys)..where((k) => k.id.equals(id))).getSingleOrNull();

  Future<int> insertSshKey(SshKeysCompanion key) => into(sshKeys).insert(key);

  Future<bool> updateSshKey(SshKeysCompanion key) =>
      update(sshKeys).replace(key);

  Future<int> deleteSshKeyById(String id) =>
      (delete(sshKeys)..where((k) => k.id.equals(id))).go();

  Future<List<Server>> getServersUsingSshKey(String sshKeyId) =>
      (select(servers)..where((s) => s.sshKeyId.equals(sshKeyId))).get();

  Future<int> countServersUsingSshKey(String sshKeyId) async {
    final count = countAll();
    final query = selectOnly(servers)
      ..addColumns([count])
      ..where(servers.sshKeyId.equals(sshKeyId));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }
}
