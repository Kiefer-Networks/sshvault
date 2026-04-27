/// Cross-desktop autostart integration for SSHVault (Linux + Windows + macOS).
///
/// On **Linux**, writes an XDG `.desktop` file under `~/.config/autostart/`
/// so the user's session manager (GNOME, KDE, XFCE, Cinnamon, ...) launches
/// SSHVault at login. The launched instance starts minimized to the system
/// tray, so the user only sees the tray icon until they explicitly request
/// the window.
///
/// Reference: XDG Autostart Specification 0.5 — files in
/// `$XDG_CONFIG_HOME/autostart/` (default `~/.config/autostart/`) are
/// executed at session start unless they have `Hidden=true`.
///
/// Flatpak: Sandboxed apps cannot exec `/proc/self/exe` from the host, so
/// the desktop file must use `flatpak run de.kiefer_networks.sshvault`.
/// Detection is via `/.flatpak-info` existence inside the sandbox.
///
/// On **Windows**, writes a `REG_SZ` value under
/// `HKCU\Software\Microsoft\Windows\CurrentVersion\Run\SSHVault` whose data
/// is the quoted path to `sshvault.exe` followed by `--minimized`. The
/// HKCU hive is per-user and writable without admin privileges, matching
/// the installer's `PrivilegesRequired=lowest` policy.
///
/// TODO(msix): MSIX/UWP packaged installs cannot use the Run key — the
/// platform requires a `StartupTask` declared in `Package.appxmanifest`
/// and toggled via `Windows.ApplicationModel.StartupTask.requestEnableAsync`.
/// Detection would be via `Package.Current` reachability through WinRT
/// (e.g. `GetCurrentPackageId` in `kernel32.dll` returning success). For
/// the current Inno-Setup distribution we always use the Run-key fallback.
///
/// On **macOS**, dispatches to the native `LoginItemHelper` over the
/// `de.kiefer_networks.sshvault/login_item` MethodChannel. macOS 13+ uses
/// `SMAppService.mainApp` (the modern, sandbox-safe Login Items API);
/// older releases fall back to a launchd plist under
/// `~/Library/LaunchAgents/`. All transport happens through the platform
/// channel, so Dart never touches `ServiceManagement` directly.
///
/// All public methods throw [UnsupportedError] on platforms other than
/// Linux, Windows, and macOS.
library;

import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';

/// Reverse-DNS application id, must match the Flatpak app id and the
/// .desktop filename so desktop integration (icons, taskbar grouping)
/// stays consistent.
const String _appId = 'de.kiefer_networks.sshvault';

/// Filename written under `$XDG_CONFIG_HOME/autostart/`. Convention is
/// to use the app's reverse-DNS id.
const String _autostartFileName = '$_appId.desktop';

/// MethodChannel name shared with `macos/Runner/LoginItemHelper.swift`.
/// Exposed so tests (and the helper itself) can pin the wire format.
const String macosLoginItemChannelName =
    'de.kiefer_networks.sshvault/login_item';

/// Lazily-constructed channel handle. Held at top level rather than per
/// service instance so we don't recreate the binding on every method call.
const MethodChannel _macosLoginItemChannel = MethodChannel(
  macosLoginItemChannelName,
);

/// Service that manages the XDG autostart entry for SSHVault.
///
/// Usage:
/// ```dart
/// final svc = AutostartService();
/// if (await svc.isEnabled()) { ... }
/// await svc.enable();          // boots minimized
/// await svc.disable();         // hides the entry
/// ```
class AutostartService {
  /// Optional override for the home directory. Tests inject a temp dir
  /// here so they don't pollute the real `~/.config`.
  final String? homeOverride;

  /// Optional override for `XDG_CONFIG_HOME`. Honoured before falling
  /// back to `$HOME/.config`. Tests pass a temp dir here.
  final String? xdgConfigHomeOverride;

  /// When `true` (default), [disable] deletes the file. When `false`, it
  /// flips `Hidden=true` so any user edits to the desktop entry are
  /// preserved across enable/disable cycles.
  final bool deleteOnDisable;

  /// Optional override for the binary path used in `Exec=`. When `null`
  /// the service detects it from `/proc/self/exe` (Linux) or
  /// `Platform.resolvedExecutable`. Mostly useful for tests.
  final String? execOverride;

