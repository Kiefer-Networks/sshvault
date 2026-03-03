import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

final _pinDialogErrorProvider = StateProvider.autoDispose<String?>((_) => null);

final _pinVerifyErrorProvider = StateProvider.autoDispose<String?>((_) => null);

final _pinVerifyingProvider = StateProvider.autoDispose<bool>((_) => false);

/// Dialog to set or verify a 6-digit PIN code.
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

class _PinDialogState extends ConsumerState<PinDialog> {
  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    final pin = _pinController.text;
    if (pin.length != 6) {
      ref.read(_pinDialogErrorProvider.notifier).state =
          l10n.pinDialogErrorLength;
      return;
    }
    if (widget.confirm && _confirmController.text != pin) {
      ref.read(_pinDialogErrorProvider.notifier).state =
          l10n.pinDialogErrorMismatch;
      return;
    }
    Navigator.of(context).pop(pin);
  }

  Widget _buildContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final error = ref.watch(_pinDialogErrorProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.subtitle != null) ...[
          Text(widget.subtitle!),
          const SizedBox(height: 16),
        ],
        TextField(
          controller: _pinController,
          decoration: InputDecoration(
            labelText: l10n.pinDialogLabel,
            hintText: l10n.pinDialogHint,
            prefixIcon: const Icon(Icons.pin),
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
        ),
        if (widget.confirm) ...[
          const SizedBox(height: 12),
          TextField(
            controller: _confirmController,
            decoration: InputDecoration(
              labelText: l10n.pinDialogConfirmLabel,
              hintText: l10n.pinDialogHint,
              prefixIcon: const Icon(Icons.pin),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            obscureText: true,
            textAlign: TextAlign.center,
            style: const TextStyle(letterSpacing: 8, fontSize: 24),
          ),
        ],
        if (error != null) ...[
          const SizedBox(height: 12),
          Text(
            error,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(widget.title),
      content: _buildContent(context),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l10n.save)),
      ],
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
  final _controller = TextEditingController();
  int _attempts = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final verifying = ref.read(_pinVerifyingProvider);
    if (verifying) return;
    final l10n = AppLocalizations.of(context)!;
    final pin = _controller.text;

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
      _controller.clear();
      if (_attempts >= AppConstants.maxPinAttempts) {
        Navigator.of(context).pop();
      }
    }
  }

  Widget _buildVerifyContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final error = ref.watch(_pinVerifyErrorProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: l10n.pinDialogLabel,
            prefixIcon: const Icon(Icons.pin),
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
          onSubmitted: (_) => _verify(),
        ),
        if (error != null) ...[
          const SizedBox(height: 12),
          Text(
            error,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final verifying = ref.watch(_pinVerifyingProvider);

    return AlertDialog(
      title: Text(l10n.pinDialogVerifyTitle),
      content: _buildVerifyContent(context),
      actions: [
        TextButton(
          onPressed: verifying ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: verifying ? null : _verify,
          child: verifying
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.lockScreenUnlock),
        ),
      ],
    );
  }
}
