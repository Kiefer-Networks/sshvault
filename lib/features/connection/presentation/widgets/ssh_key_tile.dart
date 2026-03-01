import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
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

    return Card(
      child: ListTile(
        leading: Icon(
          Icons.vpn_key_outlined,
          color: theme.colorScheme.primary,
        ),
        title: Text(
          sshKey.name,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              '${sshKey.keyType.displayName}'
              '${sshKey.fingerprint.isNotEmpty ? ' · ${sshKey.fingerprint}' : ''}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (sshKey.linkedServerCount > 0)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  l10n.sshKeyTileLinkedServers(sshKey.linkedServerCount),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (sshKey.publicKey.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                tooltip: l10n.sshKeyTileCopyPublicKey,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: sshKey.publicKey));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.sshKeyTilePublicKeyCopied)),
                  );
                },
              ),
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                tooltip: l10n.edit,
                onPressed: onEdit,
              ),
            if (onDelete != null)
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: canDelete
                      ? theme.colorScheme.error
                      : theme.disabledColor,
                ),
                tooltip: canDelete
                    ? l10n.delete
                    : l10n.sshKeyTileUnlinkFirst,
                onPressed: canDelete ? onDelete : null,
              ),
          ],
        ),
        isThreeLine: sshKey.linkedServerCount > 0,
      ),
    );
  }
}
