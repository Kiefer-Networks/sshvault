import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/constants/icon_constants.dart';
import 'package:shellvault/core/routing/shell_navigation_provider.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/core/widgets/error_state.dart';
import 'package:shellvault/core/widgets/shell_aware_app_bar.dart';
import 'package:shellvault/features/connection/domain/entities/server_entity.dart';
import 'package:shellvault/features/connection/domain/entities/server_filter.dart';
import 'package:shellvault/features/connection/presentation/providers/server_providers.dart';
import 'package:shellvault/features/connection/presentation/widgets/confirm_dialog.dart';
import 'package:shellvault/features/connection/presentation/widgets/empty_state.dart';
import 'package:shellvault/features/connection/presentation/widgets/search_filter_bar.dart';
import 'package:shellvault/features/connection/presentation/widgets/server_grid_card.dart';
import 'package:shellvault/features/connection/presentation/widgets/server_list_tile.dart';
import 'package:shellvault/features/connection/presentation/widgets/view_mode_toggle.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:shellvault/features/terminal/presentation/providers/terminal_providers.dart';

final _hostFolderExpandedProvider = StateProvider.autoDispose
    .family<bool, String>((ref, key) => true);

class ServerListScreen extends ConsumerWidget {
  const ServerListScreen({super.key});

  bool _hasActiveFilter(ServerFilter filter) {
    return filter.searchQuery.isNotEmpty ||
        filter.groupId != null ||
        filter.tagIds.isNotEmpty ||
        filter.isActive != null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(serverFilterProvider);
    final viewMode = ref.watch(viewModeProvider);
    final useGrouped = !_hasActiveFilter(filter);

    final l10n = AppLocalizations.of(context)!;

    return AdaptiveScaffold.withAppBar(
      appBar: buildShellAppBar(
        context,
        title: l10n.serverListTitle,
        actions: [const ViewModeToggle(), const SizedBox(width: 8)],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addServerFab',
        onPressed: () => context.push('/server/new'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SearchFilterBar(),
          const SizedBox(height: 8),
          Expanded(
            child: useGrouped
                ? _buildFolderGroupedView(context, ref, viewMode, l10n)
                : _buildFlatView(context, ref, viewMode, l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderGroupedView(
    BuildContext context,
    WidgetRef ref,
    ViewMode viewMode,
    AppLocalizations l10n,
  ) {
    final groupedAsync = ref.watch(folderGroupedServersProvider);

    return groupedAsync.when(
      data: (groups) {
        final totalServers = groups.fold<int>(
          0,
          (sum, g) => sum + g.servers.length,
        );
        if (totalServers == 0) {
          return EmptyState(
            icon: Icons.dns_outlined,
            title: l10n.serverListEmpty,
            subtitle: l10n.serverListEmptySubtitle,
            action: FilledButton.icon(
              onPressed: () => context.push('/server/new'),
              icon: const Icon(Icons.add),
              label: Text(l10n.serverAddButton),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: groups.fold<int>(0, (sum, g) {
            final expanded =
                g.folder == null ||
                ref.watch(_hostFolderExpandedProvider(g.folder!.id));
            return sum + 1 + (expanded ? g.servers.length : 0);
          }),
          itemBuilder: (context, index) {
            var i = 0;
            for (final group in groups) {
              final key = group.folder?.id ?? '_uncategorized';
              final expanded =
                  group.folder == null ||
                  ref.watch(_hostFolderExpandedProvider(key));

              if (index == i) {
                return _FolderSectionHeader(
                  group: group,
                  expanded: expanded,
                  onToggle: group.folder != null
                      ? () =>
                            ref
                                    .read(
                                      _hostFolderExpandedProvider(key).notifier,
                                    )
                                    .state =
                                !expanded
                      : null,
                );
              }
              i++;

              if (expanded) {
                for (final server in group.servers) {
                  if (index == i) {
                    return Padding(
                      padding: EdgeInsets.only(left: group.depth * 24.0),
                      child: ServerListTile(
                        server: server,
                        onTap: () async {
                          await ref
                              .read(sessionManagerProvider.notifier)
                              .openSession(server.id);
                          ref
                              .read(shellNavigationProvider)
                              ?.goBranch(AppConstants.terminalBranchIndex);
                        },
                        onDetail: () => context.push('/server/${server.id}'),
                        onEdit: () => context.push('/server/${server.id}/edit'),
                        onDuplicate: () async {
                          await ref
                              .read(serverListProvider.notifier)
                              .duplicateServer(
                                server.id,
                                copySuffix: l10n.serverCopySuffix,
                              );
                          if (context.mounted) {
                            AdaptiveNotification.show(
                              context,
                              message: l10n.serverDuplicated,
                            );
                          }
                        },
                        onDelete: () => _confirmDelete(context, ref, server),
                      ),
                    );
                  }
                  i++;
                }
              }
            }
            return const SizedBox.shrink();
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, _) => ErrorState(
        error: error,
        onRetry: () => ref.invalidate(folderGroupedServersProvider),
      ),
    );
  }

  Widget _buildFlatView(
    BuildContext context,
    WidgetRef ref,
    ViewMode viewMode,
    AppLocalizations l10n,
  ) {
    final serversAsync = ref.watch(serverListProvider);

    return serversAsync.when(
      data: (servers) {
        if (servers.isEmpty) {
          return EmptyState(
            icon: Icons.dns_outlined,
            title: l10n.serverListEmpty,
            subtitle: l10n.serverListEmptySubtitle,
            action: FilledButton.icon(
              onPressed: () => context.push('/server/new'),
              icon: const Icon(Icons.add),
              label: Text(l10n.serverAddButton),
            ),
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: viewMode == ViewMode.list
              ? _buildList(context, ref, servers)
              : _buildGrid(context, ref, servers),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, _) => ErrorState(
        error: error,
        onRetry: () => ref.invalidate(serverListProvider),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    ServerEntity server,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.serverDeleteTitle,
      message: l10n.serverDeleteMessage(server.name),
    );
    if (confirmed == true) {
      await ref.read(serverListProvider.notifier).deleteServer(server.id);
    }
  }

  Widget _buildList(BuildContext context, WidgetRef ref, List servers) {
    return ListView.separated(
      key: const ValueKey('list'),
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: servers.length,
      separatorBuilder: (_, _) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        final server = servers[index];
        return ServerListTile(
          server: server,
          onTap: () async {
            await ref
                .read(sessionManagerProvider.notifier)
                .openSession(server.id);
            ref
                .read(shellNavigationProvider)
                ?.goBranch(AppConstants.terminalBranchIndex);
          },
          onDetail: () => context.push('/server/${server.id}'),
          onEdit: () => context.push('/server/${server.id}/edit'),
          onDuplicate: () async {
            final l10nDup = AppLocalizations.of(context)!;
            await ref
                .read(serverListProvider.notifier)
                .duplicateServer(
                  server.id,
                  copySuffix: l10nDup.serverCopySuffix,
                );
            if (context.mounted) {
              AdaptiveNotification.show(
                context,
                message: l10nDup.serverDuplicated,
              );
            }
          },
          onDelete: () async {
            final l10n = AppLocalizations.of(context)!;
            final confirmed = await ConfirmDialog.show(
              context,
              title: l10n.serverDeleteTitle,
              message: l10n.serverDeleteMessage(server.name),
            );
            if (confirmed == true) {
              await ref
                  .read(serverListProvider.notifier)
                  .deleteServer(server.id);
            }
          },
        );
      },
    );
  }

  Widget _buildGrid(BuildContext context, WidgetRef ref, List servers) {
    return GridView.builder(
      key: const ValueKey('grid'),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.95,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: servers.length,
      itemBuilder: (context, index) {
        final server = servers[index];
        return ServerGridCard(
          server: server,
          onTap: () async {
            await ref
                .read(sessionManagerProvider.notifier)
                .openSession(server.id);
            ref
                .read(shellNavigationProvider)
                ?.goBranch(AppConstants.terminalBranchIndex);
          },
          onDetail: () => context.push('/server/${server.id}'),
          onEdit: () => context.push('/server/${server.id}/edit'),
          onLongPress: () {
            _showServerActions(context, ref, server);
          },
        );
      },
    );
  }

  void _showServerActions(BuildContext context, WidgetRef ref, dynamic server) {
    final l10n = AppLocalizations.of(context)!;
    showAdaptiveActionSheet(
      context,
      title: server.name,
      actions: [
        AdaptiveAction(
          label: l10n.serverConnect,
          icon: Icons.terminal,
          onPressed: () async {
            await ref
                .read(sessionManagerProvider.notifier)
                .openSession(server.id);
            ref
                .read(shellNavigationProvider)
                ?.goBranch(AppConstants.terminalBranchIndex);
          },
        ),
        AdaptiveAction(
          label: l10n.serverDetails,
          icon: Icons.info_outlined,
          onPressed: () => context.push('/server/${server.id}'),
        ),
        AdaptiveAction(
          label: l10n.edit,
          icon: Icons.edit,
          onPressed: () => context.push('/server/${server.id}/edit'),
        ),
        AdaptiveAction(
          label: l10n.serverDuplicate,
          icon: Icons.copy,
          onPressed: () async {
            await ref
                .read(serverListProvider.notifier)
                .duplicateServer(server.id, copySuffix: l10n.serverCopySuffix);
          },
        ),
        AdaptiveAction(
          label: l10n.delete,
          icon: Icons.delete,
          isDestructive: true,
          onPressed: () async {
            final confirmed = await ConfirmDialog.show(
              context,
              title: l10n.serverDeleteTitle,
              message: l10n.serverDeleteShort(server.name),
            );
            if (confirmed == true) {
              await ref
                  .read(serverListProvider.notifier)
                  .deleteServer(server.id);
            }
          },
        ),
      ],
      cancelLabel: l10n.cancel,
    );
  }
}

class _FolderSectionHeader extends StatelessWidget {
  final FolderServerGroup group;
  final bool expanded;
  final VoidCallback? onToggle;

  const _FolderSectionHeader({
    required this.group,
    required this.expanded,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final folder = group.folder;
    final isUncategorized = folder == null;
    final folderColor = isUncategorized
        ? theme.colorScheme.onSurfaceVariant
        : Color(folder.color);
    final name = isUncategorized ? l10n.serverListNoFolder : folder.name;

    return Padding(
      padding: EdgeInsets.only(left: group.depth * 24.0),
      child: Material(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(
                  isUncategorized
                      ? Icons.folder_off_outlined
                      : IconConstants.getIcon(folder.iconName),
                  color: folderColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: folderColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${group.servers.length}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: folderColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (onToggle != null) ...[
                  const SizedBox(width: 4),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
