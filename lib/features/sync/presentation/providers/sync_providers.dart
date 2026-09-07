import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/core/network/api_provider.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/folder_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/tag_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/ssh_key_providers.dart';
import 'package:sshvault/features/snippet/presentation/providers/snippet_providers.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/features/sync/presentation/providers/sync_repository_providers.dart';

export 'package:sshvault/features/sync/presentation/providers/sync_repository_providers.dart';

enum SyncStatus { idle, syncing, success, error }

final syncProvider = AsyncNotifierProvider<SyncNotifier, SyncStatus>(
  SyncNotifier.new,
);

class SyncNotifier extends AsyncNotifier<SyncStatus> {
  static final _log = LoggingService.instance;
  static const _tag = 'Sync';

  Timer? _debounceTimer;
  Timer? _periodicSyncTimer;
  Future<void>? _activeOperation;
  bool _stopped = false;
  bool _pushQueued = false;

  Future<void> sync() => _runExclusive(_sync);
  Future<void> pushOnly() {
    if (!_stopped && _activeOperation != null) _pushQueued = true;
    return _runExclusive(_pushOnly);
  }

  Future<void> pullOnly() => _runExclusive(_pullOnly);

  Future<Result<int>> changeEncryptionPassword(
    String oldPassword,
    String newPassword,
  ) async {
    if (_stopped || _activeOperation != null) {
      return const Err(SyncFailure('Wait for the current sync to finish'));
    }
    Result<int> outcome = const Err(SyncFailure('Password change failed'));
    await _runExclusive(() async {
      state = const AsyncValue.data(SyncStatus.syncing);
      final result = await ref
          .read(syncUseCasesProvider)
          .changeEncryptionPassword(oldPassword, newPassword);
      if (result.isFailure) {
        outcome = result;
        state = AsyncValue.error(result.failure, StackTrace.current);
        return;
      }
      final saved = await ref
          .read(secureStorageProvider)
          .saveSyncPassword(newPassword);
      if (saved.isFailure) {
        outcome = const Err(
          StorageFailure(
            'The server password was changed, but could not be saved on this device. '
            'Enter the new encryption password before syncing again.',
          ),
        );
        state = AsyncValue.error(outcome.failure, StackTrace.current);
        return;
      }
      await ref
          .read(settingsProvider.notifier)
          .setLocalVaultVersion(result.value);
      _invalidateAllDataProviders();
      state = const AsyncValue.data(SyncStatus.success);
      outcome = result;
    });
    return outcome;
  }

  Future<void> _runExclusive(Future<void> Function() operation) {
    if (_stopped) return Future<void>.value();
    final active = _activeOperation;
    if (active != null) return active;
    final completion = Completer<void>();
    _activeOperation = completion.future;
    () async {
      try {
        var next = operation;
        do {
          _pushQueued = false;
          await next();
          next = _pushOnly;
        } while (_pushQueued && !_stopped && !state.hasError);
      } catch (error, stack) {
        if (ref.mounted) state = AsyncValue.error(error, stack);
      } finally {
        _activeOperation = null;
        completion.complete();
      }
    }();
    return completion.future;
  }

  /// Prevent future syncs and finish any pending import before a local wipe.
  Future<void> stopAndWait() async {
    _stopped = true;
    _debounceTimer?.cancel();
    _periodicSyncTimer?.cancel();
    await _activeOperation;
  }

  @override
  Future<SyncStatus> build() async {
    ref.onDispose(() {
      _debounceTimer?.cancel();
      _periodicSyncTimer?.cancel();
    });

    // Start periodic sync timer
    _startPeriodicSync();

    // Restart timer when settings change (e.g. interval or autoSync toggle)
    ref.listen(settingsProvider, (_, _) => _startPeriodicSync());

    return SyncStatus.idle;
  }

