import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/constants/icon_constants.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/core/routing/shell_navigation_provider.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/widgets/error_state.dart';
import 'package:sshvault/core/widgets/shell_aware_app_bar.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/connection/domain/entities/server_filter.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/connection/presentation/widgets/confirm_dialog.dart';
import 'package:sshvault/features/connection/presentation/widgets/empty_state.dart';
import 'package:sshvault/features/connection/presentation/widgets/search_filter_bar.dart';
import 'package:sshvault/features/connection/presentation/widgets/server_grid_card.dart';
import 'package:sshvault/features/connection/presentation/widgets/server_import_flow.dart';
import 'package:sshvault/features/connection/presentation/widgets/server_list_tile.dart';
import 'package:sshvault/features/connection/presentation/widgets/view_mode_toggle.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:sshvault/features/connection/presentation/providers/repository_providers.dart';
import 'package:sshvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

final _hostFolderExpandedProvider = StateProvider.autoDispose
    .family<bool, String>((ref, key) => true);

class ServerListScreen extends ConsumerWidget {
  const ServerListScreen({super.key});

  static bool get _isDesktop =>
      Platform.isLinux || Platform.isMacOS || Platform.isWindows;

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
    // Folder grouping only makes sense for the list layout. When the user
    // picks the grid view we always show a flat grid so the toggle has a
    // visible effect even without an active filter.
    final useGrouped = viewMode == ViewMode.list && !_hasActiveFilter(filter);

    final l10n = AppLocalizations.of(context)!;

