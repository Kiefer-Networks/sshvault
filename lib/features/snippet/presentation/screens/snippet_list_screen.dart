import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/utils/platform_utils.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/core/widgets/error_state.dart';
import 'package:shellvault/core/widgets/shell_aware_app_bar.dart';
import 'package:shellvault/features/connection/presentation/widgets/confirm_dialog.dart';
import 'package:shellvault/features/connection/presentation/widgets/empty_state.dart';
import 'package:shellvault/features/snippet/domain/entities/snippet_entity.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final snippetsAsync = ref.watch(snippetListProvider);
    final filter = ref.watch(snippetFilterProvider);

    return AdaptiveScaffold.withAppBar(
      appBar: buildShellAppBar(
        context,
        title: l10n.snippetListTitle,
        actions: useCupertinoDesign
            ? [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => context.push('/snippet/new'),
                  child: const Icon(CupertinoIcons.add),
                ),
              ]
            : null,
      ),
      floatingActionButton: useCupertinoDesign
          ? null
          : FloatingActionButton(
              heroTag: 'addSnippetFab',
              onPressed: () => context.push('/snippet/new'),
              child: const Icon(Icons.add),
            ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.snippetSearchHint,
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
              keyboardType: TextInputType.text,
              onChanged: (value) {
                ref.read(snippetFilterProvider.notifier).state = value.isEmpty
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
                      ref.read(snippetFilterProvider.notifier).state = filter
                          .copyWith(clearLanguage: true);
                    },
                  ),
                ],
              ),
            ),

          const SizedBox(height: 8),

          // List
          Expanded(
            child: snippetsAsync.when(
              data: (snippets) {
                if (snippets.isEmpty) {
                  return EmptyState(
                    icon: Icons.code_outlined,
                    title: l10n.snippetListEmpty,
                    subtitle: l10n.snippetListEmptySubtitle,
                    action: FilledButton.icon(
                      onPressed: () => context.push('/snippet/new'),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.snippetAddButton),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: snippets.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, indent: 72),
                  itemBuilder: (context, index) {
                    final snippet = snippets[index];
                    return SnippetTile(
                      snippet: snippet,
                      onTap: () => context.push('/snippet/${snippet.id}'),
                      onEdit: () => context.push('/snippet/${snippet.id}/edit'),
                      onDelete: () => _deleteSnippet(context, snippet),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator.adaptive()),
              error: (error, _) => ErrorState(
                error: error,
                onRetry: () => ref.invalidate(snippetListProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteSnippet(
    BuildContext context,
    SnippetEntity snippet,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.snippetDeleteTitle,
      message: l10n.snippetDeleteMessage(snippet.name),
    );
    if (confirmed == true) {
      await ref.read(snippetListProvider.notifier).deleteSnippet(snippet.id);
    }
  }
}
