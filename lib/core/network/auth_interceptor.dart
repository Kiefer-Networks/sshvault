import 'package:dio/dio.dart';
import 'package:shellvault/core/storage/secure_storage_service.dart';

typedef OnAuthExpired = void Function();

class AuthInterceptor extends Interceptor {
  final SecureStorageService _storage;
  final Dio _dio;
  final OnAuthExpired? onAuthExpired;
  bool _isRefreshing = false;

  AuthInterceptor(this._storage, this._dio, {this.onAuthExpired});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for refresh endpoint
    if (options.path.contains('/auth/refresh') ||
        options.path.contains('/auth/login') ||
        options.path.contains('/auth/register') ||
        options.path.contains('/health')) {
      return handler.next(options);
    }

    final tokenResult = await _storage.getAccessToken();
    final token = tokenResult.isSuccess ? tokenResult.value : null;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401 || _isRefreshing) {
      return handler.next(err);
    }

    // Skip refresh for auth endpoints
    if (err.requestOptions.path.contains('/auth/refresh') ||
        err.requestOptions.path.contains('/auth/login')) {
      return handler.next(err);
    }

    _isRefreshing = true;
    try {
      final refreshResult = await _storage.getRefreshToken();
      final refreshToken =
          refreshResult.isSuccess ? refreshResult.value : null;
      if (refreshToken == null) {
        await _handleAuthExpired();
        return handler.next(err);
      }

      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final data = response.data!;
      final newAccessToken = data['access_token'] as String;
      final newRefreshToken = data['refresh_token'] as String;
      final expiresAt = data['expires_at'] as String?;

      await _storage.saveAccessToken(newAccessToken);
      await _storage.saveRefreshToken(newRefreshToken);
      if (expiresAt != null) {
        await _storage.saveTokenExpiry(expiresAt);
      }

      // Retry original request with new token
      final opts = err.requestOptions;
      opts.headers['Authorization'] = 'Bearer $newAccessToken';
      final retryResponse = await _dio.fetch(opts);
      return handler.resolve(retryResponse);
    } on DioException {
      await _handleAuthExpired();
      return handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _handleAuthExpired() async {
    await _storage.clearAuthTokens();
    onAuthExpired?.call();
  }
}
