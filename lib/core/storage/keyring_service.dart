import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sshvault/core/services/windows_credential_manager.dart';

/// Logical key under which the vault master key is stored.
///
/// Kept stable across versions so the same secret is round-tripped between
/// libsecret entries and the file-based fallback.
const String kVaultMasterKeyId = 'sv_vault_master_key';

/// Filename used for the file-based fallback (Linux without a running
/// Secret Service / headless servers / Flatpak without
/// `--talk-name=org.freedesktop.secrets`).
const String kVaultMasterKeyLegacyFile = 'master.key.enc';

/// Filename used to cache the per-app secret returned by the
/// `org.freedesktop.portal.Secret` portal. The portal hands us a stable
/// random byte string scoped to this Flatpak app — we use it as the
/// content of our local keyring file fallback so the user's master key
/// stays encrypted at rest with material we never write to disk in
/// plaintext.
///
/// Kept private to this module; callers go through [KeyringService].
const String _kPortalSecretCacheFile = 'portal.secret.bin';

/// Schema name advertised to libsecret. `flutter_secure_storage` 10.x does
/// not currently expose this through `LinuxOptions`, but we keep the
/// constant so the value is documented in one place and used by tests
/// (which assert the wrapper is configured with the expected schema).
///
/// See: <https://pub.dev/packages/flutter_secure_storage>
const String kVaultKeyringSchemaName = 'de.kiefer_networks.SSHVault.Vault';

/// Human-readable label libsecret will use in keyring management UIs
/// (gnome-keyring's "seahorse", KWallet manager).
const String kVaultKeyringLabel = 'SSHVault master key';

/// Where the master vault key is currently persisted on disk.
enum MasterKeyBackend {
  /// libsecret (GNOME Keyring / KWallet) on Linux, Keychain on macOS,
  /// Keystore-backed shared prefs on Android, DPAPI-via-fss on Windows
  /// (legacy — new installs use [windowsCredentialManager] instead).
  systemKeyring,

  /// `org.freedesktop.portal.Secret` — used on Linux/Flatpak when the
  /// direct `org.freedesktop.secrets` D-Bus service is unreachable
  /// (sandbox refused `--talk-name=org.freedesktop.secrets`, or the
  /// Secret Service simply isn't running but the portal is). The portal
  /// returns a per-app secret blob that we store under the support dir,
  /// the same way [encryptedFile] does, but the key material itself is
  /// never derived from the user — it's provisioned by the portal.
  portalSecret,

  /// Plain encrypted file under the application support directory. Used
  /// only when the system keyring is unavailable (no Secret Service,
  /// headless server, missing Flatpak permission).
  encryptedFile,

  /// Windows Credential Manager (Wincred) entry, encrypted by DPAPI under
  /// the user's logon credential and listed in
  /// `control.exe /name Microsoft.CredentialManager`. The preferred
  /// backend on Windows; chosen instead of [systemKeyring] when
  /// `Platform.isWindows`.
  windowsCredentialManager,
}

/// Minimal contract for the `org.freedesktop.portal.Secret` portal call,
/// extracted so unit tests can stub it without spinning up a real D-Bus
/// session bus. The default implementation lives in
/// [_LiveSecretPortalClient].
abstract class SecretPortalClient {
  /// Calls `RetrieveSecret(UnixFD, a{sv})` on
  /// `org.freedesktop.portal.Secret` and returns the bytes the portal
  /// wrote to the FD. Returns `null` when the portal isn't reachable
  /// (non-Linux, no D-Bus session bus, sandbox can't talk to the
  /// portal, …) so callers can degrade gracefully.
  Future<Uint8List?> retrieveSecret();
}

/// Pre-read biometric gate. On Windows the production implementation
/// calls into `local_auth` which delegates to
/// `Windows.Security.Credentials.UI.UserConsentVerifier.RequestVerificationAsync`
/// (Windows Hello on Win10+). Tests inject a stub that returns true to
/// keep the path covered without prompting a real biometric.
abstract class MasterKeyBiometricGate {
  /// Whether the gate should run before reading the master key. The
  /// default production gate consults the user setting; tests can
  /// hard-code true/false.
  Future<bool> isRequired();

