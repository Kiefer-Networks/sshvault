/// Windows runtime registrar for SSHVault URL scheme handlers (ssh://,
/// sftp://) and file associations (.pub, .pem, .ppk).
///
/// The Inno Setup installer (`windows/installer.iss`) writes the same
/// HKCU\Software\Classes keys at install time. Portable / zip distributions
/// skip the installer entirely, so this service writes the same registry
/// values at runtime — no admin elevation required because everything lives
/// under HKCU. Linux and macOS callers get a no-op implementation.
///
/// All registry calls go through `dart:ffi` against `advapi32.dll`. The
/// `_RegistryBackend` indirection lets tests substitute an in-memory fake
/// without touching the real registry.
library;

import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

// ---------------------------------------------------------------------------
// Public surface
// ---------------------------------------------------------------------------

/// One key/value pair the registrar wants to land in the registry.
///
/// `path` is a backslash-delimited subkey under `HKCU\` (e.g.
/// `Software\Classes\ssh\shell\open\command`). `name` is the value name
/// (empty string for the `(default)` value). `data` is the string payload.
class RegistryEntry {
  final String path;
  final String name;
  final String data;
  const RegistryEntry({required this.path, this.name = '', required this.data});

  @override
  bool operator ==(Object other) =>
      other is RegistryEntry &&
      other.path == path &&
      other.name == name &&
      other.data == data;

  @override
  int get hashCode => Object.hash(path, name, data);

  @override
  String toString() => 'RegistryEntry($path!$name=$data)';
}

/// Builds the canonical list of HKCU entries the registrar must land for a
/// given installed binary path. Pure function — exposed for tests so they
/// can assert the exact set of keys the FFI layer is asked to write.
List<RegistryEntry> buildSshVaultRegistryEntries(String exePath) {
  final exeIcon = '$exePath,0';
  final openCmd = '"$exePath" "%1"';
  final importCmd = '"$exePath" --import-keys "%1"';

  return <RegistryEntry>[
    // ssh:// URL scheme
    const RegistryEntry(
      path: r'Software\Classes\ssh',
      data: 'URL:Secure Shell',
    ),
    const RegistryEntry(
      path: r'Software\Classes\ssh',
      name: 'URL Protocol',
      data: '',
    ),
    RegistryEntry(path: r'Software\Classes\ssh\DefaultIcon', data: exeIcon),
    RegistryEntry(
      path: r'Software\Classes\ssh\shell\open\command',
      data: openCmd,
    ),

    // sftp:// URL scheme
    const RegistryEntry(
      path: r'Software\Classes\sftp',
      data: 'URL:SSH File Transfer Protocol',
    ),
    const RegistryEntry(
      path: r'Software\Classes\sftp',
      name: 'URL Protocol',
      data: '',
    ),
    RegistryEntry(path: r'Software\Classes\sftp\DefaultIcon', data: exeIcon),
    RegistryEntry(
      path: r'Software\Classes\sftp\shell\open\command',
      data: openCmd,
    ),

    // File extension -> ProgID
    const RegistryEntry(
      path: r'Software\Classes\.pub',
      data: 'SSHVault.PublicKey',
    ),
    const RegistryEntry(
      path: r'Software\Classes\.pem',
      data: 'SSHVault.PEMKey',
    ),
    const RegistryEntry(
      path: r'Software\Classes\.ppk',
      data: 'SSHVault.PPKKey',
    ),

    // ProgIDs + open commands
    const RegistryEntry(
      path: r'Software\Classes\SSHVault.PublicKey',
      data: 'SSH public key',
    ),
    RegistryEntry(
      path: r'Software\Classes\SSHVault.PublicKey\DefaultIcon',
      data: exeIcon,
    ),
    RegistryEntry(
      path: r'Software\Classes\SSHVault.PublicKey\shell\open\command',
      data: importCmd,
    ),

    const RegistryEntry(
      path: r'Software\Classes\SSHVault.PEMKey',
      data: 'PEM-encoded private key',
    ),
    RegistryEntry(
      path: r'Software\Classes\SSHVault.PEMKey\DefaultIcon',
      data: exeIcon,
    ),
    RegistryEntry(
      path: r'Software\Classes\SSHVault.PEMKey\shell\open\command',
      data: importCmd,
    ),

    const RegistryEntry(
      path: r'Software\Classes\SSHVault.PPKKey',
      data: 'PuTTY private key',
    ),
    RegistryEntry(
      path: r'Software\Classes\SSHVault.PPKKey\DefaultIcon',
      data: exeIcon,
    ),
    RegistryEntry(
      path: r'Software\Classes\SSHVault.PPKKey\shell\open\command',
      data: importCmd,
    ),
  ];
}

