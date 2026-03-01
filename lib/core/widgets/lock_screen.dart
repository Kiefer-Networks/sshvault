import 'package:flutter/material.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/services/biometric_provider.dart';
import 'package:shellvault/core/widgets/pin_dialog.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _authenticate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isUnlocked) {
      setState(() => _isUnlocked = false);
      _authenticate();
    }
  }

  Future<void> _onUnlockSuccess() async {
    // Load DEK into memory for field decryption
    await ref.read(settingsProvider.notifier).loadDekAfterUnlock();
    if (mounted) {
      setState(() => _isUnlocked = true);
    }
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;
    _isAuthenticating = true;

    try {
      final settings = ref.read(settingsProvider).valueOrNull;
      if (settings == null) return;

      // Try biometric first if enabled
      if (settings.biometricUnlock) {
        final service = ref.read(biometricServiceProvider);
        final success = await service.authenticate();
        if (mounted && success) {
          await _onUnlockSuccess();
          return;
        }
      }

      // Fall back to PIN if set (and biometric failed or not enabled)
      if (settings.hasPin && mounted) {
        final notifier = ref.read(settingsProvider.notifier);
        final success = await PinDialog.showVerifyPin(
          context,
          verifier: notifier.verifyPin,
        );
        if (mounted && success) {
          await _onUnlockSuccess();
        }
      }
    } finally {
      _isAuthenticating = false;
    }
  }

  Future<void> _unlockWithPin() async {
    final settings = ref.read(settingsProvider).valueOrNull;
    if (settings == null || !settings.hasPin) return;

    final notifier = ref.read(settingsProvider.notifier);
    final success = await PinDialog.showVerifyPin(
      context,
      verifier: notifier.verifyPin,
    );
    if (mounted && success) {
      await _onUnlockSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isUnlocked) return widget.child;

    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider).valueOrNull;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              l10n.lockScreenTitle,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            if (settings?.biometricUnlock ?? false)
              FilledButton.icon(
                onPressed: _isAuthenticating ? null : _authenticate,
                icon: const Icon(Icons.fingerprint),
                label: Text(l10n.lockScreenUnlock),
              ),
            if (settings?.hasPin ?? false) ...[
              if (settings?.biometricUnlock ?? false)
                const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _isAuthenticating ? null : _unlockWithPin,
                icon: const Icon(Icons.pin),
                label: Text(l10n.lockScreenEnterPin),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
