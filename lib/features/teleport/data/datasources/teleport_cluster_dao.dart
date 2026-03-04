import 'package:drift/drift.dart';
import 'package:shellvault/core/storage/database.dart';
import 'package:shellvault/features/teleport/data/models/teleport_drift_tables.dart';

part 'teleport_cluster_dao.g.dart';

@DriftAccessor(tables: [TeleportClusters])
class TeleportClusterDao extends DatabaseAccessor<AppDatabase>
    with _$TeleportClusterDaoMixin {
  TeleportClusterDao(super.db);

  Future<List<TeleportCluster>> getAllClusters() =>
      select(teleportClusters).get();

  Stream<List<TeleportCluster>> watchAllClusters() =>
      select(teleportClusters).watch();

  Future<TeleportCluster?> getClusterById(String id) =>
      (select(teleportClusters)..where((c) => c.id.equals(id)))
          .getSingleOrNull();

  Future<int> insertCluster(TeleportClustersCompanion cluster) =>
      into(teleportClusters).insert(cluster);

  Future<bool> updateCluster(TeleportClustersCompanion cluster) =>
      update(teleportClusters).replace(cluster);

  Future<int> deleteClusterById(String id) =>
      (delete(teleportClusters)..where((c) => c.id.equals(id))).go();

  Future<void> updateCertExpiry(String id, DateTime? expiresAt) {
    return (update(teleportClusters)..where((c) => c.id.equals(id))).write(
      TeleportClustersCompanion(
        certExpiresAt: Value(expiresAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
