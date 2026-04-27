// Tests for the Wayland-aware clipboard helper.
//
// We do NOT spawn real `wl-copy` here — CI / sandboxes have no compositor
// and no `wl-clipboard` binary. Instead we inject fakes for `Process.start`,
// `Process.run`, and the environment reader, then assert that the service:
//
//   1. Detects Wayland correctly (Linux + WAYLAND_DISPLAY non-empty).
//   2. Spawns `wl-copy` detached with empty argv and writes the secret to
//      stdin (UTF-8 encoded).
//   3. Falls back to in-process `Clipboard.setData` on X11, non-Linux, or
//      when `wl-copy` is absent from PATH.
//   4. Schedules `wl-copy --clear` after the autoClear timer fires.
//
// The Process fake is a hand-rolled stub: we capture argv, mode, and the
// stdin payload as bytes, then expose them for assertions.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sshvault/core/services/wayland_clipboard_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WaylandClipboardService — environment detection', () {
    test('reports Wayland when on Linux and WAYLAND_DISPLAY is set', () {
      final svc = WaylandClipboardService(
        environmentReader: () => {'WAYLAND_DISPLAY': 'wayland-0'},
        isLinuxOverride: true,
      );
      expect(svc.isWaylandSession, isTrue);
    });

    test('reports non-Wayland when WAYLAND_DISPLAY is empty', () {
      final svc = WaylandClipboardService(
        environmentReader: () => {'WAYLAND_DISPLAY': ''},
        isLinuxOverride: true,
      );
      expect(svc.isWaylandSession, isFalse);
    });

    test('reports non-Wayland when WAYLAND_DISPLAY is missing', () {
      final svc = WaylandClipboardService(
        environmentReader: () => <String, String>{},
        isLinuxOverride: true,
      );
      expect(svc.isWaylandSession, isFalse);
    });

    test('reports non-Wayland when not on Linux', () {
      final svc = WaylandClipboardService(
        environmentReader: () => {'WAYLAND_DISPLAY': 'wayland-0'},
        isLinuxOverride: false,
      );
      expect(svc.isWaylandSession, isFalse);
    });
  });

  group('WaylandClipboardService — isAvailable', () {
    test('returns true when `which wl-copy` exits 0', () async {
      final svc = WaylandClipboardService(
        isLinuxOverride: true,
        processRunner: (exe, args) async {
          expect(exe, 'which');
          expect(args, ['wl-copy']);
          return ProcessResult(0, 0, '/usr/bin/wl-copy\n', '');
        },
      );
      expect(await svc.isAvailable(), isTrue);
    });

    test('returns false when `which wl-copy` exits non-zero', () async {
      final svc = WaylandClipboardService(
        isLinuxOverride: true,
        processRunner: (exe, args) async => ProcessResult(0, 1, '', ''),
      );
      expect(await svc.isAvailable(), isFalse);
    });

    test('returns false when `which` is missing entirely', () async {
      final svc = WaylandClipboardService(
        isLinuxOverride: true,
        processRunner: (exe, args) async =>
            throw const ProcessException('which', ['wl-copy'], 'no such file'),
      );
      expect(await svc.isAvailable(), isFalse);
    });

    test('returns false off Linux without probing PATH', () async {
      var probed = false;
      final svc = WaylandClipboardService(
        isLinuxOverride: false,
        processRunner: (exe, args) async {
          probed = true;
          return ProcessResult(0, 0, '', '');
        },
      );
      expect(await svc.isAvailable(), isFalse);
      expect(probed, isFalse);
    });

    test('caches the result across calls', () async {
      var calls = 0;
      final svc = WaylandClipboardService(
        isLinuxOverride: true,
        processRunner: (exe, args) async {
          calls++;
          return ProcessResult(0, 0, '/usr/bin/wl-copy\n', '');
        },
      );
      expect(await svc.isAvailable(), isTrue);
      expect(await svc.isAvailable(), isTrue);
      expect(calls, 1, reason: 'PATH probe should be cached');
    });
  });

  group('WaylandClipboardService — copyDetached on Wayland', () {
    test('spawns wl-copy detached with the secret on stdin', () async {
      final fake = _FakeProcess();
      List<String>? capturedArgs;
      ProcessStartMode? capturedMode;
      String? capturedExe;

      final svc = WaylandClipboardService(
        environmentReader: () => {'WAYLAND_DISPLAY': 'wayland-0'},
        isLinuxOverride: true,
        processRunner: (exe, args) async =>
            ProcessResult(0, 0, '/usr/bin/wl-copy\n', ''),
        processStarter: (exe, args, {mode = ProcessStartMode.normal}) async {
          capturedExe = exe;
          capturedArgs = args;
          capturedMode = mode;
          return fake;
        },
      );

      const payload = 'super-secret-private-key-pem';
      final backend = await svc.copyDetached(payload);

      expect(backend, ClipboardCopyBackend.waylandDetached);
      expect(capturedExe, 'wl-copy');
      expect(capturedArgs, isEmpty);
      expect(capturedMode, ProcessStartMode.detached);
      expect(utf8.decode(fake.stdinBuffer), payload);
      expect(fake.stdinClosed, isTrue);
    });

    test(
      'autoClear schedules `wl-copy --clear` after the timer elapses',
      () async {
        final clearArgs = <List<String>>[];
        final fake = _FakeProcess();

        final svc = WaylandClipboardService(
          environmentReader: () => {'WAYLAND_DISPLAY': 'wayland-0'},
          isLinuxOverride: true,
          processRunner: (exe, args) async {
            if (exe == 'which') {
              return ProcessResult(0, 0, '/usr/bin/wl-copy\n', '');
            }
            if (exe == 'wl-copy') {
              clearArgs.add(List<String>.from(args));
              return ProcessResult(0, 0, '', '');
            }
            return ProcessResult(0, 0, '', '');
          },
          processStarter: (exe, args, {mode = ProcessStartMode.normal}) async {
            return fake;
          },
        );

        await svc.copyDetached(
          'token',
          autoClear: const Duration(milliseconds: 30),
        );

        // Wait long enough for the timer to fire.
        await Future<void>.delayed(const Duration(milliseconds: 80));

        expect(clearArgs, hasLength(1));
        expect(clearArgs.single, ['--clear']);
      },
    );

    test('a second copy cancels the previous auto-clear', () async {
      final clearArgs = <List<String>>[];
      final fake = _FakeProcess();

      final svc = WaylandClipboardService(
        environmentReader: () => {'WAYLAND_DISPLAY': 'wayland-0'},
        isLinuxOverride: true,
        processRunner: (exe, args) async {
          if (exe == 'which') {
            return ProcessResult(0, 0, '/usr/bin/wl-copy\n', '');
          }
          if (exe == 'wl-copy') {
            clearArgs.add(List<String>.from(args));
          }
          return ProcessResult(0, 0, '', '');
        },
        processStarter: (exe, args, {mode = ProcessStartMode.normal}) async =>
            fake,
      );

      await svc.copyDetached(
        'first',
        autoClear: const Duration(milliseconds: 40),
      );
      // Second copy without autoClear — must cancel the pending first timer.
      await svc.copyDetached('second');

      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(
        clearArgs,
        isEmpty,
        reason: 'cancelled timer must not fire wl-copy --clear',
      );
    });

    test(
      'falls back to in-process Clipboard when wl-copy is unavailable',
      () async {
        var clipboardCalls = 0;
        ClipboardData? capturedData;

        final svc = WaylandClipboardService(
          environmentReader: () => {'WAYLAND_DISPLAY': 'wayland-0'},
          isLinuxOverride: true,
          processRunner: (exe, args) async => ProcessResult(0, 1, '', ''),
          processStarter: (exe, args, {mode = ProcessStartMode.normal}) async {
            fail('Process.start must not be invoked when wl-copy is missing');
          },
          clipboardSetter: (data) async {
            clipboardCalls++;
            capturedData = data;
          },
        );

        final backend = await svc.copyDetached('hello');
        expect(backend, ClipboardCopyBackend.inProcess);
        expect(clipboardCalls, 1);
        expect(capturedData?.text, 'hello');
      },
    );
  });

  group('WaylandClipboardService — copyDetached off Wayland', () {
    test('uses Flutter Clipboard.setData on X11', () async {
      var clipboardCalls = 0;
      ClipboardData? capturedData;

      final svc = WaylandClipboardService(
        // No WAYLAND_DISPLAY → not a Wayland session.
        environmentReader: () => {'DISPLAY': ':0'},
        isLinuxOverride: true,
        processStarter: (exe, args, {mode = ProcessStartMode.normal}) async {
          fail('Process.start must not be invoked off Wayland');
        },
        clipboardSetter: (data) async {
          clipboardCalls++;
          capturedData = data;
        },
      );

      final backend = await svc.copyDetached('plain');
      expect(backend, ClipboardCopyBackend.inProcess);
      expect(clipboardCalls, 1);
      expect(capturedData?.text, 'plain');
    });

    test('uses Flutter Clipboard.setData on macOS / Windows', () async {
      var clipboardCalls = 0;

      final svc = WaylandClipboardService(
        environmentReader: () => {'WAYLAND_DISPLAY': 'wayland-0'},
        // Even with WAYLAND_DISPLAY set, the !isLinux guard wins.
        isLinuxOverride: false,
        processStarter: (exe, args, {mode = ProcessStartMode.normal}) async {
          fail('Process.start must not be invoked off Linux');
        },
        clipboardSetter: (data) async => clipboardCalls++,
      );

      final backend = await svc.copyDetached('mac-or-windows');
      expect(backend, ClipboardCopyBackend.inProcess);
      expect(clipboardCalls, 1);
    });

    test(
      'autoClear empties the in-process clipboard after the timer',
      () async {
        final captured = <String?>[];

        final svc = WaylandClipboardService(
          environmentReader: () => {'DISPLAY': ':0'},
          isLinuxOverride: true,
          clipboardSetter: (data) async => captured.add(data.text),
        );

        await svc.copyDetached(
          'transient',
          autoClear: const Duration(milliseconds: 25),
        );

        await Future<void>.delayed(const Duration(milliseconds: 80));

        expect(captured, ['transient', '']);
      },
    );
  });
}

