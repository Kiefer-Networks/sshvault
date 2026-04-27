import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/services/biometric_provider.dart';
import 'package:sshvault/core/services/screen_protection_service.dart';
import 'package:sshvault/core/storage/keyring_service.dart';
import 'package:sshvault/core/storage/secure_storage_provider.dart'
    show keyringServiceProvider;
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/widgets/pin_dialog.dart';
import 'package:sshvault/core/constants/app_colors.dart';
import 'package:sshvault/core/widgets/settings/settings.dart';
import 'package:sshvault/core/ssh/windows_ssh_agent.dart';
import 'package:sshvault/features/connection/presentation/providers/ssh_agent_provider.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

class SecuritySettingsScreen extends ConsumerWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;

    return AdaptiveScaffold(
      title: l10n.settingsSectionSecurity,
      body: settingsAsync.when(
        data: (settings) => ListView(
          padding: Spacing.paddingHorizontalLgVerticalSm,
          children: [
            // App Lock section
            Spacing.verticalSm,
            SectionHeader(title: l10n.settingsSectionAppLock),
            SettingsGroupCard(
              children: [
                Semantics(
                  button: true,
                  label: l10n.settingsAutoLock,
                  child: SettingsTile(
                    icon: Icons.lock_clock_outlined,
                    iconColor: AppColors.iconRed,
                    title: l10n.settingsAutoLock,
                    subtitleText: settings.autoLockMinutes == 0
                        ? l10n.settingsAutoLockDisabled
                        : l10n.settingsAutoLockMinutes(
                            settings.autoLockMinutes,
                          ),
                    onTap: () async {
                      final v = await showSettingsSelectionDialog<int>(
                        context: context,
                        title: l10n.settingsAutoLock,
                        currentValue: settings.autoLockMinutes,
                        options: [
                          SelectionOption(
                            value: 0,
                            label: l10n.settingsAutoLockOff,
                          ),
                          SelectionOption(
                            value: 1,
                            label: l10n.settingsAutoLock1Min,
                          ),
                          SelectionOption(
                            value: 5,
                            label: l10n.settingsAutoLock5Min,
                          ),
                          SelectionOption(
                            value: 15,
                            label: l10n.settingsAutoLock15Min,
                          ),
                          SelectionOption(
                            value: 30,
                            label: l10n.settingsAutoLock30Min,
                          ),
                        ],
                      );
                      if (v != null) {
                        ref
                            .read(settingsProvider.notifier)
                            .setAutoLockMinutes(v);
                        if (context.mounted) {
                          AdaptiveNotification.show(
                            context,
                            message: l10n.settingsUpdated,
                          );
                        }
                      }
                    },
                  ),
                ),
                _BiometricTile(settings: settings),
                _PinTile(settings: settings),
                _DuressPinTile(settings: settings),
              ],
            ),

            // Privacy section
            Spacing.verticalLg,
            SectionHeader(title: l10n.settingsSectionPrivacy),
            SettingsGroupCard(
              children: [
                if (ScreenProtectionService.isSupported)
                  SettingsSwitchTile(
                    icon: Icons.screenshot_monitor_outlined,
                    iconColor: AppColors.iconAmber,
                    title: l10n.settingsPreventScreenshots,
                    subtitleText: l10n.settingsPreventScreenshotsDescription,
                    value: settings.preventScreenshots,
                    onChanged: (v) {
                      ref
                          .read(settingsProvider.notifier)
                          .setPreventScreenshots(v);
                      AdaptiveNotification.show(
                        context,
                        message: l10n.settingsUpdated,
                      );
                    },
                  ),
                SettingsTile(
                  icon: Icons.content_paste_off_outlined,
                  iconColor: AppColors.iconPurple,
                  title: l10n.settingsClipboardAutoClear,
                  subtitleText: settings.clipboardAutoClearSecs == 0
                      ? l10n.settingsClipboardAutoClearOff
                      : l10n.settingsClipboardAutoClearValue(
                          settings.clipboardAutoClearSecs,
                        ),
                  onTap: () async {
                    final v = await showSettingsSelectionDialog<int>(
                      context: context,
                      title: l10n.settingsClipboardAutoClear,
                      currentValue: settings.clipboardAutoClearSecs,
                      options: [
                        SelectionOption(
                          value: 0,
                          label: l10n.settingsClipboardAutoClearOff,
                        ),
                        SelectionOption(
                          value: 15,
                          label: l10n.settingsClipboardAutoClearValue(15),
                        ),
                        SelectionOption(
                          value: 30,
                          label: l10n.settingsClipboardAutoClearValue(30),
                        ),
                        SelectionOption(
                          value: 60,
                          label: l10n.settingsClipboardAutoClearValue(60),
                        ),
                        SelectionOption(
                          value: 120,
                          label: l10n.settingsClipboardAutoClearValue(120),
                        ),
                      ],
                    );
                    if (v != null) {
                      ref
                          .read(settingsProvider.notifier)
                          .setClipboardAutoClear(v);
                      if (context.mounted) {
                        AdaptiveNotification.show(
                          context,
                          message: l10n.settingsUpdated,
                        );
                      }
                    }
                  },
                ),
                SettingsTile(
                  icon: Icons.timer_off_outlined,
                  iconColor: AppColors.iconOrange,
                  title: l10n.settingsSessionTimeout,
                  subtitleText: settings.sessionTimeoutMins == 0
                      ? l10n.settingsSessionTimeoutOff
                      : l10n.settingsSessionTimeoutValue(
                          settings.sessionTimeoutMins,
                        ),
                  onTap: () async {
                    final v = await showSettingsSelectionDialog<int>(
                      context: context,
                      title: l10n.settingsSessionTimeout,
                      currentValue: settings.sessionTimeoutMins,
                      options: [
                        SelectionOption(
                          value: 0,
                          label: l10n.settingsSessionTimeoutOff,
                        ),
                        SelectionOption(
                          value: 15,
                          label: l10n.settingsSessionTimeoutValue(15),
                        ),
                        SelectionOption(
                          value: 30,
                          label: l10n.settingsSessionTimeoutValue(30),
                        ),
                        SelectionOption(
                          value: 60,
                          label: l10n.settingsSessionTimeoutValue(60),
                        ),
                      ],
                    );
                    if (v != null) {
                      ref.read(settingsProvider.notifier).setSessionTimeout(v);
                      if (context.mounted) {
                        AdaptiveNotification.show(
                          context,
                          message: l10n.settingsUpdated,
                        );
                      }
                    }
                  },
                ),
              ],
            ),

            // Reminders section
            Spacing.verticalLg,
            SectionHeader(title: l10n.settingsSectionReminders),
            SettingsGroupCard(
              children: [
                SettingsTile(
                  icon: Icons.autorenew,
                  iconColor: AppColors.iconCyan,
                  title: l10n.settingsKeyRotationReminder,
                  subtitleText: settings.keyRotationReminderDays == 0
                      ? l10n.settingsKeyRotationOff
                      : l10n.settingsKeyRotationValue(
                          settings.keyRotationReminderDays,
                        ),
                  onTap: () async {
                    final v = await showSettingsSelectionDialog<int>(
                      context: context,
                      title: l10n.settingsKeyRotationReminder,
                      currentValue: settings.keyRotationReminderDays,
                      options: [
                        SelectionOption(
                          value: 0,
                          label: l10n.settingsKeyRotationOff,
                        ),
                        SelectionOption(
                          value: 30,
                          label: l10n.settingsKeyRotationValue(30),
                        ),
                        SelectionOption(
                          value: 60,
                          label: l10n.settingsKeyRotationValue(60),
                        ),
                        SelectionOption(
                          value: 90,
                          label: l10n.settingsKeyRotationValue(90),
                        ),
                      ],
                    );
                    if (v != null) {
                      ref
                          .read(settingsProvider.notifier)
                          .setKeyRotationReminder(v);
                      if (context.mounted) {
                        AdaptiveNotification.show(
                          context,
                          message: l10n.settingsUpdated,
                        );
                      }
                    }
                  },
                ),
              ],
            ),

            // ssh-agent integration. The feature degrades gracefully on
            // platforms without an agent — the underlying SshAgent.isAvailable()
            // returns false and the per-key/per-host buttons remain hidden at
            // the call sites. On Windows, the SshAgent picks between the
            // OpenSSH-for-Windows named pipe and PuTTY's Pageant
            // automatically; we surface which backend was detected as a
            // read-only chip so users can see why a specific key list shows up.
            Spacing.verticalLg,
            const SectionHeader(title: 'ssh-agent integration'),
            SettingsGroupCard(
              children: [
                if (Platform.isWindows)
                  Consumer(
                    builder: (context, ref, _) {
                      final detection = ref.watch(
                        windowsSshAgentBackendProvider,
                      );
                      return SettingsTile(
                        icon: Icons.memory,
                        iconColor: AppColors.iconDeepPurple,
                        title: 'Detected agent',
                        subtitleText: detection.when(
                          data: (b) => b.label,
                          loading: () => 'Detecting…',
                          error: (_, _) => 'Detection failed',
                        ),
                        onTap: () =>
                            ref.invalidate(windowsSshAgentBackendProvider),
                      );
                    },
                  ),
                SettingsSwitchTile(
                  icon: Icons.alt_route,
                  iconColor: AppColors.iconBlue,
                  title: 'Forward agent by default',
                  subtitleText:
                      'Expose \$SSH_AUTH_SOCK to remote shells when '
                      'opening new SSH sessions.',
                  value: settings.sshAgentForwardByDefault,
                  onChanged: (v) {
                    ref
                        .read(settingsProvider.notifier)
                        .setSshAgentForwardByDefault(v);
                    AdaptiveNotification.show(
                      context,
                      message: l10n.settingsUpdated,
                    );
                  },
                ),
                SettingsTile(
                  icon: Icons.timer_outlined,
                  iconColor: AppColors.iconCyan,
                  title: 'Default key lifetime',
                  subtitleText: settings.sshAgentDefaultLifetimeSecs == 0
                      ? 'No expiry (kept until removed)'
                      : '${settings.sshAgentDefaultLifetimeSecs ~/ 60} min',
                  onTap: () async {
                    final v = await showSettingsSelectionDialog<int>(
                      context: context,
                      title: 'Default key lifetime',
                      currentValue: settings.sshAgentDefaultLifetimeSecs,
                      options: const [
                        SelectionOption(value: 0, label: 'No expiry'),
                        SelectionOption(value: 900, label: '15 min'),
                        SelectionOption(value: 1800, label: '30 min'),
                        SelectionOption(value: 3600, label: '1 hour'),
                        SelectionOption(value: 14400, label: '4 hours'),
                        SelectionOption(value: 28800, label: '8 hours'),
                      ],
                    );
                    if (v != null) {
                      ref
                          .read(settingsProvider.notifier)
                          .setSshAgentDefaultLifetimeSecs(v);
                      if (context.mounted) {
                        AdaptiveNotification.show(
                          context,
                          message: l10n.settingsUpdated,
                        );
                      }
                    }
                  },
                ),
              ],
            ),

            // Power management — Linux + Windows only. Hidden on macOS
            // / mobile because PowerInhibitorService is a no-op there.
            // Strings are inline (not localized) to match the ssh-agent
            // block above and avoid touching all 28 .arb files for a
            // single toggle.
            if (Platform.isLinux || Platform.isWindows) ...[
              Spacing.verticalLg,
              const SectionHeader(title: 'Power management'),
              SettingsGroupCard(
                children: [
                  SettingsSwitchTile(
                    icon: Icons.bedtime_off_outlined,
                    iconColor: AppColors.iconBlue,
                    title: 'Prevent suspend during SSH sessions',
                    subtitleText: Platform.isLinux
                        ? 'Hold a systemd-logind sleep inhibitor while at '
                              'least one SSH session is connected so the '
                              'system does not auto-suspend mid-session.'
                        : 'Use SetThreadExecutionState to keep Windows '
                              'awake while at least one SSH session is '
                              'connected so the system does not '
                              'auto-suspend mid-session.',
                    value: settings.preventSuspendDuringSshSessions,
                    onChanged: (v) {
                      ref
                          .read(settingsProvider.notifier)
                          .setPreventSuspendDuringSshSessions(v);
                      AdaptiveNotification.show(
                        context,
                        message: l10n.settingsUpdated,
                      );
                    },
                  ),
                ],
              ),
            ],

            // Status section
            Spacing.verticalLg,
            SectionHeader(title: l10n.settingsSectionStatus),
            SettingsGroupCard(
              children: [
                Semantics(
                  label:
                      '${l10n.settingsFailedAttempts}: ${settings.failedPinAttempts}',
                  child: SettingsTile(
                    icon: Icons.warning_amber_outlined,
                    iconColor: AppColors.iconGrey,
                    title: l10n.settingsFailedAttempts,
                    subtitleText: settings.failedPinAttempts.toString(),
                  ),
                ),
                const _MasterKeyStorageTile(),
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
}

class _BiometricTile extends ConsumerWidget {
  final dynamic settings;

  const _BiometricTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final biometricAvailable = ref.watch(biometricAvailableProvider);
    final subtitleText = biometricAvailable.when(
      data: (available) {
        if (!available) return l10n.settingsBiometricNotAvailable;
        if (!settings.hasPin) return l10n.settingsBiometricRequiresPin;
        return null;
      },
      loading: () => null,
      error: (_, _) => l10n.settingsBiometricError,
    );

    return SettingsSwitchTile(
      icon: Icons.fingerprint,
      iconColor: AppColors.iconGreen,
      title: l10n.settingsBiometricUnlock,
      subtitleText: subtitleText,
      value: settings.biometricUnlock,
      onChanged: biometricAvailable.maybeWhen(
        data: (available) => available && settings.hasPin
            ? (v) async {
                if (v) {
                  final service = ref.read(biometricServiceProvider);
                  final success = await service.authenticate(
                    reason: l10n.settingsBiometricReason,
                  );
                  if (success) {
                    ref
                        .read(settingsProvider.notifier)
                        .setBiometricUnlock(true);
                    if (context.mounted) {
                      AdaptiveNotification.show(
                        context,
                        message: l10n.settingsBiometricEnabled,
                      );
                    }
                  }
                } else {
                  ref.read(settingsProvider.notifier).setBiometricUnlock(false);
                  if (context.mounted) {
                    AdaptiveNotification.show(
                      context,
                      message: l10n.settingsBiometricDisabled,
                    );
                  }
                }
              }
            : null,
        orElse: () => null,
      ),
    );
  }
}

class _PinTile extends ConsumerWidget {
  final dynamic settings;

  const _PinTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return SettingsTile(
      icon: Icons.pin,
      iconColor: AppColors.iconIndigo,
      title: l10n.settingsPinCode,
      subtitleText: settings.hasPin
          ? l10n.settingsPinIsSet
          : l10n.settingsPinNotConfigured,
      trailing: settings.hasPin
          ? TextButton(
              onPressed: () => _confirmRemovePin(context, ref, l10n),
              child: Text(l10n.settingsPinRemove),
            )
          : null,
      onTap: () async {
        final pin = await PinDialog.showSetPin(context);
        if (pin != null) {
          await ref.read(settingsProvider.notifier).setPinCode(pin);
          if (context.mounted) {
            AdaptiveNotification.show(
              context,
              message: l10n.settingsPinSetSuccess,
            );
          }
        }
      },
    );
  }

  Future<void> _confirmRemovePin(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final pin = await PinDialog.showVerifyPin(
      context,
      verifier: (pin) async =>
          ref.read(settingsProvider.notifier).verifyPin(pin),
    );
    if (pin == null || !context.mounted) return;

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
      if (context.mounted) {
        AdaptiveNotification.show(
          context,
          message: l10n.settingsPinRemovedSuccess,
        );
      }
    }
  }
}

class _DuressPinTile extends ConsumerWidget {
  final dynamic settings;

  const _DuressPinTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return SettingsTile(
      icon: Icons.dangerous_outlined,
      iconColor: AppColors.iconRed,
      title: l10n.settingsDuressPin,
      subtitleText: settings.hasDuressPin
          ? l10n.settingsDuressPinSet
          : l10n.settingsDuressPinNotSet,
      trailing: settings.hasDuressPin
          ? TextButton(
              onPressed: () => _removeDuressPin(context, ref, l10n),
              child: Text(l10n.settingsPinRemove),
            )
          : null,
      onTap: () => _setDuressPin(context, ref, l10n),
    );
  }

  Future<void> _setDuressPin(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    // Show warning first
    final confirmed = await showAdaptiveConfirmDialog(
      context,
      title: l10n.settingsDuressPin,
      message: l10n.settingsDuressPinWarning,
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.save,
      isDestructive: true,
    );
    if (confirmed != true || !context.mounted) return;

    final pin = await PinDialog.showSetPin(context);
    if (pin != null) {
      await ref.read(settingsProvider.notifier).setDuressPin(pin);
      if (context.mounted) {
        AdaptiveNotification.show(
          context,
          message: l10n.settingsDuressPinSetSuccess,
        );
      }
    }
  }

  Future<void> _removeDuressPin(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showAdaptiveConfirmDialog(
      context,
      title: l10n.settingsDuressPin,
      message: l10n.settingsPinRemoveWarning,
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.settingsPinRemove,
      isDestructive: true,
    );
    if (confirmed == true) {
      await ref.read(settingsProvider.notifier).clearDuressPin();
      if (context.mounted) {
        AdaptiveNotification.show(
          context,
          message: l10n.settingsDuressPinRemovedSuccess,
        );
      }
    }
  }
}

/// Read-only indicator showing where the vault master key currently lives,
/// plus a Linux-only "Re-store key in system keyring" button that triggers
/// the libsecret migration manually. Strings are intentionally inline
/// rather than localized: the master-key storage backend is a desktop
/// power-user concern and does not yet have l10n entries across all 28
/// supported locales.
class _MasterKeyStorageTile extends ConsumerStatefulWidget {
  const _MasterKeyStorageTile();

  @override
  ConsumerState<_MasterKeyStorageTile> createState() =>
      _MasterKeyStorageTileState();
}

class _MasterKeyStorageTileState extends ConsumerState<_MasterKeyStorageTile> {
  Future<MasterKeyBackend?>? _backendFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    final keyring = ref.read(keyringServiceProvider);
    setState(() => _backendFuture = keyring.currentBackend());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MasterKeyBackend?>(
      future: _backendFuture,
      builder: (context, snapshot) {
        final backend = snapshot.data;
        final subtitle = switch (backend) {
          MasterKeyBackend.systemKeyring => 'System Keyring',
          MasterKeyBackend.portalSecret => 'XDG Portal (Secret)',
          MasterKeyBackend.encryptedFile => 'Encrypted file (fallback)',
          MasterKeyBackend.windowsCredentialManager =>
            'Windows Credential Manager',
          null =>
            snapshot.connectionState == ConnectionState.waiting
                ? '...'
                : 'Not yet stored',
        };

        final showReStoreButton =
            Platform.isLinux && backend == MasterKeyBackend.encryptedFile;

        return SettingsTile(
          icon: Icons.key,
          iconColor: AppColors.iconAmber,
          title: 'Master key stored in',
          subtitleText: subtitle,
          trailing: showReStoreButton
              ? TextButton(
                  onPressed: _runManualMigration,
                  child: const Text('Re-store in keyring'),
                )
              : null,
        );
      },
    );
  }

  Future<void> _runManualMigration() async {
    final keyring = ref.read(keyringServiceProvider);
    final migrated = await keyring.migrateLegacyFileIfNeeded();
    if (!mounted) return;

    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(
      SnackBar(
        content: Text(
          migrated
              ? 'Master key moved into the system keyring.'
              : 'Could not reach the system keyring. Master key still on disk.',
        ),
      ),
    );

    if (migrated) {
      await ref
          .read(settingsProvider.notifier)
          .setKeyringMigrationCompleted(true);
    }
    _refresh();
  }
}
