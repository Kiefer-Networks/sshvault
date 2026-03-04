import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/core/widgets/shell_aware_app_bar.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:shellvault/features/teleport/presentation/providers/teleport_providers.dart';
import 'package:shellvault/features/teleport/presentation/widgets/teleport_cert_status.dart';
import 'package:shellvault/features/teleport/presentation/widgets/teleport_node_tile.dart';

class TeleportBranchScreen extends ConsumerWidget {
  const TeleportBranchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clustersAsync = ref.watch(teleportClusterListProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: buildShellAppBar(
        context,
        title: l10n.teleportTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.teleportAddClusterTooltip,
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
                    l10n.teleportNoClusters,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.teleportNoClustersHint,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => context.push('/teleport/cluster/new'),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.teleportAddCluster),
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
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'login':
                        context.push('/teleport/cluster/${cluster.id}/login');
                      case 'delete':
                        _confirmDelete(context, ref, cluster.id, cluster.name, l10n);
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'login',
                      child: ListTile(
                        leading: const Icon(Icons.login),
                        title: Text(l10n.teleportLogin),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                        title: Text(l10n.delete, style: TextStyle(color: theme.colorScheme.error)),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                children: nodesAsync.when(
                  data: (nodes) {
                    if (nodes.isEmpty) {
                      return [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            l10n.teleportNoNodes,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ];
                    }
                    return nodes.map((node) {
                      return TeleportNodeTile(
                        node: node,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.teleportSessionsNotAvailable),
                            ),
                          );
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
                        l10n.teleportFailedToLoadNodes,
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
          child: Text(l10n.error(e.toString())),
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String clusterId,
    String clusterName,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.teleportDeleteClusterConfirm(clusterName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(teleportRepositoryProvider).deleteCluster(clusterId);
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
