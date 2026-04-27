/// Persists and restores the desktop window's geometry (size, position,
/// maximized state) across launches on Linux, Windows, and macOS.
///
/// Wiring:
///   1. `WindowStateService.instance.restore()` is called from `main.dart`
///      AFTER `windowManager.ensureInitialized()` and BEFORE
///      `windowManager.show()` so we can apply the saved size / position
///      without a visible flash.
///   2. After restore, `attachListeners()` registers a `WindowListener`
///      whose callbacks (`onWindowResize` / `onWindowMove` /
///      `onWindowMaximize` / `onWindowUnmaximize`) push the latest geometry
///      into a 500 ms debounced write to the existing settings DAO.
///
/// Design notes:
///   - The service is a no-op on non-desktop platforms. Callers should
///     also guard at the call site (`if (Platform.isLinux ...)`) so the
///     `window_manager` plugin channel is never invoked on web/mobile.
///   - We intentionally only depend on `window_manager` (already a direct
///     dep). `screen_retriever` is available transitively but reaching for
///     it from here would broaden the import graph; the spec lists it as
///     "if available; otherwise just store size+position (sane fallback)"
///     and the fallback is what we ship.
///   - All persistence goes through an injected pair of reader/writer
///     adapters (typedefs `SettingsReader` / `SettingsWriter`) so unit
///     tests can drive the service without a real database.
///   - All `windowManager.*` calls are routed through a `WindowController`
///     interface; production wires the global `windowManager` singleton
///     while tests substitute a fake.
library;

import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show Offset, Size;
import 'package:window_manager/window_manager.dart';

import 'package:sshvault/core/services/logging_service.dart';

/// Settings keys used for window-state persistence.
///
/// Exposed as constants so the [SettingsNotifier] (and tests) can reuse the
/// exact same names without copy-paste drift.
class WindowStateKeys {
  static const String width = 'window_width';
  static const String height = 'window_height';
  static const String x = 'window_x';
  static const String y = 'window_y';
  static const String maximized = 'window_maximized';
  static const String monitor = 'window_monitor_id';

  const WindowStateKeys._();
}

/// Sane defaults applied on first launch / when no saved geometry exists.
class WindowStateDefaults {
  static const double width = 1280;
  static const double height = 800;

  /// Minimum window size we will ever set. Anything smaller is treated as
  /// corrupted state and clamped up.
  static const double minWidth = 480;
  static const double minHeight = 320;

  /// Maximum sane window size (defensive clamp against absurd saved values).
  static const double maxWidth = 16384;
  static const double maxHeight = 16384;

  const WindowStateDefaults._();
}

/// Plain immutable record describing what we persist between launches.
@immutable
class WindowState {
  final double width;
  final double height;
  final double? x;
  final double? y;
  final bool maximized;
  final String? monitorId;

  const WindowState({
    required this.width,
    required this.height,
    required this.maximized,
    this.x,
    this.y,
    this.monitorId,
  });

  /// Default state used when nothing is saved yet.
  const WindowState.defaults()
    : width = WindowStateDefaults.width,
      height = WindowStateDefaults.height,
      x = null,
      y = null,
      maximized = false,
      monitorId = null;

