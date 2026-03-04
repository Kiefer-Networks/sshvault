import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/services/biometric_provider.dart';
import 'package:shellvault/core/services/screen_protection_service.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/core/widgets/pin_dialog.dart';
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
                  iconColor: Colors.red,
                  title: l10n.settingsAutoLock,
                  subtitleText: settings.autoLockMinutes == 0
                      ? l10n.settingsAutoLockDisabled
                      : l10n.settingsAutoLockMinutes(settings.autoLockMinutes),
                  trailing: DropdownMenu<int>(
                    initialSelection: settings.autoLockMinutes,
                    requestFocusOnTap: false,
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: 0,
                        label: l10n.settingsAutoLockOff,
                      ),
                      DropdownMenuEntry(
                        value: 1,
                        label: l10n.settingsAutoLock1Min,
                      ),
                      DropdownMenuEntry(
                        value: 5,
                        label: l10n.settingsAutoLock5Min,
                      ),
                      DropdownMenuEntry(
                        value: 15,
                        label: l10n.settingsAutoLock15Min,
                      ),
                      DropdownMenuEntry(
                        value: 30,
                        label: l10n.settingsAutoLock30Min,
                      ),
                    ],
                    onSelected: (v) {
                      if (v != null) {
                        ref
                            .read(settingsProvider.notifier)
                            .setAutoLockMinutes(v);
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
            const SizedBox(height: 16),
            SectionHeader(title: l10n.settingsSectionPrivacy),
            SettingsGroupCard(
              children: [
                if (ScreenProtectionService.isSupported)
                  SettingsSwitchTile(
                    icon: Icons.screenshot_monitor_outlined,
                    iconColor: Colors.amber.shade800,
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
                  iconColor: Colors.purple,
                  title: l10n.settingsClipboardAutoClear,
                  trailing: DropdownMenu<int>(
                    initialSelection: settings.clipboardAutoClearSecs,
                    requestFocusOnTap: false,
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: 0,
                        label: l10n.settingsClipboardAutoClearOff,
                      ),
                      DropdownMenuEntry(
                        value: 15,
                        label: l10n.settingsClipboardAutoClearValue(15),
                      ),
                      DropdownMenuEntry(
                        value: 30,
                        label: l10n.settingsClipboardAutoClearValue(30),
                      ),
                      DropdownMenuEntry(
                        value: 60,
                        label: l10n.settingsClipboardAutoClearValue(60),
                      ),
                      DropdownMenuEntry(
                        value: 120,
                        label: l10n.settingsClipboardAutoClearValue(120),
                      ),
                    ],
                    onSelected: (v) {
                      if (v != null) {
                        ref
                            .read(settingsProvider.notifier)
                            .setClipboardAutoClear(v);
                      }
                    },
                  ),
                ),
                SettingsTile(
                  icon: Icons.timer_off_outlined,
                  iconColor: Colors.orange,
                  title: l10n.settingsSessionTimeout,
                  trailing: DropdownMenu<int>(
                    initialSelection: settings.sessionTimeoutMins,
                    requestFocusOnTap: false,
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: 0,
                        label: l10n.settingsSessionTimeoutOff,
                      ),
                      DropdownMenuEntry(
                        value: 15,
                        label: l10n.settingsSessionTimeoutValue(15),
                      ),
                      DropdownMenuEntry(
                        value: 30,
                        label: l10n.settingsSessionTimeoutValue(30),
                      ),
                      DropdownMenuEntry(
                        value: 60,
                        label: l10n.settingsSessionTimeoutValue(60),
                      ),
                    ],
                    onSelected: (v) {
                      if (v != null) {
                        ref
                            .read(settingsProvider.notifier)
                            .setSessionTimeout(v);
                      }
                    },
                  ),
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
                  iconColor: Colors.cyan,
                  title: l10n.settingsKeyRotationReminder,
                  trailing: DropdownMenu<int>(
                    initialSelection: settings.keyRotationReminderDays,
                    requestFocusOnTap: false,
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: 0,
                        label: l10n.settingsKeyRotationOff,
                      ),
                      DropdownMenuEntry(
                        value: 30,
                        label: l10n.settingsKeyRotationValue(30),
                      ),
                      DropdownMenuEntry(
                        value: 60,
                        label: l10n.settingsKeyRotationValue(60),
                      ),
                      DropdownMenuEntry(
                        value: 90,
                        label: l10n.settingsKeyRotationValue(90),
                      ),
                    ],
                    onSelected: (v) {
                      if (v != null) {
                        ref
                            .read(settingsProvider.notifier)
                            .setKeyRotationReminder(v);
                      }
                    },
                  ),
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
                  iconColor: Colors.grey,
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
      iconColor: Colors.green,
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
      iconColor: Colors.indigo,
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
      iconColor: Colors.red.shade800,
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
