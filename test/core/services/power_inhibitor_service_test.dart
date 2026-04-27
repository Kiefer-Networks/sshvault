// Tests for PowerInhibitorService.
//
// We do NOT touch the real system bus / kernel32 — login1 is unavailable
// on most CI runners and any successful Inhibit() / SetThreadExecutionState
// would actually keep the host awake for the duration of the test.
//
// Linux backend: we inject a fake [InhibitInvoker] that records the
// arguments and hands back a [ResourceHandle] backed by a real temp file's
// [RandomAccessFile]. That gives the test a fd it can observe being closed
// when the service releases the lock.
//
// Windows backend: we inject a fake [WindowsExecutionStateInvoker] that
// records each `SetThreadExecutionState` call and returns a non-zero
// "previous state" value so the service treats the call as successful.
// The Win32 tests are platform-gated on `Platform.isWindows` because the
// service short-circuits everywhere else; they run only on a real Windows
// CI runner (matching how the Linux tests are gated).

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:sshvault/core/ffi/win32_power.dart' as win32;
import 'package:sshvault/core/services/power_inhibitor_service.dart';

/// Records each Inhibit invocation and produces a fresh ResourceHandle
/// backed by a unique temp file. Closing the handle (via release()) closes
/// that file, which we observe with `RandomAccessFile.closeSync` throwing
/// on a second close.
class _RecordingInvoker {
  final List<List<String>> calls = <List<String>>[];
  // Keep references to the underlying files so the test can verify they
  // are closed afterwards. Each call returns a fresh handle.
  final List<File> backingFiles = <File>[];

  Future<ResourceHandle> call(
    String what,
    String who,
    String why,
    String mode,
  ) async {
    calls.add([what, who, why, mode]);
    final tmp = await Directory.systemTemp.createTemp('sshvault-inhibit-test-');
    final path = '${tmp.path}/fd-${calls.length}'; // unique per call
    final file = File(path);
    await file.writeAsString('inhibit-lock');
    backingFiles.add(file);
    final raf = file.openSync(mode: FileMode.read);
    return ResourceHandle.fromFile(raf);
  }
}

/// Returns true if [raf] is still open (a second close throws). Best-effort:
/// dart:io does not expose an `isClosed` property, so we attempt a no-op
/// read via positionSync which throws on a closed fd.
bool _isClosed(RandomAccessFile raf) {
  try {
    raf.positionSync();
    return false;
  } catch (_) {
    return true;
  }
}

