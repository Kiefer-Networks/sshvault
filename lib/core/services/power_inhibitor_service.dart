// Cross-platform power management inhibitor.
//
// While at least one SSH session is connected we ask the host OS to block
// automatic suspend / idle sleep so a long-running session does not
// silently die when the user steps away from the keyboard.
//
// Linux backend (systemd-logind / freedesktop login1):
//
//   org.freedesktop.login1.Manager.Inhibit(
//     what:  "sleep:idle",
//     who:   "SSHVault",
//     why:   <reason>,
//     mode:  "block",
//   ) -> h (unix file descriptor)
//
// As long as the returned file descriptor stays open the inhibitor is
// active. Closing it releases the lock. We keep the held fds in a list
// so [releaseAll] can shut everything down on app exit.
//
// Windows backend (kernel32!SetThreadExecutionState):
//
//   SetThreadExecutionState(
//     ES_SYSTEM_REQUIRED | ES_AWAYMODE_REQUIRED | ES_CONTINUOUS,
//   )
//
// The Win32 API is **not refcounted** — a second call replaces the
// first, it does not stack. To preserve the same multi-lock semantics
// as the Linux backend we maintain an internal counter and only issue
// the "release" call (`ES_CONTINUOUS` alone) when the counter hits 0.
// Each [InhibitorLockHandle] returned to the caller represents one slot
// in that counter; releasing the last one clears the system state.
//
// On macOS / mobile every public method is a cheap no-op so callers
// don't need to platform-gate.

import 'dart:async';
import 'dart:io';

import 'package:dbus/dbus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sshvault/core/ffi/win32_power.dart' as win32;
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

/// Well-known login1 destination + path + interface used for Inhibit calls.
const String _login1BusName = 'org.freedesktop.login1';
const String _login1ObjectPath = '/org/freedesktop/login1';
const String _login1ManagerInterface = 'org.freedesktop.login1.Manager';

/// Default `who` field reported to login1; shows up in `loginctl
/// list-inhibitors`.
const String kPowerInhibitorWho = 'SSHVault';

/// Default `what` argument: block both automatic suspend and the idle hint
/// being raised. Matches what GNOME / KDE use for active media players.
const String kPowerInhibitorWhat = 'sleep:idle';

/// Default `mode`: "block" stops the action entirely (vs. "delay" which only
/// delays it by a few seconds).
const String kPowerInhibitorMode = 'block';

/// Function shape that performs the actual `Inhibit` call against the
/// system bus. Tests inject a fake here so the service can be exercised
/// without a real bus.
typedef InhibitInvoker =
    Future<ResourceHandle> Function(
      String what,
      String who,
      String why,
      String mode,
    );

/// Function shape for the Win32 `SetThreadExecutionState` call. Tests
/// inject a recording fake; production wiring uses the real FFI binding.
/// Mirrors the native signature: takes a bitwise-OR `EXECUTION_STATE`
/// flag mask and returns the previous mask (or `0` on failure).
typedef WindowsExecutionStateInvoker = int Function(int esFlags);

/// Closeable handle for a single inhibitor lock.
///
/// On Linux, holding the handle keeps an underlying logind fd open. On
/// Windows it represents one slot in the service's reference count for
/// `SetThreadExecutionState`. Call [release] to drop the lock; safe to
/// call multiple times.
class InhibitorLockHandle {
  /// Linux flavour: backed by an open file descriptor returned from
  /// login1's `Inhibit` call.
  InhibitorLockHandle._linux(ResourceHandle handle, this._onRelease)
    : _handle = handle;

  /// Windows flavour: a refcount slot only. The actual system state is
  /// owned by [PowerInhibitorService] and maintained via the service's
  /// internal counter; releasing the last handle triggers the
  /// `ES_CONTINUOUS`-only call that clears the inhibit.
  InhibitorLockHandle._windows(this._onRelease) : _handle = null;

  final ResourceHandle? _handle;
  final void Function(InhibitorLockHandle handle)? _onRelease;
  bool _released = false;

  bool get isReleased => _released;

  /// Releases this lock. On Linux this closes the underlying file
  /// descriptor (login1 observes the close and drops the inhibit). On
  /// Windows it decrements the service's refcount and, when it reaches
  /// zero, calls `SetThreadExecutionState(ES_CONTINUOUS)` to clear.
  ///
  /// Safe to call multiple times; subsequent calls are no-ops.
  void release() {
    if (_released) return;
    _released = true;
    final handle = _handle;
    if (handle != null) {
      try {
        // Closing the RandomAccessFile closes the underlying fd, which
        // is what login1 watches to know the lock has been dropped.
        handle.toFile().closeSync();
      } catch (_) {
        // Best-effort: if the fd was already closed by something else
        // (e.g. the bus disconnecting) we still want to mark the handle
        // released.
      }
    }
    _onRelease?.call(this);
  }
}