  /// Schedule a debounced push (called by CRUD providers)
  void schedulePush() {
    if (_stopped) return;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 3), () {
      _log.debug(_tag, 'Debounced push triggered');
      pushOnly();
    });
  }

  /// Start periodic background sync using the configured interval.
  void _startPeriodicSync() {
    _periodicSyncTimer?.cancel();
    if (_stopped) return;
    final settings = ref.read(settingsProvider).value;
    final intervalMinutes = settings?.autoSyncIntervalMinutes ?? 5;
    _periodicSyncTimer = Timer.periodic(Duration(minutes: intervalMinutes), (
      _,
    ) {
      final authStatus = ref.read(authProvider).value;
      final s = ref.read(settingsProvider).value;
      if (authStatus == AuthStatus.authenticated && (s?.autoSync ?? false)) {
        _log.debug(_tag, 'Periodic sync triggered (${intervalMinutes}m)');
        sync();
      }
    });
  }

  /// Invalidate all data providers so they reload from DB after sync.
  ///
  /// After invalidation, explicitly read the providers in the next frame
  /// to force an immediate rebuild. Without this, FutureProviders that are
  /// not actively watched (e.g. on a background tab) may stay stale until
  /// the user navigates to them.
  void _invalidateAllDataProviders() {
    ref.invalidate(folderListProvider);
    ref.invalidate(folderTreeProvider);
    ref.invalidate(tagListProvider);
    ref.invalidate(sshKeyListProvider);
    ref.invalidate(snippetListProvider);
    ref.invalidate(settingsProvider);
    ref.invalidate(serverListProvider);
    ref.invalidate(favoriteServersProvider);
    ref.invalidate(recentServersProvider);
    ref.invalidate(folderGroupedServersProvider);
    ref.invalidate(serversLinkedToKeyProvider);

    // Force providers to rebuild in the next frame so UI updates immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!ref.mounted) return;
      ref.read(serverListProvider);
      ref.read(folderGroupedServersProvider);
      ref.read(favoriteServersProvider);
      ref.read(recentServersProvider);
    });
  }

  Future<void> _sync() async {
    // Check auth status
    final authStatus = ref.read(authProvider).value;
    if (authStatus != AuthStatus.authenticated) {
      _log.warning(_tag, 'Sync aborted: not authenticated');
      state = const AsyncValue.data(SyncStatus.idle);
      return;
    }

    // Check sync password
    final storage = ref.read(secureStorageProvider);
    final syncPwResult = await storage.getSyncPassword();
    final syncPassword = syncPwResult.isSuccess ? syncPwResult.value : null;
    if (syncPassword == null || syncPassword.isEmpty) {
      _log.warning(_tag, 'Sync aborted: sync password not set');
      state = const AsyncValue.data(SyncStatus.idle);
      return;
    }

    state = const AsyncValue.data(SyncStatus.syncing);
    _log.info(_tag, 'Sync initiated by user');

    // Get local vault version from settings
    final settings = await ref.read(settingsProvider.future);
    final localVersion = settings.localVaultVersion;

    final useCases = ref.read(syncUseCasesProvider);
    final result = await useCases.sync(syncPassword, localVersion);

    await result.fold<Future<void>>(
      onSuccess: (newVersion) async {
        // Update local vault version
        await ref
            .read(settingsProvider.notifier)
            .setLocalVaultVersion(newVersion);

        // Invalidate all data providers so they reload from DB
        _invalidateAllDataProviders();

        _log.info(_tag, 'Sync successful (version=$newVersion)');
        state = const AsyncValue.data(SyncStatus.success);
      },
      onFailure: (f) async {
        _log.error(_tag, 'Sync failed: $f');
        state = AsyncValue.error(f, StackTrace.current);
      },
    );
  }

  Future<void> _pushOnly() async {
    // Auth guard
    final authStatus = ref.read(authProvider).value;
    if (authStatus != AuthStatus.authenticated) return;

    final storage = ref.read(secureStorageProvider);
    final syncPwResult = await storage.getSyncPassword();
    final syncPassword = syncPwResult.isSuccess ? syncPwResult.value : null;
    if (syncPassword == null || syncPassword.isEmpty) return;

    state = const AsyncValue.data(SyncStatus.syncing);
    _log.info(_tag, 'Push-only initiated');

    final settings = await ref.read(settingsProvider.future);
    final localVersion = settings.localVaultVersion;

    final useCases = ref.read(syncUseCasesProvider);
    final result = await useCases.pushWithRetry(syncPassword, localVersion);

    await result.fold<Future<void>>(
      onSuccess: (newVersion) async {
        await ref
            .read(settingsProvider.notifier)
            .setLocalVaultVersion(newVersion);
        _log.info(_tag, 'Push-only successful (version=$newVersion)');
        state = const AsyncValue.data(SyncStatus.success);
      },
      onFailure: (f) async {
        _log.error(_tag, 'Push-only failed: $f');
        state = AsyncValue.error(f, StackTrace.current);
      },
    );
  }

  Future<void> _pullOnly() async {
    // Auth guard
    final authStatus = ref.read(authProvider).value;
    if (authStatus != AuthStatus.authenticated) return;

    final storage = ref.read(secureStorageProvider);
    final syncPwResult = await storage.getSyncPassword();
    final syncPassword = syncPwResult.isSuccess ? syncPwResult.value : null;
    if (syncPassword == null || syncPassword.isEmpty) return;

    state = const AsyncValue.data(SyncStatus.syncing);
    _log.info(_tag, 'Pull-only initiated');

    final useCases = ref.read(syncUseCasesProvider);
    final result = await useCases.pull(syncPassword);

    await result.fold<Future<void>>(
      onSuccess: (newVersion) async {
        await ref
            .read(settingsProvider.notifier)
            .setLocalVaultVersion(newVersion);

        _invalidateAllDataProviders();

        _log.info(_tag, 'Pull-only successful (version=$newVersion)');
        state = const AsyncValue.data(SyncStatus.success);
      },
      onFailure: (f) async {
        _log.error(_tag, 'Pull-only failed: $f');
        state = AsyncValue.error(f, StackTrace.current);
      },
    );
  }
}
