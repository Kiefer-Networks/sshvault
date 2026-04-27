// SecureClipboard — single entry point for copying secret material
// (private keys, passwords, fingerprints, snippet content with placeholders
// resolved) out of SSHVault.
//
// Goals:
//   * On Wayland, survive the SSHVault process exiting (handled by
//     [WaylandClipboardService.copyDetached]) so users can paste into a
//     terminal/browser even after closing the app.
//   * Auto-clear after 30 s by default so credentials do not linger in the
//     clipboard indefinitely. On Wayland this fires `wl-copy --clear`; on
//     other platforms it overwrites the clipboard buffer with an empty
//     string.
//   * Be a drop-in replacement for `Clipboard.setData(ClipboardData(text:
//     ...))` at call sites in features/.
//
// The Wayland integration is automatic — no settings toggle. If we are not
// on Wayland, or `wl-copy` is missing, we transparently fall back to the
// regular Flutter clipboard.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sshvault/core/services/wayland_clipboard_service.dart';

/// Default duration after which copied secrets are wiped from the
/// clipboard. Mirrors password-manager conventions (1Password / KeePassXC
/// both default in this neighborhood).
const Duration kSecureClipboardClearDuration = Duration(seconds: 30);

/// Thin facade that prefers [WaylandClipboardService.copyDetached] for
/// secrets and exposes a non-secret `copyPlain` path for things like UI
/// labels that shouldn't trigger the auto-clear timer.
class SecureClipboard {
  SecureClipboard({WaylandClipboardService? waylandService})
    : _wayland = waylandService ?? WaylandClipboardService();

  final WaylandClipboardService _wayland;

  /// Copies a sensitive value (password, private key, recovery phrase,
  /// fingerprint) to the clipboard. Returns the backend that was actually
  /// used so callers can localize a hint ("kept after app exit on Wayland",
  /// "cleared in 30 s", etc.) if they wish.
  Future<ClipboardCopyBackend> copySecret(
    String content, {
    Duration? clearAfter = kSecureClipboardClearDuration,
  }) {
    return _wayland.copyDetached(content, autoClear: clearAfter);
  }

  /// Copies a non-secret value (e.g. a hostname) using the same backend
  /// selection but without an auto-clear timer.
  Future<ClipboardCopyBackend> copyPlain(String content) {
    return _wayland.copyDetached(content);
  }

  /// Cancels the pending 30 s auto-clear, if any. Useful when the user
  /// performs a secondary action that would race with the timer.
  void cancelPendingClear() => _wayland.cancelPendingClear();

  /// `true` if the active session would benefit from the detached helper.
  /// Currently equivalent to "Linux + Wayland".
  bool get isWaylandSession => _wayland.isWaylandSession;
}

/// Riverpod provider so feature widgets can `ref.read(secureClipboardProvider)`
/// instead of constructing the service directly.
final secureClipboardProvider = Provider<SecureClipboard>((ref) {
  return SecureClipboard();
});

/// Riverpod provider for the underlying Wayland helper, exposed separately
/// so tests can override only the helper without rebuilding [SecureClipboard].
final waylandClipboardServiceProvider = Provider<WaylandClipboardService>((
  ref,
) {
  return WaylandClipboardService();
});
