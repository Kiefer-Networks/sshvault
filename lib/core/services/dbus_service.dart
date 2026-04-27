// Linux-only DBus integration for SSHVault.
//
// Provides:
//   * Single-instance enforcement: when a second `sshvault` process starts, it
//     forwards its argv to the first instance via DBus and exits cleanly.
//   * External triggers: KRunner, Rofi, Polybar (and any other client) can call
//     `de.kiefer_networks.SSHVault.Connect(host_id)` /
//     `Disconnect(session_id)` / `OpenUrl(ssh://...)` / `Activate()`.
//   * Signals: `SessionStarted(host_id, session_id)` and
//     `SessionEnded(session_id)` are broadcast on session state changes so other
//     desktop integrations can subscribe (e.g. notifiers, taskbars).
//   * `org.freedesktop.Application` (Activate / Open / ActivateAction) at
//     `/de/kiefer_networks/sshvault` so the .desktop file's
//     `DBusActivatable=true` and `Actions=` entries route into the running app.
//
// On non-Linux platforms every public entrypoint is a cheap no-op so the rest
// of the app does not need to special-case the platform.

import 'dart:async';
import 'dart:io';

import 'package:dbus/dbus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:sshvault/features/terminal/presentation/providers/session_history_provider.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

/// Well-known service name owned by the first running SSHVault instance.
const String kSshVaultBusName = 'de.kiefer_networks.SSHVault';

/// Object path that hosts the [kSshVaultInterface] interface.
const String kSshVaultObjectPath = '/de/kiefer_networks/SSHVault';

/// DBus interface name implemented by [_SshVaultDBusObject].
const String kSshVaultInterface = 'de.kiefer_networks.SSHVault';

/// Object path for the freedesktop `org.freedesktop.Application` interface.
///
/// Per the spec the path is derived from the desktop-file id by replacing
/// dots with slashes. The desktop file ships in lower-case
/// (`de.kiefer_networks.sshvault.desktop`), so the activation path the
/// launcher expects is `/de/kiefer_networks/sshvault` — distinct from our
/// custom service path which uses CamelCase (`/de/kiefer_networks/SSHVault`).
const String kFreedesktopApplicationPath = '/de/kiefer_networks/sshvault';

/// `org.freedesktop.Application` interface name.
const String kFreedesktopApplicationInterface = 'org.freedesktop.Application';

/// Action ids declared in the .desktop file's `Actions=` line. Centralised
/// so the DBus service, UI code, and tests share a single source of truth.
abstract final class SshVaultDesktopActions {
  static const String newConnection = 'NewConnection';
  static const String reopenLast = 'ReopenLast';
  static const String quit = 'Quit';
}

/// Result of trying to acquire the well-known bus name.
enum DBusBootstrapResult {
  /// We acquired [kSshVaultBusName] — we are the primary instance and have
  /// exported the service object.
  primaryOwner,

  /// Another instance already owns the name. We forwarded argv to it and the
  /// caller should exit cleanly without invoking `runApp`.
  forwardedToExisting,

  /// DBus is unavailable, the platform is not Linux, or initialization failed.
  /// The caller should continue booting normally with no DBus integration.
  unavailable,
}

/// Bootstraps DBus before Flutter starts.
///
/// Call this from `main()` before `runApp`. If this returns
/// [DBusBootstrapResult.forwardedToExisting] the calling process MUST exit
/// without showing UI.
///
/// [argv] is the command-line arguments forwarded to the existing instance via
/// `OpenUrl`. The first ssh:// argument (if any) is sent; otherwise the call
/// is `Activate()` to raise the existing window.
Future<DBusBootstrapResult> bootstrapSshVaultDBus({
  required List<String> argv,
}) async {
  if (!Platform.isLinux) return DBusBootstrapResult.unavailable;

  final log = LoggingService.instance;
  DBusClient? client;
  try {
    client = DBusClient.session();
    final reply = await client.requestName(kSshVaultBusName);
    switch (reply) {
      case DBusRequestNameReply.primaryOwner:
      case DBusRequestNameReply.alreadyOwner:
        log.info('DBus', 'Acquired $kSshVaultBusName ($reply)');
        // We become the primary owner. The actual service object is registered
        // later by [SshVaultDBusService.attach] once we have a ProviderContainer.
        await client.close();
        return DBusBootstrapResult.primaryOwner;
      case DBusRequestNameReply.exists:
      case DBusRequestNameReply.inQueue:
        log.info(
          'DBus',
          'Existing instance owns $kSshVaultBusName, forwarding argv',
        );
        await _forwardArgvToExistingInstance(client, argv);
        await client.close();
        return DBusBootstrapResult.forwardedToExisting;
    }
  } catch (e, st) {
    log.warning('DBus', 'Bootstrap failed (continuing without DBus): $e\n$st');
    try {
      await client?.close();
    } catch (_) {}
    return DBusBootstrapResult.unavailable;
  }
}

