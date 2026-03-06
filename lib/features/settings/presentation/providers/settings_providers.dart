import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart' as crypto;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/crypto/crypto_utils.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/core/storage/database_provider.dart';
import 'package:sshvault/core/storage/secure_storage_provider.dart';
import 'package:sshvault/features/settings/domain/entities/app_settings_entity.dart';

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettingsEntity>(
      SettingsNotifier.new,
    );

class SettingsNotifier extends AsyncNotifier<AppSettingsEntity> {
  static const _tag = 'Settings';
  final _log = LoggingService.instance;

  static const _keyThemeMode = 'theme_mode';
  static const _keyDefaultSshPort = 'default_ssh_port';
  static const _keyDefaultUsername = 'default_username';
  static const _keyAutoLockMinutes = 'auto_lock_minutes';
  static const _keyBiometricUnlock = 'biometric_unlock';
  static const _keyEncryptExportDefault = 'encrypt_export_default';
  static const _keyPinHash = 'pin_hash';
  static const _keyPinSalt = 'pin_salt';
  static const _keyDismissedSecurityHint = 'dismissed_security_hint';
  static const _keyLocale = 'locale';
  static const _keyFailedAttempts = 'failed_pin_attempts';
  static const _keyLockoutUntil = 'lockout_until';
  static const _keyServerUrl = 'server_url';
  static const _keySelfHosted = 'self_hosted';
  static const _keyAutoSync = 'auto_sync';
  static const _keyAutoSyncInterval = 'auto_sync_interval';
  static const _keyLocalVaultVersion = 'local_vault_version';
  static const _keyPreventScreenshots = 'prevent_screenshots';
  static const _keyDnsServers = 'dns_servers';
  static const _keyDefaultAuthMethod = 'default_auth_method';
  static const _keyConnectionTimeout = 'connection_timeout_secs';
  static const _keyKeepaliveInterval = 'keepalive_interval_secs';
  static const _keySshCompression = 'ssh_compression';
  static const _keyDefaultTerminalType = 'default_terminal_type';
  static const _keyClipboardAutoClear = 'clipboard_auto_clear_secs';
  static const _keySessionTimeout = 'session_timeout_mins';
  static const _keyDuressPinHash = 'duress_pin_hash';
  static const _keyDuressPinSalt = 'duress_pin_salt';
  static const _keyKeyRotationReminder = 'key_rotation_reminder_days';
  static const _keyGlobalProxyType = 'global_proxy_type';
  static const _keyGlobalProxyHost = 'global_proxy_host';
  static const _keyGlobalProxyPort = 'global_proxy_port';
  static const _keyGlobalProxyUsername = 'global_proxy_username';

  // Secure storage keys for PIN-related secrets
  static const _secKeyPinHash = 'settings_pin_hash';
  static const _secKeyPinSalt = 'settings_pin_salt';
  static const _secKeyDuressPinHash = 'settings_duress_pin_hash';
  static const _secKeyDuressPinSalt = 'settings_duress_pin_salt';

