/// Linux system tray integration for SSHVault.
///
/// Uses the `tray_manager` package (libayatana-appindicator under the hood)
/// so the icon shows up correctly on:
///   - KDE Plasma (StatusNotifierItem native)
///   - GNOME Shell with the AppIndicator / KStatusNotifierItem extension
///   - XFCE
///   - Cinnamon
///
/// The whole service is a no-op on non-Linux platforms. Callers should still
/// guard at the call site (`if (Platform.isLinux)`) so the import graph
/// pulls nothing on macOS / mobile.
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import 'package:sshvault/core/routing/app_router.dart';
import 'package:sshvault/core/services/headless_boot_service.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

/// A pure-data description of one tray menu entry.
///
/// Used so `menuItems` can be exercised in unit tests without having to
/// touch the native `tray_manager` Menu/MenuItem types.
class TrayMenuEntry {
  /// Stable identifier matched in the click handler.
  final String key;

  /// Localized / display label.
  final String label;

  /// True for a horizontal separator. [label] is empty when separator.
  final bool isSeparator;

  /// Children for submenu entries (empty for plain items / separators).
  final List<TrayMenuEntry> children;

  const TrayMenuEntry({
    required this.key,
    required this.label,
    this.isSeparator = false,
    this.children = const [],
  });

  const TrayMenuEntry.separator()
    : key = '__separator__',
      label = '',
      isSeparator = true,
      children = const [];

  TrayMenuEntry.submenu({
    required this.key,
    required this.label,
    required this.children,
  }) : isSeparator = false;
}

/// Singleton service that owns the system tray icon and its menu.
///
/// Lifecycle:
///   - Call [init] once after `runApp`. It subscribes to the relevant
///     Riverpod providers and pushes updates into the tray.
///   - Call [dispose] before [WindowManager.destroy] on quit.
class TrayService with TrayListener {
  TrayService._();

  static final TrayService instance = TrayService._();

  /// Asset path for the default icon.
  static const String _defaultIconPath = 'assets/images/app_icon.png';

  /// Optional "active" icon used when at least one session is open.
  /// Falls back to the default + tooltip change if the asset is missing.
  static const String _activeIconPath = 'assets/images/app_icon_active.png';

  /// Tooltip shown when hovering the tray icon.
  static const String _baseTooltip = 'SSHVault — Zero-knowledge SSH client';

  /// Read from `--minimized` argv or `SSHVAULT_MINIMIZED=1` env var.
  /// Wired in `main.dart` before `runApp` so the first window state is
  /// determined before the tray service initializes.
  static bool startMinimized = false;

  bool _initialized = false;
  bool _disposed = false;

  /// Last computed menu — exposed for testing.
  List<TrayMenuEntry> _menuItems = const [];
  List<TrayMenuEntry> get menuItems => _menuItems;

  /// Cached window visibility used to decide whether the tray shows
  /// "Show window" or "Hide to tray". Refreshed at every menu rebuild.
  bool _windowVisible = false;

  ProviderContainer? _container;
  ProviderSubscription<List<SshSessionEntity>>? _sessionsSub;
  ProviderSubscription? _favoritesSub;
  ProviderSubscription? _settingsSub;

  /// Initialize the tray icon and start listening for state changes.
  ///
  /// Safe to call repeatedly — the second invocation is a no-op.
  /// Returns immediately on non-Linux.
  Future<void> init(ProviderContainer container) async {
    if (!Platform.isLinux) return;
    if (_initialized) return;

    final settings = container.read(settingsProvider).value;
    if (settings != null && !settings.showSystemTray) {
      LoggingService.instance.info(
        'Tray',
        'System tray disabled by user setting',
      );
      // Still subscribe to the setting so we can spin up later if toggled on.
      _container = container;
      _watchSettings();
      return;
    }

    await _bootstrap(container);
  }

  /// Internal: actually create the tray icon and wire listeners.
  Future<void> _bootstrap(ProviderContainer container) async {
    _container = container;
    try {
      await trayManager.setIcon(_defaultIconPath);
      await trayManager.setToolTip(_baseTooltip);
      trayManager.addListener(this);

      _watchFavorites();
      _watchSessions();
      _watchSettings();

      await _rebuildMenu();
      _initialized = true;
      LoggingService.instance.info('Tray', 'System tray icon installed');
    } catch (e) {
      // libayatana-appindicator may not be present (e.g. headless test
      // runner). Fail soft so the app keeps working.
      LoggingService.instance.warning(
        'Tray',
        'Failed to initialize system tray: $e',
      );
    }
  }

