import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/utils/platform_utils.dart';

/// A single action for an adaptive action sheet / bottom sheet.
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
/// On iOS/macOS: [CupertinoActionSheet] via [showCupertinoModalPopup].
/// On Android/Desktop: [showModalBottomSheet] with [ListTile] items.
Future<void> showAdaptiveActionSheet(
  BuildContext context, {
  String? title,
  String? message,
  required List<AdaptiveAction> actions,
  String? cancelLabel,
}) {
  if (useCupertinoDesign) {
    return showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: title != null ? Text(title) : null,
        message: message != null ? Text(message) : null,
        actions: actions.map((a) {
          return CupertinoActionSheetAction(
            isDestructiveAction: a.isDestructive,
            isDefaultAction: a.isDefault,
            onPressed: () {
              Navigator.pop(ctx);
              a.onPressed();
            },
            child: Text(a.label),
          );
        }).toList(),
        cancelButton: cancelLabel != null
            ? CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(ctx),
                child: Text(cancelLabel),
              )
            : null,
      ),
    );
  }

  return showModalBottomSheet(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
