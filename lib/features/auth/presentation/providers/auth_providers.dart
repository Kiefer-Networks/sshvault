import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/network/api_provider.dart';
import 'package:shellvault/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:shellvault/features/auth/data/services/apple_auth_service.dart';
import 'package:shellvault/features/auth/data/services/google_auth_service.dart';
import 'package:shellvault/features/auth/domain/repositories/auth_repository.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(apiClientProvider));
});

final appleAuthServiceProvider = Provider<AppleAuthService>((ref) {
  return AppleAuthService();
});

final googleAuthServiceProvider = Provider<GoogleAuthService>((ref) {
  return GoogleAuthService();
});

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthStatus>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<AuthStatus> {
  @override
  Future<AuthStatus> build() async {
    final tokenResult = await ref.watch(secureStorageProvider).getAccessToken();
    final token = tokenResult.isSuccess ? tokenResult.value : null;
    return token != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
  }

  Future<String?> _getDeviceName() async {
    try {
      final info = DeviceInfoPlugin();
      if (kIsWeb) {
        final web = await info.webBrowserInfo;
        return web.browserName.name;
      } else if (Platform.isAndroid) {
        final android = await info.androidInfo;
        return android.model;
      } else if (Platform.isIOS) {
        final ios = await info.iosInfo;
        return ios.name;
      } else if (Platform.isMacOS) {
        final macos = await info.macOsInfo;
        return macos.computerName;
      } else if (Platform.isLinux) {
        final linux = await info.linuxInfo;
        return linux.prettyName;
      } else if (Platform.isWindows) {
        final windows = await info.windowsInfo;
        return windows.computerName;
      }
    } catch (_) {}
    return null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    final repo = ref.read(authRepositoryProvider);
    final deviceName = await _getDeviceName();

    final result = await repo.login(email, password, deviceName: deviceName);
    state = await result.fold(
      onSuccess: (auth) async {
        await _persistTokens(
          auth.accessToken,
          auth.refreshToken,
          auth.expiresAt,
          auth.user.email,
        );
        return const AsyncValue.data(AuthStatus.authenticated);
      },
      onFailure: (f) async => AsyncValue.error(f, StackTrace.current),
    );
  }

  Future<void> register(String email, String password) async {
    state = const AsyncValue.loading();
    final repo = ref.read(authRepositoryProvider);

    final result = await repo.register(email, password);
    state = await result.fold(
      onSuccess: (auth) async {
        await _persistTokens(
          auth.accessToken,
          auth.refreshToken,
          auth.expiresAt,
          auth.user.email,
        );
        return const AsyncValue.data(AuthStatus.authenticated);
      },
      onFailure: (f) async => AsyncValue.error(f, StackTrace.current),
    );
  }

  Future<void> loginWithApple() async {
    if (!showAppleSignIn) return;

    state = const AsyncValue.loading();
    final appleService = ref.read(appleAuthServiceProvider);
    final repo = ref.read(authRepositoryProvider);

    final appleResult = await appleService.signIn();
    if (appleResult.isFailure) {
      state = AsyncValue.error(appleResult.failure, StackTrace.current);
      return;
    }

    final result = await repo.oauthLogin('apple', appleResult.value.idToken);
    state = await result.fold(
      onSuccess: (auth) async {
        await _persistTokens(
          auth.accessToken,
          auth.refreshToken,
          auth.expiresAt,
          auth.user.email,
        );
        return const AsyncValue.data(AuthStatus.authenticated);
      },
      onFailure: (f) async => AsyncValue.error(f, StackTrace.current),
    );
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncValue.loading();
    final googleService = ref.read(googleAuthServiceProvider);
    final repo = ref.read(authRepositoryProvider);

    final googleResult = await googleService.signIn();
    if (googleResult.isFailure) {
      state = AsyncValue.error(googleResult.failure, StackTrace.current);
      return;
    }

    final result = await repo.oauthLogin('google', googleResult.value);
    state = await result.fold(
      onSuccess: (auth) async {
        await _persistTokens(
          auth.accessToken,
          auth.refreshToken,
          auth.expiresAt,
          auth.user.email,
        );
        return const AsyncValue.data(AuthStatus.authenticated);
      },
      onFailure: (f) async => AsyncValue.error(f, StackTrace.current),
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    final repo = ref.read(authRepositoryProvider);
    final storage = ref.read(secureStorageProvider);

    final refreshResult = await storage.getRefreshToken();
    final refreshToken = refreshResult.isSuccess ? refreshResult.value : null;
    if (refreshToken != null) {
      await repo.logout(refreshToken);
    }

    await storage.clearAuthTokens();
    ref.read(googleAuthServiceProvider).signOut();
    state = const AsyncValue.data(AuthStatus.unauthenticated);
  }

  Future<void> forgotPassword(String email) async {
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.forgotPassword(email);
    if (result.isFailure) {
      throw result.failure;
    }
  }

  Future<void> _persistTokens(
    String accessToken,
    String refreshToken,
    String? expiresAt,
    String email,
  ) async {
    final storage = ref.read(secureStorageProvider);
    await storage.saveAccessToken(accessToken);
    await storage.saveRefreshToken(refreshToken);
    if (expiresAt != null) {
      await storage.saveTokenExpiry(expiresAt);
    }
    await storage.saveUserEmail(email);
  }
}

/// Whether Apple Sign In should be shown (only iOS/macOS native)
bool get showAppleSignIn =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS);
