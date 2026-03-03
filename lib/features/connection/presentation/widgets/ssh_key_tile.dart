import 'package:flutter/material.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shellvault/features/connection/domain/entities/ssh_key_entity.dart';

class SshKeyTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final canDelete = sshKey.linkedServerCount == 0;

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          if (onEdit != null)
            SlidableAction(
              onPressed: (_) => onEdit!(),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: l10n.edit,
              borderRadius: BorderRadius.circular(12),
            ),
          if (sshKey.publicKey.isNotEmpty)
            SlidableAction(
              onPressed: (_) {
                Clipboard.setData(ClipboardData(text: sshKey.publicKey));
                AdaptiveNotification.show(
                  context,
                  message: l10n.sshKeyTilePublicKeyCopied,
                );
              },
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              icon: Icons.copy,
              label: l10n.copy,
              borderRadius: BorderRadius.circular(12),
            ),
          if (onDelete != null && canDelete)
            SlidableAction(
              onPressed: (_) => onDelete!(),
              backgroundColor: theme.colorScheme.error,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: l10n.delete,
              borderRadius: BorderRadius.circular(12),
            ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withAlpha(AppConstants.alpha26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.vpn_key_outlined,
            color: theme.colorScheme.primary,
            size: 22,
          ),
        ),
        title: Row(
          children: [
            Expanded(child: Text(sshKey.name, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                sshKey.keyType.displayName,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sshKey.fingerprint.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
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
            ],
            if (sshKey.linkedServerCount > 0)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  l10n.sshKeyTileLinkedServers(sshKey.linkedServerCount),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(
                      AppConstants.alpha153,
                    ),
                  ),
                ),
              ),
          ],
        ),
        isThreeLine: sshKey.linkedServerCount > 0,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (sshKey.publicKey.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.copy),
                tooltip: l10n.sshKeyTileCopyPublicKey,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: sshKey.publicKey));
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
}
