// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_dao.dart';

// ignore_for_file: type=lint
mixin _$ServerDaoMixin on DatabaseAccessor<AppDatabase> {
  $GroupsTable get groups => attachedDatabase.groups;
  $SshKeysTable get sshKeys => attachedDatabase.sshKeys;
  $ServersTable get servers => attachedDatabase.servers;
  $TagsTable get tags => attachedDatabase.tags;
  $ServerTagsTable get serverTags => attachedDatabase.serverTags;
  ServerDaoManager get managers => ServerDaoManager(this);
}

class ServerDaoManager {
  final _$ServerDaoMixin _db;
  ServerDaoManager(this._db);
  $$GroupsTableTableManager get groups =>
      $$GroupsTableTableManager(_db.attachedDatabase, _db.groups);
  $$SshKeysTableTableManager get sshKeys =>
      $$SshKeysTableTableManager(_db.attachedDatabase, _db.sshKeys);
  $$ServersTableTableManager get servers =>
      $$ServersTableTableManager(_db.attachedDatabase, _db.servers);
  $$TagsTableTableManager get tags =>
      $$TagsTableTableManager(_db.attachedDatabase, _db.tags);
  $$ServerTagsTableTableManager get serverTags =>
      $$ServerTagsTableTableManager(_db.attachedDatabase, _db.serverTags);
}
