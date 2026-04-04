import 'package:flutter/material.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/constants/icon_constants.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/core/routing/shell_navigation_provider.dart';
import 'package:sshvault/core/widgets/error_state.dart';
import 'package:sshvault/core/widgets/shell_aware_app_bar.dart';
import 'package:sshvault/features/connection/domain/entities/group_entity.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/connection/domain/entities/server_filter.dart';
import 'package:sshvault/features/connection/presentation/providers/folder_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/repository_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/connection/presentation/screens/folder_form_dialog.dart';
import 'package:sshvault/features/connection/presentation/widgets/confirm_dialog.dart';
import 'package:sshvault/features/connection/presentation/widgets/empty_state.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

final _folderTileExpandedProvider = StateProvider.autoDispose
    .family<bool, String>((ref, folderId) => false);

final _folderTileConnectingProvider = StateProvider.autoDispose
    .family<bool, String>((ref, folderId) => false);

class FolderBrowserScreen extends ConsumerWidget {
  const FolderBrowserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(folderTreeProvider);

    final l10n = AppLocalizations.of(context)!;

    return AdaptiveScaffold.withAppBar(
      appBar: buildShellAppBar(
        context,
        title: l10n.folderListTitle,
        actions: null,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addFolderFab',
        onPressed: () => _showFolderForm(context, ref),
        child: const Icon(Icons.add),
      ),
      body: foldersAsync.when(
        data: (folders) {
          if (folders.isEmpty) {
            return EmptyState(
              icon: Icons.folder_outlined,
              title: l10n.folderListEmpty,
              subtitle: l10n.folderListEmptySubtitle,
              action: FilledButton.icon(
                onPressed: () => _showFolderForm(context, ref),
                icon: const Icon(Icons.add),
                label: Text(l10n.folderAddButton),
              ),
            );
          }

          final widgets = _buildFolderList(context, ref, folders);
          return ListView.separated(
            padding: EdgeInsets.only(bottom: Spacing.fabClearance),
            itemCount: widgets.length,
            separatorBuilder: (_, _) => Spacing.verticalXxs,
            itemBuilder: (_, index) => widgets[index],
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) => ErrorState(
          error: error,
          onRetry: () => ref.invalidate(folderTreeProvider),
        ),
      ),
    );
  }

  List<Widget> _buildFolderList(
    BuildContext context,
    WidgetRef ref,
    List<GroupEntity> folders, {
    int depth = 0,
  }) {
    final widgets = <Widget>[];
    for (final folder in folders) {
      widgets.add(
        _FolderTile(
          folder: folder,
          depth: depth,
          onEdit: () => _showFolderForm(context, ref, folder: folder),
          onDelete: () => _deleteFolder(context, ref, folder),
        ),
      );
      if (folder.children.isNotEmpty) {
        widgets.addAll(
          _buildFolderList(context, ref, folder.children, depth: depth + 1),
        );
      }
    }
    return widgets;
  }

  void _showFolderForm(
    BuildContext context,
    WidgetRef ref, {
    GroupEntity? folder,
  }) {
    FolderFormDialog.show(context, folder: folder);
  }

  Future<void> _deleteFolder(
    BuildContext context,
    WidgetRef ref,
    GroupEntity folder,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.folderDeleteTitle,
      message: l10n.folderDeleteMessage(folder.name),
    );
    if (confirmed == true) {
      await ref.read(folderListProvider.notifier).deleteFolder(folder.id);
    }
  }
}

class _FolderTile extends ConsumerWidget {
  final GroupEntity folder;
  final int depth;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FolderTile({
    required this.folder,
    this.depth = 0,
    required this.onEdit,
    required this.onDelete,
  });

