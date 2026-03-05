// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'known_host_dao.dart';

// ignore_for_file: type=lint
mixin _$KnownHostDaoMixin on DatabaseAccessor<AppDatabase> {
  $KnownHostsTable get knownHosts => attachedDatabase.knownHosts;
  KnownHostDaoManager get managers => KnownHostDaoManager(this);
}

class KnownHostDaoManager {
  final _$KnownHostDaoMixin _db;
  KnownHostDaoManager(this._db);
  $$KnownHostsTableTableManager get knownHosts =>
      $$KnownHostsTableTableManager(_db.attachedDatabase, _db.knownHosts);
}
