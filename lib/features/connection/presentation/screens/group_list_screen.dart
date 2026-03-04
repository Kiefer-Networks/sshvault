import 'package:flutter/material.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/constants/icon_constants.dart';
import 'package:shellvault/core/routing/shell_navigation_provider.dart';
import 'package:shellvault/core/widgets/error_state.dart';
import 'package:shellvault/core/widgets/shell_aware_app_bar.dart';
import 'package:shellvault/features/connection/domain/entities/group_entity.dart';
import 'package:shellvault/features/connection/domain/entities/server_entity.dart';
import 'package:shellvault/features/connection/domain/entities/server_filter.dart';
import 'package:shellvault/features/connection/presentation/providers/group_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/repository_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/server_providers.dart';
import 'package:shellvault/features/connection/presentation/screens/group_form_dialog.dart';
import 'package:shellvault/features/connection/presentation/widgets/confirm_dialog.dart';
import 'package:shellvault/features/connection/presentation/widgets/empty_state.dart';
import 'package:shellvault/features/terminal/presentation/providers/terminal_providers.dart';

final _groupTileExpandedProvider = StateProvider.autoDispose
    .family<bool, String>((ref, groupId) => false);

final _groupTileConnectingProvider = StateProvider.autoDispose
    .family<bool, String>((ref, groupId) => false);

class GroupListScreen extends ConsumerWidget {
  const GroupListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(groupTreeProvider);

    final l10n = AppLocalizations.of(context)!;

    return AdaptiveScaffold.withAppBar(
      appBar: buildShellAppBar(
        context,
        title: l10n.groupListTitle,
        actions: null,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addGroupFab',
        onPressed: () => _showGroupForm(context, ref),
        child: const Icon(Icons.add),
      ),
      body: groupsAsync.when(
        data: (groups) {
          if (groups.isEmpty) {
            return EmptyState(
              icon: Icons.folder_outlined,
              title: l10n.groupListEmpty,
              subtitle: l10n.groupListEmptySubtitle,
              action: FilledButton.icon(
                onPressed: () => _showGroupForm(context, ref),
                icon: const Icon(Icons.add),
                label: Text(l10n.groupAddButton),
              ),
            );
          }

          final widgets = _buildGroupList(context, ref, groups);
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: widgets.length,
            separatorBuilder: (_, _) => const SizedBox(height: 4),
            itemBuilder: (_, index) => widgets[index],
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) => ErrorState(
          error: error,
          onRetry: () => ref.invalidate(groupTreeProvider),
        ),
      ),
    );
  }

  List<Widget> _buildGroupList(
    BuildContext context,
    WidgetRef ref,
    List<GroupEntity> groups, {
    int depth = 0,
  }) {
    final widgets = <Widget>[];
    for (final group in groups) {
      widgets.add(
        _GroupTile(
          group: group,
          depth: depth,
          onEdit: () => _showGroupForm(context, ref, group: group),
          onDelete: () => _deleteGroup(context, ref, group),
        ),
      );
      if (group.children.isNotEmpty) {
        widgets.addAll(
          _buildGroupList(context, ref, group.children, depth: depth + 1),
        );
      }
    }
    return widgets;
  }

  void _showGroupForm(
    BuildContext context,
    WidgetRef ref, {
    GroupEntity? group,
  }) {
    GroupFormDialog.show(context, group: group);
  }

  Future<void> _deleteGroup(
    BuildContext context,
    WidgetRef ref,
    GroupEntity group,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.groupDeleteTitle,
      message: l10n.groupDeleteMessage(group.name),
    );
    if (confirmed == true) {
      await ref.read(groupListProvider.notifier).deleteGroup(group.id);
    }
  }
}

class _GroupTile extends ConsumerWidget {
  final GroupEntity group;
  final int depth;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _GroupTile({
    required this.group,
    this.depth = 0,
    required this.onEdit,
    required this.onDelete,
  });

  Future<void> _connectAllServers(BuildContext context, WidgetRef ref) async {
    final connectingAll = ref.read(_groupTileConnectingProvider(group.id));
    if (connectingAll) return;
    ref.read(_groupTileConnectingProvider(group.id).notifier).state = true;

    try {
      final groupId = group.id;
      final useCases = ref.read(serverUseCasesProvider);
      final result = await useCases.getServers(
        filter: ServerFilter(groupId: groupId),
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
      ref.read(_groupTileConnectingProvider(group.id).notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final expanded = ref.watch(_groupTileExpandedProvider(group.id));
    final connectingAll = ref.watch(_groupTileConnectingProvider(group.id));
    final groupColor = Color(group.color);

    return Column(
      children: [
        Slidable(
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (_) => onEdit(),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: l10n.edit,
                borderRadius: BorderRadius.circular(12),
              ),
              SlidableAction(
                onPressed: (_) => onDelete(),
                backgroundColor: theme.colorScheme.error,
                foregroundColor: Colors.white,
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
                      left: BorderSide(color: groupColor, width: 3),
                    ),
                  )
                : null,
            child: ListTile(
              contentPadding: EdgeInsets.only(
                left: 16.0 + depth * 24.0,
                right: 16.0,
              ),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: groupColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  IconConstants.getIcon(group.iconName),
                  color: groupColor,
                  size: 22,
                ),
              ),
              title: Text(group.name),
              subtitle: Text(
                l10n.groupServerCount(group.serverCount),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (group.serverCount > 0)
                    connectingAll
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : OutlinedButton.icon(
                            onPressed: () => _connectAllServers(context, ref),
                            icon: const Icon(Icons.play_arrow, size: 18),
                            label: Text(l10n.groupConnectAll),
                            style: OutlinedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                          ),
                  if (group.serverCount > 0)
                    IconButton(
                      icon: Icon(
                        expanded ? Icons.expand_less : Icons.expand_more,
                      ),
                      onPressed: () =>
                          ref
                                  .read(
                                    _groupTileExpandedProvider(
                                      group.id,
                                    ).notifier,
                                  )
                                  .state =
                              !expanded,
                      tooltip: expanded
                          ? l10n.groupCollapse
                          : l10n.groupShowHosts,
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
              onTap: group.serverCount > 0
                  ? () =>
                        ref
                                .read(
                                  _groupTileExpandedProvider(group.id).notifier,
                                )
                                .state =
                            !expanded
                  : null,
            ),
          ),
        ),
        if (expanded) _GroupServerList(groupId: group.id, depth: depth),
      ],
    );
  }
}

class _GroupServerList extends ConsumerWidget {
  final String groupId;
  final int depth;

  const _GroupServerList({required this.groupId, required this.depth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serversAsync = ref.watch(serversByGroupProvider(groupId));
    final theme = Theme.of(context);
    final indent = 16.0 + depth * 24.0 + 24.0;

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
        padding: EdgeInsets.only(left: indent, top: 8, bottom: 8),
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
      contentPadding: EdgeInsets.only(left: indent, right: 16),
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
