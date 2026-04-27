// Unit tests for `dynamicColorProvider`.
//
// The provider gates on [Platform.isAndroid] so the real
// `DynamicColorPlugin.getCorePalette()` MethodChannel call is never
// invoked on the Linux test runner. We exercise:
//
//   1. The non-Android short-circuit (default runner state) — must
//      resolve to `AsyncData(null)` without touching any channel.
//   2. The `debugIsAndroidOverride` test seam — flipping it to `true`
//      lets the provider call into the plugin, which we intercept via
//      `setMockMethodCallHandler` on the `dynamic_color` plugin's
//      channel and verify a synthetic palette is decoded into a
//      non-null [CorePalette].
//   3. The defensive `try/catch` around the platform call — when the
//      channel throws, the provider must surface `AsyncData(null)`
//      rather than `AsyncError`, so the theme keeps booting.
//
// We do NOT spin up a real Android binding — the channel mock is
// enough to exercise the wiring.

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sshvault/core/theme/dynamic_color_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Channel name used by the `dynamic_color` plugin's Dart side. Kept as
  // a top-level constant so a future bump of the plugin only needs a
  // single edit if upstream renames it.
  const channel = MethodChannel('io.material.plugins/dynamic_color');

  tearDown(() {
    // Always restore the override so a failing assertion in one test
    // doesn't leak Android-mode into the next.
    debugIsAndroidOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('dynamicColorProvider (non-Android)', () {
    test('returns AsyncData(null) on the Linux test runner', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // No override → falls through to `Platform.isAndroid`, which is
      // `false` on the CI test runner.
      final result = await container.read(dynamicColorProvider.future);
      expect(result, isNull);
    });

    test('explicit override to non-Android also returns null', () async {
      debugIsAndroidOverride = false;

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = await container.read(dynamicColorProvider.future);
      expect(result, isNull);
    });
  });

  group('dynamicColorProvider (Android override)', () {
    test('mocked channel payload yields a non-null CorePalette', () async {
      debugIsAndroidOverride = true;

      // Build a synthetic [CorePalette] payload in the wire shape the
      // plugin expects: a list of five ARGB-encoded source colors
      // (primary, secondary, tertiary, neutral, neutralVariant). We
      // re-use [CorePalette.of] to derive a palette from a fixed seed,
      // then extract the first tone of each tonal palette as the source
      // ARGB. The exact decoding lives inside `CorePalette.fromList`,
      // which is what the plugin invokes under the hood.
      const seed = 0xFF1A1A2E;
      final reference = CorePalette.of(seed);

      var callCount = 0;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            callCount++;
            expect(call.method, 'getCorePalette');
            // Return the raw int list the plugin's Dart side expects —
            // it deserializes with `CorePalette.fromList(list)`.
            return reference.asList();
          });

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = await container.read(dynamicColorProvider.future);
      expect(callCount, 1, reason: 'getCorePalette must be invoked once');
      expect(result, isNotNull);
      expect(result, isA<CorePalette>());
      // The decoded palette's primary key tone should round-trip.
      expect(result!.primary.get(40), reference.primary.get(40));
    });

    test(
      'channel error is swallowed and reported as AsyncData(null)',
      () async {
        debugIsAndroidOverride = true;

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (call) async {
              throw PlatformException(
                code: 'NO_PALETTE',
                message: 'OEM build does not implement dynamic color',
              );
            });

        final container = ProviderContainer();
        addTearDown(container.dispose);

        final result = await container.read(dynamicColorProvider.future);
        // The provider's defensive try/catch must turn the exception into
        // a successful `null` so the theme keeps using the brand seed.
        expect(result, isNull);
      },
    );
  });
}
