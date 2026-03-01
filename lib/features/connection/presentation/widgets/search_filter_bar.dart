import 'package:flutter/material.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/features/connection/domain/entities/server_filter.dart';
import 'package:shellvault/features/connection/presentation/providers/group_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/server_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/tag_providers.dart';
import 'package:shellvault/features/connection/presentation/widgets/group_chip.dart';
import 'package:shellvault/features/connection/presentation/widgets/tag_chip.dart';

class SearchFilterBar extends ConsumerStatefulWidget {
  const SearchFilterBar({super.key});

  @override
  ConsumerState<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends ConsumerState<SearchFilterBar> {
  final _searchController = TextEditingController();
  bool _showFilters = false;

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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.searchServers,
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: filter.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              ref.read(serverFilterProvider.notifier).state =
                                  filter.copyWith(searchQuery: '');
                            },
                          )
                        : null,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    ref.read(serverFilterProvider.notifier).state =
                        filter.copyWith(searchQuery: value);
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  _showFilters
                      ? Icons.filter_list_off
                      : Icons.filter_list,
                  color: _hasActiveFilters(filter)
                      ? theme.colorScheme.primary
                      : null,
                ),
                onPressed: () =>
                    setState(() => _showFilters = !_showFilters),
              ),
            ],
          ),
        ),
        if (_showFilters) ...[
          const SizedBox(height: 12),
          _buildGroupFilter(filter, l10n),
          const SizedBox(height: 8),
          _buildTagFilter(filter),
          const SizedBox(height: 8),
          _buildStatusFilter(filter, l10n),
        ],
      ],
    );
  }

  bool _hasActiveFilters(ServerFilter filter) {
    return filter.groupId != null ||
        filter.tagIds.isNotEmpty ||
        filter.isActive != null;
  }

  Widget _buildGroupFilter(ServerFilter filter, AppLocalizations l10n) {
    final groupsAsync = ref.watch(groupListProvider);
    return SizedBox(
      height: 36,
      child: groupsAsync.when(
        data: (groups) => ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            FilterChip(
              label: Text(l10n.filterAllGroups),
              selected: filter.groupId == null,
              onSelected: (_) {
                ref.read(serverFilterProvider.notifier).state =
                    filter.copyWith(groupId: null);
              },
            ),
            const SizedBox(width: 8),
            ...groups.map(
              (group) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GroupChip(
                  group: group,
                  selected: filter.groupId == group.id,
                  onTap: () {
                    ref.read(serverFilterProvider.notifier).state =
                        filter.copyWith(
                      groupId:
                          filter.groupId == group.id ? null : group.id,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        loading: () => const SizedBox.shrink(),
        error: (_, _) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildTagFilter(ServerFilter filter) {
    final tagsAsync = ref.watch(tagListProvider);
    return SizedBox(
      height: 36,
      child: tagsAsync.when(
        data: (tags) => ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: tags
              .map(
                (tag) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: TagChip(
                    tag: tag,
                    selected: filter.tagIds.contains(tag.id),
                    onTap: () {
                      final newTagIds = List<String>.from(filter.tagIds);
                      if (newTagIds.contains(tag.id)) {
                        newTagIds.remove(tag.id);
                      } else {
                        newTagIds.add(tag.id);
                      }
                      ref.read(serverFilterProvider.notifier).state =
                          filter.copyWith(tagIds: newTagIds);
                    },
                  ),
                ),
              )
              .toList(),
        ),
        loading: () => const SizedBox.shrink(),
        error: (_, _) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildStatusFilter(ServerFilter filter, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          FilterChip(
            label: Text(l10n.filterAll),
            selected: filter.isActive == null,
            onSelected: (_) {
              ref.read(serverFilterProvider.notifier).state =
                  filter.copyWith(isActive: null);
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: Text(l10n.filterActive),
            selected: filter.isActive == true,
            onSelected: (_) {
              ref.read(serverFilterProvider.notifier).state =
                  filter.copyWith(
                isActive: filter.isActive == true ? null : true,
              );
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: Text(l10n.filterInactive),
            selected: filter.isActive == false,
            onSelected: (_) {
              ref.read(serverFilterProvider.notifier).state =
                  filter.copyWith(
                isActive: filter.isActive == false ? null : false,
              );
            },
          ),
          const Spacer(),
          if (_hasActiveFilters(filter))
            TextButton.icon(
              icon: const Icon(Icons.clear_all, size: 18),
              label: Text(l10n.filterClear),
              onPressed: () {
                ref.read(serverFilterProvider.notifier).state =
                    const ServerFilter();
              },
            ),
        ],
      ),
    );
  }
}