  @override
  Future<AppSettingsEntity> build() async {
    final dao = ref.watch(databaseProvider).appSettingsDao;
    final secureStorage = ref.watch(secureStorageProvider);

    // Single query instead of 17+ sequential reads
    final all = await dao.getAll();

    // Read PIN secrets from secure storage
    final secPinHash = await _readSecure(secureStorage, _secKeyPinHash);
    final secPinSalt = await _readSecure(secureStorage, _secKeyPinSalt);
    final secDuressPinHash = await _readSecure(
      secureStorage,
      _secKeyDuressPinHash,
    );
    final secDuressPinSalt = await _readSecure(
      secureStorage,
      _secKeyDuressPinSalt,
    );

    // Migrate PIN data from database to secure storage if needed
    final dbPinHash = all[_keyPinHash];
    final dbPinSalt = all[_keyPinSalt];
    final dbDuressPinHash = all[_keyDuressPinHash];
    final dbDuressPinSalt = all[_keyDuressPinSalt];

    String pinHash = secPinHash;
    String pinSalt = secPinSalt;
    String duressPinHash = secDuressPinHash;
    String duressPinSalt = secDuressPinSalt;

    // Migrate legacy plaintext PIN to hash if present
    final legacyPin = all['pin_code'];
    if (legacyPin != null &&
        legacyPin.isNotEmpty &&
        pinHash.isEmpty &&
        (dbPinHash == null || dbPinHash.isEmpty)) {
      final hashResult = await _hashPin(legacyPin);
      await secureStorage.write(key: _secKeyPinHash, value: hashResult.hash);
      await secureStorage.write(key: _secKeyPinSalt, value: hashResult.salt);
      await dao.deleteValue('pin_code');
      pinHash = hashResult.hash;
      pinSalt = hashResult.salt;
    }

    // Migrate existing PIN hash/salt from DB to secure storage
    if (pinHash.isEmpty && dbPinHash != null && dbPinHash.isNotEmpty) {
      await secureStorage.write(key: _secKeyPinHash, value: dbPinHash);
      await secureStorage.write(key: _secKeyPinSalt, value: dbPinSalt ?? '');
      await dao.setValue(_keyPinHash, '');
      await dao.setValue(_keyPinSalt, '');
      pinHash = dbPinHash;
      pinSalt = dbPinSalt ?? '';
      _log.info(_tag, 'Migrated PIN hash to secure storage');
    }

    // Migrate existing duress PIN hash/salt from DB to secure storage
    if (duressPinHash.isEmpty &&
        dbDuressPinHash != null &&
        dbDuressPinHash.isNotEmpty) {
      await secureStorage.write(
        key: _secKeyDuressPinHash,
        value: dbDuressPinHash,
      );
      await secureStorage.write(
        key: _secKeyDuressPinSalt,
        value: dbDuressPinSalt ?? '',
      );
      await dao.setValue(_keyDuressPinHash, '');
      await dao.setValue(_keyDuressPinSalt, '');
      duressPinHash = dbDuressPinHash;
      duressPinSalt = dbDuressPinSalt ?? '';
      _log.info(_tag, 'Migrated duress PIN hash to secure storage');
    }

    return _buildEntity(
      all,
      pinHash: pinHash,
      pinSalt: pinSalt,
      duressPinHash: duressPinHash,
      duressPinSalt: duressPinSalt,
    );
  }

  /// Reads a value from secure storage, returning empty string on failure.
  Future<String> _readSecure(dynamic secureStorage, String key) async {
    try {
      final result = await secureStorage.read(key: key);
      return result ?? '';
    } catch (_) {
      return '';
    }
  }

  AppSettingsEntity _buildEntity(
    Map<String, String> all, {
    String? pinHash,
    String? pinSalt,
    String? duressPinHash,
    String? duressPinSalt,
  }) {
    return AppSettingsEntity(
      themeMode: _parseThemeMode(all[_keyThemeMode]),
      defaultSshPort: int.tryParse(all[_keyDefaultSshPort] ?? '') ?? 22,
      defaultUsername: all[_keyDefaultUsername] ?? 'root',
      autoLockMinutes: int.tryParse(all[_keyAutoLockMinutes] ?? '') ?? 5,
      biometricUnlock: all[_keyBiometricUnlock] == 'true',
      encryptExportByDefault: all[_keyEncryptExportDefault] != 'false',
      pinHash: pinHash ?? '',
      pinSalt: pinSalt ?? '',
      dismissedSecurityHint: all[_keyDismissedSecurityHint] == 'true',
      locale: all[_keyLocale] ?? '',
      failedPinAttempts: int.tryParse(all[_keyFailedAttempts] ?? '') ?? 0,
      lockoutUntil: _parseLockoutUntil(all[_keyLockoutUntil]),
      serverUrl: all[_keyServerUrl] ?? '',
      selfHosted: all[_keySelfHosted] == 'true',
      autoSync: all[_keyAutoSync] != 'false',
      autoSyncIntervalMinutes:
          int.tryParse(all[_keyAutoSyncInterval] ?? '') ?? 5,
      localVaultVersion: int.tryParse(all[_keyLocalVaultVersion] ?? '') ?? 0,
      preventScreenshots: all[_keyPreventScreenshots] == 'true',
      dnsServers: all[_keyDnsServers] ?? '',
      defaultAuthMethod: all[_keyDefaultAuthMethod] ?? 'password',
      connectionTimeoutSecs:
          int.tryParse(all[_keyConnectionTimeout] ?? '') ?? 30,
      keepaliveIntervalSecs:
          int.tryParse(all[_keyKeepaliveInterval] ?? '') ?? 15,
      sshCompression: all[_keySshCompression] == 'true',
      defaultTerminalType: all[_keyDefaultTerminalType] ?? 'xterm-256color',
      clipboardAutoClearSecs:
          int.tryParse(all[_keyClipboardAutoClear] ?? '') ?? 0,
      sessionTimeoutMins: int.tryParse(all[_keySessionTimeout] ?? '') ?? 0,
      duressPinHash: duressPinHash ?? '',
      duressPinSalt: duressPinSalt ?? '',
      keyRotationReminderDays:
          int.tryParse(all[_keyKeyRotationReminder] ?? '') ?? 0,
      globalProxyType: all[_keyGlobalProxyType] ?? 'none',
      globalProxyHost: all[_keyGlobalProxyHost] ?? '',
      globalProxyPort: int.tryParse(all[_keyGlobalProxyPort] ?? '') ?? 1080,
      globalProxyUsername: all[_keyGlobalProxyUsername] ?? '',
    );
  }

