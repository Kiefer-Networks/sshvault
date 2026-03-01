import 'package:flutter/material.dart';
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
    return AlertDialog(
      title: const Text('Handle Conflicts'),
      content: const Text(
        'How should existing entries be handled during import?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        OutlinedButton(
          onPressed: () =>
              Navigator.of(context).pop(ImportConflictStrategy.skip),
          child: const Text('Skip Existing'),
        ),
        OutlinedButton(
          onPressed: () =>
              Navigator.of(context).pop(ImportConflictStrategy.rename),
          child: const Text('Rename New'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(context).pop(ImportConflictStrategy.overwrite),
          child: const Text('Overwrite'),
        ),
      ],
    );
  }
}
