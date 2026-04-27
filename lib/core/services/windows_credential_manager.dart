// Windows Credential Manager (Wincred) backend for the master vault key.
//
// On Windows the recommended at-rest storage for a per-user secret is the
// "Windows Credential Vault" exposed by `advapi32.dll`. Each entry there is
// transparently encrypted with DPAPI under the user's logon credential, so
// it follows the user account across machines (when roaming profiles are
// enabled) and is unreadable by other local users.
//
// `flutter_secure_storage` on Windows already wraps DPAPI directly, but it
// stores the ciphertext in the app's own data directory rather than as a
// first-class credential. Using the Credential Vault gives us:
//
//   * Visibility in `control.exe /name Microsoft.CredentialManager` so a
//     user can audit / delete the entry without uninstalling the app.
//   * The same UX `git`, `aws`, `kubectl`, `npm` use — power users expect
//     the master secret to live there.
//   * Roaming through Windows account sync (when the user has it enabled),
//     without us having to manage the cipher.
//
// This file talks to `advapi32.dll` through `dart:ffi`. The four entry
// points we need are tiny (`CredWriteW`, `CredReadW`, `CredDeleteW`,
// `CredFree`) and well documented in the SDK; we redeclare just the
// structures we need rather than depend on `package:win32` to keep the
// transitive footprint small.
//
// All public methods are async because callers (KeyringService) expect a
// Future-returning surface, even though the underlying syscalls are
// synchronous.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

/// Stable target name for SSHVault's master vault key inside the Windows
/// Credential Vault. The `de.kiefer_networks.SSHVault.*` prefix matches the
/// reverse-DNS scheme used by libsecret on Linux so a future cross-platform
/// migration tool can pattern-match SSHVault entries on either side.
const String kWindowsMasterKeyTarget = 'de.kiefer_networks.SSHVault.MasterKey';

/// Username field stored alongside the credential. Wincred requires a
/// non-null username for `CRED_TYPE_GENERIC` entries; we use a fixed marker
/// so the credential is unambiguously ours even if a user has multiple
/// SSHVault profiles in the future.
const String kWindowsMasterKeyUserName = 'sshvault-master-key';

/// `CRED_TYPE_GENERIC` — opaque blob, not tied to a network resource.
const int credTypeGeneric = 0x1;

/// `CRED_PERSIST_LOCAL_MACHINE` — entry survives logoff but not OS
/// reinstall, which matches the lifecycle we want: a user reinstalling
/// Windows is doing something destructive enough that asking them to
/// re-enter the master passphrase is acceptable, but we do NOT want to
/// drop the secret on every logoff.
const int credPersistLocalMachine = 0x2;

/// `ERROR_NOT_FOUND` returned by `CredReadW` when the target does not
/// exist. Surfaced so callers can distinguish "no credential yet" from
/// "the syscall failed".
const int errorNotFound = 1168;

/// Plain Dart view over a CRED_TYPE_GENERIC entry. Only fields SSHVault
/// actually reads/writes are exposed.
class WindowsCredential {
  WindowsCredential({required this.target, required List<int> blob})
    : blob = Uint8List.fromList(blob);

  final String target;
  final Uint8List blob;
}

/// Thrown for unrecoverable failures in the Wincred syscalls. The
/// `errorCode` is the raw `GetLastError()` value so logs are
/// machine-greppable.
class WindowsCredentialException implements Exception {
  WindowsCredentialException(this.message, {this.errorCode});

  final String message;
  final int? errorCode;

  @override
  String toString() => errorCode == null
      ? 'WindowsCredentialException: $message'
      : 'WindowsCredentialException: $message (Win32 error $errorCode)';
}

/// Hook for tests: lets us swap in a fake `advapi32.dll` so we don't
/// have to actually link against it on Linux/macOS CI runners.
abstract class WincredFfi {
  /// Calls `CredReadW(target, type, 0, &outCred)`. Returns the raw blob
  /// on success, null when the target does not exist, and throws on any
  /// other failure.
  Uint8List? credRead(String target, int type);

  /// Calls `CredWriteW(&cred, 0)`. Throws on failure.
  void credWrite(String target, String userName, Uint8List blob, int persist);

  /// Calls `CredDeleteW(target, type, 0)`. Returns true when the entry
  /// existed and was deleted, false when nothing was there.
  bool credDelete(String target, int type);
}

