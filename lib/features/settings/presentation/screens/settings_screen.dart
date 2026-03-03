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
    final colorScheme = Theme.of(context).colorScheme;

    return AdaptiveScaffold(
      title: l10n.settingsTitle,
      body: settingsAsync.when(
        data: (settings) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              // ── Appearance ──────────────────────────────────────────
              _SettingsGroup(
                title: l10n.settingsSectionAppearance,
                children: [
                  _SettingsTile(
                    icon: Icons.palette_outlined,
                    iconColor: colorScheme.primary,
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
                          ref
                              .read(settingsProvider.notifier)
                              .setThemeMode(mode);
                        },
                      ),
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.language,
                    iconColor: colorScheme.tertiary,
                    title: l10n.settingsLanguage,
                    subtitleText: _localeLabel(l10n, settings.locale),
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
                ],
              ),

              // ── Terminal ───────────────────────────────────────────
              _SettingsGroup(
                title: l10n.settingsSectionTerminal,
                children: [
                  Builder(
                    builder: (context) {
                      final themeKeyAsync =
                          ref.watch(terminalThemeKeyProvider);
                      return _SettingsTile(
                        icon: Icons.color_lens_outlined,
                        iconColor: Colors.deepPurple,
                        title: l10n.settingsTerminalTheme,
                        subtitleText: themeKeyAsync.when(
                          data: (key) => key.displayName,
                          loading: () => l10n.loading,
                          error: (_, _) =>
                              l10n.settingsTerminalThemeDefault,
                        ),
                        onTap: () => TerminalThemePicker.show(context),
                      );
                    },
                  ),
                  Builder(
                    builder: (context) {
                      final fontSizeAsync =
                          ref.watch(terminalFontSizeProvider);
                      final fontSize = fontSizeAsync.value ?? 14.0;
                      return _SettingsTile(
                        icon: Icons.text_fields_outlined,
                        iconColor: Colors.teal,
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
                                        .read(
                                          terminalFontSizeProvider.notifier,
                                        )
                                        .decrease(),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: fontSize >= 24
                                  ? null
                                  : () => ref
                                        .read(
                                          terminalFontSizeProvider.notifier,
                                        )
                                        .increase(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),

              // ── SSH Defaults ───────────────────────────────────────
              _SettingsGroup(
                title: l10n.settingsSectionSshDefaults,
                children: [
                  _SettingsTile(
                    icon: Icons.numbers,
                    iconColor: Colors.orange,
                    title: l10n.settingsDefaultPort,
                    subtitleText: settings.defaultSshPort.toString(),
                    onTap: () =>
                        _editPort(l10n, settings.defaultSshPort),
                  ),
                  _SettingsTile(
                    icon: Icons.person_outline,
                    iconColor: Colors.blue,
                    title: l10n.settingsDefaultUsername,
                    subtitleText: settings.defaultUsername,
                    onTap: () =>
                        _editUsername(l10n, settings.defaultUsername),
                  ),
                ],
              ),

              // ── Security ───────────────────────────────────────────
              _SettingsGroup(
                title: l10n.settingsSectionSecurity,
                children: [
                  _SettingsTile(
                    icon: Icons.lock_clock_outlined,
                    iconColor: Colors.red,
                    title: l10n.settingsAutoLock,
                    subtitleText: settings.autoLockMinutes == 0
                        ? l10n.settingsAutoLockDisabled
                        : l10n.settingsAutoLockMinutes(
                            settings.autoLockMinutes,
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
                          if (!available) {
                            return l10n.settingsBiometricNotAvailable;
                          }
                          if (!settings.hasPin) {
                            return l10n.settingsBiometricRequiresPin;
                          }
                          return null;
                        },
                        loading: () => null,
                        error: (_, _) => l10n.settingsBiometricError,
                      );
                      return _SettingsSwitchTile(
                        icon: Icons.fingerprint,
                        iconColor: Colors.green,
                        title: l10n.settingsBiometricUnlock,
                        subtitleText: subtitleText,
                        value: settings.biometricUnlock,
                        onChanged: biometricAvailable.maybeWhen(
                          data: (available) =>
                              available && settings.hasPin
                                  ? (v) async {
                                      if (v) {
                                        final service = ref.read(
                                          biometricServiceProvider,
                                        );
                                        final success =
                                            await service.authenticate(
                                          reason:
                                              l10n.settingsBiometricReason,
                                        );
                                        if (success) {
                                          ref
                                              .read(
                                                settingsProvider.notifier,
                                              )
                                              .setBiometricUnlock(true);
                                        }
                                      } else {
                                        ref
                                            .read(
                                              settingsProvider.notifier,
                                            )
                                            .setBiometricUnlock(false);
                                      }
                                    }
                                  : null,
                          orElse: () => null,
                        ),
                      );
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.pin,
                    iconColor: Colors.indigo,
                    title: l10n.settingsPinCode,
                    subtitleText: settings.hasPin
                        ? l10n.settingsPinIsSet
                        : l10n.settingsPinNotConfigured,
                    trailing: settings.hasPin
                        ? TextButton(
                            onPressed: () => _confirmRemovePin(l10n),
                            child: Text(l10n.settingsPinRemove),
                          )
                        : null,
                    onTap: () async {
                      final pin = await PinDialog.showSetPin(context);
                      if (pin != null) {
                        await ref
                            .read(settingsProvider.notifier)
                            .setPinCode(pin);
                      }
                    },
                  ),
                  if (ScreenProtectionService.isSupported)
                    _SettingsSwitchTile(
                      icon: Icons.screenshot_monitor_outlined,
                      iconColor: Colors.amber.shade800,
                      title: l10n.settingsPreventScreenshots,
                      subtitleText:
                          l10n.settingsPreventScreenshotsDescription,
                      value: settings.preventScreenshots,
                      onChanged: (v) {
                        ref
                            .read(settingsProvider.notifier)
                            .setPreventScreenshots(v);
                      },
                    ),
                ],
              ),

              // ── Network & DNS ──────────────────────────────────────
              _SettingsGroup(
                title: l10n.settingsSectionNetwork,
                children: [
                  _SettingsTile(
                    icon: Icons.dns_outlined,
                    iconColor: Colors.cyan,
                    title: l10n.settingsDnsServers,
                    subtitleText: settings.dnsServers.isEmpty
                        ? l10n.settingsDnsDefault
                        : settings.dnsServers,
                    onTap: () =>
                        _editDnsServers(l10n, settings.dnsServers),
                  ),
                ],
              ),

              // ── Export ─────────────────────────────────────────────
              _SettingsGroup(
                title: l10n.settingsSectionExport,
                children: [
                  _SettingsSwitchTile(
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
                ],
              ),

              // ── Sync ───────────────────────────────────────────────
              _SettingsGroup(
                title: l10n.settingsSectionSync,
                children: [
                  Builder(
                    builder: (context) {
                      final authState = ref.watch(authProvider);
                      final isAuthenticated =
                          authState.value == AuthStatus.authenticated;
                      return _SettingsTile(
                        icon: Icons.account_circle_outlined,
                        iconColor: colorScheme.primary,
                        title: l10n.settingsSyncAccount,
                        subtitle: FutureBuilder<String>(
                          future: _getUserEmail(ref),
                          builder: (_, snap) => Text(
                            isAuthenticated
                                ? (snap.data ?? l10n.loading)
                                : l10n.settingsSyncNotLoggedIn,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push(
                          isAuthenticated ? '/sync-settings' : '/login',
                        ),
                      );
                    },
                  ),
                  _SettingsSwitchTile(
                    icon: Icons.sync_outlined,
                    iconColor: Colors.lightBlue,
                    title: l10n.syncAutoSync,
                    value: settings.autoSync,
                    onChanged: (v) {
                      ref.read(settingsProvider.notifier).setAutoSync(v);
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.cloud_outlined,
                    iconColor: Colors.blueGrey,
                    title: l10n.settingsSyncServerUrl,
                    subtitleText: settings.serverUrl.isEmpty
                        ? l10n.settingsSyncDefaultServer
                        : settings.serverUrl,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/server-config'),
                  ),
                  Builder(
                    builder: (context) {
                      final authState = ref.watch(authProvider);
                      final isAuthenticated =
                          authState.value == AuthStatus.authenticated;
                      if (!isAuthenticated) return const SizedBox.shrink();
                      return _SettingsTile(
                        icon: Icons.logout,
                        iconColor: colorScheme.error,
                        title: l10n.accountLogout,
                        onTap: () async {
                          await ref.read(authProvider.notifier).logout();
                        },
                      );
                    },
                  ),
                ],
              ),

              // ── Support ────────────────────────────────────────────
              _SettingsGroup(
                title: l10n.settingsSectionSupport,
                children: [
                  _SettingsTile(
                    icon: Icons.download_outlined,
                    iconColor: Colors.brown,
                    title: l10n.settingsDownloadLogs,
                    onTap: () => _downloadLogs(l10n),
                  ),
                  _SettingsTile(
                    icon: Icons.email_outlined,
                    iconColor: Colors.pink,
                    title: l10n.settingsSendLogs,
                    onTap: () => _sendLogsToSupport(l10n),
                  ),
                  _SettingsTile(
                    icon: Icons.favorite_outlined,
                    iconColor: Colors.red,
                    title: l10n.supportProjectTitle,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/support'),
                  ),
                ],
              ),

              // ── About ─────────────────────────────────────────────
              _SettingsGroup(
                title: l10n.settingsSectionAbout,
                children: [
                  _SettingsTile(
                    icon: Icons.info_outline,
                    iconColor: colorScheme.secondary,
                    title: l10n.settingsAbout,
                    onTap: () => app.showAppAboutDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) =>
            Center(child: Text(l10n.error(error.toString()))),
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

  Future<void> _editDnsServers(
    AppLocalizations l10n,
    String current,
  ) async {
    final controller = TextEditingController(text: current);
    final result = await showAdaptiveFormDialog<String>(
      context,
      title: l10n.settingsDnsServers,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settingsDnsHint,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: l10n.settingsDnsLabel,
              hintText:
                  'https://cloudflare-dns.com/dns-query,\nhttps://dns.google/resolve',
            ),
            keyboardType: TextInputType.url,
          ),
        ],
      ),
      materialActions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, ''),
          child: Text(l10n.settingsDnsReset),
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
          onPressed: () => Navigator.pop(context, ''),
          child: Text(l10n.settingsDnsReset),
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
      ref.read(settingsProvider.notifier).setDnsServers(result);
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

// ─────────────────────────────────────────────────────────────────────────────
// Android 16–style settings widgets
// ─────────────────────────────────────────────────────────────────────────────

/// A grouped settings section with a colored header and rounded card.
class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsGroup({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            clipBehavior: Clip.antiAlias,
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

/// A single settings row with a colored circular icon.
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitleText;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitleText,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _CircleIcon(icon: icon, color: iconColor),
      title: Text(title),
      subtitle: subtitle ??
          (subtitleText != null
              ? Text(
                  subtitleText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                )
              : null),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

/// A settings row with a switch toggle.
class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitleText;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _SettingsSwitchTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitleText,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: _CircleIcon(icon: icon, color: iconColor),
      title: Text(title),
      subtitle: subtitleText != null
          ? Text(
              subtitleText!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      value: value,
      onChanged: onChanged,
    );
  }
}

/// A small circular background behind the icon, matching Android 16 style.
class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _CircleIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}