/// Picks the first ssh:// URL from [argv] and sends it to the running
/// instance via [kSshVaultInterface].OpenUrl. Falls back to Activate() when no
/// URL is present.
Future<void> _forwardArgvToExistingInstance(
  DBusClient client,
  List<String> argv,
) async {
  final remote = DBusRemoteObject(
    client,
    name: kSshVaultBusName,
    path: DBusObjectPath(kSshVaultObjectPath),
  );

  String? sshUrl;
  for (final a in argv) {
    if (a.startsWith('ssh://') || a.startsWith('sshvault://')) {
      sshUrl = a;
      break;
    }
  }

  if (sshUrl != null) {
    await remote.callMethod(kSshVaultInterface, 'OpenUrl', [
      DBusString(sshUrl),
    ], replySignature: DBusSignature(''));
  } else {
    await remote.callMethod(
      kSshVaultInterface,
      'Activate',
      const [],
      replySignature: DBusSignature(''),
    );
  }
}

/// Sends a fire-and-forget `Quit` to the running primary instance. Returns
/// `true` if the call succeeded, `false` if no instance is reachable or the
/// call failed. Safe to call from any process — does not require us to own
/// the bus name.
Future<bool> sendDBusQuit() async {
  if (!Platform.isLinux) return false;
  final log = LoggingService.instance;
  DBusClient? client;
  try {
    client = DBusClient.session();
    final remote = DBusRemoteObject(
      client,
      name: kSshVaultBusName,
      path: DBusObjectPath(kSshVaultObjectPath),
    );
    await remote.callMethod(
      kSshVaultInterface,
      'Quit',
      const [],
      replySignature: DBusSignature(''),
    );
    return true;
  } catch (e) {
    log.warning('DBus', 'Quit RPC failed: $e');
    return false;
  } finally {
    try {
      await client?.close();
    } catch (_) {}
  }
}

/// Service exposed once the primary instance has finished booting and a
/// [ProviderContainer] is available.
///
/// Wires DBus method calls to provider mutations (`sessionManagerProvider`)
/// and listens to session state to emit `SessionStarted`/`SessionEnded`
/// signals.
class SshVaultDBusService {
  SshVaultDBusService._({
    required DBusClient client,
    required _SshVaultDBusObject object,
    required _FreedesktopApplicationObject appObject,
    required ProviderContainer container,
  }) : _client = client,
       _object = object,
       _appObject = appObject,
       _container = container;

  final DBusClient _client;
  final _SshVaultDBusObject _object;
  final _FreedesktopApplicationObject _appObject;
  final ProviderContainer _container;

  ProviderSubscription<List<SshSessionEntity>>? _sessionsSubscription;
  // Tracks last seen session ids so we can diff added/removed entries.
  final Set<String> _knownSessionIds = <String>{};
  // Tracks session id -> server id for SessionEnded payloads.
  final Map<String, String> _sessionHostMap = <String, String>{};

  // Activation callback (raise the window). Provided by main.dart.
  void Function()? _onActivate;
  // Quit callback (terminate the running instance). Provided by main.dart.
  void Function()? _onQuit;
  // Routes `ActivateAction("NewConnection")` to a fresh /server/new screen.
  void Function()? _onNewConnection;
  // Routes `ActivateAction("ReopenLast")` to the last-active session. When
  // unset the service falls back to its own [sessionHistoryProvider] read.
  void Function()? _onReopenLast;

