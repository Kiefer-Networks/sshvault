import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/constants/icon_constants.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/core/routing/shell_navigation_provider.dart';
import 'package:sshvault/core/utils/byte_format.dart';
import 'package:sshvault/core/utils/date_formatter.dart';
import 'package:sshvault/core/widgets/error_state.dart';
import 'package:sshvault/core/widgets/settings/section_card.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/repository_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/connection/presentation/widgets/confirm_dialog.dart';
import 'package:sshvault/features/connection/presentation/widgets/empty_state.dart';
import 'package:sshvault/features/connection/presentation/widgets/filter_bottom_sheet.dart';
import 'package:sshvault/features/connection/presentation/widgets/search_filter_bar.dart';
import 'package:sshvault/features/connection/presentation/widgets/server_import_flow.dart';
import 'package:sshvault/features/connection/presentation/widgets/server_list_tile.dart';
import 'package:sshvault/features/connection/presentation/widgets/tag_chip.dart';
import 'package:sshvault/features/terminal/data/services/remote_system_metrics_service.dart';
import 'package:sshvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

enum _ConsoleTab { fleet, sessions, activity }

/// Desktop-only fleet dashboard for the Hosts branch (>= 600 dp — see
/// [AppShell]'s `_DesktopScaffold`). Replaces the old host list plus
/// persistent detail pane with a single grid built around what SSHVault
/// actually knows about a host: TCP/session reachability, tags, and the
/// system snapshot collected after the last successful connection.
///
/// A handful of labels here are hard-coded English rather than routed
/// through ARB files: this project ships 28 generated locale files
/// (`lib/l10n/generated/`) that are committed and checked for freshness in
/// CI via `flutter gen-l10n`, which requires the Flutter SDK. The same
/// trade-off already exists for the iPad-only action in
/// [ServerListTile] — see the comment there.
class OperationsConsoleScreen extends ConsumerStatefulWidget {
  const OperationsConsoleScreen({super.key});

  @override
  ConsumerState<OperationsConsoleScreen> createState() =>
      _OperationsConsoleScreenState();
}

class _OperationsConsoleScreenState
    extends ConsumerState<OperationsConsoleScreen> {
  _ConsoleTab _tab = _ConsoleTab.fleet;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(serverFilterProvider).searchQuery,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    final filter = ref.read(serverFilterProvider);
    ref.read(serverFilterProvider.notifier).state = filter.copyWith(
      searchQuery: value,
    );
  }

  Future<void> _showFilterSheet() async {
    final result = await FilterBottomSheet.show(
      context,
      currentFilter: ref.read(serverFilterProvider),
    );
    if (result != null) {
      ref.read(serverFilterProvider.notifier).state = result;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sessionCount = ref.watch(sessionManagerProvider).length;

    return ColoredBox(
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.xxl,
              Spacing.lg,
              Spacing.xxl,
              Spacing.sm,
            ),
            child: _ConsoleTopBar(
              tab: _tab,
              onTabChanged: (t) => setState(() => _tab = t),
              searchController: _searchController,
              onSearchChanged: _onSearchChanged,
              onFilterTap: _showFilterSheet,
              sessionCount: sessionCount,
            ),
          ),
          const ActiveFilterChips(),
          Spacing.verticalSm,
          Expanded(
            child: switch (_tab) {
              _ConsoleTab.fleet => const _FleetView(),
              _ConsoleTab.sessions => const _SessionsView(),
              _ConsoleTab.activity => const _ActivityView(),
            },
          ),
        ],
      ),
    );
  }
}

class _ConsoleTopBar extends ConsumerWidget {
  final _ConsoleTab tab;
  final ValueChanged<_ConsoleTab> onTabChanged;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterTap;
  final int sessionCount;

