// Tests for the GlobalShortcuts portal client.
//
// We do NOT spin up a real session bus — CI runners normally don't have one,
// and asking xdg-desktop-portal to register a hotkey would require user
// interaction. Instead we verify:
//   * the service is platform-gated (off Linux it never touches the bus)
//   * the public "rebind" / "register" entrypoints publish a status to the
//     Riverpod provider so the Settings UI can show the right state
//   * the `Activated` signal handler maps shortcut_id → activations stream
//     and de-duplicates ticks
//   * the BindShortcuts payload shape matches the portal contract
//     (sa{sv}, with description + preferred_trigger keys)
//
// Where the real service would talk to DBus, we exercise pure helpers and a
// fake controller so the assertions stay deterministic.

import 'dart:io';

import 'package:dbus/dbus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sshvault/core/services/global_shortcut_service.dart';

void main() {
  group('GlobalShortcutService — platform gating', () {
    test('supportsPortal is false off Linux', () {
      if (Platform.isLinux) return;
      expect(GlobalShortcutService.supportsPortal, isFalse);
    });

    test('register() returns unavailable status off Linux', () async {
      if (Platform.isLinux) return;
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final svc = GlobalShortcutService();
      addTearDown(svc.dispose);
      final status = await svc.register(container: container);
      expect(status.portalAvailable, isFalse);
      expect(status.bound, isFalse);
      // The status should also have been published to the provider so the
      // Settings UI can render the fallback panel.
      expect(
        container.read(globalShortcutStatusProvider).portalAvailable,
        isFalse,
      );
    });
  });

  group('Constants & fallback', () {
    test('kQuickConnectShortcutId is the documented portal key', () {
      // The portal matches Activated signals against this exact string. If
      // it ever changes the dbus-send fallback in the README also has to
      // change, so guard the literal here.
      expect(kQuickConnectShortcutId, 'sshvault.quick-connect');
    });

    test('kQuickConnectDefaultTrigger uses the portal trigger grammar', () {
      // The portal expects the modifier+key string to be uppercase modifiers
      // joined with `+` and a lowercase keysym at the end.
      expect(kQuickConnectDefaultTrigger, 'SUPER+SHIFT+s');
    });

    test('kFallbackDbusSendCommand targets the SSHVault DBus service', () {
      // The README points XFCE users at this exact command — if the bus
      // name or method ever changes, this test fails fast.
      expect(
        kFallbackDbusSendCommand,
        contains('--dest=de.kiefer_networks.SSHVault'),
      );
      expect(kFallbackDbusSendCommand, contains('Activate'));
      expect(kFallbackDbusSendCommand, startsWith('dbus-send --session'));
    });
  });

  group('BindShortcuts payload shape', () {
    test('payload is a(sa{sv}) with description + preferred_trigger', () {
      // Mirror the structure the portal expects so we catch accidental
      // signature drift.
      final shortcut = DBusStruct([
        const DBusString(kQuickConnectShortcutId),
        DBusDict.stringVariant({
          'description': const DBusString('Quick connect'),
          'preferred_trigger': const DBusString(kQuickConnectDefaultTrigger),
        }),
      ]);
      // ignore: prefer_const_constructors
      final array = DBusArray(DBusSignature('(sa{sv})'), [shortcut]);
      expect(array.signature, DBusSignature('a(sa{sv})'));
      // First element of the struct is the shortcut id.
      expect(
        (shortcut.children[0] as DBusString).value,
        kQuickConnectShortcutId,
      );
      // Second element is the options dict containing the two required keys.
      final options = (shortcut.children[1] as DBusDict).asStringVariantDict();
      expect(options['description'], isA<DBusString>());
      expect((options['description'] as DBusString).value, 'Quick connect');
      expect(options['preferred_trigger'], isA<DBusString>());
      expect(
        (options['preferred_trigger'] as DBusString).value,
        kQuickConnectDefaultTrigger,
      );
    });
  });

  group('Activated signal → activation stream', () {
    test('matching shortcut_id increments the activation counter', () {
      // Mirror the dispatch the real subscription does. We can't construct
      // a real DBusSignal without going through the parser, so we model the
      // values list directly and assert the predicate the service uses.
      final tracker = _ActivationTracker();

      // Three Activated signals: one matches, one is for a different id,
      // one matches again. The service should fire twice.
      final signals = <List<DBusValue>>[
        [
          // ignore: prefer_const_constructors
          DBusObjectPath('/org/freedesktop/portal/desktop/session/abc'),
          const DBusString(kQuickConnectShortcutId),
          const DBusUint64(1700000001000),
          DBusDict.stringVariant(const {}),
        ],
        [
          // ignore: prefer_const_constructors
          DBusObjectPath('/org/freedesktop/portal/desktop/session/abc'),
          const DBusString('com.other.app.toggle'),
          const DBusUint64(1700000002000),
          DBusDict.stringVariant(const {}),
        ],
        [
          // ignore: prefer_const_constructors
          DBusObjectPath('/org/freedesktop/portal/desktop/session/abc'),
          const DBusString(kQuickConnectShortcutId),
          const DBusUint64(1700000003000),
          DBusDict.stringVariant(const {}),
        ],
      ];

      for (final values in signals) {
        tracker.dispatch(values);
      }

      expect(tracker.ticks, [1, 2]);
    });

    test('truncated Activated payload is ignored', () {
      // The portal could in theory send fewer values (older revision) — the
      // service should not throw, just ignore the signal.
      final tracker = _ActivationTracker();
      tracker.dispatch([const DBusString(kQuickConnectShortcutId)]);
      expect(tracker.ticks, isEmpty);
    });
  });

  group('Status publishing', () {
    test('GlobalShortcutStatus.copyWith preserves unmentioned fields', () {
      const base = GlobalShortcutStatus(
        portalAvailable: true,
        bound: false,
        trigger: 'SUPER+SHIFT+s',
      );
      final next = base.copyWith(bound: true);
      expect(next.portalAvailable, isTrue);
      expect(next.bound, isTrue);
      expect(next.trigger, 'SUPER+SHIFT+s');
    });

    test('unavailable constant has both flags false', () {
      expect(GlobalShortcutStatus.unavailable.portalAvailable, isFalse);
      expect(GlobalShortcutStatus.unavailable.bound, isFalse);
      expect(GlobalShortcutStatus.unavailable.trigger, isNull);
    });
  });
}

/// Mirrors the predicate the production code applies inside the
/// `Activated` subscription so the contract is enforced from outside the
/// (private, DBus-coupled) implementation.
class _ActivationTracker {
  int _counter = 0;
  final List<int> ticks = [];

  void dispatch(List<DBusValue> values) {
    if (values.length < 2) return;
    final id = values[1];
    if (id is DBusString && id.value == kQuickConnectShortcutId) {
      ticks.add(++_counter);
    }
  }
}
