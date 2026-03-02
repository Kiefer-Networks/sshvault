import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/network/api_client.dart';
import 'package:shellvault/features/auth/domain/entities/auth_response.dart';
import 'package:shellvault/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;

  AuthRepositoryImpl(this._apiClient);

  @override
  Future<Result<AuthResponse>> register(String email, String password) async {
    final result = await _apiClient.post(
      '/v1/auth/register',
      data: {'email': email, 'password': password},
    );
    return result.fold(
      onSuccess: (data) {
        try {
          return Success(AuthResponse.fromJson(data));
        } catch (e) {
          return Err(AuthFailure('Invalid response format', cause: e));
        }
      },
      onFailure: (f) => Err(AuthFailure(f.message, cause: f.cause)),
    );
  }

  @override
  Future<Result<AuthResponse>> login(
    String email,
    String password, {
    String? deviceName,
  }) async {
    final result = await _apiClient.post(
      '/v1/auth/login',
      data: {
        'email': email,
        'password': password,
        if (deviceName != null) 'device_name': deviceName,
      },
    );
    return result.fold(
      onSuccess: (data) {
        try {
          return Success(AuthResponse.fromJson(data));
        } catch (e) {
          return Err(AuthFailure('Invalid response format', cause: e));
        }
      },
      onFailure: (f) => Err(AuthFailure(f.message, cause: f.cause)),
    );
  }

  @override
  Future<Result<AuthResponse>> oauthLogin(
    String provider,
    String idToken,
  ) async {
    final result = await _apiClient.post(
      '/v1/auth/oauth/$provider',
      data: {'id_token': idToken},
    );
    return result.fold(
      onSuccess: (data) {
        try {
          return Success(AuthResponse.fromJson(data));
        } catch (e) {
          return Err(AuthFailure('Invalid response format', cause: e));
        }
      },
      onFailure: (f) => Err(AuthFailure(f.message, cause: f.cause)),
    );
  }

  @override
  Future<Result<void>> logout(String refreshToken) async {
    final result = await _apiClient.post(
      '/v1/auth/logout',
      data: {'refresh_token': refreshToken},
    );
    return result.fold(
      onSuccess: (_) => const Success(null),
      onFailure: (f) => Err(AuthFailure(f.message, cause: f.cause)),
    );
  }

  @override
  Future<Result<void>> forgotPassword(String email) async {
    final result = await _apiClient.post(
      '/v1/auth/forgot-password',
      data: {'email': email},
    );
    return result.fold(
      onSuccess: (_) => const Success(null),
      onFailure: (f) => Err(AuthFailure(f.message, cause: f.cause)),
    );
  }

  @override
  Future<Result<void>> resetPassword(String token, String newPassword) async {
    final result = await _apiClient.post(
      '/v1/auth/reset-password',
      data: {'token': token, 'new_password': newPassword},
    );
    return result.fold(
      onSuccess: (_) => const Success(null),
      onFailure: (f) => Err(AuthFailure(f.message, cause: f.cause)),
    );
  }

  @override
  Future<Result<void>> verifyEmail(String token) async {
    final result = await _apiClient.get(
      '/v1/auth/verify-email?token=${Uri.encodeComponent(token)}',
    );
    return result.fold(
      onSuccess: (_) => const Success(null),
      onFailure: (f) => Err(AuthFailure(f.message, cause: f.cause)),
    );
  }
}
