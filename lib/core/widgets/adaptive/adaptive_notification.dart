import 'package:flutter/material.dart';

/// Shows a [SnackBar] notification via [ScaffoldMessenger].
class AdaptiveNotification {
  AdaptiveNotification._();

  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: actionLabel != null
            ? SnackBarAction(label: actionLabel, onPressed: onAction ?? () {})
            : null,
      ),
    );
  }
}
