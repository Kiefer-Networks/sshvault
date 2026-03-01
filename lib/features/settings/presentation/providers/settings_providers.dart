import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/storage/database_provider.dart';
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

  @override
  Future<AppSettingsEntity> build() async {
    final dao = ref.watch(databaseProvider).appSettingsDao;

    final themeStr = await dao.getValue(_keyThemeMode);
    final portStr = await dao.getValue(_keyDefaultSshPort);
    final username = await dao.getValue(_keyDefaultUsername);
    final autoLockStr = await dao.getValue(_keyAutoLockMinutes);
    final biometricStr = await dao.getValue(_keyBiometricUnlock);
    final encryptStr = await dao.getValue(_keyEncryptExportDefault);

    return AppSettingsEntity(
      themeMode: _parseThemeMode(themeStr),
      defaultSshPort: int.tryParse(portStr ?? '') ?? 22,
      defaultUsername: username ?? 'root',
      autoLockMinutes: int.tryParse(autoLockStr ?? '') ?? 5,
      biometricUnlock: biometricStr == 'true',
      encryptExportByDefault: encryptStr != 'false',
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
}
