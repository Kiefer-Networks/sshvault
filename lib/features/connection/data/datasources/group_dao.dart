import 'package:drift/drift.dart';
import 'package:shellvault/core/storage/database.dart';
import 'package:shellvault/features/connection/data/models/drift_tables.dart';

part 'group_dao.g.dart';

@DriftAccessor(tables: [Groups, Servers])
class GroupDao extends DatabaseAccessor<AppDatabase> with _$GroupDaoMixin {
  GroupDao(super.db);

  Future<List<Group>> getAllGroups() =>
      (select(groups)..orderBy([(g) => OrderingTerm.asc(g.sortOrder)])).get();

  Future<Group?> getGroupById(String id) =>
      (select(groups)..where((g) => g.id.equals(id))).getSingleOrNull();

  Future<List<Group>> getChildGroups(String parentId) =>
      (select(groups)..where((g) => g.parentId.equals(parentId))).get();

  Future<List<Group>> getRootGroups() =>
      (select(groups)..where((g) => g.parentId.isNull())).get();

  Future<int> insertGroup(GroupsCompanion group) => into(groups).insert(group);

  Future<bool> updateGroup(GroupsCompanion group) =>
      update(groups).replace(group);

  Future<int> deleteGroupById(String id) =>
      (delete(groups)..where((g) => g.id.equals(id))).go();

  Future<int> getServerCountForGroup(String groupId) async {
    final count = countAll();
    final query = selectOnly(servers)
      ..addColumns([count])
      ..where(servers.groupId.equals(groupId));
    final result = await query.getSingle();
    return result.read(count)!;
  }
}