  ThemeMode _parseThemeMode(String? value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  String _themeModeToString(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
  }

  DateTime? _parseLockoutUntil(String? value) {
    if (value == null || value.isEmpty) return null;
    final ms = int.tryParse(value);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  /// Hashes a PIN with Argon2id. Returns the hash and salt as base64 strings.
  ///
  /// Uses the `cryptography` package for deterministic key derivation
  /// (pointycastle's Argon2id with lanes>1 is non-deterministic).
  Future<_PinHashResult> _hashPin(String pin, {Uint8List? existingSalt}) async {
    final Uint8List salt;
    if (existingSalt != null) {
      salt = existingSalt;
    } else {
      salt = CryptoUtils.secureRandomBytes(AppConstants.saltLength);
    }

    final argon2 = crypto.Argon2id(
      memory: AppConstants.argon2MemoryKB,
      iterations: AppConstants.argon2Iterations,
      parallelism: AppConstants.argon2Parallelism,
      hashLength: 32,
    );

    final secretKey = await argon2.deriveKey(
      secretKey: crypto.SecretKey(utf8.encode(pin)),
      nonce: salt,
    );
    final hashBytes = Uint8List.fromList(await secretKey.extractBytes());

    final result = _PinHashResult(
      hash: base64Encode(hashBytes),
      salt: base64Encode(salt),
    );

    CryptoUtils.zeroMemory(salt);
    CryptoUtils.zeroMemory(hashBytes);

    return result;
  }

  /// Verifies a PIN against stored hash and salt with brute-force protection.
  /// Returns true on success, false on failure. Tracks failed attempts and
  /// triggers lockout after [AppConstants.maxPinAttempts] failures.
  Future<bool> verifyPin(String pin) async {
    final current = state.value;
    if (current == null || !current.hasPin) return false;

    // Check lockout
    if (current.isLockedOut) return false;

    final salt = base64Decode(current.pinSalt);
    final result = await _hashPin(pin, existingSalt: salt);

    final dao = ref.read(databaseProvider).appSettingsDao;

    if (CryptoUtils.constantTimeStringEquals(result.hash, current.pinHash)) {
      // Reset failed attempts on success
      await dao.setValue(_keyFailedAttempts, '0');
      await dao.deleteValue(_keyLockoutUntil);
      ref.invalidateSelf();
      return true;
    }

    // Increment failed attempts
    final newAttempts = current.failedPinAttempts + 1;
    await dao.setValue(_keyFailedAttempts, newAttempts.toString());

    if (newAttempts >= AppConstants.maxPinAttempts) {
      final lockoutUntil = DateTime.now().add(
        const Duration(seconds: AppConstants.lockoutDurationSeconds),
      );
      await dao.setValue(
        _keyLockoutUntil,
        lockoutUntil.millisecondsSinceEpoch.toString(),
      );
    }

    ref.invalidateSelf();
    return false;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _log.info(_tag, 'Theme changed to ${_themeModeToString(mode)}');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyThemeMode, _themeModeToString(mode));
    ref.invalidateSelf();
  }

  Future<void> setDefaultSshPort(int port) async {
    _log.info(_tag, 'Default SSH port changed to $port');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyDefaultSshPort, port.toString());
    ref.invalidateSelf();
  }

