import 'package:dio/dio.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/core/storage/secure_storage_service.dart';

typedef OnAuthExpired = Future<void> Function({bool sessionRevoked});

class AuthInterceptor extends Interceptor {
  static final _log = LoggingService.instance;
  static const _tag = 'Auth';

  final SecureStorageService _storage;
  final Dio _dio;
  final OnAuthExpired? onAuthExpired;
  Future<String?>? _refreshFuture;

  AuthInterceptor(this._storage, this._dio, {this.onAuthExpired});

  /// Endpoints that do not require an Authorization header.
  static const _publicPaths = [
    '/auth/refresh',
    '/auth/login',
    '/auth/register',
    '/health',
    '/auth/challenge',
    '/auth/logout',
    '/auth/confirm-email-change',
    '/attestation',
    '/attestation/pubkey',
    '/auth/forgot-password',
    '/auth/reset-password',
    '/auth/verify-email',
    '/auth/oauth',
  ];

  bool _isPublicPath(String path) {
    final cleanPath = Uri.parse(path).path;
    return _publicPaths.any((p) => cleanPath.endsWith(p));
  }

  @override
  Future<void> onRequest(
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

      final deviceIdResult = await _storage.getDeviceId();
      final deviceId = deviceIdResult.isSuccess ? deviceIdResult.value : null;
      if (deviceId != null && deviceId.isNotEmpty) {
        options.headers['X-Device-ID'] = deviceId;
      }

      handler.next(options);
    } catch (e) {
      _log.error(_tag, 'Failed to attach auth header: $e');
      handler.next(options);
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401 ||
        _isPublicPath(err.requestOptions.path)) {
      return handler.next(err);
    }

    try {
      // A delayed 401 may arrive after another request already rotated the
      // token. Reuse that token instead of consuming the replacement again.
      final stored = await _storage.getAccessToken();
      var token = stored.isSuccess ? stored.value : null;
      if (token == null ||
          err.requestOptions.headers['Authorization'] == 'Bearer $token') {
        final pending = _refreshFuture ??= _refreshTokens();
        try {
          token = await pending;
        } finally {
          if (identical(_refreshFuture, pending)) _refreshFuture = null;
        }
      }
      if (token == null) return handler.next(err);

      final options = err.requestOptions;
      options.headers['Authorization'] = 'Bearer $token';
      // This Dio has no auth interceptor: retries are bounded to one request.
      final response = await _dio.fetch<dynamic>(options);
      return handler.resolve(response);
    } on DioException catch (error) {
      // The refreshed session remains valid even if the retried operation
      // fails. Surface the actual operation error without clearing tokens.
      return handler.next(error);
    } catch (error) {
      _log.error(_tag, 'Authentication retry failed: $error');
      return handler.next(err);
    }
  }

  Future<String?> _refreshTokens() async {
    try {
      final refreshResult = await _storage.getRefreshToken();
      final refreshToken = refreshResult.isSuccess ? refreshResult.value : null;
      if (refreshToken == null || refreshToken.isEmpty) {
        await _handleAuthExpired();
        return null;
      }
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      final data = response.data;
      final access = data?['access_token'];
      final refresh = data?['refresh_token'];
      if (access is! String ||
          access.isEmpty ||
          refresh is! String ||
          refresh.isEmpty) {
        _log.error(_tag, 'Invalid token refresh response');
        // A 2xx refresh may already have consumed the single-use token.
        // Replaying it after an unusable response could revoke every session.
        await _handleAuthExpired();
        return null;
      }
      final accessSaved = await _storage.saveAccessToken(access);
      final refreshSaved = await _storage.saveRefreshToken(refresh);
      if (accessSaved.isFailure || refreshSaved.isFailure) {
        // A rotated token that could not be saved cannot safely be replayed.
        await _handleAuthExpired();
        return null;
      }
      final rawExpiry = data?['expires_at'];
      if (rawExpiry is int) {
        await _storage.saveTokenExpiry(
          DateTime.fromMillisecondsSinceEpoch(
            rawExpiry * 1000,
            isUtc: true,
          ).toIso8601String(),
        );
      } else if (rawExpiry is String) {
        await _storage.saveTokenExpiry(rawExpiry);
      }
      return access;
    } on DioException catch (error) {
      // Only explicit refresh rejection proves that the session is invalid.
      // Offline, timeouts, rate limiting and server failures are retryable.
      if (error.response?.statusCode == 401) {
        await _handleAuthExpired(sessionRevoked: true);
      }
      return null;
    } catch (error) {
      _log.error(_tag, 'Token refresh failed: $error');
      return null;
    }
  }

  Future<void> _handleAuthExpired({bool sessionRevoked = false}) async {
    _log.warning(
      _tag,
      sessionRevoked
          ? 'Session revoked — clearing tokens'
          : 'Auth expired — clearing tokens',
    );
    await _storage.clearAuthTokens();
    await onAuthExpired?.call(sessionRevoked: sessionRevoked);
  }
}
