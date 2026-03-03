// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_dao.dart';

// ignore_for_file: type=lint
mixin _$GroupDaoMixin on DatabaseAccessor<AppDatabase> {
  $GroupsTable get groups => attachedDatabase.groups;
  $SshKeysTable get sshKeys => attachedDatabase.sshKeys;
  $ServersTable get servers => attachedDatabase.servers;
  GroupDaoManager get managers => GroupDaoManager(this);
}

class GroupDaoManager {
  final _$GroupDaoMixin _db;
  GroupDaoManager(this._db);
  $$GroupsTableTableManager get groups =>
      $$GroupsTableTableManager(_db.attachedDatabase, _db.groups);
  $$SshKeysTableTableManager get sshKeys =>
      $$SshKeysTableTableManager(_db.attachedDatabase, _db.sshKeys);
  $$ServersTableTableManager get servers =>
      $$ServersTableTableManager(_db.attachedDatabase, _db.servers);
}
