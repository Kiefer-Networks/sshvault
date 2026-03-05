import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/services/biometric_provider.dart';
import 'package:shellvault/core/services/screen_protection_service.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/core/widgets/pin_dialog.dart';
import 'package:shellvault/core/constants/app_colors.dart';
import 'package:shellvault/core/widgets/settings/settings.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // App Lock section
            const SizedBox(height: 8),
            SectionHeader(title: l10n.settingsSectionAppLock),
            SettingsGroupCard(
              children: [
                SettingsTile(
                  icon: Icons.lock_clock_outlined,
                  iconColor: AppColors.iconRed,
                  title: l10n.settingsAutoLock,
                  subtitleText: settings.autoLockMinutes == 0
                      ? l10n.settingsAutoLockDisabled
                      : l10n.settingsAutoLockMinutes(settings.autoLockMinutes),
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
                      ref.read(settingsProvider.notifier).setAutoLockMinutes(v);
                    }
                  },
                ),
                _BiometricTile(settings: settings),
                _PinTile(settings: settings),
                _DuressPinTile(settings: settings),
              ],
            ),

            // Privacy section
            const SizedBox(height: 16),
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
                    }
                  },
                ),
              ],
            ),

            // Reminders section
            const SizedBox(height: 16),
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
                    }
                  },
                ),
              ],
            ),

            // Status section
            const SizedBox(height: 16),
            SectionHeader(title: l10n.settingsSectionStatus),
            SettingsGroupCard(
              children: [
                SettingsTile(
                  icon: Icons.warning_amber_outlined,
                  iconColor: AppColors.iconGrey,
                  title: l10n.settingsFailedAttempts,
                  subtitleText: settings.failedPinAttempts.toString(),
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
                  }
                } else {
                  ref.read(settingsProvider.notifier).setBiometricUnlock(false);
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
    }
  }
}
