import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shellvault/core/theme/glassmorphism.dart';
import 'package:shellvault/features/connection/presentation/providers/export_import_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/server_providers.dart';
import 'package:shellvault/features/connection/presentation/widgets/export_password_dialog.dart';
import 'package:shellvault/features/connection/presentation/widgets/import_conflict_dialog.dart';

class ExportImportScreen extends ConsumerWidget {
  const ExportImportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exportState = ref.watch(exportImportNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Export / Import'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Export Section
          GlassmorphicContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.upload, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text('Export',
                        style: theme.textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _exportJson(context, ref),
                    icon: const Icon(Icons.description),
                    label: const Text('Export as JSON (no credentials)'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _exportEncrypted(context, ref),
                    icon: const Icon(Icons.lock),
                    label: const Text('Export Encrypted ZIP (with credentials)'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Import Section
          GlassmorphicContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.download, color: theme.colorScheme.secondary),
                    const SizedBox(width: 8),
                    Text('Import',
                        style: theme.textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _importFile(context, ref),
                    icon: const Icon(Icons.file_open),
                    label: const Text('Import from File'),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Supports JSON (plain) and ZIP (encrypted) files.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(102),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Status
          if (exportState.isLoading)
            const Center(child: CircularProgressIndicator()),
          if (exportState.hasError)
            Card(
              color: theme.colorScheme.error.withAlpha(26),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Error: ${exportState.error}',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ),
          if (exportState.hasValue && exportState.value != null)
            Card(
              color: Colors.green.withAlpha(26),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  exportState.value!,
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _exportJson(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(exportImportNotifierProvider.notifier);
    await notifier.exportToJson();

    final state = ref.read(exportImportNotifierProvider);
    if (state.hasValue && state.value != null && context.mounted) {
      final path = state.value!;
      _showShareOption(context, path);
    }
  }

  Future<void> _exportEncrypted(BuildContext context, WidgetRef ref) async {
    final password = await ExportPasswordDialog.show(context);
    if (password == null) return;

    final notifier = ref.read(exportImportNotifierProvider.notifier);
    await notifier.exportToEncryptedZip(password);

    final state = ref.read(exportImportNotifierProvider);
    if (state.hasValue && state.value != null && context.mounted) {
      final path = state.value!;
      _showShareOption(context, path);
    }
  }

  void _showShareOption(BuildContext context, String filePath) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exported to: $filePath'),
        action: SnackBarAction(
          label: 'Share',
          onPressed: () {
            Share.shareXFiles([XFile(filePath)]);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Future<void> _importFile(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'zip'],
    );

    if (result == null || result.files.isEmpty) return;
    final filePath = result.files.first.path;
    if (filePath == null || !context.mounted) return;

    // Ask for conflict strategy
    final strategy = await ImportConflictDialog.show(context);
    if (strategy == null) return;

    // If ZIP, ask for password
    String? password;
    if (filePath.endsWith('.zip') && context.mounted) {
      password = await _askImportPassword(context);
      if (password == null) return;
    }

    final notifier = ref.read(exportImportNotifierProvider.notifier);
    final importResult = await notifier.importFromFile(
      filePath,
      strategy,
      password: password,
    );

    if (importResult != null && context.mounted) {
      ref.invalidate(serverListProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Imported ${importResult.serversImported} servers, '
            '${importResult.groupsImported} groups, '
            '${importResult.tagsImported} tags. '
            '${importResult.skipped} skipped.',
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<String?> _askImportPassword(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter Password'),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Export Password',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text),
            child: const Text('Decrypt'),
          ),
        ],
      ),
    );
  }
}
