import 'dart:io';

import 'package:flutter/foundation.dart';

/// Whether the current platform supports native In-App Purchases.
bool get isNativeIapPlatform {
  if (kIsWeb) return false;
  return Platform.isIOS || Platform.isAndroid || Platform.isMacOS;
}

/// Whether the current platform is a mobile device (iOS or Android).
bool get isMobilePlatform {
  if (kIsWeb) return false;
  return Platform.isIOS || Platform.isAndroid;
}

/// Whether the current platform is a desktop OS (macOS, Windows, Linux).
bool get isDesktopPlatform {
  if (kIsWeb) return false;
  return Platform.isMacOS || Platform.isWindows || Platform.isLinux;
}
