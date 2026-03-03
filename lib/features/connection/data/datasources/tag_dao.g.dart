// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_dao.dart';

// ignore_for_file: type=lint
mixin _$TagDaoMixin on DatabaseAccessor<AppDatabase> {
  $TagsTable get tags => attachedDatabase.tags;
  $GroupsTable get groups => attachedDatabase.groups;
  $SshKeysTable get sshKeys => attachedDatabase.sshKeys;
  $ServersTable get servers => attachedDatabase.servers;
  $ServerTagsTable get serverTags => attachedDatabase.serverTags;
  TagDaoManager get managers => TagDaoManager(this);
}

class TagDaoManager {
  final _$TagDaoMixin _db;
  TagDaoManager(this._db);
  $$TagsTableTableManager get tags =>
      $$TagsTableTableManager(_db.attachedDatabase, _db.tags);
  $$GroupsTableTableManager get groups =>
      $$GroupsTableTableManager(_db.attachedDatabase, _db.groups);
  $$SshKeysTableTableManager get sshKeys =>
      $$SshKeysTableTableManager(_db.attachedDatabase, _db.sshKeys);
  $$ServersTableTableManager get servers =>
      $$ServersTableTableManager(_db.attachedDatabase, _db.servers);
  $$ServerTagsTableTableManager get serverTags =>
      $$ServerTagsTableTableManager(_db.attachedDatabase, _db.serverTags);
}
