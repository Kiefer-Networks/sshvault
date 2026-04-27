// Android App Shortcuts integration for SSHVault.
//
// On Android, long-pressing the launcher icon pops a small menu of "App
// Shortcuts". SSHVault ships three static entries (quick connect, add host,
// reopen last) declared in `android/app/src/main/res/xml/shortcuts.xml`, and
// up to four dynamic entries — one per favorite host — pushed at runtime via
// the `de.kiefer_networks.sshvault/shortcuts` method channel.
//
// The Kotlin side (`MainActivity.kt`) handles the actual `ShortcutManager`
// calls; this service is the Dart-side controller that watches
// `favoriteServersProvider` and forwards favorite changes across the channel.
//
// On every other platform this service is a no-op: any non-Android caller
// returns immediately, and a `MissingPluginException` (e.g. unit tests, or a
// build that hasn't registered the channel yet) is logged once and then
// suppressed for the rest of the run.

library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';

/// Maximum number of favorites pushed as dynamic shortcuts. The platform
/// allows up to 5 total static + dynamic entries on most launchers; SSHVault
/// has 3 static entries, so we cap dynamic at the requested top-3.
const int kAndroidMaxDynamicFavorites = 3;

/// One favorite entry serialised across the method channel.
@immutable
class AndroidShortcutFavorite {
  final String id;
  final String name;
  final String subtitle;

  const AndroidShortcutFavorite({
    required this.id,
    required this.name,
    this.subtitle = '',
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'subtitle': subtitle,
  };

  @override
  bool operator ==(Object other) =>
      other is AndroidShortcutFavorite &&
      other.id == id &&
      other.name == name &&
      other.subtitle == subtitle;

  @override
  int get hashCode => Object.hash(id, name, subtitle);
}

/// Singleton service that keeps Android dynamic shortcuts in sync with
/// `favoriteServersProvider`.
class AndroidShortcutsService {
  AndroidShortcutsService._();
  static final AndroidShortcutsService instance = AndroidShortcutsService._();

  static const _tag = 'AndroidShortcuts';

  /// Channel name shared with `MainActivity.kt`.
  static const MethodChannel _channel = MethodChannel(
    'de.kiefer_networks.sshvault/shortcuts',
  );

  /// Test seam — overridden by tests to capture the method + payload without
  /// standing up the full mock messenger plumbing.
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
  ProviderSubscription<AsyncValue<List<ServerEntity>>>? _favoritesSub;

  /// Last payload pushed to the OS — exposed for testing and used to
  /// short-circuit redundant `setFavorites` calls.
  List<AndroidShortcutFavorite> _last = const [];
  List<AndroidShortcutFavorite> get lastFavorites => List.unmodifiable(_last);

  /// Wire up provider listeners and push the initial dynamic shortcuts. Safe
  /// to call repeatedly; the second invocation is a no-op. Returns
  /// immediately on non-Android platforms.
  Future<void> init(ProviderContainer container) async {
    if (!_isAndroid) return;
    if (_initialized) return;
    _container = container;

    _favoritesSub = container.listen<AsyncValue<List<ServerEntity>>>(
      favoriteServersProvider,
      (_, _) => unawaited(_refresh()),
      fireImmediately: false,
    );

    _initialized = true;
    LoggingService.instance.info(_tag, 'Android shortcuts service initialized');
    await _refresh();
  }

  /// Stop listening and clear dynamic shortcuts. Safe to call from any
  /// platform.
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _favoritesSub?.close();
    _favoritesSub = null;
    if (_isAndroid && _initialized && !_helperUnavailable) {
      try {
        await invoker('setFavorites', const <Object>[]);
      } catch (_) {
        // best-effort
      }
    }
  }

  /// Force a rebuild from the current provider state. Public for testing.
  @visibleForTesting
  Future<void> refresh() => _refresh();

  Future<void> _refresh() async {
    if (!_isAndroid || _container == null || _helperUnavailable) return;
    final servers = _container!.read(favoriteServersProvider).value ?? const [];
    await _setFavorites(buildFavorites(servers));
  }

  /// Pure builder used by tests and by [_refresh]. Caps the result at
  /// [kAndroidMaxDynamicFavorites] (top-3 favorites), maps the server
  /// entity onto the channel-friendly shape, and falls back to the hostname
  /// when the user hasn't named the host.
  static List<AndroidShortcutFavorite> buildFavorites(
    List<ServerEntity> servers,
  ) {
    final capped = servers.take(kAndroidMaxDynamicFavorites);
    return capped
        .map(
          (s) => AndroidShortcutFavorite(
            id: s.id,
            name: s.name.isEmpty ? s.hostname : s.name,
            subtitle: s.hostname,
          ),
        )
        .toList(growable: false);
  }

  Future<void> _setFavorites(List<AndroidShortcutFavorite> favorites) async {
    if (_listsEqual(favorites, _last)) return;
    _last = List.unmodifiable(favorites);
    try {
      await invoker(
        'setFavorites',
        favorites.map((f) => f.toMap()).toList(growable: false),
      );
    } on MissingPluginException {
      _helperUnavailable = true;
      LoggingService.instance.warning(
        _tag,
        'Native shortcuts helper not registered; dynamic shortcuts disabled',
      );
    } catch (e) {
      LoggingService.instance.warning(_tag, 'setFavorites failed: $e');
    }
  }

  /// Test-only reset so each test starts with a clean state.
  @visibleForTesting
  void resetForTest() {
    _favoritesSub?.close();
    _favoritesSub = null;
    _container = null;
    _last = const [];
    _initialized = false;
    _disposed = false;
    _helperUnavailable = false;
    invoker = _defaultInvoke;
  }

  static bool get _isAndroid {
    if (kIsWeb) return false;
    return Platform.isAndroid;
  }

  static bool _listsEqual(
    List<AndroidShortcutFavorite> a,
    List<AndroidShortcutFavorite> b,
  ) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
