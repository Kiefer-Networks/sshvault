import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sshvault/core/utils/auto_sync_mixin.dart';
import 'package:sshvault/features/connection/domain/entities/tag_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/repository_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';

final tagListProvider = AsyncNotifierProvider<TagListNotifier, List<TagEntity>>(
  TagListNotifier.new,
);

/// Tag currently selected for the desktop Tags master/detail pane. Mirrors
/// [desktopSelectedServerIdProvider]'s own purpose for Hosts.
final desktopSelectedTagIdProvider = StateProvider<String?>((ref) => null);

/// True while the Tags master/detail pane's "+" is showing the inline
/// create form instead of an existing tag's detail/edit view.
final tagsCreatingProvider = StateProvider<bool>((ref) => false);

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
        ref.invalidate(serverListProvider);
        ref.invalidate(serverCountByTagProvider);
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
        ref.invalidate(serverListProvider);
        ref.invalidate(serverCountByTagProvider);
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
        ref.invalidate(serverListProvider);
        ref.invalidate(serverCountByTagProvider);
        triggerAutoSync();
      },
      onFailure: (failure) => throw failure,
    );
  }
}
