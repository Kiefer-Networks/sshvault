import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

/// Dialog to set or verify a 6-digit PIN code.
class PinDialog extends StatefulWidget {
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
  /// Returns true if correct.
  static Future<bool> showVerifyPin(
    BuildContext context, {
    required bool Function(String pin) verifier,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _PinVerifyDialog(verifier: verifier),
    );
    return result ?? false;
  }

  @override
  State<PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _error;

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
      setState(() => _error = l10n.pinDialogErrorLength);
      return;
    }
    if (widget.confirm && _confirmController.text != pin) {
      setState(() => _error = l10n.pinDialogErrorMismatch);
      return;
    }
    Navigator.of(context).pop(pin);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
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
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

class _PinVerifyDialog extends StatefulWidget {
  final bool Function(String pin) verifier;

  const _PinVerifyDialog({required this.verifier});

  @override
  State<_PinVerifyDialog> createState() => _PinVerifyDialogState();
}

class _PinVerifyDialogState extends State<_PinVerifyDialog> {
  final _controller = TextEditingController();
  String? _error;
  int _attempts = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _verify() {
    final l10n = AppLocalizations.of(context)!;
    if (widget.verifier(_controller.text)) {
      Navigator.of(context).pop(true);
    } else {
      _attempts++;
      setState(() {
        _error = l10n.pinDialogWrongPin(_attempts);
        _controller.clear();
      });
      if (_attempts >= 5) {
        Navigator.of(context).pop(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.pinDialogVerifyTitle),
      content: Column(
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
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
      actions: [
        FilledButton(
          onPressed: _verify,
          child: Text(l10n.lockScreenUnlock),
        ),
      ],
    );
  }
}
