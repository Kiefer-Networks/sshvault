import 'package:drift/drift.dart';
import 'package:shellvault/core/storage/database.dart';
import 'package:shellvault/features/connection/data/models/drift_tables.dart';

part 'snippet_dao.g.dart';

@DriftAccessor(tables: [Snippets, SnippetTags, SnippetVariables, Tags])
class SnippetDao extends DatabaseAccessor<AppDatabase> with _$SnippetDaoMixin {
  SnippetDao(super.db);

  static String _escapeLike(String input) => input
      .replaceAll('\\', '\\\\')
      .replaceAll('%', '\\%')
      .replaceAll('_', '\\_');

  Future<List<Snippet>> getAllSnippets() =>
      (select(snippets)..orderBy([(s) => OrderingTerm.asc(s.sortOrder)])).get();

  Future<Snippet?> getSnippetById(String id) =>
      (select(snippets)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<List<Snippet>> getSnippetsByGroupId(String groupId) =>
      (select(snippets)
            ..where((s) => s.groupId.equals(groupId))
            ..orderBy([(s) => OrderingTerm.asc(s.sortOrder)]))
          .get();

  Future<List<Snippet>> getFilteredSnippets({
    String? searchQuery,
    String? groupId,
    List<String>? tagIds,
    String? language,
  }) async {
    var query = select(snippets);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final escaped = _escapeLike(searchQuery);
      query = query
        ..where(
          (s) =>
              s.name.like('%$escaped%') |
              s.content.like('%$escaped%') |
              s.description.like('%$escaped%'),
        );
    }

    if (groupId != null) {
      query = query..where((s) => s.groupId.equals(groupId));
    }

    if (language != null && language.isNotEmpty) {
      query = query..where((s) => s.language.equals(language));
    }

    query = query..orderBy([(s) => OrderingTerm.asc(s.sortOrder)]);

    var results = await query.get();

    if (tagIds != null && tagIds.isNotEmpty) {
      final snippetIdsWithTags = await (select(
        snippetTags,
      )..where((st) => st.tagId.isIn(tagIds))).get();
      final matchingIds = snippetIdsWithTags.map((st) => st.snippetId).toSet();
      results = results.where((s) => matchingIds.contains(s.id)).toList();
    }

    return results;
  }

  Future<int> insertSnippet(SnippetsCompanion snippet) =>
      into(snippets).insert(snippet);

  Future<bool> updateSnippet(SnippetsCompanion snippet) =>
      update(snippets).replace(snippet);

  Future<int> deleteSnippetById(String id) async {
    await (delete(snippetTags)..where((st) => st.snippetId.equals(id))).go();
    await (delete(
      snippetVariables,
    )..where((sv) => sv.snippetId.equals(id))).go();
    return (delete(snippets)..where((s) => s.id.equals(id))).go();
  }

  Future<List<Tag>> getTagsForSnippet(String snippetId) async {
    final query = select(snippetTags).join([
      innerJoin(tags, tags.id.equalsExp(snippetTags.tagId)),
    ])..where(snippetTags.snippetId.equals(snippetId));

    final rows = await query.get();
    return rows.map((row) => row.readTable(tags)).toList();
  }

  Future<void> setSnippetTags(String snippetId, List<String> tagIds) async {
    await (delete(
      snippetTags,
    )..where((st) => st.snippetId.equals(snippetId))).go();
    for (final tagId in tagIds) {
      await into(
        snippetTags,
      ).insert(SnippetTagsCompanion.insert(snippetId: snippetId, tagId: tagId));
    }
  }

  Future<List<SnippetVariable>> getAllSnippetVariables() =>
      select(snippetVariables).get();

  Future<List<SnippetVariable>> getVariablesForSnippet(String snippetId) =>
      (select(snippetVariables)
            ..where((sv) => sv.snippetId.equals(snippetId))
            ..orderBy([(sv) => OrderingTerm.asc(sv.sortOrder)]))
          .get();

  Future<void> setSnippetVariables(
    String snippetId,
    List<SnippetVariablesCompanion> variables,
  ) async {
    await (delete(
      snippetVariables,
    )..where((sv) => sv.snippetId.equals(snippetId))).go();
    for (final variable in variables) {
      await into(snippetVariables).insert(variable);
    }
  }
}