  /// Optional override for Flatpak detection. When `null` we probe the
  /// sandbox marker file `/.flatpak-info` (only present inside Flatpak).
  final bool? flatpakOverride;

  /// Optional in-memory registry stub used by Windows tests. When `null`
  /// the Windows backend dispatches to real `advapi32.dll` calls.
  final WindowsRegistryStub? _registryOverride;

  /// Optional override for the macOS Login Item channel. Tests inject a
  /// fake `MethodChannel` so they can assert on the exact method names
  /// without touching `SMAppService`.
  final MethodChannel? _macosChannelOverride;

  const AutostartService({
    this.homeOverride,
    this.xdgConfigHomeOverride,
    this.deleteOnDisable = true,
    this.execOverride,
    this.flatpakOverride,
    WindowsRegistryStub? registryOverride,
    MethodChannel? macosChannelOverride,
  }) : _registryOverride = registryOverride,
       _macosChannelOverride = macosChannelOverride;

  /// Returns `true` when an active autostart entry exists. An entry with
  /// `Hidden=true` counts as disabled even if the file is still on disk.
  ///
  /// On Windows, returns `true` when the `Run\SSHVault` registry value is
  /// present (any non-empty `REG_SZ` data).
  Future<bool> isEnabled() async {
    if (Platform.isWindows) {
      return _windows().isEnabled();
    }
    if (Platform.isMacOS) {
      return _macos().isEnabled();
    }
    _assertLinux();
    final file = File(_autostartPath());
    if (!await file.exists()) return false;
    final contents = await file.readAsString();
    return !_isHidden(contents);
  }

  /// Writes the `.desktop` file (Linux) or the Run-key value (Windows),
  /// idempotently. Existing entries are overwritten so toggling enable
  /// always produces a known-good entry pointing at the current binary.
  ///
  /// [minimized] controls whether `--minimized` is appended. Defaults to
  /// `true` so the wakeup is silent.
  Future<void> enable({bool minimized = true}) async {
    if (Platform.isWindows) {
      return _windows().enable(minimized: minimized);
    }
    if (Platform.isMacOS) {
      return _macos().enable();
    }
    _assertLinux();
    final dir = Directory(_autostartDir());
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final file = File(_autostartPath());
    final contents = buildDesktopFile(
      execLine: _resolveExecLine(minimized: minimized),
      flatpakAppId: _isFlatpak() ? _appId : null,
    );
    await file.writeAsString(contents, flush: true);
  }

  /// Turns off auto-start. By default the entry file is removed (Linux)
  /// or the registry value is deleted (Windows); pass
  /// [deleteOnDisable]=false at construction to instead set
  /// `Hidden=true` on Linux (preserves user edits like `OnlyShowIn`).
  /// The flag has no effect on Windows — there is no equivalent
  /// "soft-disable" semantics for the Run key.
  Future<void> disable() async {
    if (Platform.isWindows) {
      return _windows().disable();
    }
    if (Platform.isMacOS) {
      return _macos().disable();
    }
    _assertLinux();
    final file = File(_autostartPath());
    if (!await file.exists()) return;
    if (deleteOnDisable) {
      await file.delete();
      return;
    }
    final original = await file.readAsString();
    final patched = _setHidden(original, true);
    await file.writeAsString(patched, flush: true);
  }

  /// Builds the Windows backend lazily — keeps the constructor `const`
  /// and avoids loading `advapi32.dll` on Linux hosts where it doesn't
  /// exist anyway.
  _WindowsAutostartBackend _windows() => _WindowsAutostartBackend(
    execOverride: execOverride,
    registry: _registryOverride,
  );

  /// Builds the macOS backend. The default channel is a top-level `const`
  /// so we don't recreate it per call; tests pass a fake via
  /// `macosChannelOverride`.
  _MacosAutostartBackend _macos() => _MacosAutostartBackend(
    channel: _macosChannelOverride ?? _macosLoginItemChannel,
  );

  // ---------------------------------------------------------------------
  // Internals (some are exposed `@visibleForTesting`-style as static
  // top-level helpers for direct unit testing).
  // ---------------------------------------------------------------------

