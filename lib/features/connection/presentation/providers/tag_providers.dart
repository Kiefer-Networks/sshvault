import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/utils/auto_sync_mixin.dart';
import 'package:shellvault/features/connection/domain/entities/tag_entity.dart';
import 'package:shellvault/features/connection/presentation/providers/repository_providers.dart';

final tagListProvider = AsyncNotifierProvider<TagListNotifier, List<TagEntity>>(
  TagListNotifier.new,
);

class TagListNotifier extends AsyncNotifier<List<TagEntity>>
    with AutoSyncMixin {
  @override
  Future<List<TagEntity>> build() async {
    final useCases = ref.watch(tagUseCasesProvider);
    final result = await useCases.getTags();
    return result.fold(
      onSuccess: (tags) => tags,
      onFailure: (failure) => throw failure,
    );
  }

  Future<void> createTag(TagEntity tag) async {
    final useCases = ref.read(tagUseCasesProvider);
    final result = await useCases.createTag(tag);
    result.fold(
      onSuccess: (_) {
        ref.invalidateSelf();
        triggerAutoSync();
      },
      onFailure: (failure) => throw failure,
    );
  }

  Future<void> updateTag(TagEntity tag) async {
    final useCases = ref.read(tagUseCasesProvider);
    final result = await useCases.updateTag(tag);
    result.fold(
      onSuccess: (_) {
        ref.invalidateSelf();
        triggerAutoSync();
      },
      onFailure: (failure) => throw failure,
    );
  }

  Future<void> deleteTag(String id) async {
    final useCases = ref.read(tagUseCasesProvider);
    final result = await useCases.deleteTag(id);
    result.fold(
      onSuccess: (_) {
        ref.invalidateSelf();
        triggerAutoSync();
      },
      onFailure: (failure) => throw failure,
    );
  }
}