  /// Acquires the bus name (if not already owned), exports the service object,
  /// and starts listening to provider state.
  ///
  /// Returns `null` on platforms without DBus or if registration fails. The
  /// caller can ignore that — the rest of the app keeps working without DBus.
  static Future<SshVaultDBusService?> attach({
    required ProviderContainer container,
    void Function()? onActivate,
    void Function(String url)? onOpenUrl,
    void Function()? onQuit,
    void Function()? onNewConnection,
    void Function()? onReopenLast,
  }) async {
    if (!Platform.isLinux) return null;

    final log = LoggingService.instance;
    DBusClient? client;
    try {
      client = DBusClient.session();
      // We may or may not still own the name (bootstrap closed the previous
      // client). Re-request to be safe.
      final reply = await client.requestName(kSshVaultBusName);
      if (reply != DBusRequestNameReply.primaryOwner &&
          reply != DBusRequestNameReply.alreadyOwner) {
        log.warning(
          'DBus',
          'Could not become primary owner during attach: $reply',
        );
        await client.close();
        return null;
      }

      final object = _SshVaultDBusObject(
        path: DBusObjectPath(kSshVaultObjectPath),
      );
      final appObject = _FreedesktopApplicationObject(
        path: DBusObjectPath(kFreedesktopApplicationPath),
      );

      final service = SshVaultDBusService._(
        client: client,
        object: object,
        appObject: appObject,
        container: container,
      );
      service._onActivate = onActivate;
      service._onQuit = onQuit;
      service._onNewConnection = onNewConnection;
      service._onReopenLast = onReopenLast;
      object._service = service;
      object._onOpenUrl = onOpenUrl;
      appObject._service = service;
      appObject._onOpenUrl = onOpenUrl;

      await client.registerObject(object);
      await client.registerObject(appObject);
      service._startListening();

      log.info(
        'DBus',
        'Service registered at $kSshVaultObjectPath and '
            '$kFreedesktopApplicationPath',
      );
      return service;
    } catch (e, st) {
      log.warning('DBus', 'Attach failed: $e\n$st');
      try {
        await client?.close();
      } catch (_) {}
      return null;
    }
  }

  /// Cleans up the service (used in tests or app shutdown).
  Future<void> dispose() async {
    _sessionsSubscription?.close();
    _sessionsSubscription = null;
    try {
      await _client.unregisterObject(_object);
    } catch (_) {}
    try {
      await _client.unregisterObject(_appObject);
    } catch (_) {}
    try {
      await _client.releaseName(kSshVaultBusName);
    } catch (_) {}
    await _client.close();
  }

  // --- Method handlers ------------------------------------------------------

  Future<void> handleConnect(String hostId) async {
    if (hostId.isEmpty) {
      throw ArgumentError('host_id must not be empty');
    }
    LoggingService.instance.info('DBus', 'Connect($hostId)');
    await _container.read(sessionManagerProvider.notifier).openSession(hostId);
    // Record for ActivateAction("ReopenLast"). The session-listener also
    // mirrors this, but recording here covers the case where openSession
    // returns synchronously without a state diff (already-open session).
    _container.read(sessionHistoryProvider.notifier).recordHost(hostId);
  }

  Future<void> handleDisconnect(String sessionId) async {
    if (sessionId.isEmpty) {
      throw ArgumentError('session_id must not be empty');
    }
    LoggingService.instance.info('DBus', 'Disconnect($sessionId)');
    _container.read(sessionManagerProvider.notifier).closeSession(sessionId);
  }

  Future<List<List<String>>> handleListHosts() async {
    final asyncServers = _container.read(serverListProvider);
    final servers = asyncServers.maybeWhen(
      data: (s) => s,
      orElse: () => const <ServerEntity>[],
    );
    return servers
        .map((s) => <String>[s.id, s.name, s.hostname, s.username])
        .toList();
  }

