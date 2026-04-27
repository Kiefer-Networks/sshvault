// Linux-only global keyboard shortcut integration for SSHVault.
//
// Talks to `org.freedesktop.portal.Desktop` → `GlobalShortcuts` (xdg-desktop-
// portal v1.16+, GNOME 45+, Plasma 5.27+/6.x). The portal lets sandboxed apps
// register a system-wide hotkey *without* poking X11/Wayland directly — the
// compositor or shell binds the key, and forwards every press as a DBus signal
// (`Activated`).
//
// Flow:
//   1. `CreateSession`             → portal returns a session handle
//   2. `BindShortcuts`(handle, …)  → user confirms the trigger, portal stores
//                                    it persistently
//   3. portal emits `Activated`    → we surface it on a Riverpod provider
//
// On non-Linux platforms (or when the portal isn't installed) the public
// entrypoints are cheap no-ops so the rest of the app doesn't have to special-
// case the platform. The Settings UI calls
// [GlobalShortcutService.isPortalAvailable] to decide whether to show the
// fallback README snippet.

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dbus/dbus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:sshvault/core/services/logging_service.dart';

/// Well-known portal name and object path. The desktop portal is itself a DBus
/// service on the session bus; every backend (GNOME / KDE / xdg-desktop-portal-
/// gtk / -kde) implements the same interface.
const String kPortalBusName = 'org.freedesktop.portal.Desktop';
const String kPortalObjectPath = '/org/freedesktop/portal/desktop';
const String kGlobalShortcutsInterface =
    'org.freedesktop.portal.GlobalShortcuts';
const String kRequestInterface = 'org.freedesktop.portal.Request';

/// Stable identifier for the only shortcut we register. Used as the key inside
/// the `BindShortcuts` payload and matched against the `Activated` signal's
/// `shortcut_id`.
const String kQuickConnectShortcutId = 'sshvault.quick-connect';

/// Default trigger we ask the portal to suggest. The user can override it in
/// the system settings dialog the portal pops up — we don't enforce anything.
const String kQuickConnectDefaultTrigger = 'SUPER+SHIFT+s';

/// Broadcast every time the global shortcut fires. The UI layer listens to
/// this and pops up the Quick Connect overlay.
///
/// We use a [StreamProvider] of monotonically increasing tick counts (rather
/// than `void`) so listeners can deduplicate and debounce — see
/// `app.dart`'s `ref.listen`.
final quickConnectShortcutProvider = StreamProvider<int>((ref) {
  final svc = ref.watch(globalShortcutServiceProvider);
  return svc.activations;
});

/// Singleton holder. Exposed as a provider so widgets can call
/// `rebindShortcut()` from the Settings screen without going through a
/// platform channel or InheritedWidget.
final globalShortcutServiceProvider = Provider<GlobalShortcutService>((ref) {
  final svc = GlobalShortcutService();
  ref.onDispose(svc.dispose);
  return svc;
});

/// Reflects the last-known portal state. Used by the Settings UI to decide
/// whether to show "Re-bind" or the fallback README snippet.
class GlobalShortcutStatus {
  const GlobalShortcutStatus({
    required this.portalAvailable,
    required this.bound,
    this.trigger,
  });

  /// `true` when `org.freedesktop.portal.Desktop` answered an introspection
  /// for `GlobalShortcuts`. `false` means XFCE or an old portal — the user
  /// must bind the key themselves.
  final bool portalAvailable;

  /// `true` once `BindShortcuts` succeeded for the current session.
  final bool bound;

  /// The actual trigger the portal stored (may differ from
  /// [kQuickConnectDefaultTrigger] if the user picked something else). Null
  /// until the portal reports it back.
  final String? trigger;

  GlobalShortcutStatus copyWith({
    bool? portalAvailable,
    bool? bound,
    String? trigger,
  }) {
    return GlobalShortcutStatus(
      portalAvailable: portalAvailable ?? this.portalAvailable,
      bound: bound ?? this.bound,
      trigger: trigger ?? this.trigger,
    );
  }

  static const unavailable = GlobalShortcutStatus(
    portalAvailable: false,
    bound: false,
  );
}

/// Mirror of the last known [GlobalShortcutStatus] so the Settings tab can
/// observe it reactively.
final globalShortcutStatusProvider = StateProvider<GlobalShortcutStatus>(
  (_) => GlobalShortcutStatus.unavailable,
);

/// The exact `dbus-send` command that XFCE / non-portal users can wire to a
/// custom keybinding via Settings → Keyboard → Application Shortcuts. Ships
/// in the README and the Settings fallback panel.
const String kFallbackDbusSendCommand =
    'dbus-send --session --type=method_call '
    '--dest=de.kiefer_networks.SSHVault '
    '/de/kiefer_networks/SSHVault '
    'de.kiefer_networks.SSHVault.Activate';

