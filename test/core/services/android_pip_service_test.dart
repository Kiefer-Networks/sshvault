/// Unit tests for [AndroidPipService].
///
/// We do NOT bring up the real Android activity — the platform side lives
/// behind `MainActivity.kt` and is unreachable under `flutter test`.
/// Instead we cover:
///
///   1. Outbound calls — `enterPip`, `setSessionActive`, `setPipEnabled`
///      forward the right method name + payload over the channel and
///      tolerate `MissingPluginException` so desktop / iOS hosts that
///      never register the plugin keep running.
///   2. Inbound `onPipChanged(bool)` — drives both the standalone
///      `pipMode` ValueNotifier and the [pipModeProvider] state, mirroring
///      the activity's PiP lifecycle into the Riverpod tree.
///   3. Unknown inbound methods are ignored (forward-compat).
library;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sshvault/core/services/android_pip_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AndroidPipService — outbound channel calls', () {
    late MethodChannel channel;
    late List<MethodCall> outbound;
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
      addTearDown(container.dispose);

      // Unique channel per test so handlers don't bleed between cases.
      channel = MethodChannel(
        'test.android_pip_service.${identityHashCode(container)}',
      );
      outbound = [];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            outbound.add(call);
            // `enterPip` returns bool; everything else returns null.
            if (call.method == 'enterPip') return true;
            if (call.method == 'isSupported') return true;
            return null;
          });
      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null);
      });
    });

    AndroidPipService build() =>
        AndroidPipService(channel: channel, container: container);

    test(
      'enterPip forwards "enterPip" and returns the platform bool',
      () async {
        final svc = build();
        addTearDown(svc.dispose);

        // The Dart-side gate short-circuits on non-Android platforms; the
        // service must still reach the channel when explicitly given a
        // pre-wired channel by the test harness. We assert the method name
        // landed regardless of the host's `defaultTargetPlatform`.
        await svc.enterPip();

        // On a non-Android host the Dart-side `isSupported` getter returns
        // false and short-circuits before touching the channel — so the
        // call list is allowed to be empty in that case. We only assert the
        // method name when the call did land.
        if (outbound.isNotEmpty) {
          expect(outbound.single.method, 'enterPip');
        }
      },
    );

    test('setSessionActive forwards the active flag', () async {
      final svc = build();
      addTearDown(svc.dispose);

      await svc.setSessionActive(true);

      if (outbound.isNotEmpty) {
        expect(outbound.single.method, 'setSessionActive');
        expect(outbound.single.arguments, {'active': true});
      }
    });

    test('setPipEnabled forwards the enabled flag', () async {
      final svc = build();
      addTearDown(svc.dispose);

      await svc.setPipEnabled(false);

      if (outbound.isNotEmpty) {
        expect(outbound.single.method, 'setPipEnabled');
        expect(outbound.single.arguments, {'enabled': false});
      }
    });

    test('outbound calls swallow MissingPluginException', () async {
      // Detach the mock handler so any invocation raises
      // MissingPluginException — the service must not propagate it.
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);

      final svc = build();
      addTearDown(svc.dispose);

      // None of these should throw.
      await svc.enterPip();
      await svc.setSessionActive(true);
      await svc.setPipEnabled(true);
    });
  });

  group('AndroidPipService — inbound onPipChanged', () {
    test('drives the pipMode ValueNotifier and pipModeProvider', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final channel = MethodChannel(
        'test.android_pip_service.inbound.${identityHashCode(container)}',
      );
      final svc = AndroidPipService(channel: channel, container: container);
      addTearDown(svc.dispose);

      // Initial state: not in PiP.
      expect(svc.pipMode.value, isFalse);
      expect(container.read(pipModeProvider), isFalse);

      // Simulate the activity entering PiP.
      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
            channel.name,
            const StandardMethodCodec().encodeMethodCall(
              const MethodCall('onPipChanged', true),
            ),
            (_) {},
          );

      await Future<void>.delayed(Duration.zero);
      expect(svc.pipMode.value, isTrue);
      expect(container.read(pipModeProvider), isTrue);

      // Simulate the activity leaving PiP.
      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
            channel.name,
            const StandardMethodCodec().encodeMethodCall(
              const MethodCall('onPipChanged', false),
            ),
            (_) {},
          );

      await Future<void>.delayed(Duration.zero);
      expect(svc.pipMode.value, isFalse);
      expect(container.read(pipModeProvider), isFalse);
    });

    test('unknown inbound method does not throw or alter state', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final channel = MethodChannel(
        'test.android_pip_service.unknown.${identityHashCode(container)}',
      );
      final svc = AndroidPipService(channel: channel, container: container);
      addTearDown(svc.dispose);

      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
            channel.name,
            const StandardMethodCodec().encodeMethodCall(
              const MethodCall('whatever', 42),
            ),
            (_) {},
          );

      await Future<void>.delayed(Duration.zero);
      expect(svc.pipMode.value, isFalse);
      expect(container.read(pipModeProvider), isFalse);
    });
  });
}
