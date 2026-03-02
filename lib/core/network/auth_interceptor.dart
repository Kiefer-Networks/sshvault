import 'dart:async';

import 'package:dio/dio.dart';
import 'package:shellvault/core/services/logging_service.dart';
import 'package:shellvault/core/storage/secure_storage_service.dart';

typedef OnAuthExpired = void Function();

class AuthInterceptor extends Interceptor {
  static final _log = LoggingService.instance;
  static const _tag = 'Auth';

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
      } else {
        _log.warning(_tag, 'No access token for ${options.path}');
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
      _log.warning(_tag, '401 on auth endpoint ${err.requestOptions.path} — not refreshing');
      return handler.next(err);
    }

    _log.info(_tag, '401 on ${err.requestOptions.path} — attempting token refresh');

    // If another refresh is already in progress, wait for it and retry.
    if (_isRefreshing) {
      _log.debug(_tag, 'Token refresh already in progress, waiting');
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
    final completer = Completer<void>();
    _refreshCompleter = completer;
    try {
      final refreshResult = await _storage.getRefreshToken();
      final refreshToken = refreshResult.isSuccess ? refreshResult.value : null;
      if (refreshToken == null) {
        _log.warning(_tag, 'No refresh token available — session expired');
        await _handleAuthExpired();
        completer.completeError(StateError('No refresh token available'));
        return handler.next(err);
      }

      _log.debug(_tag, 'Refreshing access token');
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final data = response.data;
      if (data == null) {
        _log.error(_tag, 'Token refresh returned empty response');
        await _handleAuthExpired();
        completer.completeError(StateError('Empty refresh response'));
        return handler.next(err);
      }
      final newAccessToken = data['access_token'] as String;
      final newRefreshToken = data['refresh_token'] as String;
      String? expiresAt;
      final rawExpiry = data['expires_at'];
      if (rawExpiry is int) {
        expiresAt = DateTime.fromMillisecondsSinceEpoch(
          rawExpiry * 1000,
          isUtc: true,
        ).toIso8601String();
      } else if (rawExpiry is String) {
        expiresAt = rawExpiry;
      }

      await _storage.saveAccessToken(newAccessToken);
      await _storage.saveRefreshToken(newRefreshToken);
      if (expiresAt != null) {
        await _storage.saveTokenExpiry(expiresAt);
      }

      _log.info(_tag, 'Token refreshed successfully');

      // Signal waiting requests that the refresh succeeded.
      completer.complete();

      // Retry original request with new token
      final opts = err.requestOptions;
      opts.headers['Authorization'] = 'Bearer $newAccessToken';
      final retryResponse = await _dio.fetch(opts);
      return handler.resolve(retryResponse);
    } on DioException catch (e) {
      _log.error(
        _tag,
        'Token refresh failed: ${e.response?.statusCode ?? 'N/A'} ${e.message}',
      );
      await _handleAuthExpired();
      if (!completer.isCompleted) {
        completer.completeError(StateError('Token refresh failed'));
      }
      return handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _handleAuthExpired() async {
    _log.warning(_tag, 'Auth expired — clearing tokens');
    await _storage.clearAuthTokens();
    onAuthExpired?.call();
  }
}
