import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/constants/app_colors.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/widgets/settings/settings.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';
import 'package:sshvault/features/terminal/presentation/widgets/terminal_theme_picker.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

class AppearanceSettingsScreen extends ConsumerWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;

    return AdaptiveScaffold(
      title: l10n.settingsSectionAppearance,
      body: settingsAsync.when(
        data: (settings) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // Theme & Language
            const SizedBox(height: 8),
            SectionHeader(title: l10n.settingsSectionAppearance),
            SettingsGroupCard(
              children: [
                SettingsTile(
                  icon: Icons.palette_outlined,
                  iconColor: Theme.of(context).colorScheme.primary,
                  title: l10n.settingsTheme,
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: AdaptiveSegmentedControl<ThemeMode>(
                      selected: settings.themeMode,
                      segments: {
                        ThemeMode.system: l10n.settingsThemeSystem,
                        ThemeMode.light: l10n.settingsThemeLight,
                        ThemeMode.dark: l10n.settingsThemeDark,
                      },
                      onChanged: (mode) {
                        ref.read(settingsProvider.notifier).setThemeMode(mode);
                      },
                    ),
                  ),
                ),
                SettingsTile(
                  icon: Icons.language,
                  iconColor: Theme.of(context).colorScheme.tertiary,
                  title: l10n.settingsLanguage,
                  subtitleText: _localeLabel(l10n, settings.locale),
                  onTap: () async {
                    final v = await showSettingsSelectionDialog<String>(
                      context: context,
                      title: l10n.settingsLanguage,
                      currentValue: settings.locale.isEmpty
                          ? ''
                          : settings.locale,
                      options: [
                        SelectionOption(
                          value: '',
                          label: l10n.settingsLanguageSystem,
                        ),
                        SelectionOption(
                          value: 'en',
                          label: l10n.settingsLanguageEn,
                        ),
                        SelectionOption(
                          value: 'de',
                          label: l10n.settingsLanguageDe,
                        ),
                        SelectionOption(
                          value: 'es',
                          label: l10n.settingsLanguageEs,
                        ),
                      ],
                    );
                    if (v != null) {
                      ref.read(settingsProvider.notifier).setLocale(v);
                    }
                  },
                ),
              ],
            ),

            // Terminal
            const SizedBox(height: 16),
            SectionHeader(title: l10n.settingsSectionTerminal),
            SettingsGroupCard(
              children: [
                Builder(
                  builder: (context) {
                    final themeKeyAsync = ref.watch(terminalThemeKeyProvider);
                    return SettingsTile(
                      icon: Icons.color_lens_outlined,
                      iconColor: AppColors.iconDeepPurple,
                      title: l10n.settingsTerminalTheme,
                      subtitleText: themeKeyAsync.when(
                        data: (key) => key.displayName,
                        loading: () => l10n.loading,
                        error: (_, _) => l10n.settingsTerminalThemeDefault,
                      ),
                      onTap: () => TerminalThemePicker.show(context),
                    );
                  },
                ),
                Builder(
                  builder: (context) {
                    final fontSizeAsync = ref.watch(terminalFontSizeProvider);
                    final fontSize = fontSizeAsync.value ?? 14.0;
                    return SettingsTile(
                      icon: Icons.text_fields_outlined,
                      iconColor: AppColors.iconTeal,
                      title: l10n.settingsFontSize,
                      subtitleText: l10n.settingsFontSizeValue(
                        fontSize.toInt(),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: fontSize <= 8
                                ? null
                                : () => ref
                                      .read(terminalFontSizeProvider.notifier)
                                      .decrease(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: fontSize >= 24
                                ? null
                                : () => ref
                                      .read(terminalFontSizeProvider.notifier)
                                      .increase(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) =>
            Center(child: Text(l10n.error(errorMessage(error)))),
      ),
    );
  }

  String _localeLabel(AppLocalizations l10n, String locale) {
    return switch (locale) {
      'en' => l10n.settingsLanguageEn,
      'de' => l10n.settingsLanguageDe,
      'es' => l10n.settingsLanguageEs,
      _ => l10n.settingsLanguageSystem,
    };
  }
}
