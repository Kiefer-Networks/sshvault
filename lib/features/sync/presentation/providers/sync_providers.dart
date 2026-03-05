import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/network/api_provider.dart';
import 'package:shellvault/core/services/logging_service.dart';
import 'package:shellvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/server_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/folder_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/tag_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/ssh_key_providers.dart';
import 'package:shellvault/features/snippet/presentation/providers/snippet_providers.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:shellvault/features/sync/presentation/providers/sync_repository_providers.dart';

export 'package:shellvault/features/sync/presentation/providers/sync_repository_providers.dart';

enum SyncStatus { idle, syncing, success, error }

final syncProvider = AsyncNotifierProvider<SyncNotifier, SyncStatus>(
  SyncNotifier.new,
);

class SyncNotifier extends AsyncNotifier<SyncStatus> {
  static final _log = LoggingService.instance;
  static const _tag = 'Sync';

  Timer? _debounceTimer;
  Timer? _periodicSyncTimer;

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
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 3), () {
      _log.debug(_tag, 'Debounced push triggered');
      pushOnly();
    });
  }

  /// Start periodic background sync using the configured interval.
  void _startPeriodicSync() {
    _periodicSyncTimer?.cancel();
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

  Future<void> sync() async {
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
    final settings = ref.read(settingsProvider).value;
    final localVersion = settings?.localVaultVersion ?? 0;

    final useCases = ref.read(syncUseCasesProvider);
    var result = await useCases.sync(syncPassword, localVersion);

    // If pull decryption failed (corrupted server vault from old crypto bug),
    // fall back to push-only to overwrite with correctly encrypted local data.
    if (result.isFailure && result.failure is CryptoFailure) {
      _log.warning(
        _tag,
        'Pull decryption failed — falling back to push-only '
        'to re-encrypt server vault',
      );
      result = await useCases.push(syncPassword, localVersion);
    }

    result.fold(
      onSuccess: (newVersion) {
        // Update local vault version
        ref.read(settingsProvider.notifier).setLocalVaultVersion(newVersion);

        // Invalidate all data providers so they reload from DB
        ref.invalidate(serverListProvider);
        ref.invalidate(folderListProvider);
        ref.invalidate(tagListProvider);
        ref.invalidate(sshKeyListProvider);
        ref.invalidate(snippetListProvider);

        _log.info(_tag, 'Sync successful (version=$newVersion)');
        state = const AsyncValue.data(SyncStatus.success);
      },
      onFailure: (f) {
        _log.error(_tag, 'Sync failed: $f');
        state = AsyncValue.error(f, StackTrace.current);
      },
    );
  }

  Future<void> pushOnly() async {
    // Auth guard
    final authStatus = ref.read(authProvider).value;
    if (authStatus != AuthStatus.authenticated) return;

    final storage = ref.read(secureStorageProvider);
    final syncPwResult = await storage.getSyncPassword();
    final syncPassword = syncPwResult.isSuccess ? syncPwResult.value : null;
    if (syncPassword == null || syncPassword.isEmpty) return;

    state = const AsyncValue.data(SyncStatus.syncing);
    _log.info(_tag, 'Push-only initiated');

    final settings = ref.read(settingsProvider).value;
    final localVersion = settings?.localVaultVersion ?? 0;

    final useCases = ref.read(syncUseCasesProvider);
    final result = await useCases.pushWithRetry(syncPassword, localVersion);

    result.fold(
      onSuccess: (newVersion) {
        ref.read(settingsProvider.notifier).setLocalVaultVersion(newVersion);
        _log.info(_tag, 'Push-only successful (version=$newVersion)');
        state = const AsyncValue.data(SyncStatus.success);
      },
      onFailure: (f) {
        _log.error(_tag, 'Push-only failed: $f');
        state = AsyncValue.error(f, StackTrace.current);
      },
    );
  }

  Future<void> pullOnly() async {
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

    result.fold(
      onSuccess: (newVersion) {
        ref.read(settingsProvider.notifier).setLocalVaultVersion(newVersion);

        ref.invalidate(serverListProvider);
        ref.invalidate(folderListProvider);
        ref.invalidate(tagListProvider);
        ref.invalidate(sshKeyListProvider);
        ref.invalidate(snippetListProvider);

        _log.info(_tag, 'Pull-only successful (version=$newVersion)');
        state = const AsyncValue.data(SyncStatus.success);
      },
      onFailure: (f) {
        _log.error(_tag, 'Pull-only failed: $f');
        state = AsyncValue.error(f, StackTrace.current);
      },
    );
  }
}
