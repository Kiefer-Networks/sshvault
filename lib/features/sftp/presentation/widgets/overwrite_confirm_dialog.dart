import 'package:flutter/material.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class OverwriteConfirmDialog extends StatelessWidget {
  final String fileName;

  const OverwriteConfirmDialog({super.key, required this.fileName});

  static Future<bool> show(BuildContext context, String fileName) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => OverwriteConfirmDialog(fileName: fileName),
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