  Future<List<List<String>>> handleListSessions() async {
    final sessions = _container.read(sessionManagerProvider);
    return sessions
        .map((s) => <String>[s.id, s.serverId, s.title, s.status.name])
        .toList();
  }

  Future<void> handleOpenUrl(String url, {void Function(String)? sink}) async {
    LoggingService.instance.info('DBus', 'OpenUrl($url)');
    if (sink != null) {
      sink(url);
      return;
    }
    // Default behavior: parse ssh:// host portion and try to find a server with
    // a matching hostname. If no match, attempt to treat [url] as a host id.
    final parsed = Uri.tryParse(url);
    if (parsed == null) return;
    final hostFragment = parsed.host;
    final asyncServers = _container.read(serverListProvider);
    final servers = asyncServers.maybeWhen(
      data: (s) => s,
      orElse: () => const <ServerEntity>[],
    );
    final match = servers.where(
      (s) => s.hostname == hostFragment || s.id == hostFragment,
    );
    if (match.isNotEmpty) {
      await handleConnect(match.first.id);
    }
  }

  void handleActivate() {
    LoggingService.instance.info('DBus', 'Activate');
    _onActivate?.call();
  }

  void handleQuit() {
    LoggingService.instance.info('DBus', 'Quit');
    final cb = _onQuit;
    if (cb != null) {
      cb();
    } else {
      // No callback wired (headless test or early shutdown). Exit hard.
      // ignore: avoid_print
      Future.microtask(() => exit(0));
    }
  }

  /// Implements `org.freedesktop.Application.Open`.
  ///
  /// Each URI is dispatched through [handleOpenUrl] (so ssh:// / sftp://
  /// land in the existing routing logic). `platformData` is accepted for
  /// spec compliance but unused — it's a desktop-environment payload, not
  /// a routing hint. A failure on one URI does not abort the rest.
  Future<void> handleOpen(
    List<String> uris,
    Map<String, DBusValue> platformData, {
    void Function(String)? sink,
  }) async {
    LoggingService.instance.info(
      'DBus',
      'Open(${uris.length} URI(s), platform_data=${platformData.length})',
    );
    for (final uri in uris) {
      try {
        await handleOpenUrl(uri, sink: sink);
      } catch (e, st) {
        LoggingService.instance.warning(
          'DBus',
          'Open(uri=$uri) failed: $e\n$st',
        );
      }
    }
  }

  /// Implements `org.freedesktop.Application.ActivateAction`.
  ///
  /// Routes the action id (matching one of the .desktop file's
  /// `[Desktop Action ...]` blocks) to the wired callback or — for
  /// `ReopenLast` — to a fallback that re-opens the host recorded in the
  /// in-memory [sessionHistoryProvider].
  ///
  /// `params` is currently unused — none of our actions take parameters.
  /// `platformData` is also unused (see [handleOpen]).
  Future<void> handleActivateAction(
    String actionName,
    List<DBusValue> params,
    Map<String, DBusValue> platformData,
  ) async {
    LoggingService.instance.info(
      'DBus',
      'ActivateAction($actionName, params=${params.length})',
    );
    switch (actionName) {
      case SshVaultDesktopActions.newConnection:
        // Bring the window forward first so the form is visible.
        _onActivate?.call();
        _onNewConnection?.call();
        break;
      case SshVaultDesktopActions.reopenLast:
        _onActivate?.call();
        if (_onReopenLast != null) {
          _onReopenLast!.call();
          break;
        }
        // Fallback: re-open the host recorded in our in-memory tracker.
        final hostId = _container.read(sessionHistoryProvider);
        if (hostId != null && hostId.isNotEmpty) {
          await handleConnect(hostId);
        } else {
          LoggingService.instance.info(
            'DBus',
            'ReopenLast: no last-active host on record',
          );
        }
        break;
      case SshVaultDesktopActions.quit:
        handleQuit();
        break;
      default:
        LoggingService.instance.warning(
          'DBus',
          'ActivateAction: unknown action "$actionName"',
        );
    }
  }

  // --- Signals --------------------------------------------------------------

