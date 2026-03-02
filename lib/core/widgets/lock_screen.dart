import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/services/biometric_provider.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';

class LockScreen extends ConsumerStatefulWidget {
  final Widget child;

  const LockScreen({super.key, required this.child});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen>
    with WidgetsBindingObserver {
  bool _isUnlocked = false;
  bool _isAuthenticating = false;
  bool _isVerifying = false;
  final _pinController = TextEditingController();
  String? _pinError;
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
    if (state == AppLifecycleState.resumed && _isUnlocked) {
      setState(() {
        _isUnlocked = false;
        _pinController.clear();
        _pinError = null;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _tryBiometric();
      });
    }
  }

  void _startLockoutTimerIfNeeded() {
    final settings = ref.read(settingsProvider).valueOrNull;
    if (settings != null && settings.isLockedOut) {
      _lockoutTimer?.cancel();
      _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) {
          _lockoutTimer?.cancel();
          return;
        }
        final s = ref.read(settingsProvider).valueOrNull;
        if (s == null || !s.isLockedOut) {
          _lockoutTimer?.cancel();
          setState(() => _pinError = null);
        } else {
          setState(() {});
        }
      });
    }
  }

  Future<void> _onUnlockSuccess() async {
    if (mounted) {
      setState(() => _isUnlocked = true);
    }
  }

  Future<void> _tryBiometric() async {
    if (_isAuthenticating) return;

    final settings = ref.read(settingsProvider).valueOrNull;
    if (settings == null || !settings.biometricUnlock) return;
    if (settings.isLockedOut) return;

    setState(() => _isAuthenticating = true);

    try {
      final service = ref.read(biometricServiceProvider);
      final success = await service.authenticate();
      if (mounted && success) {
        await _onUnlockSuccess();
      }
    } finally {
      if (mounted) {
        setState(() => _isAuthenticating = false);
      }
    }
  }

  Future<void> _verifyPin() async {
    if (_isVerifying) return;
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsProvider.notifier);

    final settings = ref.read(settingsProvider).valueOrNull;
    if (settings != null && settings.isLockedOut) return;

    if (_pinController.text.length != 6) {
      setState(() => _pinError = l10n.pinDialogErrorLength);
      return;
    }

    setState(() => _isVerifying = true);

    final success = await notifier.verifyPin(_pinController.text);

    if (!mounted) return;

    if (success) {
      await _onUnlockSuccess();
    } else {
      final updatedSettings = ref.read(settingsProvider).valueOrNull;
      if (updatedSettings != null && updatedSettings.isLockedOut) {
        _startLockoutTimerIfNeeded();
      }
      setState(() {
        _isVerifying = false;
        if (updatedSettings?.isLockedOut ?? false) {
          final remaining = updatedSettings!.remainingLockout;
          _pinError = l10n.lockScreenLockedOut(remaining.inMinutes + 1);
        } else {
          final remaining =
              AppConstants.maxPinAttempts -
              (updatedSettings?.failedPinAttempts ?? 0);
          _pinError = l10n.pinDialogWrongPin(remaining);
        }
        _pinController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isUnlocked) return widget.child;

    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider).valueOrNull;
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
                    enabled: !isLockedOut && !_isVerifying,
                    decoration: InputDecoration(
                      labelText: l10n.pinDialogLabel,
                      hintText: l10n.pinDialogHint,
                      prefixIcon: const Icon(Icons.pin),
                      errorText: _pinError,
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
                FilledButton.icon(
                  onPressed: isLockedOut || _isVerifying ? null : _verifyPin,
                  icon: _isVerifying
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
                OutlinedButton.icon(
                  onPressed: _isAuthenticating || isLockedOut
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
