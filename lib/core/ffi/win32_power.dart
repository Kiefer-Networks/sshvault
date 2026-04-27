// Minimal FFI binding to Windows `kernel32.SetThreadExecutionState` for
// power-management inhibits.
//
// The Win32 contract: while a process holds an execution state with the
// `ES_CONTINUOUS` bit set, Windows treats that thread as "in use" and will
// neither enter system sleep nor (with `ES_AWAYMODE_REQUIRED`) flip the
// active session into away-mode.
//
// Important quirks of the Win32 API which this file does NOT abstract
// away (the caller — `PowerInhibitorService` — handles them):
//
//   * The call is **per-thread** but **not refcounted**. A second call
//     replaces the first, it does not stack. Callers must therefore track
//     their own desired-state count and only issue the "release" call
//     (`ES_CONTINUOUS` alone) when that count drops to zero.
//   * The return value is the *previous* execution-state mask, or `0` on
//     failure. We surface it as a plain `int` and let the caller decide
//     whether a zero return is interesting (we do not — the inhibitor is
//     best-effort, mirroring the Linux logind behaviour).
//
// Loaded lazily so importing this file on non-Windows does not crash at
// module-load time. The actual `DynamicLibrary.open('kernel32.dll')` is
// only attempted when [SetThreadExecutionState] is first read.

import 'dart:ffi';
import 'dart:io';

/// Inform the system that the state being set should remain in effect
/// until the next call that uses `ES_CONTINUOUS` and one of the other
/// state flags is cleared.
const int esContinuous = 0x80000000;

/// Forces the system to be in the working state by resetting the system
/// idle timer.
const int esSystemRequired = 0x00000001;

/// Forces the display to be on by resetting the display idle timer.
/// Not used by SSHVault — terminals are usable with the screen off — but
/// exposed for completeness/tests.
const int esDisplayRequired = 0x00000002;

/// Enables away mode. This value must be specified with `ES_CONTINUOUS`.
/// Away mode should be used only by media-recording / media-distribution
/// applications that must perform critical background processing on
/// desktop computers while the computer appears to be sleeping. Long-
/// running SSH sessions qualify under "critical background processing".
const int esAwaymodeRequired = 0x00000040;

/// FFI typedef for `SetThreadExecutionState` as exported by kernel32.dll.
///
/// MSDN signature:
/// ```c
/// EXECUTION_STATE SetThreadExecutionState(EXECUTION_STATE esFlags);
/// ```
/// Where `EXECUTION_STATE` is `DWORD` (uint32) on all supported Windows
/// targets.
typedef SetThreadExecutionStateNative = Uint32 Function(Uint32 esFlags);
typedef SetThreadExecutionStateDart = int Function(int esFlags);

DynamicLibrary? _kernel32Cache;

DynamicLibrary get _kernel32 {
  // Fail loudly on non-Windows: we should never reach this getter on any
  // other OS, because [PowerInhibitorService] platform-gates its callers.
  // The assertion exists to catch wiring regressions in tests.
  assert(Platform.isWindows, 'win32_power.dart loaded on non-Windows platform');
  return _kernel32Cache ??= DynamicLibrary.open('kernel32.dll');
}

/// Direct binding to `kernel32!SetThreadExecutionState`.
///
/// Pass a bitwise-OR of the `es*` constants above. Returns the previous
/// execution-state mask on success or `0` on failure.
///
/// Looked up lazily on first access so that importing this file on
/// non-Windows hosts (which is unavoidable when the surrounding service
/// platform-dispatches at runtime) does not blow up at JIT/AOT load
/// time.
final SetThreadExecutionStateDart setThreadExecutionState = _kernel32
    .lookupFunction<SetThreadExecutionStateNative, SetThreadExecutionStateDart>(
      'SetThreadExecutionState',
    );

/// Function shape used by [PowerInhibitorService] to allow tests to
/// substitute a recording fake. Mirrors the Win32 signature exactly.
typedef SetThreadExecutionStateFn = int Function(int esFlags);
