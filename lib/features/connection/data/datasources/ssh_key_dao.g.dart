// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ssh_key_dao.dart';

// ignore_for_file: type=lint
mixin _$SshKeyDaoMixin on DatabaseAccessor<AppDatabase> {
  $SshKeysTable get sshKeys => attachedDatabase.sshKeys;
  $GroupsTable get groups => attachedDatabase.groups;
  $ServersTable get servers => attachedDatabase.servers;
  SshKeyDaoManager get managers => SshKeyDaoManager(this);
}

class SshKeyDaoManager {
  final _$SshKeyDaoMixin _db;
  SshKeyDaoManager(this._db);
  $$SshKeysTableTableManager get sshKeys =>
      $$SshKeysTableTableManager(_db.attachedDatabase, _db.sshKeys);
  $$GroupsTableTableManager get groups =>
      $$GroupsTableTableManager(_db.attachedDatabase, _db.groups);
  $$ServersTableTableManager get servers =>
      $$ServersTableTableManager(_db.attachedDatabase, _db.servers);
}
