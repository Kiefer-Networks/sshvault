import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/repository_providers.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:shellvault/features/snippet/domain/entities/snippet_entity.dart';
import 'package:shellvault/features/sync/presentation/providers/sync_providers.dart';

final snippetFilterProvider = StateProvider<SnippetFilter>(
  (ref) => const SnippetFilter(),
);

class SnippetFilter {
  final String? searchQuery;
  final String? groupId;
  final List<String>? tagIds;
  final String? language;

  const SnippetFilter({
    this.searchQuery,
    this.groupId,
    this.tagIds,
    this.language,
  });

  SnippetFilter copyWith({
    String? searchQuery,
    String? groupId,
    List<String>? tagIds,
    String? language,
    bool clearSearch = false,
    bool clearGroup = false,
    bool clearLanguage = false,
  }) {
    return SnippetFilter(
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
      groupId: clearGroup ? null : (groupId ?? this.groupId),
      tagIds: tagIds ?? this.tagIds,
      language: clearLanguage ? null : (language ?? this.language),
    );
  }
}

final snippetListProvider =
    AsyncNotifierProvider<SnippetListNotifier, List<SnippetEntity>>(
      SnippetListNotifier.new,
    );

class SnippetListNotifier extends AsyncNotifier<List<SnippetEntity>> {
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

  Future<void> createSnippet(SnippetEntity snippet) async {
    final useCases = ref.read(snippetUseCasesProvider);
    final result = await useCases.createSnippet(snippet);
    result.fold(
      onSuccess: (_) {
        ref.invalidateSelf();
        _triggerAutoSync();
      },
      onFailure: (failure) => throw Exception(failure.message),
    );
  }

  Future<void> updateSnippet(SnippetEntity snippet) async {
    final useCases = ref.read(snippetUseCasesProvider);
    final result = await useCases.updateSnippet(snippet);
    result.fold(
      onSuccess: (_) {
        ref.invalidateSelf();
        _triggerAutoSync();
      },
      onFailure: (failure) => throw Exception(failure.message),
    );
  }

  Future<void> deleteSnippet(String id) async {
    final useCases = ref.read(snippetUseCasesProvider);
    final result = await useCases.deleteSnippet(id);
    result.fold(
      onSuccess: (_) {
        ref.invalidateSelf();
        _triggerAutoSync();
      },
      onFailure: (failure) => throw Exception(failure.message),
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
    onFailure: (failure) => throw Exception(failure.message),
  );
});
