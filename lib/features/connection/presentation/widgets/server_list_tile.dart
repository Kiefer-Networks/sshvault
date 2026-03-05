import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/services/vpn_detector_service.dart';
import 'package:shellvault/core/widgets/settings/circle_icon.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shellvault/core/constants/icon_constants.dart';
import 'package:shellvault/features/connection/domain/entities/server_entity.dart';
import 'package:shellvault/features/connection/presentation/providers/server_reachability_provider.dart';
import 'package:shellvault/features/connection/presentation/widgets/tag_chip.dart';
import 'package:shellvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:shellvault/features/terminal/presentation/providers/terminal_providers.dart';

class ServerListTile extends ConsumerWidget {
  final ServerEntity server;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;
  final VoidCallback? onDetail;

  const ServerListTile({
    super.key,
    required this.server,
    required this.onTap,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
    this.onDetail,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final vpnActive = server.requiresVpn
        ? ref.watch(vpnActiveProvider).value ?? false
        : false;

    // Determine live connection status from sessions
    final sessions = ref.watch(sessionManagerProvider);
    final session = sessions
        .where((s) => s.serverId == server.id)
        .firstOrNull;
    final connectionStatus = session?.status;

    return Slidable(
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
        onTap: onTap,
        leading: CircleIcon(
          icon: IconConstants.getIcon(server.iconName),
          color: Color(server.color),
          size: 44,
        ),
        title: Row(
          children: [
            Expanded(child: Text(server.name, overflow: TextOverflow.ellipsis)),
            if (server.requiresVpn) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.shield_outlined,
                size: 16,
                color: vpnActive
                    ? Colors.green
                    : theme.colorScheme.error,
              ),
            ],
            const SizedBox(width: 8),
            _ConnectionStatusBadge(
              connectionStatus: connectionStatus,
              server: server,
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${server.username}@${server.hostname}:${server.port}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(
                  AppConstants.alpha153,
                ),
                fontFamily: AppConstants.monospaceFontFamily,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (server.tags.isNotEmpty) ...[
              const SizedBox(height: 4),
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
        trailing: onDetail != null
            ? IconButton(
                icon: const Icon(Icons.info_outlined),
                onPressed: onDetail,
                tooltip: l10n.serverDetails,
                visualDensity: VisualDensity.compact,
              )
            : null,
      ),
    );
  }
}

class _ConnectionStatusBadge extends ConsumerWidget {
  final SshConnectionStatus? connectionStatus;
  final ServerEntity server;

  const _ConnectionStatusBadge({
    this.connectionStatus,
    required this.server,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final Color color;
    final bool glow;

    switch (connectionStatus) {
      case SshConnectionStatus.connected:
        color = Colors.green;
        glow = true;
      case SshConnectionStatus.connecting:
      case SshConnectionStatus.authenticating:
        color = Colors.orange;
        glow = true;
      case SshConnectionStatus.error:
        color = colorScheme.error;
        glow = false;
      case SshConnectionStatus.disconnected:
        color = colorScheme.outlineVariant;
        glow = false;
      case null:
        // No active session — show TCP reachability
        final reachability = ref.watch(
          serverReachabilityProvider(server),
        );
        return reachability.when(
          loading: () => _badge(Colors.orange, glow: true),
          error: (_, _) => _badge(colorScheme.error, glow: false),
          data: (reachable) => reachable
              ? _badge(Colors.green, glow: true)
              : _badge(colorScheme.error, glow: false),
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
