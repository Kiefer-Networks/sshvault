import 'package:flutter/material.dart';
import 'package:shellvault/core/constants/app_constants.dart';

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
  final int failedPinAttempts;
  final DateTime? lockoutUntil;
  final String serverUrl;
  final bool selfHosted;
  final bool autoSync;
  final int localVaultVersion;

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
    this.failedPinAttempts = 0,
    this.lockoutUntil,
    this.serverUrl = '',
    this.selfHosted = false,
    this.autoSync = true,
    this.localVaultVersion = 0,
  });

  bool get hasPin => pinHash.isNotEmpty;
  bool get hasAnyLock => biometricUnlock || hasPin;

  bool get isLockedOut {
    if (lockoutUntil == null) return false;
    return DateTime.now().isBefore(lockoutUntil!);
  }

  Duration get remainingLockout {
    if (lockoutUntil == null) return Duration.zero;
    final remaining = lockoutUntil!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  bool get shouldLockout =>
      failedPinAttempts >= AppConstants.maxPinAttempts;

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
    int? failedPinAttempts,
    DateTime? lockoutUntil,
    bool clearLockout = false,
    String? serverUrl,
    bool? selfHosted,
    bool? autoSync,
    int? localVaultVersion,
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
      failedPinAttempts: failedPinAttempts ?? this.failedPinAttempts,
      lockoutUntil: clearLockout ? null : (lockoutUntil ?? this.lockoutUntil),
      serverUrl: serverUrl ?? this.serverUrl,
      selfHosted: selfHosted ?? this.selfHosted,
      autoSync: autoSync ?? this.autoSync,
      localVaultVersion: localVaultVersion ?? this.localVaultVersion,
    );
  }
}