/// Bitmask used on Windows when acquiring a sleep inhibitor.
///
/// `ES_SYSTEM_REQUIRED` keeps the system from suspending due to user-idle
/// timeouts; `ES_AWAYMODE_REQUIRED` ensures the call works on desktops
/// where away-mode is enabled (laptops without it ignore the bit, which
/// is the documented behaviour); `ES_CONTINUOUS` makes the state stick
/// until we explicitly clear it (rather than being a one-shot reset of
/// the idle timer).
const int kWindowsAcquireFlags =
    win32.esSystemRequired | win32.esAwaymodeRequired | win32.esContinuous;

/// Bitmask used on Windows when releasing the inhibitor: passing just
/// `ES_CONTINUOUS` resets the thread's execution state to "no
/// requirements", allowing the system to suspend normally.
const int kWindowsReleaseFlags = win32.esContinuous;

/// Manages cross-platform inhibitor locks for SSHVault.
///
/// Typical usage from the riverpod wiring:
///
/// ```dart
/// final svc = PowerInhibitorService();
/// final handle = await svc.acquireSleepLock('Active SSH session');
/// // ... later, when no sessions remain:
/// handle?.release();
/// ```
///
/// Multiple SSH sessions reuse a single lock — the wiring code is
/// expected to acquire on `0 -> >=1` and release on `>=1 -> 0`. The
/// service itself supports stacking multiple handles so that nested
/// callers (tests, future per-session policies) work too.
class PowerInhibitorService {
  PowerInhibitorService({
    InhibitInvoker? invoker,
    WindowsExecutionStateInvoker? windowsInvoker,
    LoggingService? logger,
  }) : _invoker = invoker,
       _windowsInvoker = windowsInvoker,
       _log = logger ?? LoggingService.instance;

  static const _tag = 'PowerInhibitor';

  final InhibitInvoker? _invoker;
  final WindowsExecutionStateInvoker? _windowsInvoker;
  final LoggingService _log;

  /// All currently-held locks. Kept so [releaseAll] can clean up at
  /// shutdown even if individual callers forgot to release.
  final List<InhibitorLockHandle> _heldLocks = <InhibitorLockHandle>[];

  /// Number of currently-held (non-released) locks. Useful for tests.
  int get heldLockCount => _heldLocks.where((h) => !h.isReleased).length;

  /// Acquires a single sleep/idle inhibitor lock with the given [reason].
  ///
  /// Returns `null` on:
  ///   * unsupported platforms (macOS / mobile),
  ///   * if the underlying OS call fails (logind unreachable, kernel32
  ///     lookup failed, etc).
  ///
  /// Callers should treat a null return as "no power management override
  /// available" and continue normally — the system may still suspend.
  Future<InhibitorLockHandle?> acquireSleepLock(String reason) async {
    if (Platform.isLinux) {
      return _acquireLinux(reason);
    }
    if (Platform.isWindows) {
      return _acquireWindows(reason);
    }
    return null;
  }

  Future<InhibitorLockHandle?> _acquireLinux(String reason) async {
    try {
      final invoker = _invoker ?? _defaultInvoker;
      final handle = await invoker(
        kPowerInhibitorWhat,
        kPowerInhibitorWho,
        reason,
        kPowerInhibitorMode,
      );
      final lock = InhibitorLockHandle._linux(handle, _onLockReleased);
      _heldLocks.add(lock);
      _log.info(_tag, 'Acquired sleep inhibitor (logind): $reason');
      return lock;
    } catch (e, st) {
      _log.warning(_tag, 'Failed to acquire sleep inhibitor: $e\n$st');
      return null;
    }
  }

  /// Acquires a Windows inhibitor.
  ///
  /// On Windows the underlying `SetThreadExecutionState` API is *not*
  /// refcounted — calling it again with the same flags doesn't stack.
  /// We model multi-acquire semantics by issuing the API call only on
  /// the `0 -> 1` transition and the corresponding clear-call only on
  /// the `1 -> 0` transition (in [_onLockReleased]).
  Future<InhibitorLockHandle?> _acquireWindows(String reason) async {
    try {
      final firstLock = _heldLocks.where((h) => !h.isReleased).isEmpty;
      if (firstLock) {
        final invoker = _windowsInvoker ?? win32.setThreadExecutionState;
        final prev = invoker(kWindowsAcquireFlags);
        // SetThreadExecutionState returns 0 on failure. We log and
        // refuse to hand out a lock so the caller can react (e.g. by
        // skipping the toast). Mirror the Linux "best-effort" stance.
        if (prev == 0) {
          _log.warning(
            _tag,
            'SetThreadExecutionState returned 0 (failure) for: $reason',
          );
          return null;
        }
      }
      final lock = InhibitorLockHandle._windows(_onLockReleased);
      _heldLocks.add(lock);
      _log.info(_tag, 'Acquired sleep inhibitor (Win32): $reason');
      return lock;
    } catch (e, st) {
      _log.warning(_tag, 'Failed to acquire sleep inhibitor: $e\n$st');
      return null;
    }
  }

  /// Releases every lock currently held by this service. Safe to call
  /// repeatedly; locks already released are skipped.
  void releaseAll() {
    // Iterate over a copy because [release] mutates [_heldLocks] via the
    // _onLockReleased callback.
    final snapshot = List<InhibitorLockHandle>.from(_heldLocks);
    for (final lock in snapshot) {
      lock.release();
    }
    _heldLocks.clear();
  }

