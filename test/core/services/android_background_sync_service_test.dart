// Unit tests for the Android WorkManager background sync service.
//
// We mock the `Workmanager` plugin singleton with `mocktail` so the
// register / cancel paths can be exercised on any host (including Linux
// CI) without spinning up an actual MethodChannel binding. The platform
// gate inside `AndroidBackgroundSyncService` short-circuits on non-Android
// hosts, so the assertions are split into two groups depending on
// `Platform.isAndroid`.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workmanager/workmanager.dart';

import 'package:sshvault/core/services/android_background_sync_service.dart';

class _MockWorkmanager extends Mock implements Workmanager {}

class _FakeConstraints extends Fake implements Constraints {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(_FakeConstraints());
    registerFallbackValue(ExistingPeriodicWorkPolicy.update);
    registerFallbackValue(BackoffPolicy.exponential);
    registerFallbackValue(Duration.zero);
  });

  group('AndroidBackgroundSyncService — platform gating', () {
    test('non-Android hosts treat enable/disable as no-ops', () async {
      if (Platform.isAndroid) return;
      final mock = _MockWorkmanager();
      final svc = AndroidBackgroundSyncService(workmanager: mock);

      await svc.enableBackgroundSync();
      await svc.disable();

      // Plugin must never be touched on iOS / desktop — the static
      // platform gate short-circuits before any method dispatches.
      verifyZeroInteractions(mock);
    });
  });

  group('AndroidBackgroundSyncService — Android behaviour', () {
    late _MockWorkmanager mock;
    late AndroidBackgroundSyncService svc;

    setUp(() {
      mock = _MockWorkmanager();
      svc = AndroidBackgroundSyncService(workmanager: mock);

      when(
        () =>
            mock.initialize(any(), isInDebugMode: any(named: 'isInDebugMode')),
      ).thenAnswer((_) async {});
      when(
        () => mock.registerPeriodicTask(
          any(),
          any(),
          frequency: any(named: 'frequency'),
          constraints: any(named: 'constraints'),
          existingWorkPolicy: any(named: 'existingWorkPolicy'),
          backoffPolicy: any(named: 'backoffPolicy'),
          backoffPolicyDelay: any(named: 'backoffPolicyDelay'),
        ),
      ).thenAnswer((_) async {});
      when(() => mock.cancelByUniqueName(any())).thenAnswer((_) async {});
    });

    test('enableBackgroundSync registers a periodic task with NETWORK '
        'connectivity constraint', () async {
      if (!Platform.isAndroid) return;

      await svc.enableBackgroundSync(interval: const Duration(hours: 1));

      verify(
        () =>
            mock.initialize(any(), isInDebugMode: any(named: 'isInDebugMode')),
      ).called(1);
      verify(
        () => mock.registerPeriodicTask(
          'sshvault.periodic-sync',
          'sshvault.periodic-sync',
          frequency: const Duration(hours: 1),
          constraints: any(
            named: 'constraints',
            that: isA<Constraints>().having(
              (c) => c.networkType,
              'networkType',
              NetworkType.connected,
            ),
          ),
          existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
          backoffPolicy: BackoffPolicy.exponential,
          backoffPolicyDelay: any(named: 'backoffPolicyDelay'),
        ),
      ).called(1);
    });

    test('enableBackgroundSync only initializes the plugin once', () async {
      if (!Platform.isAndroid) return;

      await svc.enableBackgroundSync();
      await svc.enableBackgroundSync(interval: const Duration(hours: 2));

      // initialize() must be idempotent — calling enable twice in a row
      // should not re-spin the headless engine.
      verify(
        () =>
            mock.initialize(any(), isInDebugMode: any(named: 'isInDebugMode')),
      ).called(1);
      verify(
        () => mock.registerPeriodicTask(
          any(),
          any(),
          frequency: any(named: 'frequency'),
          constraints: any(named: 'constraints'),
          existingWorkPolicy: any(named: 'existingWorkPolicy'),
          backoffPolicy: any(named: 'backoffPolicy'),
          backoffPolicyDelay: any(named: 'backoffPolicyDelay'),
        ),
      ).called(2);
    });

    test('disable cancels the unique work', () async {
      if (!Platform.isAndroid) return;

      await svc.disable();

      verify(() => mock.cancelByUniqueName('sshvault.periodic-sync')).called(1);
    });
  });
}
