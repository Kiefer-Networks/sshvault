import 'package:flutter/material.dart';
import 'package:shellvault/core/utils/validators.dart';

class ExportPasswordDialog extends StatefulWidget {
  const ExportPasswordDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (_) => const ExportPasswordDialog(),
    );
  }

  @override
  State<ExportPasswordDialog> createState() => _ExportPasswordDialogState();
}

class _ExportPasswordDialogState extends State<ExportPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Export Password'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'This password will be used to encrypt your export file including credentials.',
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () => setState(
                      () => _obscurePassword = !_obscurePassword),
                ),
              ),
              validator: Validators.validateExportPassword,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _confirmController,
              obscureText: _obscureConfirm,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirm
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () => setState(
                      () => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(_passwordController.text);
            }
          },
          child: const Text('Encrypt & Export'),
        ),
      ],
    );
  }
}
