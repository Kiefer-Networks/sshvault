import 'package:flutter/material.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/core/constants/icon_constants.dart';
import 'package:shellvault/core/routing/shell_navigation_provider.dart';
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

class GroupListScreen extends ConsumerWidget {
  const GroupListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(groupTreeProvider);

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: buildShellAppBar(context, title: l10n.groupListTitle),
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
            separatorBuilder: (_, _) =>
                const Divider(height: 1, indent: 72),
            itemBuilder: (_, index) => widgets[index],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              Text(l10n.error(error.toString())),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(groupTreeProvider),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addGroupFab',
        onPressed: () => _showGroupForm(context, ref),
        child: const Icon(Icons.add),
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
      widgets.add(_GroupTile(
        group: group,
        depth: depth,
        onEdit: () => _showGroupForm(context, ref, group: group),
        onDelete: () => _deleteGroup(context, ref, group),
      ));
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
    GroupFormDialog.show(context, ref, group: group);
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

class _GroupTile extends ConsumerStatefulWidget {
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

  @override
  ConsumerState<_GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends ConsumerState<_GroupTile> {
  bool _expanded = false;
  bool _connectingAll = false;

  Future<void> _connectAllServers() async {
    if (_connectingAll) return;
    setState(() => _connectingAll = true);

    try {
      final groupId = widget.group.id;
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

      if (mounted) {
        ref.read(shellNavigationProvider)?.goBranch(6);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.error(e.toString())),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _connectingAll = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final group = widget.group;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Slidable(
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (_) => widget.onEdit(),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: l10n.edit,
                borderRadius: BorderRadius.circular(12),
              ),
              SlidableAction(
                onPressed: (_) => widget.onDelete(),
                backgroundColor: theme.colorScheme.error,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: l10n.delete,
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.only(
              left: 16.0 + widget.depth * 24.0,
              right: 16.0,
            ),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Color(group.color).withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                IconConstants.getIcon(group.iconName),
                color: Color(group.color),
                size: 22,
              ),
            ),
            title: Text(group.name),
            subtitle: Text(
              '${group.serverCount} server${group.serverCount == 1 ? '' : 's'}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(153),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (group.serverCount > 0)
                  _connectingAll
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: const Icon(Icons.play_circle_outline),
                          onPressed: _connectAllServers,
                          tooltip: l10n.groupConnectAll,
                          visualDensity: VisualDensity.compact,
                        ),
                if (group.serverCount > 0)
                  IconButton(
                    icon: Icon(
                      _expanded
                          ? Icons.expand_less
                          : Icons.expand_more,
                    ),
                    onPressed: () => setState(() => _expanded = !_expanded),
                    tooltip: _expanded ? l10n.groupCollapse : l10n.groupShowHosts,
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            onTap: group.serverCount > 0
                ? () => setState(() => _expanded = !_expanded)
                : null,
          ),
        ),
        if (_expanded)
          _GroupServerList(
            groupId: group.id,
            depth: widget.depth,
          ),
      ],
    );
  }
}

class _GroupServerList extends ConsumerWidget {
  final String groupId;
  final int depth;

  const _GroupServerList({
    required this.groupId,
    required this.depth,
  });

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
                  ref.read(shellNavigationProvider)?.goBranch(6);
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
        child: Text(AppLocalizations.of(context)!.error(e.toString()), style: theme.textTheme.bodySmall),
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
      leading: Icon(
        Icons.dns_outlined,
        size: 18,
        color: Color(server.color),
      ),
      title: Text(
        server.name,
        style: theme.textTheme.bodyMedium,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${server.username}@${server.hostname}',
        style: theme.textTheme.bodySmall?.copyWith(
          fontFamily: 'monospace',
          fontSize: 11,
          color: theme.colorScheme.onSurface.withAlpha(128),
        ),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.info_outlined, size: 18),
            onPressed: onDetail,
            tooltip: AppLocalizations.of(context)!.serverDetails,
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            icon: const Icon(Icons.terminal, size: 18),
            onPressed: onTap,
            tooltip: AppLocalizations.of(context)!.serverConnect,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
