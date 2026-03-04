import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/network/api_provider.dart';
import 'package:shellvault/core/storage/database_provider.dart';
import 'package:shellvault/features/account/presentation/providers/account_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/server_providers.dart';
import 'package:shellvault/features/teleport/data/repositories/teleport_repository_impl.dart';
import 'package:shellvault/features/teleport/data/services/teleport_api_service.dart';
import 'package:shellvault/features/teleport/data/services/teleport_connection_service.dart';
import 'package:shellvault/features/teleport/domain/entities/connection_target.dart';
import 'package:shellvault/features/teleport/domain/entities/teleport_cluster_entity.dart';
import 'package:shellvault/features/teleport/domain/entities/teleport_node_entity.dart';
import 'package:shellvault/features/teleport/domain/repositories/teleport_repository.dart';

// --- Services ---

final teleportApiServiceProvider = Provider<TeleportApiService>((ref) {
  final api = ref.watch(apiClientProvider);
  return TeleportApiService(api);
});

final teleportConnectionServiceProvider = Provider<TeleportConnectionService>((ref) {
  return TeleportConnectionService();
});

// --- Repository ---

final teleportRepositoryProvider = Provider<TeleportRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final api = ref.watch(teleportApiServiceProvider);
  return TeleportRepositoryImpl(dao: db.teleportClusterDao, api: api);
});

// --- Cluster List ---

final teleportClusterListProvider =
    StreamProvider<List<TeleportClusterEntity>>((ref) {
  final repo = ref.watch(teleportRepositoryProvider);
  return repo.watchLocalClusters();
});

// --- Node List (per cluster) ---

final teleportNodeListProvider =
    FutureProvider.family<List<TeleportNodeEntity>, String>((ref, clusterId) async {
  final repo = ref.watch(teleportRepositoryProvider);
  final result = await repo.fetchNodes(clusterId);
  return result.fold(
    onSuccess: (nodes) => nodes,
    onFailure: (_) => [],
  );
});

// --- All Nodes (across all clusters) ---

final teleportAllNodesProvider =
    FutureProvider<List<TeleportNodeEntity>>((ref) async {
  final clustersAsync = ref.watch(teleportClusterListProvider);

  return clustersAsync.when(
    data: (clusters) async {
      final allNodes = <TeleportNodeEntity>[];
      final repo = ref.read(teleportRepositoryProvider);

      for (final cluster in clusters) {
        final result = await repo.fetchNodes(cluster.id);
        result.fold(
          onSuccess: (nodes) {
            for (final node in nodes) {
              allNodes.add(TeleportNodeEntity(
                id: node.id,
                clusterId: cluster.id,
                clusterName: cluster.name,
                hostname: node.hostname,
                addr: node.addr,
                labels: node.labels,
                osType: node.osType,
              ));
            }
          },
          onFailure: (_) {},
        );
      }

      return allNodes;
    },
    loading: () => [],
    error: (_, _) => [],
  );
});

// --- Teleport Unlocked State ---

/// Whether the user has purchased the Teleport addon.
final teleportUnlockedProvider = Provider<bool>((ref) {
  final billing = ref.watch(billingStatusProvider);
  return billing.when(
    data: (status) => status.teleportUnlocked,
    loading: () => false,
    error: (_, _) => false,
  );
});

final teleportHasClustersProvider = Provider<bool>((ref) {
  final clusters = ref.watch(teleportClusterListProvider);
  return clusters.when(
    data: (list) => list.isNotEmpty,
    loading: () => false,
    error: (_, _) => false,
  );
});

// --- Unified Connection Targets ---

/// Combines local servers and Teleport nodes into a single list.
/// Useful for unified search / quick-connect features.
final unifiedConnectionTargetsProvider =
    FutureProvider<List<ConnectionTarget>>((ref) async {
  final servers = ref.watch(serverListProvider).value ?? [];
  final teleportNodes = ref.watch(teleportAllNodesProvider).value ?? [];

  return [
    ...servers.map(LocalServer.new),
    ...teleportNodes.map(TeleportNode.new),
  ];
});