/// High-level wrapper around the Windows Credential Vault.
///
/// Methods are async-by-convention so they slot into the existing
/// `KeyringService` pipeline without forcing every call site to think
/// about whether the platform is sync or not. Tests can inject a
/// [WincredFfi] to exercise the wrapper without touching `advapi32.dll`.
class WindowsCredentialManager {
  WindowsCredentialManager({WincredFfi? ffi})
    : _ffi =
          ffi ?? (Platform.isWindows ? _LiveWincredFfi() : _NoopWincredFfi()),
      _explicitFfi = ffi != null;

  final WincredFfi _ffi;
  final bool _explicitFfi;

  /// Returns true on platforms where the Credential Vault is reachable.
  /// Off-Windows the manager constructs successfully (so providers don't
  /// need conditional imports) but every operation becomes a no-op
  /// — unless a test injected an explicit [WincredFfi], in which case
  /// the wrapper drives the stub directly.
  bool get isSupported => Platform.isWindows || _explicitFfi;

  /// Reads a credential blob. Returns null if the credential does not
  /// exist or the platform is not Windows.
  Future<List<int>?> read(String targetName) async {
    if (!isSupported) return null;
    return _ffi.credRead(targetName, credTypeGeneric);
  }

  /// Writes a credential blob. The persistence flag defaults to
  /// `CRED_PERSIST_LOCAL_MACHINE`; pass `persistLocalMachine: true` to
  /// keep that, or false to fall back to `CRED_PERSIST_SESSION` (entry
  /// dies with the logon session — useful for tests).
  Future<void> write(
    String targetName,
    List<int> blob, {
    bool persistLocalMachine = true,
  }) async {
    if (!isSupported) return;
    final persist = persistLocalMachine ? credPersistLocalMachine : 0x1;
    final bytes = blob is Uint8List ? blob : Uint8List.fromList(blob);
    _ffi.credWrite(targetName, kWindowsMasterKeyUserName, bytes, persist);
  }

  /// Deletes a credential. Returns true if an entry was actually removed.
  Future<bool> delete(String targetName) async {
    if (!isSupported) return false;
    return _ffi.credDelete(targetName, credTypeGeneric);
  }

  /// Convenience: round-trips a UTF-8 string through the credential
  /// vault. The master key is currently a UTF-8 passphrase; future
  /// callers wanting raw bytes should use [read]/[write] directly.
  Future<String?> readString(String targetName) async {
    final bytes = await read(targetName);
    if (bytes == null) return null;
    try {
      return utf8.decode(bytes);
    } catch (_) {
      // The blob is not valid UTF-8 — return null rather than crashing
      // the read path. KeyringService will treat this the same as a
      // missing entry and fall back to the next backend.
      return null;
    }
  }

  Future<void> writeString(
    String targetName,
    String value, {
    bool persistLocalMachine = true,
  }) {
    return write(
      targetName,
      utf8.encode(value),
      persistLocalMachine: persistLocalMachine,
    );
  }
}

// ---------------------------------------------------------------------------
// Live FFI — only loaded on Windows. Off-Windows we install [_NoopWincredFfi]
// so that constructing [WindowsCredentialManager] never has to dlopen a
// missing library.
// ---------------------------------------------------------------------------

// `CREDENTIALW` layout from `wincred.h`. We model only the fields we
// need; padding is governed by the natural alignment of the typed
// pointer-sized fields. The struct is identical on x64 and ARM64
// Windows targets.
final class _CredentialW extends Struct {
  @Uint32()
  external int flags;
  @Uint32()
  external int type;
  external Pointer<Utf16> targetName;
  external Pointer<Utf16> comment;
  // FILETIME (LowPart/HighPart) — 8 bytes total, ignored by us.
  @Uint32()
  external int lastWrittenLow;
  @Uint32()
  external int lastWrittenHigh;
  @Uint32()
  external int credentialBlobSize;
  external Pointer<Uint8> credentialBlob;
  @Uint32()
  external int persist;
  @Uint32()
  external int attributeCount;
  external Pointer<Void> attributes;
  external Pointer<Utf16> targetAlias;
  external Pointer<Utf16> userName;
}

typedef _CredReadWNative =
    Int32 Function(
      Pointer<Utf16> targetName,
      Uint32 type,
      Uint32 flags,
      Pointer<Pointer<_CredentialW>> credential,
    );
typedef _CredReadWDart =
    int Function(
      Pointer<Utf16> targetName,
      int type,
      int flags,
      Pointer<Pointer<_CredentialW>> credential,
    );

typedef _CredWriteWNative =
    Int32 Function(Pointer<_CredentialW> credential, Uint32 flags);
typedef _CredWriteWDart =
    int Function(Pointer<_CredentialW> credential, int flags);

typedef _CredDeleteWNative =
    Int32 Function(Pointer<Utf16> targetName, Uint32 type, Uint32 flags);
