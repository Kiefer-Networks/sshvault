// Wayland-aware clipboard helper.
//
// Background: under a Wayland compositor the clipboard offer is owned by the
// process that put the data there. As soon as that process exits, the
// compositor drops the offer and the clipboard is empty again. For SSHVault
// users that is a footgun — they copy a public key or a password, switch to a
// terminal/browser, and the paste yields nothing because the SSHVault window
// was already closed (or its in-process buffer cleared by the auto-clear
// timer firing in the wrong order).
//
// The standard fix is to delegate to `wl-copy` (from `wl-clipboard`) and
// detach it: the helper process keeps the clipboard offer alive even after
// the parent app exits, until either the user pastes (most compositors drop
// the offer automatically after a successful paste) or we explicitly clear
// the selection with `wl-copy --clear`.
//
// This service is a thin shim around that pattern. It detects whether we are
// running under Wayland on Linux; if so, [copyDetached] forks `wl-copy`
// detached with the secret on stdin. On X11, macOS, Windows, mobile, and the
// web, it falls back to Flutter's standard `Clipboard.setData`, which is
// fine because those platforms do not lose the clipboard when the owning
// process exits.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Result of attempting a [WaylandClipboardService.copyDetached] call.
enum ClipboardCopyBackend {
  /// We forked `wl-copy` as a detached process.
  waylandDetached,

  /// We used Flutter's in-process `Clipboard.setData`.
  inProcess,

  /// We attempted Wayland but `wl-copy` was unavailable / failed; we fell
  /// back to in-process clipboard. The caller may want to surface a hint.
  waylandFallback,
}

/// Signature compatible with `Process.start`. Tests inject a fake to verify
/// argv, stdin payload, and start-mode without spawning a real subprocess.
typedef ProcessStarter =
    Future<Process> Function(
      String executable,
      List<String> arguments, {
      ProcessStartMode mode,
    });

/// Signature compatible with `Process.run`, used to probe `which wl-copy`
/// and to fire the `wl-copy --clear` after the auto-clear timer.
typedef ProcessRunner =
    Future<ProcessResult> Function(String executable, List<String> arguments);

/// Reads `Platform.environment` — overridable so tests can simulate Wayland
/// without actually setting `WAYLAND_DISPLAY` in the test process.
typedef EnvironmentReader = Map<String, String> Function();

/// Wayland-aware clipboard service. Wire this through DI / a Riverpod
/// provider so call sites in features can copy secrets without caring about
/// the underlying compositor.
class WaylandClipboardService {
  WaylandClipboardService({
    ProcessStarter? processStarter,
    ProcessRunner? processRunner,
    EnvironmentReader? environmentReader,
    bool? isLinuxOverride,
    Future<void> Function(ClipboardData data)? clipboardSetter,
  }) : _processStarter =
           processStarter ??
           ((exe, args, {ProcessStartMode mode = ProcessStartMode.normal}) =>
               Process.start(exe, args, mode: mode)),
       _processRunner = processRunner ?? Process.run,
       _environmentReader = environmentReader ?? (() => Platform.environment),
       _isLinux = isLinuxOverride ?? Platform.isLinux,
       _clipboardSetter = clipboardSetter ?? Clipboard.setData;

  final ProcessStarter _processStarter;
  final ProcessRunner _processRunner;
  final EnvironmentReader _environmentReader;
  final bool _isLinux;
  final Future<void> Function(ClipboardData data) _clipboardSetter;

  /// Cached `wl-copy` availability. Populated lazily by [isAvailable]; reset
  /// only via [resetForTest] because PATH does not change at runtime.
  bool? _wlCopyAvailable;

  /// Active auto-clear timer, if any. Kept so a subsequent copy can cancel
  /// the previous timer (otherwise the new value would get nuked early).
  Timer? _clearTimer;

  /// Default auto-clear duration applied to the in-process fallback when no
  /// explicit value is provided. Matches the existing 30 s SecureClipboard
  /// behavior the rest of the app already documents.
  static const Duration defaultAutoClear = Duration(seconds: 30);

