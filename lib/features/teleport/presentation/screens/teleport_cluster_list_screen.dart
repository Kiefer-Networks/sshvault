import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/features/teleport/presentation/providers/teleport_providers.dart';
import 'package:shellvault/features/teleport/presentation/widgets/teleport_cert_status.dart';
import 'package:shellvault/features/teleport/presentation/widgets/teleport_node_tile.dart';

class TeleportBranchScreen extends ConsumerWidget {
  const TeleportBranchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clustersAsync = ref.watch(teleportClusterListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teleport'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add cluster',
            onPressed: () => context.push('/teleport/cluster/new'),
          ),
        ],
      ),
      body: clustersAsync.when(
        data: (clusters) {
          if (clusters.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cloud_outlined,
                    size: 64,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Teleport clusters',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add a cluster to see your SSH nodes',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => context.push('/teleport/cluster/new'),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Cluster'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: clusters.length,
            itemBuilder: (context, index) {
              final cluster = clusters[index];
              final nodesAsync = ref.watch(teleportNodeListProvider(cluster.id));

              return ExpansionTile(
                leading: const Icon(Icons.cloud),
                title: Text(cluster.name),
                subtitle: Row(
                  children: [
                    Text(
                      cluster.proxyAddr,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: 8),
                    TeleportCertStatus(expiresAt: cluster.certExpiresAt),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => context.push('/teleport/cluster/${cluster.id}'),
                ),
                children: nodesAsync.when(
                  data: (nodes) {
                    if (nodes.isEmpty) {
                      return [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'No nodes available',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ];
                    }
                    return nodes.map((node) {
                      return TeleportNodeTile(
                        node: node,
                        onTap: () {
                          // TODO: Open terminal session to Teleport node
                        },
                      );
                    }).toList();
                  },
                  loading: () => [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ],
                  error: (e, _) => [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Failed to load nodes',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error: $e'),
        ),
      ),
    );
  }
}
