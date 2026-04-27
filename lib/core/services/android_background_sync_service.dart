// Android-only background sync via WorkManager.
//
// The `workmanager` package spawns a headless Flutter engine and runs the
// top-level `callbackDispatcher` entry point in a background isolate. We
// register a single periodic worker (`sshvault.periodic-sync`) that runs
// the existing `SyncUseCases.sync` pipeline so the auto-sync keeps
// working with the app closed.
//
// iOS / desktop targets are no-ops at the call site — those platforms
// either don't have WorkManager (iOS uses BGTaskScheduler, not modeled
// here) or already have their own keep-alive mechanism (the Dart timer
// in `SyncNotifier._startPeriodicSync`). The user-facing toggle is
// gated to `Platform.isAndroid` in the settings screen.

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/core/storage/secure_storage_provider.dart';
import 'package:sshvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/features/sync/presentation/providers/sync_providers.dart';
import 'package:workmanager/workmanager.dart';

/// Unique WorkManager task name. Must stay in sync with
/// `SyncWorker.UNIQUE_WORK_NAME` on the Kotlin side so the work item
/// can be inspected / cancelled with the same identifier from native
/// debug tooling (e.g. `adb shell dumpsys jobscheduler`).
const String _kPeriodicSyncTask = 'sshvault.periodic-sync';

/// Provider exposing the singleton service so the settings screen can
/// flip the toggle through the same DI graph as the rest of the app.
final androidBackgroundSyncServiceProvider =
    Provider<AndroidBackgroundSyncService>(
      (ref) => AndroidBackgroundSyncService(),
    );

/// Top-level callback invoked by the `workmanager` plugin in a background
/// Dart isolate when WorkManager fires the registered periodic task.
///
/// MUST be a top-level (or static) function — the Flutter engine looks
/// up the entry point by symbol name when it spawns the headless isolate.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    final log = LoggingService.instance;
    const tag = 'BgSync';
    if (taskName != _kPeriodicSyncTask) {
      log.warning(tag, 'Unknown task: $taskName');
      return Future.value(true);
    }

    log.info(tag, 'Background sync task started');
    final container = ProviderContainer();
    try {
      // Auth + sync-password gates mirror `SyncNotifier.sync` so we don't
      // burn battery on a hopeless attempt when the user has logged out
      // or never set a sync password.
      final authStatus = await container.read(authProvider.future);
      if (authStatus != AuthStatus.authenticated) {
        log.info(tag, 'Skipping background sync — not authenticated');
        return true;
      }
      final storage = container.read(secureStorageProvider);
      final syncPwResult = await storage.getSyncPassword();
      final syncPassword = syncPwResult.isSuccess ? syncPwResult.value : null;
      if (syncPassword == null || syncPassword.isEmpty) {
        log.info(tag, 'Skipping background sync — no sync password');
        return true;
      }

      final settings = await container.read(settingsProvider.future);
      final useCases = container.read(syncUseCasesProvider);
      final result = await useCases.sync(
        syncPassword,
        settings.localVaultVersion,
      );

      return result.fold(
        onSuccess: (newVersion) {
          log.info(tag, 'Background sync completed (v=$newVersion)');
          // Persist the new version so the foreground UI picks it up
          // when the user next opens the app.
          container
              .read(settingsProvider.notifier)
              .setLocalVaultVersion(newVersion);
          return true;
        },
        onFailure: (f) {
          log.warning(tag, 'Background sync failed: $f');
          // Returning false signals WorkManager to apply backoff.
          return false;
        },
      );
    } catch (e, st) {
      log.error(tag, 'Background sync crashed: $e\n$st');
      return false;
    } finally {
      container.dispose();
    }
  });
}

/// Wraps the `workmanager` plugin so the rest of the app talks to a
/// platform-aware façade. All entry points are no-ops on non-Android
/// hosts so callers don't need to scatter `Platform.isAndroid` guards.
class AndroidBackgroundSyncService {
  AndroidBackgroundSyncService({Workmanager? workmanager})
    : _workmanager = workmanager ?? Workmanager();

  static const _tag = 'BgSync';
  final _log = LoggingService.instance;
  final Workmanager _workmanager;

  bool _initialized = false;

  /// Idempotent. Safe to call from `main()` even on iOS / desktop —
  /// the platform check short-circuits before touching the plugin.
  Future<void> initialize() async {
    if (!_isSupported || _initialized) return;
    await _workmanager.initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
    _initialized = true;
    _log.debug(_tag, 'WorkManager initialized');
  }

  /// Registers (or refreshes) a periodic sync worker with the given
  /// interval. WorkManager enforces a 15-minute floor on the OS side, so
  /// shorter intervals get clamped silently — we still pass through what
  /// the user asked for.
  Future<void> enableBackgroundSync({
    Duration interval = const Duration(hours: 1),
  }) async {
    if (!_isSupported) return;
    await initialize();
    await _workmanager.registerPeriodicTask(
      _kPeriodicSyncTask,
      _kPeriodicSyncTask,
      frequency: interval,
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
      backoffPolicy: BackoffPolicy.exponential,
      backoffPolicyDelay: const Duration(minutes: 5),
    );
    _log.info(
      _tag,
      'Periodic background sync enabled (every ${interval.inMinutes}m)',
    );
  }

  /// Cancels the periodic worker. Safe to call when nothing is registered.
  Future<void> disable() async {
    if (!_isSupported) return;
    if (!_initialized) {
      // Best-effort: still attempt cancel-by-name so a cold-started cancel
      // (e.g. user toggling off before any explicit init) reaches the OS.
      await initialize();
    }
    await _workmanager.cancelByUniqueName(_kPeriodicSyncTask);
    _log.info(_tag, 'Periodic background sync disabled');
  }

  bool get _isSupported => Platform.isAndroid;
}
