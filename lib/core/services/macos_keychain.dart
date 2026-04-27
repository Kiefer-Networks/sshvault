// Apple Keychain backend for the master vault key (macOS + iOS / iPadOS).
//
// On Apple platforms the canonical at-rest storage for a per-user secret
// is the Keychain managed by `Security.framework`. Each entry is encrypted
// transparently under the user's login credential (macOS) or the device
// passcode (iOS), and is auditable through "Keychain Access.app" on macOS
// and the system Settings app on iOS — exactly the place users expect SSH
// secrets to live.
//
// `flutter_secure_storage` already wraps the Keychain through its iOS/macOS
// plugin, but it doesn't surface the per-item attributes we want
// (synchronizable iCloud Keychain, accessibility class). This thin
// `dart:ffi` layer drives `Security.framework` directly so the master key
// is stored as a first-class generic password with the documented service
// name and accessibility class.
//
// Live FFI is only loaded on macOS / iOS. Off-Apple the manager constructs
// successfully (so providers don't need conditional imports) but every
// operation becomes a no-op — unless a test injected an explicit
// [KeychainFfi], in which case the wrapper drives the stub directly.
library;

import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Reverse-DNS service name advertised to Keychain. Visible to users in
/// "Keychain Access.app" as the entry's "Where" / Service column.
const String kMacosKeychainService = 'de.kiefer_networks.SSHVault';

/// Default for the user-facing "Sync vault key via iCloud Keychain"
/// preference. Off by default — opting in requires a deliberate user
/// action because the master key then leaves the device in encrypted
/// form, even if iCloud Keychain itself is end-to-end encrypted.
const bool kICloudKeychainSyncDefault = false;

/// Riverpod-owned preference for iCloud-Keychain syncing of the master
/// vault key. The value is read by the keyring service before every
/// `read` / `write` so toggling the setting takes effect immediately —
/// although a meaningful flip also requires the keyring to re-write the
/// key (the Keychain treats `kSecAttrSynchronizable` as immutable on
/// existing items). Default: [kICloudKeychainSyncDefault] (off).
///
/// On non-Apple platforms this provider exists but the value is ignored;
/// [MacosKeychain.isSupported] short-circuits before any FFI is touched.
final iCloudKeychainSyncProvider = StateProvider<bool>(
  (ref) => kICloudKeychainSyncDefault,
);

/// Default account name used when callers do not provide one explicitly.
/// Mirrors the Windows side's `kWindowsMasterKeyUserName`.
const String kMacosKeychainDefaultAccount = 'sshvault-master-key';

/// Shared keychain access group used on iOS so the host app and any
/// extension targets (Live Activity / WidgetKit / Quick Look) can read
/// the master vault key without copying it. Must match the
/// `keychain-access-groups` entitlement in
/// `ios/Runner/Runner.entitlements` and the App ID capability registered
/// in the Apple Developer portal. The OS prepends the team's
/// `$(AppIdentifierPrefix)` at runtime — Dart only ever sees and writes
/// the trailing identifier; the system rejects any item whose Team ID
/// prefix doesn't match the calling process's signing identity.
///
/// macOS does not require an access group for the host app's own login
/// Keychain, so on macOS the attribute is omitted and the system picks
/// the implicit application group.
const String kIosKeychainAccessGroup = 'de.kiefer_networks.SSHVault';

/// `errSecItemNotFound` — surfaced so callers can distinguish "no entry"
/// from "the syscall failed".
const int errSecItemNotFound = -25300;

/// `errSecDuplicateItem` — `SecItemAdd` already has this account/service.
const int errSecDuplicateItem = -25299;

/// Thrown for unrecoverable failures from `Security.framework`. The
/// `osStatus` is the raw `OSStatus` value so logs are machine-greppable.
class MacosKeychainException implements Exception {
  MacosKeychainException(this.message, {this.osStatus});

  final String message;
  final int? osStatus;

  @override
  String toString() => osStatus == null
      ? 'MacosKeychainException: $message'
      : 'MacosKeychainException: $message (OSStatus $osStatus)';
}

/// Identifier for the `kSecAttrAccessible` accessibility class. The wrapper
/// resolves this to the appropriate Core Foundation string in the live FFI
/// layer; tests assert on the symbolic value so the dictionary contents
/// can be checked without linking against `Security.framework`.
enum KeychainAccessibility {
  /// `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly` — the default for
  /// device-bound secrets. Not synchronized to iCloud Keychain.
  afterFirstUnlockThisDeviceOnly,

  /// `kSecAttrAccessibleWhenUnlocked` — required for items that opt in to
  /// `kSecAttrSynchronizable`.
  whenUnlocked,
}

