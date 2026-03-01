import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Checks if the device supports biometric or device credential authentication.
  /// Returns true for biometrics (fingerprint/face) OR device credentials (PIN/pattern).
  Future<bool> isAvailable() async {
    return _auth.isDeviceSupported();
  }

  /// Returns the available biometric types on the device.
  Future<List<BiometricType>> getAvailableTypes() async {
    return _auth.getAvailableBiometrics();
  }

  /// Authenticates the user with biometrics (or device PIN/passcode fallback).
  Future<bool> authenticate({
    String reason = 'Authenticate to unlock ShellVault',
  }) async {
    return _auth.authenticate(
      localizedReason: reason,
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: false,
      ),
    );
  }
}