  String _autostartDir() {
    final xdg =
        xdgConfigHomeOverride ?? Platform.environment['XDG_CONFIG_HOME'];
    if (xdg != null && xdg.isNotEmpty) {
      return '$xdg/autostart';
    }
    final home = homeOverride ?? Platform.environment['HOME'] ?? '/tmp';
    return '$home/.config/autostart';
  }

  String _autostartPath() => '${_autostartDir()}/$_autostartFileName';

  /// Detects the host binary path. Order of preference:
  ///   1. [execOverride] (tests).
  ///   2. `/proc/self/exe` symlink target — works for native and Flutter
  ///      bundles even when launched via a wrapper.
  ///   3. [Platform.resolvedExecutable] as a last resort.
  String _detectBinary() {
    if (execOverride != null && execOverride!.isNotEmpty) {
      return execOverride!;
    }
    try {
      final link = Link('/proc/self/exe');
      if (link.existsSync()) {
        final target = link.targetSync();
        if (target.isNotEmpty) return target;
      }
    } catch (_) {
      // /proc may be unavailable in some sandboxes — fall through.
    }
    return Platform.resolvedExecutable;
  }

  String _resolveExecLine({required bool minimized}) {
    if (_isFlatpak()) {
      // Inside Flatpak, the host runs `flatpak run <app-id>` which the
      // Flatpak helper resolves to the sandboxed binary. Passing args
      // after the app id forwards them to the application.
      const base = 'flatpak run $_appId';
      return minimized ? '$base --minimized' : base;
    }
    final bin = _escapeExec(_detectBinary());
    return minimized ? '$bin --minimized' : bin;
  }

  bool _isFlatpak() {
    if (flatpakOverride != null) return flatpakOverride!;
    return File('/.flatpak-info').existsSync();
  }

  void _assertLinux() {
    if (!Platform.isLinux) {
      throw UnsupportedError(
        'AutostartService is only supported on Linux, Windows, and macOS',
      );
    }
  }
}

// ---------------------------------------------------------------------
// macOS backend.
//
// All work happens in the native helper (see
// `macos/Runner/LoginItemHelper.swift`). This class is just a thin
// MethodChannel proxy so platform branching stays inside the service and
// the public API remains a single class.
// ---------------------------------------------------------------------

/// Wraps the platform-channel calls to the native `LoginItemHelper`. Kept
/// internal so callers go through [AutostartService].
class _MacosAutostartBackend {
  _MacosAutostartBackend({required this.channel});

  final MethodChannel channel;

  /// Defensive cast — the native side returns `Bool`, but a stale plugin
  /// or a misconfigured fake could yield `null`; treat that as "off".
  Future<bool> isEnabled() async {
    final v = await channel.invokeMethod<bool>('isEnabled');
    return v ?? false;
  }

  /// `--minimized` semantics live in the launchd plist on the native
  /// side; the Dart layer simply asks for "on".
  Future<void> enable() async {
    await channel.invokeMethod<bool>('enable');
  }

  Future<void> disable() async {
    await channel.invokeMethod<bool>('disable');
  }
}

// ---------------------------------------------------------------------
// Windows backend.
//
// Stays in this file to keep the public surface (one class) intact and
// avoid a second import boundary for callers. Heavy lifting is split
// into a small protocol [WindowsRegistryStub] so unit tests can inject
// an in-memory map without spinning up FFI.
// ---------------------------------------------------------------------

/// Per-user Run-key path. Writing here does *not* require admin rights,
/// matching the installer's `PrivilegesRequired=lowest` guarantee.
const String windowsRunKeySubkey =
    r'Software\Microsoft\Windows\CurrentVersion\Run';

/// Value name we own under the Run key. Must be unique within HKCU\...\Run
/// — Windows keys values by name, not by data.
const String windowsRunValueName = 'SSHVault';

/// Test-only seam. Production code uses [_FfiWindowsRegistry]; tests pass
/// a [WindowsRegistryStub] backed by an in-memory map so we can assert on
/// the exact path and data without touching the host registry.
abstract class WindowsRegistryStub {
  /// Returns the `REG_SZ` data at `HKCU\<subkey>\<valueName>`, or `null`
  /// if either the key or the value is missing.
  String? readString({required String subkey, required String valueName});

  /// Writes a `REG_SZ` value, creating the key if necessary.
  void writeString({
    required String subkey,
    required String valueName,
    required String data,
  });

