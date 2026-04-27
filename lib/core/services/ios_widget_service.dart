// iOS Home-Screen + Lock-Screen Widget bridge.
//
// Pairs with the native [QuickConnectWidget] + [LockScreenAccessoryWidget]
// targets bundled in `ios/SshvaultWidget/` (see `SshvaultWidget.swift`).
//
// Responsibilities:
//   - Listen to `favoriteServersProvider` + `recentServersProvider`. When
//     either changes, push a JSON payload over the
//     `de.kiefer_networks.sshvault/ios_widget` MethodChannel that contains
//       * `favorites`: top-N (defaults to eight — the Home Screen
//         systemLarge grid is 4×2) host tiles.
//       * `lastConnected`: { id, name, hostname } or `null`. Used by the
//         `.accessoryInline` Lock Screen complication.
//   - The Swift side writes that JSON into the shared App Group
//     UserDefaults (`group.de.kiefer_networks.sshvault`) under the key
//     `qc_widget_payload` and calls
//     `WidgetCenter.shared.reloadAllTimelines()` so every active widget
//     instance refreshes.
//
// The widget toggle [iosWidgetsEnabledProvider] is a simple Riverpod
// `StateProvider<bool>` that defaults to `true` — flipping it to `false`
// stops the service from pushing further updates. The native side keeps
// the last payload visible (matches macOS / Android widget behavior on
// app removal).
//
// Platform gating: iOS only. On every other platform the service is a
// complete no-op so it's safe to call `init` unconditionally from app
// bootstrap. `MissingPluginException` is treated as "the helper isn't
// wired yet" — we log once and stop trying.
//
// Test seam: the [MethodChannel] is reached through the [invoker] field,
// the same pattern used by `AndroidWidgetService` and `JumpListService`.
// Tests overwrite the field with a recorder; production code routes
// straight to `_defaultInvoke`.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';

/// User-facing toggle surfaced under Settings → Appearance as
/// "Show widgets". Defaults to `true` on iOS 14+ (Home Screen widget) /
/// iOS 16+ (Lock Screen complication).
///
/// Lives outside the main `AppSettingsEntity` / DAO on purpose: the widget
/// extension is iOS-specific and the rest of the app never reads this
/// flag. Persisting it to SharedPreferences is left to a follow-up if the
/// surrounding settings UI grows a generic boolean DAO row — for now the
/// in-memory default is fine since installing the widget itself is also a
/// per-launch user action via the iOS widget gallery.
final iosWidgetsEnabledProvider = StateProvider<bool>((ref) => true);

/// One host entry pushed across the channel.
///
/// Encoded as a `Map<String, Object?>` with three keys (`id`, `name`,
/// `hostname`) so the standard Flutter codec carries it without a custom
/// binary codec on the Swift side.
@immutable
class IosWidgetHost {
  /// Stable server id — used to build the `sshvault://host/<id>` deep
  /// link the widget tile invokes via `Link(URL(...))`.
  final String id;

  /// Visible label shown on the tile when non-empty; otherwise the
  /// widget falls back to [hostname].
  final String name;

  /// Connection hostname; surfaces as the tile fallback label and as
  /// the deep-link target hint.
  final String hostname;

  const IosWidgetHost({
    required this.id,
    required this.name,
    required this.hostname,
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'hostname': hostname,
  };

  @override
  bool operator ==(Object other) =>
      other is IosWidgetHost &&
      other.id == id &&
      other.name == name &&
      other.hostname == hostname;

  @override
  int get hashCode => Object.hash(id, name, hostname);
}

/// Singleton service that owns the iOS widget bridge.
class IosWidgetService {
  IosWidgetService._();
  static final IosWidgetService instance = IosWidgetService._();

  static const _tag = 'IosWidget';

  /// Maximum number of tiles the Home-Screen `systemLarge` widget can
  /// paint — must stay in sync with `QuickConnectWidget.maxTiles` on the
  /// Swift side. systemSmall renders 1, systemMedium 4, systemLarge 8.
  static const int kMaxTiles = 8;

  /// Channel name shared with `AppDelegate.swift`.
  static const MethodChannel _channel = MethodChannel(
    'de.kiefer_networks.sshvault/ios_widget',
  );

  /// Test seam — overridden by tests so we can assert which method was
  /// invoked with which payload without spinning up the full
  /// `TestDefaultBinaryMessengerBinding` mock messenger machinery.
  @visibleForTesting
  Future<Object?> Function(String method, Object? args) invoker =
      _defaultInvoke;

  static Future<Object?> _defaultInvoke(String method, Object? args) {
    return _channel.invokeMethod(method, args);
  }

  bool _initialized = false;
  bool _disposed = false;
  bool _helperUnavailable = false;

  ProviderContainer? _container;
  ProviderSubscription? _favoritesSub;
  ProviderSubscription? _recentsSub;
  ProviderSubscription? _enabledSub;

  /// Last payload pushed to the OS — exposed for testing and to suppress
  /// duplicate channel calls when nothing meaningful changed.
  String _lastPayloadJson = '';
  String get lastPayloadJson => _lastPayloadJson;

