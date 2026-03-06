import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shellvault/core/services/logging_service.dart';

class BiometricService {
  static final _log = LoggingService.instance;
  static const _tag = 'Biometric';

  final LocalAuthentication _auth = LocalAuthentication();

  /// Returns true if the current platform supports biometric/local auth.
  static bool get isPlatformSupported {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows;
  }

  /// Checks if the device supports biometric or device credential authentication.
  Future<bool> isAvailable() async {
    if (!isPlatformSupported) return false;
    try {
      return await _auth.isDeviceSupported();
    } catch (e) {
      _log.warning(_tag, 'Failed to check biometric availability: $e');
      return false;
    }
  }

  /// Returns the available biometric types on the device.
  Future<List<BiometricType>> getAvailableTypes() async {
    if (!isPlatformSupported) return [];
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      _log.warning(_tag, 'Failed to get available biometric types: $e');
      return [];
    }
  }

  /// Authenticates the user with biometrics (or device PIN/passcode fallback).
  Future<bool> authenticate({
    String reason = 'Authenticate to unlock SSH Vault',
  }) async {
    if (!isPlatformSupported) return false;
    try {
      return await _auth.authenticate(localizedReason: reason);
    } catch (e) {
      _log.warning(_tag, 'Biometric authentication failed: $e');
      return false;
    }
  }
}
