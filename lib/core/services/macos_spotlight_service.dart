// Core Spotlight indexing for SSHVault hosts (macOS + iOS).
//
// Pushes the current `serverListProvider` snapshot into Spotlight via the
// `de.kiefer_networks.sshvault/spotlight` method channel — implemented by
// `macos/Runner/SpotlightIndexer.swift` on macOS and
// `ios/Runner/SpotlightIndexer.swift` on iOS. Both Swift implementations
// share the same channel name and method shapes so a single Dart service
// drives them.
//
// Activating a Spotlight hit forwards `spotlightOpen(hostId)`:
//   * macOS: over `de.kiefer_networks.sshvault/macos`, from
//     `application(_:continue:restorationHandler:)`.
//   * iOS: over `de.kiefer_networks.sshvault/ios`, from the same hook.
// Both routes terminate in the existing host-router elsewhere in the app.
//
// Re-indexing happens on every change to the host list, with a 1-second
// debounce so back-to-back mutations (bulk import, sync replay, drag-reorder)
// collapse into a single native call. On non-macOS / non-iOS hosts every
// entry point is a guarded no-op so this file can be wired unconditionally
// from the startup path.

library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';

/// Method-channel name shared with `macos/Runner/SpotlightIndexer.swift` and
/// `ios/Runner/SpotlightIndexer.swift`. Centralised here so a rename on any
/// side is visible to grep.
const String kMacosSpotlightChannel = 'de.kiefer_networks.sshvault/spotlight';

/// Debounce window for re-indexing. The native call hops onto Spotlight's
/// own queue, but we still want to coalesce the burst of provider
/// invalidations triggered by a bulk import so we only push one batch.
const Duration _kSpotlightDebounce = Duration(seconds: 1);

/// Riverpod-owned service that mirrors `serverListProvider` into Core
/// Spotlight on macOS and iOS. Created lazily by
/// [macosSpotlightServiceProvider] which also installs the listener; tearing
/// the provider down (e.g. test cleanup) cancels the debounce timer and
/// detaches the channel handler.
class MacosSpotlightService {
  /// Production constructor — binds the real method channel. Safe to
  /// instantiate on non-macOS / non-iOS hosts; every method short-circuits
  /// before touching the channel so the platform-specific plugin never has
  /// to load.
  MacosSpotlightService()
    : _channel = const MethodChannel(kMacosSpotlightChannel);

  /// Test seam — lets unit tests inject a mock channel without spinning up
  /// the binary messenger machinery.
  @visibleForTesting
  MacosSpotlightService.test({required MethodChannel channel})
    : _channel = channel;

  final MethodChannel _channel;

  Timer? _debounce;
  bool _disposed = false;

  /// Last batch we pushed. Used to skip redundant native calls when the
  /// provider re-emits an identical list (e.g. a tag-only update that the
  /// Spotlight surface doesn't care about).
  List<_SpotlightItem> _lastBatch = const [];

  /// Whether the native plugin responded with `MissingPluginException`.
  /// Once true we stop calling the channel — no point spamming the log on
  /// every list update if the host is non-macOS or the registrant didn't
  /// load (e.g. running under `flutter test` on macOS).
  bool _channelUnavailable = false;

  /// True on macOS / iOS where the native plugin is reachable.
  bool get _isEnabled =>
      !kIsWeb &&
      (Platform.isMacOS || Platform.isIOS) &&
      !_channelUnavailable &&
      !_disposed;

  /// Schedule a re-index. Coalesces back-to-back calls into a single
  /// native invocation `_kSpotlightDebounce` later.
  void scheduleIndex(List<ServerEntity> servers) {
    if (!_isEnabled) return;
    _debounce?.cancel();
    _debounce = Timer(_kSpotlightDebounce, () {
      unawaited(_index(servers));
    });
  }

  /// Push [servers] to Spotlight immediately, bypassing the debounce.
  /// Useful for test code and for the explicit "Rebuild Spotlight index"
  /// button in Preferences (if/when one is added).
  Future<void> indexNow(List<ServerEntity> servers) async {
    _debounce?.cancel();
    if (!_isEnabled) return;
    await _index(servers);
  }