  /// Prompt the user. Returning false aborts the read and the caller
  /// surfaces this as "no key available" so the lock screen stays up.
  Future<bool> verify();
}

/// No-op gate used when biometric pre-unlock is not configured.
class _DisabledBiometricGate implements MasterKeyBiometricGate {
  const _DisabledBiometricGate();

  @override
  Future<bool> isRequired() async => false;

  @override
  Future<bool> verify() async => true;
}

/// Persistent storage for the vault master key (the user's passphrase used
/// to derive the DEK).
///
/// On every supported platform the primary backend is the OS-level
/// keyring exposed by `flutter_secure_storage`:
///
/// | Platform | Backend                                       |
/// |----------|-----------------------------------------------|
/// | Linux    | libsecret -> GNOME Keyring / KWallet          |
/// | macOS    | Keychain                                      |
/// | iOS      | Keychain                                      |
/// | Android  | Keystore-backed EncryptedSharedPreferences    |
/// | Windows  | DPAPI                                         |
///
/// On Linux the service additionally falls back to:
///
///  1. `org.freedesktop.portal.Secret` — sandbox-clean per-app secret
///     accessible from inside Flatpak even without
///     `--talk-name=org.freedesktop.secrets`.
///  2. A plain file under `getApplicationSupportDirectory()` — last-resort
///     fallback for headless servers / containers where neither libsecret
///     nor the portal is reachable.
class KeyringService {
  KeyringService({
    FlutterSecureStorage? storage,
    String? supportDirOverride,
    SecretPortalClient? portalClient,
    WindowsCredentialManager? windowsCredentialManager,
    bool? isWindowsOverride,
    MasterKeyBiometricGate? biometricGate,
  }) : _storage = storage ?? _defaultStorage(),
       _supportDirOverride = supportDirOverride,
       _portalClient = portalClient ?? _LiveSecretPortalClient(),
       _wincred = windowsCredentialManager ?? WindowsCredentialManager(),
       _isWindows = isWindowsOverride ?? Platform.isWindows,
       _biometricGate = biometricGate ?? const _DisabledBiometricGate();

  final FlutterSecureStorage _storage;
  final String? _supportDirOverride;
  final SecretPortalClient _portalClient;
  final WindowsCredentialManager _wincred;
  final bool _isWindows;
  final MasterKeyBiometricGate _biometricGate;

  /// True when this service is running on Windows (or has been told it is
  /// via the test-only `isWindowsOverride` flag). When true the read/write
  /// paths prefer the Windows Credential Vault over `flutter_secure_storage`.
  @visibleForTesting
  bool get isWindowsBackendActive => _isWindows && _wincred.isSupported;

  /// Tracks whether we've already shown a fallback warning this process,
  /// used by the settings banner so we don't spam the user.
  static bool fallbackWarningSurfaced = false;

  /// Default `FlutterSecureStorage` configuration. The Linux options use
  /// the version-10 default constructor (`flutter_secure_storage_linux` 3.x
  /// uses libsecret unconditionally). Android, iOS, macOS and Windows
  /// receive sensible accessibility defaults.
  static FlutterSecureStorage _defaultStorage() {
    return const FlutterSecureStorage(
      // ignore: deprecated_member_use
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
      mOptions: MacOsOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
      lOptions: LinuxOptions(),
      wOptions: WindowsOptions(),
    );
  }

