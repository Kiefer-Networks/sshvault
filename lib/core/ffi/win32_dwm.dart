// Direct Win32 DWM API bindings for the bits flutter_acrylic doesn't cover:
//   * Dark-mode title bar  (DWMWA_USE_IMMERSIVE_DARK_MODE)
//   * Win11 rounded corners (DWMWA_WINDOW_CORNER_PREFERENCE)
//
// Resolution and HWND lookup go through dwmapi.dll / user32.dll directly via
// `dart:ffi`. We avoid pulling in `package:win32` to keep this layer tiny
// and to make unit tests cheap (just stub `setWindowAttribute`).
//
// All calls no-op on non-Windows platforms — the Linux / macOS runners
// never load `dwmapi.dll`, so `DwmApi.instance` returns `null` there and
// the chrome service short-circuits before any FFI traffic.

import 'dart:ffi';
import 'dart:io' show Platform;

import 'package:ffi/ffi.dart';

/// Documented attribute IDs from `<dwmapi.h>`. We declare only the ones we
/// actually use so the surface stays auditable.
abstract final class DwmAttribute {
  /// `DWMWA_USE_IMMERSIVE_DARK_MODE` — enables dark mode for the non-client
  /// area (title bar, frame). Available since Windows 10 build 17763 (1809);
  /// some early builds use the value 19 instead of 20. We try 20 first and
  /// fall back to 19 on E_INVALIDARG to cover both cases.
  static const int useImmersiveDarkMode = 20;
  static const int useImmersiveDarkModeLegacy = 19;

  /// `DWMWA_WINDOW_CORNER_PREFERENCE` — Win11 only. Values are
  /// `DWMWCP_*` from the corner preference enum.
  static const int windowCornerPreference = 33;
}

/// Values for `DWMWA_WINDOW_CORNER_PREFERENCE`.
abstract final class DwmCornerPreference {
  static const int defaultPref = 0; // DWMWCP_DEFAULT
  static const int doNotRound = 1; // DWMWCP_DONOTROUND
  static const int round = 2; // DWMWCP_ROUND
  static const int roundSmall = 3; // DWMWCP_ROUNDSMALL
}

// ----- Native function typedefs -----

typedef _DwmSetWindowAttributeNative =
    Int32 Function(
      IntPtr hwnd,
      Uint32 dwAttribute,
      Pointer<Void> pvAttribute,
      Uint32 cbAttribute,
    );

typedef _DwmSetWindowAttributeDart =
    int Function(
      int hwnd,
      int dwAttribute,
      Pointer<Void> pvAttribute,
      int cbAttribute,
    );

typedef _FindWindowWNative =
    IntPtr Function(Pointer<Utf16> lpClassName, Pointer<Utf16> lpWindowName);

typedef _FindWindowWDart =
    int Function(Pointer<Utf16> lpClassName, Pointer<Utf16> lpWindowName);

/// Thin wrapper around `dwmapi.dll` + `user32.dll`. Only loaded on Windows.
///
/// The class is open for subclassing in tests — see [DwmApiOverride] which
/// the [WindowsChromeService] consumes so unit tests can record the
/// `(attribute, value)` pairs we hand to the OS without spinning up an FFI
/// shim or a real Win32 process.
class DwmApi {
  final _DwmSetWindowAttributeDart _dwmSetWindowAttribute;
  final _FindWindowWDart _findWindow;

  DwmApi._(this._dwmSetWindowAttribute, this._findWindow);

  /// Returns a singleton bound to the live `dwmapi.dll` / `user32.dll`,
  /// or `null` on non-Windows platforms (where those DLLs do not exist).
  static DwmApi? _cached;
  static DwmApi? load() {
    if (!Platform.isWindows) return null;
    final existing = _cached;
    if (existing != null) return existing;
    try {
      final dwm = DynamicLibrary.open('dwmapi.dll');
      final user32 = DynamicLibrary.open('user32.dll');
      final fn = dwm
          .lookupFunction<
            _DwmSetWindowAttributeNative,
            _DwmSetWindowAttributeDart
          >('DwmSetWindowAttribute');
      final find = user32.lookupFunction<_FindWindowWNative, _FindWindowWDart>(
        'FindWindowW',
      );
      return _cached = DwmApi._(fn, find);
    } catch (_) {
      return null;
    }
  }

  /// Sets a `BOOL` (4-byte) DWM attribute on [hwnd]. Mirrors
  /// `DwmSetWindowAttribute(hwnd, attr, &BOOL, 4)`.
  ///
  /// Returns the raw HRESULT. `0` is `S_OK`; non-zero values surface to the
  /// caller so they can fall back (e.g. immersive-dark-mode 20 → 19).
  int setBoolAttribute({
    required int hwnd,
    required int attribute,
    required bool value,
  }) {
    final ptr = calloc<Int32>();
    try {
      ptr.value = value ? 1 : 0;
      return _dwmSetWindowAttribute(hwnd, attribute, ptr.cast(), 4);
    } finally {
      calloc.free(ptr);
    }
  }

  /// Sets a 4-byte `DWORD` DWM attribute on [hwnd]. Used for
  /// `DWMWA_WINDOW_CORNER_PREFERENCE`.
  int setIntAttribute({
    required int hwnd,
    required int attribute,
    required int value,
  }) {
    final ptr = calloc<Uint32>();
    try {
      ptr.value = value;
      return _dwmSetWindowAttribute(hwnd, attribute, ptr.cast(), 4);
    } finally {
      calloc.free(ptr);
    }
  }

  /// Looks up the Flutter runner's top-level window. Class name is hard-coded
  /// in the Flutter Windows runner template; window name is `null` so the
  /// first window with that class wins (we only ever spawn one).
  int findFlutterRunnerHwnd() {
    final cls = 'FLUTTER_RUNNER_WIN32_WINDOW'.toNativeUtf16();
    try {
      return _findWindow(cls, nullptr);
    } finally {
      calloc.free(cls);
    }
  }
}

/// Test seam — let `WindowsChromeService` swap in a recording fake without
/// touching the real DLLs. Implementations only need to record the calls;
/// the production path uses [DwmApi] directly.
abstract class DwmApiOverride {
  int setBoolAttribute({
    required int hwnd,
    required int attribute,
    required bool value,
  });

  int setIntAttribute({
    required int hwnd,
    required int attribute,
    required int value,
  });

  int findFlutterRunnerHwnd();
}

/// Adapter so [DwmApi] satisfies [DwmApiOverride]. Keeps the production
/// call-site type-safe without requiring the FFI class to declare the
/// abstract `implements` (which would force `package:ffi` into tests).
class DwmApiAdapter implements DwmApiOverride {
  final DwmApi _api;
  const DwmApiAdapter(this._api);

  @override
  int setBoolAttribute({
    required int hwnd,
    required int attribute,
    required bool value,
  }) => _api.setBoolAttribute(hwnd: hwnd, attribute: attribute, value: value);

  @override
  int setIntAttribute({
    required int hwnd,
    required int attribute,
    required int value,
  }) => _api.setIntAttribute(hwnd: hwnd, attribute: attribute, value: value);

  @override
  int findFlutterRunnerHwnd() => _api.findFlutterRunnerHwnd();
}