  /// `true` iff we believe the current process is running under Wayland on
  /// Linux. The check is deliberately permissive: `WAYLAND_DISPLAY` is the
  /// canonical signal documented by the freedesktop spec.
  bool get isWaylandSession {
    if (!_isLinux) return false;
    final display = _environmentReader()['WAYLAND_DISPLAY'];
    return display != null && display.isNotEmpty;
  }

  /// Returns `true` if `wl-copy` is on PATH. The result is cached for the
  /// lifetime of the service — a missing binary at boot is not going to
  /// magically appear later, and `which` is cheap but not free.
  Future<bool> isAvailable() async {
    if (!_isLinux) return false;
    final cached = _wlCopyAvailable;
    if (cached != null) return cached;
    try {
      final res = await _processRunner('which', const ['wl-copy']);
      final ok = res.exitCode == 0;
      _wlCopyAvailable = ok;
      return ok;
    } on ProcessException {
      _wlCopyAvailable = false;
      return false;
    }
  }

  /// Copies [content] to the clipboard.
  ///
  /// On Wayland (Linux + `WAYLAND_DISPLAY` set + `wl-copy` available) this
  /// forks a detached `wl-copy` process so the clipboard offer survives
  /// after the SSHVault process exits.
  ///
  /// On every other platform — and as a graceful fallback when `wl-copy`
  /// is missing — this delegates to Flutter's `Clipboard.setData`.
  ///
  /// If [autoClear] is non-null, the clipboard is cleared after the given
  /// duration. On Wayland this is implemented by spawning `wl-copy --clear`;
  /// on other platforms by overwriting the clipboard with an empty string.
  /// Pass [autoClear] = `null` (the default) to disable; callers wiring
  /// SecureClipboard's existing 30 s timer should pass [defaultAutoClear].
  Future<ClipboardCopyBackend> copyDetached(
    String content, {
    Duration? autoClear,
  }) async {
    // Cancel any previous auto-clear so we do not nuke the new value early.
    _clearTimer?.cancel();
    _clearTimer = null;

    if (isWaylandSession && await isAvailable()) {
      try {
        final proc = await _processStarter(
          'wl-copy',
          const <String>[],
          mode: ProcessStartMode.detached,
        );
        proc.stdin.add(utf8.encode(content));
        // `flush` + `close` is the documented way to ensure the data has
        // actually reached the helper before its stdin EOFs. We swallow
        // errors here because some Process implementations close stdin
        // synchronously and re-raise on the second flush.
        try {
          await proc.stdin.flush();
        } catch (_) {}
        try {
          await proc.stdin.close();
        } catch (_) {}

        if (autoClear != null) {
          _clearTimer = Timer(autoClear, () {
            _runWlCopyClear();
          });
        }
        return ClipboardCopyBackend.waylandDetached;
      } catch (e, st) {
        // wl-copy failed — fall through to the in-process clipboard so the
        // user still gets *something* on their clipboard.
        if (kDebugMode) {
          debugPrint('wl-copy detached spawn failed: $e\n$st');
        }
        await _setInProcess(content, autoClear);
        return ClipboardCopyBackend.waylandFallback;
      }
    }

    await _setInProcess(content, autoClear);
    return ClipboardCopyBackend.inProcess;
  }

  /// Cancels any pending auto-clear timer (e.g. when a new copy supersedes
  /// the previous one, or when the user manually cleared the clipboard).
  void cancelPendingClear() {
    _clearTimer?.cancel();
    _clearTimer = null;
  }

  /// Visible for tests. Forces the next [isAvailable] to re-probe and
  /// cancels any in-flight clear timer.
  @visibleForTesting
  void resetForTest() {
    _wlCopyAvailable = null;
    _clearTimer?.cancel();
    _clearTimer = null;
  }

  Future<void> _setInProcess(String content, Duration? autoClear) async {
    await _clipboardSetter(ClipboardData(text: content));
    if (autoClear != null) {
      _clearTimer = Timer(autoClear, () async {
        try {
          await _clipboardSetter(const ClipboardData(text: ''));
        } catch (_) {}
      });
    }
  }

  Future<void> _runWlCopyClear() async {
    try {
      await _processRunner('wl-copy', const ['--clear']);
    } on ProcessException {
      // Best effort. If the binary disappeared the clipboard offer dies
      // with the helper anyway.
    } catch (_) {}
  }
}