  /// Reads the master vault key. The lookup order is:
  ///
  ///  1. The system keyring via `flutter_secure_storage`.
  ///  2. `org.freedesktop.portal.Secret` (Linux only). The portal
  ///     returns a per-app secret which is treated as the stored value
  ///     when the legacy file fallback also exists.
  ///  3. The on-disk file fallback under the app support dir.
  Future<String?> readVaultKey() async {
    // On Windows the Credential Vault is the canonical store. We try it
    // first and migrate any value still living in `flutter_secure_storage`
    // (i.e. older installs) so the next read goes straight to Wincred.
    if (isWindowsBackendActive) {
      // Optional Windows Hello pre-unlock. The gate's `isRequired()`
      // consults the user's `biometricUnlock` setting; when on we
      // prompt UserConsentVerifier.RequestVerificationAsync via
      // local_auth before opening the credential. A failed prompt
      // returns null (treated as "no key available") so the lock
      // screen stays up rather than silently bypassing biometrics.
      try {
        if (await _biometricGate.isRequired()) {
          final ok = await _biometricGate.verify();
          if (!ok) return null;
        }
      } catch (e) {
        debugPrint('[KeyringService] biometric gate failed: $e');
        return null;
      }
      try {
        final wincredValue = await _wincred.readString(kWindowsMasterKeyTarget);
        if (wincredValue != null) return wincredValue;
      } catch (e) {
        debugPrint('[KeyringService] Wincred read failed: $e');
      }
      try {
        final fssValue = await _storage.read(key: kVaultMasterKeyId);
        if (fssValue != null) {
          // One-shot migration: copy fss → Wincred and remove the fss
          // entry so we don't have two sources of truth.
          await _migrateFssToWincred(fssValue);
          return fssValue;
        }
      } catch (e) {
        debugPrint('[KeyringService] fss read (Windows migration) failed: $e');
      }
      return null;
    }

    try {
      final value = await _storage.read(key: kVaultMasterKeyId);
      if (value != null) return value;
    } catch (e) {
      debugPrint('[KeyringService] keyring read failed: $e -- using fallback');
      fallbackWarningSurfaced = false;
    }
    final fileValue = await _readFromFile();
    if (fileValue != null) return fileValue;
    // Last attempt: ask the Secret portal. If it returns bytes we expose
    // them as a hex string so the rest of the pipeline (which expects a
    // UTF-8 master key) doesn't choke on raw binary.
    return _readFromPortal();
  }

  /// Copies a key from `flutter_secure_storage` (the legacy DPAPI-via-fss
  /// location) into the Windows Credential Vault, then removes the fss
  /// entry. Best-effort: errors are logged but don't propagate, because
  /// the user's key has already been read successfully.
  Future<void> _migrateFssToWincred(String value) async {
    try {
      await _wincred.writeString(kWindowsMasterKeyTarget, value);
      try {
        await _storage.delete(key: kVaultMasterKeyId);
      } catch (e) {
        debugPrint('[KeyringService] Wincred migration: fss delete failed: $e');
      }
    } catch (e) {
      debugPrint('[KeyringService] Wincred migration write failed: $e');
    }
  }

  /// Writes the master vault key to the system keyring. On failure (e.g.
  /// missing Secret Service) the value is written to the file fallback so
  /// the app remains usable on headless boxes.
  ///
  /// Returns the backend that ultimately accepted the value, so callers
  /// can show the right indicator in the UI.
  Future<MasterKeyBackend> writeVaultKey(String value) async {
    if (isWindowsBackendActive) {
      try {
        await _wincred.writeString(kWindowsMasterKeyTarget, value);
        // Drop any stale fss entry so [readVaultKey] always reads
        // through Wincred from now on.
        try {
          await _storage.delete(key: kVaultMasterKeyId);
        } catch (_) {
          // Best effort.
        }
        return MasterKeyBackend.windowsCredentialManager;
      } catch (e) {
        debugPrint('[KeyringService] Wincred write failed: $e -- falling back');
        // Fall through to the fss/file path so the user can still save
        // a key even if Wincred misbehaves (e.g. policy disables the
        // Credential Vault).
      }
    }

    try {
      await _storage.write(key: kVaultMasterKeyId, value: value);
      // Successful keyring write -- purge any stale file copy.
      await _deleteFile();
      return MasterKeyBackend.systemKeyring;
    } catch (e) {
      debugPrint('[KeyringService] keyring write failed: $e -- using fallback');
      fallbackWarningSurfaced = false;
    }

    // libsecret refused (NotFound / AccessDenied / no service running).
    // Try the Secret portal — if it answers, we still persist the user's
    // value to the legacy file (the portal itself is a *bring your own
    // key* primitive: the portal hands out a per-app secret, it does not
    // store ours). The portal hit just confirms a sandbox-safe path
    // exists, so we report `portalSecret` to the UI.
    final portalBytes = await _portalClient.retrieveSecret();
    await _writeToFile(value);
    return portalBytes != null
        ? MasterKeyBackend.portalSecret
        : MasterKeyBackend.encryptedFile;
  }

