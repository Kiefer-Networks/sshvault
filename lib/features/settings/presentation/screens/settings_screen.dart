import 'dart:io' show File;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/utils/platform_utils.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shellvault/core/network/api_provider.dart';
import 'package:shellvault/core/services/biometric_provider.dart';
import 'package:shellvault/core/services/screen_protection_service.dart';
import 'package:shellvault/core/services/logging_provider.dart';
import 'package:shellvault/core/widgets/pin_dialog.dart';
import 'package:shellvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:shellvault/features/settings/presentation/widgets/about_dialog.dart'
    as app;
import 'package:shellvault/features/terminal/presentation/providers/terminal_providers.dart';
import 'package:shellvault/features/terminal/presentation/widgets/terminal_theme_picker.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;

    return AdaptiveScaffold(
      title: l10n.settingsTitle,
      body: settingsAsync.when(
        data: (settings) {
          return ListView(
            children: [
              // Appearance
              _SectionHeader(title: l10n.settingsSectionAppearance),
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: Text(l10n.settingsTheme),
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
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(l10n.settingsLanguage),
                subtitle: Text(_localeLabel(l10n, settings.locale)),
                trailing: DropdownButton<String>(
                        value: settings.locale.isEmpty ? '' : settings.locale,
                        underline: const SizedBox.shrink(),
                        items: [
                          DropdownMenuItem(
                            value: '',
                            child: Text(l10n.settingsLanguageSystem),
                          ),
                          DropdownMenuItem(
                            value: 'en',
                            child: Text(l10n.settingsLanguageEn),
                          ),
                          DropdownMenuItem(
                            value: 'de',
                            child: Text(l10n.settingsLanguageDe),
                          ),
                          DropdownMenuItem(
                            value: 'es',
                            child: Text(l10n.settingsLanguageEs),
                          ),
                        ],
                        onChanged: (v) {
                          if (v != null) {
                            ref.read(settingsProvider.notifier).setLocale(v);
                          }
                        },
                      ),
              ),
              const Divider(),

              // Terminal
              _SectionHeader(title: l10n.settingsSectionTerminal),
              Builder(
                builder: (context) {
                  final themeKeyAsync = ref.watch(terminalThemeKeyProvider);
                  return ListTile(
                    leading: const Icon(Icons.color_lens_outlined),
                    title: Text(l10n.settingsTerminalTheme),
                    subtitle: Text(
                      themeKeyAsync.when(
                        data: (key) => key.displayName,
                        loading: () => l10n.loading,
                        error: (_, _) => l10n.settingsTerminalThemeDefault,
                      ),
                    ),
                    onTap: () => TerminalThemePicker.show(context),
                  );
                },
              ),
              Builder(
                builder: (context) {
                  final fontSizeAsync = ref.watch(terminalFontSizeProvider);
                  final fontSize = fontSizeAsync.value ?? 14.0;
                  return ListTile(
                    leading: const Icon(Icons.text_fields_outlined),
                    title: Text(l10n.settingsFontSize),
                    subtitle: Text(
                      l10n.settingsFontSizeValue(fontSize.toInt()),
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
              const Divider(),

              // SSH Defaults
              _SectionHeader(title: l10n.settingsSectionSshDefaults),
              ListTile(
                leading: const Icon(Icons.numbers),
                title: Text(l10n.settingsDefaultPort),
                subtitle: Text(settings.defaultSshPort.toString()),
                onTap: () => _editPort(l10n, settings.defaultSshPort),
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(l10n.settingsDefaultUsername),
                subtitle: Text(settings.defaultUsername),
                onTap: () => _editUsername(l10n, settings.defaultUsername),
              ),
              const Divider(),

              // Security
              _SectionHeader(title: l10n.settingsSectionSecurity),
              ListTile(
                leading: const Icon(Icons.lock_clock_outlined),
                title: Text(l10n.settingsAutoLock),
                subtitle: Text(
                  settings.autoLockMinutes == 0
                      ? l10n.settingsAutoLockDisabled
                      : l10n.settingsAutoLockMinutes(settings.autoLockMinutes),
                ),
                trailing: DropdownButton<int>(
                        value: settings.autoLockMinutes,
                        underline: const SizedBox.shrink(),
                        items: [
                          DropdownMenuItem(
                            value: 0,
                            child: Text(l10n.settingsAutoLockOff),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text(l10n.settingsAutoLock1Min),
                          ),
                          DropdownMenuItem(
                            value: 5,
                            child: Text(l10n.settingsAutoLock5Min),
                          ),
                          DropdownMenuItem(
                            value: 15,
                            child: Text(l10n.settingsAutoLock15Min),
                          ),
                          DropdownMenuItem(
                            value: 30,
                            child: Text(l10n.settingsAutoLock30Min),
                          ),
                        ],
                        onChanged: (v) {
                          if (v != null) {
                            ref
                                .read(settingsProvider.notifier)
                                .setAutoLockMinutes(v);
                          }
                        },
                      ),
              ),
              Builder(
                builder: (context) {
                  final biometricAvailable = ref.watch(
                    biometricAvailableProvider,
                  );
                  final subtitleText = biometricAvailable.when(
                    data: (available) {
                      if (!available) return l10n.settingsBiometricNotAvailable;
                      if (!settings.hasPin) {
                        return l10n.settingsBiometricRequiresPin;
                      }
                      return null;
                    },
                    loading: () => null,
                    error: (_, _) => l10n.settingsBiometricError,
                  );
                  return AdaptiveSwitchTile(
                    secondary: const Icon(Icons.fingerprint),
                    title: l10n.settingsBiometricUnlock,
                    subtitle: subtitleText,
                    value: settings.biometricUnlock,
                    onChanged: biometricAvailable.maybeWhen(
                      data: (available) => available && settings.hasPin
                          ? (v) async {
                              if (v) {
                                final service = ref.read(
                                  biometricServiceProvider,
                                );
                                final success = await service.authenticate(
                                  reason: l10n.settingsBiometricReason,
                                );
                                if (success) {
                                  ref
                                      .read(settingsProvider.notifier)
                                      .setBiometricUnlock(true);
                                }
                              } else {
                                ref
                                    .read(settingsProvider.notifier)
                                    .setBiometricUnlock(false);
                              }
                            }
                          : null,
                      orElse: () => null,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.pin),
                title: Text(l10n.settingsPinCode),
                subtitle: Text(
                  settings.hasPin
                      ? l10n.settingsPinIsSet
                      : l10n.settingsPinNotConfigured,
                ),
                trailing: settings.hasPin
                    ? TextButton(
                        onPressed: () => _confirmRemovePin(l10n),
                        child: Text(l10n.settingsPinRemove),
                      )
                    : null,
                onTap: () async {
                  final pin = await PinDialog.showSetPin(context);
                  if (pin != null) {
                    await ref.read(settingsProvider.notifier).setPinCode(pin);
                  }
                },
              ),
              if (ScreenProtectionService.isSupported)
                AdaptiveSwitchTile(
                  secondary: const Icon(Icons.screenshot_monitor_outlined),
                  title: l10n.settingsPreventScreenshots,
                  subtitle: l10n.settingsPreventScreenshotsDescription,
                  value: settings.preventScreenshots,
                  onChanged: (v) {
                    ref
                        .read(settingsProvider.notifier)
                        .setPreventScreenshots(v);
                  },
                ),
              const Divider(),

              // Export
              _SectionHeader(title: l10n.settingsSectionExport),
              AdaptiveSwitchTile(
                secondary: const Icon(Icons.enhanced_encryption_outlined),
                title: l10n.settingsEncryptExport,
                value: settings.encryptExportByDefault,
                onChanged: (v) {
                  ref
                      .read(settingsProvider.notifier)
                      .setEncryptExportByDefault(v);
                },
              ),
              const Divider(),

              // Sync
              _SectionHeader(title: l10n.settingsSectionSync),
              Builder(
                builder: (context) {
                  final authState = ref.watch(authProvider);
                  final isAuthenticated =
                      authState.value == AuthStatus.authenticated;
                  return ListTile(
                    leading: const Icon(Icons.account_circle_outlined),
                    title: Text(l10n.settingsSyncAccount),
                    subtitle: FutureBuilder<String>(
                      future: _getUserEmail(ref),
                      builder: (_, snap) => Text(
                        isAuthenticated
                            ? (snap.data ?? l10n.loading)
                            : l10n.settingsSyncNotLoggedIn,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(
                      isAuthenticated ? '/sync-settings' : '/login',
                    ),
                  );
                },
              ),
              AdaptiveSwitchTile(
                secondary: const Icon(Icons.sync_outlined),
                title: l10n.syncAutoSync,
                value: settings.autoSync,
                onChanged: (v) {
                  ref.read(settingsProvider.notifier).setAutoSync(v);
                },
              ),
              ListTile(
                leading: const Icon(Icons.dns_outlined),
                title: Text(l10n.settingsSyncServerUrl),
                subtitle: Text(
                  settings.serverUrl.isEmpty
                      ? l10n.settingsSyncDefaultServer
                      : settings.serverUrl,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/server-config'),
              ),
              Builder(
                builder: (context) {
                  final authState = ref.watch(authProvider);
                  final isAuthenticated =
                      authState.value == AuthStatus.authenticated;
                  if (!isAuthenticated) return const SizedBox.shrink();
                  return ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(l10n.accountLogout),
                    onTap: () async {
                      await ref.read(authProvider.notifier).logout();
                    },
                  );
                },
              ),
              const Divider(),

              // Support
              _SectionHeader(title: l10n.settingsSectionSupport),
              ListTile(
                leading: const Icon(Icons.download_outlined),
                title: Text(l10n.settingsDownloadLogs),
                onTap: () => _downloadLogs(l10n),
              ),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: Text(l10n.settingsSendLogs),
                onTap: () => _sendLogsToSupport(l10n),
              ),
              ListTile(
                leading: const Icon(Icons.favorite_outlined),
                title: Text(l10n.supportProjectTitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/support'),
              ),
              const Divider(),

              // About
              _SectionHeader(title: l10n.settingsSectionAbout),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(l10n.settingsAbout),
                onTap: () => app.showAppAboutDialog(context),
              ),
            ],
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) => Center(child: Text(l10n.error(error.toString()))),
      ),
    );
  }

  Future<String> _getUserEmail(WidgetRef ref) async {
    final storage = ref.read(secureStorageProvider);
    final result = await storage.getUserEmail();
    return result.isSuccess ? (result.value ?? '') : '';
  }

  String _localeLabel(AppLocalizations l10n, String locale) {
    return switch (locale) {
      'en' => l10n.settingsLanguageEn,
      'de' => l10n.settingsLanguageDe,
      'es' => l10n.settingsLanguageEs,
      _ => l10n.settingsLanguageSystem,
    };
  }

  Future<void> _confirmRemovePin(AppLocalizations l10n) async {
    // Verify current PIN before allowing removal
    final pin = await PinDialog.showVerifyPin(
      context,
      verifier: (pin) async =>
          ref.read(settingsProvider.notifier).verifyPin(pin),
    );
    if (pin == null || !mounted) return;

    final confirmed = await showAdaptiveConfirmDialog(
      context,
      title: l10n.settingsPinRemoveTitle,
      message: l10n.settingsPinRemoveWarning,
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.settingsPinRemove,
      isDestructive: true,
    );
    if (confirmed == true) {
      await ref.read(settingsProvider.notifier).clearPinCode();
    }
  }

  Future<void> _editPort(AppLocalizations l10n, int currentPort) async {
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

  Future<void> _downloadLogs(AppLocalizations l10n) async {
    final logger = ref.read(loggingServiceProvider);

    if (logger.isEmpty) {
      if (!mounted) return;
      AdaptiveNotification.show(context, message: l10n.settingsLogsEmpty);
      return;
    }

    final filePath = await logger.exportToFile();
    if (filePath == null || !mounted) return;

    if (isDesktopPlatform) {
      final savePath = await FilePicker.platform.saveFile(
        dialogTitle: l10n.settingsDownloadLogs,
        fileName: 'shellvault_logs.txt',
      );
      if (savePath == null || !mounted) return;
      await File(filePath).copy(savePath);
    } else {
      await SharePlus.instance.share(ShareParams(files: [XFile(filePath)]));
    }

    if (!mounted) return;
    AdaptiveNotification.show(context, message: l10n.settingsLogsSaved);
  }

  Future<void> _sendLogsToSupport(AppLocalizations l10n) async {
    final logger = ref.read(loggingServiceProvider);

    // Detect platform
    String platform;
    if (kIsWeb) {
      platform = 'Web';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      platform = 'iOS';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      platform = 'Android';
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      platform = 'macOS';
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      platform = 'Windows';
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      platform = 'Linux';
    } else {
      platform = 'Unknown';
    }

    // If logs exist, export and share via share_plus with email intent
    if (!logger.isEmpty && !isDesktopPlatform) {
      final filePath = await logger.exportToFile();
      if (filePath != null && mounted) {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(filePath)],
            subject: 'SSH Vault Support Request',
            text:
                'Please describe your issue:\n\n'
                '---\n'
                'App Version: ${AppConstants.appVersion}\n'
                'Platform: $platform\n'
                '---\n',
          ),
        );
        return;
      }
    }

    // Fallback: open mailto link without attachment
    final mailUri = Uri(
      scheme: 'mailto',
      path: 'support@sshvault.app',
      queryParameters: {
        'subject': 'SSH Vault Support Request',
        'body':
            'Please describe your issue:\n\n'
            '---\n'
            'App Version: ${AppConstants.appVersion}\n'
            'Platform: $platform\n'
            '---\n',
      },
    );

    if (await canLaunchUrl(mailUri)) {
      await launchUrl(mailUri);
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
