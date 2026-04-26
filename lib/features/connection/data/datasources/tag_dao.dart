import 'package:drift/drift.dart';
import 'package:sshvault/core/storage/database.dart';
import 'package:sshvault/features/connection/data/models/drift_tables.dart';

part 'tag_dao.g.dart';

@DriftAccessor(tables: [Tags, ServerTags])
class TagDao extends DatabaseAccessor<AppDatabase> with _$TagDaoMixin {
  TagDao(super.db);

  Future<List<Tag>> getAllTags() =>
      (select(tags)
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .get();

  Future<List<Tag>> getAllTagsIncludingDeleted() => select(tags).get();

  Future<List<Tag>> getDeletedTags() =>
      (select(tags)..where((t) => t.deletedAt.isNotNull())).get();

  Future<Tag?> getTagById(String id) => (select(tags)..where(
    (t) => t.id.equals(id) & t.deletedAt.isNull(),
  )).getSingleOrNull();

  Future<Tag?> getTagByIdIncludingDeleted(String id) =>
      (select(tags)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertTag(TagsCompanion tag) => into(tags).insert(tag);

  Future<bool> updateTag(TagsCompanion tag) => update(tags).replace(tag);

  /// Soft delete + cascade-detach from servers. Join rows are removed
  /// outright since they are reconstructable from the surviving tag once
  /// it is restored or skipped.
  Future<int> deleteTagById(String id) async {
    await (delete(serverTags)..where((st) => st.tagId.equals(id))).go();
    final now = DateTime.now();
    return (update(tags)..where((t) => t.id.equals(id))).write(
      TagsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  Future<int> hardDeleteTagById(String id) async {
    await (delete(serverTags)..where((st) => st.tagId.equals(id))).go();
    return (delete(tags)..where((t) => t.id.equals(id))).go();
  }

  Future<int> pruneTombstones(DateTime olderThan) => (delete(tags)..where(
    (t) => t.deletedAt.isNotNull() & t.deletedAt.isSmallerThanValue(olderThan),
  )).go();
}
