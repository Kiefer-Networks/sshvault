// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teleport_cluster_dao.dart';

// ignore_for_file: type=lint
mixin _$TeleportClusterDaoMixin on DatabaseAccessor<AppDatabase> {
  $TeleportClustersTable get teleportClusters =>
      attachedDatabase.teleportClusters;
  TeleportClusterDaoManager get managers => TeleportClusterDaoManager(this);
}

class TeleportClusterDaoManager {
  final _$TeleportClusterDaoMixin _db;
  TeleportClusterDaoManager(this._db);
  $$TeleportClustersTableTableManager get teleportClusters =>
      $$TeleportClustersTableTableManager(
        _db.attachedDatabase,
        _db.teleportClusters,
      );
}