  Future<void> _connectAllServers(BuildContext context, WidgetRef ref) async {
    final connectingAll = ref.read(_folderTileConnectingProvider(folder.id));
    if (connectingAll) return;
    ref.read(_folderTileConnectingProvider(folder.id).notifier).state = true;

    try {
      final folderId = folder.id;
      final useCases = ref.read(serverUseCasesProvider);
      final result = await useCases.getServers(
        filter: ServerFilter(groupId: folderId),
      );
      final servers = result.fold(
        onSuccess: (s) => s,
        onFailure: (f) => throw Exception(f.message),
      );

      if (servers.isEmpty) return;

      final sessionManager = ref.read(sessionManagerProvider.notifier);
      for (final server in servers) {
        await sessionManager.openSession(server.id);
      }

      if (context.mounted) {
        ref
            .read(shellNavigationProvider)
            ?.goBranch(AppConstants.terminalBranchIndex);
      }
    } catch (e) {
      if (context.mounted) {
        AdaptiveNotification.show(
          context,
          message: AppLocalizations.of(context)!.error(errorMessage(e)),
        );
      }
    } finally {
      ref.read(_folderTileConnectingProvider(folder.id).notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final expanded = ref.watch(_folderTileExpandedProvider(folder.id));
    final connectingAll = ref.watch(_folderTileConnectingProvider(folder.id));
    final folderColor = Color(folder.color);

    return Column(
      children: [
        Slidable(
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (_) => onEdit(),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                icon: Icons.edit,
                label: l10n.edit,
                borderRadius: BorderRadius.circular(12),
              ),
              SlidableAction(
                onPressed: (_) => onDelete(),
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
                icon: Icons.delete,
                label: l10n.delete,
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
          child: Container(
            decoration: depth > 0
                ? BoxDecoration(
                    border: Border(
                      left: BorderSide(color: folderColor, width: 3),
                    ),
                  )
                : null,
            child: ListTile(
              contentPadding: EdgeInsets.only(
                left: Spacing.lg + depth * Spacing.xxl,
                right: Spacing.lg,
              ),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: folderColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  IconConstants.getIcon(folder.iconName),
                  color: folderColor,
                  size: 22,
                ),
              ),
              title: Text(folder.name),
              subtitle: Text(
                l10n.folderServerCount(folder.serverCount),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (folder.serverCount > 0)
                    connectingAll
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : OutlinedButton.icon(
                            onPressed: () => _connectAllServers(context, ref),
                            icon: const Icon(Icons.play_arrow, size: 18),
                            label: Text(l10n.folderConnectAll),
                            style: OutlinedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.symmetric(
                                horizontal: Spacing.md,
                              ),
                            ),
                          ),
                  if (folder.serverCount > 0)
                    IconButton(
                      icon: Icon(
                        expanded ? Icons.expand_less : Icons.expand_more,
                      ),
                      onPressed: () =>
                          ref
                                  .read(
                                    _folderTileExpandedProvider(
                                      folder.id,
                                    ).notifier,
                                  )
                                  .state =
                              !expanded,
                      tooltip: expanded
                          ? l10n.folderCollapse
                          : l10n.folderShowHosts,
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
              onTap: folder.serverCount > 0
                  ? () =>
                        ref
                                .read(
                                  _folderTileExpandedProvider(
                                    folder.id,
                                  ).notifier,
                                )
                                .state =
                            !expanded
                  : null,
            ),
          ),
        ),
        if (expanded) _FolderServerList(folderId: folder.id, depth: depth),
      ],
    );
  }
}

class _FolderServerList extends ConsumerWidget {
  final String folderId;
  final int depth;

  const _FolderServerList({required this.folderId, required this.depth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serversAsync = ref.watch(serversByGroupProvider(folderId));
    final theme = Theme.of(context);
    final indent = Spacing.lg + depth * Spacing.xxl + Spacing.xxl;

    return serversAsync.when(
      data: (servers) {
        if (servers.isEmpty) return const SizedBox.shrink();
        return Column(
          children: [
            for (final server in servers)
              _ServerSubTile(
                server: server,
                indent: indent,
                theme: theme,
                onTap: () async {
                  await ref
                      .read(sessionManagerProvider.notifier)
                      .openSession(server.id);
                  ref
                      .read(shellNavigationProvider)
                      ?.goBranch(AppConstants.terminalBranchIndex);
                },
                onDetail: () => context.push('/server/${server.id}'),
              ),
          ],
        );
      },
      loading: () => Padding(
        padding: EdgeInsets.only(
          left: indent,
          top: Spacing.sm,
          bottom: Spacing.sm,
        ),
        child: const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (e, _) => Padding(
        padding: EdgeInsets.only(left: indent),
        child: Text(
          AppLocalizations.of(context)!.error(errorMessage(e)),
          style: theme.textTheme.bodySmall,
        ),
      ),
    );
  }
}

class _ServerSubTile extends StatelessWidget {
  final ServerEntity server;
  final double indent;
  final ThemeData theme;
  final VoidCallback onTap;
  final VoidCallback onDetail;

  const _ServerSubTile({
    required this.server,
    required this.indent,
    required this.theme,
    required this.onTap,
    required this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: indent, right: Spacing.lg),
      dense: true,
      leading: Icon(Icons.dns_outlined, size: 18, color: Color(server.color)),
      title: Text(
        server.name,
        style: theme.textTheme.bodyMedium,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${server.username}@${server.hostname}',
        style: theme.textTheme.bodySmall?.copyWith(
          fontFamily: AppConstants.monospaceFontFamily,
          fontSize: 11,
          color: theme.colorScheme.onSurface.withAlpha(AppConstants.alpha128),
        ),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.terminal, size: 18),
        onPressed: onTap,
        tooltip: AppLocalizations.of(context)!.serverConnect,
        visualDensity: VisualDensity.compact,
      ),
      onTap: onDetail,
    );
  }
}
