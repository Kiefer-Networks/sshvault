import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/features/connection/domain/entities/group_entity.dart';
import 'package:shellvault/features/connection/domain/entities/server_filter.dart';
import 'package:shellvault/features/connection/presentation/providers/folder_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/tag_providers.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  final ServerFilter currentFilter;

  const FilterBottomSheet({super.key, required this.currentFilter});

  static Future<ServerFilter?> show(
    BuildContext context, {
    required ServerFilter currentFilter,
  }) {
    return showModalBottomSheet<ServerFilter>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => FilterBottomSheet(currentFilter: currentFilter),
    );
  }

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late String? _groupId;
  late List<String> _tagIds;
  late bool? _isActive;

  List<Widget> _buildFolderFilterTree(List<GroupEntity> folders, int depth) {
    final widgets = <Widget>[];
    for (final folder in folders) {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(left: depth * 16.0),
          child: FilterChip(
            avatar: Icon(Icons.folder, size: 18, color: Color(folder.color)),
            label: Text(folder.name),
            selected: _groupId == folder.id,
            onSelected: (_) => setState(() {
              _groupId = _groupId == folder.id ? null : folder.id;
            }),
          ),
        ),
      );
      if (folder.children.isNotEmpty) {
        widgets.addAll(_buildFolderFilterTree(folder.children, depth + 1));
      }
    }
    return widgets;
  }

  @override
  void initState() {
    super.initState();
    _groupId = widget.currentFilter.groupId;
    _tagIds = List.from(widget.currentFilter.tagIds);
    _isActive = widget.currentFilter.isActive;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final foldersAsync = ref.watch(folderTreeProvider);
    final tagsAsync = ref.watch(tagListProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.85,
      builder: (context, scrollController) => Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(l10n.filterTitle, style: theme.textTheme.titleLarge),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _groupId = null;
                      _tagIds = [];
                      _isActive = null;
                    });
                  },
                  child: Text(l10n.filterClearAll),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Scrollable content
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Folder filter
                Text(l10n.filterFolder, style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                foldersAsync.when(
                  data: (folders) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FilterChip(
                        label: Text(l10n.filterAllFolders),
                        selected: _groupId == null,
                        onSelected: (_) => setState(() => _groupId = null),
                      ),
                      const SizedBox(height: 4),
                      ..._buildFolderFilterTree(folders, 0),
                    ],
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 16),

                // Tag filter
                Text(l10n.filterTags, style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                tagsAsync.when(
                  data: (tags) => Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      for (final tag in tags)
                        FilterChip(
                          avatar: Icon(
                            Icons.label,
                            size: 18,
                            color: Color(tag.color),
                          ),
                          label: Text(tag.name),
                          selected: _tagIds.contains(tag.id),
                          onSelected: (_) => setState(() {
                            if (_tagIds.contains(tag.id)) {
                              _tagIds.remove(tag.id);
                            } else {
                              _tagIds.add(tag.id);
                            }
                          }),
                        ),
                    ],
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 16),

                // Status filter
                Text(l10n.filterStatus, style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    FilterChip(
                      label: Text(l10n.filterAll),
                      selected: _isActive == null,
                      onSelected: (_) => setState(() => _isActive = null),
                    ),
                    FilterChip(
                      label: Text(l10n.filterActive),
                      selected: _isActive == true,
                      onSelected: (_) => setState(
                        () => _isActive = _isActive == true ? null : true,
                      ),
                    ),
                    FilterChip(
                      label: Text(l10n.filterInactive),
                      selected: _isActive == false,
                      onSelected: (_) => setState(
                        () => _isActive = _isActive == false ? null : false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Apply button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    ServerFilter(
                      searchQuery: widget.currentFilter.searchQuery,
                      groupId: _groupId,
                      tagIds: _tagIds,
                      isActive: _isActive,
                    ),
                  );
                },
                child: Text(l10n.filterApply),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
