import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Wraps the app root in an [AnnotatedRegion] that drives the Android status
/// bar and navigation bar styling based on the active theme [Brightness].
///
/// Edge-to-edge enforcement on Android 15+ (SDK 35) means the system bars
/// are transparent and the app draws *behind* them. To stay readable we
/// flip the bar icon brightness to match the surface they overlay:
///
///   * Light theme  -> dark icons (Brightness.dark)
///   * Dark theme   -> light icons (Brightness.light)
///
/// This widget is a no-op on non-Android platforms — Flutter ignores
/// [SystemUiOverlayStyle] there and we don't want to fight desktop
/// compositors that already paint their own chrome.
class EdgeToEdgeSystemUi extends StatelessWidget {
  final Widget child;
  final Brightness brightness;

  const EdgeToEdgeSystemUi({
    super.key,
    required this.child,
    required this.brightness,
  });

  /// Builds the [SystemUiOverlayStyle] for the given app [brightness].
  ///
  /// `brightness` is the *theme* brightness (light/dark surface). The
  /// resulting bar icon brightness is the *opposite* so icons stay legible
  /// against the app's content drawing through the transparent bars.
  static SystemUiOverlayStyle styleFor(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final iconBrightness = isDark ? Brightness.light : Brightness.dark;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: iconBrightness,
      // iOS uses statusBarBrightness (the *background* brightness).
      statusBarBrightness: brightness,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: iconBrightness,
      systemNavigationBarContrastEnforced: false,
      systemStatusBarContrastEnforced: false,
    );
  }

  /// Re-applies the system UI overlay style imperatively — useful right
  /// after `runApp` and whenever the user toggles the theme. Cheap; safe to
  /// spam from listeners.
  static void apply(Brightness brightness) {
    if (!Platform.isAndroid && !Platform.isIOS) return;
    SystemChrome.setSystemUIOverlayStyle(styleFor(brightness));
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isAndroid && !Platform.isIOS) return child;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: styleFor(brightness),
      child: child,
    );
  }
}
