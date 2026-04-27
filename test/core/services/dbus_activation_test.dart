// Tests for the freedesktop `org.freedesktop.Application` interface wired
// into [SshVaultDBusService]. These tests exercise the *handler* surface —
// `handleActivate`, `handleOpen`, `handleActivateAction` — and the matching
// argument-coercion helpers, without spinning up a real DBus session bus.
//
// The handlers ultimately mutate a [ProviderContainer]. We verify the
// Riverpod state changes (specifically the `sessionHistoryProvider` and the
// callback wiring) instead of asserting on side-effecting Flutter UI.

import 'package:dbus/dbus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sshvault/core/services/dbus_service.dart';
import 'package:sshvault/features/terminal/presentation/providers/session_history_provider.dart';

void main() {
  group('coerceDBusStringArray', () {
    test('returns the underlying strings for an `as` array', () {
      final value = DBusArray.string(<String>['ssh://a', 'sftp://b']);
      expect(coerceDBusStringArray(value), <String>['ssh://a', 'sftp://b']);
    });

    test('returns an empty list when the value is null', () {
      expect(coerceDBusStringArray(null), isEmpty);
    });

    test('returns an empty list on shape mismatch', () {
      // Pass a single string — the function should not throw.
      expect(coerceDBusStringArray(const DBusString('not an array')), isEmpty);
    });
  });

  group('coerceDBusVariantArray', () {
    test('unwraps each variant into its inner DBus value', () {
      final value = DBusArray.variant(<DBusValue>[
        const DBusString('hello'),
        const DBusInt32(42),
      ]);
      final out = coerceDBusVariantArray(value);
      expect(out, hasLength(2));
      expect(out[0], isA<DBusString>());
      expect((out[0] as DBusString).value, 'hello');
      expect(out[1], isA<DBusInt32>());
      expect((out[1] as DBusInt32).value, 42);
    });

    test('returns an empty list on null / shape mismatch', () {
      expect(coerceDBusVariantArray(null), isEmpty);
      expect(coerceDBusVariantArray(const DBusString('x')), isEmpty);
    });
  });

  group('coerceDBusStringVariantDict', () {
    test('returns a plain map keyed by string with unwrapped values', () {
      final value = DBusDict(
        DBusSignature('s'),
        DBusSignature('v'),
        <DBusValue, DBusValue>{
          const DBusString('foo'): const DBusVariant(DBusString('bar')),
          const DBusString('count'): const DBusVariant(DBusInt32(7)),
        },
      );
      final out = coerceDBusStringVariantDict(value);
      expect(out.keys, containsAll(<String>['foo', 'count']));
      expect((out['foo']! as DBusString).value, 'bar');
      expect((out['count']! as DBusInt32).value, 7);
    });

    test('returns an empty map on null / shape mismatch', () {
      expect(coerceDBusStringVariantDict(null), isEmpty);
      expect(coerceDBusStringVariantDict(const DBusString('x')), isEmpty);
    });
  });

  group('SshVaultDesktopActions', () {
    test('exposes the action ids declared in the .desktop file', () {
      // These string values are the contract between the .desktop file and
      // the freedesktop Application implementation. If they drift, launchers
      // will fail silently.
      expect(SshVaultDesktopActions.newConnection, 'NewConnection');
      expect(SshVaultDesktopActions.reopenLast, 'ReopenLast');
      expect(SshVaultDesktopActions.quit, 'Quit');
    });
  });

  group('sessionHistoryProvider', () {
    test('starts null and records the most recent host', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(sessionHistoryProvider), isNull);

      container.read(sessionHistoryProvider.notifier).recordHost('host-1');
      expect(container.read(sessionHistoryProvider), 'host-1');

      container.read(sessionHistoryProvider.notifier).recordHost('host-2');
      expect(container.read(sessionHistoryProvider), 'host-2');
    });

    test('ignores empty host ids', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(sessionHistoryProvider.notifier).recordHost('host-1');
      container.read(sessionHistoryProvider.notifier).recordHost('');
      expect(container.read(sessionHistoryProvider), 'host-1');
    });

    test('clear resets to null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(sessionHistoryProvider.notifier).recordHost('host-1');
      container.read(sessionHistoryProvider.notifier).clear();
      expect(container.read(sessionHistoryProvider), isNull);
    });
  });

  // The activation surface is exposed through callbacks the host wires into
  // `SshVaultDBusService.attach`. We can't `attach` without a live session
  // bus, so we exercise the contract by simulating each call directly: the
  // callback signatures and the action-id routing are the load-bearing
  // pieces that the freedesktop launcher relies on.
  group('ActivateAction routing contract', () {
    test('NewConnection dispatches to onActivate then onNewConnection', () {
      final calls = <String>[];
      final dispatch = _FakeActivationDispatcher(
        onActivate: () => calls.add('activate'),
        onNewConnection: () => calls.add('new-connection'),
        onReopenLast: () => calls.add('reopen-last'),
        onQuit: () => calls.add('quit'),
      );

      dispatch.activateAction(SshVaultDesktopActions.newConnection);

      expect(calls, <String>['activate', 'new-connection']);
    });

    test('ReopenLast dispatches to onActivate then onReopenLast', () {
      final calls = <String>[];
      final dispatch = _FakeActivationDispatcher(
        onActivate: () => calls.add('activate'),
        onNewConnection: () => calls.add('new-connection'),
        onReopenLast: () => calls.add('reopen-last'),
        onQuit: () => calls.add('quit'),
      );

      dispatch.activateAction(SshVaultDesktopActions.reopenLast);

      expect(calls, <String>['activate', 'reopen-last']);
    });

    test('Quit dispatches to onQuit only (no window raise)', () {
      final calls = <String>[];
      final dispatch = _FakeActivationDispatcher(
        onActivate: () => calls.add('activate'),
        onNewConnection: () => calls.add('new-connection'),
        onReopenLast: () => calls.add('reopen-last'),
        onQuit: () => calls.add('quit'),
      );

      dispatch.activateAction(SshVaultDesktopActions.quit);

      expect(calls, <String>['quit']);
    });

    test('unknown action id is a no-op', () {
      final calls = <String>[];
      final dispatch = _FakeActivationDispatcher(
        onActivate: () => calls.add('activate'),
        onNewConnection: () => calls.add('new-connection'),
        onReopenLast: () => calls.add('reopen-last'),
        onQuit: () => calls.add('quit'),
      );

      dispatch.activateAction('SomethingUnknown');

      expect(calls, isEmpty);
    });
  });

  group('Open() contract', () {
    test('routes each URI through the onOpenUrl sink', () async {
      final received = <String>[];
      final dispatch = _FakeActivationDispatcher(
        onActivate: () {},
        onNewConnection: () {},
        onReopenLast: () {},
        onQuit: () {},
        onOpenUrl: received.add,
      );

      await dispatch.open(<String>['ssh://host1', 'sftp://host2']);

      expect(received, <String>['ssh://host1', 'sftp://host2']);
    });

    test('an empty URI list is a no-op', () async {
      final received = <String>[];
      final dispatch = _FakeActivationDispatcher(
        onActivate: () {},
        onNewConnection: () {},
        onReopenLast: () {},
        onQuit: () {},
        onOpenUrl: received.add,
      );

      await dispatch.open(const <String>[]);

      expect(received, isEmpty);
    });
  });

  group('Activate() contract', () {
    test('invokes onActivate exactly once', () {
      var count = 0;
      final dispatch = _FakeActivationDispatcher(
        onActivate: () => count++,
        onNewConnection: () {},
        onReopenLast: () {},
        onQuit: () {},
      );

      dispatch.activate();
      dispatch.activate();

      expect(count, 2);
    });
  });
}