/// Hand-rolled `Process` fake. We only need to capture stdin and pretend the
/// detached helper is alive — we never await exitCode/stdout/stderr in the
/// service.
class _FakeProcess implements Process {
  final _FakeIOSink _stdin = _FakeIOSink();

  List<int> get stdinBuffer => _stdin.buffer;

  bool get stdinClosed => _stdin.closed;

  @override
  IOSink get stdin => _stdin;

  @override
  int get pid => 4242;

  @override
  Future<int> get exitCode => Completer<int>().future;

  @override
  Stream<List<int>> get stdout => const Stream<List<int>>.empty();

  @override
  Stream<List<int>> get stderr => const Stream<List<int>>.empty();

  @override
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]) => true;
}

class _FakeIOSink implements IOSink {
  final List<int> buffer = <int>[];
  bool closed = false;

  @override
  Encoding encoding = utf8;

  @override
  void add(List<int> data) {
    if (closed) {
      throw StateError('add() after close()');
    }
    buffer.addAll(data);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future<void> addStream(Stream<List<int>> stream) async {
    await for (final chunk in stream) {
      add(chunk);
    }
  }

  @override
  Future<void> close() async {
    closed = true;
  }

  @override
  Future<void> get done async {}

  @override
  Future<void> flush() async {}

  @override
  void write(Object? object) {
    add(encoding.encode(object?.toString() ?? ''));
  }

  @override
  void writeAll(Iterable<Object?> objects, [String separator = '']) {
    write(objects.map((o) => o?.toString() ?? '').join(separator));
  }

  @override
  void writeCharCode(int charCode) => add([charCode]);

  @override
  void writeln([Object? object = '']) {
    write('$object\n');
  }
}
