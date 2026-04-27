/// Tray-only / headless boot mode for SSHVault.
///
/// The flow looks like this:
///
///   1. `main.dart` parses `--minimized` (or `SSHVAULT_MINIMIZED=1`) from
///      argv/env and flips [HeadlessBootService.startMinimized] BEFORE
///      `runApp`.
///   2. While `startMinimized` is true the service:
///        - Skips the initial `windowManager.show()` (the window stays hidden
///          until the user picks "Show window" from the tray).
///        - Asks `app.dart` to defer the first-run security dialog and any
///          onboarding step until the window is actually surfaced.
///        - Allows DBus, the system tray and `autoSync` to run normally so
///          that external KRunner / Polybar triggers and background sync are
///          unaffected.
///   3. The service installs a `WindowListener` that intercepts the [×]
///      button. When `closeToTray` is on (Linux / Windows only) the window
///      hides instead of quitting.
///   4. Resume-on-login: if the user opted into [resumeOnLogin] and any
///      hosts are recorded as "last active" the service replays them via
///      [resumeSavedSessions] without surfacing the window.
///
/// Everything behind a `Platform.isLinux || Platform.isWindows` guard is
/// inert on macOS / mobile, so this file is safe to import unconditionally.
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'package:sshvault/core/services/logging_service.dart';

/// Riverpod provider exposing the singleton service. Treat this as the
/// single source of truth for [HeadlessBootService.isHeadlessBoot].
final headlessBootServiceProvider = Provider<HeadlessBootService>((ref) {
  return HeadlessBootService.instance;
});

/// Convenience provider — `true` while the app is in tray-only boot mode.
final isHeadlessBootProvider = Provider<bool>((ref) {
  return ref.watch(headlessBootServiceProvider).isHeadlessBoot;
});

/// Reads the last-active host id list. Provided as an async indirection so
/// tests can swap in a fake without touching the real database. Defaults to
/// reading nothing — `app.dart` overrides this with the real implementation
/// once it has access to the SharedPrefs / settings DAO.
typedef LastActiveHostsLoader = Future<List<String>> Function();

/// Opens a single saved session by host id. Same idea as above — `app.dart`
/// wires this to `sessionManagerProvider.openSession`.
typedef SessionOpener = Future<void> Function(String hostId);

/// Holds the runtime "tray-only boot" flags and orchestrates the
/// `windowManager` close-intercept and session-resume logic.
class HeadlessBootService with WindowListener {
  HeadlessBootService._();

  /// Singleton instance. Keep the constructor private so tests can call
  /// [debugReset] to start from a clean state without recreating it.
  static final HeadlessBootService instance = HeadlessBootService._();

  // ---------------------------------------------------------------------
  // Boot-time flags. Mutated from main.dart before `runApp`.
  // ---------------------------------------------------------------------

  /// `true` if the binary was started with `--minimized` or
  /// `SSHVAULT_MINIMIZED=1`. Treated as the single source of truth for
  /// whether we boot into the tray.
  static bool startMinimized = false;

  // ---------------------------------------------------------------------
  // Settings-driven flags. Updated from `applySettings` whenever the
  // SettingsNotifier emits.
  // ---------------------------------------------------------------------

  /// When the user clicks [×] on Linux / Windows: hide the window instead of
  /// quitting. Off by default.
  bool closeToTray = false;

  /// When set, the service will replay the last-active hosts on boot if
  /// [startMinimized] is also true.
  bool resumeOnLogin = false;

  // ---------------------------------------------------------------------
  // Internal state.
  // ---------------------------------------------------------------------

  bool _windowListenerInstalled = false;
  bool _windowSurfaced = false;
  bool _disposed = false;

  LastActiveHostsLoader? _lastActiveHostsLoader;
  SessionOpener? _sessionOpener;

  /// `true` when the binary was launched in tray-only mode and the user has
  /// not yet surfaced the window.
  bool get isHeadlessBoot => startMinimized && !_windowSurfaced;

  /// Plumbing for tests: resets every flag to its default. Never call from
  /// production code.
  @visibleForTesting
  void debugReset() {
    startMinimized = false;
    closeToTray = false;
    resumeOnLogin = false;
    _windowListenerInstalled = false;
    _windowSurfaced = false;
    _disposed = false;
    _lastActiveHostsLoader = null;
    _sessionOpener = null;
  }

  // ---------------------------------------------------------------------
  // Public API.
  // ---------------------------------------------------------------------

  /// Wires up persistence callbacks. Call once from `app.dart` after the
  /// providers are available.
  void wirePersistence({
    required LastActiveHostsLoader loadLastActiveHosts,
    required SessionOpener openSession,
  }) {
    _lastActiveHostsLoader = loadLastActiveHosts;
    _sessionOpener = openSession;
  }

