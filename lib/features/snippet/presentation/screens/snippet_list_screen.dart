import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/core/widgets/shell_aware_app_bar.dart';
import 'package:shellvault/features/connection/presentation/widgets/empty_state.dart';
import 'package:shellvault/features/snippet/presentation/providers/snippet_providers.dart';
import 'package:shellvault/features/snippet/presentation/widgets/snippet_tile.dart';

class SnippetListScreen extends ConsumerStatefulWidget {
  const SnippetListScreen({super.key});

  @override
  ConsumerState<SnippetListScreen> createState() => _SnippetListScreenState();
}

class _SnippetListScreenState extends ConsumerState<SnippetListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snippetsAsync = ref.watch(snippetListProvider);
    final filter = ref.watch(snippetFilterProvider);

    return Scaffold(
      appBar: buildShellAppBar(context, title: 'Snippets'),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search snippets...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(snippetFilterProvider.notifier).state =
                              filter.copyWith(clearSearch: true);
                        },
                      )
                    : null,
                isDense: true,
              ),
              onChanged: (value) {
                ref.read(snippetFilterProvider.notifier).state =
                    value.isEmpty
                        ? filter.copyWith(clearSearch: true)
                        : filter.copyWith(searchQuery: value);
              },
            ),
          ),

          // Language filter chips
          if (filter.language != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Chip(
                    label: Text(filter.language!),
                    onDeleted: () {
                      ref.read(snippetFilterProvider.notifier).state =
                          filter.copyWith(clearLanguage: true);
                    },
                  ),
                ],
              ),
            ),

          // List
          Expanded(
            child: snippetsAsync.when(
              data: (snippets) {
                if (snippets.isEmpty) {
                  return EmptyState(
                    icon: Icons.code_outlined,
                    title: 'No snippets yet',
                    subtitle:
                        'Create reusable code snippets and commands.',
                    action: FilledButton.icon(
                      onPressed: () => context.push('/snippet/new'),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Snippet'),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: snippets.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final snippet = snippets[index];
                    return SnippetTile(
                      snippet: snippet,
                      onTap: () => context.push('/snippet/${snippet.id}'),
                    );
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addSnippetFab',
        onPressed: () => context.push('/snippet/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
