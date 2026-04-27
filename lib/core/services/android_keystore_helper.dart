// Dart-side bridge to the AndroidKeyStore-backed master vault key.
//
// On Android the master vault key is the user's passphrase used to derive
// the data-encryption key. By default `flutter_secure_storage` parks it in
// `EncryptedSharedPreferences`, which is itself encrypted by an
// AndroidKeyStore master key — but that key is implicit, the security
// level is opaque to the app, and there is no way to ask "is StrongBox
// being used?" from Dart.
//
// This helper exposes an explicit AES-256-GCM key under
// `de.kiefer_networks.SSHVault.MasterKey` with StrongBox preferred (Pixel
// 3+, recent Samsung flagships, …) and a TEE fallback for older devices.
// The Flutter side wraps the raw master-key bytes through this key on
// write and unwraps them on read; the wrapped blob lives in a regular
// SharedPreferences file so it can be backed up via Android Auto-Backup
// without leaking the key itself (the key never leaves the keystore).
//
// The matching native code is `AndroidKeystoreHelper.kt`. The channel
// name is mirrored on both sides via [kAndroidKeystoreChannel].
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Shared method-channel name. Kept in a single constant so the Kotlin
/// side and the Dart side cannot drift apart silently — tests assert on
/// this value to flag any rename.
const String kAndroidKeystoreChannel = 'de.kiefer_networks.sshvault/keystore';

/// Stable AndroidKeyStore alias for the master vault key. Reverse-DNS to
/// match the rest of the platform (`kVaultKeyringSchemaName`,
/// `kWindowsMasterKeyTarget`, `kMacosKeychainService`).
const String kAndroidMasterKeyAlias = 'de.kiefer_networks.SSHVault.MasterKey';

/// Reported security level of an AndroidKeyStore key. Mirrors the strings
/// returned by the native side (`AndroidKeystoreHelper.kt`); a separate
/// enum here keeps the Dart consumers (settings UI, diagnostics) on a
/// type-safe surface instead of switching on raw strings.
enum AndroidKeystoreSecurityLevel {
  /// `KeyInfo.SECURITY_LEVEL_STRONGBOX` — the key lives on a discrete
  /// secure element (e.g. Titan M on Pixel devices). Highest assurance
  /// available on Android.
  strongBox,

  /// `KeyInfo.SECURITY_LEVEL_TRUSTED_ENVIRONMENT` — the key lives in
  /// the SoC's TEE (TrustZone / TEE OS). Still hardware-isolated from
  /// the Linux kernel but shares the application processor.
  tee,

  /// `KeyInfo.SECURITY_LEVEL_SOFTWARE` — the key is encrypted and
  /// stored in software only. Treated as a degraded state by the
  /// settings UI: we offer the user a "Re-create with hardware" button
  /// so they can move to TEE/StrongBox if their device gained those
  /// capabilities (e.g. after a factory reset on a previously rooted
  /// device).
  software;

  /// Maps the wire-format string returned by the native helper.
  static AndroidKeystoreSecurityLevel? parse(String? raw) {
    switch (raw) {
      case 'strongbox':
        return AndroidKeystoreSecurityLevel.strongBox;
      case 'tee':
        return AndroidKeystoreSecurityLevel.tee;
      case 'software':
        return AndroidKeystoreSecurityLevel.software;
      default:
        return null;
    }
  }

  /// Human-readable label surfaced in the security settings tile. The
  /// strings are intentionally inline — the master-key storage backend
  /// is a power-user concern and does not yet have l10n entries across
  /// all 28 supported locales.
  String get displayLabel {
    switch (this) {
      case AndroidKeystoreSecurityLevel.strongBox:
        return 'Hardware Security (StrongBox)';
      case AndroidKeystoreSecurityLevel.tee:
        return 'Hardware Security (TEE)';
      case AndroidKeystoreSecurityLevel.software:
        return 'Software Keystore';
    }
  }
}

/// Thrown when the keystore channel is unavailable (non-Android, or the
/// activity has not wired the helper yet). Callers should treat this as
/// "no hardware-backed key available" and fall back to the existing
/// `flutter_secure_storage` path.
class AndroidKeystoreUnavailable implements Exception {
  AndroidKeystoreUnavailable(this.message);
  final String message;

  @override
  String toString() => 'AndroidKeystoreUnavailable: $message';
}

/// Thin client over the `de.kiefer_networks.sshvault/keystore` channel.
///
/// All operations are no-ops on non-Android platforms (return `null` /
/// `false`) so callers can hold an instance unconditionally without a
/// platform branch at the call site.
class AndroidKeystoreHelper {
  AndroidKeystoreHelper({MethodChannel? channel, bool? isAndroidOverride})
    : _channel = channel ?? const MethodChannel(kAndroidKeystoreChannel),
      _isAndroid = isAndroidOverride ?? Platform.isAndroid;