  void _startListening() {
    _sessionsSubscription = _container.listen<List<SshSessionEntity>>(
      sessionManagerProvider,
      (prev, next) => _diffAndEmit(next),
      fireImmediately: true,
    );
  }

  void _diffAndEmit(List<SshSessionEntity> sessions) {
    final currentIds = sessions.map((s) => s.id).toSet();

    // Newly created sessions → SessionStarted
    for (final s in sessions) {
      if (!_knownSessionIds.contains(s.id)) {
        _knownSessionIds.add(s.id);
        _sessionHostMap[s.id] = s.serverId;
        // Mirror into the session-history provider so `ReopenLast` can fall
        // back to it without an extra subscription on the consumer side.
        _container.read(sessionHistoryProvider.notifier).recordHost(s.serverId);
        emitSessionStarted(hostId: s.serverId, sessionId: s.id);
      }
    }

    // Removed sessions → SessionEnded
    final removed = _knownSessionIds.difference(currentIds);
    for (final id in removed) {
      _knownSessionIds.remove(id);
      _sessionHostMap.remove(id);
      emitSessionEnded(sessionId: id);
    }
  }

  /// Visible for tests.
  Future<void> emitSessionStarted({
    required String hostId,
    required String sessionId,
  }) async {
    await _object.emitSignal(kSshVaultInterface, 'SessionStarted', [
      DBusString(hostId),
      DBusString(sessionId),
    ]);
  }

  /// Visible for tests.
  Future<void> emitSessionEnded({required String sessionId}) async {
    await _object.emitSignal(kSshVaultInterface, 'SessionEnded', [
      DBusString(sessionId),
    ]);
  }

  /// Visible for tests.
  Future<void> emitNotified(String message) async {
    await _object.emitSignal(kSshVaultInterface, 'Notified', [
      DBusString(message),
    ]);
  }
}

/// The exported DBus object that delegates method calls to
/// [SshVaultDBusService].
class _SshVaultDBusObject extends DBusObject {
  _SshVaultDBusObject({required DBusObjectPath path}) : super(path);

  SshVaultDBusService? _service;
  void Function(String url)? _onOpenUrl;

  @override
  List<DBusIntrospectInterface> introspect() {
    return [
      DBusIntrospectInterface(
        kSshVaultInterface,
        methods: [
          DBusIntrospectMethod(
            'Connect',
            args: [
              DBusIntrospectArgument(
                DBusSignature('s'),
                DBusArgumentDirection.in_,
                name: 'host_id',
              ),
            ],
          ),
          DBusIntrospectMethod(
            'Disconnect',
            args: [
              DBusIntrospectArgument(
                DBusSignature('s'),
                DBusArgumentDirection.in_,
                name: 'session_id',
              ),
            ],
          ),
          DBusIntrospectMethod(
            'ListHosts',
            args: [
              DBusIntrospectArgument(
                DBusSignature('a(ssss)'),
                DBusArgumentDirection.out,
                name: 'hosts',
              ),
            ],
          ),
          DBusIntrospectMethod(
            'ListSessions',
            args: [
              DBusIntrospectArgument(
                DBusSignature('a(ssss)'),
                DBusArgumentDirection.out,
                name: 'sessions',
              ),
            ],
          ),
          DBusIntrospectMethod(
            'OpenUrl',
            args: [
              DBusIntrospectArgument(
                DBusSignature('s'),
                DBusArgumentDirection.in_,
                name: 'url',
              ),
            ],
          ),
          DBusIntrospectMethod('Activate'),
          DBusIntrospectMethod('Quit'),
        ],
        signals: [
          DBusIntrospectSignal(
            'SessionStarted',
            args: [
              DBusIntrospectArgument(
                DBusSignature('s'),
                DBusArgumentDirection.out,
                name: 'host_id',
              ),
              DBusIntrospectArgument(
                DBusSignature('s'),
                DBusArgumentDirection.out,
                name: 'session_id',
              ),
            ],
          ),
          DBusIntrospectSignal(
            'SessionEnded',
            args: [
              DBusIntrospectArgument(
                DBusSignature('s'),
                DBusArgumentDirection.out,
                name: 'session_id',
              ),
            ],
          ),
          DBusIntrospectSignal(
            'Notified',
            args: [
              DBusIntrospectArgument(
                DBusSignature('s'),
                DBusArgumentDirection.out,
                name: 'message',
              ),
            ],
          ),
        ],
      ),
    ];
  }

