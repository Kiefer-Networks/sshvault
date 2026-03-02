import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shellvault/core/services/logging_service.dart';

/// Prevents screenshots and screen recording on mobile platforms.
///
/// - Android: Uses FLAG_SECURE via platform channel
/// - iOS: Uses secure text field overlay via platform channel
/// - Desktop/Web: No-op (OS-level screenshot prevention not possible)
class ScreenProtectionService {
  static final _log = LoggingService.instance;
  static const _tag = 'ScreenProtection';
  static const _channel = MethodChannel('com.shellvault/screen_protection');

  bool _enabled = false;

  bool get enabled => _enabled;

  /// Returns true if this platform supports screenshot prevention.
  static bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> setEnabled(bool enable) async {
    if (!isSupported) return;
    if (enable == _enabled) return;

    try {
      await _channel.invokeMethod('setFlagSecure', {'enable': enable});
      _enabled = enable;
      _log.info(_tag, 'Screen protection ${enable ? 'enabled' : 'disabled'}');
    } on PlatformException catch (e) {
      _log.error(_tag, 'Failed to set screen protection: $e');
    }
  }
}
