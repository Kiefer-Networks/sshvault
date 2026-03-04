import 'dart:typed_data';

import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/teleport/data/services/teleport_api_service.dart';
import 'package:shellvault/features/teleport/domain/entities/teleport_cluster_entity.dart';
import 'package:shellvault/features/teleport/domain/entities/teleport_node_entity.dart';

abstract class TeleportRepository {
  // --- Local (Drift) ---
  Future<List<TeleportClusterEntity>> getLocalClusters();
  Stream<List<TeleportClusterEntity>> watchLocalClusters();
  Future<void> saveClusterLocally(TeleportClusterEntity cluster);
  Future<void> deleteClusterLocally(String id);
  Future<void> updateCertExpiry(String id, DateTime? expiresAt);

  // --- Remote (API) ---
  Future<Result<TeleportClusterEntity>> registerCluster({
    required String name,
    required String proxyAddr,
    required String authMethod,
    Uint8List? identity,
  });
  Future<Result<List<TeleportClusterEntity>>> fetchClusters();
  Future<Result<void>> deleteCluster(String id);
  Future<Result<void>> login({
    required String clusterId,
    String? username,
    String? password,
    String? otpToken,
  });
  Future<Result<List<TeleportNodeEntity>>> fetchNodes(String clusterId);
  Future<Result<TeleportCertificates>> generateCerts({
    required String clusterId,
    String? username,
    String? ttl,
  });
}
