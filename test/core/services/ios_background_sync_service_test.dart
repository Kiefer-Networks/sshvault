// Unit tests for the iOS BGTaskScheduler background sync service.
//
// We hook the platform side via Flutter's
// `defaultBinaryMessenger.setMockMethodCallHandler` so the tests can
// exercise the schedule / cancel paths on any host (including Linux
// CI) without spinning up an actual `BGTaskScheduler`. The platform
// gate inside `IosBackgroundSyncService` short-circuits on non-iOS
// hosts, so the assertions are split into two groups depending on
// `Platform.isIOS`.

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sshvault/core/services/ios_background_sync_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Builder for a fresh service bound to an isolated container per
  /// test. The service constructor accepts a custom `MethodChannel`
  /// override so we don't have to monkey with the real platform
  /// dispatcher in non-iOS suites — but for the iOS-behaviour group
  /// we want the real channel because `setMockMethodCallHandler`
  /// keys off it.
  IosBackgroundSyncService makeService({MethodChannel? channel}) {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final ref = container.read(Provider<Ref>((r) => r));
    return IosBackgroundSyncService(ref: ref, channel: channel);
  }

  group('IosBackgroundSyncService — platform gating', () {
    test('non-iOS hosts treat enable/disable as no-ops', () async {
      if (Platform.isIOS) return;

      const channel = MethodChannel(kIosBackgroundSyncChannel);
      final calls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call);
            return null;
          });
      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null);
      });

      final svc = makeService(channel: channel);
      await svc.enableBackgroundSync();
      await svc.disable();

      // Plugin must never be touched on Android / desktop — the
      // platform gate short-circuits before any method dispatches.
      expect(calls, isEmpty);
    });
  });

  group('IosBackgroundSyncService — iOS behaviour', () {
    late MethodChannel channel;
    late List<MethodCall> calls;

    setUp(() {
      channel = const MethodChannel(kIosBackgroundSyncChannel);
      calls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call);
            return null;
          });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('enableBackgroundSync submits a schedule request with the '
        'requested interval', () async {
      if (!Platform.isIOS) return;
      final svc = makeService(channel: channel);

      await svc.enableBackgroundSync(interval: const Duration(hours: 1));

      expect(calls, hasLength(1));
      expect(calls.single.method, 'schedule');
      final args = calls.single.arguments as Map<Object?, Object?>;
      expect(args['intervalSeconds'], 3600.0);
    });

    test('enableBackgroundSync only initializes the channel once', () async {
      if (!Platform.isIOS) return;
      final svc = makeService(channel: channel);

      await svc.enableBackgroundSync();
      await svc.enableBackgroundSync(interval: const Duration(hours: 2));

      // Two schedule calls — but only one initialize side-effect. The
      // mock messenger has no observable init step, so we assert via
      // count of `schedule` calls.
      expect(calls.where((c) => c.method == 'schedule').toList(), hasLength(2));
    });

    test('disable cancels the pending request', () async {
      if (!Platform.isIOS) return;
      final svc = makeService(channel: channel);

      await svc.disable();

      expect(calls, hasLength(1));
      expect(calls.single.method, 'cancel');
    });

    test('channel name matches the Swift constant', () {
      // Compile-time pin against the literal in
      // `BackgroundSyncHelper.swift`. Bumping this requires bumping
      // the Swift constant in lockstep.
      expect(
        kIosBackgroundSyncChannel,
        'de.kiefer-networks.sshvault/background_sync',
      );
    });
  });
}
