import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Semantic haptic feedback wrapper that gives every UI affordance a
/// *meaning* instead of a magnitude.
///
/// Why bother? Material 3 introduced a richer haptic palette in Android
/// 11+ (API 30+) — `HapticFeedbackConstants.CONFIRM`, `REJECT`, and
/// `GESTURE_END` — that conveys outcome, not just intensity. iOS has had
/// the same idea since iOS 10 with `UINotificationFeedbackGenerator`
/// (`.success` / `.warning` / `.error`). Flutter's stock [HapticFeedback]
/// only exposes the older "light / medium / heavy" impact scale plus a
/// `vibrate()` that resolves to `AudioServicesPlaySystemSound` on iOS
/// (i.e. *not* a notification haptic). We therefore bridge:
///   * Android — `HapticFeedbackConstants.CONFIRM / REJECT / GESTURE_END`
///   * iOS — `UINotificationFeedbackGenerator` for outcome haptics
///   * Both — fall back to the closest stock Flutter primitive on older
///     OS versions or when the bridge declines.
///
/// Call sites should never reach for [HapticFeedback] directly: use one
/// of [tapConfirm], [tapReject], [gestureEnd], [notifySuccess],
/// [notifyWarning], or [notifyError] so the gesture's *intent* is visible
/// at the call site and the platform mapping stays in one place.
class HapticFeedbackHelper {
  HapticFeedbackHelper._();

  /// Method channel name. Must mirror `MainActivity.hapticChannel` on the
  /// Kotlin side.
  @visibleForTesting
  static const MethodChannel channel = MethodChannel(
    'de.kiefer_networks.sshvault/haptic',
  );

  /// iOS-only method channel for `UINotificationFeedbackGenerator`. Must
  /// mirror the channel name registered in `ios/Runner/AppDelegate.swift`.
  /// Kept separate from [channel] so the Android handler can stay
  /// platform-pure and the iOS handler does not have to no-op on
  /// Android-flavoured payloads.
  @visibleForTesting
  static const MethodChannel iosNotificationChannel = MethodChannel(
    'de.kiefer-networks.sshvault/haptic_notification',
  );

  /// Test seam: lets unit tests override the platform check without
  /// having to mock `dart:io`. When non-null, the helper treats the
  /// current platform as Android iff the value is `true`.
  @visibleForTesting
  static bool? debugIsAndroidOverride;

  /// Test seam: lets unit tests override the iOS platform check without
  /// having to mock `dart:io`. When non-null, the helper treats the
  /// current platform as iOS iff the value is `true`.
  @visibleForTesting
  static bool? debugIsIosOverride;

  static bool get _isAndroid =>
      debugIsAndroidOverride ?? (!kIsWeb && Platform.isAndroid);

  static bool get _isIos => debugIsIosOverride ?? (!kIsWeb && Platform.isIOS);

  /// Affirmative feedback — used for accept / confirm / connect actions.
  ///
  /// Maps to:
  ///   * Android 11+: `HapticFeedbackConstants.CONFIRM`
  ///   * Older Android: `HapticFeedbackConstants.VIRTUAL_KEY`
  ///   * Other platforms: [HapticFeedback.lightImpact]
  static Future<void> tapConfirm() async {
    if (await _invokeNative('confirm')) return;
    await HapticFeedback.lightImpact();
  }

  /// Negative feedback — used for cancel / reject / destructive-confirm
  /// actions (e.g. confirming a delete).
  ///
  /// Maps to:
  ///   * Android 11+: `HapticFeedbackConstants.REJECT`
  ///   * Older Android: `HapticFeedbackConstants.LONG_PRESS`
  ///   * Other platforms: [HapticFeedback.mediumImpact]
  static Future<void> tapReject() async {
    if (await _invokeNative('reject')) return;
    await HapticFeedback.mediumImpact();
  }