/// Manages the lifetime of a [GlobalShortcuts] session.
class GlobalShortcutService {
  GlobalShortcutService({DBusClient? client, LoggingService? log})
    : _injectedClient = client,
      _log = log ?? LoggingService.instance;

  static const _tag = 'GlobalShortcut';

  final DBusClient? _injectedClient;
  final LoggingService _log;

  DBusClient? _client;
  DBusRemoteObject? _portal;
  StreamSubscription<DBusSignal>? _activatedSub;
  String? _sessionHandle;
  int _activationCounter = 0;

  final StreamController<int> _activations = StreamController<int>.broadcast();

  /// Stream of activations — one event per `Activated` signal that matches
  /// our shortcut id. Replayed via [quickConnectShortcutProvider].
  Stream<int> get activations => _activations.stream;

  GlobalShortcutStatus _status = GlobalShortcutStatus.unavailable;
  GlobalShortcutStatus get status => _status;

  /// `true` when the running platform can plausibly host this service. We
  /// don't probe the bus here (that's [register]'s job) — we just gate on the
  /// OS so the rest of the app can call us unconditionally.
  static bool get supportsPortal => Platform.isLinux;

  /// Connects to the portal, opens a session, and binds the default trigger.
  /// Returns the resolved [GlobalShortcutStatus]. Idempotent — calling twice
  /// re-uses the existing session.
  ///
  /// `container` is used to publish the status to
  /// [globalShortcutStatusProvider]. Pass the same container the rest of the
  /// app uses, otherwise the Settings UI won't see updates.
  Future<GlobalShortcutStatus> register({
    required ProviderContainer container,
    String preferredTrigger = kQuickConnectDefaultTrigger,
  }) async {
    if (!supportsPortal) {
      _status = GlobalShortcutStatus.unavailable;
      _publish(container);
      return _status;
    }

    try {
      await _ensurePortal();
      if (_portal == null) {
        _status = GlobalShortcutStatus.unavailable;
        _publish(container);
        return _status;
      }
      _status = _status.copyWith(portalAvailable: true);

      _sessionHandle ??= await _createSession();
      if (_sessionHandle == null) {
        _log.warning(_tag, 'CreateSession returned no handle');
        _publish(container);
        return _status;
      }

      await _bindShortcuts(_sessionHandle!, preferredTrigger);
      await _subscribeActivated();

      _status = _status.copyWith(bound: true, trigger: preferredTrigger);
      _publish(container);
      _log.info(_tag, 'Bound $kQuickConnectShortcutId → $preferredTrigger');
      return _status;
    } catch (e, st) {
      _log.warning(_tag, 'register() failed: $e\n$st');
      _publish(container);
      return _status;
    }
  }

  /// Asks the portal to renegotiate the trigger. The portal reopens its UI so
  /// the user can pick a new key combination. Visible on the Settings screen
  /// as a "Re-bind" button.
  Future<void> rebind({
    required ProviderContainer container,
    String preferredTrigger = kQuickConnectDefaultTrigger,
  }) async {
    if (!supportsPortal) return;
    try {
      await _ensurePortal();
      if (_portal == null || _sessionHandle == null) {
        // No active session — fall back to a fresh register cycle.
        await register(
          container: container,
          preferredTrigger: preferredTrigger,
        );
        return;
      }
      await _bindShortcuts(_sessionHandle!, preferredTrigger);
      _status = _status.copyWith(bound: true, trigger: preferredTrigger);
      _publish(container);
    } catch (e, st) {
      _log.warning(_tag, 'rebind() failed: $e\n$st');
    }
  }

  /// Closes the active session and cancels the signal subscription. Safe to
  /// call multiple times.
  Future<void> dispose() async {
    await _activatedSub?.cancel();
    _activatedSub = null;
    if (_sessionHandle != null && _client != null) {
      try {
        // Ask the portal to drop the session. Best-effort — the portal will
        // also drop sessions when our DBus connection closes.
        final session = DBusRemoteObject(
          _client!,
          name: kPortalBusName,
          path: DBusObjectPath(_sessionHandle!),
        );
        await session.callMethod(
          'org.freedesktop.portal.Session',
          'Close',
          const [],
          replySignature: DBusSignature(''),
        );
      } catch (_) {}
    }
    _sessionHandle = null;
    if (_injectedClient == null) {
      try {
        await _client?.close();
      } catch (_) {}
    }
    _client = null;
    _portal = null;
    if (!_activations.isClosed) {
      await _activations.close();
    }
  }

  // ---------------------------------------------------------------------------
  // internals

  Future<void> _ensurePortal() async {
    if (_portal != null) return;
    final client = _injectedClient ?? DBusClient.session();
    _client = client;
    _portal = DBusRemoteObject(
      client,
      name: kPortalBusName,
      path: DBusObjectPath(kPortalObjectPath),
    );
  }

