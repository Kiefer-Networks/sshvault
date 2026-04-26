import 'package:drift/drift.dart';
import 'package:sshvault/core/storage/database.dart';
import 'package:sshvault/features/connection/data/models/drift_tables.dart';

part 'group_dao.g.dart';

@DriftAccessor(tables: [Groups, Servers])
class GroupDao extends DatabaseAccessor<AppDatabase> with _$GroupDaoMixin {
  GroupDao(super.db);

  Future<List<Group>> getAllGroups() =>
      (select(groups)
            ..where((g) => g.deletedAt.isNull())
            ..orderBy([(g) => OrderingTerm.asc(g.sortOrder)]))
          .get();

  Future<List<Group>> getAllGroupsIncludingDeleted() => select(groups).get();

  Future<List<Group>> getDeletedGroups() =>
      (select(groups)..where((g) => g.deletedAt.isNotNull())).get();

  Future<Group?> getGroupById(String id) => (select(
    groups,
  )..where((g) => g.id.equals(id) & g.deletedAt.isNull())).getSingleOrNull();

  Future<Group?> getGroupByIdIncludingDeleted(String id) =>
      (select(groups)..where((g) => g.id.equals(id))).getSingleOrNull();

  Future<List<Group>> getChildGroups(String parentId) => (select(
    groups,
  )..where((g) => g.parentId.equals(parentId) & g.deletedAt.isNull())).get();

  Future<List<Group>> getRootGroups() => (select(
    groups,
  )..where((g) => g.parentId.isNull() & g.deletedAt.isNull())).get();

  Future<int> insertGroup(GroupsCompanion group) => into(groups).insert(group);

  Future<bool> updateGroup(GroupsCompanion group) =>
      update(groups).replace(group);

  /// Soft delete — preserves the row so peers can replicate the deletion.
  Future<int> deleteGroupById(String id) {
    final now = DateTime.now();
    return (update(groups)..where((g) => g.id.equals(id))).write(
      GroupsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  Future<int> hardDeleteGroupById(String id) =>
      (delete(groups)..where((g) => g.id.equals(id))).go();

  Future<int> pruneTombstones(DateTime olderThan) =>
      (delete(groups)..where(
            (g) =>
                g.deletedAt.isNotNull() &
                g.deletedAt.isSmallerThanValue(olderThan),
          ))
          .go();

  Future<int> getServerCountForGroup(String groupId) async {
    final count = countAll();
    final query = selectOnly(servers)
      ..addColumns([count])
      ..where(servers.groupId.equals(groupId) & servers.deletedAt.isNull());
    final result = await query.getSingle();
    return result.read(count)!;
  }
}