  const _ConsoleTopBar({
    required this.tab,
    required this.onTabChanged,
    required this.searchController,
    required this.onSearchChanged,
    required this.onFilterTap,
    required this.sessionCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        SegmentedButton<_ConsoleTab>(
          segments: [
            const ButtonSegment(
              value: _ConsoleTab.fleet,
              label: Text('Fleet'),
              icon: Icon(Icons.dns_outlined),
            ),
            ButtonSegment(
              value: _ConsoleTab.sessions,
              label: Text(
                sessionCount > 0 ? 'Sessions ($sessionCount)' : 'Sessions',
              ),
              icon: const Icon(Icons.terminal_outlined),
            ),
            const ButtonSegment(
              value: _ConsoleTab.activity,
              label: Text('Activity'),
              icon: Icon(Icons.history),
            ),
          ],
          selected: {tab},
          showSelectedIcon: false,
          onSelectionChanged: (selection) => onTabChanged(selection.first),
        ),
        Spacing.horizontalLg,
        Expanded(
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              isDense: true,
              hintText: l10n.searchServers,
              prefixIcon: const Icon(Icons.search, size: 20),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Spacing.horizontalSm,
        IconButton.filledTonal(
          icon: const Icon(Icons.tune),
          tooltip: l10n.filterTitle,
          onPressed: onFilterTap,
        ),
        Spacing.horizontalSm,
        FilledButton.icon(
          onPressed: () => ServerImportFlow.addServer(context, ref),
          icon: const Icon(Icons.add),
          label: Text(l10n.serverAddButton),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Fleet
// ---------------------------------------------------------------------------

class _FleetView extends ConsumerWidget {
  const _FleetView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final serversAsync = ref.watch(serverListProvider);
    final sessions = ref.watch(sessionManagerProvider);

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

        final byId = {for (final s in servers) s.id: s};

        return Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.xxl,
                  0,
                  Spacing.xxl,
                  Spacing.lg,
                ),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 380,
                  mainAxisExtent: 260,
                  crossAxisSpacing: Spacing.md,
                  mainAxisSpacing: Spacing.md,
                ),
                itemCount: servers.length,
                itemBuilder: (context, index) {
                  final server = servers[index];
                  return _FleetCard(
                    server: server,
                    jumpHostName: server.jumpHostId != null
                        ? byId[server.jumpHostId]?.name
                        : null,
                  );
                },
              ),
            ),
            _FleetFooter(servers: servers, sessions: sessions),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, _) =>
          ErrorState(error: error, onRetry: () => ref.invalidate(serverListProvider)),
    );
  }
}

class _FleetCard extends ConsumerWidget {
  final ServerEntity server;
  final String? jumpHostName;

