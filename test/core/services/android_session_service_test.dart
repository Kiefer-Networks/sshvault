/// Unit tests for [AndroidSessionService].
///
/// We do NOT bring up the real foreground service — that lives behind the
/// Kotlin plugin in `android/app/src/main/kotlin/.../SessionForegroundService.kt`
/// and is unreachable under `flutter test`. Instead we cover:
///
///   1. The channel name matches the literal hard-coded on the Kotlin side
///      so a drift on either side fails fast in CI.
///   2. The listener invokes `start(count, names)` exactly once on the
///      0 -> >=1 transition and `stop()` once on the >=1 -> 0 transition.
///   3. A re-emission with the same count + same names produces no
///      additional native call (avoids notification flicker).
///   4. A change in the names while the count stays >=1 refreshes the
///      notification with another `start(...)` call.
///   5. An inbound `disconnectAll()` from the native side calls
///      `closeAllSessions` on the wired `sessionManagerProvider`.
library;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xterm/xterm.dart';

import 'package:sshvault/core/services/android_session_service.dart';
import 'package:sshvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

/// Test double for [SessionManagerNotifier]. Exposes a public `set` so the
/// test can drive state transitions without standing up the SSH stack, and
/// records every `closeAllSessions()` call so we can assert the inbound
/// `disconnectAll` round-trip.
class _FakeSessionManager extends Notifier<List<SshSessionEntity>>
    implements SessionManagerNotifier {
  int closeAllCalls = 0;

  @override
  List<SshSessionEntity> build() => const [];

  void set(List<SshSessionEntity> value) => state = value;

  @override
  void closeAllSessions() {
    closeAllCalls += 1;
    state = const [];
  }

  // Unused in tests but required by the interface contract. We mark them
  // unsupported so an accidental call fails loudly instead of silently.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

SshSessionEntity _session(String id, String title) {
  return SshSessionEntity(
    id: id,
    serverId: 'srv-$id',
    title: title,
    terminal: Terminal(maxLines: 10),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('channel constant', () {
    test('matches the literal used by MainActivity.kt', () {
      // Drift here would silently disconnect Dart from the foreground
      // service. The Kotlin side reads exactly this string in
      // `MainActivity.configureFlutterEngine`.
      expect(
        kAndroidSessionServiceChannel,
        'de.kiefer_networks.sshvault/session_service',
      );
    });
  });

  group('AndroidSessionService — outbound channel calls', () {
    late _FakeSessionManager fake;
    late ProviderContainer container;
    late MethodChannel channel;
    late List<MethodCall> outbound;

    setUp(() {
      fake = _FakeSessionManager();
      container = ProviderContainer(
        overrides: [sessionManagerProvider.overrideWith(() => fake)],
      );
      addTearDown(container.dispose);

      // Force a unique channel per test so handlers don't bleed between
      // cases. We register a mock handler that records every outbound call.
      channel = MethodChannel(
        'test.android_session_service.${identityHashCode(container)}',
      );
      outbound = [];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            outbound.add(call);
            return null;
          });
      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null);
      });
    });

    AndroidSessionService buildService() => AndroidSessionService.test(
      container: container,
      channel: channel,
      forceEnabled: true,
    );

    test('0 -> 1 fires start with the host title', () async {
      final svc = buildService()..attach();
      addTearDown(svc.dispose);

      fake.set([_session('a', 'prod-1')]);
      await Future<void>.delayed(Duration.zero);

      expect(outbound, hasLength(1));
      expect(outbound.single.method, 'start');
      expect(outbound.single.arguments, {
        'count': 1,
        'names': ['prod-1'],
      });
    });

    test('1 -> 0 fires stop exactly once', () async {
      final svc = buildService()..attach();
      addTearDown(svc.dispose);

      fake.set([_session('a', 'prod-1')]);
      await Future<void>.delayed(Duration.zero);
      outbound.clear();

      fake.set(const []);
      await Future<void>.delayed(Duration.zero);

      expect(outbound, hasLength(1));
      expect(outbound.single.method, 'stop');
    });

    test('emitting the same list twice does not re-call start', () async {
      final svc = buildService()..attach();
      addTearDown(svc.dispose);

      final entity = _session('a', 'prod-1');
      fake.set([entity]);
      await Future<void>.delayed(Duration.zero);
      outbound.clear();

      // Re-set with an identically-shaped list — the names key + count are
      // unchanged so we should not refresh the notification.
      fake.set([_session('a', 'prod-1')]);
      await Future<void>.delayed(Duration.zero);

      expect(outbound, isEmpty);
    });

    test('host name change while count >=1 refreshes start', () async {
      final svc = buildService()..attach();
      addTearDown(svc.dispose);

      fake.set([_session('a', 'prod-1')]);
      await Future<void>.delayed(Duration.zero);
      outbound.clear();

      fake.set([_session('a', 'prod-2')]);
      await Future<void>.delayed(Duration.zero);

      expect(outbound, hasLength(1));
      expect(outbound.single.method, 'start');
      expect((outbound.single.arguments as Map)['names'], ['prod-2']);
    });

    test('count delta with the same head host still refreshes', () async {
      final svc = buildService()..attach();
      addTearDown(svc.dispose);

      fake.set([_session('a', 'prod-1')]);
      await Future<void>.delayed(Duration.zero);
      outbound.clear();

      fake.set([_session('a', 'prod-1'), _session('b', 'staging')]);
      await Future<void>.delayed(Duration.zero);

      expect(outbound, hasLength(1));
      expect((outbound.single.arguments as Map)['count'], 2);
      expect((outbound.single.arguments as Map)['names'], [
        'prod-1',
        'staging',
      ]);
    });
  });

  group('AndroidSessionService — inbound disconnectAll', () {
    test('routes to SessionManagerNotifier.closeAllSessions', () async {
      final fake = _FakeSessionManager();
      final container = ProviderContainer(
        overrides: [sessionManagerProvider.overrideWith(() => fake)],
      );
      addTearDown(container.dispose);

      const channel = MethodChannel('test.android_session_service.inbound');
      final svc = AndroidSessionService.test(
        container: container,
        channel: channel,
        forceEnabled: true,
      );
      addTearDown(svc.dispose);

      // Materialize the notifier so the override is realised before the
      // inbound call lands.
      container.read(sessionManagerProvider);

      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
            channel.name,
            const StandardMethodCodec().encodeMethodCall(
              const MethodCall('disconnectAll'),
            ),
            (_) {},
          );

      // Allow the handler to finish.
      await Future<void>.delayed(Duration.zero);
      expect(fake.closeAllCalls, 1);
    });

    test('unknown method does not throw', () async {
      final fake = _FakeSessionManager();
      final container = ProviderContainer(
        overrides: [sessionManagerProvider.overrideWith(() => fake)],
      );
      addTearDown(container.dispose);

      const channel = MethodChannel('test.android_session_service.unknown');
      final svc = AndroidSessionService.test(
        container: container,
        channel: channel,
        forceEnabled: true,
      );
      addTearDown(svc.dispose);

      container.read(sessionManagerProvider);

      // Must not throw.
      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
            channel.name,
            const StandardMethodCodec().encodeMethodCall(
              const MethodCall('whatever'),
            ),
            (_) {},
          );

      await Future<void>.delayed(Duration.zero);
      expect(fake.closeAllCalls, 0);
    });
  });
}