  /// "Gesture committed" feedback — used at the end of a swipe-to-delete
  /// or any irreversible drag. Lighter than [tapReject] because the user
  /// has already seen the visual outcome of the gesture.
  ///
  /// Maps to:
  ///   * Android 11+: `HapticFeedbackConstants.GESTURE_END`
  ///   * Older Android: `HapticFeedbackConstants.CONTEXT_CLICK`
  ///   * Other platforms: [HapticFeedback.selectionClick]
  static Future<void> gestureEnd() async {
    if (await _invokeNative('gestureEnd')) return;
    await HapticFeedback.selectionClick();
  }

  /// Affirmative outcome — a brief celebratory thump used after an
  /// operation finishes successfully (vault unlock, key import, snippet
  /// save). Distinct from [tapConfirm], which fires the *moment* a button
  /// is pressed; this fires once the work behind it is *done*.
  ///
  /// Maps to:
  ///   * iOS 10+: `UINotificationFeedbackGenerator.notificationOccurred(.success)`
  ///   * Android 11+: `HapticFeedbackConstants.CONFIRM`
  ///   * Older Android: `HapticFeedbackConstants.VIRTUAL_KEY`
  ///   * Other platforms: [HapticFeedback.lightImpact]
  static Future<void> notifySuccess() async {
    if (await _invokeIosNotification('success')) return;
    if (await _invokeNative('confirm')) return;
    await HapticFeedback.lightImpact();
  }

  /// Cautionary outcome — a double-tap pattern used when a non-fatal
  /// problem surfaces (input validation, near-empty rate-limit budget,
  /// host-key TOFU prompt). Heavier than [notifySuccess] without escalating
  /// to the staccato error pattern.
  ///
  /// Maps to:
  ///   * iOS 10+: `UINotificationFeedbackGenerator.notificationOccurred(.warning)`
  ///   * Android 11+: `HapticFeedbackConstants.REJECT`
  ///   * Older Android: `HapticFeedbackConstants.LONG_PRESS`
  ///   * Other platforms: [HapticFeedback.mediumImpact]
  static Future<void> notifyWarning() async {
    if (await _invokeIosNotification('warning')) return;
    if (await _invokeNative('reject')) return;
    await HapticFeedback.mediumImpact();
  }

  /// Failure outcome — the staccato three-tap pattern reserved for hard
  /// failures (auth rejected, host-key mismatch, decryption failed). On
  /// platforms without a dedicated error haptic this falls through to
  /// `heavyImpact`, which is the loudest stock primitive.
  ///
  /// Maps to:
  ///   * iOS 10+: `UINotificationFeedbackGenerator.notificationOccurred(.error)`
  ///   * Android 11+: `HapticFeedbackConstants.REJECT`
  ///   * Older Android: `HapticFeedbackConstants.LONG_PRESS`
  ///   * Other platforms: [HapticFeedback.heavyImpact]
  static Future<void> notifyError() async {
    if (await _invokeIosNotification('error')) return;
    if (await _invokeNative('reject')) return;
    await HapticFeedback.heavyImpact();
  }

  /// Invokes the Android haptic bridge. Returns `true` when the platform
  /// performed a haptic, `false` if it declined (unknown name) or the
  /// platform isn't Android.
  ///
  /// Any [PlatformException] is swallowed — haptics are a polish layer
  /// and must never propagate failure into business logic.
  static Future<bool> _invokeNative(String type) async {
    if (!_isAndroid) return false;
    try {
      final result = await channel.invokeMethod<bool>(
        'performHaptic',
        <String, Object?>{'type': type},
      );
      return result == true;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  /// Invokes the iOS notification-haptic bridge. Returns `true` when the
  /// platform reports the haptic was scheduled, `false` if it declined or
  /// the platform isn't iOS.
  ///
  /// As with [_invokeNative] every platform error is swallowed — haptics
  /// are polish, never load-bearing.
  static Future<bool> _invokeIosNotification(String type) async {
    if (!_isIos) return false;
    try {
      final result = await iosNotificationChannel.invokeMethod<bool>(
        'notify',
        <String, Object?>{'type': type},
      );
      return result == true;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}
