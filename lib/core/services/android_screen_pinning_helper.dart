import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sshvault/core/services/logging_service.dart';

/// Small helper that opens the system Lock-Screen / Screen-Pinning settings
/// page on Android.
///
/// Android's "Screen Pinning" feature (sometimes branded "App Pinning") locks
/// the device to a single app until the user enters their PIN/biometric, which
/// is exactly the workflow we want to recommend when handing the unlocked
/// phone to a colleague to copy a public key. There is no public API to pin
/// our own activity, but we can drop the user one tap away from the toggle.
///
/// On non-Android platforms every method is a no-op that returns `false`.
///
/// Usage example (e.g. inside an onboarding tip card):
///
/// ```dart
/// if (AndroidScreenPinningHelper.isSupported) {
///   await AndroidScreenPinningHelper.openSettings();
/// }
/// ```
///
/// The deeplink uses the `android.settings.LOCK_SCREEN_SETTINGS` intent
/// action, which lands directly on the page that hosts the
/// "App pinning" / "Screen pinning" toggle on stock Android. Some OEM skins
/// (Samsung One UI, Xiaomi MIUI) host it under a different path; in that case
/// the intent still opens the closest matching settings root and the user can
/// finish navigation manually.
class AndroidScreenPinningHelper {
  static final _log = LoggingService.instance;
  static const _tag = 'ScreenPinning';

  /// Channel shared with `MainActivity` for OS-integration helpers. We
  /// re-use the screen_protection channel namespace prefix to keep the
  /// surface tidy; the method name is unique.
  static const _channel = MethodChannel(
    'de.kiefer-networks.sshvault/screen_pinning',
  );

  /// True only on Android — Screen Pinning is an Android concept.
  static bool get isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// Open the system page that hosts the Screen-Pinning toggle.
  ///
  /// Returns `true` when the intent was dispatched successfully, `false`
  /// otherwise (unsupported platform, missing native handler, or intent
  /// resolution failure on a stripped-down ROM).
  static Future<bool> openSettings() async {
    if (!isSupported) return false;
    try {
      final ok = await _channel.invokeMethod<bool>('openLockScreenSettings');
      return ok ?? false;
    } on MissingPluginException {
      _log.warning(
        _tag,
        'Native handler not registered; Screen-Pinning deeplink unavailable.',
      );
      return false;
    } on PlatformException catch (e) {
      _log.error(_tag, 'Failed to open Lock-Screen settings: $e');
      return false;
    }
  }
}
