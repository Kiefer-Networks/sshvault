import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/core/services/ios_window_service.dart';
import 'package:sshvault/core/services/vpn_detector_service.dart';
import 'package:sshvault/core/widgets/settings/circle_icon.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sshvault/core/constants/icon_constants.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/server_reachability_provider.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/connection/presentation/widgets/server_refresh_action.dart';
import 'package:sshvault/features/connection/presentation/widgets/tag_chip.dart';
import 'package:sshvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

class ServerListTile extends ConsumerWidget {
  final ServerEntity server;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;
  final VoidCallback? onDetail;
  final VoidCallback? onFavoriteToggle;

  /// Tighter row for the desktop master/detail list columns (Hosts,
  /// Folders, Tags, Keys) — sized to match the command palette's own row
  /// density (17px icon, 9-11px padding) rather than the roomier,
  /// touch-target-sized row this same tile renders on mobile.
  final bool dense;

  const ServerListTile({
    super.key,
    required this.server,
    required this.onTap,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
    this.onDetail,
    this.onFavoriteToggle,
    this.dense = false,
  });

  /// `true` when the running platform is iPadOS (iOS + iPad-sized layout).
  /// On iPhone or any non-iOS host the multi-window action stays hidden.
  static bool _showMultiWindowAction(BuildContext context) {
    if (kIsWeb || !Platform.isIOS) return false;
    return MediaQuery.of(context).size.width > 600;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final vpnActive = server.requiresVpn
        ? ref.watch(vpnActiveProvider).value ?? false
        : false;

    // Determine live connection status from sessions
    final sessions = ref.watch(sessionManagerProvider);
    final session = sessions.where((s) => s.serverId == server.id).firstOrNull;
    final connectionStatus = session?.status;

    final showOpenInWindow = _showMultiWindowAction(context);

    final isDesktop = !kIsWeb && MediaQuery.of(context).size.width >= 1100;
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          if (showOpenInWindow)
            SlidableAction(
              onPressed: (_) =>
                  IosWindowService.instance.openSessionWindow(server.id),
              backgroundColor: theme.colorScheme.secondaryContainer,
              foregroundColor: theme.colorScheme.onSecondaryContainer,
              icon: Icons.open_in_new,
              // Hard-coded English label: this action only appears on iPad
              // and adding a new entry to ~28 ARB files is out of scope.
              label: 'New window',
              borderRadius: BorderRadius.circular(12),
            ),
          SlidableAction(
            onPressed: (_) => onEdit(),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            icon: Icons.edit,
            label: l10n.edit,
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (_) => onDuplicate(),
            backgroundColor: theme.colorScheme.tertiary,
            foregroundColor: theme.colorScheme.onTertiary,
            icon: Icons.copy,
            label: l10n.copy,
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
      child: ListTile(
        dense: dense,
        visualDensity: dense ? VisualDensity.compact : null,
        contentPadding: dense
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 2)
            : null,
        onTap: () {
          ref.read(desktopSelectedServerIdProvider.notifier).state = server.id;
          onTap();
        },
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleIcon(
              icon: IconConstants.getIcon(server.iconName),
              color: Color(server.color),
              size: dense ? 30 : 44,
            ),
            Spacing.horizontalXs,
            ConnectionStatusBadge(
              connectionStatus: connectionStatus,
              server: server,
            ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                server.name,
                overflow: TextOverflow.ellipsis,
                style: dense
                    ? const TextStyle(
                        fontSize: 13.5,
                        fontFamily: AppConstants.monospaceFontFamily,
                      )
                    : null,
              ),
            ),
            if (server.requiresVpn) ...[
              Spacing.horizontalXxs,
              Icon(
                Icons.shield_outlined,
                size: 16,
                color: vpnActive
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.error,
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${server.username}@${server.hostname}:${server.port}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: dense ? 11 : null,
                color: theme.colorScheme.onSurface.withAlpha(
                  AppConstants.alpha153,
                ),
                fontFamily: AppConstants.monospaceFontFamily,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (server.tags.isNotEmpty) ...[
              Spacing.verticalXxs,
              Wrap(
                spacing: 4,
                children: server.tags
                    .take(3)
                    .map((tag) => TagChip(tag: tag))
                    .toList(),
              ),
            ],
          ],
        ),
        isThreeLine: server.tags.isNotEmpty,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onFavoriteToggle != null)
              IconButton(
                icon: Icon(
                  server.isFavorite ? Icons.star : Icons.star_border,
                  color: server.isFavorite
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withAlpha(
                          AppConstants.alpha102,
                        ),
                  size: 20,
                ),
                tooltip: server.isFavorite
                    ? l10n.removeFromFavorites
                    : l10n.addToFavorites,
                onPressed: onFavoriteToggle,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            if (isDesktop)
              PopupMenuButton<String>(
                tooltip: l10n.navMore,
                onSelected: (action) async {
                  if (action == 'edit') {
                    onEdit();
                  } else if (action == 'delete') {
                    onDelete();
                  } else if (action == 'connect') {
                    await ref
                        .read(sessionManagerProvider.notifier)
                        .openSession(server.id);
                  } else if (action == 'refresh') {
                    await refreshServerInfo(context, ref, server);
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
                  const PopupMenuItem(
                    value: 'refresh',
                    child: ListTile(
                      leading: Icon(Icons.refresh),
                      title: Text('Refresh'),
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
                    value: 'delete',
                    child: ListTile(
                      leading: const Icon(Icons.delete),
                      title: Text(l10n.delete),
                    ),
                  ),
                ],
              ),
            if (onDetail != null && !isDesktop)
              IconButton(
                icon: const Icon(Icons.info_outlined),
                onPressed: onDetail,
                tooltip: l10n.serverDetails,
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
      ),
    );
  }
}

/// Shows an active session's live status, or the last-known TCP
/// reachability ([serverReachabilityProvider]) when no session is open.
///
/// Shared between [ServerListTile] and the desktop Operations Console so
/// both surfaces agree on what "online" means for a host.
class ConnectionStatusBadge extends ConsumerWidget {
  final SshConnectionStatus? connectionStatus;
  final ServerEntity server;