  const _FleetCard({required this.server, this.jumpHostName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final sessions = ref.watch(sessionManagerProvider);
    final session = sessions.where((s) => s.serverId == server.id).firstOrNull;
    final focused = ref.watch(desktopSelectedServerIdProvider) == server.id;
    final metrics = _parseMetrics(server.systemMetricsJson);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: focused ? theme.colorScheme.primary : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () =>
              ref.read(desktopSelectedServerIdProvider.notifier).state =
                  server.id,
          child: Padding(
            padding: Spacing.paddingAllMd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _OsBadge(server: server),
                    const Spacer(),
                    ConnectionStatusBadge(
                      connectionStatus: session?.status,
                      server: server,
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                      icon: Icon(
                        server.isFavorite ? Icons.star : Icons.star_border,
                        size: 17,
                        color: server.isFavorite
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      tooltip: server.isFavorite
                          ? l10n.removeFromFavorites
                          : l10n.addToFavorites,
                      onPressed: () async {
                        final useCases = ref.read(serverUseCasesProvider);
                        await useCases.toggleFavorite(
                          server.id,
                          !server.isFavorite,
                        );
                        ref.invalidate(serverListProvider);
                        ref.invalidate(favoriteServersProvider);
                        ref.invalidate(folderGroupedServersProvider);
                      },
                    ),
                    PopupMenuButton<String>(
                      tooltip: l10n.navMore,
                      visualDensity: VisualDensity.compact,
                      onSelected: (action) async {
                        switch (action) {
                          case 'connect':
                            await ref
                                .read(sessionManagerProvider.notifier)
                                .openSession(server.id);
                            ref
                                .read(shellNavigationProvider)
                                ?.goBranch(AppConstants.terminalBranchIndex);
                          case 'detail':
                            context.push('/server/${server.id}');
                          case 'edit':
                            context.push('/server/${server.id}/edit');
                          case 'duplicate':
                            await ref
                                .read(serverListProvider.notifier)
                                .duplicateServer(
                                  server.id,
                                  copySuffix: l10n.serverCopySuffix,
                                );
                          case 'delete':
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
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'connect',
                          child: ListTile(
                            leading: const Icon(Icons.terminal),
                            title: Text(l10n.serverConnect),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'detail',
                          child: ListTile(
                            leading: const Icon(Icons.info_outlined),
                            title: Text(l10n.serverDetails),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'edit',
                          child: ListTile(
                            leading: const Icon(Icons.edit),
                            title: Text(l10n.edit),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'duplicate',
                          child: ListTile(
                            leading: const Icon(Icons.copy),
                            title: Text(l10n.serverDuplicate),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            leading: const Icon(Icons.delete),
                            title: Text(l10n.delete),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  server.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${server.username}@${server.hostname}:${server.port}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: AppConstants.monospaceFontFamily,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (server.tags.isNotEmpty || jumpHostName != null) ...[
                  Spacing.verticalXxs,
                  SizedBox(
                    height: 24,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (final tag in server.tags.take(3)) ...[
                          TagChip(
                            tag: tag,
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          Spacing.horizontalXxs,
                        ],
                        if (jumpHostName != null)
                          Chip(
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            avatar: const Icon(Icons.alt_route, size: 14),
                            label: Text(
                              'via $jumpHostName',
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                const Spacer(),
                Divider(
                  height: Spacing.lg,
                  color: theme.colorScheme.outlineVariant.withAlpha(120),
                ),
                if (metrics != null)
                  _MetricsFooter(metrics: metrics)
                else
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'No system info yet — connect once to detect it.',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OsBadge extends StatelessWidget {
  final ServerEntity server;
  const _OsBadge({required this.server});

  static IconData _icon(String? family) => switch (family?.toLowerCase()) {
    'windows' => Icons.window,
    'macos' => Icons.laptop_mac,
    'linux' => Icons.computer,
    'bsd' => Icons.dns,
    _ => Icons.help_outline,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = server.osPrettyName ?? server.osName ?? server.osVersion;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _icon(server.osFamily),
            size: 12,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: Text(
              label ?? '—',
              style: theme.textTheme.labelSmall?.copyWith(
                fontFamily: AppConstants.monospaceFontFamily,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsFooter extends StatelessWidget {
  final RemoteSystemMetrics metrics;
  const _MetricsFooter({required this.metrics});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final captured = relativeTime(metrics.collectedAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DiskUsageLine(metrics: metrics),
        Spacing.verticalXxs,
        Row(
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.memory,
                    size: 13,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      metrics.ramBytes != null
                          ? formatBytes(metrics.ramBytes!)
                          : '—',
                      style: labelStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Spacing.horizontalMd,
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.developer_board,
                    size: 13,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      metrics.cpuCores != null
                          ? '${metrics.cpuCores} cores'
                          : '—',
                      style: labelStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(captured, style: labelStyle),
          ],
        ),
      ],
    );
  }
}

class _DiskUsageLine extends StatelessWidget {
  final RemoteSystemMetrics metrics;
  const _DiskUsageLine({required this.metrics});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (metrics.disks.isEmpty) {
      return Row(
        children: [
          Icon(
            Icons.storage_outlined,
            size: 13,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            'No disk data yet',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    }
    final primary = metrics.disks.firstWhere(
      (d) =>
          d.mountPoint == '/' ||
          d.mountPoint.toUpperCase().startsWith('C:'),
      orElse: () =>
          metrics.disks.reduce((a, b) => a.totalBytes >= b.totalBytes ? a : b),
    );
    final ratio = primary.totalBytes > 0
        ? (primary.usedBytes / primary.totalBytes).clamp(0.0, 1.0)
        : 0.0;
    return Row(
      children: [
        Icon(
          Icons.storage_outlined,
          size: 13,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 4,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              color: ratio > 0.9
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${formatBytes(primary.usedBytes)} / ${formatBytes(primary.totalBytes)}',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _FleetFooter extends StatelessWidget {
  final List<ServerEntity> servers;
  final List<SshSessionEntity> sessions;
  const _FleetFooter({required this.servers, required this.sessions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final connectedIds = sessions
        .where((s) => s.status == SshConnectionStatus.connected)
        .map((s) => s.serverId)
        .toSet();
    final connectedCount = servers
        .where((s) => connectedIds.contains(s.id))
        .length;
    final neverConnected = servers
        .where((s) => s.lastConnectedAt == null)
        .length;

    final diskRatios = <double>[];
    for (final server in servers) {
      final metrics = _parseMetrics(server.systemMetricsJson);
      if (metrics == null || metrics.disks.isEmpty) continue;
      final primary = metrics.disks.reduce(
        (a, b) => a.totalBytes >= b.totalBytes ? a : b,
      );
      if (primary.totalBytes > 0) {
        diskRatios.add(primary.usedBytes / primary.totalBytes);
      }
    }
    final avgDisk = diskRatios.isEmpty
        ? null
        : (diskRatios.reduce((a, b) => a + b) / diskRatios.length * 100)
              .round();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.xxl,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: DefaultTextStyle(
        style: theme.textTheme.labelSmall!.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        child: Row(
          children: [
            Text('${servers.length} hosts'),
            Spacing.horizontalLg,
            Text('$connectedCount connected'),
            if (neverConnected > 0) ...[
              Spacing.horizontalLg,
              Text('$neverConnected never connected'),
            ],
            if (avgDisk != null) ...[
              Spacing.horizontalLg,
              Text('avg disk $avgDisk%'),
            ],
          ],
        ),
      ),
    );
  }
}

RemoteSystemMetrics? _parseMetrics(String? raw) {
  if (raw == null) return null;
  try {
    final value = jsonDecode(raw);
    if (value is! Map) return null;
    return RemoteSystemMetrics.fromJson(Map<String, Object?>.from(value));
  } catch (_) {
    return null;
  }
}

// ---------------------------------------------------------------------------
// Sessions
// ---------------------------------------------------------------------------

class _SessionsView extends ConsumerWidget {
  const _SessionsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final sessions = ref.watch(sessionManagerProvider);

    if (sessions.isEmpty) {
      return const EmptyState(
        icon: Icons.terminal_outlined,
        title: 'No active sessions',
        subtitle: 'Connect to a host from Fleet to start a session.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.xxl,
        vertical: Spacing.md,
      ),
      itemCount: sessions.length,
      separatorBuilder: (_, _) => Spacing.verticalSm,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return SectionCard(
          child: Row(
            children: [
              _SessionStatusDot(status: session.status),
              Spacing.horizontalMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(session.title, style: theme.textTheme.titleSmall),
                    Text(
                      _sessionSubtitle(session),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.open_in_new),
                tooltip: 'Open terminal',
                onPressed: () {
                  ref.read(activeSessionIndexProvider.notifier).state = index;
                  ref
                      .read(shellNavigationProvider)
                      ?.goBranch(AppConstants.terminalBranchIndex);
                },
              ),
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: l10n.disconnect,
                onPressed: () => ref
                    .read(sessionManagerProvider.notifier)
                    .closeSession(session.id),
              ),
            ],
          ),
        );
      },
    );
  }

  String _sessionSubtitle(SshSessionEntity s) => switch (s.status) {
    SshConnectionStatus.connecting => 'Connecting…',
    SshConnectionStatus.authenticating => 'Authenticating…',
    SshConnectionStatus.connected => 'Connected · ${relativeTime(s.createdAt)}',
    SshConnectionStatus.disconnected => 'Disconnected',
    SshConnectionStatus.error => s.errorMessage ?? 'Connection error',
  };
}

class _SessionStatusDot extends StatelessWidget {
  final SshConnectionStatus status;
  const _SessionStatusDot({required this.status});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Color color;
    switch (status) {
      case SshConnectionStatus.connected:
        color = Colors.green;
      case SshConnectionStatus.connecting:
      case SshConnectionStatus.authenticating:
        color = Colors.amber;
      case SshConnectionStatus.error:
        color = Colors.red;
      case SshConnectionStatus.disconnected:
        color = colorScheme.outlineVariant;
    }
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

// ---------------------------------------------------------------------------
// Activity
// ---------------------------------------------------------------------------

class _ActivityView extends ConsumerWidget {
  const _ActivityView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final recentsAsync = ref.watch(recentServersProvider);

    return recentsAsync.when(
      data: (servers) {
        if (servers.isEmpty) {
          return const EmptyState(
            icon: Icons.history,
            title: 'No recent activity',
            subtitle: 'Hosts you connect to will show up here.',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.xxl,
            vertical: Spacing.md,
          ),
          itemCount: servers.length,
          separatorBuilder: (_, _) => Spacing.verticalSm,
          itemBuilder: (context, index) {
            final server = servers[index];
            return SectionCard(
              child: Row(
                children: [
                  Icon(
                    IconConstants.getIcon(server.iconName),
                    color: Color(server.color),
                  ),
                  Spacing.horizontalMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(server.name, style: theme.textTheme.titleSmall),
                        Text(
                          server.lastConnectedAt != null
                              ? 'Last connected ${relativeTime(server.lastConnectedAt!)} ago'
                              : 'Never connected',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.terminal),
                    tooltip: l10n.serverConnect,
                    onPressed: () async {
                      await ref
                          .read(sessionManagerProvider.notifier)
                          .openSession(server.id);
                      ref
                          .read(shellNavigationProvider)
                          ?.goBranch(AppConstants.terminalBranchIndex);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, _) => ErrorState(
        error: error,
        onRetry: () => ref.invalidate(recentServersProvider),
      ),
    );
  }
}
