import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/services/biometric_provider.dart';
import 'package:sshvault/core/services/biometric_service.dart';
import 'package:sshvault/core/storage/keyring_service.dart';
import 'package:sshvault/core/storage/secure_storage_service.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

/// Wraps `flutter_secure_storage` and the platform-native credential
/// stores for the master vault key only. Backed by libsecret on Linux,
/// Keychain on macOS, EncryptedSharedPreferences on Android, and the
/// Windows Credential Manager on Windows.
final keyringServiceProvider = Provider<KeyringService>((ref) {
  // Lazy biometric gate: defers reading the settings until the gate is
  // actually consulted so that constructing the provider does not cause
  // a settings-load cycle.
  MasterKeyBiometricGate? gate;
  if (Platform.isWindows) {
    gate = _SettingsDrivenBiometricGate(ref);
  }
  return KeyringService(biometricGate: gate);
});

/// On Windows we want to challenge the user with Windows Hello before
/// the master key is read out of the Credential Vault, but only when
/// they've turned biometric unlock on. `local_auth` already drives
/// `Windows.Security.Credentials.UI.UserConsentVerifier.RequestVerificationAsync`
/// under the hood on Win10+.
class _SettingsDrivenBiometricGate implements MasterKeyBiometricGate {
  _SettingsDrivenBiometricGate(this._ref);

  final Ref _ref;

  @override
  Future<bool> isRequired() async {
    try {
      final settings = await _ref.read(settingsProvider.future);
      return settings.biometricUnlock;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> verify() async {
    final service = _ref.read(biometricServiceProvider);
    if (!BiometricService.isPlatformSupported) return true;
    return service.authenticate(
      reason: 'Confirm with Windows Hello to unlock SSHVault',
    );
  }
}
