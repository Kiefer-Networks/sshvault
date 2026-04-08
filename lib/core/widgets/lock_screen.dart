import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/core/storage/database_provider.dart';
import 'package:sshvault/core/storage/secure_storage_provider.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/services/biometric_provider.dart';
import 'package:sshvault/core/widgets/pin_num_pad.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';

class _LockState {
  final bool isUnlocked;
  final bool isAuthenticating;
  final bool isVerifying;
  final String? pinError;

  const _LockState({
    this.isUnlocked = false,
    this.isAuthenticating = false,
    this.isVerifying = false,
    this.pinError,
  });

  _LockState copyWith({
    bool? isUnlocked,
    bool? isAuthenticating,
    bool? isVerifying,
    String? pinError,
    bool clearPinError = false,
  }) {
    return _LockState(
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isAuthenticating: isAuthenticating ?? this.isAuthenticating,
      isVerifying: isVerifying ?? this.isVerifying,
      pinError: clearPinError ? null : (pinError ?? this.pinError),
    );
  }
}

class _LockNotifier extends Notifier<_LockState> {
  @override
  _LockState build() => const _LockState();

  void setUnlocked(bool value) {
    state = state.copyWith(isUnlocked: value);
  }

  void setAuthenticating(bool value) {
    state = state.copyWith(isAuthenticating: value);
  }

  void setVerifying(bool value) {
    state = state.copyWith(isVerifying: value);
  }

  void setPinError(String? value) {
    if (value == null) {
      state = state.copyWith(clearPinError: true);
    } else {
      state = state.copyWith(pinError: value);
    }
  }

  void resetForResume() {
    state = const _LockState();
  }

  void setVerifyFailed({required String pinError}) {
    state = state.copyWith(isVerifying: false, pinError: pinError);
  }

  void forceRebuild() {
    state = state.copyWith();
  }
}

final _lockStateProvider =
    NotifierProvider.autoDispose<_LockNotifier, _LockState>(_LockNotifier.new);

class LockScreen extends ConsumerStatefulWidget {
  final Widget child;

  const LockScreen({super.key, required this.child});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen>
    with WidgetsBindingObserver {
  String _pin = '';
  Timer? _lockoutTimer;
  DateTime? _pausedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _startLockoutTimerIfNeeded();
        _tryBiometric();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _lockoutTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _pausedAt ??= DateTime.now();
      return;
    }

