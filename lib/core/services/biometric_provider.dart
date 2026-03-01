import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/services/biometric_service.dart';

final biometricServiceProvider =
    Provider<BiometricService>((ref) => BiometricService());

final biometricAvailableProvider = FutureProvider<bool>((ref) {
  return ref.watch(biometricServiceProvider).isAvailable();
});
