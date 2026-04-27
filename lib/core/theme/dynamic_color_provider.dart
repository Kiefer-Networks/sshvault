// Dynamic Color (Material You) provider.
//
// On Android 12+ the platform exposes a wallpaper-derived [CorePalette] via
// the `dynamic_color` plugin. We surface that palette through a Riverpod
// [FutureProvider] so the theme builder in `lib/app.dart` can opt into
// using it as the Material 3 seed when the user's "Follow system accent"
// toggle is on.
//
// On non-Android platforms (Linux, Windows, macOS, iOS, web) and on
// pre-Android-12 devices the plugin returns `null` from `getCorePalette()`,
// so the provider's value is `null` and the theme falls back to the
// brand seed (or the existing desktop accent on Linux). This file contains
// no platform-specific imports — `dynamic_color` already gates the channel
// call internally and degrades safely off-Android.
//
// We keep this provider intentionally narrow:
//   * No caching beyond Riverpod's default (the palette only changes when
//     the user picks a new wallpaper, and a `ref.invalidate` from the
//     settings screen is enough to refresh).
//   * No side effects — it does not write to settings or theme state.

import 'dart:io' show Platform;

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

/// Test seam: lets unit tests pretend they're running on Android so the
/// real `DynamicColorPlugin.getCorePalette()` path is exercised against a
/// mocked MethodChannel. Production code never assigns this — it stays
/// `null` and [Platform.isAndroid] is consulted instead.
///
/// Tests must always restore this to `null` in tearDown so a failing
/// assertion in one test doesn't leak into the next.
bool? debugIsAndroidOverride;

/// Asynchronously resolves the system's wallpaper-derived [CorePalette].
///
/// Returns `null` outside of Android 12+ (where the platform channel has
/// no implementation) so callers can treat the absence of a palette as
/// "fall back to the brand seed" without any platform branching.
final dynamicColorProvider = FutureProvider<CorePalette?>((ref) async {
  // Short-circuit on platforms where we know the plugin is a no-op. This
  // avoids spinning up the MethodChannel on Linux/Windows/macOS just to
  // get a `null` back, and keeps the provider trivially testable on the
  // CI runner (which is Linux).
  final isAndroid = debugIsAndroidOverride ?? Platform.isAndroid;
  if (!isAndroid) return null;

  try {
    return await DynamicColorPlugin.getCorePalette();
  } catch (_) {
    // Defensive: the plugin throws on some OEM builds where the platform
    // channel is registered but the underlying API call fails. Treat any
    // failure as "no dynamic palette available" so the app keeps booting
    // with the brand seed.
    return null;
  }
});