/// Top-level subkeys the unregister path deletes (everything beneath them
/// goes with the recursive walk in [_RegistryBackend.deleteTree]).
const List<String> kSshVaultRegistryRoots = <String>[
  r'Software\Classes\ssh',
  r'Software\Classes\sftp',
  r'Software\Classes\.pub',
  r'Software\Classes\.pem',
  r'Software\Classes\.ppk',
  r'Software\Classes\SSHVault.PublicKey',
  r'Software\Classes\SSHVault.PEMKey',
  r'Software\Classes\SSHVault.PPKKey',
];

/// Pluggable backend so tests can swap in a fake without touching the real
/// registry. The default implementation is the FFI-backed [_Advapi32Backend].
abstract class WindowsRegistryBackend {
  Future<bool> keyExists(String path);
  Future<String?> readString(String path, String name);
  Future<void> writeString(String path, String name, String data);
  Future<void> deleteTree(String path);
}

/// Cross-platform façade for the URL scheme + file association registrar.
///
/// On Linux / macOS every method is a cheap no-op so callers don't have to
/// guard each call site. On Windows the FFI backend is invoked.
class WindowsProtocolRegistrar {
  /// Optional override for the binary path used in the registered commands.
  /// `null` defaults to [Platform.resolvedExecutable]. Tests inject a fixed
  /// path so the asserted entries are reproducible.
  final String? exePathOverride;

  /// Registry backend. Tests inject a fake; production gets the FFI-backed
  /// default constructed lazily so the import is free on non-Windows hosts.
  final WindowsRegistryBackend? backendOverride;

  /// Optional override for `Platform.isWindows`. Lets tests exercise the
  /// Windows code path on a Linux CI host. Defaults to the real value.
  final bool? platformIsWindowsOverride;

  const WindowsProtocolRegistrar({
    this.exePathOverride,
    this.backendOverride,
    this.platformIsWindowsOverride,
  });

  bool get _isWindows => platformIsWindowsOverride ?? Platform.isWindows;

  String get _exePath => exePathOverride ?? Platform.resolvedExecutable;

  WindowsRegistryBackend get _backend => backendOverride ?? _Advapi32Backend();

  /// Returns `true` when every entry in [buildSshVaultRegistryEntries] is
  /// already present with the expected data. Off-Windows always returns
  /// `true` so first-run logic skips the prompt.
  Future<bool> isRegistered() async {
    if (!_isWindows) return true;
    final entries = buildSshVaultRegistryEntries(_exePath);
    for (final e in entries) {
      // The (default) value with empty data ("URL Protocol" marker) only
      // needs the named value to be present — its data is conventionally
      // empty so we just check existence.
      final actual = await _backend.readString(e.path, e.name);
      if (actual == null) return false;
      if (e.data.isNotEmpty && actual != e.data) return false;
    }
    return true;
  }

  /// Writes / overwrites every required key. Idempotent — re-running is
  /// safe and self-heals partial state from a previous interrupted run.
  Future<void> register() async {
    if (!_isWindows) return;
    final entries = buildSshVaultRegistryEntries(_exePath);
    for (final e in entries) {
      await _backend.writeString(e.path, e.name, e.data);
    }
  }

