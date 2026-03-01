import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _pinController = TextEditingController();
  String? _pinError;
  int _attempts = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Defer biometric authentication to after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _tryBiometric();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pinController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isUnlocked) {
      setState(() {
        _isUnlocked = false;
        _pinController.clear();
        _pinError = null;
        _attempts = 0;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _tryBiometric();
      });
    }
  }

  Future<void> _onUnlockSuccess() async {
    // Load DEK into memory for field decryption
    await ref.read(settingsProvider.notifier).loadDekAfterUnlock();
    if (mounted) {
      setState(() => _isUnlocked = true);
    }
  }

  /// Attempts biometric authentication only (no dialog needed).
  Future<void> _tryBiometric() async {
    if (_isAuthenticating) return;

    final settings = ref.read(settingsProvider).valueOrNull;
    if (settings == null || !settings.biometricUnlock) return;

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

  /// Verifies the PIN entered in the inline text field.
  void _verifyPin() {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsProvider.notifier);

    if (_pinController.text.length != 6) {
      setState(() => _pinError = l10n.pinDialogErrorLength);
      return;
    }

    if (notifier.verifyPin(_pinController.text)) {
      _onUnlockSuccess();
    } else {
      _attempts++;
      setState(() {
        _pinError = l10n.pinDialogWrongPin(_attempts);
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

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline,
                  size: 64, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                l10n.lockScreenTitle,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 32),

              // Inline PIN input field
              if (settings?.hasPin ?? false) ...[
                SizedBox(
                  width: 240,
                  child: TextField(
                    controller: _pinController,
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
                  onPressed: _verifyPin,
                  icon: const Icon(Icons.lock_open),
                  label: Text(l10n.lockScreenUnlock),
                ),
              ],

              // Biometric unlock button
              if (settings?.biometricUnlock ?? false) ...[
                if (settings?.hasPin ?? false) const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _isAuthenticating ? null : _tryBiometric,
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
