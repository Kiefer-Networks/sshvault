import 'package:flutter/material.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive_dialog.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

class CreateSymlinkDialog {
  static Future<({String target, String name})?> show(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final targetController = TextEditingController();
    final nameController = TextEditingController();

    return showAdaptiveFormDialog<({String target, String name})>(
      context,
      title: l10n.sftpCreateSymlink,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: targetController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.sftpSymlinkTarget,
              border: const OutlineInputBorder(),
            ),
          ),
          Spacing.verticalLg,
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: l10n.sftpSymlinkName,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      materialActions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        Spacing.horizontalSm,
        FilledButton(
          onPressed: () {
            final target = targetController.text.trim();
            final name = nameController.text.trim();
            if (target.isNotEmpty && name.isNotEmpty) {
              Navigator.pop(context, (target: target, name: name));
            }
          },
          child: Text(l10n.create),
        ),
      ],
    );
  }
}