  /// Installs the `WindowListener` that turns [×] into a "hide to tray"
  /// when [closeToTray] is enabled. Linux and Windows only — every other
  /// platform returns immediately.
  Future<void> installWindowCloseIntercept() async {
    if (_windowListenerInstalled) return;
    if (!Platform.isLinux && !Platform.isWindows) return;

    try {
      windowManager.addListener(this);
      // Without setPreventClose(true) the native close button quits the app
      // immediately. We only flip this on for the platforms we care about.
      await windowManager.setPreventClose(true);
      _windowListenerInstalled = true;
      LoggingService.instance.info(
        'HeadlessBoot',
        'Window close intercept installed',
      );
    } catch (e) {
      LoggingService.instance.warning(
        'HeadlessBoot',
        'Failed to install window close intercept: $e',
      );
    }
  }

  /// Marks the window as having been surfaced to the user (via the tray
  /// "Show window" item, an external DBus `Activate`, or the user starting
  /// in normal mode). Subsequent `isHeadlessBoot` reads return `false`.
  void markWindowSurfaced() {
    _windowSurfaced = true;
  }

  /// Pulls the matching flags out of the freshly emitted settings entity.
  /// [closeToTraySetting] and [resumeOnLoginSetting] are nullable so we can
  /// keep the previous value if the settings haven't loaded yet.
  void applySettings({bool? closeToTraySetting, bool? resumeOnLoginSetting}) {
    if (closeToTraySetting != null) closeToTray = closeToTraySetting;
    if (resumeOnLoginSetting != null) resumeOnLogin = resumeOnLoginSetting;
  }

  /// Hides the window without destroying it. Safe to call from any
  /// platform — non-desktop platforms get a no-op.
  Future<void> hideToTray() async {
    if (!Platform.isLinux && !Platform.isWindows) return;
    try {
      await windowManager.hide();
    } catch (e) {
      LoggingService.instance.warning(
        'HeadlessBoot',
        'Failed to hide window: $e',
      );
    }
  }

  /// Surfaces the main window. Calls `windowManager.show()` + `focus()`.
  Future<void> showWindow() async {
    if (!Platform.isLinux && !Platform.isWindows) return;
    try {
      await windowManager.show();
      await windowManager.focus();
      markWindowSurfaced();
    } catch (e) {
      LoggingService.instance.warning(
        'HeadlessBoot',
        'Failed to show window: $e',
      );
    }
  }

  /// Re-opens any saved sessions in the background. Returns the list of host
  /// ids that were attempted (even if the open failed) so callers can log /
  /// surface a notification.
  ///
  /// Skips the work entirely if either:
  ///   * The boot was not minimized (startup-only behaviour).
  ///   * The user disabled [resumeOnLogin].
  ///   * No hosts have been persisted.
  Future<List<String>> resumeSavedSessions() async {
    if (!startMinimized) return const [];
    if (!resumeOnLogin) return const [];
    final loader = _lastActiveHostsLoader;
    final opener = _sessionOpener;
    if (loader == null || opener == null) return const [];

    final hosts = await loader();
    if (hosts.isEmpty) return const [];

    LoggingService.instance.info(
      'HeadlessBoot',
      'Resuming ${hosts.length} session(s) in background',
    );
    for (final id in hosts) {
      try {
        await opener(id);
      } catch (e) {
        LoggingService.instance.warning(
          'HeadlessBoot',
          'Failed to resume session $id: $e',
        );
      }
    }
    return hosts;
  }

  /// Tears down the close intercept on quit. Idempotent.
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    if (!_windowListenerInstalled) return;
    try {
      windowManager.removeListener(this);
      await windowManager.setPreventClose(false);
    } catch (_) {
      // best-effort
    }
  }

  // ---------------------------------------------------------------------
  // WindowListener — close-button interception.
  // ---------------------------------------------------------------------

  @override
  void onWindowClose() {
    // Fire and forget — the close event is synchronous from the framework's
    // POV. We resolve the intent off the UI thread.
    unawaited(_handleCloseIntent());
  }

  Future<void> _handleCloseIntent() async {
    if (!Platform.isLinux && !Platform.isWindows) return;
    try {
      if (closeToTray) {
        await windowManager.hide();
        return;
      }
      // closeToTray is off — honour the user's intent and quit.
      await windowManager.setPreventClose(false);
      await windowManager.destroy();
    } catch (e) {
      LoggingService.instance.warning(
        'HeadlessBoot',
        'Window close handler failed: $e',
      );
    }
  }
}
