import 'package:flutter/foundation.dart';

/// Whether the UI should use Cupertino design.
///
/// Currently always false — Material Design is used on all platforms.
bool get useCupertinoDesign => false;

/// Whether the platform is iOS mobile.
///
/// Currently always false — Material layout is used everywhere.
bool get isCupertinoMobile => false;

/// Whether the current platform supports native In-App Purchases.
bool get isNativeIapPlatform {
  if (kIsWeb) return false;
  return defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.macOS;
}

/// Whether the current platform is a mobile device (iOS or Android).
bool get isMobilePlatform {
  if (kIsWeb) return false;
  return defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;
}

/// Whether the current platform is a desktop OS (macOS, Windows, Linux).
bool get isDesktopPlatform {
  if (kIsWeb) return false;
  return defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux;
}