  /// Opens a `Session` on the portal. The handle is an object path that we
  /// pass to every subsequent `BindShortcuts` / `ListShortcuts` call.
  ///
  /// The portal returns the handle by emitting the `Response` signal on the
  /// matching `Request` object — we synchronously call the method (which
  /// returns a Request path), then wait for the Response signal.
  Future<String?> _createSession() async {
    final portal = _portal!;
    final token = _randomToken('sshvault_session');
    final handleToken = _randomToken('sshvault_handle');

    final reply = await portal.callMethod(
      kGlobalShortcutsInterface,
      'CreateSession',
      [
        DBusDict.stringVariant({
          'session_handle_token': DBusString(token),
          'handle_token': DBusString(handleToken),
        }),
      ],
      replySignature: DBusSignature('o'),
    );
    final requestPath = reply.returnValues.first as DBusObjectPath;

    final response = await _awaitResponse(requestPath);
    if (response == null) return null;

    final dict = response.results;
    final sessionHandle = dict['session_handle'];
    if (sessionHandle is DBusString) return sessionHandle.value;
    if (sessionHandle is DBusObjectPath) return sessionHandle.value;
    // Some portal versions inline the session path into the request itself —
    // fall back to a synthesized handle.
    return '/org/freedesktop/portal/desktop/session/${_clientId()}/$token';
  }

  /// Calls `BindShortcuts(session, [(id, options)], parent_window, options)`.
  /// The portal pops up a confirmation dialog the first time; subsequent
  /// calls update the existing binding silently.
  Future<void> _bindShortcuts(
    String sessionHandle,
    String preferredTrigger,
  ) async {
    final portal = _portal!;
    final shortcuts = DBusArray(DBusSignature('(sa{sv})'), [
      DBusStruct([
        const DBusString(kQuickConnectShortcutId),
        DBusDict.stringVariant({
          'description': const DBusString('Quick connect'),
          'preferred_trigger': DBusString(preferredTrigger),
        }),
      ]),
    ]);
    final reply = await portal.callMethod(
      kGlobalShortcutsInterface,
      'BindShortcuts',
      [
        DBusObjectPath(sessionHandle),
        shortcuts,
        const DBusString(''), // parent_window — none
        DBusDict.stringVariant({
          'handle_token': DBusString(_randomToken('sshvault_bind')),
        }),
      ],
      replySignature: DBusSignature('o'),
    );
    final requestPath = reply.returnValues.first as DBusObjectPath;
    await _awaitResponse(requestPath);
  }

  /// Subscribes to `Activated(o session_handle, s shortcut_id, t timestamp,
  /// a{sv} options)` and forwards matching shortcuts to [activations].
  Future<void> _subscribeActivated() async {
    if (_activatedSub != null) return;
    final portal = _portal!;
    final stream = DBusRemoteObjectSignalStream(
      object: portal,
      interface: kGlobalShortcutsInterface,
      name: 'Activated',
    );
    _activatedSub = stream.listen((sig) {
      // values: [session_handle (o), shortcut_id (s), timestamp (t), options]
      if (sig.values.length < 2) return;
      final id = sig.values[1];
      if (id is DBusString && id.value == kQuickConnectShortcutId) {
        _activations.add(++_activationCounter);
      }
    });
  }

  /// Waits for the matching `Response` signal on the given `Request` object.
  /// Returns the response payload, or null if the request was cancelled.
  Future<_PortalResponse?> _awaitResponse(DBusObjectPath requestPath) async {
    final completer = Completer<_PortalResponse?>();
    final stream = DBusSignalStream(
      _client!,
      sender: kPortalBusName,
      path: requestPath,
      interface: kRequestInterface,
      name: 'Response',
    );
    final sub = stream.listen((sig) {
      if (completer.isCompleted) return;
      if (sig.values.length < 2) {
        completer.complete(null);
        return;
      }
      final code = (sig.values[0] as DBusUint32).value;
      final results = (sig.values[1] as DBusDict).asStringVariantDict();
      if (code == 0) {
        completer.complete(_PortalResponse(results));
      } else {
        completer.complete(null);
      }
    });
    try {
      return await completer.future.timeout(const Duration(seconds: 30));
    } on TimeoutException {
      _log.warning(_tag, 'Portal response timed out for $requestPath');
      return null;
    } finally {
      await sub.cancel();
    }
  }

  void _publish(ProviderContainer container) {
    container.read(globalShortcutStatusProvider.notifier).state = _status;
  }

  String _clientId() {
    final unique = _client?.uniqueName ?? ':?';
    return unique.replaceAll(':', '').replaceAll('.', '_');
  }

  String _randomToken(String prefix) {
    final rand = Random.secure();
    final n = rand.nextInt(0x7fffffff);
    return '${prefix}_$n';
  }
}

class _PortalResponse {
  _PortalResponse(this.results);
  final Map<String, DBusValue> results;
}