  /// Deletes `valueName` from the key. No-op when missing — mirrors
  /// `RegDeleteValueW` returning `ERROR_FILE_NOT_FOUND`, which we treat
  /// as success because the desired state ("absent") already holds.
  void deleteValue({required String subkey, required String valueName});
}

/// Wraps the platform-specific operations so [AutostartService] can stay
/// const-constructible and platform-agnostic at construction time.
class _WindowsAutostartBackend {
  _WindowsAutostartBackend({this.execOverride, WindowsRegistryStub? registry})
    : _registry = registry ?? _FfiWindowsRegistry();

  final String? execOverride;
  final WindowsRegistryStub _registry;

  Future<bool> isEnabled() async {
    final v = _registry.readString(
      subkey: windowsRunKeySubkey,
      valueName: windowsRunValueName,
    );
    return v != null && v.isNotEmpty;
  }

  Future<void> enable({required bool minimized}) async {
    final exe = execOverride ?? _detectWindowsBinary();
    final data = buildWindowsRunValue(exe: exe, minimized: minimized);
    _registry.writeString(
      subkey: windowsRunKeySubkey,
      valueName: windowsRunValueName,
      data: data,
    );
  }

  Future<void> disable() async {
    _registry.deleteValue(
      subkey: windowsRunKeySubkey,
      valueName: windowsRunValueName,
    );
  }
}

/// Builds the `REG_SZ` data we store under the Run key.
///
/// Output shape: `"C:\path\to\sshvault.exe" --minimized` (or without the
/// flag when [minimized] is `false`). The EXE path is **always** quoted —
/// `Program Files` (with a space) is the default install location and an
/// unquoted path would be misparsed by `CreateProcess`.
String buildWindowsRunValue({required String exe, required bool minimized}) {
  // Strip any pre-existing surrounding quotes so we always emit exactly
  // one quote pair around the path.
  var path = exe.trim();
  if (path.length >= 2 && path.startsWith('"') && path.endsWith('"')) {
    path = path.substring(1, path.length - 1);
  }
  final quoted = '"$path"';
  return minimized ? '$quoted --minimized' : quoted;
}

/// Resolves the absolute path of the running executable on Windows.
///
/// `/proc/self/exe` doesn't exist on Windows, so we call
/// `GetModuleFileNameW(NULL, ...)` from `kernel32.dll` to obtain the full
/// path of the EXE that hosts the current process. Falls back to
/// [Platform.resolvedExecutable] if FFI fails (shouldn't happen on real
/// Windows, but keeps tests/headless hosts well-behaved).
String _detectWindowsBinary() {
  try {
    return getModuleFileName();
  } catch (_) {
    return Platform.resolvedExecutable;
  }
}

// ---------------------------------------------------------------------
// FFI glue. All Win32 wide-string APIs use UTF-16 LE; we use
// `package:ffi`'s `Utf16` helpers so we don't have to hand-roll
// surrogate handling.
// ---------------------------------------------------------------------

// HKCU = 0x80000001. Cast lazily because Dart's `int` is 64-bit but the
// Win32 HKEY type is a 32-bit handle on Win32 / 64-bit on Win64; passing
// as `IntPtr` covers both.
const int _hkeyCurrentUser = 0x80000001;

// Access rights for the Run key. KEY_WRITE | KEY_READ is what the docs
// recommend for most user-level registry interactions.
const int _keyRead = 0x20019;
const int _keyWrite = 0x20006;
const int _keyAllAccess = _keyRead | _keyWrite;

// REG_SZ = null-terminated wide string.
const int _regSz = 1;

// Standard Win32 status codes we care about.
const int _errorSuccess = 0;
const int _errorFileNotFound = 2;

// Maximum path length we ever expect from GetModuleFileName. Win32 has
// historically capped at MAX_PATH=260 but long-path-aware processes can
// see up to 32767. 1024 is comfortably above the realistic install
// location (`C:\Program Files\SSHVault\sshvault.exe`).
const int _maxPathChars = 1024;

typedef _RegOpenKeyExWNative =
    Int32 Function(IntPtr, Pointer<Utf16>, Uint32, Uint32, Pointer<IntPtr>);
typedef _RegOpenKeyExW =
    int Function(int, Pointer<Utf16>, int, int, Pointer<IntPtr>);