  /// Tear down listeners and remove the tray icon.
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _sessionsSub?.close();
    _favoritesSub?.close();
    _settingsSub?.close();
    if (Platform.isLinux && _initialized) {
      try {
        trayManager.removeListener(this);
        await trayManager.destroy();
      } catch (_) {
        // best-effort
      }
    }
  }

  // ---------------------------------------------------------------------
  // Provider subscriptions
  // ---------------------------------------------------------------------

  void _watchFavorites() {
    _favoritesSub = _container!.listen(
      favoriteServersProvider,
      (_, _) => _rebuildMenu(),
      fireImmediately: false,
    );
  }

  void _watchSessions() {
    _sessionsSub = _container!.listen<List<SshSessionEntity>>(
      sessionManagerProvider,
      (_, sessions) async {
        await _rebuildMenu();
        await _refreshIconForSessions(sessions);
      },
      fireImmediately: false,
    );
  }

  void _watchSettings() {
    _settingsSub = _container!.listen(settingsProvider, (prev, next) async {
      final wasEnabled = prev?.value?.showSystemTray ?? true;
      final isEnabled = next.value?.showSystemTray ?? true;
      if (wasEnabled == isEnabled) return;
      if (isEnabled && !_initialized) {
        await _bootstrap(_container!);
      } else if (!isEnabled && _initialized) {
        await dispose();
        // Allow a future re-enable to recreate the icon.
        _disposed = false;
        _initialized = false;
      }
    });
  }

  Future<void> _refreshIconForSessions(List<SshSessionEntity> sessions) async {
    if (!Platform.isLinux || !_initialized) return;
    final activeCount = sessions
        .where((s) => s.status == SshConnectionStatus.connected)
        .length;
    try {
      // Try the dedicated "active" icon, otherwise just update the tooltip.
      if (activeCount > 0 && await _activeIconExists()) {
        await trayManager.setIcon(_activeIconPath);
      } else {
        await trayManager.setIcon(_defaultIconPath);
      }
      await trayManager.setToolTip(
        activeCount == 0 ? _baseTooltip : '$_baseTooltip ($activeCount active)',
      );
    } catch (_) {
      // ignore — tray may have been destroyed
    }
  }

  Future<bool> _activeIconExists() async {
    // We can't probe Flutter assets from disk reliably, so attempt to set
    // the icon and let `tray_manager` raise on missing assets. To avoid the
    // exception flicker during normal operation we cache the result.
    if (_activeIconCached != null) return _activeIconCached!;
    try {
      await trayManager.setIcon(_activeIconPath);
      _activeIconCached = true;
    } catch (_) {
      _activeIconCached = false;
    }
    return _activeIconCached!;
  }

  bool? _activeIconCached;

  // ---------------------------------------------------------------------
  // Menu construction
  // ---------------------------------------------------------------------

  /// Build the in-memory menu description from current providers and push
  /// it into the native tray. Public for testability via [computeMenu].
  Future<void> _rebuildMenu() async {
    if (_container == null) return;
    final favorites =
        _container!.read(favoriteServersProvider).value ?? const [];
    final sessions = _container!.read(sessionManagerProvider);

    // Refresh the visibility cache so the menu shows the right toggle. If
    // the call fails (e.g. window_manager not yet ensured) we keep the
    // last known value — no point spamming logs with transient errors.
    if (Platform.isLinux) {
      try {
        _windowVisible = await windowManager.isVisible();
      } catch (_) {
        // ignore
      }
    }

    _menuItems = computeMenu(
      favorites: favorites,
      sessions: sessions,
      windowVisible: _windowVisible,
    );

    if (!Platform.isLinux || !_initialized) return;
    try {
      await trayManager.setContextMenu(_toNativeMenu(_menuItems));
    } catch (e) {
      LoggingService.instance.warning('Tray', 'Failed to set context menu: $e');
    }
  }

  /// Pure function producing the menu description from inputs.
  ///
  /// Exposed so tests can verify labels/order without having to mock the
  /// native tray. Same logic used by [_rebuildMenu].
  static List<TrayMenuEntry> computeMenu({
    required List<ServerEntity> favorites,
    required List<SshSessionEntity> sessions,
    bool windowVisible = false,
  }) {
    final items = <TrayMenuEntry>[
      // The first entry is contextual: "Show window" surfaces the window
      // (also used by the headless boot mode to flip out of tray-only),
      // "Hide to tray" hides it without quitting. We keep both entries on
      // the same key prefix family so external callers can match either.
      if (windowVisible)
        const TrayMenuEntry(key: 'hide_to_tray', label: 'Hide to tray')
      else
        const TrayMenuEntry(key: 'show_window', label: 'Show window'),
      const TrayMenuEntry.separator(),
      TrayMenuEntry.submenu(
        key: 'favorites',
        label: 'Connect to favorite',
        children: favorites.isEmpty
            ? const [
                TrayMenuEntry(key: 'favorites_empty', label: '(no favorites)'),
              ]
            : [
                for (final s in favorites)
                  TrayMenuEntry(
                    key: 'favorite:${s.id}',
                    label: s.name.isEmpty ? s.hostname : s.name,
                  ),
              ],
      ),
      TrayMenuEntry.submenu(
        key: 'sessions',
        label: 'Active sessions',
        children: sessions.isEmpty
            ? const [
                TrayMenuEntry(
                  key: 'sessions_empty',
                  label: '(no active sessions)',
                ),
              ]
            : [
                for (var i = 0; i < sessions.length; i++)
                  TrayMenuEntry(key: 'session:$i', label: sessions[i].title),
              ],
      ),
      const TrayMenuEntry.separator(),
      const TrayMenuEntry(key: 'settings', label: 'Settings'),
      const TrayMenuEntry(key: 'quit', label: 'Quit'),
    ];
    return items;
  }

  Menu _toNativeMenu(List<TrayMenuEntry> entries) {
    return Menu(items: entries.map(_toNativeItem).toList());
  }

  MenuItem _toNativeItem(TrayMenuEntry entry) {
    if (entry.isSeparator) return MenuItem.separator();
    if (entry.children.isNotEmpty) {
      return MenuItem.submenu(
        key: entry.key,
        label: entry.label,
        submenu: _toNativeMenu(entry.children),
      );
    }
    return MenuItem(key: entry.key, label: entry.label);
  }

  // ---------------------------------------------------------------------
  // TrayListener — click handling
  // ---------------------------------------------------------------------

  @override
  void onTrayIconMouseDown() {
    // Left click: toggle show/hide of the main window.
    _toggleWindow();
  }

  @override
  void onTrayIconRightMouseDown() {
    // Right click: show menu (handled natively by tray_manager when
    // a context menu is set, but we forward just in case).
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    final key = menuItem.key ?? '';
    if (key == 'show_window') {
      _showWindow();
      return;
    }
    if (key == 'hide_to_tray') {
      _hideWindow();
      return;
    }
    if (key == 'settings') {
      _showWindow();
      _navigate('/settings');
      return;
    }
    if (key == 'quit') {
      _quit();
      return;
    }
    if (key.startsWith('favorite:')) {
      final id = key.substring('favorite:'.length);
      _connectFavorite(id);
      return;
    }
    if (key.startsWith('session:')) {
      final idx = int.tryParse(key.substring('session:'.length));
      if (idx != null) _focusSession(idx);
      return;
    }
  }

  // ---------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------

  Future<void> _showWindow() async {
    if (!Platform.isLinux) return;
    try {
      await windowManager.show();
      await windowManager.focus();
      // Once the user surfaces the window we leave headless boot mode so
      // any deferred dialogs (first-run security warning, onboarding) are
      // free to show on the next frame.
      HeadlessBootService.instance.markWindowSurfaced();
      _windowVisible = true;
      await _rebuildMenu();
    } catch (_) {
      // window_manager not yet ensured (e.g. headless test) — ignore.
    }
  }

  Future<void> _hideWindow() async {
    if (!Platform.isLinux) return;
    try {
      await windowManager.hide();
      _windowVisible = false;
      await _rebuildMenu();
    } catch (_) {
      // ignore
    }
  }

  Future<void> _toggleWindow() async {
    if (!Platform.isLinux) return;
    try {
      final visible = await windowManager.isVisible();
      if (visible) {
        await _hideWindow();
      } else {
        await _showWindow();
      }
    } catch (_) {
      // ignore
    }
  }

  void _navigate(String path) {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null) return;
    try {
      ctx.go(path);
    } catch (_) {
      // Router not ready — ignore.
    }
  }

  Future<void> _connectFavorite(String serverId) async {
    if (_container == null) return;
    await _showWindow();
    try {
      await _container!
          .read(sessionManagerProvider.notifier)
          .openSession(serverId);
      _navigate('/');
    } catch (e) {
      LoggingService.instance.warning(
        'Tray',
        'Failed to open favorite $serverId: $e',
      );
    }
  }

  void _focusSession(int index) {
    if (_container == null) return;
    final sessions = _container!.read(sessionManagerProvider);
    if (index < 0 || index >= sessions.length) return;
    _container!.read(activeSessionIndexProvider.notifier).state = index;
    _showWindow();
    _navigate('/');
  }

  Future<void> _quit() async {
    if (_container == null) return;
    try {
      _container!.read(sessionManagerProvider.notifier).closeAllSessions();
    } catch (_) {
      // ignore
    }
    await dispose();
    try {
      await windowManager.destroy();
    } catch (_) {
      // ignore
    }
    // As a last resort.
    exit(0);
  }
}
