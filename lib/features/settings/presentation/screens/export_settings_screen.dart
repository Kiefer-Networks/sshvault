import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/utils/file_chooser.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/constants/app_colors.dart';
import 'package:sshvault/core/widgets/settings/settings.dart';
import 'package:sshvault/features/connection/presentation/providers/export_import_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/connection/presentation/widgets/export_password_dialog.dart';
import 'package:sshvault/features/connection/presentation/widgets/import_conflict_dialog.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

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
          padding: Spacing.paddingHorizontalLgVerticalSm,
          children: [
            // Export Section
            Spacing.verticalSm,
            SectionHeader(title: l10n.exportSectionTitle),
            SettingsGroupCard(
              children: [
                SettingsSwitchTile(
                  icon: Icons.enhanced_encryption_outlined,
                  iconColor: AppColors.iconDeepOrange,
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
                  iconColor: AppColors.iconBlue,
                  title: l10n.settingsExportJson,
                  subtitleText: l10n.exportJsonButton,
                  onTap: () => _exportJson(context, ref),
                ),
                SettingsTile(
                  icon: Icons.lock_outlined,
                  iconColor: AppColors.iconDeepPurple,
                  title: l10n.settingsExportEncrypted,
                  subtitleText: l10n.exportZipButton,
                  onTap: () => _exportEncrypted(context, ref),
                ),
              ],
            ),

            // Import Section
            Spacing.verticalLg,
            SectionHeader(title: l10n.settingsSectionImport),
            SettingsGroupCard(
              children: [
                SettingsTile(
                  icon: Icons.file_open_outlined,
                  iconColor: AppColors.iconTeal,
                  title: l10n.settingsImportFile,
                  subtitleText: l10n.importSupportedFormats,
                  onTap: () => _importFile(context, ref),
                ),
              ],
            ),

            // Status
            Spacing.verticalLg,
            if (exportState.isLoading)
              const Center(child: CircularProgressIndicator.adaptive()),
            if (exportState.hasError)
              Semantics(
                liveRegion: true,
                child: Card(
                  color: theme.colorScheme.errorContainer,
                  child: Padding(
                    padding: Spacing.paddingAllMd,
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: theme.colorScheme.onErrorContainer,
                          size: 20,
                        ),
                        Spacing.horizontalSm,
                        Expanded(
                          child: Text(
                            errorMessage(exportState.error!),
                            style: TextStyle(
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (exportState.hasValue && exportState.value != null)
              Semantics(
                liveRegion: true,
                child: Card(
                  color: theme.colorScheme.tertiaryContainer,
                  child: Padding(
                    padding: Spacing.paddingAllMd,
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
              ),
            Spacing.verticalLg,
          ],
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) =>
            Center(child: Text(l10n.error(errorMessage(error)))),
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
    final l10n = AppLocalizations.of(context)!;
    final result = await FileChooser.openFile(
      dialogTitle: l10n.fileChooserImportSettings,
      filters: const [FileTypeFilter.json, FileTypeFilter.zip],
    );

    if (result == null) return;
    final filePath = result.path;
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
