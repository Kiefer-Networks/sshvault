import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/utils/platform_utils.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

enum FirstSyncStrategy { merge, overwriteLocal, keepLocal, deleteLocalAndPull }

Future<FirstSyncStrategy?> showFirstSyncDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final theme = Theme.of(context);

  if (useCupertinoDesign) {
    return showCupertinoDialog<FirstSyncStrategy>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(l10n.firstSyncTitle),
        content: Text(l10n.firstSyncMessage),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(ctx, FirstSyncStrategy.merge),
            child: Text(l10n.firstSyncMerge),
          ),
          CupertinoDialogAction(
            onPressed: () =>
                Navigator.pop(ctx, FirstSyncStrategy.overwriteLocal),
            child: Text(l10n.firstSyncOverwriteLocal),
          ),
          CupertinoDialogAction(
            onPressed: () =>
                Navigator.pop(ctx, FirstSyncStrategy.keepLocal),
            child: Text(l10n.firstSyncKeepLocal),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () =>
                Navigator.pop(ctx, FirstSyncStrategy.deleteLocalAndPull),
            child: Text(l10n.firstSyncDeleteLocal),
          ),
        ],
      ),
    );
  }

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
          const SizedBox(height: 16),
          _StrategyOption(
            icon: Icons.merge,
            label: l10n.firstSyncMerge,
            color: theme.colorScheme.primary,
            onTap: () => Navigator.pop(ctx, FirstSyncStrategy.merge),
          ),
          const SizedBox(height: 8),
          _StrategyOption(
            icon: Icons.cloud_download_outlined,
            label: l10n.firstSyncOverwriteLocal,
            color: theme.colorScheme.secondary,
            onTap: () => Navigator.pop(ctx, FirstSyncStrategy.overwriteLocal),
          ),
          const SizedBox(height: 8),
          _StrategyOption(
            icon: Icons.cloud_upload_outlined,
            label: l10n.firstSyncKeepLocal,
            color: theme.colorScheme.tertiary,
            onTap: () => Navigator.pop(ctx, FirstSyncStrategy.keepLocal),
          ),
          const SizedBox(height: 8),
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
            const SizedBox(width: 12),
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
