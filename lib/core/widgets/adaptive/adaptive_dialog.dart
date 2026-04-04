import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';

/// Shows a confirmation dialog as a modal bottom sheet (Android 16 style).
Future<bool?> showAdaptiveConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String cancelLabel,
  required String confirmLabel,
  Color? confirmColor,
  bool isDestructive = false,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (ctx) {
      final theme = Theme.of(ctx);
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: Spacing.paddingHorizontalXxl,
              child: Text(title, style: theme.textTheme.titleLarge),
            ),
            Spacing.verticalLg,
            Padding(
              padding: Spacing.paddingHorizontalXxl,
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Spacing.verticalXxl,
            Padding(
              padding: EdgeInsets.fromLTRB(Spacing.xxl, 0, Spacing.xxl, Spacing.xxl),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text(cancelLabel),
                  ),
                  Spacing.horizontalSm,
                  FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: confirmColor != null
                        ? FilledButton.styleFrom(backgroundColor: confirmColor)
                        : isDestructive
                        ? FilledButton.styleFrom(
                            backgroundColor: theme.colorScheme.error,
                          )
                        : null,
                    child: Text(confirmLabel),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// Shows a form dialog as a modal bottom sheet.
Future<T?> showAdaptiveFormDialog<T>(
  BuildContext context, {
  required String title,
  required Widget content,
  required List<Widget> materialActions,
  Widget? icon,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (ctx) {
      final theme = Theme.of(ctx);
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon, Spacing.verticalSm],
            Padding(
              padding: Spacing.paddingHorizontalXxl,
              child: Text(title, style: theme.textTheme.titleLarge),
            ),
            Spacing.verticalLg,
            Flexible(
              child: SingleChildScrollView(
                padding: Spacing.paddingHorizontalXxl,
                child: content,
              ),
            ),
            Spacing.verticalLg,
            Padding(
              padding: EdgeInsets.fromLTRB(Spacing.xxl, 0, Spacing.xxl, Spacing.xxl),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: materialActions,
              ),
            ),
          ],
        ),
      );
    },
  );
}
