import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Manages ongoing notifications for active SSH terminal sessions.
///
/// On mobile (Android/iOS) a persistent notification is shown while SSH
/// sessions are active. Tapping it brings the user back to the terminal.
class TerminalNotificationService {
  static const _channelId = 'terminal_sessions';
  static const _channelName = 'Terminal Sessions';
  static const _notificationId = 42;

  /// Set by the shell to navigate to the terminal branch on tap.
  static void Function()? onNotificationTapped;

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

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

    // Request permission on iOS and Android 13+
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
  Future<void> show({required String title, required String body}) async {
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
    if (!Platform.isAndroid && !Platform.isIOS) return;
    if (!_initialized) return;
    await _plugin.cancel(id: _notificationId);
  }
}
