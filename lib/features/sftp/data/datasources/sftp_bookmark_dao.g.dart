// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sftp_bookmark_dao.dart';

// ignore_for_file: type=lint
mixin _$SftpBookmarkDaoMixin on DatabaseAccessor<AppDatabase> {
  $GroupsTable get groups => attachedDatabase.groups;
  $SshKeysTable get sshKeys => attachedDatabase.sshKeys;
  $ServersTable get servers => attachedDatabase.servers;
  $SftpBookmarksTable get sftpBookmarks => attachedDatabase.sftpBookmarks;
  SftpBookmarkDaoManager get managers => SftpBookmarkDaoManager(this);
}

class SftpBookmarkDaoManager {
  final _$SftpBookmarkDaoMixin _db;
  SftpBookmarkDaoManager(this._db);
  $$GroupsTableTableManager get groups =>
      $$GroupsTableTableManager(_db.attachedDatabase, _db.groups);
  $$SshKeysTableTableManager get sshKeys =>
      $$SshKeysTableTableManager(_db.attachedDatabase, _db.sshKeys);
  $$ServersTableTableManager get servers =>
      $$ServersTableTableManager(_db.attachedDatabase, _db.servers);
  $$SftpBookmarksTableTableManager get sftpBookmarks =>
      $$SftpBookmarksTableTableManager(_db.attachedDatabase, _db.sftpBookmarks);
}
