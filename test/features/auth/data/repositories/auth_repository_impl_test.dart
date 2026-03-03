import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/network/api_client.dart';
import 'package:shellvault/features/auth/data/repositories/auth_repository_impl.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApi;
  late AuthRepositoryImpl sut;

  final authResponseData = {
    'user': {'id': 'u1', 'email': 'test@example.com', 'verified': true},
    'access_token': 'access-123',
    'refresh_token': 'refresh-456',
    'expires_at': '2025-12-31T23:59:59Z',
  };

  setUp(() {
    mockApi = MockApiClient();
    sut = AuthRepositoryImpl(mockApi);
  });

  group('register', () {
    test('returns AuthResponse on success', () async {
      when(
        () => mockApi.post('/v1/auth/register', data: any(named: 'data')),
      ).thenAnswer((_) async => Success(authResponseData));

      final result = await sut.register('test@example.com', 'password123');
      expect(result.isSuccess, isTrue);
      expect(result.value.user.email, 'test@example.com');
      expect(result.value.accessToken, 'access-123');
      expect(result.value.refreshToken, 'refresh-456');
    });

    test('returns AuthFailure on network error', () async {
      when(
        () => mockApi.post('/v1/auth/register', data: any(named: 'data')),
      ).thenAnswer(
        (_) async =>
            const Err(NetworkFailure('email already exists', statusCode: 409)),
      );

      final result = await sut.register('test@example.com', 'password123');
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<AuthFailure>());
      expect(result.failure.message, 'email already exists');
    });

    test('sends correct data payload', () async {
      when(
        () => mockApi.post('/v1/auth/register', data: any(named: 'data')),
      ).thenAnswer((_) async => Success(authResponseData));

      await sut.register('user@test.com', 'pass');
      verify(
        () => mockApi.post(
          '/v1/auth/register',
          data: {'email': 'user@test.com', 'password': 'pass'},
        ),
      ).called(1);
    });
  });

  group('login', () {
    test('returns AuthResponse on success', () async {
      when(
        () => mockApi.post('/v1/auth/login', data: any(named: 'data')),
      ).thenAnswer((_) async => Success(authResponseData));

      final result = await sut.login('test@example.com', 'password123');
      expect(result.isSuccess, isTrue);
      expect(result.value.accessToken, 'access-123');
    });

    test('includes device_name when provided', () async {
      when(
        () => mockApi.post('/v1/auth/login', data: any(named: 'data')),
      ).thenAnswer((_) async => Success(authResponseData));

      await sut.login('test@example.com', 'pass', deviceName: 'iPhone 15');
      verify(
        () => mockApi.post(
          '/v1/auth/login',
          data: {
            'email': 'test@example.com',
            'password': 'pass',
            'device_name': 'iPhone 15',
          },
        ),
      ).called(1);
    });

    test('returns AuthFailure on wrong credentials', () async {
      when(
        () => mockApi.post('/v1/auth/login', data: any(named: 'data')),
      ).thenAnswer(
        (_) async =>
            const Err(NetworkFailure('invalid credentials', statusCode: 401)),
      );

      final result = await sut.login('test@example.com', 'wrong');
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<AuthFailure>());
    });
  });

  group('logout', () {
    test('returns Success on successful logout', () async {
      when(
        () => mockApi.post('/v1/auth/logout', data: any(named: 'data')),
      ).thenAnswer((_) async => const Success(<String, dynamic>{}));

      final result = await sut.logout('refresh-token');
      expect(result.isSuccess, isTrue);
    });

    test('sends refresh token', () async {
      when(
        () => mockApi.post('/v1/auth/logout', data: any(named: 'data')),
      ).thenAnswer((_) async => const Success(<String, dynamic>{}));

      await sut.logout('my-refresh');
      verify(
        () => mockApi.post(
          '/v1/auth/logout',
          data: {'refresh_token': 'my-refresh'},
        ),
      ).called(1);
    });

    test('returns AuthFailure on error', () async {
      when(
        () => mockApi.post('/v1/auth/logout', data: any(named: 'data')),
      ).thenAnswer(
        (_) async => const Err(NetworkFailure('server error', statusCode: 500)),
      );

      final result = await sut.logout('token');
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<AuthFailure>());
    });
  });

  group('forgotPassword', () {
    test('returns Success', () async {
      when(
        () =>
            mockApi.post('/v1/auth/forgot-password', data: any(named: 'data')),
      ).thenAnswer((_) async => const Success(<String, dynamic>{}));

      final result = await sut.forgotPassword('user@test.com');
      expect(result.isSuccess, isTrue);
    });

    test('returns AuthFailure on error', () async {
      when(
        () =>
            mockApi.post('/v1/auth/forgot-password', data: any(named: 'data')),
      ).thenAnswer(
        (_) async => const Err(NetworkFailure('rate limited', statusCode: 429)),
      );

      final result = await sut.forgotPassword('user@test.com');
      expect(result.isFailure, isTrue);
    });
  });

  group('resetPassword', () {
    test('returns Success', () async {
      when(
        () => mockApi.post('/v1/auth/reset-password', data: any(named: 'data')),
      ).thenAnswer((_) async => const Success(<String, dynamic>{}));

      final result = await sut.resetPassword('reset-token', 'new-pass');
      expect(result.isSuccess, isTrue);
    });

    test('sends token and new_password', () async {
      when(
        () => mockApi.post('/v1/auth/reset-password', data: any(named: 'data')),
      ).thenAnswer((_) async => const Success(<String, dynamic>{}));

      await sut.resetPassword('tok', 'pass');
      verify(
        () => mockApi.post(
          '/v1/auth/reset-password',
          data: {'token': 'tok', 'new_password': 'pass'},
        ),
      ).called(1);
    });
  });

  group('verifyEmail', () {
    test('returns Success', () async {
      when(
        () => mockApi.get(any()),
      ).thenAnswer((_) async => const Success(<String, dynamic>{}));

      final result = await sut.verifyEmail('verify-token');
      expect(result.isSuccess, isTrue);
    });

    test('returns AuthFailure on error', () async {
      when(() => mockApi.get(any())).thenAnswer(
        (_) async =>
            const Err(NetworkFailure('token expired', statusCode: 410)),
      );

      final result = await sut.verifyEmail('expired-token');
      expect(result.isFailure, isTrue);
    });
  });
}
