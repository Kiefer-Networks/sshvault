import 'package:flutter/material.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/features/snippet/domain/entities/snippet_entity.dart';
import 'package:shellvault/features/snippet/presentation/providers/snippet_providers.dart';
import 'package:shellvault/features/snippet/presentation/widgets/variable_fill_dialog.dart';

class SnippetQuickPanel extends ConsumerStatefulWidget {
  const SnippetQuickPanel({super.key});

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) =>
            _SnippetQuickPanelContent(scrollController: scrollController),
      ),
    );
  }

  @override
  ConsumerState<SnippetQuickPanel> createState() => _SnippetQuickPanelState();
}

class _SnippetQuickPanelState extends ConsumerState<SnippetQuickPanel> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class _SnippetQuickPanelContent extends ConsumerStatefulWidget {
  final ScrollController scrollController;

  const _SnippetQuickPanelContent({required this.scrollController});

  @override
  ConsumerState<_SnippetQuickPanelContent> createState() =>
      _SnippetQuickPanelContentState();
}

class _SnippetQuickPanelContentState
    extends ConsumerState<_SnippetQuickPanelContent> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final snippetsAsync = ref.watch(snippetListProvider);

    return Column(
      children: [
        // Handle
        Container(
          margin: const EdgeInsets.only(top: 8),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withAlpha(51),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        // Title
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(l10n.snippetQuickPanelTitle, style: theme.textTheme.titleMedium),
        ),
        // Search
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: l10n.snippetQuickPanelSearch,
              prefixIcon: const Icon(Icons.search, size: 20),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.text,
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
        ),
        const SizedBox(height: 8),
        // List
        Expanded(
          child: snippetsAsync.when(
            data: (snippets) {
              final filtered = _searchQuery.isEmpty
                  ? snippets
                  : snippets
                      .where((s) =>
                          s.name
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()) ||
                          s.content
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()))
                      .toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Text(
                    _searchQuery.isEmpty
                        ? l10n.snippetQuickPanelEmpty
                        : l10n.snippetQuickPanelNoMatch,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(128),
                    ),
                  ),
                );
              }

              return ListView.separated(
                controller: widget.scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filtered.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1),
                itemBuilder: (context, index) {
                  final snippet = filtered[index];
                  return _SnippetTile(
                    snippet: snippet,
                    onTap: () => _insertSnippet(snippet),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(l10n.error(e.toString()))),
          ),
        ),
      ],
    );
  }

  Future<void> _insertSnippet(SnippetEntity snippet) async {
    if (snippet.variables.isEmpty) {
      Navigator.of(context).pop(snippet.content);
    } else {
      final resolved = await VariableFillDialog.show(
        context,
        snippet,
        returnContent: true,
      );
      if (resolved != null && mounted) {
        Navigator.of(context).pop(resolved);
      }
    }
  }
}

class _SnippetTile extends StatelessWidget {
  final SnippetEntity snippet;
  final VoidCallback onTap;

  const _SnippetTile({required this.snippet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          Expanded(
            child: Text(snippet.name, overflow: TextOverflow.ellipsis),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              snippet.language,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
      subtitle: Text(
        snippet.content.replaceAll('\n', ' '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(
          fontFamily: 'monospace',
          color: theme.colorScheme.onSurface.withAlpha(128),
        ),
      ),
    );
  }
}
