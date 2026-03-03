import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/utils/platform_utils.dart';

/// Shows a platform-adaptive confirmation dialog.
///
/// On iOS/macOS: [CupertinoAlertDialog] via [showCupertinoDialog].
/// On Android/Desktop: [AlertDialog] via [showDialog].
Future<bool?> showAdaptiveConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String cancelLabel,
  required String confirmLabel,
  Color? confirmColor,
  bool isDestructive = false,
}) {
  if (useCupertinoDesign) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(cancelLabel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: isDestructive,
            isDefaultAction: !isDestructive,
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

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

/// Shows a platform-adaptive alert dialog with a single OK button.
Future<void> showAdaptiveAlert(
  BuildContext context, {
  required String title,
  required String message,
  String? okLabel,
}) {
  final label = okLabel ?? 'OK';
  if (useCupertinoDesign) {
    return showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(ctx),
            child: Text(label),
          ),
        ],
      ),
    );
  }

  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(label),
        ),
      ],
    ),
  );
}

/// Shows a platform-adaptive form dialog.
///
/// On iOS/macOS: [CupertinoAlertDialog] with form content.
/// On Android/Desktop: [AlertDialog] with form content.
Future<T?> showAdaptiveFormDialog<T>(
  BuildContext context, {
  required String title,
  required Widget content,
  required List<Widget> materialActions,
  required List<CupertinoDialogAction> cupertinoActions,
  Widget? icon,
}) {
  if (useCupertinoDesign) {
    return showCupertinoDialog<T>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(title),
        content: Material(
          color: Colors.transparent,
          child: content,
        ),
        actions: cupertinoActions,
      ),
    );
  }

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
