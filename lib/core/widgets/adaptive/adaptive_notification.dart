import 'dart:async';
import 'dart:io' show Platform;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

bool get _isApplePlatform => Platform.isIOS || Platform.isMacOS;
bool get _supportsSystemNotification =>
    Platform.isMacOS || Platform.isLinux || Platform.isWindows;

/// Shows a platform-adaptive notification.
///
/// Uses native system notifications on macOS, Linux, and Windows; a
/// Cupertino-style overlay toast on iOS; and a Material [SnackBar] on Android.
class AdaptiveNotification {
  AdaptiveNotification._();

  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _systemInitialized = false;
  static int _notificationId = 1000;

  static Future<void> _ensureSystemInitialized() async {
    if (_systemInitialized) return;
    _systemInitialized = true;

    const macSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: false,
      requestSoundPermission: false,
      defaultPresentAlert: true,
      defaultPresentBadge: false,
      defaultPresentSound: false,
    );

    const linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'Open',
    );

    const windowsSettings = WindowsInitializationSettings(
      appName: 'SSHVault',
      appUserModelId: 'KieferNetworks.SSHVault',
      guid: 'e7d9f3c4-1a2b-4c5d-9e6f-7a8b9c0d1e2f',
    );

    await _plugin.initialize(
      settings: const InitializationSettings(
        macOS: macSettings,
        linux: linuxSettings,
        windows: windowsSettings,
      ),
    );

    if (Platform.isMacOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true);
    }
  }

  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    if (_supportsSystemNotification) {
      _showSystemNotification(message);
      return;
    }

    if (_isApplePlatform) {
      _showCupertinoOverlay(
        context,
        message: message,
        duration: duration,
        actionLabel: actionLabel,
        onAction: onAction,
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: actionLabel != null
            ? SnackBarAction(label: actionLabel, onPressed: onAction ?? () {})
            : null,
      ),
    );
  }

  static Future<void> _showSystemNotification(String message) async {
    await _ensureSystemInitialized();

    const details = NotificationDetails(
      macOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: false,
        presentSound: false,
      ),
      linux: LinuxNotificationDetails(),
      windows: WindowsNotificationDetails(),
    );

    final id = _notificationId++;
    await _plugin.show(
      id: id,
      title: 'SSHVault',
      body: message,
      notificationDetails: details,
    );
  }

  static void _showCupertinoOverlay(
    BuildContext context, {
    required String message,
    required Duration duration,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _CupertinoNotificationOverlay(
        message: message,
        duration: duration,
        actionLabel: actionLabel,
        onAction: onAction,
        onDismiss: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
  }
}

class _CupertinoNotificationOverlay extends StatefulWidget {
  final String message;
  final Duration duration;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback onDismiss;

  const _CupertinoNotificationOverlay({
    required this.message,
    required this.duration,
    this.actionLabel,
    this.onAction,
    required this.onDismiss,
  });

  @override
  State<_CupertinoNotificationOverlay> createState() =>
      _CupertinoNotificationOverlayState();
}

class _CupertinoNotificationOverlayState
    extends State<_CupertinoNotificationOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
    _dismissTimer = Timer(widget.duration, _dismiss);
  }

  void _dismiss() {
    _dismissTimer?.cancel();
    _controller.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDark = brightness == Brightness.dark;

    return Positioned(
      top: padding.top + 8,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xCC2C2C2E)
                      : const Color(0xCCF2F2F7),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? const Color(0x33FFFFFF)
                        : const Color(0x33000000),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.message,
                        style: TextStyle(
                          color: isDark
                              ? CupertinoColors.white
                              : CupertinoColors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (widget.actionLabel != null)
                      CupertinoButton(
                        padding: const EdgeInsets.only(left: 12),
                        minimumSize: Size.zero,
                        onPressed: () {
                          widget.onAction?.call();
                          _dismiss();
                        },
                        child: Text(
                          widget.actionLabel!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
