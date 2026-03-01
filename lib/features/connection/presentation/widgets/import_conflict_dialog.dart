import 'package:flutter/material.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:shellvault/features/connection/domain/repositories/export_import_repository.dart';

class ImportConflictDialog extends StatelessWidget {
  const ImportConflictDialog({super.key});

  static Future<ImportConflictStrategy?> show(BuildContext context) {
    return showDialog<ImportConflictStrategy>(
      context: context,
      builder: (_) => const ImportConflictDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.importConflictTitle),
      content: Text(l10n.importConflictDescription),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        OutlinedButton(
          onPressed: () =>
              Navigator.of(context).pop(ImportConflictStrategy.skip),
          child: Text(l10n.importConflictSkip),
        ),
        OutlinedButton(
          onPressed: () =>
              Navigator.of(context).pop(ImportConflictStrategy.rename),
          child: Text(l10n.importConflictRename),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(context).pop(ImportConflictStrategy.overwrite),
          child: Text(l10n.importConflictOverwrite),
        ),
      ],
    );
  }
}