  /// Wire up provider listeners and push the initial widget state. Safe
  /// to call repeatedly; the second invocation is a no-op. Returns
  /// immediately on non-iOS platforms.
  Future<void> init(ProviderContainer container) async {
    if (!_isIos) return;
    if (_initialized) return;
    _container = container;

    _favoritesSub = container.listen(
      favoriteServersProvider,
      (_, _) => unawaited(_refresh()),
      fireImmediately: false,
    );
    _recentsSub = container.listen(
      recentServersProvider,
      (_, _) => unawaited(_refresh()),
      fireImmediately: false,
    );
    _enabledSub = container.listen(
      iosWidgetsEnabledProvider,
      (_, _) => unawaited(_refresh()),
      fireImmediately: false,
    );

    _initialized = true;
    LoggingService.instance.info(_tag, 'iOS widget service initialized');
    await _refresh();
  }

  /// Stop listening to providers. Doesn't clear the persisted JSON — the
  /// widget keeps its last-known content if the app is killed, which
  /// matches user expectations for home-screen widgets.
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _favoritesSub?.close();
    _recentsSub?.close();
    _enabledSub?.close();
  }

  /// Force a rebuild from the current provider state. Public for testing.
  @visibleForTesting
  Future<void> refresh() => _refresh();

  Future<void> _refresh() async {
    if (!_isIos || _container == null || _helperUnavailable) return;
    final enabled = _container!.read(iosWidgetsEnabledProvider);
    if (!enabled) {
      // Push an empty payload so the widget renders the "not configured"
      // placeholder. Stops short of a separate `clearFavorites` channel
      // method to keep the API surface small.
      await _setPayloadJson(_encode(const [], null));
      return;
    }
    final favorites =
        _container!.read(favoriteServersProvider).value ?? const [];
    final recents = _container!.read(recentServersProvider).value ?? const [];
    final hosts = buildHosts(favorites: favorites);
    final lastConnected = pickLastConnected(recents);
    await _setPayloadJson(_encode(hosts, lastConnected));
  }

  /// Pure builder used by tests and by [_refresh]. Trims to [kMaxTiles]
  /// and drops servers without a stable id (defensive — should never
  /// happen in production but keeps the channel contract robust).
  static List<IosWidgetHost> buildHosts({
    required List<ServerEntity> favorites,
  }) {
    final hosts = <IosWidgetHost>[];
    for (final server in favorites) {
      if (server.id.isEmpty) continue;
      hosts.add(
        IosWidgetHost(
          id: server.id,
          name: server.name,
          hostname: server.hostname,
        ),
      );
      if (hosts.length >= kMaxTiles) break;
    }
    return hosts;
  }

  /// Picks the most-recent server for the `.accessoryInline` Lock Screen
  /// complication. `recents` is expected to already be sorted by
  /// `lastConnectedAt DESC` upstream — we just take the first valid
  /// entry. Returns `null` if there is no recent server, in which case
  /// the complication renders the placeholder text.
  static IosWidgetHost? pickLastConnected(List<ServerEntity> recents) {
    for (final server in recents) {
      if (server.id.isEmpty) continue;
      return IosWidgetHost(
        id: server.id,
        name: server.name,
        hostname: server.hostname,
      );
    }
    return null;
  }

  /// Builds the JSON payload the Swift side reads from the App Group's
  /// shared `UserDefaults`. Public for tests.
  @visibleForTesting
  static String encode(
    List<IosWidgetHost> favorites,
    IosWidgetHost? lastConnected,
  ) => _encode(favorites, lastConnected);

  static String _encode(
    List<IosWidgetHost> favorites,
    IosWidgetHost? lastConnected,
  ) {
    return jsonEncode({
      'favorites': favorites.map((h) => h.toMap()).toList(growable: false),
      'lastConnected': lastConnected?.toMap(),
    });
  }

  Future<void> _setPayloadJson(String payload) async {
    if (payload == _lastPayloadJson) return;
    _lastPayloadJson = payload;
    try {
      await invoker('setFavorites', payload);
    } on MissingPluginException {
      _helperUnavailable = true;
      LoggingService.instance.warning(
        _tag,
        'iOS widget helper not registered; setFavorites disabled',
      );
    } catch (e) {
      LoggingService.instance.warning(_tag, 'setFavorites failed: $e');
    }
  }

  /// Test-only reset so each test starts from a clean state.
  @visibleForTesting
  void resetForTest() {
    _favoritesSub?.close();
    _recentsSub?.close();
    _enabledSub?.close();
    _favoritesSub = null;
    _recentsSub = null;
    _enabledSub = null;
    _container = null;
    _lastPayloadJson = '';
    _initialized = false;
    _disposed = false;
    _helperUnavailable = false;
    invoker = _defaultInvoke;
  }

  static bool get _isIos {
    // Guard `Platform.isIOS` behind kIsWeb so the analyzer doesn't think
    // we're trying to read the `dart:io` platform on web (where it
    // throws).
    if (kIsWeb) return false;
    return Platform.isIOS;
  }
}
