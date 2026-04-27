/// Unit tests for [WindowStateService].
///
/// We do NOT bring up a real Flutter engine / `window_manager` plugin
/// channel — the service is exercised through:
///   1. A `_FakeWindowController` that records calls and lets tests pre-seed
///      the geometry the "OS" reports.
///   2. An in-memory map plugged in via the [SettingsReader] / [SettingsWriter]
///      adapters so we can verify the write-side without a Drift DAO.
///
/// Coverage targets:
///   - Save → restore round-trip preserves size, position, and the
///     maximized flag exactly.
///   - The 0×0 saved state clamps up to the default 1280×800.
///   - Off-screen positions (large negative / NaN / >maxWidth) are dropped
///     so the OS centers the window instead of placing it off-screen.
library;

import 'package:flutter/widgets.dart' show Offset, Size;
import 'package:flutter_test/flutter_test.dart';
import 'package:window_manager/window_manager.dart';

import 'package:sshvault/core/services/window_state_service.dart';

class _FakeWindowController implements WindowController {
  Size size = const Size(1280, 800);
  Offset position = const Offset(0, 0);
  bool maximized = false;

  final List<String> calls = [];
  final List<WindowListener> listeners = [];

  @override
  Future<Size> getSize() async {
    calls.add('getSize');
    return size;
  }

  @override
  Future<Offset> getPosition() async {
    calls.add('getPosition');
    return position;
  }

  @override
  Future<bool> isMaximized() async {
    calls.add('isMaximized');
    return maximized;
  }

  @override
  Future<void> setSize(Size s) async {
    calls.add('setSize:${s.width.toInt()}x${s.height.toInt()}');
    size = s;
  }

  @override
  Future<void> setPosition(Offset p) async {
    calls.add('setPosition:${p.dx.toInt()},${p.dy.toInt()}');
    position = p;
  }

  @override
  Future<void> maximize() async {
    calls.add('maximize');
    maximized = true;
  }

  @override
  Future<void> unmaximize() async {
    calls.add('unmaximize');
    maximized = false;
  }

  @override
  void addListener(WindowListener listener) {
    listeners.add(listener);
  }

  @override
  void removeListener(WindowListener listener) {
    listeners.remove(listener);
  }
}

({
  WindowStateService service,
  _FakeWindowController controller,
  Map<String, String> store,
})
buildService({Map<String, String>? initial, Duration? debounce}) {
  final controller = _FakeWindowController();
  final store = <String, String>{};
  if (initial != null) store.addAll(initial);
  final service = WindowStateService.forTest(
    controller: controller,
    read: (k) async => store[k],
    write: (k, v) async {
      store[k] = v;
    },
    debounce: debounce ?? const Duration(milliseconds: 1),
  );
  return (service: service, controller: controller, store: store);
}

