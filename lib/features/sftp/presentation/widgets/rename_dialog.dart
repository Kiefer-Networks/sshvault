import 'package:flutter/material.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive_dialog.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

class RenameDialog {
  static Future<String?> show(
    BuildContext context, {
    required String currentName,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: currentName);
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: currentName.contains('.')
          ? currentName.lastIndexOf('.')
          : currentName.length,
    );

    return showAdaptiveFormDialog<String>(
      context,
      title: l10n.sftpRenameTitle,
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: l10n.sftpRenameLabel,
          border: const OutlineInputBorder(),
        ),
        onSubmitted: (value) => Navigator.pop(context, value.trim()),
      ),
      materialActions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        Spacing.horizontalSm,
        FilledButton(
          onPressed: () => Navigator.pop(context, controller.text.trim()),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
