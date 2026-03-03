import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/utils/platform_utils.dart';

/// A platform-adaptive button.
///
/// On iOS/macOS: [CupertinoButton] / [CupertinoButton.filled].
/// On Android/Desktop: [FilledButton] / [TextButton] / [OutlinedButton].
class AdaptiveButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final _AdaptiveButtonStyle _style;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const AdaptiveButton._({
    required this.onPressed,
    required this.child,
    required _AdaptiveButtonStyle style,
    this.color,
    this.padding,
  }) : _style = style;

  /// Creates a filled/primary button.
  const factory AdaptiveButton.filled({
    required VoidCallback? onPressed,
    required Widget child,
    Color? color,
    EdgeInsetsGeometry? padding,
  }) = _FilledAdaptiveButton;

  /// Creates a text/plain button.
  const factory AdaptiveButton.text({
    required VoidCallback? onPressed,
    required Widget child,
    Color? color,
    EdgeInsetsGeometry? padding,
  }) = _TextAdaptiveButton;

  /// Creates a filled button with an icon.
  static Widget filledIcon({
    required VoidCallback? onPressed,
    required Widget icon,
    required Widget label,
    Color? color,
    ButtonStyle? style,
  }) {
    if (useCupertinoDesign) {
      return CupertinoButton.filled(
        onPressed: onPressed,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme(
              data: const IconThemeData(color: CupertinoColors.white, size: 18),
              child: icon,
            ),
            const SizedBox(width: 8),
            label,
          ],
        ),
      );
    }
    return FilledButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: label,
      style:
          style ??
          (color != null
              ? FilledButton.styleFrom(backgroundColor: color)
              : null),
    );
  }

  /// Creates a text/plain button with an icon.
  static Widget textIcon({
    required VoidCallback? onPressed,
    required Widget icon,
    required Widget label,
    Color? color,
  }) {
    if (useCupertinoDesign) {
      return CupertinoButton(
        onPressed: onPressed,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme(
              data: IconThemeData(
                color: color ?? CupertinoColors.activeBlue,
                size: 18,
              ),
              child: icon,
            ),
            const SizedBox(width: 8),
            label,
          ],
        ),
      );
    }
    return TextButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: label,
      style: color != null
          ? TextButton.styleFrom(foregroundColor: color)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (useCupertinoDesign) {
      switch (_style) {
        case _AdaptiveButtonStyle.filled:
          return CupertinoButton.filled(
            onPressed: onPressed,
            padding: padding,
            child: child,
          );
        case _AdaptiveButtonStyle.text:
          return CupertinoButton(
            onPressed: onPressed,
            padding: padding,
            child: child,
          );
      }
    }

    switch (_style) {
      case _AdaptiveButtonStyle.filled:
        return FilledButton(
          onPressed: onPressed,
          style: color != null
              ? FilledButton.styleFrom(backgroundColor: color)
              : null,
          child: child,
        );
      case _AdaptiveButtonStyle.text:
        return TextButton(
          onPressed: onPressed,
          style: color != null
              ? TextButton.styleFrom(foregroundColor: color)
              : null,
          child: child,
        );
    }
  }
}

enum _AdaptiveButtonStyle { filled, text }

class _FilledAdaptiveButton extends AdaptiveButton {
  const _FilledAdaptiveButton({
    required super.onPressed,
    required super.child,
    super.color,
    super.padding,
  }) : super._(style: _AdaptiveButtonStyle.filled);
}

class _TextAdaptiveButton extends AdaptiveButton {
  const _TextAdaptiveButton({
    required super.onPressed,
    required super.child,
    super.color,
    super.padding,
  }) : super._(style: _AdaptiveButtonStyle.text);
}
