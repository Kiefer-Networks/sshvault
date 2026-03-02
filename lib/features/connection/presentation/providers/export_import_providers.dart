import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/features/connection/domain/repositories/export_import_repository.dart';
import 'package:shellvault/features/connection/presentation/providers/repository_providers.dart';

class ExportImportNotifier extends Notifier<AsyncValue<String?>> {
  @override
  AsyncValue<String?> build() => const AsyncData(null);

  Future<void> exportToJson() async {
    state = const AsyncLoading();
    final useCases = ref.read(exportImportUseCasesProvider);
    final result = await useCases.exportToJson();
    state = result.fold(
      onSuccess: (path) => AsyncData(path),
      onFailure: (failure) => AsyncError(failure.message, StackTrace.current),
    );
  }

  Future<void> exportToEncryptedZip(String password) async {
    state = const AsyncLoading();
    final useCases = ref.read(exportImportUseCasesProvider);
    final result = await useCases.exportToEncryptedZip(password);
    state = result.fold(
      onSuccess: (path) => AsyncData(path),
      onFailure: (failure) => AsyncError(failure.message, StackTrace.current),
    );
  }

  Future<ImportResult?> importFromFile(
    String filePath,
    ImportConflictStrategy strategy, {
    String? password,
  }) async {
    state = const AsyncLoading();
    final useCases = ref.read(exportImportUseCasesProvider);
    final result = await useCases.importFromFile(
      filePath,
      strategy,
      password: password,
    );
    return result.fold(
      onSuccess: (importResult) {
        state = const AsyncData('Import successful');
        return importResult;
      },
      onFailure: (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return null;
      },
    );
  }
}

final exportImportNotifierProvider =
    NotifierProvider<ExportImportNotifier, AsyncValue<String?>>(
      ExportImportNotifier.new,
    );