  const ConnectionStatusBadge({
    super.key,
    this.connectionStatus,
    required this.server,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final Color color;
    final bool glow;

    switch (connectionStatus) {
      case SshConnectionStatus.connected:
        color = Colors.green;
        glow = true;
      case SshConnectionStatus.connecting:
      case SshConnectionStatus.authenticating:
        color = Colors.amber;
        glow = true;
      case SshConnectionStatus.error:
        color = Colors.red;
        glow = false;
      case SshConnectionStatus.disconnected:
        color = colorScheme.outlineVariant;
        glow = false;
      case null:
        // No active session — show TCP reachability
        final reachability = ref.watch(serverReachabilityProvider(server));
        return reachability.when(
          loading: () => Tooltip(
            message: l10n.serverReachabilityChecking,
            child: _badge(colorScheme.secondary, glow: true),
          ),
          error: (_, _) => Tooltip(
            message: l10n.serverNotReachable,
            child: _badge(colorScheme.error, glow: false),
          ),
          data: (status) {
            final (color, message, glow) = switch (status) {
              ServerReachability.unreachable => (
                Colors.red,
                l10n.serverNotReachable,
                false,
              ),
              ServerReachability.portClosed => (
                Colors.amber,
                l10n.serverPortClosed,
                false,
              ),
              ServerReachability.portOpen => (
                Colors.green,
                l10n.serverPortOpen,
                true,
              ),
            };
            return Tooltip(
              message: message,
              child: _badge(color, glow: glow),
            );
          },
        );
    }

    return _badge(color, glow: glow);
  }

  Widget _badge(Color color, {required bool glow}) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: glow
            ? [
                BoxShadow(
                  color: color.withAlpha(AppConstants.alpha128),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }
}