  WindowState copyWith({
    double? width,
    double? height,
    double? x,
    double? y,
    bool? maximized,
    String? monitorId,
    bool clearPosition = false,
  }) {
    return WindowState(
      width: width ?? this.width,
      height: height ?? this.height,
      x: clearPosition ? null : (x ?? this.x),
      y: clearPosition ? null : (y ?? this.y),
      maximized: maximized ?? this.maximized,
      monitorId: monitorId ?? this.monitorId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WindowState &&
          other.width == width &&
          other.height == height &&
          other.x == x &&
          other.y == y &&
          other.maximized == maximized &&
          other.monitorId == monitorId;

  @override
  int get hashCode => Object.hash(width, height, x, y, maximized, monitorId);

  @override
  String toString() =>
      'WindowState(${width.toStringAsFixed(0)}x${height.toStringAsFixed(0)} '
      '@ ${x?.toStringAsFixed(0) ?? '-'},${y?.toStringAsFixed(0) ?? '-'} '
      'max=$maximized mon=${monitorId ?? '-'})';
}

/// Thin abstraction over `windowManager` so unit tests can substitute a fake.
abstract class WindowController {
  Future<Size> getSize();
  Future<Offset> getPosition();
  Future<bool> isMaximized();
  Future<void> setSize(Size size);
  Future<void> setPosition(Offset position);
  Future<void> maximize();
  Future<void> unmaximize();
  void addListener(WindowListener listener);
  void removeListener(WindowListener listener);
}

/// Production adapter that defers to the real [windowManager] singleton.
class _RealWindowController implements WindowController {
  const _RealWindowController();

  @override
  Future<Size> getSize() => windowManager.getSize();

  @override
  Future<Offset> getPosition() => windowManager.getPosition();

  @override
  Future<bool> isMaximized() => windowManager.isMaximized();

  @override
  Future<void> setSize(Size size) => windowManager.setSize(size);

  @override
  Future<void> setPosition(Offset position) =>
      windowManager.setPosition(position);

  @override
  Future<void> maximize() => windowManager.maximize();

  @override
  Future<void> unmaximize() => windowManager.unmaximize();

  @override
  void addListener(WindowListener listener) =>
      windowManager.addListener(listener);

  @override
  void removeListener(WindowListener listener) =>
      windowManager.removeListener(listener);
}

/// Storage adapter — kept as a pair of function pointers so tests can swap
/// in an in-memory map without dragging a real Drift DAO into the suite.
typedef SettingsReader = Future<String?> Function(String key);
typedef SettingsWriter = Future<void> Function(String key, String value);

/// Coordinates window-state save/restore.
///
/// Singleton via [instance] so the tray service / shutdown hooks can reach
/// it without plumbing it through Riverpod. Tests construct their own
/// instances directly via the public constructor.
class WindowStateService with WindowListener {
  /// The default singleton wired into `main.dart`.
  static final WindowStateService instance = WindowStateService._default();

  WindowStateService._default()
    : _controller = const _RealWindowController(),
      _debounce = const Duration(milliseconds: 500),
      _logTag = 'WindowState';

  /// Public test constructor.
  @visibleForTesting
  WindowStateService.forTest({
    required WindowController controller,
    required SettingsReader read,
    required SettingsWriter write,
    Duration debounce = const Duration(milliseconds: 500),
  }) : _controller = controller,
       _debounce = debounce,
       _logTag = 'WindowState' {
    _read = read;
    _write = write;
  }

  final WindowController _controller;
  final Duration _debounce;
  final String _logTag;

  SettingsReader? _read;
  SettingsWriter? _write;

  Timer? _debounceTimer;
  WindowState _pending = const WindowState.defaults();
  bool _attached = false;
  bool _restored = false;

  /// True on a host OS where we should actually touch the window manager.
  /// Mobile / web fall through to a no-op.
  static bool get isSupportedPlatform {
    if (kIsWeb) return false;
    return Platform.isLinux || Platform.isWindows || Platform.isMacOS;
  }

  /// Wires the storage adapters. Call before [restore].
  void bindStorage({
    required SettingsReader read,
    required SettingsWriter write,
  }) {
    _read = read;
    _write = write;
  }

  /// Reads saved geometry (if any) and applies it to the window before it
  /// is shown. Safe to call multiple times — subsequent calls are no-ops.
  ///
  /// Returns the [WindowState] that was applied (the default state if
  /// nothing was saved or persistence is unbound).
  Future<WindowState> restore() async {
    if (!isSupportedPlatform) return const WindowState.defaults();
    if (_restored) return _pending;
    _restored = true;

    final saved = await _readState();
    final clamped = clampForApply(saved);

    try {
      await _controller.setSize(Size(clamped.width, clamped.height));
      if (clamped.x != null && clamped.y != null) {
        await _controller.setPosition(Offset(clamped.x!, clamped.y!));
      }
      if (clamped.maximized) {
        await _controller.maximize();
      }
    } catch (e, st) {
      LoggingService.instance.warning(
        _logTag,
        'Failed to apply saved window state: $e\n$st',
      );
    }

    _pending = clamped;
    return clamped;
  }

  /// Subscribes to window-manager events so subsequent resize / move /
  /// (un)maximize push debounced writes.
  void attachListeners() {
    if (!isSupportedPlatform) return;
    if (_attached) return;
    _controller.addListener(this);
    _attached = true;
  }

  /// Releases the listener and flushes any pending write. Call from the
  /// shutdown path so the final geometry survives.
  Future<void> dispose() async {
    if (_attached) {
      _controller.removeListener(this);
      _attached = false;
    }
    final timer = _debounceTimer;
    _debounceTimer = null;
    if (timer != null && timer.isActive) {
      timer.cancel();
      await _flush();
    }
  }

  // -------- WindowListener overrides --------

  @override
  void onWindowResize() {
    unawaited(_capture());
  }

  @override
  void onWindowMove() {
    unawaited(_capture());
  }

  @override
  void onWindowMaximize() {
    _pending = _pending.copyWith(maximized: true);
    _scheduleWrite();
  }

  @override
  void onWindowUnmaximize() {
    _pending = _pending.copyWith(maximized: false);
    _scheduleWrite();
  }

  // -------- internal --------

  Future<void> _capture() async {
    try {
      final maximized = await _controller.isMaximized();
      if (maximized) {
        // While maximized the size/position reported by the OS is the
        // maximized geometry, not the user's preferred restore size.
        // Skip — `onWindowMaximize` already recorded the state flip.
        _pending = _pending.copyWith(maximized: true);
      } else {
        final size = await _controller.getSize();
        final pos = await _controller.getPosition();
        _pending = _pending.copyWith(
          width: size.width,
          height: size.height,
          x: pos.dx,
          y: pos.dy,
          maximized: false,
        );
      }
      _scheduleWrite();
    } catch (e) {
      LoggingService.instance.warning(_logTag, 'Capture failed: $e');
    }
  }

  void _scheduleWrite() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounce, () {
      unawaited(_flush());
    });
  }