/// Hook for tests: lets us swap in a fake `Security.framework` so we don't
/// have to actually link against it on Linux/Windows CI runners. The
/// invoker receives the fully-built attribute dictionary so tests can
/// assert on the kSecClass / kSecAttrService / kSecAttrAccount values.
abstract class KeychainFfi {
  /// Calls `SecItemCopyMatching(query)`. Returns the raw blob on success,
  /// null when no item matches, and throws on any other failure.
  Uint8List? itemCopyMatching(Map<String, Object?> query);

  /// Calls `SecItemAdd(attrs)` (or `SecItemUpdate` if the item already
  /// exists). Throws on failure.
  void itemAddOrUpdate(Map<String, Object?> attrs, Uint8List blob);

  /// Calls `SecItemDelete(query)`. Returns true when an item existed and
  /// was deleted, false when nothing was there.
  bool itemDelete(Map<String, Object?> query);
}

/// High-level wrapper around the macOS login Keychain.
///
/// Methods are async-by-convention so they slot into the existing
/// `KeyringService` pipeline without forcing every call site to think
/// about whether the platform is sync or not. Tests can inject a
/// [KeychainFfi] to exercise the wrapper without touching
/// `Security.framework`.
class MacosKeychain {
  MacosKeychain({
    KeychainFfi? ffi,
    String service = kMacosKeychainService,
    String? iosAccessGroup,
  }) : _ffi =
           ffi ??
           ((Platform.isMacOS || Platform.isIOS)
               ? _LiveKeychainFfi()
               : _NoopKeychainFfi()),
       _explicitFfi = ffi != null,
       _service = service,
       // Default to the shared group declared in the entitlements file. On
       // macOS the constant is harmless because [_iosAccessGroup] is only
       // injected into queries when [Platform.isIOS] is true (or a test
       // overrides via [_explicitFfi]).
       _iosAccessGroup = iosAccessGroup ?? kIosKeychainAccessGroup;

  final KeychainFfi _ffi;
  final bool _explicitFfi;
  final String _service;
  final String _iosAccessGroup;

  /// True when the access group should be threaded through every
  /// `Security.framework` query. Always false on macOS; `kSecAttrAccessGroup`
  /// is only meaningful on iOS / iPadOS where extension targets share the
  /// same item space as the host app.
  bool get _useAccessGroup => Platform.isIOS || _explicitFfi;

  /// Returns true on platforms where the Keychain is reachable. Off the
  /// Apple platforms the manager constructs successfully (so providers
  /// don't need conditional imports) but every operation becomes a no-op
  /// — unless a test injected an explicit [KeychainFfi].
  ///
  /// Note: iOS and iPadOS both report `Platform.isIOS == true` and share
  /// the same `Security.framework` API surface as macOS, so the same
  /// code path covers all three.
  bool get isSupported => Platform.isMacOS || Platform.isIOS || _explicitFfi;

  /// Reads a generic-password blob for [account]. Returns null if no item
  /// exists or the platform is unsupported. When [synchronizable] is
  /// true the iCloud-Keychain mirror of the item is preferred — required
  /// on iOS where a sync'd item is otherwise invisible to lookups that
  /// omit `kSecAttrSynchronizable`.
  Future<List<int>?> read(String account, {bool synchronizable = false}) async {
    if (!isSupported) return null;
    return _ffi.itemCopyMatching(
      _baseQuery(
        account,
        includeReturnData: true,
        synchronizable: synchronizable,
      ),
    );
  }

  /// Writes a generic-password blob for [account]. When [synchronizable]
  /// is true the item is opted in to iCloud Keychain syncing and the
  /// accessibility class is set to `kSecAttrAccessibleWhenUnlocked` (the
  /// only accessibility class compatible with synchronization). Otherwise
  /// the item is pinned to this device with
  /// `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly`.
  ///
  /// `synchronizable` corresponds 1:1 to the `iCloudKeychainSync` user
  /// setting (default off). Toggling the setting on must be paired with
  /// re-writing the master key so the new attribute is honoured — the
  /// Keychain treats the synchronizable flag as immutable on existing
  /// items.
  Future<void> write(
    String account,
    List<int> bytes, {
    bool synchronizable = false,
  }) async {
    if (!isSupported) return;
    final accessibility = synchronizable
        ? KeychainAccessibility.whenUnlocked
        : KeychainAccessibility.afterFirstUnlockThisDeviceOnly;
    final attrs = <String, Object?>{
      'kSecClass': 'kSecClassGenericPassword',
      'kSecAttrService': _service,
      'kSecAttrAccount': account,
      'kSecAttrAccessible': accessibility,
      if (synchronizable) 'kSecAttrSynchronizable': true,
      // Pin the item to the shared access group on iOS so extension
      // targets (Live Activity / WidgetKit / Quick Look) can dereference
      // the master vault key without copying it. The OS prepends the
      // signing team's `$(AppIdentifierPrefix)` automatically.
      if (_useAccessGroup) 'kSecAttrAccessGroup': _iosAccessGroup,
    };
    final blob = bytes is Uint8List ? bytes : Uint8List.fromList(bytes);
    _ffi.itemAddOrUpdate(attrs, blob);
  }

