import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:flutter/services.dart';
import 'package:sshvault/core/widgets/settings/circle_icon.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sshvault/features/connection/domain/entities/ssh_key_entity.dart';
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
                Clipboard.setData(ClipboardData(text: sshKey.publicKey));
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
              padding: EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 2),
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
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sshKey.fingerprint.isNotEmpty) ...[
              SizedBox(height: Spacing.xxxs),
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
            if (serverNames.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: Spacing.xxxs),
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
