import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sshvault/core/services/logging_service.dart';

/// Bridges Flutter to the iPadOS multi-window APIs.
///
/// On iPadOS the system supports running the same app in multiple parallel
/// scenes — Stage Manager, Split View, and Slide Over all rely on this.
/// `Info.plist` already declares `UIApplicationSupportsMultipleScenes=true`
/// and `ios/Runner/SceneDelegate.swift` handles the lifecycle. This service
/// is the Dart-side entry point: callers ask to "open in a new window" and
/// the native side spawns a fresh scene pre-routed to the requested SSH
/// session.
///
/// On every other platform — including iPhone — the service degrades to a
/// no-op (`isSupported` is `false`, calls return harmlessly).
class IosWindowService {
  IosWindowService._();

  /// Singleton instance. The service holds no per-instance state, but a
  /// singleton keeps the API symmetric with the rest of `core/services/`.
  static final IosWindowService instance = IosWindowService._();

  static const String _channelName = 'de.kiefer_networks.sshvault/ios_windows';

  /// Activity type that the Swift side encodes into the spawned
  /// `NSUserActivity`. Mirrored in `SceneDelegate.swift` —
  /// `kSshVaultSessionActivityType`.
  // ignore: unused_field
  static const String _activityType = 'de.kiefer_networks.sshvault.session';

  static const MethodChannel _channel = MethodChannel(_channelName);

  static final _log = LoggingService.instance;
  static const _tag = 'IosWindowService';

  bool _multiWindowKnown = false;
  bool _multiWindowSupported = false;

  /// `true` iff the current platform is iOS *and* the running device reports
  /// support for multiple scenes. iPhones running iOS 13+ technically have
  /// the API but the system rejects activation requests, so we additionally
  /// gate on the runtime answer from the native side.
  ///
  /// Callers should still combine this with a layout-size check
  /// (`MediaQuery.size.width > 600`) to avoid showing the action on iPhones
  /// even if the OS would accept the call.
  bool get isPlatformSupported => !kIsWeb && Platform.isIOS;

  /// Sync, layout-only version — does not query the native side. Intended
  /// for `build()` predicates that only care about the platform name.
  static bool get isIosPlatform => !kIsWeb && Platform.isIOS;

  /// Probes the native side for runtime multi-scene support. Cached.
  Future<bool> isMultiWindowSupported() async {
    if (!isPlatformSupported) return false;
    if (_multiWindowKnown) return _multiWindowSupported;
    try {
      final supported = await _channel.invokeMethod<bool>(
        'isMultiWindowSupported',
      );
      _multiWindowSupported = supported ?? false;
    } on MissingPluginException {
      _multiWindowSupported = false;
    } on PlatformException catch (e) {
      _log.warning(_tag, 'isMultiWindowSupported failed: $e');
      _multiWindowSupported = false;
    }
    _multiWindowKnown = true;
    return _multiWindowSupported;
  }

  /// Asks iPadOS to spawn a new scene pre-routed to [hostId].
  ///
  /// The native side calls `UIApplication.shared.requestSceneSessionActivation`
  /// with an `NSUserActivity` carrying the host id. When the new scene
  /// connects, `SceneDelegate.scene(_:willConnectTo:options:)` reads the
  /// activity and posts an `openSessionInThisWindow` callback over the same
  /// method channel — see [setSessionOpener].
  ///
  /// Returns `true` on success, `false` when the platform does not support
  /// multi-window or the call failed. The method never throws.
  Future<bool> openSessionWindow(String hostId) async {
    if (!isPlatformSupported) {
      _log.debug(_tag, 'openSessionWindow($hostId) ignored: not iPadOS');
      return false;
    }
    try {
      await _channel.invokeMethod<void>('openSessionWindow', {
        'hostId': hostId,
      });
      _log.info(_tag, 'Spawned new iPad window for host=$hostId');
      return true;
    } on MissingPluginException {
      _log.warning(_tag, 'iOS window plugin not registered');
      return false;
    } on PlatformException catch (e) {
      _log.error(_tag, 'openSessionWindow failed: $e');
      return false;
    }
  }

  /// Hook invoked by the native side on a freshly-connected scene that was
  /// spawned for a specific session. Pass a callback that opens [hostId]
  /// (typically `sessionManagerProvider.openSession` + a route push to
  /// `/terminal`).
  ///
  /// Returns a [StreamSubscription]-like disposable so callers can detach
  /// when their owning provider disposes.
  void setSessionOpener(Future<void> Function(String hostId) opener) {
    if (!isPlatformSupported) return;
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'openSessionInThisWindow':
          final args = call.arguments as Map?;
          final hostId = args?['hostId'] as String?;
          if (hostId == null || hostId.isEmpty) return null;
          try {
            await opener(hostId);
          } catch (e, stack) {
            _log.error(_tag, 'session opener threw: $e\n$stack');
          }
          return null;
        default:
          return null;
      }
    });
  }
}
