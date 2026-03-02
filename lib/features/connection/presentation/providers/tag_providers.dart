import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:shellvault/features/connection/domain/entities/tag_entity.dart';
import 'package:shellvault/features/connection/presentation/providers/repository_providers.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:shellvault/features/sync/presentation/providers/sync_providers.dart';

final tagListProvider = AsyncNotifierProvider<TagListNotifier, List<TagEntity>>(
  TagListNotifier.new,
);

class TagListNotifier extends AsyncNotifier<List<TagEntity>> {
  @override
  Future<List<TagEntity>> build() async {
    final useCases = ref.watch(tagUseCasesProvider);
    final result = await useCases.getTags();
    return result.fold(
      onSuccess: (tags) => tags,
      onFailure: (failure) => throw Exception(failure.message),
    );
  }

  void _triggerAutoSync() {
    final authStatus = ref.read(authProvider).valueOrNull;
    final settings = ref.read(settingsProvider).valueOrNull;
    if (authStatus == AuthStatus.authenticated &&
        (settings?.autoSync ?? false)) {
      ref.read(syncProvider.notifier).schedulePush();
    }
  }

  Future<void> createTag(TagEntity tag) async {
    final useCases = ref.read(tagUseCasesProvider);
    final result = await useCases.createTag(tag);
    result.fold(
      onSuccess: (_) {
        ref.invalidateSelf();
        _triggerAutoSync();
      },
      onFailure: (failure) => throw Exception(failure.message),
    );
  }

  Future<void> updateTag(TagEntity tag) async {
    final useCases = ref.read(tagUseCasesProvider);
    final result = await useCases.updateTag(tag);
    result.fold(
      onSuccess: (_) {
        ref.invalidateSelf();
        _triggerAutoSync();
      },
      onFailure: (failure) => throw Exception(failure.message),
    );
  }

  Future<void> deleteTag(String id) async {
    final useCases = ref.read(tagUseCasesProvider);
    final result = await useCases.deleteTag(id);
    result.fold(
      onSuccess: (_) {
        ref.invalidateSelf();
        _triggerAutoSync();
      },
      onFailure: (failure) => throw Exception(failure.message),
    );
  }
}
