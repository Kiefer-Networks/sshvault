import 'package:flutter/material.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shellvault/core/utils/validators.dart';

class _ExportPasswordVisibility {
  final bool obscurePassword;
  final bool obscureConfirm;

  const _ExportPasswordVisibility({
    this.obscurePassword = true,
    this.obscureConfirm = true,
  });

  _ExportPasswordVisibility copyWith({
    bool? obscurePassword,
    bool? obscureConfirm,
  }) {
    return _ExportPasswordVisibility(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirm: obscureConfirm ?? this.obscureConfirm,
    );
  }
}

final _exportPasswordVisibilityProvider =
    StateProvider.autoDispose<_ExportPasswordVisibility>(
      (ref) => const _ExportPasswordVisibility(),
    );

class ExportPasswordDialog extends ConsumerStatefulWidget {
  const ExportPasswordDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (_) => const ExportPasswordDialog(),
    );
  }

  @override
  ConsumerState<ExportPasswordDialog> createState() =>
      _ExportPasswordDialogState();
}

class _ExportPasswordDialogState extends ConsumerState<ExportPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final visibility = ref.watch(_exportPasswordVisibilityProvider);

    final formContent = Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.exportPasswordDescription),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: visibility.obscurePassword,
            decoration: InputDecoration(
              labelText: l10n.exportPasswordLabel,
              suffixIcon: IconButton(
                icon: Icon(
                  visibility.obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () =>
                    ref
                        .read(_exportPasswordVisibilityProvider.notifier)
                        .state = visibility.copyWith(
                      obscurePassword: !visibility.obscurePassword,
                    ),
              ),
            ),
            keyboardType: TextInputType.visiblePassword,
            validator: Validators.exportPasswordValidator(l10n),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _confirmController,
            obscureText: visibility.obscureConfirm,
            decoration: InputDecoration(
              labelText: l10n.exportPasswordConfirmLabel,
              suffixIcon: IconButton(
                icon: Icon(
                  visibility.obscureConfirm
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () =>
                    ref
                        .read(_exportPasswordVisibilityProvider.notifier)
                        .state = visibility.copyWith(
                      obscureConfirm: !visibility.obscureConfirm,
                    ),
              ),
            ),
            keyboardType: TextInputType.visiblePassword,
            validator: (value) {
              if (value != _passwordController.text) {
                return l10n.exportPasswordMismatch;
              }
              return null;
            },
          ),
        ],
      ),
    );

    void onConfirm() {
      if (_formKey.currentState!.validate()) {
        Navigator.of(context).pop(_passwordController.text);
      }
    }

    return AlertDialog(
      title: Text(l10n.exportPasswordTitle),
      content: formContent,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: onConfirm,
          child: Text(l10n.exportPasswordButton),
        ),
      ],
    );
  }
}