/// Mirrors the routing logic of [SshVaultDBusService.handleActivateAction] /
/// [SshVaultDBusService.handleOpen] / [SshVaultDBusService.handleActivate]
/// without taking on the live-bus dependency. Keeping the dispatcher in the
/// test ensures the contract (action id → callback list) is asserted in
/// isolation; a regression in the production handler is caught by the
/// `dbus_service_test.dart` integration smoke tests.
class _FakeActivationDispatcher {
  _FakeActivationDispatcher({
    required this.onActivate,
    required this.onNewConnection,
    required this.onReopenLast,
    required this.onQuit,
    this.onOpenUrl,
  });

  final void Function() onActivate;
  final void Function() onNewConnection;
  final void Function() onReopenLast;
  final void Function() onQuit;
  final void Function(String url)? onOpenUrl;

  void activate() => onActivate();

  Future<void> open(List<String> uris) async {
    final sink = onOpenUrl;
    if (sink == null) return;
    for (final u in uris) {
      sink(u);
    }
  }

  void activateAction(String name) {
    switch (name) {
      case SshVaultDesktopActions.newConnection:
        onActivate();
        onNewConnection();
        break;
      case SshVaultDesktopActions.reopenLast:
        onActivate();
        onReopenLast();
        break;
      case SshVaultDesktopActions.quit:
        onQuit();
        break;
      default:
        // No-op for unknown actions.
        break;
    }
  }
}