  /// Removes every top-level subkey we own (ssh, sftp, ProgIDs, extension
  /// hints). Recursive; missing keys are ignored.
  Future<void> unregister() async {
    if (!_isWindows) return;
    for (final root in kSshVaultRegistryRoots) {
      await _backend.deleteTree(root);
    }
  }
}

// ---------------------------------------------------------------------------
// FFI-backed Windows implementation
// ---------------------------------------------------------------------------

// Constants from <winreg.h> / <winnt.h>. Values are stable across all
// Windows versions we care about (Win7+).
const int _kHkeyCurrentUser = 0x80000001;
const int _kKeyAllAccess = 0xF003F;
const int _kKeyRead = 0x20019;
const int _kRegSz = 1;
const int _kErrorSuccess = 0;
const int _kErrorFileNotFound = 2;
const int _kErrorMoreData = 234;
const int _kRegOptionNonVolatile = 0;

/// `dart:ffi` wrapper around the Win32 registry APIs we need.
///
/// Linux / macOS callers must not instantiate this class — every method
/// would fail to load `advapi32.dll`. The `WindowsProtocolRegistrar`
/// platform guard prevents that.
class _Advapi32Backend implements WindowsRegistryBackend {
  static final DynamicLibrary _advapi32 = _loadAdvapi32();

  static DynamicLibrary _loadAdvapi32() {
    if (!Platform.isWindows) {
      // Returning a stub keeps the field initializer happy on non-Windows;
      // the platform guard in [WindowsProtocolRegistrar] means we never
      // reach the lookup below.
      return DynamicLibrary.process();
    }
    return DynamicLibrary.open('advapi32.dll');
  }

  // RegCreateKeyExW: creates or opens the key under [hKey].
  static final _regCreateKeyEx = _advapi32
      .lookupFunction<
        Int32 Function(
          IntPtr hKey,
          Pointer<Utf16> lpSubKey,
          Uint32 reserved,
          Pointer<Utf16> lpClass,
          Uint32 dwOptions,
          Uint32 samDesired,
          Pointer<Void> lpSecurityAttributes,
          Pointer<IntPtr> phkResult,
          Pointer<Uint32> lpdwDisposition,
        ),
        int Function(
          int hKey,
          Pointer<Utf16> lpSubKey,
          int reserved,
          Pointer<Utf16> lpClass,
          int dwOptions,
          int samDesired,
          Pointer<Void> lpSecurityAttributes,
          Pointer<IntPtr> phkResult,
          Pointer<Uint32> lpdwDisposition,
        )
      >('RegCreateKeyExW');

  // RegOpenKeyExW: read-only open used by isRegistered() and the recursive
  // delete to enumerate subkeys.
  static final _regOpenKeyEx = _advapi32
      .lookupFunction<
        Int32 Function(
          IntPtr hKey,
          Pointer<Utf16> lpSubKey,
          Uint32 ulOptions,
          Uint32 samDesired,
          Pointer<IntPtr> phkResult,
        ),
        int Function(
          int hKey,
          Pointer<Utf16> lpSubKey,
          int ulOptions,
          int samDesired,
          Pointer<IntPtr> phkResult,
        )
      >('RegOpenKeyExW');

  // RegSetValueExW: writes a REG_SZ value.
  static final _regSetValueEx = _advapi32
      .lookupFunction<
        Int32 Function(
          IntPtr hKey,
          Pointer<Utf16> lpValueName,
          Uint32 reserved,
          Uint32 dwType,
          Pointer<Uint8> lpData,
          Uint32 cbData,
        ),
        int Function(
          int hKey,
          Pointer<Utf16> lpValueName,
          int reserved,
          int dwType,
          Pointer<Uint8> lpData,
          int cbData,
        )
      >('RegSetValueExW');

