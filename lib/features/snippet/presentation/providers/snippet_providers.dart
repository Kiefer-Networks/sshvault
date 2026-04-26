import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sshvault/core/utils/auto_sync_mixin.dart';
import 'package:sshvault/features/connection/presentation/providers/folder_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/repository_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/tag_providers.dart';
import 'package:sshvault/features/snippet/domain/entities/snippet_entity.dart';
import 'package:sshvault/features/snippet/domain/entities/snippet_filter.dart';

export 'package:sshvault/features/snippet/domain/entities/snippet_filter.dart';

final snippetFilterProvider = StateProvider<SnippetFilter>(
  (ref) => const SnippetFilter(),
);

final snippetListProvider =
    AsyncNotifierProvider<SnippetListNotifier, List<SnippetEntity>>(
      SnippetListNotifier.new,
    );

class SnippetListNotifier extends AsyncNotifier<List<SnippetEntity>>
    with AutoSyncMixin {
  @override
  Future<List<SnippetEntity>> build() async {
    final filter = ref.watch(snippetFilterProvider);
    final useCases = ref.watch(snippetUseCasesProvider);
    final result = await useCases.getFilteredSnippets(
      searchQuery: filter.searchQuery,
      groupId: filter.groupId,
      tagIds: filter.tagIds,
      language: filter.language,
    );
    return result.fold(
      onSuccess: (snippets) => snippets,
      onFailure: (failure) => throw failure,
    );
  }

  Future<void> createSnippet(SnippetEntity snippet) async {
    final useCases = ref.read(snippetUseCasesProvider);
    final result = await useCases.createSnippet(snippet);
    result.fold(
      onSuccess: (_) {
        ref.invalidateSelf();
        // Folder and tag count badges read from these providers — invalidate
        // so counts refresh immediately instead of waiting for an app restart.
        ref.invalidate(folderListProvider);
        ref.invalidate(tagListProvider);
        triggerAutoSync();
      },
      onFailure: (failure) => throw failure,
    );
  }

  Future<void> updateSnippet(SnippetEntity snippet) async {
    final useCases = ref.read(snippetUseCasesProvider);
    final result = await useCases.updateSnippet(snippet);
    result.fold(
      onSuccess: (_) {
        ref.invalidateSelf();
        // Folder and tag count badges read from these providers — invalidate
        // so counts refresh immediately instead of waiting for an app restart.
        ref.invalidate(folderListProvider);
        ref.invalidate(tagListProvider);
        triggerAutoSync();
      },
      onFailure: (failure) => throw failure,
    );
  }

  Future<void> deleteSnippet(String id) async {
    final useCases = ref.read(snippetUseCasesProvider);
    final result = await useCases.deleteSnippet(id);
    result.fold(
      onSuccess: (_) {
        ref.invalidateSelf();
        // Folder and tag count badges read from these providers — invalidate
        // so counts refresh immediately instead of waiting for an app restart.
        ref.invalidate(folderListProvider);
        ref.invalidate(tagListProvider);
        triggerAutoSync();
      },
      onFailure: (failure) => throw failure,
    );
  }
}

final snippetDetailProvider = FutureProvider.family<SnippetEntity, String>((
  ref,
  id,
) async {
  final useCases = ref.watch(snippetUseCasesProvider);
  final result = await useCases.getSnippet(id);
  return result.fold(
    onSuccess: (snippet) => snippet,
    onFailure: (failure) => throw failure,
  );
});

/// Number of snippets currently linked to a given tag.
final snippetCountByTagProvider = FutureProvider.family<int, String>((
  ref,
  tagId,
) async {
  final useCases = ref.watch(snippetUseCasesProvider);
  final result = await useCases.getFilteredSnippets(tagIds: [tagId]);
  return result.fold(
    onSuccess: (snippets) => snippets.length,
    onFailure: (_) => 0,
  );
});
