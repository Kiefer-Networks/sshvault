import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shellvault/core/utils/auto_sync_mixin.dart';
import 'package:shellvault/features/connection/presentation/providers/repository_providers.dart';
import 'package:shellvault/features/snippet/domain/entities/snippet_entity.dart';
import 'package:shellvault/features/snippet/domain/entities/snippet_filter.dart';

export 'package:shellvault/features/snippet/domain/entities/snippet_filter.dart';

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