  @override
  Future<DBusMethodResponse> handleMethodCall(DBusMethodCall methodCall) async {
    if (methodCall.interface != kSshVaultInterface) {
      return DBusMethodErrorResponse.unknownInterface();
    }
    final svc = _service;
    if (svc == null) {
      return DBusMethodErrorResponse.failed('Service not yet initialized');
    }

    try {
      switch (methodCall.name) {
        case 'Connect':
          final id = methodCall.values.isEmpty
              ? ''
              : (methodCall.values.first as DBusString).value;
          await svc.handleConnect(id);
          return DBusMethodSuccessResponse();
        case 'Disconnect':
          final id = methodCall.values.isEmpty
              ? ''
              : (methodCall.values.first as DBusString).value;
          await svc.handleDisconnect(id);
          return DBusMethodSuccessResponse();
        case 'ListHosts':
          final hosts = await svc.handleListHosts();
          return DBusMethodSuccessResponse([
            DBusArray(
              DBusSignature('(ssss)'),
              hosts.map(
                (row) => DBusStruct([
                  DBusString(row[0]),
                  DBusString(row[1]),
                  DBusString(row[2]),
                  DBusString(row[3]),
                ]),
              ),
            ),
          ]);
        case 'ListSessions':
          final sessions = await svc.handleListSessions();
          return DBusMethodSuccessResponse([
            DBusArray(
              DBusSignature('(ssss)'),
              sessions.map(
                (row) => DBusStruct([
                  DBusString(row[0]),
                  DBusString(row[1]),
                  DBusString(row[2]),
                  DBusString(row[3]),
                ]),
              ),
            ),
          ]);
        case 'OpenUrl':
          final url = methodCall.values.isEmpty
              ? ''
              : (methodCall.values.first as DBusString).value;
          await svc.handleOpenUrl(url, sink: _onOpenUrl);
          return DBusMethodSuccessResponse();
        case 'Activate':
          svc.handleActivate();
          return DBusMethodSuccessResponse();
        case 'Quit':
          svc.handleQuit();
          return DBusMethodSuccessResponse();
        default:
          return DBusMethodErrorResponse.unknownMethod();
      }
    } on ArgumentError catch (e) {
      return DBusMethodErrorResponse.invalidArgs(e.message?.toString() ?? '');
    } catch (e) {
      return DBusMethodErrorResponse.failed(e.toString());
    }
  }
}

/// Implements `org.freedesktop.Application` at [kFreedesktopApplicationPath].
///
/// Required for `DBusActivatable=true` in the .desktop file: launchers (GNOME
/// Shell, KDE Plasma, gtk-launch, …) call this interface to start the app or
/// route Actions= entries instead of forking a new process.
///
/// We register this as a separate `DBusObject` because the spec mandates a
/// path derived from the desktop-file id (`/de/kiefer_networks/sshvault`),
/// which is distinct from our custom service path
/// (`/de/kiefer_networks/SSHVault`).
class _FreedesktopApplicationObject extends DBusObject {
  _FreedesktopApplicationObject({required DBusObjectPath path}) : super(path);

  SshVaultDBusService? _service;
  void Function(String url)? _onOpenUrl;