typedef _RegCreateKeyExWNative =
    Int32 Function(
      IntPtr,
      Pointer<Utf16>,
      Uint32,
      Pointer<Utf16>,
      Uint32,
      Uint32,
      Pointer<Void>,
      Pointer<IntPtr>,
      Pointer<Uint32>,
    );
typedef _RegCreateKeyExW =
    int Function(
      int,
      Pointer<Utf16>,
      int,
      Pointer<Utf16>,
      int,
      int,
      Pointer<Void>,
      Pointer<IntPtr>,
      Pointer<Uint32>,
    );

typedef _RegQueryValueExWNative =
    Int32 Function(
      IntPtr,
      Pointer<Utf16>,
      Pointer<Uint32>,
      Pointer<Uint32>,
      Pointer<Uint8>,
      Pointer<Uint32>,
    );
typedef _RegQueryValueExW =
    int Function(
      int,
      Pointer<Utf16>,
      Pointer<Uint32>,
      Pointer<Uint32>,
      Pointer<Uint8>,
      Pointer<Uint32>,
    );

typedef _RegSetValueExWNative =
    Int32 Function(
      IntPtr,
      Pointer<Utf16>,
      Uint32,
      Uint32,
      Pointer<Uint8>,
      Uint32,
    );
typedef _RegSetValueExW =
    int Function(int, Pointer<Utf16>, int, int, Pointer<Uint8>, int);

typedef _RegDeleteValueWNative = Int32 Function(IntPtr, Pointer<Utf16>);
typedef _RegDeleteValueW = int Function(int, Pointer<Utf16>);

typedef _RegCloseKeyNative = Int32 Function(IntPtr);
typedef _RegCloseKey = int Function(int);

typedef _GetModuleFileNameWNative =
    Uint32 Function(IntPtr, Pointer<Utf16>, Uint32);
typedef _GetModuleFileNameW = int Function(int, Pointer<Utf16>, int);

class _Advapi {
  _Advapi._(DynamicLibrary lib)
    : openKey = lib
          .lookup<NativeFunction<_RegOpenKeyExWNative>>('RegOpenKeyExW')
          .asFunction(),
      createKey = lib
          .lookup<NativeFunction<_RegCreateKeyExWNative>>('RegCreateKeyExW')
          .asFunction(),
      query = lib
          .lookup<NativeFunction<_RegQueryValueExWNative>>('RegQueryValueExW')
          .asFunction(),
      setValue = lib
          .lookup<NativeFunction<_RegSetValueExWNative>>('RegSetValueExW')
          .asFunction(),
      deleteValue = lib
          .lookup<NativeFunction<_RegDeleteValueWNative>>('RegDeleteValueW')
          .asFunction(),
      closeKey = lib
          .lookup<NativeFunction<_RegCloseKeyNative>>('RegCloseKey')
          .asFunction();

  final _RegOpenKeyExW openKey;
  final _RegCreateKeyExW createKey;
  final _RegQueryValueExW query;
  final _RegSetValueExW setValue;
  final _RegDeleteValueW deleteValue;
  final _RegCloseKey closeKey;

  static _Advapi? _instance;
  static _Advapi instance() =>
      _instance ??= _Advapi._(DynamicLibrary.open('advapi32.dll'));
}

class _Kernel32 {
  _Kernel32._(DynamicLibrary lib)
    : getModuleFileName = lib
          .lookup<NativeFunction<_GetModuleFileNameWNative>>(
            'GetModuleFileNameW',
          )
          .asFunction();

  final _GetModuleFileNameW getModuleFileName;

  static _Kernel32? _instance;
  static _Kernel32 instance() =>
      _instance ??= _Kernel32._(DynamicLibrary.open('kernel32.dll'));
}

