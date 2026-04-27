import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/core/services/secure_clipboard.dart';
import 'package:sshvault/core/widgets/settings/circle_icon.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sshvault/features/connection/domain/entities/ssh_key_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/ssh_agent_provider.dart';
import 'package:sshvault/features/connection/presentation/providers/ssh_key_providers.dart';

class SshKeyTile extends ConsumerWidget {
  final SshKeyEntity sshKey;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const SshKeyTile({
    super.key,
    required this.sshKey,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final linkedServers = ref.watch(serversLinkedToKeyProvider(sshKey.id));
    final serverNames = linkedServers.value ?? [];
    final canDelete = serverNames.isEmpty;
    // Surface a chip when this key is currently held by the running agent.
    // The provider polls every 5 s; if the agent isn't reachable the
    // AsyncValue stays in error state and the chip simply stays hidden.
    final agentKeysAsync = ref.watch(agentKeysProvider);
    final loadedInAgent = agentKeysAsync.maybeWhen(
      data: (keys) => _publicKeyMatchesAny(sshKey.publicKey, keys),
      orElse: () => false,
    );

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          if (onEdit != null)
            SlidableAction(
              onPressed: (_) => onEdit!(),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              icon: Icons.edit,
              label: l10n.edit,
              borderRadius: BorderRadius.circular(12),
            ),
          if (sshKey.publicKey.isNotEmpty)
            SlidableAction(
              onPressed: (_) {
                ref.read(secureClipboardProvider).copyPlain(sshKey.publicKey);
                AdaptiveNotification.show(
                  context,
                  message: l10n.sshKeyTilePublicKeyCopied,
                );
              },
              backgroundColor: theme.colorScheme.tertiary,
              foregroundColor: theme.colorScheme.onTertiary,
              icon: Icons.copy,
              label: l10n.copy,
              borderRadius: BorderRadius.circular(12),
            ),
          if (onDelete != null && canDelete)
            SlidableAction(
              onPressed: (_) => onDelete!(),
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
              icon: Icons.delete,
              label: l10n.delete,
              borderRadius: BorderRadius.circular(12),
            ),
        ],
      ),
      child: ListTile(
        leading: CircleIcon(
          icon: Icons.vpn_key_outlined,
          color: theme.colorScheme.primary,
          size: 44,
        ),
        title: Row(
          children: [
            Expanded(child: Text(sshKey.name, overflow: TextOverflow.ellipsis)),
            Spacing.horizontalSm,
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                sshKey.keyType.displayName,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            if (loadedInAgent) ...[
              Spacing.horizontalSm,
              Tooltip(
                message: 'Loaded in ssh-agent',
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.memory,
                        size: 12,
                        color: theme.colorScheme.onTertiaryContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'agent',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sshKey.fingerprint.isNotEmpty) ...[
              const SizedBox(height: Spacing.xxxs),
              Semantics(
                label: '${sshKey.name} fingerprint: ${sshKey.fingerprint}',
                child: Text(
                  sshKey.fingerprint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: AppConstants.monospaceFontFamily,
                    fontSize: 11,
                    color: theme.colorScheme.onSurface.withAlpha(
                      AppConstants.alpha153,
                    ),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            if (serverNames.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: Spacing.xxxs),
                child: Text(
                  serverNames.map((s) => s.name).join(', '),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(
                      AppConstants.alpha153,
                    ),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        isThreeLine: serverNames.isNotEmpty,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (sshKey.publicKey.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.copy),
                tooltip: l10n.sshKeyTileCopyPublicKey,
                onPressed: () {
                  ref.read(secureClipboardProvider).copyPlain(sshKey.publicKey);
                  AdaptiveNotification.show(
                    context,
                    message: l10n.sshKeyTilePublicKeyCopied,
                  );
                },
                visualDensity: VisualDensity.compact,
              ),
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: l10n.edit,
                onPressed: onEdit,
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
        onTap: onEdit,
      ),
    );
  }

  /// Returns true if any agent-held key has a public-key blob matching the
  /// `authorized_keys`-style line stored on this SSHVault key. The blob is
  /// the second whitespace-delimited token: `<type> <base64-blob> [comment]`.
  static bool _publicKeyMatchesAny(
    String publicKeyLine,
    List<dynamic> agentKeys,
  ) {
    final trimmed = publicKeyLine.trim();
    if (trimmed.isEmpty) return false;
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length < 2) return false;
    final ourBlob = base64.decode(parts[1]);
    for (final k in agentKeys) {
      // Use dynamic dispatch to avoid pulling AgentKey into widget API.
      final blob = (k as dynamic).keyBlob as List<int>;
      if (blob.length != ourBlob.length) continue;
      var equal = true;
      for (var i = 0; i < blob.length; i++) {
        if (blob[i] != ourBlob[i]) {
          equal = false;
          break;
        }
      }
      if (equal) return true;
    }
    return false;
  }
}
