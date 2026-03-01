import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Returns true if the current platform supports biometric/local auth.
  static bool get isPlatformSupported {
    if (kIsWeb) return false;
    return Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isMacOS ||
        Platform.isWindows;
  }

  /// Checks if the device supports biometric or device credential authentication.
  Future<bool> isAvailable() async {
    if (!isPlatformSupported) return false;
    try {
      return await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  /// Returns the available biometric types on the device.
  Future<List<BiometricType>> getAvailableTypes() async {
    if (!isPlatformSupported) return [];
    try {
      return await _auth.getAvailableBiometrics();
    } catch (_) {
      return [];
    }
  }

  /// Authenticates the user with biometrics (or device PIN/passcode fallback).
  Future<bool> authenticate({
    String reason = 'Authenticate to unlock SSH Vault',
  }) async {
    if (!isPlatformSupported) return false;
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
