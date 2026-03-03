import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/network/api_client.dart';
import 'package:shellvault/features/account/data/repositories/account_repository_impl.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApi;
  late AccountRepositoryImpl sut;

  final userJson = {
    'id': 'u1',
    'email': 'test@example.com',
    'verified': true,
  };

  setUp(() {
    mockApi = MockApiClient();
    sut = AccountRepositoryImpl(mockApi);
  });

  group('getProfile', () {
    test('returns UserEntity on success', () async {
      when(() => mockApi.get('/v1/user'))
          .thenAnswer((_) async => Success(userJson));

      final result = await sut.getProfile();
      expect(result.isSuccess, isTrue);
      expect(result.value.email, 'test@example.com');
      expect(result.value.verified, isTrue);
    });

    test('returns failure on network error', () async {
      when(() => mockApi.get('/v1/user')).thenAnswer(
        (_) async => const Err(NetworkFailure('unauthorized', statusCode: 401)),
      );

      final result = await sut.getProfile();
      expect(result.isFailure, isTrue);
    });
  });

  group('updateProfile', () {
    test('returns updated UserEntity on success', () async {
      when(() => mockApi.put('/v1/user', data: any(named: 'data')))
          .thenAnswer((_) async => Success(userJson));

      final result = await sut.updateProfile(email: 'new@test.com');
      expect(result.isSuccess, isTrue);
    });

    test('returns failure on error', () async {
      when(() => mockApi.put('/v1/user', data: any(named: 'data')))
          .thenAnswer(
        (_) async => const Err(NetworkFailure('invalid email', statusCode: 422)),
      );

      final result = await sut.updateProfile(email: 'bad');
      expect(result.isFailure, isTrue);
    });
  });

  group('changePassword', () {
    test('returns Success on password change', () async {
      when(() => mockApi.put('/v1/user/password', data: any(named: 'data')))
          .thenAnswer((_) async => const Success(<String, dynamic>{}));

      final result = await sut.changePassword('old-pass', 'new-pass');
      expect(result.isSuccess, isTrue);
    });

    test('sends correct payload', () async {
      when(() => mockApi.put('/v1/user/password', data: any(named: 'data')))
          .thenAnswer((_) async => const Success(<String, dynamic>{}));

      await sut.changePassword('old', 'new');
      verify(() => mockApi.put(
            '/v1/user/password',
            data: {'current_password': 'old', 'new_password': 'new'},
          )).called(1);
    });

    test('returns failure on wrong password', () async {
      when(() => mockApi.put('/v1/user/password', data: any(named: 'data')))
          .thenAnswer(
        (_) async => const Err(NetworkFailure('wrong password', statusCode: 401)),
      );

      final result = await sut.changePassword('wrong', 'new');
      expect(result.isFailure, isTrue);
    });
  });

  group('deleteAccount', () {
    test('returns Success', () async {
      when(() => mockApi.delete('/v1/user'))
          .thenAnswer((_) async => const Success(<String, dynamic>{}));

      final result = await sut.deleteAccount();
      expect(result.isSuccess, isTrue);
    });

    test('returns failure on error', () async {
      when(() => mockApi.delete('/v1/user')).thenAnswer(
        (_) async => const Err(NetworkFailure('server error', statusCode: 500)),
      );

      final result = await sut.deleteAccount();
      expect(result.isFailure, isTrue);
    });
  });

  group('getDevices', () {
    test('returns list of DeviceEntity on success', () async {
      when(() => mockApi.get('/v1/devices')).thenAnswer(
        (_) async => const Success({
          'devices': [
            {'id': 'd1', 'name': 'iPhone', 'platform': 'ios'},
            {'id': 'd2', 'name': 'MacBook', 'platform': 'macos'},
          ],
        }),
      );

      final result = await sut.getDevices();
      expect(result.isSuccess, isTrue);
      expect(result.value, hasLength(2));
      expect(result.value[0].name, 'iPhone');
      expect(result.value[1].platform, 'macos');
    });

    test('returns empty list when no devices', () async {
      when(() => mockApi.get('/v1/devices')).thenAnswer(
        (_) async => const Success(<String, dynamic>{}),
      );

      final result = await sut.getDevices();
      expect(result.isSuccess, isTrue);
      expect(result.value, isEmpty);
    });

    test('returns failure on error', () async {
      when(() => mockApi.get('/v1/devices')).thenAnswer(
        (_) async => const Err(NetworkFailure('offline')),
      );

      final result = await sut.getDevices();
      expect(result.isFailure, isTrue);
    });
  });

  group('registerDevice', () {
    test('returns device ID on success', () async {
      when(() => mockApi.post('/v1/devices', data: any(named: 'data')))
          .thenAnswer((_) async => const Success({'id': 'new-device-id'}));

      final result = await sut.registerDevice('My Phone', 'android');
      expect(result.isSuccess, isTrue);
      expect(result.value, 'new-device-id');
    });

    test('sends name and platform', () async {
      when(() => mockApi.post('/v1/devices', data: any(named: 'data')))
          .thenAnswer((_) async => const Success({'id': 'x'}));

      await sut.registerDevice('iPad', 'ios');
      verify(() => mockApi.post(
            '/v1/devices',
            data: {'name': 'iPad', 'platform': 'ios'},
          )).called(1);
    });
  });

  group('deleteDevice', () {
    test('returns Success', () async {
      when(() => mockApi.delete('/v1/devices/d1'))
          .thenAnswer((_) async => const Success(<String, dynamic>{}));

      final result = await sut.deleteDevice('d1');
      expect(result.isSuccess, isTrue);
    });
  });

  group('logoutAllDevices', () {
    test('returns revoked count', () async {
      when(() => mockApi.post('/v1/auth/logout-all'))
          .thenAnswer((_) async => const Success({'revoked': 5}));

      final result = await sut.logoutAllDevices();
      expect(result.isSuccess, isTrue);
      expect(result.value, 5);
    });
  });

  group('getBillingStatus', () {
    test('returns BillingStatus on success', () async {
      when(() => mockApi.get('/v1/billing/status')).thenAnswer(
        (_) async => const Success({
          'active': true,
          'provider': 'stripe',
          'status': 'active',
        }),
      );

      final result = await sut.getBillingStatus();
      expect(result.isSuccess, isTrue);
      expect(result.value.active, isTrue);
      expect(result.value.provider, 'stripe');
    });

    test('returns failure on error', () async {
      when(() => mockApi.get('/v1/billing/status')).thenAnswer(
        (_) async => const Err(NetworkFailure('offline')),
      );

      final result = await sut.getBillingStatus();
      expect(result.isFailure, isTrue);
    });
  });

  group('createCheckout', () {
    test('returns URL on success', () async {
      when(() => mockApi.post('/v1/billing/checkout')).thenAnswer(
        (_) async => const Success({'url': 'https://checkout.stripe.com/xxx'}),
      );

      final result = await sut.createCheckout();
      expect(result.isSuccess, isTrue);
      expect(result.value, contains('stripe.com'));
    });
  });

  group('createPortal', () {
    test('returns URL on success', () async {
      when(() => mockApi.post('/v1/billing/portal')).thenAnswer(
        (_) async => const Success({'url': 'https://portal.stripe.com/xxx'}),
      );

      final result = await sut.createPortal();
      expect(result.isSuccess, isTrue);
      expect(result.value, contains('stripe.com'));
    });
  });

  group('getAuditLogs', () {
    test('returns AuditLogResult on success', () async {
      when(() => mockApi.get(
            '/v1/audit',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => const Success({
          'audit_logs': [
            {
              'id': 'log1',
              'timestamp': '2025-01-01T00:00:00Z',
              'level': 'info',
              'category': 'AUTH',
              'action': 'LOGIN',
            },
          ],
          'total': 1,
          'limit': 50,
          'offset': 0,
        }),
      );

      final result = await sut.getAuditLogs();
      expect(result.isSuccess, isTrue);
      expect(result.value.logs, hasLength(1));
      expect(result.value.logs[0].category, 'AUTH');
      expect(result.value.total, 1);
    });

    test('passes query parameters', () async {
      when(() => mockApi.get(
            '/v1/audit',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => const Success({
          'audit_logs': [],
          'total': 0,
          'limit': 50,
          'offset': 0,
        }),
      );

      await sut.getAuditLogs(
        category: 'AUTH',
        limit: 25,
        offset: 10,
      );
      verify(() => mockApi.get(
            '/v1/audit',
            queryParameters: {
              'limit': '25',
              'offset': '10',
              'category': 'AUTH',
            },
          )).called(1);
    });

    test('returns failure on error', () async {
      when(() => mockApi.get(
            '/v1/audit',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => const Err(NetworkFailure('unauthorized', statusCode: 401)),
      );

      final result = await sut.getAuditLogs();
      expect(result.isFailure, isTrue);
    });
  });
}
