// iOS-only background sync via `BGTaskScheduler`.
//
// The Swift counterpart (`ios/Runner/BackgroundSyncHelper.swift`) wires
// up a single `BGAppRefreshTaskRequest` keyed by
// `de.kiefer_networks.sshvault.sync` and bounces the OS-fired BGTask
// over a method channel into this Dart service. The actual sync logic
// is shared with the Android pass: we delegate to the same Riverpod
// pipeline (`SyncUseCases.sync`) so a single code path drives the
// vault download regardless of which platform's scheduler woke us up.
//
// Public surface mirrors `AndroidBackgroundSyncService` so the settings
// screen can flip between the two via `Platform.isIOS` /
// `Platform.isAndroid` without juggling two API shapes:
//
//   * `initialize()`           — idempotent; installs the channel handler
//   * `enableBackgroundSync()` — submits the BGTask request
//   * `disable()`              — cancels the pending BGTask
//
// Non-iOS hosts treat every call as a no-op so callers don't need to
// scatter platform guards.

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/core/storage/secure_storage_provider.dart';
import 'package:sshvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/features/sync/presentation/providers/sync_providers.dart';

/// MethodChannel name. Must match `BackgroundSyncHelper.channelName`
/// in Swift. Kept in a const so the test can pin against the same
/// literal without importing the service.
const String kIosBackgroundSyncChannel =
    'de.kiefer-networks.sshvault/background_sync';

/// Provider exposing the singleton service. Mirrors the Android one so
/// the settings screen can pick the right service via `Platform.isIOS`
/// vs `Platform.isAndroid` without dragging both into widget state.
final iosBackgroundSyncServiceProvider = Provider<IosBackgroundSyncService>(
  (ref) => IosBackgroundSyncService(ref: ref),
);

/// Wraps the iOS `BGTaskScheduler` MethodChannel so the rest of the app
/// talks to a platform-aware façade. All entry points are no-ops on
/// non-iOS hosts so callers don't need to scatter `Platform.isIOS`
/// guards.
class IosBackgroundSyncService {
  IosBackgroundSyncService({required Ref ref, MethodChannel? channel})
    : _ref = ref,
      _channel = channel ?? const MethodChannel(kIosBackgroundSyncChannel);

  static const _tag = 'IosBgSync';
  final _log = LoggingService.instance;

  /// Riverpod handle so the BGTask handler can read auth + settings +
  /// sync use-cases from the live container, exactly the way the
  /// Android `callbackDispatcher` does.
  final Ref _ref;

  /// Dual-purpose channel: outbound `schedule` / `cancel` to the BGTask
  /// helper, inbound `runBackgroundSync` from the BGTask handler.
  final MethodChannel _channel;

  bool _initialized = false;

  /// Idempotent. Safe to call from `main()` even on Android / desktop —
  /// the platform check short-circuits before touching the channel.
  Future<void> initialize() async {
    if (!_isSupported || _initialized) return;
    _channel.setMethodCallHandler(_handleCall);
    _initialized = true;
    _log.debug(_tag, 'BGTaskScheduler bridge initialized');
  }

  /// Submits a `BGAppRefreshTaskRequest` with the given earliest-begin
  /// interval. iOS may delay further based on usage heuristics.
  ///
  /// Calling repeatedly replaces the previously-pending request with
  /// the same identifier — there is no separate "update" verb.
  Future<void> enableBackgroundSync({
    Duration interval = const Duration(hours: 1),
  }) async {
    if (!_isSupported) return;
    await initialize();
    await _channel.invokeMethod<void>('schedule', <String, Object?>{
      'intervalSeconds': interval.inSeconds.toDouble(),
    });
    _log.info(
      _tag,
      'BGTaskScheduler armed (earliest in ${interval.inMinutes}m)',
    );
  }

  /// Cancels any pending BGTask request. Safe to call when nothing is
  /// scheduled.
  Future<void> disable() async {
    if (!_isSupported) return;
    if (!_initialized) {
      // Best-effort: still attempt cancel so a cold-started cancel
      // (toggle flipped off before any explicit init) reaches iOS.
      await initialize();
    }
    await _channel.invokeMethod<void>('cancel');
    _log.info(_tag, 'BGTaskScheduler cancelled');
  }

  /// Handles `runBackgroundSync` invocations from the BGTask handler.
  /// Returns `true` on success, `false` to signal the OS to apply
  /// backoff before the next slot.
  Future<Object?> _handleCall(MethodCall call) async {
    if (call.method != 'runBackgroundSync') {
      return null;
    }
    return _runBackgroundSync();
  }

  /// Runs the same auth + sync-password gate as
  /// `callbackDispatcher` on the Android side. iOS gives us a ~30s
  /// wallclock budget — the sync pipeline already enforces its own
  /// per-request timeouts so we don't need a wrapper here.
  Future<bool> _runBackgroundSync() async {
    _log.info(_tag, 'BGTask sync started');
    try {
      final authStatus = await _ref.read(authProvider.future);
      if (authStatus != AuthStatus.authenticated) {
        _log.info(_tag, 'Skipping BGTask sync — not authenticated');
        return true;
      }
      final storage = _ref.read(secureStorageProvider);
      final syncPwResult = await storage.getSyncPassword();
      final syncPassword = syncPwResult.isSuccess ? syncPwResult.value : null;
      if (syncPassword == null || syncPassword.isEmpty) {
        _log.info(_tag, 'Skipping BGTask sync — no sync password');
        return true;
      }

      final settings = await _ref.read(settingsProvider.future);
      final useCases = _ref.read(syncUseCasesProvider);
      final result = await useCases.sync(
        syncPassword,
        settings.localVaultVersion,
      );
      return result.fold(
        onSuccess: (newVersion) {
          _log.info(_tag, 'BGTask sync completed (v=$newVersion)');
          _ref.read(settingsProvider.notifier).setLocalVaultVersion(newVersion);
          return true;
        },
        onFailure: (f) {
          _log.warning(_tag, 'BGTask sync failed: $f');
          return false;
        },
      );
    } catch (e, st) {
      _log.error(_tag, 'BGTask sync crashed: $e\n$st');
      return false;
    }
  }

  bool get _isSupported => Platform.isIOS;
}
