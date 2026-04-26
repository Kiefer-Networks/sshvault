import 'package:drift/drift.dart';
import 'package:sshvault/core/storage/database.dart';
import 'package:sshvault/features/connection/data/models/drift_tables.dart';

part 'server_dao.g.dart';

@DriftAccessor(tables: [Servers, ServerTags, Tags])
class ServerDao extends DatabaseAccessor<AppDatabase> with _$ServerDaoMixin {
  ServerDao(super.db);

  static String _escapeLike(String input) => input
      .replaceAll('\\', '\\\\')
      .replaceAll('%', '\\%')
      .replaceAll('_', '\\_');

  Future<List<Server>> getAllServers() =>
      (select(servers)..where((s) => s.deletedAt.isNull())).get();

  /// Includes tombstones — used by the sync layer to push deletions.
  Future<List<Server>> getAllServersIncludingDeleted() =>
      select(servers).get();

  Future<List<Server>> getDeletedServers() =>
      (select(servers)..where((s) => s.deletedAt.isNotNull())).get();

  Future<Server?> getServerById(String id) => (select(servers)..where(
    (s) => s.id.equals(id) & s.deletedAt.isNull(),
  )).getSingleOrNull();

  /// Returns the row even if soft-deleted. The sync layer needs to see
  /// tombstones to apply LWW correctly.
  Future<Server?> getServerByIdIncludingDeleted(String id) =>
      (select(servers)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<List<Server>> getServersByGroupId(String groupId) =>
      (select(servers)..where(
            (s) => s.groupId.equals(groupId) & s.deletedAt.isNull(),
          ))
          .get();

  Future<List<Server>> getServersBySshKeyId(String sshKeyId) =>
      (select(servers)..where(
            (s) => s.sshKeyId.equals(sshKeyId) & s.deletedAt.isNull(),
          ))
          .get();

  Future<List<Server>> searchServers(String query) {
    final escaped = _escapeLike(query);
    return (select(servers)..where(
          (s) =>
              s.deletedAt.isNull() &
              (s.name.like('%$escaped%') |
                  s.hostname.like('%$escaped%') |
                  s.username.like('%$escaped%') |
                  s.notes.like('%$escaped%')),
        ))
        .get();
  }

  Future<List<Server>> getFilteredServers({
    String? searchQuery,
    String? groupId,
    List<String>? groupIds,
    List<String>? tagIds,
    bool? isActive,
  }) async {
    var query = select(servers)..where((s) => s.deletedAt.isNull());

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final escaped = _escapeLike(searchQuery);
      query = query
        ..where(
          (s) =>
              s.name.like('%$escaped%') |
              s.hostname.like('%$escaped%') |
              s.username.like('%$escaped%'),
        );
    }

    if (groupIds != null && groupIds.isNotEmpty) {
      query = query..where((s) => s.groupId.isIn(groupIds));
    } else if (groupId != null) {
      query = query..where((s) => s.groupId.equals(groupId));
    }

    if (isActive != null) {
      query = query..where((s) => s.isActive.equals(isActive));
    }

    query = query..orderBy([(s) => OrderingTerm.asc(s.sortOrder)]);

    var results = await query.get();

    if (tagIds != null && tagIds.isNotEmpty) {
      final serverIdsWithTags = await (select(
        serverTags,
      )..where((st) => st.tagId.isIn(tagIds))).get();
      final matchingServerIds = serverIdsWithTags
          .map((st) => st.serverId)
          .toSet();
      results = results.where((s) => matchingServerIds.contains(s.id)).toList();
    }

    return results;
  }

  Future<int> insertServer(ServersCompanion server) =>
      into(servers).insert(server);

  Future<bool> updateServer(ServersCompanion server) =>
      update(servers).replace(server);

  /// Soft-delete: marks the server as deleted so the deletion can be
  /// replicated through sync. Use [hardDeleteServerById] to actually
  /// remove the row (e.g. tombstone pruning, local-only purge).
  Future<int> deleteServerById(String id) {
    final now = DateTime.now();
    return (update(servers)..where((s) => s.id.equals(id))).write(
      ServersCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
        isActive: const Value(false),
      ),
    );
  }

  Future<int> hardDeleteServerById(String id) =>
      (delete(servers)..where((s) => s.id.equals(id))).go();

  /// Purges tombstones older than [olderThan]. Returns purged row count.
  Future<int> pruneTombstones(DateTime olderThan) => (delete(servers)..where(
    (s) => s.deletedAt.isNotNull() & s.deletedAt.isSmallerThanValue(olderThan),
  )).go();

  Future<void> setServerTags(String serverId, List<String> tagIds) async {
    await (delete(
      serverTags,
    )..where((st) => st.serverId.equals(serverId))).go();
    for (final tagId in tagIds) {
      await into(
        serverTags,
      ).insert(ServerTagsCompanion.insert(serverId: serverId, tagId: tagId));
    }
  }

  Future<List<Tag>> getTagsForServer(String serverId) async {
    final query = select(serverTags).join([
      innerJoin(tags, tags.id.equalsExp(serverTags.tagId)),
    ])..where(serverTags.serverId.equals(serverId));

    final rows = await query.get();
    return rows.map((row) => row.readTable(tags)).toList();
  }

  Future<void> setFavorite(String id, bool favorite) =>
      (update(servers)..where((s) => s.id.equals(id))).write(
        ServersCompanion(isFavorite: Value(favorite)),
      );

  Future<void> setLastConnectedAt(String id, DateTime time) =>
      (update(servers)..where((s) => s.id.equals(id))).write(
        ServersCompanion(lastConnectedAt: Value(time)),
      );

  Future<List<Server>> getFavoriteServers() =>
      (select(servers)
            ..where(
              (s) => s.isFavorite.equals(true) & s.deletedAt.isNull(),
            )
            ..orderBy([(s) => OrderingTerm.asc(s.sortOrder)]))
          .get();

  Future<List<Server>> getRecentServers({int limit = 5}) =>
      (select(servers)
            ..where(
              (s) => s.lastConnectedAt.isNotNull() & s.deletedAt.isNull(),
            )
            ..orderBy([(s) => OrderingTerm.desc(s.lastConnectedAt)])
            ..limit(limit))
          .get();

  Future<void> updateSortOrders(Map<String, int> idToOrder) async {
    await batch((batch) {
      for (final entry in idToOrder.entries) {
        batch.update(
          servers,
          ServersCompanion(sortOrder: Value(entry.value)),
          where: (s) => s.id.equals(entry.key),
        );
      }
    });
  }
}