  // RegQueryValueExW: reads a REG_SZ value.
  static final _regQueryValueEx = _advapi32
      .lookupFunction<
        Int32 Function(
          IntPtr hKey,
          Pointer<Utf16> lpValueName,
          Pointer<Uint32> lpReserved,
          Pointer<Uint32> lpType,
          Pointer<Uint8> lpData,
          Pointer<Uint32> lpcbData,
        ),
        int Function(
          int hKey,
          Pointer<Utf16> lpValueName,
          Pointer<Uint32> lpReserved,
          Pointer<Uint32> lpType,
          Pointer<Uint8> lpData,
          Pointer<Uint32> lpcbData,
        )
      >('RegQueryValueExW');

  // RegCloseKey: drops the open handle.
  static final _regCloseKey = _advapi32
      .lookupFunction<Int32 Function(IntPtr hKey), int Function(int hKey)>(
        'RegCloseKey',
      );

  // RegDeleteKeyW: deletes a key with no subkeys. Recursive delete is
  // implemented in [deleteTree] via RegEnumKeyExW.
  static final _regDeleteKey = _advapi32
      .lookupFunction<
        Int32 Function(IntPtr hKey, Pointer<Utf16> lpSubKey),
        int Function(int hKey, Pointer<Utf16> lpSubKey)
      >('RegDeleteKeyW');

  // RegEnumKeyExW: enumerates child keys for the recursive walk.
  static final _regEnumKeyEx = _advapi32
      .lookupFunction<
        Int32 Function(
          IntPtr hKey,
          Uint32 dwIndex,
          Pointer<Utf16> lpName,
          Pointer<Uint32> lpcchName,
          Pointer<Uint32> lpReserved,
          Pointer<Utf16> lpClass,
          Pointer<Uint32> lpcchClass,
          Pointer<Void> lpftLastWriteTime,
        ),
        int Function(
          int hKey,
          int dwIndex,
          Pointer<Utf16> lpName,
          Pointer<Uint32> lpcchName,
          Pointer<Uint32> lpReserved,
          Pointer<Utf16> lpClass,
          Pointer<Uint32> lpcchClass,
          Pointer<Void> lpftLastWriteTime,
        )
      >('RegEnumKeyExW');

  @override
  Future<bool> keyExists(String path) async {
    final subKey = path.toNativeUtf16();
    final phk = calloc<IntPtr>();
    try {
      final rc = _regOpenKeyEx(_kHkeyCurrentUser, subKey, 0, _kKeyRead, phk);
      if (rc == _kErrorSuccess) {
        _regCloseKey(phk.value);
        return true;
      }
      return false;
    } finally {
      calloc.free(subKey);
      calloc.free(phk);
    }
  }

  @override
  Future<String?> readString(String path, String name) async {
    final subKey = path.toNativeUtf16();
    final valueName = name.toNativeUtf16();
    final phk = calloc<IntPtr>();
    try {
      final openRc = _regOpenKeyEx(
        _kHkeyCurrentUser,
        subKey,
        0,
        _kKeyRead,
        phk,
      );
      if (openRc == _kErrorFileNotFound) return null;
      if (openRc != _kErrorSuccess) return null;

      // Probe for size first (lpData=null), then alloc + read.
      final cb = calloc<Uint32>();
      try {
        final probeRc = _regQueryValueEx(
          phk.value,
          valueName,
          nullptr,
          nullptr,
          nullptr,
          cb,
        );
        if (probeRc != _kErrorSuccess && probeRc != _kErrorMoreData) {
          return null;
        }
        if (cb.value == 0) return '';
        final buf = calloc<Uint8>(cb.value + 2); // +2 for safety NUL
        try {
          final readRc = _regQueryValueEx(
            phk.value,
            valueName,
            nullptr,
            nullptr,
            buf,
            cb,
          );
          if (readRc != _kErrorSuccess) return null;
          final widePtr = buf.cast<Uint16>();
          // Length in chars excluding terminator (data is REG_SZ).
          final chars = (cb.value ~/ 2);
          // Trim trailing NULs.
          var end = chars;
          while (end > 0 && widePtr[end - 1] == 0) {
            end--;
          }
          return _utf16ToString(widePtr, end);
        } finally {
          calloc.free(buf);
        }
      } finally {
        calloc.free(cb);
        _regCloseKey(phk.value);
      }
    } finally {
      calloc.free(subKey);
      calloc.free(valueName);
      calloc.free(phk);
    }
  }

