// ignore_for_file: prefer_const_constructors
// Unit tests for DesktopAppearanceService.
//
// These tests do NOT bring up a real D-Bus session — they exercise:
//   1. The pure value decoders (`decodeColorScheme`, `decodeAccentColor`,
//      `unwrapVariant`) against the exact wire shapes the portal publishes.
//   2. The signal -> Riverpod-provider plumbing, by feeding synthetic
//      `DBusSignal` values through `handleSignalForTest`.
//
// We avoid spinning up a real `DBusServer` to keep this suite fast and
// runnable in CI without a session bus.

import 'package:dbus/dbus.dart';
import 'package:flutter/material.dart' show Brightness, Color;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sshvault/core/services/desktop_appearance_service.dart';

void main() {
  group('DesktopAppearanceService.decodeColorScheme', () {
    test('0 → null (no preference)', () {
      expect(
        DesktopAppearanceService.decodeColorSchemeForTest(DBusUint32(0)),
        isNull,
      );
    });

    test('1 → Brightness.dark (prefer dark)', () {
      expect(
        DesktopAppearanceService.decodeColorSchemeForTest(DBusUint32(1)),
        Brightness.dark,
      );
    });

    test('2 → Brightness.light (prefer light)', () {
      expect(
        DesktopAppearanceService.decodeColorSchemeForTest(DBusUint32(2)),
        Brightness.light,
      );
    });

    test('out-of-range → null', () {
      expect(
        DesktopAppearanceService.decodeColorSchemeForTest(DBusUint32(99)),
        isNull,
      );
    });

    test('non-integer → null', () {
      expect(
        DesktopAppearanceService.decodeColorSchemeForTest(DBusString('dark')),
        isNull,
      );
    });
  });

  group('DesktopAppearanceService.decodeAccentColor', () {
    test('valid (ddd) struct → opaque Color', () {
      // GNOME 47 publishes RGB doubles in [0, 1].
      final v = DBusStruct([DBusDouble(1.0), DBusDouble(0.5), DBusDouble(0.0)]);
      final c = DesktopAppearanceService.decodeAccentColorForTest(v);
      expect(c, isNotNull);
      // ignore: deprecated_member_use
      expect(c!.alpha, 255);
      // ignore: deprecated_member_use
      expect(c.red, 255);
      // ignore: deprecated_member_use
      expect(c.green, 128);
      // ignore: deprecated_member_use
      expect(c.blue, 0);
    });

    test('negative components → null (no accent set)', () {
      // The portal signals "no accent color" via negative values.
      final v = DBusStruct([
        DBusDouble(-1.0),
        DBusDouble(-1.0),
        DBusDouble(-1.0),
      ]);
      expect(DesktopAppearanceService.decodeAccentColorForTest(v), isNull);
    });

    test('4-tuple (dddd) with alpha → respects alpha', () {
      final v = DBusStruct([
        DBusDouble(0.0),
        DBusDouble(0.0),
        DBusDouble(0.0),
        DBusDouble(0.5),
      ]);
      final c = DesktopAppearanceService.decodeAccentColorForTest(v);
      expect(c, isNotNull);
      // ignore: deprecated_member_use
      expect(c!.alpha, closeTo(128, 1));
    });

    test('non-struct → null', () {
      expect(
        DesktopAppearanceService.decodeAccentColorForTest(DBusUint32(42)),
        isNull,
      );
    });
  });

  group('DesktopAppearanceService.unwrapVariant', () {
    test('plain value passes through', () {
      final v = DBusUint32(1);
      expect(DesktopAppearanceService.unwrapVariantForTest(v), v);
    });

    test('single variant unwrapped', () {
      final inner = DBusUint32(2);
      expect(
        DesktopAppearanceService.unwrapVariantForTest(DBusVariant(inner)),
        inner,
      );
    });

    test('double variant unwrapped (some portal versions wrap twice)', () {
      final inner = DBusUint32(1);
      expect(
        DesktopAppearanceService.unwrapVariantForTest(
          DBusVariant(DBusVariant(inner)),
        ),
        inner,
      );
    });
  });

  group('DesktopAppearanceService → Riverpod providers', () {
    late ProviderContainer container;
    late DesktopAppearanceService service;

    setUp(() {
      container = ProviderContainer();
      // Use the test variant which does NOT call initialize() — we don't
      // want to touch the real session bus from a unit test.
      service = container.read(desktopAppearanceServiceTestProvider);
    });

    tearDown(() async {
      // Service is disposed via the container.
      container.dispose();
      // Give the async dispose a turn to settle so we don't leak handles.
      await Future<void>.delayed(Duration.zero);
      // Reference `service` so the analyzer doesn't flag it unused after
      // teardown — we genuinely need it bound for the `setUp` builder.
      service.toString();
    });

    test('color-scheme signal updates desktopColorSchemeProvider', () {
      // Pre-condition: provider starts unset (== null).
      expect(container.read(desktopColorSchemeProvider), isNull);

      service.handleSignalForTest(
        DBusSignal(
          sender: 'org.freedesktop.portal.Desktop',
          path: DBusObjectPath('/org/freedesktop/portal/desktop'),
          interface: 'org.freedesktop.portal.Settings',
          name: 'SettingChanged',
          values: [
            DBusString('org.freedesktop.appearance'),
            DBusString('color-scheme'),
            DBusVariant(DBusUint32(1)), // prefer-dark
          ],
        ),
      );

      expect(container.read(desktopColorSchemeProvider), Brightness.dark);
    });

    test('accent-color signal updates desktopAccentColorProvider', () {
      expect(container.read(desktopAccentColorProvider), isNull);

      service.handleSignalForTest(
        DBusSignal(
          sender: 'org.freedesktop.portal.Desktop',
          path: DBusObjectPath('/org/freedesktop/portal/desktop'),
          interface: 'org.freedesktop.portal.Settings',
          name: 'SettingChanged',
          values: [
            DBusString('org.freedesktop.appearance'),
            DBusString('accent-color'),
            DBusVariant(
              DBusStruct([DBusDouble(0.2), DBusDouble(0.4), DBusDouble(0.8)]),
            ),
          ],
        ),
      );

      final accent = container.read(desktopAccentColorProvider);
      expect(accent, isNotNull);
      expect(accent, isA<Color>());
    });

    test('unrelated namespace is ignored', () {
      service.handleSignalForTest(
        DBusSignal(
          sender: 'org.freedesktop.portal.Desktop',
          path: DBusObjectPath('/org/freedesktop/portal/desktop'),
          interface: 'org.freedesktop.portal.Settings',
          name: 'SettingChanged',
          values: [
            DBusString('org.gnome.desktop.interface'),
            DBusString('color-scheme'),
            DBusVariant(DBusUint32(2)),
          ],
        ),
      );

      // Provider must NOT have been touched — only the
      // `org.freedesktop.appearance` namespace is honored.
      expect(container.read(desktopColorSchemeProvider), isNull);
    });

    test('malformed signal (too few values) is dropped', () {
      // Should not throw and should not update the provider.
      service.handleSignalForTest(
        DBusSignal(
          sender: 'org.freedesktop.portal.Desktop',
          path: DBusObjectPath('/org/freedesktop/portal/desktop'),
          interface: 'org.freedesktop.portal.Settings',
          name: 'SettingChanged',
          values: [DBusString('org.freedesktop.appearance')],
        ),
      );

      expect(container.read(desktopColorSchemeProvider), isNull);
    });
  });
}
