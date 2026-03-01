import 'package:drift/drift.dart';
import 'package:shellvault/core/storage/database.dart';
import 'package:shellvault/features/connection/data/models/drift_tables.dart';

part 'tag_dao.g.dart';

@DriftAccessor(tables: [Tags, ServerTags])
class TagDao extends DatabaseAccessor<AppDatabase> with _$TagDaoMixin {
  TagDao(super.db);

  Future<List<Tag>> getAllTags() =>
      (select(tags)..orderBy([(t) => OrderingTerm.asc(t.name)])).get();

  Future<Tag?> getTagById(String id) =>
      (select(tags)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertTag(TagsCompanion tag) => into(tags).insert(tag);

  Future<bool> updateTag(TagsCompanion tag) => update(tags).replace(tag);

  Future<int> deleteTagById(String id) async {
    await (delete(serverTags)..where((st) => st.tagId.equals(id))).go();
    return (delete(tags)..where((t) => t.id.equals(id))).go();
  }
}
