// Unit tests for [MacosBiometricGate].
//
// We mock `LocalAuthentication` rather than wiring through the platform
// channel — `local_auth`'s plugin registrant is unreachable under
// `flutter test` and the gate's logic (cache TTL, exception mapping,
// non-macOS pass-through) is the bit worth covering here. The native
// LAContext flow is exercised by integration tests on macOS runners.

import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/services/macos_biometric_gate.dart';

class _MockLocalAuth extends Mock implements LocalAuthentication {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MacosBiometricGate — non-macOS pass-through', () {
    test('returns Success without touching LocalAuthentication', () async {
      final mock = _MockLocalAuth();
      final gate = MacosBiometricGate(auth: mock, isMacOsOverride: false);

      final result = await gate.authenticate();

      expect(result.isSuccess, isTrue);
      // Critically: we must NOT have prompted on Linux / Windows.
      verifyNever(
        () => mock.authenticate(
          localizedReason: any(named: 'localizedReason'),
          biometricOnly: any(named: 'biometricOnly'),
        ),
      );
    });
  });

  group('MacosBiometricGate — success path', () {
    late _MockLocalAuth mock;

    setUp(() {
      mock = _MockLocalAuth();
      when(
        () => mock.authenticate(
          localizedReason: any(named: 'localizedReason'),
          biometricOnly: any(named: 'biometricOnly'),
        ),
      ).thenAnswer((_) async => true);
    });

    test(
      'returns Success and forwards localizedReason + biometricOnly',
      () async {
        final gate = MacosBiometricGate(auth: mock, isMacOsOverride: true);

        final result = await gate.authenticate(reason: 'unlock for keychain');

        expect(result.isSuccess, isTrue);
        verify(
          () => mock.authenticate(
            localizedReason: 'unlock for keychain',
            biometricOnly: true,
          ),
        ).called(1);
      },
    );

    test(
      'local_auth returning false maps to AuthFailure (treated as cancel)',
      () async {
        when(
          () => mock.authenticate(
            localizedReason: any(named: 'localizedReason'),
            biometricOnly: any(named: 'biometricOnly'),
          ),
        ).thenAnswer((_) async => false);
        final gate = MacosBiometricGate(auth: mock, isMacOsOverride: true);

        final result = await gate.authenticate();

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<AuthFailure>());
      },
    );
  });

  group('MacosBiometricGate — exception mapping', () {
    late _MockLocalAuth mock;
    late MacosBiometricGate gate;

    setUp(() {
      mock = _MockLocalAuth();
      gate = MacosBiometricGate(auth: mock, isMacOsOverride: true);
    });

    void stubThrows(LocalAuthExceptionCode code) {
      when(
        () => mock.authenticate(
          localizedReason: any(named: 'localizedReason'),
          biometricOnly: any(named: 'biometricOnly'),
        ),
      ).thenThrow(LocalAuthException(code: code, description: code.name));
    }

    test('userCanceled maps to AuthFailure', () async {
      stubThrows(LocalAuthExceptionCode.userCanceled);
      final r = await gate.authenticate();
      expect(r.isFailure, isTrue);
      expect(r.failure, isA<AuthFailure>());
    });

    test('userRequestedFallback maps to AuthFailure', () async {
      stubThrows(LocalAuthExceptionCode.userRequestedFallback);
      final r = await gate.authenticate();
      expect(r.failure, isA<AuthFailure>());
    });

    test('biometricLockout maps to SecurityViolation', () async {
      stubThrows(LocalAuthExceptionCode.biometricLockout);
      final r = await gate.authenticate();
      expect(r.isFailure, isTrue);
      expect(r.failure, isA<SecurityViolation>());
    });

    test('temporaryLockout maps to SecurityViolation', () async {
      stubThrows(LocalAuthExceptionCode.temporaryLockout);
      final r = await gate.authenticate();
      expect(r.failure, isA<SecurityViolation>());
    });

    test('noBiometricsEnrolled maps to AuthFailure (unavailable)', () async {
      stubThrows(LocalAuthExceptionCode.noBiometricsEnrolled);
      final r = await gate.authenticate();
      expect(r.failure, isA<AuthFailure>());
    });

    test('noBiometricHardware maps to AuthFailure (unavailable)', () async {
      stubThrows(LocalAuthExceptionCode.noBiometricHardware);
      final r = await gate.authenticate();
      expect(r.failure, isA<AuthFailure>());
    });

    test('unknownError maps to AuthFailure with cause preserved', () async {
      stubThrows(LocalAuthExceptionCode.unknownError);
      final r = await gate.authenticate();
      expect(r.failure, isA<AuthFailure>());
      expect((r.failure as AuthFailure).cause, isA<LocalAuthException>());
    });

    test('non-LocalAuthException is wrapped in AuthFailure', () async {
      when(
        () => mock.authenticate(
          localizedReason: any(named: 'localizedReason'),
          biometricOnly: any(named: 'biometricOnly'),
        ),
      ).thenThrow(StateError('platform exploded'));
      final r = await gate.authenticate();
      expect(r.isFailure, isTrue);
      expect(r.failure, isA<AuthFailure>());
    });
  });

  group('MacosBiometricGate — cache TTL', () {
    late _MockLocalAuth mock;
    late DateTime fakeNow;

    setUp(() {
      mock = _MockLocalAuth();
      fakeNow = DateTime.utc(2026, 1, 1, 12);
      when(
        () => mock.authenticate(
          localizedReason: any(named: 'localizedReason'),
          biometricOnly: any(named: 'biometricOnly'),
        ),
      ).thenAnswer((_) async => true);
    });

    test('cached success suppresses re-prompt within TTL', () async {
      final gate = MacosBiometricGate(
        auth: mock,
        isMacOsOverride: true,
        cacheTtl: const Duration(seconds: 60),
        clock: () => fakeNow,
      );

      // First call: real prompt.
      final r1 = await gate.authenticate();
      expect(r1.isSuccess, isTrue);

      // Advance 30s — still inside TTL.
      fakeNow = fakeNow.add(const Duration(seconds: 30));
      final r2 = await gate.authenticate();
      expect(r2.isSuccess, isTrue);

      verify(
        () => mock.authenticate(
          localizedReason: any(named: 'localizedReason'),
          biometricOnly: any(named: 'biometricOnly'),
        ),
      ).called(1);
    });

    test('TTL expiry forces a re-prompt', () async {
      final gate = MacosBiometricGate(
        auth: mock,
        isMacOsOverride: true,
        cacheTtl: const Duration(seconds: 60),
        clock: () => fakeNow,
      );

      await gate.authenticate();

      // Step past the 60-second window.
      fakeNow = fakeNow.add(const Duration(seconds: 61));
      await gate.authenticate();

      verify(
        () => mock.authenticate(
          localizedReason: any(named: 'localizedReason'),
          biometricOnly: any(named: 'biometricOnly'),
        ),
      ).called(2);
    });

    test('failed auth does not seed the cache', () async {
      when(
        () => mock.authenticate(
          localizedReason: any(named: 'localizedReason'),
          biometricOnly: any(named: 'biometricOnly'),
        ),
      ).thenThrow(
        const LocalAuthException(code: LocalAuthExceptionCode.userCanceled),
      );
      final gate = MacosBiometricGate(
        auth: mock,
        isMacOsOverride: true,
        cacheTtl: const Duration(seconds: 60),
        clock: () => fakeNow,
      );

      final r1 = await gate.authenticate();
      expect(r1.isFailure, isTrue);

      // No advance: a second call must still hit the platform.
      final r2 = await gate.authenticate();
      expect(r2.isFailure, isTrue);

      verify(
        () => mock.authenticate(
          localizedReason: any(named: 'localizedReason'),
          biometricOnly: any(named: 'biometricOnly'),
        ),
      ).called(2);
    });

    test('invalidateCache() clears the cached success', () async {
      final gate = MacosBiometricGate(
        auth: mock,
        isMacOsOverride: true,
        cacheTtl: const Duration(seconds: 60),
        clock: () => fakeNow,
      );

      await gate.authenticate();
      gate.invalidateCache();
      await gate.authenticate();

      verify(
        () => mock.authenticate(
          localizedReason: any(named: 'localizedReason'),
          biometricOnly: any(named: 'biometricOnly'),
        ),
      ).called(2);
    });
  });
}
