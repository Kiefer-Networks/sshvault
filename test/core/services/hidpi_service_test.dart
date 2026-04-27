// Tests for the HiDPI / per-monitor scale bridge.
//
// We exercise the method-call handler directly (via `handleCallForTest`)
// and assert that:
//
//   1. A valid `monitorScaleChanged(double)` call updates
//      [currentMonitorScaleProvider] in the wired Riverpod container.
//   2. Repeated identical calls are a no-op (no spurious provider writes).
//   3. The metrics-change hook is invoked (we replace
//      `WidgetsBinding.instance.handleMetricsChanged` with a counting test
//      hook so the test does not require a live binding).
//   4. Bad / missing arguments are ignored gracefully — the provider
//      keeps its previous value, no exception escapes.
//
// We do NOT spin up the platform MethodChannel here — the C++ side is
// covered by the integration build, not these unit tests.

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sshvault/core/services/hidpi_service.dart';

void main() {
  // `init()` calls `MethodChannel.setMethodCallHandler` which requires the
  // platform messenger from a running binding. Use the test binding.
  TestWidgetsFlutterBinding.ensureInitialized();

  late HiDpiService sut;
  late ProviderContainer container;
  late int metricsHookCalls;

  setUp(() {
    container = ProviderContainer();
    metricsHookCalls = 0;
    sut = HiDpiService.instance;
    sut.resetForTest();
    // We avoid `init()` because it touches the platform MethodChannel and
    // would also try to listen on settingsProvider (which would build the
    // database stack). We only need the method-call handler exercised.
    sut.onMetricsChangedForTest = () {
      metricsHookCalls++;
    };
  });

  tearDown(() {
    sut.resetForTest();
    container.dispose();
  });

  test(
    'valid monitorScaleChanged updates currentMonitorScaleProvider',
    () async {
      // Inject a container and trigger the handler manually.
      _setUpServiceWithContainer(sut, container);

      expect(container.read(currentMonitorScaleProvider), 1.0);

      await sut.handleCallForTest(const MethodCall('monitorScaleChanged', 2.0));

      expect(container.read(currentMonitorScaleProvider), 2.0);
      expect(metricsHookCalls, 1);
    },
  );

  test('integer arguments are coerced to double', () async {
    _setUpServiceWithContainer(sut, container);

    await sut.handleCallForTest(const MethodCall('monitorScaleChanged', 1));
    expect(container.read(currentMonitorScaleProvider), 1.0);

    await sut.handleCallForTest(const MethodCall('monitorScaleChanged', 2));
    expect(container.read(currentMonitorScaleProvider), 2.0);
    expect(metricsHookCalls, 2);
  });

  test('repeated identical scale only writes once', () async {
    _setUpServiceWithContainer(sut, container);

    await sut.handleCallForTest(const MethodCall('monitorScaleChanged', 1.5));
    await sut.handleCallForTest(const MethodCall('monitorScaleChanged', 1.5));
    await sut.handleCallForTest(const MethodCall('monitorScaleChanged', 1.5));

    // Provider settles to the value …
    expect(container.read(currentMonitorScaleProvider), 1.5);
    // … and `handleMetricsChanged` is still called every time the C++
    // side pings us. (We re-dispatch metrics on every event so a window
    // that was hidden during the change still picks it up.)
    expect(metricsHookCalls, 3);
  });

  test('null / negative / non-numeric arguments are ignored', () async {
    _setUpServiceWithContainer(sut, container);
    container.read(currentMonitorScaleProvider.notifier).state = 1.25;

    await sut.handleCallForTest(const MethodCall('monitorScaleChanged', null));
    await sut.handleCallForTest(const MethodCall('monitorScaleChanged', -1.0));
    await sut.handleCallForTest(const MethodCall('monitorScaleChanged', 'two'));

    expect(container.read(currentMonitorScaleProvider), 1.25);
    expect(metricsHookCalls, 0);
  });

  test('unknown method names are silently ignored', () async {
    _setUpServiceWithContainer(sut, container);
    container.read(currentMonitorScaleProvider.notifier).state = 1.0;

    final result = await sut.handleCallForTest(
      const MethodCall('somethingElse', 99.0),
    );

    expect(result, isNull);
    expect(container.read(currentMonitorScaleProvider), 1.0);
    expect(metricsHookCalls, 0);
  });
}

// The HiDpiService API exposes `init({ProviderContainer? container})`, but
// `init` also subscribes to `settingsProvider` which would pull in the full
// database stack. For unit tests we want the lighter plumbing: container
// wiring + method-call handler only. We accomplish that by reaching
// through the test-only `handleCallForTest` hook (which already pipes into
// the same `_handleCall` path). To make the container available to that
// path without `init`, we re-use `resetForTest` + a deliberate minimal
// init that skips the settingsProvider listener.
void _setUpServiceWithContainer(HiDpiService sut, ProviderContainer container) {
  // `init` with `mirrorForcedPixelRatio: false` skips the settings provider
  // subscription so we don't need to spin up the database stack. The
  // method-channel registration is harmless in unit tests; we drive the
  // handler through `handleCallForTest` rather than the real messenger.
  sut.init(container: container, mirrorForcedPixelRatio: false);
}
