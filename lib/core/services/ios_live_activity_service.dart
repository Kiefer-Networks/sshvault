// iOS 16.1+ Live Activity service for SSHVault.
//
// Posts a single "active SSH sessions" Live Activity to the Dynamic
// Island and the lock-screen card by translating
// `sessionManagerProvider` mutations into `start` / `update` / `end`
// calls over the `de.kiefer_networks.sshvault/live_activity` method
// channel. Native bridge: `ios/Runner/LiveActivityBridge.swift`.
//
// On every non-iOS host (Linux / Windows / macOS / Android) every
// method short-circuits to a no-op so the service can be wired
// unconditionally from `app.dart` without `Platform.isIOS` guards at
// every call site.

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

/// Method-channel name shared with `LiveActivityBridge.swift`. Renaming
/// on either side breaks the bridge — both must move together.
const String kIosLiveActivityChannel =
    'de.kiefer_networks.sshvault/live_activity';

/// Maximum number of host names we ship to the activity. ActivityKit
/// caps the encoded payload at 4 KB; five entries is well within that
/// even with long FQDNs. The native side re-clamps defensively so a
/// future regression here can't blow the budget.
const int _kMaxHostNames = 5;

/// Wraps the native ActivityKit bridge and projects
/// `sessionManagerProvider` state onto it. Owns no state of its own
/// beyond an "is an activity currently posted" flag — ActivityKit is
/// the source of truth for the live UI.
///
/// Usage from `app.dart`:
///
/// ```dart
/// ref.read(iosLiveActivityServiceProvider).attach(ref);
/// ```
///
/// The provider keepalives itself so the listener survives widget
/// rebuilds (matching the desktop power-inhibitor pattern).
class IosLiveActivityService {
  IosLiveActivityService({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel(kIosLiveActivityChannel);

  final MethodChannel _channel;
  final _log = LoggingService.instance;
  static const _tag = 'LiveActivity';

  /// True once we've successfully posted a `start` call. Used to pick
  /// between `start` (first invocation) and `update` (subsequent ticks)
  /// so we don't accidentally request a fresh activity on every state
  /// emission.
  bool _started = false;

  /// True if the user has disabled the toggle. Cached to avoid reading
  /// the settings provider on every session emission.
  bool _enabled = true;

  ProviderSubscription<List<SshSessionEntity>>? _sessionSub;
  ProviderSubscription? _settingsSub;

  /// Wires the listeners. No-op on non-iOS hosts.
  void attach(Ref ref) {
    if (!Platform.isIOS) return;

    // Mirror the user's "Show active sessions on Lock Screen" toggle.
    // We listen rather than read-once so flipping the switch off
    // tears down the live activity immediately.
    _settingsSub = ref.listen(settingsProvider, (_, next) {
      final s = next.value;
      if (s == null) return;
      final wasEnabled = _enabled;
      _enabled = s.iosLiveActivitySessions;
      if (wasEnabled && !_enabled) {
        // Toggle flipped off — retract any in-flight activity.
        unawaited(end());
      } else if (!wasEnabled && _enabled) {
        // Toggle flipped on — re-sync against the current session list.
        final sessions = ref.read(sessionManagerProvider);
        unawaited(_syncFromSessions(sessions));
      }
    }, fireImmediately: true);

    // Project session-manager state onto ActivityKit. We only post
    // `connected` sessions — half-finished connection attempts would
    // make the count bounce around uselessly.
    _sessionSub = ref.listen<List<SshSessionEntity>>(
      sessionManagerProvider,
      (_, next) => unawaited(_syncFromSessions(next)),
      fireImmediately: true,
    );
  }

  /// Cleanup hook for tests. Production code lets the keepAlive
  /// provider live for the process's lifetime.
  void dispose() {
    _sessionSub?.close();
    _settingsSub?.close();
    _sessionSub = null;
    _settingsSub = null;
  }

  Future<void> _syncFromSessions(List<SshSessionEntity> sessions) async {
    if (!Platform.isIOS || !_enabled) return;

    final connected = sessions
        .where((s) => s.status == SshConnectionStatus.connected)
        .toList();

    if (connected.isEmpty) {
      await end();
      return;
    }

    // Most-recently-created first so the lock-screen card surfaces the
    // session the user is actually likely to care about when truncation
    // kicks in.
    connected.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final names = connected
        .take(_kMaxHostNames)
        .map((s) => s.title)
        .toList(growable: false);

    if (_started) {
      await update(connected.length, names);
    } else {
      await start(connected.length, names);
    }
  }

  /// Starts (or re-starts) the live activity. Safe to call when an
  /// activity is already alive — the native bridge folds it into an
  /// update so we never spawn duplicates.
  Future<void> start(int count, List<String> names) async {
    if (!Platform.isIOS) return;
    try {
      await _channel.invokeMethod<void>('start', {
        'count': count,
        'names': names,
      });
      _started = true;
    } on MissingPluginException {
      // iOS < 16.1 never registers the bridge. Fail closed.
      _started = false;
    } catch (e) {
      _log.warning(_tag, 'start() failed: $e');
    }
  }

  /// Pushes a new content state onto the running activity. No-op when
  /// no activity has been started.
  Future<void> update(int count, List<String> names) async {
    if (!Platform.isIOS || !_started) return;
    try {
      await _channel.invokeMethod<void>('update', {
        'count': count,
        'names': names,
      });
    } on MissingPluginException {
      _started = false;
    } catch (e) {
      _log.warning(_tag, 'update() failed: $e');
    }
  }

  /// Tears down the running activity. Idempotent — safe to call when
  /// nothing is alive.
  Future<void> end() async {
    if (!Platform.isIOS || !_started) return;
    try {
      await _channel.invokeMethod<void>('end');
    } on MissingPluginException {
      // ignore — extension is unavailable
    } catch (e) {
      _log.warning(_tag, 'end() failed: $e');
    }
    _started = false;
  }
}

/// Eagerly-pinned provider. Reading it once from `app.dart` (and never
/// disposing) is enough to keep the listeners alive for the process's
/// lifetime.
final iosLiveActivityServiceProvider = Provider<IosLiveActivityService>((ref) {
  final svc = IosLiveActivityService();
  ref.onDispose(svc.dispose);
  if (Platform.isIOS) {
    svc.attach(ref);
  }
  return svc;
});