typedef _CredDeleteWDart =
    int Function(Pointer<Utf16> targetName, int type, int flags);

typedef _CredFreeNative = Void Function(Pointer<Void> buffer);
typedef _CredFreeDart = void Function(Pointer<Void> buffer);

typedef _GetLastErrorNative = Uint32 Function();
typedef _GetLastErrorDart = int Function();

class _LiveWincredFfi implements WincredFfi {
  _LiveWincredFfi() {
    final advapi32 = DynamicLibrary.open('advapi32.dll');
    final kernel32 = DynamicLibrary.open('kernel32.dll');
    _credRead = advapi32.lookupFunction<_CredReadWNative, _CredReadWDart>(
      'CredReadW',
    );
    _credWrite = advapi32.lookupFunction<_CredWriteWNative, _CredWriteWDart>(
      'CredWriteW',
    );
    _credDelete = advapi32.lookupFunction<_CredDeleteWNative, _CredDeleteWDart>(
      'CredDeleteW',
    );
    _credFree = advapi32.lookupFunction<_CredFreeNative, _CredFreeDart>(
      'CredFree',
    );
    _getLastError = kernel32
        .lookupFunction<_GetLastErrorNative, _GetLastErrorDart>('GetLastError');
  }

  late final _CredReadWDart _credRead;
  late final _CredWriteWDart _credWrite;
  late final _CredDeleteWDart _credDelete;
  late final _CredFreeDart _credFree;
  late final _GetLastErrorDart _getLastError;

  @override
  Uint8List? credRead(String target, int type) {
    final targetPtr = target.toNativeUtf16();
    final outPtr = calloc<Pointer<_CredentialW>>();
    try {
      final ok = _credRead(targetPtr, type, 0, outPtr);
      if (ok == 0) {
        final err = _getLastError();
        if (err == errorNotFound) return null;
        throw WindowsCredentialException(
          'CredReadW failed for "$target"',
          errorCode: err,
        );
      }
      final cred = outPtr.value.ref;
      final size = cred.credentialBlobSize;
      if (size == 0) return Uint8List(0);
      final bytes = Uint8List(size);
      for (var i = 0; i < size; i++) {
        bytes[i] = cred.credentialBlob[i];
      }
      _credFree(outPtr.value.cast<Void>());
      return bytes;
    } finally {
      calloc.free(targetPtr);
      calloc.free(outPtr);
    }
  }

  @override
  void credWrite(String target, String userName, Uint8List blob, int persist) {
    final targetPtr = target.toNativeUtf16();
    final userPtr = userName.toNativeUtf16();
    final blobPtr = calloc<Uint8>(blob.isEmpty ? 1 : blob.length);
    for (var i = 0; i < blob.length; i++) {
      blobPtr[i] = blob[i];
    }
    final credPtr = calloc<_CredentialW>();
    try {
      credPtr.ref
        ..flags = 0
        ..type = credTypeGeneric
        ..targetName = targetPtr
        ..comment = nullptr
        ..lastWrittenLow = 0
        ..lastWrittenHigh = 0
        ..credentialBlobSize = blob.length
        ..credentialBlob = blobPtr
        ..persist = persist
        ..attributeCount = 0
        ..attributes = nullptr
        ..targetAlias = nullptr
        ..userName = userPtr;
      final ok = _credWrite(credPtr, 0);
      if (ok == 0) {
        final err = _getLastError();
        throw WindowsCredentialException(
          'CredWriteW failed for "$target"',
          errorCode: err,
        );
      }
    } finally {
      calloc.free(targetPtr);
      calloc.free(userPtr);
      calloc.free(blobPtr);
      calloc.free(credPtr);
    }
  }

  @override
  bool credDelete(String target, int type) {
    final targetPtr = target.toNativeUtf16();
    try {
      final ok = _credDelete(targetPtr, type, 0);
      if (ok == 0) {
        final err = _getLastError();
        if (err == errorNotFound) return false;
        throw WindowsCredentialException(
          'CredDeleteW failed for "$target"',
          errorCode: err,
        );
      }
      return true;
    } finally {
      calloc.free(targetPtr);
    }
  }
}

/// Used on non-Windows hosts. All ops short-circuit. The class exists so
/// that constructing [WindowsCredentialManager] without an explicit
/// [WincredFfi] is safe everywhere — it just becomes a no-op rather than
/// crashing at `DynamicLibrary.open`.
class _NoopWincredFfi implements WincredFfi {
  @override
  Uint8List? credRead(String target, int type) => null;

  @override
  void credWrite(String target, String userName, Uint8List blob, int persist) {}

  @override
  bool credDelete(String target, int type) => false;
}
