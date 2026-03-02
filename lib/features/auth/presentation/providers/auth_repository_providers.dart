import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/network/api_provider.dart';
import 'package:shellvault/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:shellvault/features/auth/data/services/apple_auth_service.dart';
import 'package:shellvault/features/auth/data/services/google_auth_service.dart';
import 'package:shellvault/features/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(apiClientProvider));
});

final appleAuthServiceProvider = Provider<AppleAuthService>((ref) {
  return AppleAuthService();
});

final googleAuthServiceProvider = Provider<GoogleAuthService>((ref) {
  return GoogleAuthService();
});
