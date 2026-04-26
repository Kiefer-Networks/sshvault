import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/constants/app_colors.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/widgets/settings/settings.dart';
import 'package:sshvault/features/settings/domain/entities/app_settings_entity.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';
import 'package:sshvault/features/terminal/presentation/widgets/terminal_theme_picker.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
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
          padding: Spacing.paddingHorizontalLgVerticalSm,
          children: [
            // Theme & Language
            Spacing.verticalSm,
            SectionHeader(title: l10n.settingsSectionAppearance),
            SettingsGroupCard(
              children: [
                Semantics(
                  label: l10n.settingsTheme,
                  child: SettingsTile(
                    icon: Icons.palette_outlined,
                    iconColor: Theme.of(context).colorScheme.primary,
                    title: l10n.settingsTheme,
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: Spacing.sm),
                      child: AdaptiveSegmentedControl<AppThemeMode>(
                        selected: settings.themeMode,
                        segments: {
                          AppThemeMode.system: l10n.settingsThemeSystem,
                          AppThemeMode.light: l10n.settingsThemeLight,
                          AppThemeMode.dark: l10n.settingsThemeDark,
                        },
                        onChanged: (mode) {
                          ref
                              .read(settingsProvider.notifier)
                              .setThemeMode(mode);
                          AdaptiveNotification.show(
                            context,
                            message: l10n.settingsThemeChanged,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Semantics(
                  button: true,
                  label: l10n.settingsLanguage,
                  child: SettingsTile(
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
                            value: 'ar',
                            label: l10n.settingsLanguageAr,
                          ),
                          SelectionOption(
                            value: 'cs',
                            label: l10n.settingsLanguageCs,
                          ),
                          SelectionOption(
                            value: 'da',
                            label: l10n.settingsLanguageDa,
                          ),
                          SelectionOption(
                            value: 'de',
                            label: l10n.settingsLanguageDe,
                          ),
                          SelectionOption(
                            value: 'el',
                            label: l10n.settingsLanguageEl,
                          ),
                          SelectionOption(
                            value: 'es',
                            label: l10n.settingsLanguageEs,
                          ),
                          SelectionOption(
                            value: 'fi',
                            label: l10n.settingsLanguageFi,
                          ),
                          SelectionOption(
                            value: 'fr',
                            label: l10n.settingsLanguageFr,
                          ),
                          SelectionOption(
                            value: 'he',
                            label: l10n.settingsLanguageHe,
                          ),
                          SelectionOption(
                            value: 'hi',
                            label: l10n.settingsLanguageHi,
                          ),
                          SelectionOption(
                            value: 'hu',
                            label: l10n.settingsLanguageHu,
                          ),
                          SelectionOption(
                            value: 'id',
                            label: l10n.settingsLanguageId,
                          ),
                          SelectionOption(
                            value: 'it',
                            label: l10n.settingsLanguageIt,
                          ),
                          SelectionOption(
                            value: 'ja',
                            label: l10n.settingsLanguageJa,
                          ),
                          SelectionOption(
                            value: 'ko',
                            label: l10n.settingsLanguageKo,
                          ),
                          SelectionOption(
                            value: 'nb',
                            label: l10n.settingsLanguageNb,
                          ),
                          SelectionOption(
                            value: 'nl',
                            label: l10n.settingsLanguageNl,
                          ),
                          SelectionOption(
                            value: 'pl',
                            label: l10n.settingsLanguagePl,
                          ),
                          SelectionOption(
                            value: 'pt',
                            label: l10n.settingsLanguagePt,
                          ),
                          SelectionOption(
                            value: 'ro',
                            label: l10n.settingsLanguageRo,
                          ),
                          SelectionOption(
                            value: 'ru',
                            label: l10n.settingsLanguageRu,
                          ),
                          SelectionOption(
                            value: 'sv',
                            label: l10n.settingsLanguageSv,
                          ),
                          SelectionOption(
                            value: 'th',
                            label: l10n.settingsLanguageTh,
                          ),
                          SelectionOption(
                            value: 'tr',
                            label: l10n.settingsLanguageTr,
                          ),
                          SelectionOption(
                            value: 'uk',
                            label: l10n.settingsLanguageUk,
                          ),
                          SelectionOption(
                            value: 'vi',
                            label: l10n.settingsLanguageVi,
                          ),
                          SelectionOption(
                            value: 'zh',
                            label: l10n.settingsLanguageZh,
                          ),
                        ],
                      );
                      if (v != null) {
                        ref.read(settingsProvider.notifier).setLocale(v);
                        if (context.mounted) {
                          AdaptiveNotification.show(
                            context,
                            message: l10n.settingsLanguageChanged,
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),

            // --- Desktop integration (Linux only) ---
            // The XDG appearance portal exposes the user's preferred color
            // scheme + accent color. Honoring it makes SSHVault feel native
            // on GNOME 42+ and KDE Plasma 6+.
            if (Platform.isLinux) ...[
              Spacing.verticalLg,
              const SectionHeader(title: 'Desktop integration'),
              SettingsGroupCard(
                children: [
                  SettingsSwitchTile(
                    icon: Icons.color_lens_outlined,
                    iconColor: Theme.of(context).colorScheme.primary,
                    title: 'Follow GNOME accent color',
                    subtitleText:
                        'Use the desktop accent color from GNOME / KDE '
                        'Settings as the app theme. Falls back to the '
                        'built-in brand color when unavailable.',
                    value: settings.followDesktopAccent,
                    onChanged: (v) {
                      ref
                          .read(settingsProvider.notifier)
                          .setFollowDesktopAccent(v);
                      AdaptiveNotification.show(
                        context,
                        message: l10n.settingsThemeChanged,
                      );
                    },
                  ),
                ],
              ),
            ],

            // Terminal
            Spacing.verticalLg,
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
                          Tooltip(
                            message: l10n.settingsFontSizeDecreaseTooltip,
                            child: IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: fontSize <= 8
                                  ? null
                                  : () => ref
                                        .read(terminalFontSizeProvider.notifier)
                                        .decrease(),
                            ),
                          ),
                          Tooltip(
                            message: l10n.settingsFontSizeIncreaseTooltip,
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: fontSize >= 24
                                  ? null
                                  : () => ref
                                        .read(terminalFontSizeProvider.notifier)
                                        .increase(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
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

  String _localeLabel(AppLocalizations l10n, String locale) {
    return switch (locale) {
      'ar' => l10n.settingsLanguageAr,
      'cs' => l10n.settingsLanguageCs,
      'da' => l10n.settingsLanguageDa,
      'de' => l10n.settingsLanguageDe,
      'el' => l10n.settingsLanguageEl,
      'en' => l10n.settingsLanguageEn,
      'es' => l10n.settingsLanguageEs,
      'fi' => l10n.settingsLanguageFi,
      'fr' => l10n.settingsLanguageFr,
      'he' => l10n.settingsLanguageHe,
      'hi' => l10n.settingsLanguageHi,
      'hu' => l10n.settingsLanguageHu,
      'id' => l10n.settingsLanguageId,
      'it' => l10n.settingsLanguageIt,
      'ja' => l10n.settingsLanguageJa,
      'ko' => l10n.settingsLanguageKo,
      'nb' => l10n.settingsLanguageNb,
      'nl' => l10n.settingsLanguageNl,
      'pl' => l10n.settingsLanguagePl,
      'pt' => l10n.settingsLanguagePt,
      'ro' => l10n.settingsLanguageRo,
      'ru' => l10n.settingsLanguageRu,
      'sv' => l10n.settingsLanguageSv,
      'th' => l10n.settingsLanguageTh,
      'tr' => l10n.settingsLanguageTr,
      'uk' => l10n.settingsLanguageUk,
      'vi' => l10n.settingsLanguageVi,
      'zh' => l10n.settingsLanguageZh,
      _ => l10n.settingsLanguageSystem,
    };
  }
}