  @override
  List<DBusIntrospectInterface> introspect() {
    return [
      DBusIntrospectInterface(
        kFreedesktopApplicationInterface,
        methods: [
          DBusIntrospectMethod(
            'Activate',
            args: [
              DBusIntrospectArgument(
                DBusSignature('a{sv}'),
                DBusArgumentDirection.in_,
                name: 'platform_data',
              ),
            ],
          ),
          DBusIntrospectMethod(
            'Open',
            args: [
              DBusIntrospectArgument(
                DBusSignature('as'),
                DBusArgumentDirection.in_,
                name: 'uris',
              ),
              DBusIntrospectArgument(
                DBusSignature('a{sv}'),
                DBusArgumentDirection.in_,
                name: 'platform_data',
              ),
            ],
          ),
          DBusIntrospectMethod(
            'ActivateAction',
            args: [
              DBusIntrospectArgument(
                DBusSignature('s'),
                DBusArgumentDirection.in_,
                name: 'action_name',
              ),
              DBusIntrospectArgument(
                DBusSignature('av'),
                DBusArgumentDirection.in_,
                name: 'parameter',
              ),
              DBusIntrospectArgument(
                DBusSignature('a{sv}'),
                DBusArgumentDirection.in_,
                name: 'platform_data',
              ),
            ],
          ),
        ],
      ),
    ];
  }

  @override
  Future<DBusMethodResponse> handleMethodCall(DBusMethodCall methodCall) async {
    if (methodCall.interface != kFreedesktopApplicationInterface) {
      return DBusMethodErrorResponse.unknownInterface();
    }
    final svc = _service;
    if (svc == null) {
      return DBusMethodErrorResponse.failed('Service not yet initialized');
    }

    try {
      switch (methodCall.name) {
        case 'Activate':
          // Signature: a{sv} platform_data — we accept it for spec
          // compliance but ignore the dict.
          svc.handleActivate();
          return DBusMethodSuccessResponse();
        case 'Open':
          // Signature: as uris, a{sv} platform_data.
          final uris = coerceDBusStringArray(
            methodCall.values.elementAtOrNull(0),
          );
          final platformData = coerceDBusStringVariantDict(
            methodCall.values.elementAtOrNull(1),
          );
          await svc.handleOpen(uris, platformData, sink: _onOpenUrl);
          return DBusMethodSuccessResponse();
        case 'ActivateAction':
          // Signature: s action_name, av parameter, a{sv} platform_data.
          final actionName = methodCall.values.isEmpty
              ? ''
              : (methodCall.values.first as DBusString).value;
          final params = coerceDBusVariantArray(
            methodCall.values.elementAtOrNull(1),
          );
          final platformData = coerceDBusStringVariantDict(
            methodCall.values.elementAtOrNull(2),
          );
          await svc.handleActivateAction(actionName, params, platformData);
          return DBusMethodSuccessResponse();
        default:
          return DBusMethodErrorResponse.unknownMethod();
      }
    } on ArgumentError catch (e) {
      return DBusMethodErrorResponse.invalidArgs(e.message?.toString() ?? '');
    } catch (e) {
      return DBusMethodErrorResponse.failed(e.toString());
    }
  }
}

// ---------------------------------------------------------------------------
// Argument coercion helpers — top-level + visible for tests so we can
// exercise them without spinning up a real bus.
// ---------------------------------------------------------------------------

/// Coerces a `DBusArray` of strings (`as`) into `List<String>`. Returns an
/// empty list when the value is null or has the wrong shape.
List<String> coerceDBusStringArray(DBusValue? value) {
  if (value is DBusArray) {
    return value.children.whereType<DBusString>().map((s) => s.value).toList();
  }
  return const <String>[];
}

/// Coerces a `DBusArray` of variants (`av`) into `List<DBusValue>` where each
/// entry is the variant's inner value. Returns an empty list on shape
/// mismatch.
List<DBusValue> coerceDBusVariantArray(DBusValue? value) {
  if (value is DBusArray) {
    return value.children.map((c) => c is DBusVariant ? c.value : c).toList();
  }
  return const <DBusValue>[];
}

/// Coerces a `DBusDict` keyed by strings holding variants (`a{sv}`) into a
/// plain Dart map. Returns an empty map on shape mismatch.
Map<String, DBusValue> coerceDBusStringVariantDict(DBusValue? value) {
  if (value is DBusDict) {
    final result = <String, DBusValue>{};
    value.children.forEach((k, v) {
      if (k is DBusString) {
        result[k.value] = v is DBusVariant ? v.value : v;
      }
    });
    return result;
  }
  return const <String, DBusValue>{};
}