  /// Drop every host SSHVault has indexed. Called when the user signs out,
  /// wipes the local vault, or disables Spotlight indexing in Preferences.
  Future<void> removeAll() async {
    _debounce?.cancel();
    if (!_isEnabled) return;
    try {
      await _channel.invokeMethod<bool>('removeAll');
      _lastBatch = const [];
    } on MissingPluginException {
      _markChannelUnavailable('removeAll');
    } on PlatformException catch (e) {
      LoggingService.instance.warning(
        'Spotlight',
        'removeAll failed: ${e.code} ${e.message}',
      );
    }
  }

  /// Tear down the timer and forget the cached batch. The owning provider
  /// calls this from `onDispose`.
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _debounce?.cancel();
    _debounce = null;
    _lastBatch = const [];
  }

  // ---------------------------------------------------------------------------

  Future<void> _index(List<ServerEntity> servers) async {
    if (!_isEnabled) return;
    final batch = servers
        .map(_SpotlightItem.fromServer)
        .toList(growable: false);
    if (_listsEqual(batch, _lastBatch)) return;
    _lastBatch = batch;
    try {
      await _channel.invokeMethod<dynamic>('index', <String, Object?>{
        'items': batch.map((e) => e.toMap()).toList(growable: false),
      });
    } on MissingPluginException {
      _markChannelUnavailable('index');
    } on PlatformException catch (e) {
      LoggingService.instance.warning(
        'Spotlight',
        'index failed: ${e.code} ${e.message}',
      );
    }
  }

  void _markChannelUnavailable(String method) {
    _channelUnavailable = true;
    LoggingService.instance.warning(
      'Spotlight',
      'Native plugin not registered; "$method" disabled for this run',
    );
  }

  static bool _listsEqual(List<_SpotlightItem> a, List<_SpotlightItem> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Internal value carrier — keeps the channel payload consistent between
/// `_index` and the equality check used to skip redundant pushes.
@immutable
class _SpotlightItem {
  final String id;
  final String title;
  final String subtitle;
  final String fingerprint;

  const _SpotlightItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.fingerprint,
  });

  factory _SpotlightItem.fromServer(ServerEntity s) {
    final title = s.name.isEmpty ? s.hostname : s.name;
    // Subtitle mirrors the user-visible "user@host:port" rendering that
    // SSHVault uses in the host list — gives Spotlight enough context to
    // disambiguate same-named hosts on different jump networks.
    final port = s.port == 22 ? '' : ':${s.port}';
    final user = s.username.isEmpty ? '' : '${s.username}@';
    final subtitle = '$user${s.hostname}$port';
    return _SpotlightItem(
      id: s.id,
      title: title,
      subtitle: subtitle,
      // ServerEntity carries no per-host fingerprint today, but the channel
      // contract has the slot reserved so we can populate it from the
      // host-key store later without changing the Swift side.
      fingerprint: '',
    );
  }

  Map<String, Object?> toMap() => <String, Object?>{
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'fingerprint': fingerprint,
  };

  @override
  bool operator ==(Object other) =>
      other is _SpotlightItem &&
      other.id == id &&
      other.title == title &&
      other.subtitle == subtitle &&
      other.fingerprint == fingerprint;

  @override
  int get hashCode => Object.hash(id, title, subtitle, fingerprint);
}

/// Provider that owns the singleton [MacosSpotlightService] AND wires the
/// `serverListProvider` listener. `ref.listen` on the AsyncValue payload
/// fires every time the host list reloads; we forward the resolved list
/// (or `[]` when the provider is in `loading` / `error`) to the debounced
/// indexer.
///
/// The provider is `keepAlive` so that subsequent `ref.read` calls don't
/// recreate the service and lose the listener; the explicit `onDispose`
/// covers the test path and the eventual user-driven sign-out flow that
/// invalidates the provider on purpose.
final macosSpotlightServiceProvider = Provider<MacosSpotlightService>((ref) {
  final service = MacosSpotlightService();

  // Re-index whenever the host list changes. The debounce inside
  // `scheduleIndex` collapses bursts (bulk import, sync replay) into a
  // single native call. We use `fireImmediately` so the freshly-launched
  // app primes the index without waiting for the first user mutation.
  ref.listen<AsyncValue<List<ServerEntity>>>(serverListProvider, (
    previous,
    next,
  ) {
    final servers = next.value;
    if (servers == null) return;
    service.scheduleIndex(servers);
  }, fireImmediately: true);

  ref.onDispose(service.dispose);
  return service;
});