  Future<void> setDefaultUsername(String username) async {
    _log.info(_tag, 'Default username changed');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyDefaultUsername, username);
    ref.invalidateSelf();
  }

  Future<void> setAutoLockMinutes(int minutes) async {
    _log.info(_tag, 'Auto-lock timeout changed to $minutes minutes');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyAutoLockMinutes, minutes.toString());
    ref.invalidateSelf();
  }

  Future<void> setBiometricUnlock(bool enabled) async {
    _log.info(_tag, 'Biometric unlock ${enabled ? 'enabled' : 'disabled'}');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyBiometricUnlock, enabled.toString());
    ref.invalidateSelf();
  }

  Future<void> setEncryptExportByDefault(bool enabled) async {
    _log.info(
      _tag,
      'Encrypt export default ${enabled ? 'enabled' : 'disabled'}',
    );
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyEncryptExportDefault, enabled.toString());
    ref.invalidateSelf();
  }

  /// Sets a new PIN code (app-level lock only, no database encryption).
  Future<void> setPinCode(String pin) async {
    _log.info(_tag, 'PIN code set');
    final secureStorage = ref.read(secureStorageProvider);
    final hashResult = await _hashPin(pin);

    await secureStorage.write(key: _secKeyPinHash, value: hashResult.hash);
    await secureStorage.write(key: _secKeyPinSalt, value: hashResult.salt);

    ref.invalidateSelf();
  }

  /// Clears the PIN code and disables biometric unlock.
  Future<void> clearPinCode() async {
    _log.info(_tag, 'PIN code removed');
    final dao = ref.read(databaseProvider).appSettingsDao;
    final secureStorage = ref.read(secureStorageProvider);

    // Clear PIN hash and salt from secure storage
    await secureStorage.delete(key: _secKeyPinHash);
    await secureStorage.delete(key: _secKeyPinSalt);

    // Also clear any remnants from database (migration cleanup)
    await dao.setValue(_keyPinHash, '');
    await dao.setValue(_keyPinSalt, '');

    // Disable biometric unlock (requires PIN)
    await dao.setValue(_keyBiometricUnlock, 'false');

    ref.invalidateSelf();
  }

  Future<void> setDismissedSecurityHint(bool dismissed) async {
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyDismissedSecurityHint, dismissed.toString());
    ref.invalidateSelf();
  }

  Future<void> setLocale(String locale) async {
    _log.info(_tag, 'Locale changed to ${locale.isEmpty ? 'system' : locale}');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyLocale, locale);
    ref.invalidateSelf();
  }

  Future<void> setServerUrl(String url) async {
    _log.info(_tag, 'Server URL changed');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyServerUrl, url);
    ref.invalidateSelf();
  }

  Future<void> setSelfHosted(bool selfHosted) async {
    _log.info(_tag, 'Self-hosted ${selfHosted ? 'enabled' : 'disabled'}');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keySelfHosted, selfHosted.toString());
    ref.invalidateSelf();
  }

  Future<void> setAutoSync(bool enabled) async {
    _log.info(_tag, 'Auto-sync ${enabled ? 'enabled' : 'disabled'}');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyAutoSync, enabled.toString());
    ref.invalidateSelf();
  }

  Future<void> setAutoSyncInterval(int minutes) async {
    _log.info(_tag, 'Auto-sync interval changed to ${minutes}m');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyAutoSyncInterval, minutes.toString());
    ref.invalidateSelf();
  }

  Future<void> setLocalVaultVersion(int version) async {
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyLocalVaultVersion, version.toString());
    ref.invalidateSelf();
  }

  Future<void> setPreventScreenshots(bool enabled) async {
    _log.info(_tag, 'Prevent screenshots ${enabled ? 'enabled' : 'disabled'}');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyPreventScreenshots, enabled.toString());
    ref.invalidateSelf();
  }

  Future<void> setDnsServers(String servers) async {
    _log.info(_tag, 'DNS servers changed');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyDnsServers, servers);
    ref.invalidateSelf();
  }

  Future<void> setDefaultAuthMethod(String method) async {
    _log.info(_tag, 'Default auth method changed to $method');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyDefaultAuthMethod, method);
    ref.invalidateSelf();
  }

  Future<void> setConnectionTimeout(int seconds) async {
    _log.info(_tag, 'Connection timeout changed to ${seconds}s');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyConnectionTimeout, seconds.toString());
    ref.invalidateSelf();
  }

  Future<void> setKeepaliveInterval(int seconds) async {
    _log.info(_tag, 'Keepalive interval changed to ${seconds}s');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyKeepaliveInterval, seconds.toString());
    ref.invalidateSelf();
  }

  Future<void> setSshCompression(bool enabled) async {
    _log.info(_tag, 'SSH compression ${enabled ? 'enabled' : 'disabled'}');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keySshCompression, enabled.toString());
    ref.invalidateSelf();
  }

  Future<void> setDefaultTerminalType(String type) async {
    _log.info(_tag, 'Default terminal type changed to $type');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyDefaultTerminalType, type);
    ref.invalidateSelf();
  }

  Future<void> setClipboardAutoClear(int seconds) async {
    _log.info(_tag, 'Clipboard auto-clear changed to ${seconds}s');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyClipboardAutoClear, seconds.toString());
    ref.invalidateSelf();
  }

  Future<void> setSessionTimeout(int minutes) async {
    _log.info(_tag, 'Session timeout changed to ${minutes}m');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keySessionTimeout, minutes.toString());
    ref.invalidateSelf();
  }

  Future<void> setDuressPin(String pin) async {
    _log.info(_tag, 'Duress PIN set');
    final secureStorage = ref.read(secureStorageProvider);
    final hashResult = await _hashPin(pin);
    await secureStorage.write(
      key: _secKeyDuressPinHash,
      value: hashResult.hash,
    );
    await secureStorage.write(
      key: _secKeyDuressPinSalt,
      value: hashResult.salt,
    );
    ref.invalidateSelf();
  }

  Future<void> clearDuressPin() async {
    _log.info(_tag, 'Duress PIN removed');
    final dao = ref.read(databaseProvider).appSettingsDao;
    final secureStorage = ref.read(secureStorageProvider);

    // Clear from secure storage
    await secureStorage.delete(key: _secKeyDuressPinHash);
    await secureStorage.delete(key: _secKeyDuressPinSalt);

    // Also clear any remnants from database (migration cleanup)
    await dao.setValue(_keyDuressPinHash, '');
    await dao.setValue(_keyDuressPinSalt, '');
    ref.invalidateSelf();
  }

  Future<bool> verifyDuressPin(String pin) async {
    final current = state.value;
    if (current == null || !current.hasDuressPin) return false;

    final salt = base64Decode(current.duressPinSalt);
    final result = await _hashPin(pin, existingSalt: salt);
    return CryptoUtils.constantTimeStringEquals(
      result.hash,
      current.duressPinHash,
    );
  }

  Future<void> setKeyRotationReminder(int days) async {
    _log.info(_tag, 'Key rotation reminder changed to ${days}d');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyKeyRotationReminder, days.toString());
    ref.invalidateSelf();
  }

  Future<void> setGlobalProxyType(String type) async {
    _log.info(_tag, 'Global proxy type changed to $type');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyGlobalProxyType, type);
    ref.invalidateSelf();
  }

  Future<void> setGlobalProxyHost(String host) async {
    _log.info(_tag, 'Global proxy host changed');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyGlobalProxyHost, host);
    ref.invalidateSelf();
  }

  Future<void> setGlobalProxyPort(int port) async {
    _log.info(_tag, 'Global proxy port changed to $port');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyGlobalProxyPort, port.toString());
    ref.invalidateSelf();
  }

  Future<void> setGlobalProxyUsername(String username) async {
    _log.info(_tag, 'Global proxy username changed');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyGlobalProxyUsername, username);
    ref.invalidateSelf();
  }
}

class _PinHashResult {
  final String hash;
  final String salt;
  const _PinHashResult({required this.hash, required this.salt});
}
