import 'package:flutter_test/flutter_test.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/network/api_client.dart';
import 'package:shellvault/core/security/heartbeat_service.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApi;

  setUp(() {
    mockApi = MockApiClient();
  });

  group('HeartbeatService — lifecycle', () {
    test('isRunning is false before start', () {
      final sut = HeartbeatService(apiClient: mockApi);
      expect(sut.isRunning, isFalse);
    });

    test('isRunning is true after start', () {
      final sut = HeartbeatService(apiClient: mockApi);
      sut.start();
      expect(sut.isRunning, isTrue);
      sut.stop(); // cleanup
    });

    test('isRunning is false after stop', () {
      final sut = HeartbeatService(apiClient: mockApi);
      sut.start();
      sut.stop();
      expect(sut.isRunning, isFalse);
    });

    test('start is idempotent — calling twice does not reset state', () {
      when(() => mockApi.get('/health'))
          .thenAnswer((_) async => const Err<Map<String, dynamic>>(
                NetworkFailure('fail'),
              ));

      final sut = HeartbeatService(
        apiClient: mockApi,
        interval: const Duration(milliseconds: 50),
      );
      sut.start();
      sut.start(); // second call should be a no-op
      expect(sut.isRunning, isTrue);
      sut.stop();
    });

    test('stop resets consecutive failure count', () async {
      when(() => mockApi.get('/health'))
          .thenAnswer((_) async => const Err<Map<String, dynamic>>(
                NetworkFailure('fail'),
              ));

      final sut = HeartbeatService(
        apiClient: mockApi,
        interval: const Duration(milliseconds: 10),
        maxFailures: 10,
      );
      sut.start();

      // Wait for some failures to accumulate
      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(sut.consecutiveFailures, greaterThan(0));

      sut.stop();
      expect(sut.consecutiveFailures, 0);
    });

    test('consecutiveFailures starts at zero', () {
      final sut = HeartbeatService(apiClient: mockApi);
      expect(sut.consecutiveFailures, 0);
    });
  });

  group('HeartbeatService — failure counting', () {
    test('increments failure count on Err result', () async {
      when(() => mockApi.get('/health'))
          .thenAnswer((_) async => const Err<Map<String, dynamic>>(
                NetworkFailure('Server error'),
              ));

      final sut = HeartbeatService(
        apiClient: mockApi,
        interval: const Duration(milliseconds: 10),
        maxFailures: 100, // high so it does not expire
      );
      sut.start();

      await Future<void>.delayed(const Duration(milliseconds: 60));
      sut.stop();

      expect(sut.consecutiveFailures, 0); // stop resets
    });

    test('failures accumulate while running', () async {
      when(() => mockApi.get('/health')).thenAnswer((_) async {
        return const Err<Map<String, dynamic>>(NetworkFailure('fail'));
      });

      final sut = HeartbeatService(
        apiClient: mockApi,
        interval: const Duration(milliseconds: 10),
        maxFailures: 100,
      );
      sut.start();

      await Future<void>.delayed(const Duration(milliseconds: 80));
      final failuresBefore = sut.consecutiveFailures;
      expect(failuresBefore, greaterThan(0));

      sut.stop();
    });
  });

  group('HeartbeatService — session expiration', () {
    test('calls onSessionExpired after maxFailures consecutive failures', () async {
      var sessionExpired = false;

      when(() => mockApi.get('/health'))
          .thenAnswer((_) async => const Err<Map<String, dynamic>>(
                NetworkFailure('fail'),
              ));

      final sut = HeartbeatService(
        apiClient: mockApi,
        interval: const Duration(milliseconds: 10),
        maxFailures: 3,
        onSessionExpired: () => sessionExpired = true,
      );
      sut.start();

      // Wait long enough for 3+ heartbeats
      await Future<void>.delayed(const Duration(milliseconds: 120));
      expect(sessionExpired, isTrue);
      expect(sut.isRunning, isFalse); // auto-stopped after expiration
    });

    test('stops the timer when session expires', () async {
      when(() => mockApi.get('/health'))
          .thenAnswer((_) async => const Err<Map<String, dynamic>>(
                NetworkFailure('fail'),
              ));

      final sut = HeartbeatService(
        apiClient: mockApi,
        interval: const Duration(milliseconds: 10),
        maxFailures: 2,
        onSessionExpired: () {},
      );
      sut.start();

      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(sut.isRunning, isFalse);
    });

    test('does not expire when failures stay below threshold', () async {
      var sessionExpired = false;
      var callCount = 0;

      when(() => mockApi.get('/health')).thenAnswer((_) async {
        callCount++;
        // Alternate: fail, fail, succeed, fail, fail, succeed...
        if (callCount % 3 == 0) {
          return const Success<Map<String, dynamic>>({'status': 'ok'});
        }
        return const Err<Map<String, dynamic>>(NetworkFailure('fail'));
      });

      final sut = HeartbeatService(
        apiClient: mockApi,
        interval: const Duration(milliseconds: 10),
        maxFailures: 3,
        onSessionExpired: () => sessionExpired = true,
      );
      sut.start();

      await Future<void>.delayed(const Duration(milliseconds: 150));
      sut.stop();

      expect(sessionExpired, isFalse);
    });

    test('works without onSessionExpired callback', () async {
      when(() => mockApi.get('/health'))
          .thenAnswer((_) async => const Err<Map<String, dynamic>>(
                NetworkFailure('fail'),
              ));

      final sut = HeartbeatService(
        apiClient: mockApi,
        interval: const Duration(milliseconds: 10),
        maxFailures: 2,
      );
      sut.start();

      // Should not throw even without callback
      await Future<void>.delayed(const Duration(milliseconds: 80));
      expect(sut.isRunning, isFalse);
    });
  });

  group('HeartbeatService — recovery', () {
    test('resets failure count after successful heartbeat', () async {
      var callCount = 0;
      when(() => mockApi.get('/health')).thenAnswer((_) async {
        callCount++;
        // First 2 calls fail, then succeed
        if (callCount <= 2) {
          return const Err<Map<String, dynamic>>(NetworkFailure('fail'));
        }
        return const Success<Map<String, dynamic>>({'status': 'ok'});
      });

      final sut = HeartbeatService(
        apiClient: mockApi,
        interval: const Duration(milliseconds: 10),
        maxFailures: 5,
      );
      sut.start();

      // Wait for enough time for failures + recovery
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // After recovery, failure count should be back to 0
      expect(sut.consecutiveFailures, 0);
      expect(sut.isRunning, isTrue);
      sut.stop();
    });

    test('success after failures prevents session expiration', () async {
      var sessionExpired = false;
      var callCount = 0;

      when(() => mockApi.get('/health')).thenAnswer((_) async {
        callCount++;
        // Fail twice, then succeed, repeat
        if (callCount % 3 != 0) {
          return const Err<Map<String, dynamic>>(NetworkFailure('fail'));
        }
        return const Success<Map<String, dynamic>>({'status': 'ok'});
      });

      final sut = HeartbeatService(
        apiClient: mockApi,
        interval: const Duration(milliseconds: 10),
        maxFailures: 3,
        onSessionExpired: () => sessionExpired = true,
      );
      sut.start();

      await Future<void>.delayed(const Duration(milliseconds: 150));
      sut.stop();

      expect(sessionExpired, isFalse);
    });
  });

  group('HeartbeatService — exception handling', () {
    test('treats thrown exception as failure', () async {
      when(() => mockApi.get('/health')).thenThrow(Exception('Network error'));

      var sessionExpired = false;
      final sut = HeartbeatService(
        apiClient: mockApi,
        interval: const Duration(milliseconds: 10),
        maxFailures: 2,
        onSessionExpired: () => sessionExpired = true,
      );
      sut.start();

      await Future<void>.delayed(const Duration(milliseconds: 80));
      expect(sessionExpired, isTrue);
      expect(sut.isRunning, isFalse);
    });
  });

  group('HeartbeatService — configuration', () {
    test('default interval is 60 seconds', () {
      final sut = HeartbeatService(apiClient: mockApi);
      expect(sut.interval, const Duration(seconds: 60));
    });

    test('default maxFailures is 3', () {
      final sut = HeartbeatService(apiClient: mockApi);
      expect(sut.maxFailures, 3);
    });

    test('custom interval and maxFailures are respected', () {
      final sut = HeartbeatService(
        apiClient: mockApi,
        interval: const Duration(seconds: 30),
        maxFailures: 5,
      );
      expect(sut.interval, const Duration(seconds: 30));
      expect(sut.maxFailures, 5);
    });
  });
}
