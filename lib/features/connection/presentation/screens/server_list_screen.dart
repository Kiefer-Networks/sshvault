import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/constants/icon_constants.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/core/routing/shell_navigation_provider.dart';
import 'package:sshvault/core/utils/ssh_config_parser.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/widgets/error_state.dart';
import 'package:sshvault/core/widgets/shell_aware_app_bar.dart';
import 'package:sshvault/core/constants/color_constants.dart';
import 'package:sshvault/features/connection/domain/entities/auth_method.dart';
import 'package:sshvault/features/connection/domain/entities/server_credentials.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/connection/domain/entities/server_filter.dart';
import 'package:sshvault/features/connection/domain/entities/ssh_key_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/ssh_key_providers.dart';
import 'package:sshvault/core/crypto/ssh_key_type.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/connection/presentation/widgets/confirm_dialog.dart';
import 'package:sshvault/features/connection/presentation/widgets/empty_state.dart';
import 'package:sshvault/features/connection/presentation/widgets/search_filter_bar.dart';
import 'package:sshvault/features/connection/presentation/widgets/server_grid_card.dart';
import 'package:sshvault/features/connection/presentation/widgets/server_list_tile.dart';
import 'package:sshvault/features/connection/presentation/widgets/view_mode_toggle.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:sshvault/features/connection/presentation/providers/repository_providers.dart';
import 'package:sshvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

final _sshConfigImportedProvider = StateProvider<bool>((ref) => false);

final _hostFolderExpandedProvider = StateProvider.autoDispose
    .family<bool, String>((ref, key) => true);

class ServerListScreen extends ConsumerWidget {
  const ServerListScreen({super.key});

  static bool get _isDesktop =>
      Platform.isLinux || Platform.isMacOS || Platform.isWindows;

  void _onAddServer(BuildContext context, WidgetRef ref) {
    if (!_isDesktop || !SshConfigParser.configExists) {
      context.push('/server/new');
      return;
    }

    final alreadyImported = ref.read(_sshConfigImportedProvider);
    if (alreadyImported) {
      _askReimportOrManual(context, ref);
    } else {
      _showSshConfigImportDialog(context, ref);
    }
  }

