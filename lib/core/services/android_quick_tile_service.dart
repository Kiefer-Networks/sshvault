// Android Quick Settings Tile bridge for SSHVault.
//
// On Android the user can pull down the status shade and tap a "SSHVault"
// tile to reopen the last SSH session straight from anywhere in the system —
// no app launcher round-trip required. The native side
// (`QuickConnectTileService.kt`) reads the most recent host name from
// SharedPreferences and shows it on the tile label so the affordance is
// "SSHVault: prod-1" instead of just "SSHVault".
//
// This Dart class owns the small bit of plumbing that keeps that label fresh:
// it watches `recentServersProvider` and pushes the most recent server's
// display name to the platform side via a method channel.
//
// On every other platform (iOS, desktops, web) this service is a complete
// no-op. `MissingPluginException` is treated as "the helper isn't wired yet"
// — we log once and stop trying.
//
// The actual deep-link handling (`sshvault://reopen-last`) lives in the
// existing `app_links` / `windows_instance_service` routing layer; the tile
// just fires that URL and lets the rest of the app deal with it.

library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';

/// Singleton that mirrors `recentServersProvider` onto the Android tile.
class AndroidQuickTileService {
  AndroidQuickTileService._();
  static final AndroidQuickTileService instance = AndroidQuickTileService._();

  static const _tag = 'QuickTile';

  /// Channel shared with `QuickConnectTileService.kt`.
  static const MethodChannel _channel = MethodChannel(
    'de.kiefer_networks.sshvault/qs_tile',
  );

  /// Method name the native side expects.
  @visibleForTesting
  static const String kUpdateLastHostMethod = 'updateLastHost';

  /// Test seam — overridden by tests so they can assert which method was
  /// invoked with which payload without a mock messenger.
  @visibleForTesting
  Future<Object?> Function(String method, Object? args) invoker =
      _defaultInvoke;

  static Future<Object?> _defaultInvoke(String method, Object? args) {
    return _channel.invokeMethod(method, args);
  }

  bool _initialized = false;
  bool _disposed = false;
  bool _helperUnavailable = false;
  String? _lastPushed;

  ProviderSubscription<AsyncValue<List<ServerEntity>>>? _recentsSub;

  /// Wire up the provider listener. Safe to call repeatedly; the second
  /// invocation is a no-op. Returns immediately on non-Android platforms.
  Future<void> init(ProviderContainer container) async {
    if (!_isAndroid) return;
    if (_initialized) return;
    _initialized = true;

    _recentsSub = container.listen<AsyncValue<List<ServerEntity>>>(
      recentServersProvider,
      (_, next) {
        final servers = next.value;
        if (servers == null) return;
        unawaited(_pushMostRecent(servers));
      },
      fireImmediately: true,
    );

    LoggingService.instance.info(
      _tag,
      'Android Quick Tile service initialized',
    );
  }

  /// Tear down the provider subscription. Idempotent.
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _recentsSub?.close();
    _recentsSub = null;
  }

  /// Force a push of [name] to the native side. Public for testing and for
  /// callers that want to override the label outside the provider stream
  /// (e.g. when a session is opened explicitly).
  Future<void> updateLastHost(String name) async {
    if (!_isAndroid || _helperUnavailable) return;
    final trimmed = name.trim();
    if (trimmed == _lastPushed) return;
    _lastPushed = trimmed;
    try {
      await invoker(kUpdateLastHostMethod, {'name': trimmed});
    } on MissingPluginException {
      _helperUnavailable = true;
      LoggingService.instance.warning(
        _tag,
        'Native QS tile helper not registered; updateLastHost disabled',
      );
    } catch (e) {
      LoggingService.instance.warning(_tag, 'updateLastHost failed: $e');
    }
  }

  Future<void> _pushMostRecent(List<ServerEntity> servers) async {
    if (servers.isEmpty) {
      await updateLastHost('');
      return;
    }
    final s = servers.first;
    final name = s.name.isEmpty ? s.hostname : s.name;
    await updateLastHost(name);
  }

  /// Test-only reset hook.
  @visibleForTesting
  void resetForTest() {
    _recentsSub?.close();
    _recentsSub = null;
    _initialized = false;
    _disposed = false;
    _helperUnavailable = false;
    _lastPushed = null;
    invoker = _defaultInvoke;
  }

  /// Last value pushed to the OS — exposed for tests.
  @visibleForTesting
  String? get lastPushed => _lastPushed;

  static bool get _isAndroid {
    if (kIsWeb) return false;
    return Platform.isAndroid;
  }
}