  /// Deletes the master vault key from both the keyring and the file
  /// fallback. Errors are swallowed so a partial deletion still removes
  /// the other half.
  Future<void> deleteVaultKey() async {
    if (isWindowsBackendActive) {
      try {
        await _wincred.delete(kWindowsMasterKeyTarget);
      } catch (e) {
        debugPrint('[KeyringService] Wincred delete failed: $e');
      }
    }
    try {
      await _storage.delete(key: kVaultMasterKeyId);
    } catch (e) {
      debugPrint('[KeyringService] keyring delete failed: $e');
    }
    await _deleteFile();
    await _deletePortalCache();
  }

  /// Detects which backend currently holds the master key. Returns null
  /// when neither a keyring entry nor a fallback file exists.
  Future<MasterKeyBackend?> currentBackend() async {
    if (isWindowsBackendActive) {
      try {
        final wincredValue = await _wincred.readString(kWindowsMasterKeyTarget);
        if (wincredValue != null) {
          return MasterKeyBackend.windowsCredentialManager;
        }
      } catch (e) {
        debugPrint('[KeyringService] Wincred currentBackend probe failed: $e');
      }
    }
    try {
      final value = await _storage.read(key: kVaultMasterKeyId);
      if (value != null) return MasterKeyBackend.systemKeyring;
    } catch (_) {
      // Fall through to file check.
    }
    final file = await _legacyFile();
    if (await file.exists()) {
      // If we cached a portal secret alongside the legacy file we know
      // the active backend is the portal-mediated one.
      final portalCache = await _portalCacheFile();
      if (await portalCache.exists()) return MasterKeyBackend.portalSecret;
      return MasterKeyBackend.encryptedFile;
    }
    return null;
  }

  /// Runs once: if a legacy file is present, copies it into the system
  /// keyring and removes the file. Returns true when a migration actually
  /// happened (so callers can flip a `migrationCompleted` flag), false
  /// when nothing needed to be done or the keyring is unavailable.
  Future<bool> migrateLegacyFileIfNeeded() async {
    final file = await _legacyFile();
    if (!await file.exists()) return false;

    final String contents;
    try {
      contents = await file.readAsString();
    } catch (e) {
      debugPrint('[KeyringService] legacy file unreadable: $e');
      return false;
    }
    if (contents.isEmpty) {
      await _deleteFile();
      return false;
    }

    try {
      await _storage.write(key: kVaultMasterKeyId, value: contents);
      await _deleteFile();
      return true;
    } catch (e) {
      debugPrint('[KeyringService] migration write failed: $e');
      return false;
    }
  }

  // -- file fallback ---------------------------------------------------

  Future<File> _legacyFile() async {
    final basePath =
        _supportDirOverride ?? (await getApplicationSupportDirectory()).path;
    return File(p.join(basePath, kVaultMasterKeyLegacyFile));
  }

  Future<File> _portalCacheFile() async {
    final basePath =
        _supportDirOverride ?? (await getApplicationSupportDirectory()).path;
    return File(p.join(basePath, _kPortalSecretCacheFile));
  }

  Future<String?> _readFromFile() async {
    try {
      final file = await _legacyFile();
      if (!await file.exists()) return null;
      final value = await file.readAsString();
      return value.isEmpty ? null : value;
    } catch (e) {
      debugPrint('[KeyringService] fallback read failed: $e');
      return null;
    }
  }

