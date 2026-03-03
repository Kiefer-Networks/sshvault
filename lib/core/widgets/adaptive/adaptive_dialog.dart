import 'package:flutter/material.dart';

/// Shows a confirmation dialog with cancel and confirm buttons.
Future<bool?> showAdaptiveConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String cancelLabel,
  required String confirmLabel,
  Color? confirmColor,
  bool isDestructive = false,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: confirmColor != null
              ? FilledButton.styleFrom(backgroundColor: confirmColor)
              : isDestructive
              ? FilledButton.styleFrom(
                  backgroundColor: Theme.of(ctx).colorScheme.error,
                )
              : null,
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
}

/// Shows an alert dialog with a single OK button.
Future<void> showAdaptiveAlert(
  BuildContext context, {
  required String title,
  required String message,
  String? okLabel,
}) {
  final label = okLabel ?? 'OK';
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        FilledButton(onPressed: () => Navigator.pop(ctx), child: Text(label)),
      ],
    ),
  );
}

/// Shows a form dialog.
Future<T?> showAdaptiveFormDialog<T>(
  BuildContext context, {
  required String title,
  required Widget content,
  required List<Widget> materialActions,
  List<Widget>? cupertinoActions,
  Widget? icon,
}) {
  return showDialog<T>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: icon,
      title: Text(title),
      content: content,
      actions: materialActions,
    ),
  );
}