  final MethodChannel _channel;
  final bool _isAndroid;

  /// True when this process is running on Android. Tests inject
  /// `isAndroidOverride: true` together with a mock channel.
  bool get isSupported => _isAndroid;

  /// Provisions an AES-256-GCM key under [alias]. Idempotent: calling
  /// twice with the same alias is a no-op the second time.
  ///
  /// When [requireBiometric] is `true` the key spec is built with
  /// `setUserAuthenticationRequired(true)` so every encrypt/decrypt call
  /// requires a fresh biometric/device-credential prompt. Off by default
  /// because the master key is itself gated by the app's PIN/biometric
  /// flow at a higher level — gating individual encrypt() calls would
  /// double-prompt the user.
  Future<bool> createMasterKey({
    String alias = kAndroidMasterKeyAlias,
    bool requireBiometric = false,
  }) async {
    if (!_isAndroid) return false;
    try {
      final ok = await _channel.invokeMethod<bool>('createMasterKey', {
        'alias': alias,
        'requireBiometric': requireBiometric,
      });
      return ok ?? false;
    } on MissingPluginException catch (e) {
      throw AndroidKeystoreUnavailable(e.message ?? 'channel not registered');
    } on PlatformException catch (e) {
      debugPrint(
        '[AndroidKeystoreHelper] createMasterKey($alias) failed: '
        '${e.code} ${e.message}',
      );
      rethrow;
    }
  }

  /// Reports the security level of [alias]. Returns `null` when the key
  /// does not exist or the platform is not Android.
  Future<AndroidKeystoreSecurityLevel?> securityLevel({
    String alias = kAndroidMasterKeyAlias,
  }) async {
    if (!_isAndroid) return null;
    try {
      final raw = await _channel.invokeMethod<String>('securityLevel', {
        'alias': alias,
      });
      return AndroidKeystoreSecurityLevel.parse(raw);
    } on MissingPluginException {
      return null;
    } on PlatformException catch (e) {
      debugPrint(
        '[AndroidKeystoreHelper] securityLevel($alias) failed: '
        '${e.code} ${e.message}',
      );
      return null;
    }
  }

  /// Removes [alias] from the keystore. Best-effort.
  Future<void> delete({String alias = kAndroidMasterKeyAlias}) async {
    if (!_isAndroid) return;
    try {
      await _channel.invokeMethod<void>('delete', {'alias': alias});
    } on MissingPluginException {
      return;
    } on PlatformException catch (e) {
      debugPrint(
        '[AndroidKeystoreHelper] delete($alias) failed: ${e.code} ${e.message}',
      );
    }
  }

  /// Whether [alias] is present in the AndroidKeyStore.
  Future<bool> exists({String alias = kAndroidMasterKeyAlias}) async {
    if (!_isAndroid) return false;
    try {
      final v = await _channel.invokeMethod<bool>('exists', {'alias': alias});
      return v ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  /// Encrypts [plaintext] under [alias]. Returns the ciphertext blob
  /// (IV-prefixed) ready for at-rest storage. Throws
  /// [AndroidKeystoreUnavailable] off-Android.
  Future<Uint8List> encrypt(
    Uint8List plaintext, {
    String alias = kAndroidMasterKeyAlias,
  }) async {
    if (!_isAndroid) {
      throw AndroidKeystoreUnavailable('encrypt() called on non-Android');
    }
    try {
      final result = await _channel.invokeMethod<Uint8List>('encrypt', {
        'alias': alias,
        'plaintext': plaintext,
      });
      if (result == null) {
        throw AndroidKeystoreUnavailable('encrypt returned null');
      }
      return result;
    } on MissingPluginException catch (e) {
      throw AndroidKeystoreUnavailable(e.message ?? 'channel not registered');
    }
  }

  /// Decrypts [ciphertext] previously produced by [encrypt].
  Future<Uint8List> decrypt(
    Uint8List ciphertext, {
    String alias = kAndroidMasterKeyAlias,
  }) async {
    if (!_isAndroid) {
      throw AndroidKeystoreUnavailable('decrypt() called on non-Android');
    }
    try {
      final result = await _channel.invokeMethod<Uint8List>('decrypt', {
        'alias': alias,
        'ciphertext': ciphertext,
      });
      if (result == null) {
        throw AndroidKeystoreUnavailable('decrypt returned null');
      }
      return result;
    } on MissingPluginException catch (e) {
      throw AndroidKeystoreUnavailable(e.message ?? 'channel not registered');
    }
  }
}
