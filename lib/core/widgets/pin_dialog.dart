import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/widgets/pin_num_pad.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

final _pinDialogErrorProvider = StateProvider.autoDispose<String?>((_) => null);
final _pinDialogInputProvider = StateProvider.autoDispose<String>((_) => '');

final _pinVerifyErrorProvider = StateProvider.autoDispose<String?>((_) => null);
final _pinVerifyInputProvider = StateProvider.autoDispose<String>((_) => '');
final _pinVerifyingProvider = StateProvider.autoDispose<bool>((_) => false);

/// Dialog to set or verify a 6-digit PIN code using a numpad.
class PinDialog extends ConsumerStatefulWidget {
  final String title;
  final String? subtitle;
  final bool confirm;

  const PinDialog({
    super.key,
    required this.title,
    this.subtitle,
    this.confirm = false,
  });

  /// Show dialog to set a new PIN. Returns the PIN or null if cancelled.
  static Future<String?> showSetPin(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PinDialog(
        title: l10n.pinDialogSetTitle,
        subtitle: l10n.pinDialogSetSubtitle,
        confirm: true,
      ),
    );
  }

  /// Show dialog to verify an existing PIN using a verifier function.
  /// Returns the verified PIN string if correct, null if cancelled/failed.
  static Future<String?> showVerifyPin(
    BuildContext context, {
    required Future<bool> Function(String pin) verifier,
  }) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _PinVerifyDialog(verifier: verifier),
    );
  }

  @override
  ConsumerState<PinDialog> createState() => _PinDialogState();
}

enum _SetPinPhase { enter, confirm }

class _PinDialogState extends ConsumerState<PinDialog> {
  String _firstPin = '';
  _SetPinPhase _phase = _SetPinPhase.enter;

  void _onDigit(String digit) {
    final pin = ref.read(_pinDialogInputProvider);
    if (pin.length >= 6) return;
    ref.read(_pinDialogErrorProvider.notifier).state = null;
    final updated = pin + digit;
    ref.read(_pinDialogInputProvider.notifier).state = updated;

    if (updated.length == 6) {
      _onPinComplete(updated);
    }
  }

  void _onBackspace() {
    final pin = ref.read(_pinDialogInputProvider);
    if (pin.isEmpty) return;
    ref.read(_pinDialogErrorProvider.notifier).state = null;
    ref.read(_pinDialogInputProvider.notifier).state = pin.substring(
      0,
      pin.length - 1,
    );
  }

  void _onPinComplete(String pin) {
    final l10n = AppLocalizations.of(context)!;
    if (!widget.confirm) {
      Navigator.of(context).pop(pin);
      return;
    }

    if (_phase == _SetPinPhase.enter) {
      _firstPin = pin;
      ref.read(_pinDialogInputProvider.notifier).state = '';
      _phase = _SetPinPhase.confirm;
      ref.read(_pinDialogErrorProvider.notifier).state = null;
      return;
    }

    // Confirm phase
    if (pin != _firstPin) {
      ref.read(_pinDialogErrorProvider.notifier).state =
          l10n.pinDialogErrorMismatch;
      ref.read(_pinDialogInputProvider.notifier).state = '';
      return;
    }
    Navigator.of(context).pop(pin);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final error = ref.watch(_pinDialogErrorProvider);
    final pin = ref.watch(_pinDialogInputProvider);

    final title = _phase == _SetPinPhase.confirm
        ? l10n.pinDialogConfirmLabel
        : widget.title;

    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(title),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.subtitle != null &&
                    _phase == _SetPinPhase.enter) ...[
                  Text(
                    widget.subtitle!,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                ],
                PinDotIndicator(length: pin.length, hasError: error != null),
                if (error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    error,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 32),
                PinNumPad(onDigit: _onDigit, onBackspace: _onBackspace),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PinVerifyDialog extends ConsumerStatefulWidget {
  final Future<bool> Function(String pin) verifier;

  const _PinVerifyDialog({required this.verifier});

  @override
  ConsumerState<_PinVerifyDialog> createState() => _PinVerifyDialogState();
}

class _PinVerifyDialogState extends ConsumerState<_PinVerifyDialog> {
  int _attempts = 0;

  void _onDigit(String digit) {
    final verifying = ref.read(_pinVerifyingProvider);
    final pin = ref.read(_pinVerifyInputProvider);
    if (verifying || pin.length >= 6) return;

    ref.read(_pinVerifyErrorProvider.notifier).state = null;
    final updated = pin + digit;
    ref.read(_pinVerifyInputProvider.notifier).state = updated;

    if (updated.length == 6) {
      _verify(updated);
    }
  }

  void _onBackspace() {
    final pin = ref.read(_pinVerifyInputProvider);
    if (pin.isEmpty) return;
    ref.read(_pinVerifyErrorProvider.notifier).state = null;
    ref.read(_pinVerifyInputProvider.notifier).state = pin.substring(
      0,
      pin.length - 1,
    );
  }

  Future<void> _verify(String pin) async {
    final verifying = ref.read(_pinVerifyingProvider);
    if (verifying) return;
    final l10n = AppLocalizations.of(context)!;

    if (pin.length != 6) {
      ref.read(_pinVerifyErrorProvider.notifier).state =
          l10n.pinDialogErrorLength;
      return;
    }

    ref.read(_pinVerifyingProvider.notifier).state = true;

    final success = await widget.verifier(pin);

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(pin);
    } else {
      _attempts++;
      ref.read(_pinVerifyingProvider.notifier).state = false;
      ref.read(_pinVerifyErrorProvider.notifier).state = l10n.pinDialogWrongPin(
        _attempts,
      );
      ref.read(_pinVerifyInputProvider.notifier).state = '';
      if (_attempts >= AppConstants.maxPinAttempts) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final error = ref.watch(_pinVerifyErrorProvider);
    final verifying = ref.watch(_pinVerifyingProvider);
    final pin = ref.watch(_pinVerifyInputProvider);

    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: verifying ? null : () => Navigator.of(context).pop(),
          ),
          title: Text(l10n.pinDialogVerifyTitle),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PinDotIndicator(length: pin.length, hasError: error != null),
                if (error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    error,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (verifying) ...[
                  const SizedBox(height: 12),
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
                const SizedBox(height: 32),
                PinNumPad(onDigit: _onDigit, onBackspace: _onBackspace),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
