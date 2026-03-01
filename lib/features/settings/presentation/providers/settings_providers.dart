import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pointycastle/export.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/services/logging_service.dart';
import 'package:shellvault/core/storage/database_provider.dart';
import 'package:shellvault/features/settings/domain/entities/app_settings_entity.dart';

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

  @override
  Future<AppSettingsEntity> build() async {
    final dao = ref.watch(databaseProvider).appSettingsDao;

    final themeStr = await dao.getValue(_keyThemeMode);
    final portStr = await dao.getValue(_keyDefaultSshPort);
    final username = await dao.getValue(_keyDefaultUsername);
    final autoLockStr = await dao.getValue(_keyAutoLockMinutes);
    final biometricStr = await dao.getValue(_keyBiometricUnlock);
    final encryptStr = await dao.getValue(_keyEncryptExportDefault);
    final pinHash = await dao.getValue(_keyPinHash);
    final pinSalt = await dao.getValue(_keyPinSalt);
    final dismissedHint = await dao.getValue(_keyDismissedSecurityHint);
    final locale = await dao.getValue(_keyLocale);
    final failedAttemptsStr = await dao.getValue(_keyFailedAttempts);
    final lockoutUntilStr = await dao.getValue(_keyLockoutUntil);

    // Migrate legacy plaintext PIN to hash if present
    final legacyPin = await dao.getValue('pin_code');
    if (legacyPin != null && legacyPin.isNotEmpty && (pinHash == null || pinHash.isEmpty)) {
      final hashResult = _hashPin(legacyPin);
      await dao.setValue(_keyPinHash, hashResult.hash);
      await dao.setValue(_keyPinSalt, hashResult.salt);
      await dao.deleteValue('pin_code');

      return AppSettingsEntity(
        themeMode: _parseThemeMode(themeStr),
        defaultSshPort: int.tryParse(portStr ?? '') ?? 22,
        defaultUsername: username ?? 'root',
        autoLockMinutes: int.tryParse(autoLockStr ?? '') ?? 5,
        biometricUnlock: biometricStr == 'true',
        encryptExportByDefault: encryptStr != 'false',
        pinHash: hashResult.hash,
        pinSalt: hashResult.salt,
        dismissedSecurityHint: dismissedHint == 'true',
        locale: locale ?? '',
        failedPinAttempts: int.tryParse(failedAttemptsStr ?? '') ?? 0,
        lockoutUntil: _parseLockoutUntil(lockoutUntilStr),
      );
    }

    return AppSettingsEntity(
      themeMode: _parseThemeMode(themeStr),
      defaultSshPort: int.tryParse(portStr ?? '') ?? 22,
      defaultUsername: username ?? 'root',
      autoLockMinutes: int.tryParse(autoLockStr ?? '') ?? 5,
      biometricUnlock: biometricStr == 'true',
      encryptExportByDefault: encryptStr != 'false',
      pinHash: pinHash ?? '',
      pinSalt: pinSalt ?? '',
      dismissedSecurityHint: dismissedHint == 'true',
      locale: locale ?? '',
      failedPinAttempts: int.tryParse(failedAttemptsStr ?? '') ?? 0,
      lockoutUntil: _parseLockoutUntil(lockoutUntilStr),
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
  _PinHashResult _hashPin(String pin, {Uint8List? existingSalt}) {
    final Uint8List salt;
    if (existingSalt != null) {
      salt = existingSalt;
    } else {
      final rng = Random.secure();
      salt = Uint8List.fromList(
        List.generate(AppConstants.saltLength, (_) => rng.nextInt(256)),
      );
    }

    final argon2 = Argon2BytesGenerator();
    final params = Argon2Parameters(
      Argon2Parameters.ARGON2_id,
      salt,
      desiredKeyLength: 32,
      iterations: AppConstants.argon2Iterations,
      memory: AppConstants.argon2MemoryKB,
      lanes: AppConstants.argon2Parallelism,
    );
    argon2.init(params);

    final hash = Uint8List(32);
    argon2.deriveKey(Uint8List.fromList(utf8.encode(pin)), 0, hash, 0);

    return _PinHashResult(
      hash: base64Encode(hash),
      salt: base64Encode(salt),
    );
  }

  /// Verifies a PIN against stored hash and salt with brute-force protection.
  /// Returns true on success, false on failure. Tracks failed attempts and
  /// triggers lockout after [AppConstants.maxPinAttempts] failures.
  Future<bool> verifyPin(String pin) async {
    final current = state.valueOrNull;
    if (current == null || !current.hasPin) return false;

    // Check lockout
    if (current.isLockedOut) return false;

    final salt = base64Decode(current.pinSalt);
    final result = _hashPin(pin, existingSalt: salt);

    final dao = ref.read(databaseProvider).appSettingsDao;

    if (result.hash == current.pinHash) {
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
    _log.info(_tag, 'Encrypt export default ${enabled ? 'enabled' : 'disabled'}');
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyEncryptExportDefault, enabled.toString());
    ref.invalidateSelf();
  }

  /// Sets a new PIN code (app-level lock only, no database encryption).
  Future<void> setPinCode(String pin) async {
    _log.info(_tag, 'PIN code set');
    final dao = ref.read(databaseProvider).appSettingsDao;
    final hashResult = _hashPin(pin);

    await dao.setValue(_keyPinHash, hashResult.hash);
    await dao.setValue(_keyPinSalt, hashResult.salt);

    ref.invalidateSelf();
  }

  /// Clears the PIN code and disables biometric unlock.
  Future<void> clearPinCode() async {
    _log.info(_tag, 'PIN code removed');
    final dao = ref.read(databaseProvider).appSettingsDao;

    // Clear PIN hash and salt
    await dao.setValue(_keyPinHash, '');
    await dao.setValue(_keyPinSalt, '');

    // Disable biometric unlock (requires PIN)
    await dao.setValue(_keyBiometricUnlock, 'false');

    ref.invalidateSelf();
  }

  /// No-op — field encryption has been removed.
  /// Kept for API compatibility with lock screen.
  Future<void> loadDekAfterUnlock() async {
    // No-op: field-level encryption removed
    return;
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
}

class _PinHashResult {
  final String hash;
  final String salt;
  const _PinHashResult({required this.hash, required this.salt});
}