    if (state == AppLifecycleState.resumed) {
      final lockState = ref.read(_lockStateProvider);
      if (!lockState.isUnlocked) {
        _pausedAt = null;
        return;
      }

      final pausedAt = _pausedAt;
      _pausedAt = null;

      // Determine the lock grace period. File pickers, biometric prompts,
      // and share sheets briefly push the app into the background. We must
      // NOT re-lock for those short transitions.
      final settings = ref.read(settingsProvider).value;
      final autoLockMins = settings?.autoLockMinutes ?? 5;

      // autoLockMinutes == 0 means "disabled" → never re-lock on resume.
      if (autoLockMins == 0) return;

      // If we didn't record when we paused, stay unlocked (safety).
      if (pausedAt == null) return;

      final elapsed = DateTime.now().difference(pausedAt);
      final threshold = Duration(minutes: autoLockMins);

      // Minimum grace period of 5 seconds so file pickers, biometric dialogs,
      // and other system UIs never trigger the lock screen.
      if (elapsed < const Duration(seconds: 5) || elapsed < threshold) return;

      ref.read(_lockStateProvider.notifier).resetForResume();
      _pin = '';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _tryBiometric();
      });
    }
  }

  void _startLockoutTimerIfNeeded() {
    final settings = ref.read(settingsProvider).value;
    if (settings != null && settings.isLockedOut) {
      _lockoutTimer?.cancel();
      _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) {
          _lockoutTimer?.cancel();
          return;
        }
        final s = ref.read(settingsProvider).value;
        if (s == null || !s.isLockedOut) {
          _lockoutTimer?.cancel();
          ref.read(_lockStateProvider.notifier).setPinError(null);
        } else {
          ref.read(_lockStateProvider.notifier).forceRebuild();
        }
      });
    }
  }

  Future<void> _onUnlockSuccess() async {
    if (mounted) {
      ref.read(_lockStateProvider.notifier).setUnlocked(true);
    }
  }

  Future<void> _tryBiometric() async {
    final lockState = ref.read(_lockStateProvider);
    if (lockState.isAuthenticating) return;

    final settings = ref.read(settingsProvider).value;
    if (settings == null || !settings.biometricUnlock) return;
    if (settings.isLockedOut) return;

    ref.read(_lockStateProvider.notifier).setAuthenticating(true);

    try {
      final service = ref.read(biometricServiceProvider);
      final success = await service.authenticate();
      if (mounted && success) {
        await _onUnlockSuccess();
      }
    } finally {
      if (mounted) {
        ref.read(_lockStateProvider.notifier).setAuthenticating(false);
      }
    }
  }

  void _onDigit(String digit) {
    if (_pin.length >= 6) return;
    final lockState = ref.read(_lockStateProvider);
    if (lockState.isVerifying || lockState.isUnlocked) return;

    final settings = ref.read(settingsProvider).value;
    if (settings != null && settings.isLockedOut) return;

    ref.read(_lockStateProvider.notifier).setPinError(null);
    _pin += digit;
    ref.read(_lockStateProvider.notifier).forceRebuild();

    if (_pin.length == 6) {
      _verifyPin();
    }
  }

  void _onBackspace() {
    if (_pin.isEmpty) return;
    ref.read(_lockStateProvider.notifier).setPinError(null);
    _pin = _pin.substring(0, _pin.length - 1);
    ref.read(_lockStateProvider.notifier).forceRebuild();
  }

  Future<void> _verifyPin() async {
    final lockState = ref.read(_lockStateProvider);
    if (lockState.isVerifying) return;
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsProvider.notifier);

    final settings = ref.read(settingsProvider).value;
    if (settings != null && settings.isLockedOut) return;

    if (_pin.length != 6) {
      ref
          .read(_lockStateProvider.notifier)
          .setPinError(l10n.pinDialogErrorLength);
      return;
    }

    ref.read(_lockStateProvider.notifier).setVerifying(true);

    // Check duress PIN first — silently wipe all data and show a fake
    // unlock so the coercing party sees an empty (reset) app.
    final isDuress = await notifier.verifyDuressPin(_pin);
    if (isDuress) {
      LoggingService.instance.warning(
        'LockScreen',
        'Duress PIN entered — wiping all local data',
      );
      try {
        await ref.read(secureStorageProvider).clearAllData();
        final db = ref.read(databaseProvider);
        await db.deleteAllData();
      } catch (e) {
        LoggingService.instance.error(
          'LockScreen',
          'Failed to wipe data during duress: $e',
        );
      }
      if (!mounted) return;
      // Show a normal unlock — the attacker sees an empty app
      await _onUnlockSuccess();
      return;
    }

    final success = await notifier.verifyPin(_pin);

    if (!mounted) return;

    if (success) {
      await _onUnlockSuccess();
    } else {
      final updatedSettings = ref.read(settingsProvider).value;
      if (updatedSettings != null && updatedSettings.isLockedOut) {
        _startLockoutTimerIfNeeded();
      }
      final String errorMsg;
      if (updatedSettings?.isLockedOut ?? false) {
        final remaining = updatedSettings!.remainingLockout;
        errorMsg = l10n.lockScreenLockedOut(remaining.inMinutes + 1);
      } else {
        final remaining =
            AppConstants.maxPinAttempts -
            (updatedSettings?.failedPinAttempts ?? 0);
        errorMsg = l10n.pinDialogWrongPin(remaining);
      }
      ref.read(_lockStateProvider.notifier).setVerifyFailed(pinError: errorMsg);
      _pin = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final lockState = ref.watch(_lockStateProvider);

    if (lockState.isUnlocked) return widget.child;

    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider).value;
    final l10n = AppLocalizations.of(context)!;
    final isLockedOut = settings?.isLockedOut ?? false;

    final hasBiometric = settings?.biometricUnlock ?? false;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: Spacing.paddingHorizontalXxxl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: Icon(
                  isLockedOut ? Icons.lock : Icons.lock_outline,
                  size: 64,
                  color: isLockedOut
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
              ),
              Spacing.verticalLg,
              Text(l10n.lockScreenTitle, style: theme.textTheme.headlineSmall),
              if (isLockedOut) ...[
                Spacing.verticalSm,
                Text(
                  l10n.lockScreenLockedOut(
                    settings!.remainingLockout.inMinutes + 1,
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
              Spacing.verticalXxxl,

              if (settings?.hasPin ?? false) ...[
                PinDotIndicator(
                  length: _pin.length,
                  hasError: lockState.pinError != null,
                ),
                if (lockState.pinError != null) ...[
                  Spacing.verticalMd,
                  Text(
                    lockState.pinError!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (lockState.isVerifying) ...[
                  Spacing.verticalMd,
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
                Spacing.verticalXxxl,
                PinNumPad(
                  onDigit: _onDigit,
                  onBackspace: _onBackspace,
                  onConfirm: hasBiometric ? _tryBiometric : null,
                  bottomRightChild: hasBiometric
                      ? const Icon(Icons.fingerprint)
                      : const Icon(Icons.check),
                ),
              ],

              if (!(settings?.hasPin ?? false) && hasBiometric) ...[
                Tooltip(
                  message: l10n.lockScreenTitle,
                  child: IconButton.filled(
                    onPressed: lockState.isAuthenticating || isLockedOut
                        ? null
                        : _tryBiometric,
                    icon: const Icon(Icons.fingerprint),
                    iconSize: 48,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