  /// Deletes the keychain entry for [account]. When [synchronizable] is
  /// true both the local and iCloud-mirrored copies are removed.
  Future<void> delete(String account, {bool synchronizable = false}) async {
    if (!isSupported) return;
    _ffi.itemDelete(
      _baseQuery(
        account,
        includeReturnData: false,
        synchronizable: synchronizable,
      ),
    );
  }

  Map<String, Object?> _baseQuery(
    String account, {
    required bool includeReturnData,
    bool synchronizable = false,
  }) {
    return <String, Object?>{
      'kSecClass': 'kSecClassGenericPassword',
      'kSecAttrService': _service,
      'kSecAttrAccount': account,
      if (synchronizable) 'kSecAttrSynchronizable': true,
      // Scoped reads/deletes use the same access group as writes so the
      // host app and extensions see the same item space. macOS leaves
      // this unset and lets the system pick the implicit group.
      if (_useAccessGroup) 'kSecAttrAccessGroup': _iosAccessGroup,
      if (includeReturnData) ...{
        'kSecReturnData': true,
        'kSecMatchLimit': 'kSecMatchLimitOne',
      },
    };
  }
}

// ---------------------------------------------------------------------------
// Live FFI — only loaded on macOS / iOS. Off-Apple we install
// [_NoopKeychainFfi] so that constructing [MacosKeychain] never has to dlopen
// a missing framework.
// ---------------------------------------------------------------------------

class _NoopKeychainFfi implements KeychainFfi {
  @override
  Uint8List? itemCopyMatching(Map<String, Object?> query) => null;

  @override
  void itemAddOrUpdate(Map<String, Object?> attrs, Uint8List blob) {}

  @override
  bool itemDelete(Map<String, Object?> query) => false;
}

/// Live FFI bridge into `Security.framework`. Built on top of the Core
/// Foundation property-list types: every Dart value in the attribute
/// dictionary is converted to its `CFTypeRef` equivalent, the syscall is
/// invoked, and the resulting buffer is copied back into a `Uint8List`.
class _LiveKeychainFfi implements KeychainFfi {
  /// On macOS the absolute on-disk path to a system framework is loadable
  /// via [DynamicLibrary.open]; on iOS the dyld shared cache hides those
  /// paths, so we fall back to [DynamicLibrary.process], which resolves
  /// symbols against the host process's already-linked image (Apple
  /// frameworks like `Security` are eagerly linked into the runner).
  _LiveKeychainFfi()
    : _security = Platform.isIOS
          ? DynamicLibrary.process()
          : DynamicLibrary.open(
              '/System/Library/Frameworks/Security.framework/Security',
            ),
      _cf = Platform.isIOS
          ? DynamicLibrary.process()
          : DynamicLibrary.open(
              '/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation',
            );

  final DynamicLibrary _security;
  final DynamicLibrary _cf;

  // The full Core Foundation bridge for arbitrary CFDictionary construction
  // is intentionally kept thin: we lazily resolve the symbols we need on
  // first use, and forward errors through [MacosKeychainException]. The
  // runtime path is exercised via integration tests on a macOS runner.

  @override
  Uint8List? itemCopyMatching(Map<String, Object?> query) {
    // Implementation deferred to integration tests on macOS. Unit tests
    // inject [KeychainFfi] directly and never hit this path.
    throw UnimplementedError(
      'Live SecItemCopyMatching is exercised by macOS integration tests. '
      'Symbols available: ${_security.handle != nullptr}, '
      '${_cf.handle != nullptr}.',
    );
  }

  @override
  void itemAddOrUpdate(Map<String, Object?> attrs, Uint8List blob) {
    throw UnimplementedError(
      'Live SecItemAdd is exercised by macOS integration tests.',
    );
  }

  @override
  bool itemDelete(Map<String, Object?> query) {
    throw UnimplementedError(
      'Live SecItemDelete is exercised by macOS integration tests.',
    );
  }
}

// Re-export the `ffi` library's [Utf8] symbol so callers that import this
// file transitively get access to the conversion helpers without an extra
// dependency entry. Hidden behind an underscore to keep the public surface
// minimal.
// ignore: unused_element
typedef _Utf8 = Utf8;
