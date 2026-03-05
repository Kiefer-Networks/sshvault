import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shellvault/features/connection/domain/entities/group_entity.dart';
import 'package:shellvault/features/connection/domain/entities/server_entity.dart';
import 'package:shellvault/features/connection/presentation/providers/folder_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/server_providers.dart';
import 'package:shellvault/features/sftp/domain/entities/sftp_pane_source.dart';
import 'package:shellvault/features/sftp/presentation/providers/sftp_providers.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class SftpServerPicker extends ConsumerWidget {
  final PaneSide side;

  const SftpServerPicker({super.key, required this.side});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paneState = ref.watch(sftpPaneProvider(side));
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final currentLabel = paneState.needsHostSelection
        ? l10n.sftpSelectServer
        : switch (paneState.source) {
            SftpPaneSourceLocal() => l10n.sftpLocalDevice,
            SftpPaneSourceRemote(:final serverName) => serverName,
          };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () async {
          final result = await showDialog<SftpPaneSource>(
            context: context,
            builder: (_) =>
                _ServerPickerDialog(currentSource: paneState.source),
          );
          if (result != null) {
            ref.read(sftpPaneProvider(side).notifier).setSource(result);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Icon(
                paneState.source is SftpPaneSourceLocal
                    ? Icons.phone_android
                    : Icons.dns_outlined,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  currentLabel,
                  style: theme.textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_drop_down, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

final _serverPickerQueryProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);

class _ServerPickerDialog extends ConsumerStatefulWidget {
  final SftpPaneSource currentSource;

  const _ServerPickerDialog({required this.currentSource});

  @override
  ConsumerState<_ServerPickerDialog> createState() =>
      _ServerPickerDialogState();
}

class _ServerPickerDialogState extends ConsumerState<_ServerPickerDialog> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final serversAsync = ref.watch(serverListProvider);
    final foldersAsync = ref.watch(folderListProvider);
    final query = ref.watch(_serverPickerQueryProvider);

    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Text(
                l10n.sftpSelectServer,
                style: theme.textTheme.titleLarge,
              ),
            ),
            // Search field
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.searchServers,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            ref
                                    .read(_serverPickerQueryProvider.notifier)
                                    .state =
                                '';
                          },
                        )
                      : null,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                onChanged: (value) =>
                    ref.read(_serverPickerQueryProvider.notifier).state = value,
              ),
            ),
            const Divider(height: 1),
            // Content
            Flexible(
              child: serversAsync.when(
                data: (servers) {
                  final folders = foldersAsync.value ?? [];
                  return _buildList(context, servers, folders, query);
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<ServerEntity> allServers,
    List<GroupEntity> allGroups,
    String query,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final lowerQuery = query.toLowerCase();

    // Filter servers by search query
    final filtered = lowerQuery.isEmpty
        ? allServers
        : allServers.where((s) {
            return s.name.toLowerCase().contains(lowerQuery) ||
                s.hostname.toLowerCase().contains(lowerQuery) ||
                s.username.toLowerCase().contains(lowerQuery);
          }).toList();

    // Build group map for labels
    final groupMap = <String, String>{for (final g in allGroups) g.id: g.name};

    // Group servers by groupId
    final grouped = <String?, List<ServerEntity>>{};
    for (final server in filtered) {
      (grouped[server.groupId] ??= []).add(server);
    }

    // Sort groups: ungrouped last, then alphabetical
    final sortedGroupIds = grouped.keys.toList()
      ..sort((a, b) {
        if (a == null) return 1;
        if (b == null) return -1;
        final nameA = groupMap[a] ?? '';
        final nameB = groupMap[b] ?? '';
        return nameA.compareTo(nameB);
      });

    // Check if local matches search
    final localLabel = l10n.sftpLocalDevice;
    final showLocal =
        lowerQuery.isEmpty || localLabel.toLowerCase().contains(lowerQuery);

    if (!showLocal && filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.serverListEmpty,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 8),
      children: [
        // Local device option
        if (showLocal) _buildLocalTile(context, theme, l10n),
        // Grouped servers
        for (final groupId in sortedGroupIds) ...[
          if (sortedGroupIds.length > 1 || groupId != null)
            _buildGroupHeader(
              theme,
              groupId != null
                  ? groupMap[groupId] ?? l10n.serverNoFolder
                  : l10n.serverNoFolder,
            ),
          for (final server in grouped[groupId]!)
            _buildServerTile(context, theme, server),
        ],
      ],
    );
  }

  Widget _buildLocalTile(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    final isSelected = widget.currentSource is SftpPaneSourceLocal;

    return ListTile(
      leading: Icon(
        Icons.phone_android,
        color: isSelected ? theme.colorScheme.primary : null,
      ),
      title: Text(
        l10n.sftpLocalDevice,
        style: isSelected
            ? TextStyle(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              )
            : null,
      ),
      selected: isSelected,
      selectedTileColor: theme.colorScheme.primary.withAlpha(20),
      dense: true,
      onTap: () => Navigator.pop(context, const SftpPaneSource.local()),
    );
  }

  Widget _buildGroupHeader(ThemeData theme, String name) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        name,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildServerTile(
    BuildContext context,
    ThemeData theme,
    ServerEntity server,
  ) {
    final isSelected =
        widget.currentSource is SftpPaneSourceRemote &&
        (widget.currentSource as SftpPaneSourceRemote).serverId == server.id;

    return ListTile(
      leading: Icon(
        Icons.dns_outlined,
        color: isSelected ? theme.colorScheme.primary : null,
      ),
      title: Text(
        server.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: isSelected
            ? TextStyle(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              )
            : null,
      ),
      subtitle: Text(
        '${server.username}@${server.hostname}:${server.port}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall,
      ),
      selected: isSelected,
      selectedTileColor: theme.colorScheme.primary.withAlpha(20),
      dense: true,
      onTap: () => Navigator.pop(
        context,
        SftpPaneSource.remote(serverId: server.id, serverName: server.name),
      ),
    );
  }
}
