import 'package:flutter/material.dart';

/// A single action for a bottom sheet.
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

/// Shows a modal bottom sheet with action items.
Future<void> showAdaptiveActionSheet(
  BuildContext context, {
  String? title,
  String? message,
  required List<AdaptiveAction> actions,
  String? cancelLabel,
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
