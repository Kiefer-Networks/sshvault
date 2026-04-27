// Windows-only "native chrome" integration:
//   * Mica backdrop (Win11) with Acrylic fallback (Win10).
//   * Dark-mode title bar, toggled in lock-step with the app theme.
//   * Rounded window corners (Win11).
//
// Linux / macOS callers: every public entry point short-circuits via
// `Platform.isWindows`, so importing this service is harmless on those
// platforms (no flutter_acrylic init traffic, no FFI lookups).
//
// The service is intentionally NOT a Riverpod provider: it has to run
// before `runApp` (so the very first frame already has Mica + the dark
// title bar), and it owns process-global window state. Callers wire it
// from `main.dart` and from a `ref.listenManual(settingsProvider, ...)`
// inside `SSHVaultApp`.

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/widgets.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';

import 'package:sshvault/core/ffi/win32_dwm.dart';
import 'package:sshvault/core/services/logging_service.dart';

/// Backdrop the user requested. Resolved against the running OS at apply
/// time — Win10 falls back from Mica → Acrylic → solid; Win11 honors
/// whatever was selected.
enum WindowsBackdrop {
  /// Default. Mica on Win11, Acrylic on Win10, solid below.
  mica,

  /// Force Acrylic regardless of OS. Useful if the user dislikes the
  /// near-opaque Mica wallpaper tint.
  acrylic,

  /// Disable both effects — solid scaffold surface from the theme.
  none,
}

/// User preferences mirrored from `AppSettingsEntity`. Pure data; the
/// service applies it idempotently so settings changes can re-call
/// `applyChrome` cheaply.
class WindowsChromeOptions {
  final WindowsBackdrop backdrop;
  final bool roundedCorners;
  final bool darkTheme;

  const WindowsChromeOptions({
    this.backdrop = WindowsBackdrop.mica,
    this.roundedCorners = true,
    this.darkTheme = false,
  });

  WindowsChromeOptions copyWith({
    WindowsBackdrop? backdrop,
    bool? roundedCorners,
    bool? darkTheme,
  }) => WindowsChromeOptions(
    backdrop: backdrop ?? this.backdrop,
    roundedCorners: roundedCorners ?? this.roundedCorners,
    darkTheme: darkTheme ?? this.darkTheme,
  );
}

/// Singleton service. `applyChrome` is safe to call repeatedly; each call
/// reconciles the requested options with the live window state.
class WindowsChromeService {
  static const _tag = 'WindowsChrome';

  WindowsChromeService._();
  static final WindowsChromeService _instance = WindowsChromeService._();
  static WindowsChromeService get instance => _instance;

  /// Override hooks for tests. The production path leaves these `null` and
  /// goes through [DwmApi.load] / `Window.initialize`.
  @visibleForTesting
  DwmApiOverride? dwmOverride;

  @visibleForTesting
  Future<void> Function()? acrylicInitializeOverride;

  @visibleForTesting
  Future<void> Function(WindowEffect effect, {required bool dark})?
  setEffectOverride;

  bool _acrylicInitialized = false;
  WindowsChromeOptions _last = const WindowsChromeOptions();

  /// Returns the most recently applied options. Used by tests.
  @visibleForTesting
  WindowsChromeOptions get lastApplied => _last;

  /// Resets internal state. Test-only.
  @visibleForTesting
  void resetForTest() {
    _acrylicInitialized = false;
    _last = const WindowsChromeOptions();
    dwmOverride = null;
    acrylicInitializeOverride = null;
    setEffectOverride = null;
  }

  /// Applies [options] to the live window. No-op on non-Windows. Idempotent.
  Future<void> applyChrome(WindowsChromeOptions options) async {
    if (!Platform.isWindows) return;
    final log = LoggingService.instance;

    // 1) flutter_acrylic backdrop. We always (re-)call setEffect on every
    //    applyChrome so the dark flag tracks the live theme.
    try {
      if (!_acrylicInitialized) {
        await (acrylicInitializeOverride ?? Window.initialize)();
        _acrylicInitialized = true;
      }
      final effect = _resolveEffect(options.backdrop);
      final setter =
          setEffectOverride ??
          (WindowEffect e, {required bool dark}) =>
              Window.setEffect(effect: e, dark: dark);
      await setter(effect, dark: options.darkTheme);
    } catch (e) {
      // Non-fatal — the app still renders on the solid theme surface.
      log.warning(_tag, 'flutter_acrylic setEffect failed: $e');
    }

    // 2) DWM-direct calls (dark title bar + rounded corners). Resolved on
    //    demand so tests can inject a recording fake.
    final dwm = dwmOverride ?? _loadProductionDwm();
    if (dwm == null) {
      log.warning(_tag, 'dwmapi.dll unavailable; skipping DWM chrome');
      _last = options;
      return;
    }

    final hwnd = dwm.findFlutterRunnerHwnd();
    if (hwnd == 0) {
      log.warning(_tag, 'FindWindowW returned NULL; runner HWND missing');
      _last = options;
      return;
    }

    // Dark title bar. Try the modern attribute first; fall back to the
    // legacy id (19) on E_INVALIDARG which older Win10 1809 builds need.
    final hr = dwm.setBoolAttribute(
      hwnd: hwnd,
      attribute: DwmAttribute.useImmersiveDarkMode,
      value: options.darkTheme,
    );
    if (hr != 0) {
      dwm.setBoolAttribute(
        hwnd: hwnd,
        attribute: DwmAttribute.useImmersiveDarkModeLegacy,
        value: options.darkTheme,
      );
    }

    // Rounded corners (Win11 only). On Win10 the call returns
    // E_INVALIDARG and we silently swallow it — no harm done.
    final corner = options.roundedCorners
        ? DwmCornerPreference.round
        : DwmCornerPreference.doNotRound;
    dwm.setIntAttribute(
      hwnd: hwnd,
      attribute: DwmAttribute.windowCornerPreference,
      value: corner,
    );

    _last = options;
  }

  DwmApiOverride? _loadProductionDwm() {
    final api = DwmApi.load();
    if (api == null) return null;
    return DwmApiAdapter(api);
  }

  WindowEffect _resolveEffect(WindowsBackdrop backdrop) {
    return switch (backdrop) {
      WindowsBackdrop.mica => WindowEffect.mica,
      WindowsBackdrop.acrylic => WindowEffect.acrylic,
      WindowsBackdrop.none => WindowEffect.disabled,
    };
  }
}
