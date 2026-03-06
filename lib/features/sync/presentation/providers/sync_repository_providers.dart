import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/crypto/crypto_provider.dart';
import 'package:sshvault/core/network/api_provider.dart';
import 'package:sshvault/features/connection/presentation/providers/repository_providers.dart';
import 'package:sshvault/features/sync/data/repositories/sync_repository_impl.dart';
import 'package:sshvault/features/sync/domain/repositories/sync_repository.dart';
import 'package:sshvault/features/sync/domain/usecases/sync_usecases.dart';

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