  void _onLockReleased(InhibitorLockHandle handle) {
    _heldLocks.remove(handle);
    // Windows-only: when the last lock is released, clear the system
    // execution state so the OS may suspend again. Linux releases per-
    // handle via fd close, no aggregate cleanup needed here.
    if (Platform.isWindows && _heldLocks.where((h) => !h.isReleased).isEmpty) {
      try {
        final invoker = _windowsInvoker ?? win32.setThreadExecutionState;
        invoker(kWindowsReleaseFlags);
      } catch (e, st) {
        _log.warning(_tag, 'Failed to clear Win32 execution state: $e\n$st');
      }
    }
  }

  /// Reason string baked into the Inhibit call's `why` field.
  static const String defaultReason = 'Active SSH session';

  /// Default DBus invocation against the system bus. Opens a fresh client
  /// per call (cheap; the call is rare — once per "first session opened").
  static Future<ResourceHandle> _defaultInvoker(
    String what,
    String who,
    String why,
    String mode,
  ) async {
    final client = DBusClient.system();
    try {
      final remote = DBusRemoteObject(
        client,
        name: _login1BusName,
        path: DBusObjectPath(_login1ObjectPath),
      );
      final reply = await remote.callMethod(
        _login1ManagerInterface,
        'Inhibit',
        [DBusString(what), DBusString(who), DBusString(why), DBusString(mode)],
        replySignature: DBusSignature('h'),
      );
      final fd = reply.values.single as DBusUnixFd;
      return fd.handle;
    } finally {
      // Closing the client does NOT close the received fd — the dbus
      // package transfers ownership of the underlying handle to us.
      await client.close();
    }
  }
}

// ---------------------------------------------------------------------------
// Riverpod wiring
// ---------------------------------------------------------------------------

/// Singleton service. Disposing the provider releases any held inhibitor.
final powerInhibitorServiceProvider = Provider<PowerInhibitorService>((ref) {
  final svc = PowerInhibitorService();
  ref.onDispose(svc.releaseAll);
  return svc;
});

/// Watches [sessionManagerProvider] and acquires/releases a single sleep
/// inhibitor based on session count transitions:
///
///   * 0 -> >=1 : acquire one lock
///   * >=1 -> 0 : release the held lock
///
/// Multiple concurrent sessions reuse the same lock, so opening a second
/// terminal while the first is connected is a no-op for login1.
///
/// The watcher is gated on the user-facing
/// [AppSettingsEntity.preventSuspendDuringSshSessions] toggle: when the
/// user disables it, any held lock is released and no new locks are
/// acquired until they re-enable it.
///
/// On unsupported platforms (macOS / mobile) this provider is
/// initialised but the underlying [PowerInhibitorService.acquireSleepLock]
/// is a no-op, so the watcher is effectively dormant. On Linux it talks
/// to logind; on Windows it talks to `kernel32!SetThreadExecutionState`.
final sshSessionPowerInhibitorProvider = Provider<void>((ref) {
  // Always-on listener; no listeners required to exist for the
  // subscription, so the provider must be `keepAlive` (non-autoDispose).
  ref.keepAlive();

  if (!Platform.isLinux && !Platform.isWindows) return;

  final svc = ref.watch(powerInhibitorServiceProvider);
  InhibitorLockHandle? heldLock;

  Future<void> reconcile(List<SshSessionEntity> sessions, bool enabled) async {
    final shouldHold = enabled && sessions.isNotEmpty;
    if (shouldHold && heldLock == null) {
      heldLock = await svc.acquireSleepLock(
        PowerInhibitorService.defaultReason,
      );
    } else if (!shouldHold && heldLock != null) {
      heldLock!.release();
      heldLock = null;
    }
  }

  // Initial reconcile in case sessions / settings already exist when the
  // provider first spins up.
  final initialSessions = ref.read(sessionManagerProvider);
  final initialEnabled = ref
      .read(settingsProvider)
      .maybeWhen(
        data: (s) => s.preventSuspendDuringSshSessions,
        orElse: () => true,
      );
  // Fire-and-forget; reconcile is async but the provider build is sync.
  unawaited(reconcile(initialSessions, initialEnabled));

  ref.listen<List<SshSessionEntity>>(sessionManagerProvider, (prev, next) {
    final enabled = ref
        .read(settingsProvider)
        .maybeWhen(
          data: (s) => s.preventSuspendDuringSshSessions,
          orElse: () => true,
        );
    unawaited(reconcile(next, enabled));
  });

  ref.listen(settingsProvider, (prev, next) {
    final enabled = next.maybeWhen(
      data: (s) => s.preventSuspendDuringSshSessions,
      orElse: () => true,
    );
    final sessions = ref.read(sessionManagerProvider);
    unawaited(reconcile(sessions, enabled));
  });

  ref.onDispose(() {
    heldLock?.release();
    heldLock = null;
  });
});
