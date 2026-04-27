/// Unit tests for [MacosNotificationService].
///
/// We do NOT bring up the real `UNUserNotificationCenter` — that lives
/// behind the Swift plugin in `macos/Runner/UNUserNotifications.swift`
/// and isn't reachable under `flutter test`. Instead we cover:
///
///   1. The data class [MacosNotificationAction] round-trips its
///      `label` and `tag` exactly — view-models route on the tag prefix,
///      so any silent mutation here would break the action handlers.
///   2. The service short-circuits cleanly on non-macOS hosts so callers
///      can use it from cross-platform code without `Platform.isMacOS`
///      guards at every call site.
///   3. Native `onAction` invocations re-emit the opaque tag verbatim on
///      [MacosNotificationService.actionStream] — this is the contract
///      the shell relies on to dispatch to the right session.
///   4. Native `onClick` invocations emit the synthetic `show:` tag so
///      the existing handler can route body taps without a separate
///      callback.
///   5. [MacosNotificationService.dispose] closes the stream cleanly so
///      listeners receive a `done` signal.
///
/// The platform-specific code path (channel round-trip into Swift) is
/// verified by integration tests on macOS runners.
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sshvault/core/services/macos_notification_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MacosNotificationAction', () {
    test('preserves label and tag verbatim', () {
      const action = MacosNotificationAction(
        label: 'Disconnect',
        tag: 'disconnect:abc-123',
      );
      expect(action.label, 'Disconnect');
      expect(action.tag, 'disconnect:abc-123');
    });

    test('tags carrying colons round-trip without truncation', () {
      // The router relies on splitting at the first colon; tags must
      // keep any trailing colons intact so payloads like UUIDs stay
      // correct (matches the Windows side's contract).
      const action = MacosNotificationAction(
        label: 'Reconnect',
        tag: 'reconnect:host:42',
      );
      expect(action.tag, 'reconnect:host:42');
    });
  });

  group('MacosNotificationService — channel constants', () {
    test('channel name matches the Swift plugin', () {
      // Hard-pinned: the Swift side uses the same literal so a drift
      // here would silently disconnect the bridge.
      expect(
        kMacosNotificationChannel,
        'de.kiefer_networks.sshvault/macos_notif',
      );
    });

    test('default category id matches the Swift plugin', () {
      expect(kMacosSshSessionCategory, 'ssh_session');
    });
  });

  group('MacosNotificationService — non-macOS passthrough', () {
    test('show() is a no-op on Linux / Windows', () async {
      // On non-macOS hosts the service short-circuits before touching
      // the channel — the call must complete without throwing.
      if (Platform.isMacOS) {
        // Skip: macOS runner exercises the real path in integration tests.
        return;
      }
      final service = MacosNotificationService();
      await service.show(
        id: 'session-1',
        title: 'Session active',
        body: 'host.example.com',
        actions: const [
          MacosNotificationAction(label: 'Disconnect', tag: 'disconnect:s1'),
          MacosNotificationAction(label: 'Show', tag: 'show:'),
        ],
      );
      // dismiss() of an unknown id must also be a no-op.
      await service.dismiss('session-1');
      // requestAuthorization on non-macOS returns false without throwing.
      expect(await service.requestAuthorization(), isFalse);
      await service.dispose();
    });

    test('actionStream is a broadcast stream', () async {
      final service = MacosNotificationService();
      final stream = service.actionStream;
      // Two listeners may attach at the same time without throwing
      // "Bad state: Stream has already been listened to".
      final subA = stream.listen((_) {});
      final subB = stream.listen((_) {});
      await subA.cancel();
      await subB.cancel();
      await service.dispose();
    });

    test('dispose() closes the action stream cleanly', () async {
      final service = MacosNotificationService();
      final completer = Completer<void>();
      final sub = service.actionStream.listen(
        (_) {},
        onDone: completer.complete,
      );
      await service.dispose();
      await completer.future.timeout(const Duration(seconds: 1));
      await sub.cancel();
    });
  });

  group('MacosNotificationService — native callback dispatch', () {
    /// Helper: build a service wired to a fake channel we can drive with
    /// synthetic platform messages. We also stub the `bringToFront` hook
    /// because `window_manager`'s plugin registrant isn't available in
    /// flutter_test and would crash the call site otherwise.
    MacosNotificationService buildHarness({
      required MethodChannel channel,
      Future<void> Function()? bringToFront,
    }) {
      return MacosNotificationService.test(
        channel: channel,
        bringToFront: bringToFront ?? () async {},
      );
    }

    test('onAction re-emits the opaque tag verbatim', () async {
      const channel = MethodChannel('test.macos_notif.action');
      final service = buildHarness(channel: channel);
      addTearDown(service.dispose);

      final tags = <String>[];
      final sub = service.actionStream.listen(tags.add);
      addTearDown(sub.cancel);

      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
            channel.name,
            const StandardMethodCodec().encodeMethodCall(
              const MethodCall('onAction', {
                'id': 'sshvault.terminal.sessions',
                'action': 'disconnect:host-42',
              }),
            ),
            (_) {},
          );

      // Allow the controller to drain.
      await Future<void>.delayed(Duration.zero);
      expect(tags, ['disconnect:host-42']);
    });

    test('onClick emits the synthetic "show:" tag', () async {
      const channel = MethodChannel('test.macos_notif.click');
      final service = buildHarness(channel: channel);
      addTearDown(service.dispose);

      final tags = <String>[];
      final sub = service.actionStream.listen(tags.add);
      addTearDown(sub.cancel);

      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
            channel.name,
            const StandardMethodCodec().encodeMethodCall(
              const MethodCall('onClick', {'id': 'sshvault.terminal.sessions'}),
            ),
            (_) {},
          );

      await Future<void>.delayed(Duration.zero);
      expect(tags, ['show:']);
    });

    test('bringToFront is invoked on action and click', () async {
      const channel = MethodChannel('test.macos_notif.bring');
      var calls = 0;
      final service = buildHarness(
        channel: channel,
        bringToFront: () async {
          calls += 1;
        },
      );
      addTearDown(service.dispose);

      final sub = service.actionStream.listen((_) {});
      addTearDown(sub.cancel);

      Future<void> deliver(MethodCall call) => TestDefaultBinaryMessengerBinding
          .instance
          .defaultBinaryMessenger
          .handlePlatformMessage(
            channel.name,
            const StandardMethodCodec().encodeMethodCall(call),
            (_) {},
          );

      await deliver(
        const MethodCall('onAction', {'id': 'x', 'action': 'disconnect:y'}),
      );
      await deliver(const MethodCall('onClick', {'id': 'x'}));
      await Future<void>.delayed(Duration.zero);

      expect(calls, 2);
    });

    test('malformed arguments are ignored without throwing', () async {
      const channel = MethodChannel('test.macos_notif.bad');
      final service = buildHarness(channel: channel);
      addTearDown(service.dispose);

      final tags = <String>[];
      final sub = service.actionStream.listen(tags.add);
      addTearDown(sub.cancel);

      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
            channel.name,
            const StandardMethodCodec().encodeMethodCall(
              // No `action` key — must be silently dropped, not crash.
              const MethodCall('onAction', {'id': 'x'}),
            ),
            (_) {},
          );

      await Future<void>.delayed(Duration.zero);
      expect(tags, isEmpty);
    });
  });
}
