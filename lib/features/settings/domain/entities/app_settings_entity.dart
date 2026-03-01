import 'package:flutter/material.dart';

class AppSettingsEntity {
  final ThemeMode themeMode;
  final int defaultSshPort;
  final String defaultUsername;
  final int autoLockMinutes;
  final bool biometricUnlock;
  final bool encryptExportByDefault;

  const AppSettingsEntity({
    this.themeMode = ThemeMode.system,
    this.defaultSshPort = 22,
    this.defaultUsername = 'root',
    this.autoLockMinutes = 5,
    this.biometricUnlock = false,
    this.encryptExportByDefault = true,
  });

  AppSettingsEntity copyWith({
    ThemeMode? themeMode,
    int? defaultSshPort,
    String? defaultUsername,
    int? autoLockMinutes,
    bool? biometricUnlock,
    bool? encryptExportByDefault,
  }) {
    return AppSettingsEntity(
      themeMode: themeMode ?? this.themeMode,
      defaultSshPort: defaultSshPort ?? this.defaultSshPort,
      defaultUsername: defaultUsername ?? this.defaultUsername,
      autoLockMinutes: autoLockMinutes ?? this.autoLockMinutes,
      biometricUnlock: biometricUnlock ?? this.biometricUnlock,
      encryptExportByDefault:
          encryptExportByDefault ?? this.encryptExportByDefault,
    );
  }
}
