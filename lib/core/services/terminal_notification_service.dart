import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sshvault/core/services/macos_notification_service.dart';
import 'package:sshvault/core/services/windows_notification_service.dart';

/// Manages ongoing notifications for active SSH terminal sessions.
///
/// On mobile (Android/iOS) a persistent notification is shown while SSH
/// sessions are active. Tapping it brings the user back to the terminal.
///
/// On Windows we route through [WindowsNotificationService] which uses the
/// native `Windows.UI.Notifications.ToastNotificationManager` API — toasts
/// surface in the Action Center with action buttons ("Disconnect", "Show")
/// instead of the legacy balloon-style notifications produced by
/// `flutter_local_notifications` on Win32.
///
/// On macOS we route through [MacosNotificationService] which is backed by
/// the native `UNUserNotificationCenter` API (Swift plugin under
/// `macos/Runner/UNUserNotifications.swift`). This replaces the deprecated
/// `NSUserNotification` path baked into `local_notifier` 0.1.6 and
/// `flutter_local_notifications`'s legacy macOS implementation, restoring
/// support for multiple inline action buttons (Reconnect / Disconnect /
/// Show) that persist in Notification Center.
///
/// On Linux the existing `flutter_local_notifications` path is retained.
class TerminalNotificationService {
  static const _channelId = 'terminal_sessions';
  static const _channelName = 'Terminal Sessions';
  static const _notificationId = 42;

  /// Stable string id reused for the Windows toast so the Action Center
  /// shows a single rolling entry as sessions come and go (rather than a
  /// stack of stale notifications).
  static const _windowsToastId = 'sshvault.terminal.sessions';

  /// Stable id used for the macOS Notification Center entry. Same intent
  /// as [_windowsToastId] — replace-by-id semantics keep the Notification
  /// Center clean when the active-session set churns.
  static const _macosToastId = 'sshvault.terminal.sessions';

  /// Set by the shell to navigate to the terminal branch on tap.
  static void Function()? onNotificationTapped;

  final _plugin = FlutterLocalNotificationsPlugin();
  final WindowsNotificationService? _windows;
  final MacosNotificationService? _macos;
  bool _initialized = false;

  /// Subscription to the Windows toast action stream — owned for the
  /// lifetime of the service, cancelled in [dismiss] when shutting down.
  StreamSubscription<String>? _windowsActionSub;

  /// Subscription to the macOS notification action stream. Mirrors the
  /// Windows path so the shell can use a single unified handler.
  StreamSubscription<String>? _macosActionSub;

  /// Optional handler for desktop toast actions. Wired by the shell via
  /// [onWindowsAction] / [onMacosAction]. We keep the two slots distinct
  /// even though their tag vocabularies overlap so the shell can opt one
  /// platform out without affecting the other.
  void Function(String tag)? _onWindowsAction;
  void Function(String tag)? _onMacosAction;

  TerminalNotificationService({
    WindowsNotificationService? windowsService,
    MacosNotificationService? macosService,
  }) : _windows = Platform.isWindows
           ? (windowsService ?? WindowsNotificationService())
           : null,
       _macos = Platform.isMacOS
           ? (macosService ?? MacosNotificationService())
           : null;

  /// Hook for the shell to receive opaque action tags emitted by Windows
  /// toast buttons (e.g. "disconnect:SESSION_ID", "show:"). Called once
  /// during shell init; the service forwards every subsequent click here.
  void onWindowsAction(void Function(String tag) handler) {
    _onWindowsAction = handler;
    _windowsActionSub ??= _windows?.actionStream.listen((tag) {
      _onWindowsAction?.call(tag);
    });
  }

  /// Hook for the shell to receive opaque action tags emitted by macOS
  /// `UNUserNotification` buttons. Tag vocabulary is identical to the
  /// Windows side (`disconnect:SESSION_ID`, `reconnect:HOST_ID`, `show:`)
  /// so the shell can share the same dispatch logic.
  void onMacosAction(void Function(String tag) handler) {
    _onMacosAction = handler;
    _macosActionSub ??= _macos?.actionStream.listen((tag) {
      _onMacosAction?.call(tag);
    });
  }

  /// Requests UNUserNotificationCenter authorization on macOS. No-op on
  /// other platforms. Should be called once early in app start so the
  /// system permission dialog appears before the first toast attempts to
  /// surface (otherwise the toast is silently dropped). Returns `true` if
  /// the user has granted permission.
  Future<bool> ensureMacosAuthorized() async {
    if (!Platform.isMacOS) return true;
    return await _macos?.requestAuthorization() ?? false;
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    _initialized = true;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: (_) {
        onNotificationTapped?.call();
      },
    );

    // Request permission on iOS and Android 13+. macOS does NOT use this
    // path anymore — it goes through MacosNotificationService.
    if (Platform.isIOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true);
    } else if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
  }

  /// Show or update the ongoing session notification.
  ///
  /// On Windows the call routes to [WindowsNotificationService.show] with
  /// "Disconnect" + "Show" action buttons. On macOS it routes to
  /// [MacosNotificationService.show] with the same action set. The
  /// provided [windowsDisconnectTag] / [macosDisconnectTag] is the opaque
  /// payload re-emitted on the matching service's stream when the user
  /// clicks "Disconnect" — the shell maps it back to the right session
  /// via the action handler registered with [onWindowsAction] /
  /// [onMacosAction].
  Future<void> show({
    required String title,
    required String body,
    bool windowsActionsEnabled = true,
    bool macosActionsEnabled = true,
    String? windowsDisconnectTag,
    String? macosDisconnectTag,
  }) async {
    if (Platform.isWindows) {
      final actions = <WindowsNotificationAction>[
        if (windowsActionsEnabled && windowsDisconnectTag != null)
          WindowsNotificationAction(
            label: 'Disconnect',
            tag: windowsDisconnectTag,
          ),
        if (windowsActionsEnabled)
          const WindowsNotificationAction(label: 'Show', tag: 'show:'),
      ];
      await _windows?.show(
        id: _windowsToastId,
        title: title,
        body: body,
        actions: actions,
      );
      return;
    }
    if (Platform.isMacOS) {
      final actions = <MacosNotificationAction>[
        if (macosActionsEnabled && macosDisconnectTag != null)
          MacosNotificationAction(label: 'Disconnect', tag: macosDisconnectTag),
        if (macosActionsEnabled)
          const MacosNotificationAction(label: 'Show', tag: 'show:'),
      ];
      await _macos?.show(
        id: _macosToastId,
        title: title,
        body: body,
        actions: actions,
      );
      return;
    }
    if (!Platform.isAndroid && !Platform.isIOS) return;
    await _ensureInitialized();

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Shows when SSH terminal sessions are active',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
      category: AndroidNotificationCategory.service,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: false,
    );

    await _plugin.show(
      id: _notificationId,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
    );
  }

  /// Dismiss the session notification.
  Future<void> dismiss() async {
    if (Platform.isWindows) {
      await _windows?.dismiss(_windowsToastId);
      await _windowsActionSub?.cancel();
      _windowsActionSub = null;
      return;
    }
    if (Platform.isMacOS) {
      await _macos?.dismiss(_macosToastId);
      await _macosActionSub?.cancel();
      _macosActionSub = null;
      return;
    }
    if (!Platform.isAndroid && !Platform.isIOS) return;
    if (!_initialized) return;
    await _plugin.cancel(id: _notificationId);
  }
}