    return AdaptiveScaffold.withAppBar(
      appBar: buildShellAppBar(
        context,
        title: l10n.serverListTitle,
        actions: [const ViewModeToggle(), Spacing.horizontalSm],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'searchServerFab',
            tooltip: l10n.searchServers,
            onPressed: () => showServerSearchSheet(context),
            child: const Icon(Icons.search),
          ),
          Spacing.verticalSm,
          Semantics(
            label: l10n.serverAddButton,
            button: true,
            child: Tooltip(
              message: l10n.serverAddButton,
              child: FloatingActionButton(
                heroTag: 'addServerFab',
                tooltip: l10n.serverAddButton,
                onPressed: () => ServerImportFlow.addServer(context, ref),
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const _DashboardHeader(),
          const ActiveFilterChips(),
          Spacing.verticalSm,
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
              onPressed: () => ServerImportFlow.addServer(context, ref),
              icon: const Icon(Icons.add),
              label: Text(l10n.serverAddButton),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: Spacing.fabClearance),
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
                      padding: EdgeInsets.only(left: group.depth * Spacing.xxl),
                      child: ServerListTile(
                        server: server,
                        onTap: () async {
                          if (_isDesktop) {
                            ref
                                .read(desktopSelectedServerIdProvider.notifier)
                                .state = server
                                .id;
                            return;
                          }
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
                        onFavoriteToggle: () => _toggleFavorite(ref, server),
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
              onPressed: () => ServerImportFlow.addServer(context, ref),
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
      padding: const EdgeInsets.only(bottom: Spacing.fabClearance),
      itemCount: servers.length,
      separatorBuilder: (_, _) => Spacing.verticalXxs,
      itemBuilder: (context, index) {
        final server = servers[index];
        return ServerListTile(
          server: server,
          onTap: () async {
            if (_isDesktop) {
              ref.read(desktopSelectedServerIdProvider.notifier).state =
                  server.id;
              return;
            }
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
          onFavoriteToggle: () => _toggleFavorite(ref, server),
        );
      },
    );
  }

  Widget _buildGrid(BuildContext context, WidgetRef ref, List servers) {
    return GridView.builder(
      key: const ValueKey('grid'),
      padding: const EdgeInsets.fromLTRB(
        Spacing.lg,
        0,
        Spacing.lg,
        Spacing.fabClearance,
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
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
          onFavoriteToggle: () => _toggleFavorite(ref, server),
        );
      },
    );
  }

  Future<void> _toggleFavorite(WidgetRef ref, dynamic server) async {
    final useCases = ref.read(serverUseCasesProvider);
    await useCases.toggleFavorite(server.id, !server.isFavorite);
    ref.invalidate(serverListProvider);
    ref.invalidate(favoriteServersProvider);
    ref.invalidate(folderGroupedServersProvider);
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
          label: server.isFavorite
              ? l10n.removeFromFavorites
              : l10n.addToFavorites,
          icon: server.isFavorite ? Icons.star : Icons.star_border,
          onPressed: () async {
            final useCases = ref.read(serverUseCasesProvider);
            await useCases.toggleFavorite(server.id, !server.isFavorite);
            ref.invalidate(serverListProvider);
            ref.invalidate(favoriteServersProvider);
            ref.invalidate(folderGroupedServersProvider);
          },
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
    final serverCount = group.servers.length;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        left: group.depth * Spacing.xxl + Spacing.lg,
        right: Spacing.lg,
        top: Spacing.xs,
        bottom: Spacing.xs,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onToggle,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  folderColor.withAlpha(isDark ? 60 : 40),
                  folderColor.withAlpha(isDark ? 20 : 12),
                ],
              ),
              border: Border.all(
                color: folderColor.withAlpha(isDark ? 80 : 50),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: folderColor.withAlpha(isDark ? 70 : 45),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      isUncategorized
                          ? Icons.folder_off_outlined
                          : IconConstants.getIcon(folder.iconName),
                      color: folderColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.folderServerCount(serverCount),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: folderColor.withAlpha(isDark ? 90 : 60),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '$serverCount',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: folderColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (onToggle != null) ...[
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.expand_more,
                        size: 22,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardHeader extends ConsumerWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final sessions = ref.watch(sessionManagerProvider);
    final favoritesAsync = ref.watch(favoriteServersProvider);
    final recentsAsync = ref.watch(recentServersProvider);

    final favorites = favoritesAsync.value ?? [];
    final recents = recentsAsync.value ?? [];

    if (sessions.isEmpty && favorites.isEmpty && recents.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: Spacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active sessions
          if (sessions.isNotEmpty) ...[
            _SectionHeader(title: l10n.dashboardActiveSessions),
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: Spacing.paddingHorizontalLg,
                itemCount: sessions.length,
                separatorBuilder: (_, _) => Spacing.horizontalSm,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  return ActionChip(
                    avatar: Icon(
                      Icons.circle,
                      size: 10,
                      color: session.status == SshConnectionStatus.connected
                          ? theme.colorScheme.tertiary
                          : theme.colorScheme.outlineVariant,
                    ),
                    label: Text(session.title),
                    onPressed: () {
                      ref.read(activeSessionIndexProvider.notifier).state =
                          index;
                      ref
                          .read(shellNavigationProvider)
                          ?.goBranch(AppConstants.terminalBranchIndex);
                    },
                  );
                },
              ),
            ),
          ],
          // Favorites
          if (favorites.isNotEmpty) ...[
            _SectionHeader(title: l10n.dashboardFavorites),
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: Spacing.paddingHorizontalLg,
                itemCount: favorites.length,
                separatorBuilder: (_, _) => Spacing.horizontalSm,
                itemBuilder: (context, index) {
                  final server = favorites[index];
                  return ActionChip(
                    avatar: Icon(
                      IconConstants.getIcon(server.iconName),
                      size: 16,
                      color: Color(server.color),
                    ),
                    label: Text(server.name),
                    onPressed: () async {
                      await ref
                          .read(sessionManagerProvider.notifier)
                          .openSession(server.id);
                      ref
                          .read(shellNavigationProvider)
                          ?.goBranch(AppConstants.terminalBranchIndex);
                    },
                  );
                },
              ),
            ),
          ],
          // Recents
          if (recents.isNotEmpty) ...[
            _SectionHeader(title: l10n.dashboardRecent),
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: Spacing.paddingHorizontalLg,
                itemCount: recents.length,
                separatorBuilder: (_, _) => Spacing.horizontalSm,
                itemBuilder: (context, index) {
                  final server = recents[index];
                  return ActionChip(
                    avatar: Icon(
                      IconConstants.getIcon(server.iconName),
                      size: 16,
                      color: Color(server.color),
                    ),
                    label: Text(server.name),
                    onPressed: () async {
                      await ref
                          .read(sessionManagerProvider.notifier)
                          .openSession(server.id);
                      ref
                          .read(shellNavigationProvider)
                          ?.goBranch(AppConstants.terminalBranchIndex);
                    },
                  );
                },
              ),
            ),
          ],
          Spacing.verticalXxs,
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.xxs,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
