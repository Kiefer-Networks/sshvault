import 'package:flutter/material.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive_dialog.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class NewDirectoryDialog {
  static Future<String?> show(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    return showAdaptiveFormDialog<String>(
      context,
      title: l10n.sftpNewFolder,
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: l10n.sftpNewFolderName,
          border: const OutlineInputBorder(),
        ),
        onSubmitted: (value) => Navigator.pop(context, value.trim()),
      ),
      materialActions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        const SizedBox(width: 8),
        FilledButton(
          onPressed: () => Navigator.pop(context, controller.text.trim()),
          child: Text(l10n.create),
        ),
      ],
    );
  }
}
