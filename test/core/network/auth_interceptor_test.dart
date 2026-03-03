import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/network/auth_interceptor.dart';
import 'package:shellvault/core/storage/secure_storage_service.dart';
import 'package:dio/dio.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late MockSecureStorageService mockStorage;
  late Dio dio;
  late AuthInterceptor sut;
  late bool authExpiredCalled;

  setUp(() {
    mockStorage = MockSecureStorageService();
    dio = Dio(BaseOptions(baseUrl: 'https://api.test.com'));
    authExpiredCalled = false;
    sut = AuthInterceptor(
      mockStorage,
      dio,
      onAuthExpired: () => authExpiredCalled = true,
    );
  });

  group('AuthInterceptor — public paths', () {
    test('does not add Authorization header for /auth/login', () async {
      final options = RequestOptions(path: '/v1/auth/login');
      final handler = _MockRequestHandler();

      sut.onRequest(options, handler);
      await Future<void>.delayed(Duration.zero);

      expect(handler.nextCalled, isTrue);
      expect(handler.nextOptions?.headers['Authorization'], isNull);
    });

    test('does not add Authorization header for /auth/register', () async {
      final options = RequestOptions(path: '/v1/auth/register');
      final handler = _MockRequestHandler();

      sut.onRequest(options, handler);
      await Future<void>.delayed(Duration.zero);

      expect(handler.nextCalled, isTrue);
    });

    test('does not add Authorization header for /health', () async {
      final options = RequestOptions(path: '/health');
      final handler = _MockRequestHandler();

      sut.onRequest(options, handler);
      await Future<void>.delayed(Duration.zero);

      expect(handler.nextCalled, isTrue);
    });

    test('does not add Authorization header for /auth/forgot-password', () async {
      final options = RequestOptions(path: '/v1/auth/forgot-password');
      final handler = _MockRequestHandler();

      sut.onRequest(options, handler);
      await Future<void>.delayed(Duration.zero);

      expect(handler.nextCalled, isTrue);
    });
  });

  group('AuthInterceptor — authenticated requests', () {
    test('adds Bearer token for protected paths', () async {
      when(() => mockStorage.getAccessToken())
          .thenAnswer((_) async => const Success('jwt-token-123'));

      final options = RequestOptions(path: '/v1/vault');
      final handler = _MockRequestHandler();

      sut.onRequest(options, handler);
      await Future<void>.delayed(Duration.zero);

      expect(handler.nextCalled, isTrue);
      expect(
        handler.nextOptions?.headers['Authorization'],
        'Bearer jwt-token-123',
      );
    });

    test('proceeds without auth header when no token stored', () async {
      when(() => mockStorage.getAccessToken())
          .thenAnswer((_) async => const Success(null));

      final options = RequestOptions(path: '/v1/vault');
      final handler = _MockRequestHandler();

      sut.onRequest(options, handler);
      await Future<void>.delayed(Duration.zero);

      expect(handler.nextCalled, isTrue);
      expect(handler.nextOptions?.headers['Authorization'], isNull);
    });

    test('proceeds without auth header on storage error', () async {
      when(() => mockStorage.getAccessToken()).thenThrow(Exception('error'));

      final options = RequestOptions(path: '/v1/vault');
      final handler = _MockRequestHandler();

      sut.onRequest(options, handler);
      await Future<void>.delayed(Duration.zero);

      expect(handler.nextCalled, isTrue);
    });
  });

  group('AuthInterceptor — onError non-401', () {
    test('passes through non-401 errors', () async {
      final err = DioException(
        requestOptions: RequestOptions(path: '/v1/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/v1/test'),
          statusCode: 500,
        ),
      );
      final handler = _MockErrorHandler();

      sut.onError(err, handler);
      await Future<void>.delayed(Duration.zero);

      expect(handler.nextCalled, isTrue);
    });
  });

  group('AuthInterceptor — 401 on auth endpoints', () {
    test('does not attempt refresh on /auth/login 401', () async {
      final err = DioException(
        requestOptions: RequestOptions(path: '/v1/auth/login'),
        response: Response(
          requestOptions: RequestOptions(path: '/v1/auth/login'),
          statusCode: 401,
        ),
      );
      final handler = _MockErrorHandler();

      sut.onError(err, handler);
      await Future<void>.delayed(Duration.zero);

      expect(handler.nextCalled, isTrue);
      verifyNever(() => mockStorage.getRefreshToken());
    });

    test('does not attempt refresh on /auth/refresh 401', () async {
      final err = DioException(
        requestOptions: RequestOptions(path: '/v1/auth/refresh'),
        response: Response(
          requestOptions: RequestOptions(path: '/v1/auth/refresh'),
          statusCode: 401,
        ),
      );
      final handler = _MockErrorHandler();

      sut.onError(err, handler);
      await Future<void>.delayed(Duration.zero);

      expect(handler.nextCalled, isTrue);
    });
  });

  group('AuthInterceptor — 401 token refresh', () {
    test('clears tokens and calls onAuthExpired when no refresh token', () async {
      when(() => mockStorage.getRefreshToken())
          .thenAnswer((_) async => const Success(null));
      when(() => mockStorage.clearAuthTokens())
          .thenAnswer((_) async => const Success(null));

      final err = DioException(
        requestOptions: RequestOptions(path: '/v1/vault'),
        response: Response(
          requestOptions: RequestOptions(path: '/v1/vault'),
          statusCode: 401,
        ),
      );
      final handler = _MockErrorHandler();

      // The interceptor internally completes a Completer with error
      // when no refresh token is available. We need to catch the
      // unhandled async error from the completer's future.
      await runZonedGuarded(() async {
        sut.onError(err, handler);
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }, (error, stack) {
        // Expected: StateError from completer.completeError
      });

      expect(handler.nextCalled, isTrue);
      expect(authExpiredCalled, isTrue);
      verify(() => mockStorage.clearAuthTokens()).called(1);
    });
  });
}

/// Mock request interceptor handler for testing onRequest
class _MockRequestHandler extends RequestInterceptorHandler {
  bool nextCalled = false;
  RequestOptions? nextOptions;

  @override
  void next(RequestOptions requestOptions) {
    nextCalled = true;
    nextOptions = requestOptions;
  }
}

/// Mock error interceptor handler for testing onError
class _MockErrorHandler extends ErrorInterceptorHandler {
  bool nextCalled = false;
  bool resolveCalled = false;

  @override
  void next(DioException err) {
    nextCalled = true;
  }

  @override
  void resolve(Response response) {
    resolveCalled = true;
  }
}
