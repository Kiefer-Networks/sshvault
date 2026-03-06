import 'package:flutter/material.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

class OverwriteConfirmDialog extends StatelessWidget {
  final String fileName;

  const OverwriteConfirmDialog({super.key, required this.fileName});

  static Future<bool> show(BuildContext context, String fileName) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showAdaptiveConfirmDialog(
      context,
      title: l10n.sftpOverwriteTitle,
      message: l10n.sftpOverwriteMessage(fileName),
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.sftpOverwrite,
      isDestructive: true,
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(l10n.sftpOverwriteTitle),
      content: Text(l10n.sftpOverwriteMessage(fileName)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
          ),
          child: Text(l10n.sftpOverwrite),
        ),
      ],
    );
  }
}