/// Real-registry implementation. Throws [StateError] on any non-success
/// status that isn't a "value-already-absent" condition — callers
/// translate to a logged warning so the UI toggle never crashes.
class _FfiWindowsRegistry implements WindowsRegistryStub {
  @override
  String? readString({required String subkey, required String valueName}) {
    final api = _Advapi.instance();
    final subkeyPtr = subkey.toNativeUtf16();
    final valuePtr = valueName.toNativeUtf16();
    final hKeyOut = calloc<IntPtr>();
    try {
      final open = api.openKey(
        _hkeyCurrentUser,
        subkeyPtr,
        0,
        _keyRead,
        hKeyOut,
      );
      if (open == _errorFileNotFound) return null;
      if (open != _errorSuccess) {
        throw StateError('RegOpenKeyExW failed: $open');
      }
      final hKey = hKeyOut.value;
      final typeOut = calloc<Uint32>();
      final sizeOut = calloc<Uint32>()..value = 0;
      try {
        // First call: ask for the size with a NULL data buffer.
        final probe = api.query(
          hKey,
          valuePtr,
          nullptr,
          typeOut,
          nullptr,
          sizeOut,
        );
        if (probe == _errorFileNotFound) return null;
        if (probe != _errorSuccess) {
          throw StateError('RegQueryValueExW(probe) failed: $probe');
        }
        final bytes = sizeOut.value;
        if (bytes == 0) return '';
        final buf = calloc<Uint8>(bytes);
        try {
          final read = api.query(
            hKey,
            valuePtr,
            nullptr,
            typeOut,
            buf,
            sizeOut,
          );
          if (read != _errorSuccess) {
            throw StateError('RegQueryValueExW(read) failed: $read');
          }
          // Cast the byte buffer to wide chars; trim the trailing NUL.
          final str = buf.cast<Utf16>().toDartString();
          return str;
        } finally {
          calloc.free(buf);
        }
      } finally {
        calloc.free(typeOut);
        calloc.free(sizeOut);
        api.closeKey(hKey);
      }
    } finally {
      calloc.free(subkeyPtr);
      calloc.free(valuePtr);
      calloc.free(hKeyOut);
    }
  }

  @override
  void writeString({
    required String subkey,
    required String valueName,
    required String data,
  }) {
    final api = _Advapi.instance();
    final subkeyPtr = subkey.toNativeUtf16();
    final valuePtr = valueName.toNativeUtf16();
    final dataPtr = data.toNativeUtf16();
    final hKeyOut = calloc<IntPtr>();
    final disposition = calloc<Uint32>();
    try {
      // RegCreateKeyEx opens-or-creates, so it works whether the Run key
      // already exists or not.
      final created = api.createKey(
        _hkeyCurrentUser,
        subkeyPtr,
        0,
        nullptr,
        0,
        _keyAllAccess,
        nullptr,
        hKeyOut,
        disposition,
      );
      if (created != _errorSuccess) {
        throw StateError('RegCreateKeyExW failed: $created');
      }
      final hKey = hKeyOut.value;
      // Byte length includes the trailing UTF-16 NUL terminator.
      final byteLen = (data.length + 1) * 2;
      try {
        final set = api.setValue(
          hKey,
          valuePtr,
          0,
          _regSz,
          dataPtr.cast<Uint8>(),
          byteLen,
        );
        if (set != _errorSuccess) {
          throw StateError('RegSetValueExW failed: $set');
        }
      } finally {
        api.closeKey(hKey);
      }
    } finally {
      calloc.free(subkeyPtr);
      calloc.free(valuePtr);
      calloc.free(dataPtr);
      calloc.free(hKeyOut);
      calloc.free(disposition);
    }
  }

  @override
  void deleteValue({required String subkey, required String valueName}) {
    final api = _Advapi.instance();
    final subkeyPtr = subkey.toNativeUtf16();
    final valuePtr = valueName.toNativeUtf16();
    final hKeyOut = calloc<IntPtr>();
    try {
      final open = api.openKey(
        _hkeyCurrentUser,
        subkeyPtr,
        0,
        _keyAllAccess,
        hKeyOut,
      );
      if (open == _errorFileNotFound) return;
      if (open != _errorSuccess) {
        throw StateError('RegOpenKeyExW(delete) failed: $open');
      }
      final hKey = hKeyOut.value;
      try {
        final del = api.deleteValue(hKey, valuePtr);
        if (del != _errorSuccess && del != _errorFileNotFound) {
          throw StateError('RegDeleteValueW failed: $del');
        }
      } finally {
        api.closeKey(hKey);
      }
    } finally {
      calloc.free(subkeyPtr);
      calloc.free(valuePtr);
      calloc.free(hKeyOut);
    }
  }
}

