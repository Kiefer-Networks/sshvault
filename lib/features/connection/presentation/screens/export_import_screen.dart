import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sshvault/core/widgets/settings/section_card.dart';
import 'package:sshvault/core/widgets/shell_aware_app_bar.dart';
import 'package:sshvault/features/connection/presentation/providers/export_import_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/connection/presentation/widgets/export_password_dialog.dart';
import 'package:sshvault/features/connection/presentation/widgets/import_conflict_dialog.dart';

class ExportImportScreen extends ConsumerWidget {
  const ExportImportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exportState = ref.watch(exportImportNotifierProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return AdaptiveScaffold.withAppBar(
      appBar: buildShellAppBar(context, title: l10n.exportImportTitle),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Export Section
          SectionCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.upload, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      l10n.exportSectionTitle,
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _exportJson(context, ref),
                    icon: const Icon(Icons.description),
                    label: Text(l10n.exportJsonButton),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: AdaptiveButton.filledIcon(
                    onPressed: () => _exportEncrypted(context, ref),
                    icon: const Icon(Icons.lock),
                    label: Text(l10n.exportZipButton),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Import Section
          SectionCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.download, color: theme.colorScheme.secondary),
                    const SizedBox(width: 8),
                    Text(
                      l10n.importSectionTitle,
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _importFile(context, ref),
                    icon: const Icon(Icons.file_open),
                    label: Text(l10n.importButton),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.importSupportedFormats,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(
                      AppConstants.alpha102,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Status
          if (exportState.isLoading)
            const Center(child: CircularProgressIndicator.adaptive()),
          if (exportState.hasError)
            Card(
              color: theme.colorScheme.error.withAlpha(AppConstants.alpha26),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  l10n.error(errorMessage(exportState.error!)),
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ),
          if (exportState.hasValue && exportState.value != null)
            Card(
              color: theme.colorScheme.tertiaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  exportState.value == importSuccessfulKey
                      ? l10n.importSuccessful
                      : exportState.value!,
                  style: TextStyle(
                    color: theme.colorScheme.onTertiaryContainer,
                  ),
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
    final l10n = AppLocalizations.of(context)!;
    AdaptiveNotification.show(
      context,
      message: l10n.exportedTo(filePath),
      actionLabel: l10n.share,
      onAction: () {
        SharePlus.instance.share(ShareParams(files: [XFile(filePath)]));
      },
      duration: const Duration(seconds: 5),
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
      final l10n = AppLocalizations.of(context)!;
      AdaptiveNotification.show(
        context,
        message: l10n.importResult(
          importResult.serversImported,
          importResult.groupsImported,
          importResult.tagsImported,
          importResult.skipped,
        ),
      );
    }
  }

  Future<String?> _askImportPassword(BuildContext context) async {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    try {
      final result = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.importPasswordTitle),
          content: TextField(
            controller: controller,
            obscureText: true,
            decoration: InputDecoration(labelText: l10n.importPasswordLabel),
            keyboardType: TextInputType.visiblePassword,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(controller.text),
              child: Text(l10n.importPasswordDecrypt),
            ),
          ],
        ),
      );
      return result;
    } finally {
      controller.dispose();
    }
  }
}
