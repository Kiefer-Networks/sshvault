// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snippet_dao.dart';

// ignore_for_file: type=lint
mixin _$SnippetDaoMixin on DatabaseAccessor<AppDatabase> {
  $GroupsTable get groups => attachedDatabase.groups;
  $SnippetsTable get snippets => attachedDatabase.snippets;
  $TagsTable get tags => attachedDatabase.tags;
  $SnippetTagsTable get snippetTags => attachedDatabase.snippetTags;
  $SnippetVariablesTable get snippetVariables =>
      attachedDatabase.snippetVariables;
  SnippetDaoManager get managers => SnippetDaoManager(this);
}

class SnippetDaoManager {
  final _$SnippetDaoMixin _db;
  SnippetDaoManager(this._db);
  $$GroupsTableTableManager get groups =>
      $$GroupsTableTableManager(_db.attachedDatabase, _db.groups);
  $$SnippetsTableTableManager get snippets =>
      $$SnippetsTableTableManager(_db.attachedDatabase, _db.snippets);
  $$TagsTableTableManager get tags =>
      $$TagsTableTableManager(_db.attachedDatabase, _db.tags);
  $$SnippetTagsTableTableManager get snippetTags =>
      $$SnippetTagsTableTableManager(_db.attachedDatabase, _db.snippetTags);
  $$SnippetVariablesTableTableManager get snippetVariables =>
      $$SnippetVariablesTableTableManager(
        _db.attachedDatabase,
        _db.snippetVariables,
      );
}
