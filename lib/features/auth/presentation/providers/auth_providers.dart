import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/network/api_provider.dart';
import 'package:shellvault/core/services/logging_service.dart';
import 'package:shellvault/features/account/presentation/providers/account_providers.dart';
import 'package:shellvault/features/auth/presentation/providers/auth_repository_providers.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthStatus>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<AuthStatus> {
  static final _log = LoggingService.instance;
  static const _tag = 'Auth';

  @override
  Future<AuthStatus> build() async {
    final tokenResult = await ref.watch(secureStorageProvider).getAccessToken();
    final token = tokenResult.isSuccess ? tokenResult.value : null;
    final status = token != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
    _log.info(_tag, 'Auth state initialized: ${status.name}');
    return status;
  }

  Future<String?> _getDeviceName() async {
    try {
      final info = DeviceInfoPlugin();
      if (kIsWeb) {
        final web = await info.webBrowserInfo;
        return web.browserName.name;
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        final android = await info.androidInfo;
        return android.model;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final ios = await info.iosInfo;
        return ios.name;
      } else if (defaultTargetPlatform == TargetPlatform.macOS) {
        final macos = await info.macOsInfo;
        return macos.computerName;
      } else if (defaultTargetPlatform == TargetPlatform.linux) {
        final linux = await info.linuxInfo;
        return linux.prettyName;
      } else if (defaultTargetPlatform == TargetPlatform.windows) {
        final windows = await info.windowsInfo;
        return windows.computerName;
      }
    } catch (_) {}
    return null;
  }

  Future<void> login(String email, String password) async {
    _log.info(_tag, 'Login attempt');
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
        await _registerDeviceIfNeeded();
        _invalidateAccountProviders();
        _log.info(_tag, 'Login successful');
        return const AsyncValue.data(AuthStatus.authenticated);
      },
      onFailure: (f) async {
        _log.error(_tag, 'Login failed: $f');
        return AsyncValue.error(f, StackTrace.current);
      },
    );
  }

  Future<void> register(String email, String password) async {
    _log.info(_tag, 'Registration attempt');
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
        await _registerDeviceIfNeeded();
        _invalidateAccountProviders();
        _log.info(_tag, 'Registration successful');
        return const AsyncValue.data(AuthStatus.authenticated);
      },
      onFailure: (f) async {
        _log.error(_tag, 'Registration failed: $f');
        return AsyncValue.error(f, StackTrace.current);
      },
    );
  }

  Future<void> logout() async {
    _log.info(_tag, 'Logout initiated');
    state = const AsyncValue.loading();
    final repo = ref.read(authRepositoryProvider);
    final storage = ref.read(secureStorageProvider);

    final refreshResult = await storage.getRefreshToken();
    final refreshToken = refreshResult.isSuccess ? refreshResult.value : null;
    if (refreshToken != null) {
      await repo.logout(refreshToken);
    }

    await storage.clearAuthTokens();
    _invalidateAccountProviders();
    _log.info(_tag, 'Logout completed — tokens and device ID cleared');
    state = const AsyncValue.data(AuthStatus.unauthenticated);
  }

  Future<void> forgotPassword(String email) async {
    _log.info(_tag, 'Forgot password request');
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.forgotPassword(email);
    if (result.isFailure) {
      _log.error(_tag, 'Forgot password failed: ${result.failure}');
      throw result.failure;
    }
    _log.info(_tag, 'Forgot password email sent');
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
    _log.debug(_tag, 'Auth tokens persisted');
  }

  /// Account-related providers (billing, devices, profile) already
  /// `ref.watch(authProvider)`, so they rebuild automatically when auth
  /// state changes.  No manual `ref.invalidate()` needed — calling it
  /// inside the auth state update would trigger an immediate rebuild that
  /// reads authProvider back, causing a CircularDependencyError.
  void _invalidateAccountProviders() {
    _log.debug(
      _tag,
      'Auth state changed — account providers will auto-refresh',
    );
  }

  /// Register this device if not already registered
  Future<void> _registerDeviceIfNeeded() async {
    final storage = ref.read(secureStorageProvider);
    final existingIdResult = await storage.getDeviceId();
    final existingId = existingIdResult.isSuccess
        ? existingIdResult.value
        : null;
    if (existingId != null && existingId.isNotEmpty) {
      _log.debug(
        _tag,
        'Device already registered (id=${existingId.substring(0, 8)}...)',
      );
      return;
    }

    final deviceName = await _getDeviceName() ?? 'Unknown Device';
    final platform = _getPlatformName();
    _log.info(_tag, 'Registering device: $deviceName ($platform)');

    try {
      final repo = ref.read(accountRepositoryProvider);
      final result = await repo.registerDevice(deviceName, platform);
      result.fold(
        onSuccess: (id) async {
          if (id.isNotEmpty) {
            await storage.saveDeviceId(id);
            _log.info(_tag, 'Device registered: $deviceName ($platform) → $id');
          } else {
            _log.warning(_tag, 'Device registration returned empty ID');
          }
        },
        onFailure: (f) {
          _log.error(_tag, 'Device registration failed: $f');
        },
      );
    } catch (e) {
      _log.error(_tag, 'Device registration threw: $e');
    }
  }

  String _getPlatformName() {
    if (kIsWeb) return 'web';
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) return 'ios';
      if (defaultTargetPlatform == TargetPlatform.android) return 'android';
      if (defaultTargetPlatform == TargetPlatform.macOS) return 'macos';
      if (defaultTargetPlatform == TargetPlatform.linux) return 'linux';
      if (defaultTargetPlatform == TargetPlatform.windows) return 'windows';
    } catch (_) {}
    return 'unknown';
  }
}
