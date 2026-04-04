import 'package:flutter/material.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/features/connection/domain/entities/server_filter.dart';
import 'package:sshvault/features/connection/presentation/providers/folder_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/tag_providers.dart';
import 'package:sshvault/features/connection/presentation/widgets/filter_bottom_sheet.dart';

class SearchFilterBar extends ConsumerStatefulWidget {
  const SearchFilterBar({super.key});

  @override
  ConsumerState<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends ConsumerState<SearchFilterBar> {
  final _searchController = SearchController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(serverFilterProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final activeFilterCount = _countActiveFilters(filter);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search bar + filter button
        Padding(
          padding: Spacing.paddingHorizontalLg,
          child: Row(
            children: [
              Expanded(
                child: SearchBar(
                  controller: _searchController,
                  hintText: l10n.searchServers,
                  leading: const Icon(Icons.search, size: 20),
                  trailing: [
                    if (filter.searchQuery.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(serverFilterProvider.notifier).state = filter
                              .copyWith(searchQuery: '');
                        },
                      ),
                  ],
                  onChanged: (value) {
                    ref.read(serverFilterProvider.notifier).state = filter
                        .copyWith(searchQuery: value);
                  },
                ),
              ),
              Spacing.horizontalSm,
              Badge(
                isLabelVisible: activeFilterCount > 0,
                label: Text('$activeFilterCount'),
                child: IconButton(
                  icon: Icon(
                    Icons.tune,
                    color: activeFilterCount > 0
                        ? theme.colorScheme.primary
                        : null,
                  ),
                  onPressed: () => _showFilterSheet(filter),
                ),
              ),
            ],
          ),
        ),

        // Active filter chips
        if (activeFilterCount > 0) ...[
          Spacing.verticalSm,
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: Spacing.paddingHorizontalLg,
              children: [
                ..._buildActiveFilterChips(filter, l10n),
                Spacing.horizontalSm,
                ActionChip(
                  label: Text(l10n.filterClearAll),
                  avatar: const Icon(Icons.clear_all, size: 16),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(serverFilterProvider.notifier).state =
                        const ServerFilter();
                  },
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  int _countActiveFilters(ServerFilter filter) {
    var count = 0;
    if (filter.groupId != null) count++;
    count += filter.tagIds.length;
    if (filter.isActive != null) count++;
    return count;
  }

  List<Widget> _buildActiveFilterChips(
    ServerFilter filter,
    AppLocalizations l10n,
  ) {
    final chips = <Widget>[];

    if (filter.groupId != null) {
      final foldersAsync = ref.read(folderListProvider);
      final folderName =
          foldersAsync.value
              ?.where((g) => g.id == filter.groupId)
              .firstOrNull
              ?.name ??
          '';
      chips.add(
        Padding(
          padding: EdgeInsets.only(right: Spacing.sm),
          child: InputChip(
            label: Text('${l10n.filterFolder}: $folderName'),
            onDeleted: () {
              ref.read(serverFilterProvider.notifier).state = filter.copyWith(
                groupId: null,
              );
            },
          ),
        ),
      );
    }

    for (final tagId in filter.tagIds) {
      final tagsAsync = ref.read(tagListProvider);
      final tagName =
          tagsAsync.value?.where((t) => t.id == tagId).firstOrNull?.name ?? '';
      chips.add(
        Padding(
          padding: EdgeInsets.only(right: Spacing.sm),
          child: InputChip(
            label: Text(tagName),
            onDeleted: () {
              final newTagIds = List<String>.from(filter.tagIds)..remove(tagId);
              ref.read(serverFilterProvider.notifier).state = filter.copyWith(
                tagIds: newTagIds,
              );
            },
          ),
        ),
      );
    }

    if (filter.isActive != null) {
      chips.add(
        Padding(
          padding: EdgeInsets.only(right: Spacing.sm),
          child: InputChip(
            label: Text(
              filter.isActive! ? l10n.filterActive : l10n.filterInactive,
            ),
            onDeleted: () {
              ref.read(serverFilterProvider.notifier).state = filter.copyWith(
                isActive: null,
              );
            },
          ),
        ),
      );
    }

    return chips;
  }

  Future<void> _showFilterSheet(ServerFilter currentFilter) async {
    final result = await FilterBottomSheet.show(
      context,
      currentFilter: currentFilter,
    );
    if (result != null) {
      ref.read(serverFilterProvider.notifier).state = result;
    }
  }
}
