import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/crypto/crypto_provider.dart';
import 'package:shellvault/core/network/api_provider.dart';
import 'package:shellvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/repository_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/server_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/group_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/tag_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/ssh_key_providers.dart';
import 'package:shellvault/features/snippet/presentation/providers/snippet_providers.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:shellvault/features/sync/data/repositories/sync_repository_impl.dart';
import 'package:shellvault/features/sync/domain/repositories/sync_repository.dart';
import 'package:shellvault/features/sync/domain/usecases/sync_usecases.dart';

enum SyncStatus { idle, syncing, success, error }

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  return SyncRepositoryImpl(ref.watch(apiClientProvider));
});

final syncUseCasesProvider = Provider<SyncUseCases>((ref) {
  return SyncUseCases(
    ref.watch(syncRepositoryProvider),
    ref.watch(exportImportRepositoryProvider),
    ref.watch(encryptionServiceProvider),
  );
});

final syncProvider =
    AsyncNotifierProvider<SyncNotifier, SyncStatus>(SyncNotifier.new);

class SyncNotifier extends AsyncNotifier<SyncStatus> {
  @override
  Future<SyncStatus> build() async => SyncStatus.idle;

  Future<void> sync() async {
    // Check auth status
    final authStatus = ref.read(authProvider).valueOrNull;
    if (authStatus != AuthStatus.authenticated) {
      state = AsyncValue.error(
        'Not authenticated',
        StackTrace.current,
      );
      return;
    }

    // Check sync password
    final storage = ref.read(secureStorageProvider);
    final syncPwResult = await storage.getSyncPassword();
    final syncPassword = syncPwResult.isSuccess ? syncPwResult.value : null;
    if (syncPassword == null || syncPassword.isEmpty) {
      state = AsyncValue.error(
        'Sync password not set',
        StackTrace.current,
      );
      return;
    }

    state = const AsyncValue.data(SyncStatus.syncing);

    // Get local vault version from settings
    final settings = ref.read(settingsProvider).valueOrNull;
    final localVersion = settings?.localVaultVersion ?? 0;

    final useCases = ref.read(syncUseCasesProvider);
    final result = await useCases.sync(syncPassword, localVersion);

    result.fold(
      onSuccess: (newVersion) {
        // Update local vault version
        ref.read(settingsProvider.notifier).setLocalVaultVersion(newVersion);

        // Invalidate all data providers so they reload from DB
        ref.invalidate(serverListProvider);
        ref.invalidate(groupListProvider);
        ref.invalidate(tagListProvider);
        ref.invalidate(sshKeyListProvider);
        ref.invalidate(snippetListProvider);

        state = const AsyncValue.data(SyncStatus.success);
      },
      onFailure: (f) {
        state = AsyncValue.error(f, StackTrace.current);
      },
    );
  }

  Future<void> pushOnly() async {
    final storage = ref.read(secureStorageProvider);
    final syncPwResult = await storage.getSyncPassword();
    final syncPassword = syncPwResult.isSuccess ? syncPwResult.value : null;
    if (syncPassword == null || syncPassword.isEmpty) return;

    state = const AsyncValue.data(SyncStatus.syncing);

    final settings = ref.read(settingsProvider).valueOrNull;
    final localVersion = settings?.localVaultVersion ?? 0;

    final useCases = ref.read(syncUseCasesProvider);
    final result = await useCases.push(syncPassword, localVersion);

    result.fold(
      onSuccess: (newVersion) {
        ref.read(settingsProvider.notifier).setLocalVaultVersion(newVersion);
        state = const AsyncValue.data(SyncStatus.success);
      },
      onFailure: (f) {
        state = AsyncValue.error(f, StackTrace.current);
      },
    );
  }
}
