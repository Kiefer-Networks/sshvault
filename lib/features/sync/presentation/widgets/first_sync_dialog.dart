import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

enum FirstSyncStrategy { merge, overwriteLocal, keepLocal, deleteLocalAndPull }

Future<FirstSyncStrategy?> showFirstSyncDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final theme = Theme.of(context);

  return showDialog<FirstSyncStrategy>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.firstSyncTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.firstSyncMessage),
          Spacing.verticalLg,
          _StrategyOption(
            icon: Icons.merge,
            label: l10n.firstSyncMerge,
            color: theme.colorScheme.primary,
            onTap: () => Navigator.pop(ctx, FirstSyncStrategy.merge),
          ),
          Spacing.verticalSm,
          _StrategyOption(
            icon: Icons.cloud_download_outlined,
            label: l10n.firstSyncOverwriteLocal,
            color: theme.colorScheme.secondary,
            onTap: () => Navigator.pop(ctx, FirstSyncStrategy.overwriteLocal),
          ),
          Spacing.verticalSm,
          _StrategyOption(
            icon: Icons.cloud_upload_outlined,
            label: l10n.firstSyncKeepLocal,
            color: theme.colorScheme.tertiary,
            onTap: () => Navigator.pop(ctx, FirstSyncStrategy.keepLocal),
          ),
          Spacing.verticalSm,
          _StrategyOption(
            icon: Icons.delete_outline,
            label: l10n.firstSyncDeleteLocal,
            color: theme.colorScheme.error,
            onTap: () =>
                Navigator.pop(ctx, FirstSyncStrategy.deleteLocalAndPull),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.cancel),
        ),
      ],
    ),
  );
}

class _StrategyOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _StrategyOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            Spacing.horizontalMd,
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ),
            Icon(Icons.chevron_right, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}
