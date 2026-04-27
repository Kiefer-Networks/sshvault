import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sshvault/core/services/logging_service.dart';

/// Riverpod state holding whether the activity is currently in
/// Picture-in-Picture mode. The terminal screen reads this to collapse all
/// chrome (tab bar, app bar) and render only the terminal output while the
/// system shows SSHVault as a floating window.
///
/// On non-Android platforms this stays `false` forever — the underlying
/// service is a no-op there.
final pipModeProvider = StateProvider<bool>((_) => false);

/// Bridges the Android Picture-in-Picture lifecycle into Dart.
///
/// Channel: `de.kiefer_networks.sshvault/pip`
///
/// Methods we call on the native side:
///   - `enterPip()`               — programmatic entry from a toolbar button
///   - `setSessionActive(bool)`   — toggles the SharedPreferences gate the
///                                  `MainActivity.onUserLeaveHint()` hook
///                                  reads when the user presses Home
///   - `setPipEnabled(bool)`      — mirrors the user-facing setting so the
///                                  Home-button hook can be disabled without
///                                  a process restart
///   - `isSupported()`            — returns true on Android 26+
///
/// Methods Android invokes back into Dart:
///   - `onPipChanged(bool)`       — the activity entered/left PiP
class AndroidPipService {
  AndroidPipService({MethodChannel? channel, ProviderContainer? container})
    : _channel = channel ?? const MethodChannel(_channelName),
      _container = container {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  static const String _channelName = 'de.kiefer_networks.sshvault/pip';
  static const _tag = 'AndroidPip';
  static final _log = LoggingService.instance;

  final MethodChannel _channel;
  final ProviderContainer? _container;

  /// Stream of PiP mode changes fired by the platform side. Useful for
  /// consumers that don't want to depend on Riverpod (tests primarily).
  final ValueNotifier<bool> pipMode = ValueNotifier<bool>(false);

  /// True iff the host platform can show floating PiP windows. Currently
  /// Android-only — the rest of the surface is a no-op everywhere else
  /// so the service can be wired in unconditionally.
  static bool get isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// Request the activity enter PiP immediately. Returns `true` when the
  /// platform accepted the transition. On non-Android / pre-API-26 returns
  /// `false` without throwing.
  Future<bool> enterPip() async {
    if (!isSupported) return false;
    try {
      final ok = await _channel.invokeMethod<bool>('enterPip');
      return ok ?? false;
    } on MissingPluginException {
      _log.warning(_tag, 'enterPip: native handler not registered');
      return false;
    } on PlatformException catch (e) {
      _log.error(_tag, 'enterPip failed: ${e.message}');
      return false;
    }
  }

  /// Tell the native side whether at least one SSH session is active. The
  /// Home-button auto-PiP hook only fires while this is `true`, so the Dart
  /// session manager should call this on every transition between 0 and
  /// >=1 active sessions.
  Future<void> setSessionActive(bool active) async {
    if (!isSupported) return;
    try {
      await _channel.invokeMethod('setSessionActive', {'active': active});
    } on MissingPluginException {
      // Tests / desktop hosts: no-op silently.
    } on PlatformException catch (e) {
      _log.warning(_tag, 'setSessionActive failed: ${e.message}');
    }
  }

  /// Mirror the user-facing "Picture-in-Picture" toggle to native so the
  /// Home-button hook reads the latest value without a method-channel hop
  /// at the moment of `onUserLeaveHint()`.
  Future<void> setPipEnabled(bool enabled) async {
    if (!isSupported) return;
    try {
      await _channel.invokeMethod('setPipEnabled', {'enabled': enabled});
    } on MissingPluginException {
      // No native handler (desktop / tests) — silently ignore.
    } on PlatformException catch (e) {
      _log.warning(_tag, 'setPipEnabled failed: ${e.message}');
    }
  }

  /// Asks the native side whether PiP is supported on the current device
  /// (API >= 26). Falls back to the Dart-side platform check on failure.
  Future<bool> queryNativeSupport() async {
    if (!isSupported) return false;
    try {
      final ok = await _channel.invokeMethod<bool>('isSupported');
      return ok ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  /// Tear down the listener. The instance is a single-app singleton so this
  /// is rarely needed in production, but tests rely on it.
  void dispose() {
    _channel.setMethodCallHandler(null);
    pipMode.dispose();
  }

  Future<dynamic> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onPipChanged':
        final isInPip = call.arguments == true;
        pipMode.value = isInPip;
        // Update the Riverpod state if the caller wired a container in. We
        // tolerate the absence of a container so the service can still be
        // exercised by unit tests that don't spin up Riverpod.
        try {
          _container?.read(pipModeProvider.notifier).state = isInPip;
        } catch (e) {
          _log.warning(_tag, 'pipModeProvider update failed: $e');
        }
        return null;
      default:
        // Forward-compat: future Android versions may invoke additional
        // callbacks (e.g. close-action). Silently ignore unknowns instead
        // of throwing so older Dart builds keep running on newer OSes.
        return null;
    }
  }
}

/// Riverpod provider exposing a singleton [AndroidPipService] bound to the
/// current container so platform callbacks can flip [pipModeProvider]
/// without an explicit wiring step at app boot.
final androidPipServiceProvider = Provider<AndroidPipService>((ref) {
  final service = AndroidPipService(container: ref.container);
  ref.onDispose(service.dispose);
  return service;
});
