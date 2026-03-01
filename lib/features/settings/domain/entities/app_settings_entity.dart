import 'package:flutter/material.dart';

class AppSettingsEntity {
  final ThemeMode themeMode;
  final int defaultSshPort;
  final String defaultUsername;
  final int autoLockMinutes;
  final bool biometricUnlock;
  final bool encryptExportByDefault;
  final String pinHash;
  final String pinSalt;
  final bool dismissedSecurityHint;
  final String locale;

  const AppSettingsEntity({
    this.themeMode = ThemeMode.system,
    this.defaultSshPort = 22,
    this.defaultUsername = 'root',
    this.autoLockMinutes = 5,
    this.biometricUnlock = false,
    this.encryptExportByDefault = true,
    this.pinHash = '',
    this.pinSalt = '',
    this.dismissedSecurityHint = false,
    this.locale = '',
  });

  bool get hasPin => pinHash.isNotEmpty;
  bool get hasAnyLock => biometricUnlock || hasPin;

  AppSettingsEntity copyWith({
    ThemeMode? themeMode,
    int? defaultSshPort,
    String? defaultUsername,
    int? autoLockMinutes,
    bool? biometricUnlock,
    bool? encryptExportByDefault,
    String? pinHash,
    String? pinSalt,
    bool? dismissedSecurityHint,
    String? locale,
  }) {
    return AppSettingsEntity(
      themeMode: themeMode ?? this.themeMode,
      defaultSshPort: defaultSshPort ?? this.defaultSshPort,
      defaultUsername: defaultUsername ?? this.defaultUsername,
      autoLockMinutes: autoLockMinutes ?? this.autoLockMinutes,
      biometricUnlock: biometricUnlock ?? this.biometricUnlock,
      encryptExportByDefault:
          encryptExportByDefault ?? this.encryptExportByDefault,
      pinHash: pinHash ?? this.pinHash,
      pinSalt: pinSalt ?? this.pinSalt,
      dismissedSecurityHint:
          dismissedSecurityHint ?? this.dismissedSecurityHint,
      locale: locale ?? this.locale,
    );
  }
}