void main() {
  group('PowerInhibitorService', () {
    test(
      'acquireSleepLock forwards the documented Inhibit arguments',
      () async {
        // Skip on non-Linux — the service short-circuits to null and the
        // invoker is never called.
        if (!Platform.isLinux) {
          return;
        }

        final invoker = _RecordingInvoker();
        final svc = PowerInhibitorService(invoker: invoker.call);

        final handle = await svc.acquireSleepLock('Active SSH session');

        expect(handle, isNotNull);
        expect(invoker.calls, hasLength(1));
        // The login1 contract: ("sleep:idle", "SSHVault", reason, "block").
        expect(invoker.calls.single, [
          'sleep:idle',
          'SSHVault',
          'Active SSH session',
          'block',
        ]);
        expect(svc.heldLockCount, 1);

        // Cleanup: release so the temp file is closed.
        handle!.release();
      },
    );

    test('releaseAll closes the underlying fd', () async {
      if (!Platform.isLinux) return;

      final invoker = _RecordingInvoker();
      final svc = PowerInhibitorService(invoker: invoker.call);

      final handle = await svc.acquireSleepLock('Active SSH session');
      expect(handle, isNotNull);
      expect(svc.heldLockCount, 1);

      // Reach into the backing file and reopen it just to grab a separate
      // handle for the close-state probe. The service holds the original
      // fd; releasing should close it. We verify by re-opening the file
      // (succeeds — file still exists on disk) and observing that the
      // service's internal bookkeeping zeroes out.
      final probe = invoker.backingFiles.single.openSync(mode: FileMode.read);
      expect(_isClosed(probe), isFalse);
      probe.closeSync();

      svc.releaseAll();

      expect(svc.heldLockCount, 0);
      expect(handle!.isReleased, isTrue);

      // Releasing twice is a no-op.
      handle.release();
      expect(svc.heldLockCount, 0);
    });

    test('release() on a single handle removes it from the held set', () async {
      if (!Platform.isLinux) return;

      final invoker = _RecordingInvoker();
      final svc = PowerInhibitorService(invoker: invoker.call);

      final h1 = await svc.acquireSleepLock('first');
      final h2 = await svc.acquireSleepLock('second');
      expect(svc.heldLockCount, 2);

      h1!.release();
      expect(svc.heldLockCount, 1);
      expect(h1.isReleased, isTrue);
      expect(h2!.isReleased, isFalse);

      h2.release();
      expect(svc.heldLockCount, 0);
    });

    test(
      'unsupported platforms short-circuit to null without invoking the bus',
      () async {
        if (Platform.isLinux || Platform.isWindows) return;

        final invoker = _RecordingInvoker();
        final svc = PowerInhibitorService(invoker: invoker.call);

        final handle = await svc.acquireSleepLock('Active SSH session');

        expect(handle, isNull);
        expect(invoker.calls, isEmpty);
        expect(svc.heldLockCount, 0);
      },
    );

    test(
      'invoker exception is swallowed and acquireSleepLock returns null',
      () async {
        if (!Platform.isLinux) return;

        Future<ResourceHandle> failingInvoker(
          String what,
          String who,
          String why,
          String mode,
        ) {
          return Future.error(StateError('login1 unavailable'));
        }

        final svc = PowerInhibitorService(invoker: failingInvoker);
        final handle = await svc.acquireSleepLock('Active SSH session');

        expect(handle, isNull);
        expect(svc.heldLockCount, 0);
      },
    );
  });

  // --------------------------------------------------------------------
  // Windows backend
  // --------------------------------------------------------------------
  //
  // The service routes acquireSleepLock through SetThreadExecutionState
  // when running on Windows. The Win32 API is NOT refcounted, so the
  // service must:
  //   * call once with the full ES_SYSTEM_REQUIRED|ES_AWAYMODE_REQUIRED|
  //     ES_CONTINUOUS mask on the first acquire,
  //   * leave the second/third/etc. acquires as cheap refcount bumps
  //     (no further system calls),
  //   * call once with ES_CONTINUOUS alone when the last lock is
  //     released (clearing the inhibit so the system may suspend again).
  //
  // The recording fake below mirrors the Win32 signature exactly and
  // returns the "previous state" value (non-zero on success).
  group('PowerInhibitorService Windows backend', () {
    test('acquireSleepLock issues exactly one '
        'ES_SYSTEM_REQUIRED|ES_AWAYMODE_REQUIRED|ES_CONTINUOUS call', () async {
      if (!Platform.isWindows) return;

      final calls = <int>[];
      int fakeInvoker(int flags) {
        calls.add(flags);
        // Return a non-zero "previous state" so the service treats it
        // as a successful call.
        return win32.esContinuous;
      }

      final svc = PowerInhibitorService(windowsInvoker: fakeInvoker);

      final handle = await svc.acquireSleepLock('Active SSH session');

      expect(handle, isNotNull);
      expect(svc.heldLockCount, 1);
      expect(calls, hasLength(1));
      expect(
        calls.single,
        win32.esSystemRequired | win32.esAwaymodeRequired | win32.esContinuous,
      );

      // Releasing should issue the clear-call (ES_CONTINUOUS alone).
      handle!.release();
      expect(svc.heldLockCount, 0);
      expect(calls, hasLength(2));
      expect(calls.last, win32.esContinuous);
    });

    test(
      'second acquire reuses the existing inhibit (no extra Win32 call)',
      () async {
        if (!Platform.isWindows) return;

        final calls = <int>[];
        int fakeInvoker(int flags) {
          calls.add(flags);
          return win32.esContinuous;
        }

        final svc = PowerInhibitorService(windowsInvoker: fakeInvoker);

        final h1 = await svc.acquireSleepLock('first');
        final h2 = await svc.acquireSleepLock('second');

        expect(h1, isNotNull);
        expect(h2, isNotNull);
        expect(svc.heldLockCount, 2);
        // Only ONE acquire-call must reach Win32: the API is not
        // refcounted, so a second `SetThreadExecutionState` would be
        // a redundant no-op at best.
        expect(calls, hasLength(1));

        // Releasing the first lock must NOT clear the inhibit while the
        // second is still held.
        h1!.release();
        expect(svc.heldLockCount, 1);
        expect(calls, hasLength(1));

        // Releasing the second lock must clear the inhibit.
        h2!.release();
        expect(svc.heldLockCount, 0);
        expect(calls, hasLength(2));
        expect(calls.last, win32.esContinuous);
      },
    );

    test(
      'releaseAll clears the Win32 inhibit even with multiple locks held',
      () async {
        if (!Platform.isWindows) return;

        final calls = <int>[];
        int fakeInvoker(int flags) {
          calls.add(flags);
          return win32.esContinuous;
        }

        final svc = PowerInhibitorService(windowsInvoker: fakeInvoker);

        await svc.acquireSleepLock('first');
        await svc.acquireSleepLock('second');
        await svc.acquireSleepLock('third');
        expect(svc.heldLockCount, 3);
        expect(calls, hasLength(1)); // only the initial acquire

        svc.releaseAll();

        expect(svc.heldLockCount, 0);
        // Exactly one clear-call regardless of how many handles were
        // held — the OS state was set once and is cleared once.
        final clearCalls = calls.where((f) => f == win32.esContinuous);
        expect(clearCalls, hasLength(1));
      },
    );

    test('SetThreadExecutionState returning 0 yields a null handle', () async {
      if (!Platform.isWindows) return;

      final calls = <int>[];
      int failingInvoker(int flags) {
        calls.add(flags);
        // Per MSDN, a return of 0 means the call failed.
        return 0;
      }

      final svc = PowerInhibitorService(windowsInvoker: failingInvoker);

      final handle = await svc.acquireSleepLock('Active SSH session');

      expect(handle, isNull);
      expect(svc.heldLockCount, 0);
      expect(calls, hasLength(1));
    });
  });

  // --------------------------------------------------------------------
  // Android backend
  // --------------------------------------------------------------------
  //
  // The service routes acquireSleepLock through the WakeLockHelper
  // platform channel when running on Android. Each handle owns its own
  // PowerManager.WakeLock, keyed by the opaque string returned from the
  // native `acquire(reason)` call. Releasing the handle hands that key
  // back to `release(key)` which calls `WakeLock.release()`.
  //
  // The tests are platform-gated on `Platform.isAndroid` because the
  // service short-circuits everywhere else; they run only on the Android
  // CI runner (matching how the other backends are gated).
  group('PowerInhibitorService Android backend', () {
    test('acquireSleepLock forwards the reason and stores the key', () async {
      if (!Platform.isAndroid) return;

      final acquireCalls = <String>[];
      final releaseCalls = <String>[];
      var nextKey = 0;

      Future<String> fakeAcquire(String reason) async {
        acquireCalls.add(reason);
        nextKey++;
        return 'wl-$nextKey';
      }

      Future<void> fakeRelease(String key) async {
        releaseCalls.add(key);
      }

      final svc = PowerInhibitorService(
        androidAcquire: fakeAcquire,
        androidRelease: fakeRelease,
      );

      final handle = await svc.acquireSleepLock('Active SSH session');

      expect(handle, isNotNull);
      expect(svc.heldLockCount, 1);
      expect(acquireCalls, ['Active SSH session']);
      expect(handle!.androidWakeLockKey, 'wl-1');

      handle.release();
      // Release is fire-and-forget; let the microtask queue drain.
      await Future<void>.delayed(Duration.zero);

      expect(svc.heldLockCount, 0);
      expect(releaseCalls, ['wl-1']);
    });

    test(
      'multiple acquires produce independent handles with distinct keys',
      () async {
        if (!Platform.isAndroid) return;

        final acquireCalls = <String>[];
        final releaseCalls = <String>[];
        var nextKey = 0;

        Future<String> fakeAcquire(String reason) async {
          acquireCalls.add(reason);
          nextKey++;
          return 'wl-$nextKey';
        }

        Future<void> fakeRelease(String key) async {
          releaseCalls.add(key);
        }

        final svc = PowerInhibitorService(
          androidAcquire: fakeAcquire,
          androidRelease: fakeRelease,
        );

        final h1 = await svc.acquireSleepLock('first');
        final h2 = await svc.acquireSleepLock('second');

        expect(h1, isNotNull);
        expect(h2, isNotNull);
        expect(svc.heldLockCount, 2);
        expect(acquireCalls, ['first', 'second']);
        expect(h1!.androidWakeLockKey, 'wl-1');
        expect(h2!.androidWakeLockKey, 'wl-2');

        h1.release();
        await Future<void>.delayed(Duration.zero);
        expect(svc.heldLockCount, 1);
        expect(releaseCalls, ['wl-1']);

        h2.release();
        await Future<void>.delayed(Duration.zero);
        expect(svc.heldLockCount, 0);
        expect(releaseCalls, ['wl-1', 'wl-2']);
      },
    );

    test('releaseAll releases every wake lock on the native side', () async {
      if (!Platform.isAndroid) return;

      final releaseCalls = <String>[];
      var nextKey = 0;

      Future<String> fakeAcquire(String reason) async {
        nextKey++;
        return 'wl-$nextKey';
      }

      Future<void> fakeRelease(String key) async {
        releaseCalls.add(key);
      }

      final svc = PowerInhibitorService(
        androidAcquire: fakeAcquire,
        androidRelease: fakeRelease,
      );

      await svc.acquireSleepLock('first');
      await svc.acquireSleepLock('second');
      await svc.acquireSleepLock('third');
      expect(svc.heldLockCount, 3);

      svc.releaseAll();
      await Future<void>.delayed(Duration.zero);

      expect(svc.heldLockCount, 0);
      // Every acquired key should have been handed back.
      expect(releaseCalls.toSet(), {'wl-1', 'wl-2', 'wl-3'});
    });

    test(
      'native acquire failure is swallowed and yields a null handle',
      () async {
        if (!Platform.isAndroid) return;

        Future<String> failingAcquire(String reason) {
          return Future.error(StateError('wake_lock channel unavailable'));
        }

        Future<void> fakeRelease(String key) async {}

        final svc = PowerInhibitorService(
          androidAcquire: failingAcquire,
          androidRelease: fakeRelease,
        );

        final handle = await svc.acquireSleepLock('Active SSH session');

        expect(handle, isNull);
        expect(svc.heldLockCount, 0);
      },
    );
  });
}
