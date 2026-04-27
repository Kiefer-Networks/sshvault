// In-memory session history for SSHVault.
//
// Tracks the most recently activated host id so external triggers (e.g. the
// freedesktop `ReopenLast` desktop action) can re-open the previous session
// without persisting state. The provider is intentionally tiny and synchronous
// — persistence (`HeadlessBootService.lastActiveHosts`) lives elsewhere; this
// provider is a fast in-memory shortcut for the running process.

import 'package:flutter_riverpod/legacy.dart';

/// Holds the last-active host id (server id), or `null` if no session has
/// been opened yet during this run.
class SessionHistoryNotifier extends StateNotifier<String?> {
  SessionHistoryNotifier() : super(null);

  /// Records [hostId] as the most recently activated host.
  void recordHost(String hostId) {
    if (hostId.isEmpty) return;
    state = hostId;
  }

  /// Clears the history (used in tests or when the user purges activity).
  void clear() => state = null;
}

/// Last-active host tracker exposed as a Riverpod StateNotifier so DBus
/// `ActivateAction("ReopenLast")` can pull the value synchronously.
final sessionHistoryProvider =
    StateNotifierProvider<SessionHistoryNotifier, String?>(
      (ref) => SessionHistoryNotifier(),
    );
