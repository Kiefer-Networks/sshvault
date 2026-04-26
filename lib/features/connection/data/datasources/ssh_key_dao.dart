import 'package:drift/drift.dart';
import 'package:sshvault/core/storage/database.dart';
import 'package:sshvault/features/connection/data/models/drift_tables.dart';

part 'ssh_key_dao.g.dart';

@DriftAccessor(tables: [SshKeys, Servers])
class SshKeyDao extends DatabaseAccessor<AppDatabase> with _$SshKeyDaoMixin {
  SshKeyDao(super.db);

  Future<List<SshKey>> getAllSshKeys() =>
      (select(sshKeys)..where((k) => k.deletedAt.isNull())).get();

  Future<List<SshKey>> getAllSshKeysIncludingDeleted() =>
      select(sshKeys).get();

  Future<List<SshKey>> getDeletedSshKeys() =>
      (select(sshKeys)..where((k) => k.deletedAt.isNotNull())).get();

  Future<SshKey?> getSshKeyById(String id) => (select(sshKeys)..where(
    (k) => k.id.equals(id) & k.deletedAt.isNull(),
  )).getSingleOrNull();

  Future<SshKey?> getSshKeyByIdIncludingDeleted(String id) =>
      (select(sshKeys)..where((k) => k.id.equals(id))).getSingleOrNull();

  Future<SshKey?> getSshKeyByFingerprint(String fingerprint) async {
    final rows =
        await (select(sshKeys)
              ..where(
                (k) =>
                    k.fingerprint.equals(fingerprint) & k.deletedAt.isNull(),
              )
              ..limit(1))
            .get();
    return rows.isEmpty ? null : rows.first;
  }

  Future<SshKey?> getSshKeyByPublicKey(String publicKey) async {
    final rows =
        await (select(sshKeys)
              ..where(
                (k) => k.publicKey.equals(publicKey) & k.deletedAt.isNull(),
              )
              ..limit(1))
            .get();
    return rows.isEmpty ? null : rows.first;
  }

  Future<int> insertSshKey(SshKeysCompanion key) => into(sshKeys).insert(key);

  Future<bool> updateSshKey(SshKeysCompanion key) =>
      update(sshKeys).replace(key);

  Future<int> deleteSshKeyById(String id) {
    final now = DateTime.now();
    return (update(sshKeys)..where((k) => k.id.equals(id))).write(
      SshKeysCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  Future<int> hardDeleteSshKeyById(String id) =>
      (delete(sshKeys)..where((k) => k.id.equals(id))).go();

  Future<int> pruneTombstones(DateTime olderThan) => (delete(sshKeys)..where(
    (k) => k.deletedAt.isNotNull() & k.deletedAt.isSmallerThanValue(olderThan),
  )).go();

  Future<List<Server>> getServersUsingSshKey(String sshKeyId) =>
      (select(servers)..where(
            (s) => s.sshKeyId.equals(sshKeyId) & s.deletedAt.isNull(),
          ))
          .get();

  Future<int> countServersUsingSshKey(String sshKeyId) async {
    final count = countAll();
    final query = selectOnly(servers)
      ..addColumns([count])
      ..where(servers.sshKeyId.equals(sshKeyId) & servers.deletedAt.isNull());
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }
}