  Future<void> _flush() async {
    final write = _write;
    if (write == null) return;
    final s = clampForPersist(_pending);
    try {
      await write(WindowStateKeys.width, s.width.toStringAsFixed(0));
      await write(WindowStateKeys.height, s.height.toStringAsFixed(0));
      if (s.x != null) {
        await write(WindowStateKeys.x, s.x!.toStringAsFixed(0));
      }
      if (s.y != null) {
        await write(WindowStateKeys.y, s.y!.toStringAsFixed(0));
      }
      await write(WindowStateKeys.maximized, s.maximized.toString());
      if (s.monitorId != null) {
        await write(WindowStateKeys.monitor, s.monitorId!);
      }
    } catch (e) {
      LoggingService.instance.warning(_logTag, 'Persist failed: $e');
    }
  }

  Future<WindowState> _readState() async {
    final read = _read;
    if (read == null) return const WindowState.defaults();
    try {
      final w = double.tryParse(await read(WindowStateKeys.width) ?? '');
      final h = double.tryParse(await read(WindowStateKeys.height) ?? '');
      final x = double.tryParse(await read(WindowStateKeys.x) ?? '');
      final y = double.tryParse(await read(WindowStateKeys.y) ?? '');
      final maxStr = await read(WindowStateKeys.maximized);
      final monitor = await read(WindowStateKeys.monitor);
      return WindowState(
        width: w ?? WindowStateDefaults.width,
        height: h ?? WindowStateDefaults.height,
        x: x,
        y: y,
        maximized: maxStr == 'true',
        monitorId: (monitor != null && monitor.isNotEmpty) ? monitor : null,
      );
    } catch (e) {
      LoggingService.instance.warning(
        _logTag,
        'Read failed, using defaults: $e',
      );
      return const WindowState.defaults();
    }
  }

  /// Clamps a state for application to the window: enforces min/max size
  /// and drops obviously off-screen positions. Visible for testing.
  ///
  /// Pure function — no I/O — so unit tests can verify edge cases without
  /// instantiating the service.
  @visibleForTesting
  static WindowState clampForApply(WindowState s) {
    final w = _clampDouble(
      s.width <= 0 ? WindowStateDefaults.width : s.width,
      WindowStateDefaults.minWidth,
      WindowStateDefaults.maxWidth,
    );
    final h = _clampDouble(
      s.height <= 0 ? WindowStateDefaults.height : s.height,
      WindowStateDefaults.minHeight,
      WindowStateDefaults.maxHeight,
    );

    double? x = s.x;
    double? y = s.y;
    // Off-screen heuristic: reject coordinates that are obviously bogus
    // (negative beyond -100, NaN, infinite, or larger than maxWidth/height).
    if (x == null ||
        y == null ||
        !x.isFinite ||
        !y.isFinite ||
        x < -100 ||
        y < -100 ||
        x > WindowStateDefaults.maxWidth ||
        y > WindowStateDefaults.maxHeight) {
      x = null;
      y = null;
    }
    return WindowState(
      width: w,
      height: h,
      x: x,
      y: y,
      maximized: s.maximized,
      monitorId: s.monitorId,
    );
  }

  /// Clamps a state for persistence (drops obviously bogus values rather
  /// than writing them out).
  @visibleForTesting
  static WindowState clampForPersist(WindowState s) => clampForApply(s);

  static double _clampDouble(double v, double lo, double hi) =>
      math.min(hi, math.max(lo, v));

  /// Test-only hook to peek at the buffered state.
  @visibleForTesting
  WindowState debugPendingState() => _pending;

  /// Test-only hook to seed the buffered state (skipping the listener path).
  @visibleForTesting
  void debugSetPending(WindowState s) => _pending = s;

  /// Test-only synchronous flush.
  @visibleForTesting
  Future<void> debugFlush() => _flush();
}
