import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/core/widgets/settings/settings.dart';
import 'package:shellvault/features/connection/presentation/providers/export_import_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/server_providers.dart';
import 'package:shellvault/features/connection/presentation/widgets/export_password_dialog.dart';
import 'package:shellvault/features/connection/presentation/widgets/import_conflict_dialog.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class ExportSettingsScreen extends ConsumerWidget {
  const ExportSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final exportState = ref.watch(exportImportNotifierProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AdaptiveScaffold(
      title: l10n.settingsSectionExport,
      body: settingsAsync.when(
        data: (settings) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // Export Section
            const SizedBox(height: 8),
            SectionHeader(title: l10n.exportSectionTitle),
            SettingsGroupCard(
              children: [
                SettingsSwitchTile(
                  icon: Icons.enhanced_encryption_outlined,
                  iconColor: Colors.deepOrange,
                  title: l10n.settingsEncryptExport,
                  value: settings.encryptExportByDefault,
                  onChanged: (v) {
                    ref
                        .read(settingsProvider.notifier)
                        .setEncryptExportByDefault(v);
                  },
                ),
                SettingsTile(
                  icon: Icons.description_outlined,
                  iconColor: Colors.blue,
                  title: l10n.settingsExportJson,
                  subtitleText: l10n.exportJsonButton,
                  onTap: () => _exportJson(context, ref),
                ),
                SettingsTile(
                  icon: Icons.lock_outlined,
                  iconColor: Colors.deepPurple,
                  title: l10n.settingsExportEncrypted,
                  subtitleText: l10n.exportZipButton,
                  onTap: () => _exportEncrypted(context, ref),
                ),
              ],
            ),

            // Import Section
            const SizedBox(height: 16),
            SectionHeader(title: l10n.settingsSectionImport),
            SettingsGroupCard(
              children: [
                SettingsTile(
                  icon: Icons.file_open_outlined,
                  iconColor: Colors.teal,
                  title: l10n.settingsImportFile,
                  subtitleText: l10n.importSupportedFormats,
                  onTap: () => _importFile(context, ref),
                ),
              ],
            ),

            // Status
            const SizedBox(height: 16),
            if (exportState.isLoading)
              const Center(child: CircularProgressIndicator.adaptive()),
            if (exportState.hasError)
              Card(
                color: theme.colorScheme.error.withAlpha(AppConstants.alpha26),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    l10n.error(exportState.error.toString()),
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              ),
            if (exportState.hasValue && exportState.value != null)
              Card(
                color: Colors.green.withAlpha(AppConstants.alpha26),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    exportState.value!,
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) => Center(child: Text(l10n.error(error.toString()))),
      ),
    );
  }

  Future<void> _exportJson(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(exportImportNotifierProvider.notifier);
    await notifier.exportToJson();

    final state = ref.read(exportImportNotifierProvider);
    if (state.hasValue && state.value != null && context.mounted) {
      _showShareOption(context, state.value!);
    }
  }

  Future<void> _exportEncrypted(BuildContext context, WidgetRef ref) async {
    final password = await ExportPasswordDialog.show(context);
    if (password == null) return;

    final notifier = ref.read(exportImportNotifierProvider.notifier);
    await notifier.exportToEncryptedZip(password);

    final state = ref.read(exportImportNotifierProvider);
    if (state.hasValue && state.value != null && context.mounted) {
      _showShareOption(context, state.value!);
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

    final strategy = await ImportConflictDialog.show(context);
    if (strategy == null) return;

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
