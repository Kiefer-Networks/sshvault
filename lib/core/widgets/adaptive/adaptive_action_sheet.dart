import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';

bool get _isApplePlatform => Platform.isIOS || Platform.isMacOS;

/// A single action for an action sheet.
class AdaptiveAction {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isDestructive;
  final bool isDefault;

  const AdaptiveAction({
    required this.label,
    this.icon,
    required this.onPressed,
    this.isDestructive = false,
    this.isDefault = false,
  });
}

/// Shows a platform-adaptive action sheet.
///
/// Uses [CupertinoActionSheet] on iOS/macOS and a modal bottom sheet
/// with [ListTile] items on other platforms.
Future<void> showAdaptiveActionSheet(
  BuildContext context, {
  String? title,
  String? message,
  required List<AdaptiveAction> actions,
  String? cancelLabel,
}) {
  if (_isApplePlatform) {
    return _showCupertinoSheet(
      context,
      title: title,
      message: message,
      actions: actions,
      cancelLabel: cancelLabel,
    );
  }
  return _showMaterialSheet(
    context,
    title: title,
    message: message,
    actions: actions,
  );
}

Future<void> _showCupertinoSheet(
  BuildContext context, {
  String? title,
  String? message,
  required List<AdaptiveAction> actions,
  String? cancelLabel,
}) {
  return showCupertinoModalPopup(
    context: context,
    builder: (ctx) => CupertinoActionSheet(
      title: title != null ? Text(title) : null,
      message: message != null ? Text(message) : null,
      actions: actions
          .map(
            (a) => CupertinoActionSheetAction(
              isDefaultAction: a.isDefault,
              isDestructiveAction: a.isDestructive,
              onPressed: () {
                Navigator.pop(ctx);
                a.onPressed();
              },
              child: Text(a.label),
            ),
          )
          .toList(),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.pop(ctx),
        child: Text(cancelLabel ?? 'Cancel'),
      ),
    ),
  );
}

Future<void> _showMaterialSheet(
  BuildContext context, {
  String? title,
  String? message,
  required List<AdaptiveAction> actions,
}) {
  return showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Padding(
              padding: EdgeInsets.fromLTRB(
                Spacing.lg,
                Spacing.lg,
                Spacing.lg,
                Spacing.sm,
              ),
              child: Text(title, style: Theme.of(ctx).textTheme.titleMedium),
            ),
          ...actions.map((a) {
            return ListTile(
              leading: a.icon != null ? Icon(a.icon) : null,
              title: Text(
                a.label,
                style: a.isDestructive
                    ? TextStyle(color: Theme.of(ctx).colorScheme.error)
                    : null,
              ),
              onTap: () {
                Navigator.pop(ctx);
                a.onPressed();
              },
            );
          }),
          Spacing.verticalSm,
        ],
      ),
    ),
  );
}
