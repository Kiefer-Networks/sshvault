import 'package:drift/drift.dart';
import 'package:sshvault/core/storage/database.dart';
import 'package:sshvault/features/connection/data/models/drift_tables.dart';

part 'sftp_bookmark_dao.g.dart';

@DriftAccessor(tables: [SftpBookmarks])
class SftpBookmarkDao extends DatabaseAccessor<AppDatabase>
    with _$SftpBookmarkDaoMixin {
  SftpBookmarkDao(super.db);

  Future<List<SftpBookmark>> getByServerId(String serverId) =>
      (select(sftpBookmarks)
            ..where((t) => t.serverId.equals(serverId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<int> insertBookmark(SftpBookmarksCompanion bookmark) =>
      into(sftpBookmarks).insert(bookmark);

  Future<int> deleteById(String id) =>
      (delete(sftpBookmarks)..where((t) => t.id.equals(id))).go();

  Future<int> deleteByServerId(String serverId) =>
      (delete(sftpBookmarks)..where((t) => t.serverId.equals(serverId))).go();
}
