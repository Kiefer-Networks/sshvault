// Android Home-Screen Widget bridge.
//
// Pairs with the native [QuickConnectWidget] AppWidgetProvider in
// `android/app/src/main/kotlin/de/kiefer_networks/sshvault/QuickConnectWidget.kt`.
//
// Responsibilities:
//   - Listen to `favoriteServersProvider`. When the favorites change, push the
//     top-N entries (defaults to four — the widget grid is 4×1) over the
//     `de.kiefer_networks.sshvault/widget` MethodChannel as a
//     `List<Map<String, Object?>>`.
//   - Kotlin persists the JSON in `SharedPreferences("sshvault_widget",
//     "qc_widget_hosts")` and broadcasts `WIDGET_REFRESH`, which routes back
//     into `QuickConnectWidget.onUpdate` for every active widget instance.
//
// Platform gating: Android only. On every other platform the service is a
// complete no-op so it's safe to call `init` unconditionally from app
// bootstrap. `MissingPluginException` is treated as "the helper isn't wired
// yet" — we log once and stop trying.
//
// Test seam: the [MethodChannel] is reached through the [invoker] field, the
// same pattern used by `JumpListService`. Tests overwrite the field with a
// recorder; production code routes straight to `_defaultInvoke`.
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';

/// One host entry pushed across the channel.
///
/// Encoded as a `Map<String, Object?>` with three keys (`id`, `name`,
/// `hostname`) so the standard Flutter codec carries it without a custom
/// binary codec on the Kotlin side.
@immutable
class WidgetHost {
  /// Stable server id — used to build the `sshvault://host/<id>` deep link.
  final String id;

  /// Visible label shown on the tile when non-empty; otherwise the widget
  /// falls back to [hostname].
  final String name;

  /// Connection hostname; surfaces as the tile fallback label and as the
  /// deep-link target hint.
  final String hostname;

  const WidgetHost({
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
      other is WidgetHost &&
      other.id == id &&
      other.name == name &&
      other.hostname == hostname;

  @override
  int get hashCode => Object.hash(id, name, hostname);
}

/// Singleton service that owns the Android home-screen widget bridge.
class AndroidWidgetService {
  AndroidWidgetService._();
  static final AndroidWidgetService instance = AndroidWidgetService._();

  static const _tag = 'AndroidWidget';

  /// Maximum number of tiles the widget can paint — must stay in sync with
  /// `QuickConnectWidget.MAX_TILES` on the Kotlin side.
  static const int kMaxTiles = 4;

  /// Channel name shared with `MainActivity.kt`.
  static const MethodChannel _channel = MethodChannel(
    'de.kiefer_networks.sshvault/widget',
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

  /// Last hosts pushed to the OS — exposed for testing and to suppress
  /// duplicate channel calls when nothing meaningful changed.
  List<WidgetHost> _lastHosts = const [];
  List<WidgetHost> get lastHosts => List.unmodifiable(_lastHosts);

  /// Wire up provider listeners and push the initial widget state. Safe to
  /// call repeatedly; the second invocation is a no-op. Returns immediately
  /// on non-Android platforms.
  Future<void> init(ProviderContainer container) async {
    if (!_isAndroid) return;
    if (_initialized) return;
    _container = container;

    _favoritesSub = container.listen(
      favoriteServersProvider,
      (_, _) => unawaited(_refresh()),
      fireImmediately: false,
    );

    _initialized = true;
    LoggingService.instance.info(_tag, 'Android widget service initialized');
    await _refresh();
  }

  /// Stop listening to providers. Doesn't clear the persisted JSON — the
  /// widget keeps its last-known content if the app is killed, which matches
  /// user expectations for home-screen widgets.
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _favoritesSub?.close();
  }

  /// Force a rebuild from the current provider state. Public for testing.
  @visibleForTesting
  Future<void> refresh() => _refresh();

  Future<void> _refresh() async {
    if (!_isAndroid || _container == null || _helperUnavailable) return;
    final favorites =
        _container!.read(favoriteServersProvider).value ?? const [];
    await _setHosts(buildHosts(favorites: favorites));
  }

  /// Pure builder used by tests and by [_refresh]. Trims to [kMaxTiles] and
  /// drops servers without a stable id (defensive — should never happen in
  /// production but keeps the channel contract robust).
  static List<WidgetHost> buildHosts({required List<ServerEntity> favorites}) {
    final hosts = <WidgetHost>[];
    for (final server in favorites) {
      if (server.id.isEmpty) continue;
      hosts.add(
        WidgetHost(id: server.id, name: server.name, hostname: server.hostname),
      );
      if (hosts.length >= kMaxTiles) break;
    }
    return hosts;
  }

  Future<void> _setHosts(List<WidgetHost> hosts) async {
    if (_listsEqual(hosts, _lastHosts)) return;
    _lastHosts = List.unmodifiable(hosts);
    try {
      await invoker(
        'setFavorites',
        hosts.map((h) => h.toMap()).toList(growable: false),
      );
    } on MissingPluginException {
      _helperUnavailable = true;
      LoggingService.instance.warning(
        _tag,
        'Android widget helper not registered; setFavorites disabled',
      );
    } catch (e) {
      LoggingService.instance.warning(_tag, 'setFavorites failed: $e');
    }
  }

  /// Test-only reset so each test starts from a clean state.
  @visibleForTesting
  void resetForTest() {
    _favoritesSub?.close();
    _favoritesSub = null;
    _container = null;
    _lastHosts = const [];
    _initialized = false;
    _disposed = false;
    _helperUnavailable = false;
    invoker = _defaultInvoke;
  }

  static bool get _isAndroid {
    // Guard `Platform.isAndroid` behind kIsWeb so the analyzer doesn't think
    // we're trying to read the `dart:io` platform on web (where it throws).
    if (kIsWeb) return false;
    return Platform.isAndroid;
  }

  static bool _listsEqual(List<WidgetHost> a, List<WidgetHost> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
