import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/core/widgets/settings/settings.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class SshSettingsScreen extends ConsumerWidget {
  const SshSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;

    return AdaptiveScaffold(
      title: l10n.settingsSectionSshDefaults,
      body: settingsAsync.when(
        data: (settings) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            const SizedBox(height: 8),
            SectionHeader(title: l10n.settingsSectionSshDefaults),
            SettingsGroupCard(
              children: [
                SettingsTile(
                  icon: Icons.numbers,
                  iconColor: Colors.orange,
                  title: l10n.settingsDefaultPort,
                  subtitleText: settings.defaultSshPort.toString(),
                  onTap: () =>
                      _editPort(context, ref, l10n, settings.defaultSshPort),
                ),
                SettingsTile(
                  icon: Icons.person_outline,
                  iconColor: Colors.blue,
                  title: l10n.settingsDefaultUsername,
                  subtitleText: settings.defaultUsername,
                  onTap: () => _editUsername(
                    context,
                    ref,
                    l10n,
                    settings.defaultUsername,
                  ),
                ),
              ],
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

  Future<void> _editPort(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    int currentPort,
  ) async {
    final controller = TextEditingController(text: currentPort.toString());
    final result = await showAdaptiveFormDialog<String>(
      context,
      title: l10n.settingsDefaultPortDialog,
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: l10n.settingsPortLabel,
          hintText: l10n.settingsPortHint,
        ),
      ),
      materialActions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, controller.text),
          child: Text(l10n.save),
        ),
      ],
      cupertinoActions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context, controller.text),
          child: Text(l10n.save),
        ),
      ],
    );
    controller.dispose();
    if (result != null) {
      final port = int.tryParse(result);
      if (port != null && port > 0 && port <= 65535) {
        ref.read(settingsProvider.notifier).setDefaultSshPort(port);
      }
    }
  }

  Future<void> _editUsername(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String currentUsername,
  ) async {
    final controller = TextEditingController(text: currentUsername);
    final result = await showAdaptiveFormDialog<String>(
      context,
      title: l10n.settingsDefaultUsernameDialog,
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: l10n.settingsUsernameLabel,
          hintText: l10n.settingsUsernameHint,
        ),
        keyboardType: TextInputType.text,
      ),
      materialActions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, controller.text),
          child: Text(l10n.save),
        ),
      ],
      cupertinoActions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context, controller.text),
          child: Text(l10n.save),
        ),
      ],
    );
    controller.dispose();
    if (result != null && result.trim().isNotEmpty) {
      ref.read(settingsProvider.notifier).setDefaultUsername(result.trim());
    }
  }
}
