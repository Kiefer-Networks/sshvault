import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

/// Method-channel name shared with `macos/Runner/UNUserNotifications.swift`.
/// Centralizing it here keeps the Dart and Swift sides honest — anyone
/// renaming on one side is forced to grep for the constant.
const String kMacosNotificationChannel =
    'de.kiefer_networks.sshvault/macos_notif';

/// Stable category identifier that groups SSH-session toasts on macOS.
/// Surfaced to the user only indirectly (Notification Center filters by
/// category), but kept stable so settings like "deliver quietly" stick
/// across releases.
const String kMacosSshSessionCategory = 'ssh_session';

/// Lightweight handle attached to each macOS notification. Mirrors the
/// `WindowsNotificationAction` API exactly so callers can pivot between
/// platforms with identical call sites — only the import changes.
///
/// [tag] is opaque; the macOS plugin re-emits it verbatim on
/// [MacosNotificationService.actionStream] when the user clicks the
/// matching button. ViewModels pattern-match on the prefix
/// (`disconnect:`, `reconnect:`, `show:`).
class MacosNotificationAction {
  /// Visible button label.
  final String label;

  /// Opaque payload routed to listeners when the button is invoked. Doubles
  /// as the action identifier registered with `UNNotificationCategory`.
  final String tag;

  const MacosNotificationAction({required this.label, required this.tag});
}

/// Wraps the native macOS `UNUserNotificationCenter` plugin (Swift source
/// at `macos/Runner/UNUserNotifications.swift`) and exposes the same
/// surface as [WindowsNotificationService]:
///
///   - `show(id, title, body, actions)` with replace-by-id semantics.
///   - `dismiss(id)` to retract from Notification Center.
///   - A broadcast [actionStream] that emits the opaque tag of every
///     button the user invokes (live banner OR Notification Center).
///
/// On non-macOS hosts every method is an explicit no-op so the service
/// can be wired from cross-platform code without `Platform.isMacOS`
/// guards at every call site.
class MacosNotificationService {
  /// Override hook for tests. Production code should leave this `null`
  /// and let the constructor wire the real channel.
  @visibleForTesting
  MacosNotificationService.test({
    required MethodChannel channel,
    Future<void> Function()? bringToFront,
  }) : _channel = channel,
       _bringToFront = bringToFront ?? _defaultBringToFront {
    _channel.setMethodCallHandler(_handleNativeCall);
  }

  /// Production constructor — binds the real method channel. Safe to call
  /// on non-macOS hosts; the channel just never receives anything.
  MacosNotificationService()
    : _channel = const MethodChannel(kMacosNotificationChannel),
      _bringToFront = _defaultBringToFront {
    if (Platform.isMacOS) {
      _channel.setMethodCallHandler(_handleNativeCall);
    }
  }

  final MethodChannel _channel;
  final Future<void> Function() _bringToFront;

  final StreamController<String> _actionController =
      StreamController<String>.broadcast();

  bool _initialized = false;

  /// Emits the [MacosNotificationAction.tag] of every action the user
  /// invokes. Subscribers — typically Riverpod listeners in view-models —
  /// pattern-match the tag prefix to dispatch the right command
  /// (`disconnect:`, `reconnect:`, `show:`).
  Stream<String> get actionStream => _actionController.stream;

  /// Whether [requestAuthorization] has run at least once successfully in
  /// this process. Persisted separately by the settings layer so the user
  /// is only prompted on first run.
  bool get isAuthorizationRequested => _initialized;

  /// Asks macOS for alert/sound/badge permission. The OS shows the system
  /// dialog only the first time it's called for a given app id; subsequent
  /// calls return the cached decision without prompting. Returns `true`
  /// if the user granted permission, `false` otherwise (including when
  /// running on a non-macOS host).
  Future<bool> requestAuthorization() async {
    if (!Platform.isMacOS) return false;
    try {
      final granted = await _channel.invokeMethod<bool>('requestAuthorization');
      _initialized = true;
      return granted ?? false;
    } on PlatformException {
      // Plugin not registered (e.g. flutter_test harness) — treat as
      // denied so callers fall back to the older notification path.
      return false;
    }
  }

  /// Show or replace a notification.
  ///
  /// - [id] is opaque; passing the same id again replaces the previous
  ///   notification both in the live banner and in Notification Center.
  /// - [actions] become inline buttons. Their [MacosNotificationAction.tag]
  ///   is what gets emitted on [actionStream]; the label is shown to the
  ///   user. macOS supports up to four visible actions per notification;
  ///   anything past that gets surfaced in the "More" disclosure.
  /// - Tapping the body activates the SSHVault window via `NSApp.activate`
  ///   on the Swift side and additionally calls [windowManager.show]
  ///   here so the window stays consistent with the rest of the app.
  Future<void> show({
    required String id,
    required String title,
    required String body,
    List<MacosNotificationAction> actions = const [],
  }) async {
    if (!Platform.isMacOS) return;
    final payload = <String, Object?>{
      'id': id,
      'title': title,
      'body': body,
      'categoryId': kMacosSshSessionCategory,
      'actions': actions
          .map((a) => {'id': a.tag, 'label': a.label})
          .toList(growable: false),
    };
    try {
      await _channel.invokeMethod<bool>('show', payload);
    } on PlatformException {
      // Plugin missing or permission denied — silently skip; the
      // session-tracking code path doesn't depend on the toast existing.
    }
  }

  /// Dismiss a previously-shown notification. Removes it from the live
  /// banner AND from Notification Center. No-op on non-macOS.
  Future<void> dismiss(String id) async {
    if (!Platform.isMacOS) return;
    try {
      await _channel.invokeMethod<bool>('dismiss', {'id': id});
    } on PlatformException {
      // Already gone or plugin missing — both are fine for a dismiss.
    }
  }

  /// Tear down resources. Closes the broadcast stream so listeners receive
  /// a clean done signal; called from the owning provider's dispose. We
  /// also detach the channel handler so the test harness can re-register
  /// independently and so production GC isn't held back by the binding.
  Future<void> dispose() async {
    _channel.setMethodCallHandler(null);
    await _actionController.close();
  }

  Future<dynamic> _handleNativeCall(MethodCall call) async {
    switch (call.method) {
      case 'onAction':
        final args = call.arguments;
        if (args is Map) {
          final tag = args['action'];
          if (tag is String) {
            // Bring the window to the front first — clicking an action
            // also activates the app on the Swift side, but we mirror it
            // here so the Flutter view actually paints into focus before
            // the action handler kicks off any navigation.
            unawaited(_bringToFront());
            _actionController.add(tag);
          }
        }
        return null;
      case 'onClick':
        // Body click — surface a synthetic `show:` tag so callers can
        // route back to the terminal branch using the same handler they
        // already use for the `Show` button.
        unawaited(_bringToFront());
        _actionController.add('show:');
        return null;
      default:
        return null;
    }
  }

  /// Default front-bringer. Pulled out so tests can stub the call without
  /// requiring `window_manager`'s plugin registrant.
  static Future<void> _defaultBringToFront() async {
    try {
      await windowManager.show();
      await windowManager.focus();
    } catch (_) {
      // Headless boot or window_manager not initialized — best effort.
    }
  }
}
