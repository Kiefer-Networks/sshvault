import 'package:flutter/material.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmLabel;
  final Color? confirmColor;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel,
    this.confirmColor,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmLabel,
    Color? confirmColor,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return showAdaptiveConfirmDialog(
      context,
      title: title,
      message: message,
      cancelLabel: l10n.cancel,
      confirmLabel: confirmLabel ?? l10n.confirmDeleteLabel,
      confirmColor: confirmColor,
      isDestructive: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: confirmColor ?? theme.colorScheme.error,
          ),
          child: Text(confirmLabel ?? l10n.confirmDeleteLabel),
        ),
      ],
    );
  }
}