  @override
  Future<void> writeString(String path, String name, String data) async {
    final subKey = path.toNativeUtf16();
    final valueName = name.toNativeUtf16();
    final phk = calloc<IntPtr>();
    final disp = calloc<Uint32>();
    try {
      final rc = _regCreateKeyEx(
        _kHkeyCurrentUser,
        subKey,
        0,
        nullptr,
        _kRegOptionNonVolatile,
        _kKeyAllAccess,
        nullptr,
        phk,
        disp,
      );
      if (rc != _kErrorSuccess) {
        throw StateError('RegCreateKeyExW($path) failed with code $rc');
      }
      try {
        final wide = data.toNativeUtf16();
        // Byte length includes the trailing UTF-16 NUL.
        final byteLen = (data.length + 1) * 2;
        try {
          final setRc = _regSetValueEx(
            phk.value,
            valueName,
            0,
            _kRegSz,
            wide.cast<Uint8>(),
            byteLen,
          );
          if (setRc != _kErrorSuccess) {
            throw StateError(
              'RegSetValueExW($path!$name) failed with code $setRc',
            );
          }
        } finally {
          calloc.free(wide);
        }
      } finally {
        _regCloseKey(phk.value);
      }
    } finally {
      calloc.free(subKey);
      calloc.free(valueName);
      calloc.free(phk);
      calloc.free(disp);
    }
  }

  @override
  Future<void> deleteTree(String path) async {
    // Win32 RegDeleteKeyW only deletes leaf keys, so we recurse children
    // first, then delete the parent. Best-effort: missing keys are ignored.
    final subKey = path.toNativeUtf16();
    final phk = calloc<IntPtr>();
    try {
      final openRc = _regOpenKeyEx(
        _kHkeyCurrentUser,
        subKey,
        0,
        _kKeyAllAccess,
        phk,
      );
      if (openRc == _kErrorFileNotFound) return;
      if (openRc != _kErrorSuccess) return;

      // Collect children first (deleting while enumerating is undefined).
      final children = <String>[];
      const maxNameChars = 256; // Win32 max key name length.
      final nameBuf = calloc<Uint16>(maxNameChars);
      final cch = calloc<Uint32>();
      try {
        var i = 0;
        while (true) {
          cch.value = maxNameChars;
          final rc = _regEnumKeyEx(
            phk.value,
            i,
            nameBuf.cast<Utf16>(),
            cch,
            nullptr,
            nullptr,
            nullptr,
            nullptr,
          );
          if (rc != _kErrorSuccess) break;
          children.add(_utf16ToString(nameBuf.cast<Uint16>(), cch.value));
          i++;
        }
      } finally {
        calloc.free(nameBuf);
        calloc.free(cch);
        _regCloseKey(phk.value);
      }

      for (final child in children) {
        await deleteTree('$path\\$child');
      }

      final delRc = _regDeleteKey(_kHkeyCurrentUser, subKey);
      if (delRc != _kErrorSuccess && delRc != _kErrorFileNotFound) {
        // Non-fatal: log via throw so the outer registrar's caller can
        // surface it. Intentionally not rethrowing other backend codes —
        // best-effort uninstall.
      }
    } finally {
      calloc.free(subKey);
      calloc.free(phk);
    }
  }

  static String _utf16ToString(Pointer<Uint16> ptr, int length) {
    if (length <= 0) return '';
    final codeUnits = <int>[];
    for (var i = 0; i < length; i++) {
      codeUnits.add(ptr[i]);
    }
    return String.fromCharCodes(codeUnits);
  }
}
