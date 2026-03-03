import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/services/biometric_provider.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';

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
    state = state.copyWith(isUnlocked: false, clearPinError: true);
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
  final _pinController = TextEditingController();
  Timer? _lockoutTimer;

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
    _pinController.dispose();
    _lockoutTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final lockState = ref.read(_lockStateProvider);
    if (state == AppLifecycleState.resumed && lockState.isUnlocked) {
      ref.read(_lockStateProvider.notifier).resetForResume();
      _pinController.clear();
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

  Future<void> _verifyPin() async {
    final lockState = ref.read(_lockStateProvider);
    if (lockState.isVerifying) return;
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsProvider.notifier);

    final settings = ref.read(settingsProvider).value;
    if (settings != null && settings.isLockedOut) return;

    if (_pinController.text.length != 6) {
      ref.read(_lockStateProvider.notifier).setPinError(l10n.pinDialogErrorLength);
      return;
    }

    ref.read(_lockStateProvider.notifier).setVerifying(true);

    final success = await notifier.verifyPin(_pinController.text);

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
      _pinController.clear();
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

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isLockedOut ? Icons.lock : Icons.lock_outline,
                size: 64,
                color: isLockedOut
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(l10n.lockScreenTitle, style: theme.textTheme.headlineSmall),
              if (isLockedOut) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.lockScreenLockedOut(
                    settings!.remainingLockout.inMinutes + 1,
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
              const SizedBox(height: 32),

              if (settings?.hasPin ?? false) ...[
                SizedBox(
                  width: 240,
                  child: TextField(
                    controller: _pinController,
                    enabled: !isLockedOut && !lockState.isVerifying,
                    decoration: InputDecoration(
                      labelText: l10n.pinDialogLabel,
                      hintText: l10n.pinDialogHint,
                      prefixIcon: const Icon(Icons.pin),
                      errorText: lockState.pinError,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    obscureText: true,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: const TextStyle(letterSpacing: 8, fontSize: 24),
                    onSubmitted: (_) => _verifyPin(),
                  ),
                ),
                const SizedBox(height: 16),
                AdaptiveButton.filledIcon(
                  onPressed: isLockedOut || lockState.isVerifying ? null : _verifyPin,
                  icon: lockState.isVerifying
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.lock_open),
                  label: Text(l10n.lockScreenUnlock),
                ),
              ],

              if (settings?.biometricUnlock ?? false) ...[
                if (settings?.hasPin ?? false) const SizedBox(height: 16),
                AdaptiveButton.textIcon(
                  onPressed: lockState.isAuthenticating || isLockedOut
                      ? null
                      : _tryBiometric,
                  icon: const Icon(Icons.fingerprint),
                  label: Text(l10n.lockScreenUnlock),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