/// Calls `GetModuleFileNameW(NULL, ...)` to retrieve the full path of
/// the running EXE. Exposed top-level so tests can verify it doesn't
/// throw on Windows hosts (and is wrapped in try/catch elsewhere).
String getModuleFileName() {
  final k32 = _Kernel32.instance();
  final buf = calloc<Uint16>(_maxPathChars);
  try {
    final written = k32.getModuleFileName(0, buf.cast<Utf16>(), _maxPathChars);
    if (written == 0) {
      throw StateError('GetModuleFileNameW returned 0');
    }
    return buf.cast<Utf16>().toDartString(length: written);
  } finally {
    calloc.free(buf);
  }
}

// ---------------------------------------------------------------------
// Pure helpers — kept top-level so they're trivially unit-testable.
// ---------------------------------------------------------------------

/// Builds a valid XDG `.desktop` autostart entry.
///
/// [execLine] is inserted verbatim into the `Exec=` field. Callers are
/// responsible for escaping any special characters via [escapeExecValue]
/// (the [AutostartService] does this for the binary path automatically).
String buildDesktopFile({required String execLine, String? flatpakAppId}) {
  final lines = <String>[
    '[Desktop Entry]',
    'Type=Application',
    'Name=SSHVault',
    'GenericName=SSH Client',
    'Comment=Zero-knowledge SSH client (auto-start)',
    'Exec=$execLine',
    'Icon=$_appId',
    'Terminal=false',
    'Categories=Network;RemoteAccess;',
    'StartupNotify=false',
    'X-GNOME-Autostart-enabled=true',
    'Hidden=false',
  ];
  if (flatpakAppId != null && flatpakAppId.isNotEmpty) {
    lines.add('X-Flatpak=$flatpakAppId');
  }
  // Trailing newline keeps editors / linters happy.
  return '${lines.join('\n')}\n';
}

/// Escapes characters that have special meaning in a `.desktop` Exec
/// string. Spec: percent-escape `%` (literal `%%`), and quote any value
/// that contains whitespace or shell metacharacters. SSHVault paths are
/// usually safe but we still defend against weird install locations.
String escapeExecValue(String value) {
  // Per the Desktop Entry spec the reserved characters are:
  //   space, tab, newline, ", ', \, >, <, ~, |, &, ;, $, *, ?, #, (, ), `
  // If any are present, wrap in double quotes and escape \ and ".
  final reserved = RegExp(r'''[\s"'\\<>~|&;\$\*\?#\(\)`]''');
  final s = value.replaceAll('%', '%%');
  if (reserved.hasMatch(s)) {
    final escaped = s.replaceAll('\\', r'\\').replaceAll('"', r'\"');
    return '"$escaped"';
  }
  return s;
}

String _escapeExec(String value) => escapeExecValue(value);

/// Returns `true` when the entry has `Hidden=true` (case-insensitive).
/// XDG considers such files invalid — the session manager skips them.
bool _isHidden(String contents) {
  for (final raw in contents.split('\n')) {
    final line = raw.trim();
    if (line.isEmpty || line.startsWith('#')) continue;
    final eq = line.indexOf('=');
    if (eq <= 0) continue;
    final key = line.substring(0, eq).trim();
    final val = line.substring(eq + 1).trim();
    if (key.toLowerCase() == 'hidden') {
      return val.toLowerCase() == 'true';
    }
  }
  return false;
}

/// Rewrites the file contents with `Hidden=<value>`, preserving every
/// other line. If no Hidden key exists it's appended just before the
/// final newline.
String _setHidden(String contents, bool hidden) {
  final value = hidden ? 'true' : 'false';
  final lines = contents.split('\n');
  bool found = false;
  for (var i = 0; i < lines.length; i++) {
    final trimmed = lines[i].trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
    final eq = trimmed.indexOf('=');
    if (eq <= 0) continue;
    final key = trimmed.substring(0, eq).trim();
    if (key.toLowerCase() == 'hidden') {
      lines[i] = 'Hidden=$value';
      found = true;
      break;
    }
  }
  if (!found) {
    // Insert before the trailing empty line if the file ends with one,
    // otherwise append.
    if (lines.isNotEmpty && lines.last.isEmpty) {
      lines.insert(lines.length - 1, 'Hidden=$value');
    } else {
      lines.add('Hidden=$value');
    }
  }
  return lines.join('\n');
}