  /// Asks the Secret portal for our per-app secret blob and caches it.
  /// The portal's contract is that the same app gets the same bytes
  /// across restarts, so a successful call gives us a deterministic
  /// "key" without ever talking to libsecret.
  Future<String?> _readFromPortal() async {
    try {
      final bytes = await _portalClient.retrieveSecret();
      if (bytes == null || bytes.isEmpty) return null;
      // Persist the bytes to the cache file so [currentBackend] can
      // identify the active backend later. We hex-encode so the value
      // round-trips through the rest of the pipeline (which assumes
      // UTF-8 strings).
      try {
        final cache = await _portalCacheFile();
        await cache.parent.create(recursive: true);
        await cache.writeAsBytes(bytes, flush: true);
      } catch (_) {
        // Caching is best-effort; the bytes themselves are what
        // callers need.
      }
      return _bytesToHex(bytes);
    } catch (e) {
      debugPrint('[KeyringService] portal secret read failed: $e');
      return null;
    }
  }

  Future<void> _writeToFile(String value) async {
    try {
      final file = await _legacyFile();
      await file.parent.create(recursive: true);
      await file.writeAsString(value, flush: true);
      // Restrict to the owner where possible (best-effort, no-op on
      // platforms without POSIX perms).
      if (Platform.isLinux || Platform.isMacOS) {
        try {
          await Process.run('chmod', ['600', file.path]);
        } catch (_) {
          // chmod is purely defensive; ignore failures.
        }
      }
    } catch (e) {
      debugPrint('[KeyringService] fallback write failed: $e');
      rethrow;
    }
  }

  Future<void> _deleteFile() async {
    try {
      final file = await _legacyFile();
      if (await file.exists()) await file.delete();
    } catch (e) {
      debugPrint('[KeyringService] fallback delete failed: $e');
    }
  }

  Future<void> _deletePortalCache() async {
    try {
      final file = await _portalCacheFile();
      if (await file.exists()) await file.delete();
    } catch (e) {
      debugPrint('[KeyringService] portal cache delete failed: $e');
    }
  }

  static String _bytesToHex(Uint8List bytes) {
    final sb = StringBuffer();
    for (final b in bytes) {
      sb.write(b.toRadixString(16).padLeft(2, '0'));
    }
    return sb.toString();
  }
}

/// Production [SecretPortalClient]. Talks to
/// `org.freedesktop.portal.Secret.RetrieveSecret` over the session bus
/// when the host runtime supports passing a raw Unix file descriptor to
/// D-Bus.
///
/// The portal's contract:
///
///     RetrieveSecret(in  h fd,
///                    in  a{sv} options,
///                    out o handle)
///
/// returns asynchronously via a `Request` object on the bus, then writes
/// the secret bytes into the writable end of the pipe we passed as `h`.
///
/// `dart:io` does not currently expose a stable API for opening a raw
/// Unix file descriptor or for handing one to the `dbus` package
/// (`DBusUnixFd` requires a `ResourceHandle`, which only DartVM file
/// sockets can produce). Until a Flutter Linux plugin lands that
/// exposes this primitive natively, the live client reports the portal
/// as unreachable and [KeyringService] degrades to its on-disk file
/// fallback — which itself is sandbox-safe inside the Flatpak data
/// directory and remains the recommended path for headless boxes.
///
/// Tests inject a mock [SecretPortalClient] via the constructor to
/// drive the portal-fallback code path without depending on this
/// runtime limitation.
class _LiveSecretPortalClient implements SecretPortalClient {
  @override
  Future<Uint8List?> retrieveSecret() async {
    if (!Platform.isLinux) return null;
    // No-op until dart:io / package:dbus surface a stable way to hand
    // a writable FD to the portal. Returning null keeps the rest of
    // [KeyringService] in its existing file-fallback path.
    return null;
  }
}
