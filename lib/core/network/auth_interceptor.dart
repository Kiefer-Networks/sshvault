import 'dart:async';

import 'package:dio/dio.dart';
import 'package:shellvault/core/storage/secure_storage_service.dart';

typedef OnAuthExpired = void Function();

class AuthInterceptor extends Interceptor {
  final SecureStorageService _storage;
  final Dio _dio;
  final OnAuthExpired? onAuthExpired;
  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  AuthInterceptor(this._storage, this._dio, {this.onAuthExpired});

  /// Endpoints that do not require an Authorization header.
  static const _publicPaths = [
    '/auth/refresh',
    '/auth/login',
    '/auth/register',
    '/health',
    '/auth/forgot-password',
    '/auth/reset-password',
    '/auth/verify-email',
    '/auth/oauth',
  ];

  bool _isPublicPath(String path) {
    return _publicPaths.any((p) => path.contains(p));
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      if (_isPublicPath(options.path)) {
        return handler.next(options);
      }

      final tokenResult = await _storage.getAccessToken();
      final token = tokenResult.isSuccess ? tokenResult.value : null;
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    } catch (_) {
      // On any error, let the request proceed without auth header.
      handler.next(options);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Skip refresh for auth endpoints
    if (err.requestOptions.path.contains('/auth/refresh') ||
        err.requestOptions.path.contains('/auth/login')) {
      return handler.next(err);
    }

    // If another refresh is already in progress, wait for it and retry.
    if (_isRefreshing) {
      try {
        await _refreshCompleter!.future;
        // Refresh succeeded — retry with the new token.
        final tokenResult = await _storage.getAccessToken();
        final token = tokenResult.isSuccess ? tokenResult.value : null;
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $token';
        final retryResponse = await _dio.fetch(opts);
        return handler.resolve(retryResponse);
      } catch (_) {
        // Refresh failed — propagate the original error.
        return handler.next(err);
      }
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<void>();
    try {
      final refreshResult = await _storage.getRefreshToken();
      final refreshToken =
          refreshResult.isSuccess ? refreshResult.value : null;
      if (refreshToken == null) {
        await _handleAuthExpired();
        _refreshCompleter!.completeError(
          StateError('No refresh token available'),
        );
        return handler.next(err);
      }

      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final data = response.data;
      if (data == null) {
        await _handleAuthExpired();
        _refreshCompleter!.completeError(
          StateError('Empty refresh response'),
        );
        return handler.next(err);
      }
      final newAccessToken = data['access_token'] as String;
      final newRefreshToken = data['refresh_token'] as String;
      String? expiresAt;
      final rawExpiry = data['expires_at'];
      if (rawExpiry is int) {
        expiresAt = DateTime.fromMillisecondsSinceEpoch(
                rawExpiry * 1000, isUtc: true)
            .toIso8601String();
      } else if (rawExpiry is String) {
        expiresAt = rawExpiry;
      }

      await _storage.saveAccessToken(newAccessToken);
      await _storage.saveRefreshToken(newRefreshToken);
      if (expiresAt != null) {
        await _storage.saveTokenExpiry(expiresAt);
      }

      // Signal waiting requests that the refresh succeeded.
      _refreshCompleter!.complete();

      // Retry original request with new token
      final opts = err.requestOptions;
      opts.headers['Authorization'] = 'Bearer $newAccessToken';
      final retryResponse = await _dio.fetch(opts);
      return handler.resolve(retryResponse);
    } on DioException {
      await _handleAuthExpired();
      _refreshCompleter!.completeError(
        StateError('Token refresh failed'),
      );
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