void main() {
  group('WindowStateService.clampForApply', () {
    test('0x0 saved size clamps up to the minimums', () {
      final s = WindowStateService.clampForApply(
        const WindowState(width: 0, height: 0, maximized: false),
      );
      expect(s.width, WindowStateDefaults.width);
      expect(s.height, WindowStateDefaults.height);
    });

    test('absurd huge size clamps down', () {
      final s = WindowStateService.clampForApply(
        const WindowState(width: 99999, height: 99999, maximized: false),
      );
      expect(s.width, lessThanOrEqualTo(WindowStateDefaults.maxWidth));
      expect(s.height, lessThanOrEqualTo(WindowStateDefaults.maxHeight));
    });

    test('off-screen position is dropped', () {
      final s = WindowStateService.clampForApply(
        const WindowState(
          width: 1280,
          height: 800,
          x: -10000,
          y: -10000,
          maximized: false,
        ),
      );
      expect(s.x, isNull);
      expect(s.y, isNull);
    });

    test('NaN position is dropped', () {
      const nan = double.nan;
      const state = WindowState(
        width: 1280,
        height: 800,
        x: nan,
        y: nan,
        maximized: false,
      );
      final s = WindowStateService.clampForApply(state);
      expect(s.x, isNull);
      expect(s.y, isNull);
    });

    test('valid position and size pass through unchanged', () {
      final s = WindowStateService.clampForApply(
        const WindowState(
          width: 1280,
          height: 800,
          x: 100,
          y: 200,
          maximized: false,
        ),
      );
      expect(s.width, 1280);
      expect(s.height, 800);
      expect(s.x, 100);
      expect(s.y, 200);
      expect(s.maximized, isFalse);
    });

    test('maximized flag is preserved', () {
      final s = WindowStateService.clampForApply(
        const WindowState(
          width: 1280,
          height: 800,
          x: 100,
          y: 200,
          maximized: true,
        ),
      );
      expect(s.maximized, isTrue);
    });
  });

  group('WindowStateService.restore', () {
    test('uses defaults when the store is empty', () async {
      final t = buildService();
      final s = await t.service.restore();
      expect(s.width, WindowStateDefaults.width);
      expect(s.height, WindowStateDefaults.height);
      expect(s.maximized, isFalse);
      expect(t.controller.calls, contains('setSize:1280x800'));
      // No saved position → setPosition must NOT be called (let the OS center).
      expect(
        t.controller.calls.any((c) => c.startsWith('setPosition:')),
        isFalse,
      );
      // Not maximized → maximize() must not be called.
      expect(t.controller.calls, isNot(contains('maximize')));
    });

    test('restores saved geometry to the controller', () async {
      final t = buildService(
        initial: {
          WindowStateKeys.width: '1280',
          WindowStateKeys.height: '800',
          WindowStateKeys.x: '100',
          WindowStateKeys.y: '200',
          WindowStateKeys.maximized: 'false',
        },
      );
      final s = await t.service.restore();
      expect(s.width, 1280);
      expect(s.height, 800);
      expect(s.x, 100);
      expect(s.y, 200);
      expect(s.maximized, isFalse);
      expect(t.controller.calls, contains('setSize:1280x800'));
      expect(t.controller.calls, contains('setPosition:100,200'));
      expect(t.controller.calls, isNot(contains('maximize')));
    });

    test('clamps 0x0 saved size up to the default', () async {
      final t = buildService(
        initial: {WindowStateKeys.width: '0', WindowStateKeys.height: '0'},
      );
      final s = await t.service.restore();
      expect(s.width, WindowStateDefaults.width);
      expect(s.height, WindowStateDefaults.height);
      expect(t.controller.calls, contains('setSize:1280x800'));
    });

    test('drops an off-screen saved position', () async {
      final t = buildService(
        initial: {
          WindowStateKeys.width: '1280',
          WindowStateKeys.height: '800',
          WindowStateKeys.x: '-9999',
          WindowStateKeys.y: '-9999',
        },
      );
      await t.service.restore();
      expect(
        t.controller.calls.any((c) => c.startsWith('setPosition:')),
        isFalse,
      );
    });

    test('applies maximize() when the saved state was maximized', () async {
      final t = buildService(
        initial: {
          WindowStateKeys.width: '1280',
          WindowStateKeys.height: '800',
          WindowStateKeys.maximized: 'true',
        },
      );
      final s = await t.service.restore();
      expect(s.maximized, isTrue);
      expect(t.controller.calls, contains('maximize'));
    });
  });

  group('WindowStateService — save side (round-trip)', () {
    test('round-trip preserves 1280x800 @ (100,200), not maximized', () async {
      final t1 = buildService();
      // Simulate the user resized + moved the window.
      t1.controller.size = const Size(1280, 800);
      t1.controller.position = const Offset(100, 200);
      t1.controller.maximized = false;
      t1.service.attachListeners();
      // Drive the listener path the way window_manager would.
      t1.service.onWindowResize();
      t1.service.onWindowMove();
      // Wait past the (test-shortened) debounce so the write lands.
      await Future<void>.delayed(const Duration(milliseconds: 10));
      // Force a final flush in case the debounce timer hasn't fired yet.
      await t1.service.debugFlush();

      // Persisted store should now have the geometry.
      expect(t1.store[WindowStateKeys.width], '1280');
      expect(t1.store[WindowStateKeys.height], '800');
      expect(t1.store[WindowStateKeys.x], '100');
      expect(t1.store[WindowStateKeys.y], '200');
      expect(t1.store[WindowStateKeys.maximized], 'false');

      // Second launch: a fresh service reading from the same store should
      // restore the exact same values.
      final t2 = buildService(initial: t1.store);
      final s = await t2.service.restore();
      expect(s.width, 1280);
      expect(s.height, 800);
      expect(s.x, 100);
      expect(s.y, 200);
      expect(s.maximized, isFalse);
      expect(t2.controller.calls, contains('setSize:1280x800'));
      expect(t2.controller.calls, contains('setPosition:100,200'));
    });

    test('maximize event flips the persisted flag to true', () async {
      final t = buildService();
      t.service.attachListeners();
      t.service.onWindowMaximize();
      await t.service.debugFlush();
      expect(t.store[WindowStateKeys.maximized], 'true');
    });

    test('unmaximize event flips the persisted flag back to false', () async {
      final t = buildService();
      t.service.attachListeners();
      t.service.onWindowMaximize();
      await t.service.debugFlush();
      t.service.onWindowUnmaximize();
      await t.service.debugFlush();
      expect(t.store[WindowStateKeys.maximized], 'false');
    });
  });

  group('WindowStateService.attachListeners', () {
    test('registers exactly one listener on the controller', () {
      final t = buildService();
      t.service.attachListeners();
      expect(t.controller.listeners.length, 1);
      // Idempotent — second call must not double-register.
      t.service.attachListeners();
      expect(t.controller.listeners.length, 1);
    });

    test('dispose unregisters the listener', () async {
      final t = buildService();
      t.service.attachListeners();
      await t.service.dispose();
      expect(t.controller.listeners, isEmpty);
    });
  });
}