  Future<void> _askReimportOrManual(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.sshConfigImportTitle),
        content: Text(l10n.sshConfigImportAgain),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.sshConfigAddManually),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.sshConfigImportButton),
          ),
        ],
      ),
    );

    if (!context.mounted) return;
    if (result == true) {
      _showSshConfigImportDialog(context, ref);
    } else {
      context.push('/server/new');
    }
  }

  Future<void> _showSshConfigImportDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final entries = await SshConfigParser.parse();

    if (!context.mounted) return;

    if (entries.isEmpty) {
      context.push('/server/new');
      return;
    }

    final selected = List<bool>.filled(entries.length, true);

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final selectedCount = selected.where((s) => s).length;
          return AlertDialog(
            title: Text(l10n.sshConfigImportTitle),
            content: SizedBox(
              width: 480,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.sshConfigImportMessage(entries.length)),
                  Spacing.verticalLg,
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: entries.length,
                      itemBuilder: (_, i) {
                        final e = entries[i];
                        return CheckboxListTile(
                          value: selected[i],
                          onChanged: (v) =>
                              setDialogState(() => selected[i] = v ?? false),
                          title: Text(e.name),
                          subtitle: Text(
                            '${e.username}@${e.hostname}:${e.port}'
                            '${e.identityFile != null ? '  🔑' : ''}',
                          ),
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx, false);
                  context.push('/server/new');
                },
                child: Text(l10n.sshConfigAddManually),
              ),
              FilledButton(
                onPressed: selectedCount > 0
                    ? () => Navigator.pop(ctx, true)
                    : null,
                child: Text(l10n.sshConfigImportButton),
              ),
            ],
          );
        },
      ),
    );

    if (result != true || !context.mounted) return;

    final toImport = <SshConfigEntry>[];
    for (var i = 0; i < entries.length; i++) {
      if (selected[i]) toImport.add(entries[i]);
    }

    // Check if any selected entries reference identity files. Multiple
    // server entries may share the same identity file — collapse them so
    // we never offer to import the same key file twice in the dialog.
    final entriesWithKeys = toImport
        .where((e) => e.identityFile != null)
        .toList();
    final uniqueKeyPaths = <String, SshConfigEntry>{};
    for (final e in entriesWithKeys) {
      uniqueKeyPaths.putIfAbsent(e.identityFile!, () => e);
    }
    var importKeys = false;
    if (uniqueKeyPaths.isNotEmpty && context.mounted) {
      importKeys =
          await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(l10n.sshConfigImportKeys),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final e in uniqueKeyPaths.values)
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.vpn_key_outlined, size: 20),
                      title: Text(e.identityFile!),
                      subtitle: Text(e.name),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(l10n.sshConfigImportButton),
                ),
              ],
            ),
          ) ??
          false;
    }

    // Import SSH keys first so we can link them to servers. Pass the
    // deduplicated key list so each unique identity file is processed once.
    var keysImported = 0;
    final keyIdByPath = <String, String>{};
    if (importKeys) {
      final result = await _importSshKeys(ref, uniqueKeyPaths.values.toList());
      keysImported = result.newlyImported;
      keyIdByPath.addAll(result.idByPath);
    }

    var importedCount = 0;
    final serverNotifier = ref.read(serverListProvider.notifier);
    for (final entry in toImport) {
      try {
        final sshKeyId = entry.identityFile != null
            ? keyIdByPath[entry.identityFile]
            : null;
        final server = ServerEntity(
          id: '',
          name: entry.name,
          hostname: entry.hostname,
          port: entry.port,
          username: entry.username,
          authMethod: entry.identityFile != null
              ? AuthMethod.key
              : AuthMethod.password,
          sshKeyId: sshKeyId,
          color: ColorConstants.defaultServerColor,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await serverNotifier.createServer(server, const ServerCredentials());
        importedCount++;
      } catch (_) {
        // Skip entries that fail
      }
    }

    // Mark as imported and refresh providers
    ref.read(_sshConfigImportedProvider.notifier).state = true;
    ref.invalidate(serverListProvider);
    ref.invalidate(folderGroupedServersProvider);

    if (context.mounted) {
      final messages = <String>[];
      if (importedCount > 0) {
        messages.add(l10n.sshConfigImportSuccess(importedCount));
      }
      if (keysImported > 0) {
        messages.add(l10n.sshConfigKeysImported(keysImported));
      }
      if (messages.isNotEmpty) {
        AdaptiveNotification.show(context, message: messages.join('. '));
      }
    }
  }

  /// Imports SSH keys, deduplicating against keys already in the vault.
  ///
  /// [entries] must already be deduplicated by `identityFile` so we only
  /// touch each on-disk file once.
  ///
  /// Existing keys are matched by their stored private-key content; an
  /// existing match means we reuse the existing id and do not create a
  /// duplicate row.
  static Future<({Map<String, String> idByPath, int newlyImported})>
  _importSshKeys(WidgetRef ref, List<SshConfigEntry> entries) async {
    final keyNotifier = ref.read(sshKeyListProvider.notifier);
    final useCases = ref.read(sshKeyUseCasesProvider);
    final home =
        Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        '';

    // Build a content → existingKeyId index from the current vault.
    final existingByContent = <String, String>{};
    final existingResult = await useCases.getAllSshKeys();
    final existingKeys = existingResult.fold(
      onSuccess: (k) => k,
      onFailure: (_) => <SshKeyEntity>[],
    );
    for (final k in existingKeys) {
      final pkResult = await useCases.getSshKeyPrivateKey(k.id);
      pkResult.fold(
        onSuccess: (priv) {
          if (priv != null && priv.isNotEmpty) {
            existingByContent[priv.trim()] = k.id;
          }
        },
        onFailure: (_) {},
      );
    }

    final idByPath = <String, String>{};
    var newlyImported = 0;

    for (final entry in entries) {
      try {
        final originalPath = entry.identityFile!;
        var path = originalPath;
        if (path.startsWith('~/')) {
          path = '$home${path.substring(1)}';
        }
        final keyFile = File(path);
        if (!keyFile.existsSync()) continue;

        final privateKey = (await keyFile.readAsString()).trim();
        final existingId = existingByContent[privateKey];
        if (existingId != null) {
          // Already in vault — reuse it, do not create a duplicate.
          idByPath[originalPath] = existingId;
          continue;
        }

        final keyType = _detectKeyType(privateKey);
        final keyName = path.split(Platform.pathSeparator).last;
        final created = await keyNotifier.createSshKey(
          SshKeyEntity(
            id: '',
            name: keyName,
            keyType: keyType,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          privateKey: privateKey,
        );
        idByPath[originalPath] = created.id;
        existingByContent[privateKey] = created.id;
        newlyImported++;
      } catch (_) {
        // Skip keys that fail to read or import
      }
    }
    return (idByPath: idByPath, newlyImported: newlyImported);
  }

  static SshKeyType _detectKeyType(String privateKey) {
    if (privateKey.contains('BEGIN OPENSSH PRIVATE KEY')) {
      // Heuristic: check the key data for type hints
      if (privateKey.contains('ssh-ed25519')) return SshKeyType.ed25519;
      if (privateKey.contains('ecdsa-sha2')) return SshKeyType.ecdsa256;
      return SshKeyType.ed25519; // Modern default
    }
    if (privateKey.contains('BEGIN RSA PRIVATE KEY') ||
        privateKey.contains('BEGIN PRIVATE KEY')) {
      return SshKeyType.rsa;
    }
    if (privateKey.contains('BEGIN EC PRIVATE KEY')) {
      return SshKeyType.ecdsa256;
    }
    return SshKeyType.ed25519;
  }

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
        actions: [const ViewModeToggle(), Spacing.horizontalSm],
      ),
      floatingActionButton: Semantics(
        label: l10n.serverAddButton,
        button: true,
        child: Tooltip(
          message: l10n.serverAddButton,
          child: FloatingActionButton(
            heroTag: 'addServerFab',
            tooltip: l10n.serverAddButton,
            onPressed: () => _onAddServer(context, ref),
            child: const Icon(Icons.add),
          ),
        ),
      ),
      body: Column(
        children: [
          const _DashboardHeader(),
          const SearchFilterBar(),
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
              onPressed: () => _onAddServer(context, ref),
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
              onPressed: () => _onAddServer(context, ref),
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

    return Padding(
      padding: EdgeInsets.only(left: group.depth * Spacing.xxl),
      child: ListTile(
        onTap: onToggle,
        tileColor: theme.colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: Icon(
          isUncategorized
              ? Icons.folder_off_outlined
              : IconConstants.getIcon(folder.iconName),
          color: folderColor,
          size: 20,
        ),
        title: Text(
          name,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Badge(
              label: Text('${group.servers.length}'),
              backgroundColor: folderColor.withAlpha(AppConstants.alpha30),
              textColor: folderColor,
            ),
            if (onToggle != null) ...[
              Spacing.horizontalXxs,
              Icon(
                expanded ? Icons.expand_less : Icons.expand_more,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ],
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
