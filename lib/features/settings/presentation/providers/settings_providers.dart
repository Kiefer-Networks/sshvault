import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pointycastle/export.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/crypto/database_migration_service.dart';
import 'package:shellvault/core/crypto/dek_manager.dart';
import 'package:shellvault/core/crypto/field_crypto_provider.dart';
import 'package:shellvault/core/crypto/field_crypto_service.dart';
import 'package:shellvault/core/storage/database_provider.dart';
import 'package:shellvault/core/storage/secure_storage_provider.dart';
import 'package:shellvault/features/settings/domain/entities/app_settings_entity.dart';

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettingsEntity>(
  SettingsNotifier.new,
);

class SettingsNotifier extends AsyncNotifier<AppSettingsEntity> {
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

    // Migrate legacy plaintext PIN to hash if present
    final legacyPin = await dao.getValue('pin_code');
    if (legacyPin != null && legacyPin.isNotEmpty && (pinHash == null || pinHash.isEmpty)) {
      final hashResult = _hashPin(legacyPin);
      await dao.setValue(_keyPinHash, hashResult.hash);
      await dao.setValue(_keyPinSalt, hashResult.salt);
      await dao.deleteValue('pin_code');

      // Generate DEK if not present
      final dekManager = DekManager(ref.read(secureStorageProvider));
      final hasDek = await dekManager.hasDek();
      if (!hasDek) {
        final dek = await dekManager.generateAndStoreDek();
        final crypto = FieldCryptoService(dek);
        ref.read(fieldCryptoServiceProvider.notifier).state = crypto;

        // Encrypt existing DB data
        final db = ref.read(databaseProvider);
        await DatabaseMigrationService(db).encryptDatabase(crypto);
      }

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

  /// Hashes a PIN with Argon2id. Returns the hash and salt as base64 strings.
  _PinHashResult _hashPin(String pin, {Uint8List? existingSalt}) {
    final Uint8List salt;
    if (existingSalt != null) {
      salt = existingSalt;
    } else {
      final random = SecureRandom('Fortuna');
      random.seed(KeyParameter(
        Uint8List.fromList(
          List.generate(32, (i) => DateTime.now().microsecondsSinceEpoch % 256 ^ i.hashCode),
        ),
      ));
      salt = random.nextBytes(AppConstants.saltLength);
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

  /// Verifies a PIN against stored hash and salt.
  bool verifyPin(String pin) {
    final current = state.valueOrNull;
    if (current == null || !current.hasPin) return false;

    final salt = base64Decode(current.pinSalt);
    final result = _hashPin(pin, existingSalt: salt);
    return result.hash == current.pinHash;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyThemeMode, _themeModeToString(mode));
    ref.invalidateSelf();
  }

  Future<void> setDefaultSshPort(int port) async {
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyDefaultSshPort, port.toString());
    ref.invalidateSelf();
  }

  Future<void> setDefaultUsername(String username) async {
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyDefaultUsername, username);
    ref.invalidateSelf();
  }

  Future<void> setAutoLockMinutes(int minutes) async {
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyAutoLockMinutes, minutes.toString());
    ref.invalidateSelf();
  }

  Future<void> setBiometricUnlock(bool enabled) async {
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyBiometricUnlock, enabled.toString());
    ref.invalidateSelf();
  }

  Future<void> setEncryptExportByDefault(bool enabled) async {
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyEncryptExportDefault, enabled.toString());
    ref.invalidateSelf();
  }

  /// Sets a new PIN, generates DEK, and encrypts the database.
  Future<void> setPinCode(String pin) async {
    final dao = ref.read(databaseProvider).appSettingsDao;
    final hashResult = _hashPin(pin);

    await dao.setValue(_keyPinHash, hashResult.hash);
    await dao.setValue(_keyPinSalt, hashResult.salt);

    // Generate DEK and encrypt database
    final dekManager = DekManager(ref.read(secureStorageProvider));
    final hasDek = await dekManager.hasDek();
    if (!hasDek) {
      final dek = await dekManager.generateAndStoreDek();
      final crypto = FieldCryptoService(dek);
      ref.read(fieldCryptoServiceProvider.notifier).state = crypto;

      final db = ref.read(databaseProvider);
      await DatabaseMigrationService(db).encryptDatabase(crypto);
    }

    ref.invalidateSelf();
  }

  /// Clears the PIN, decrypts the database, deletes the DEK,
  /// and disables biometric unlock.
  Future<void> clearPinCode() async {
    final dao = ref.read(databaseProvider).appSettingsDao;
    final dekManager = DekManager(ref.read(secureStorageProvider));

    // Decrypt database before removing DEK
    final dek = await dekManager.loadDek();
    if (dek != null) {
      final crypto = FieldCryptoService(dek);
      final db = ref.read(databaseProvider);
      await DatabaseMigrationService(db).decryptDatabase(crypto);
    }

    // Remove DEK and disable crypto
    await dekManager.deleteDek();
    ref.read(fieldCryptoServiceProvider.notifier).state = null;

    // Clear PIN hash and salt
    await dao.setValue(_keyPinHash, '');
    await dao.setValue(_keyPinSalt, '');

    // Disable biometric unlock (requires PIN)
    await dao.setValue(_keyBiometricUnlock, 'false');

    ref.invalidateSelf();
  }

  /// Loads the DEK from secure storage and activates field encryption.
  /// Called after successful PIN/biometric unlock.
  Future<void> loadDekAfterUnlock() async {
    final dekManager = DekManager(ref.read(secureStorageProvider));
    final dek = await dekManager.loadDek();
    if (dek != null) {
      ref.read(fieldCryptoServiceProvider.notifier).state = FieldCryptoService(dek);
    }
  }

  Future<void> setDismissedSecurityHint(bool dismissed) async {
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_keyDismissedSecurityHint, dismissed.toString());
    ref.invalidateSelf();
  }

  Future<void> setLocale(String locale) async {
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
