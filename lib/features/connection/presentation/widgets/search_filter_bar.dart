import 'package:flutter/material.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/features/connection/domain/entities/server_filter.dart';
import 'package:sshvault/features/connection/presentation/providers/folder_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/tag_providers.dart';
import 'package:sshvault/features/connection/presentation/widgets/filter_bottom_sheet.dart';

/// Compact strip rendering only the active filter chips.
///
/// Kept separate from the search input so the search input can live in a
/// FAB-triggered modal sheet while active chips stay visible inline.
class ActiveFilterChips extends ConsumerWidget {
  const ActiveFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(serverFilterProvider);
    final l10n = AppLocalizations.of(context)!;
    final chips = _buildActiveFilterChips(context, ref, filter, l10n);
    if (chips.isEmpty && filter.searchQuery.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: Spacing.sm),
      child: SizedBox(
        height: 36,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: Spacing.paddingHorizontalLg,
          children: [
            if (filter.searchQuery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: Spacing.sm),
                child: InputChip(
                  avatar: const Icon(Icons.search, size: 16),
                  label: Text('"${filter.searchQuery}"'),
                  onDeleted: () {
                    ref.read(serverFilterProvider.notifier).state = filter
                        .copyWith(searchQuery: '');
                  },
                ),
              ),
            ...chips,
            if (chips.isNotEmpty || filter.searchQuery.isNotEmpty) ...[
              Spacing.horizontalSm,
              ActionChip(
                label: Text(l10n.filterClearAll),
                avatar: const Icon(Icons.clear_all, size: 16),
                onPressed: () {
                  ref.read(serverFilterProvider.notifier).state =
                      const ServerFilter();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Modal bottom sheet exposing the search input + filter button.
///
/// Triggered by the search FAB so the input no longer competes with the
/// scrollable header for screen real estate.
Future<void> showServerSearchSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const _ServerSearchSheet(),
  );
}

class _ServerSearchSheet extends ConsumerStatefulWidget {
  const _ServerSearchSheet();

  @override
  ConsumerState<_ServerSearchSheet> createState() => _ServerSearchSheetState();
}

class _ServerSearchSheetState extends ConsumerState<_ServerSearchSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final filter = ref.read(serverFilterProvider);
    _controller = TextEditingController(text: filter.searchQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final filter = ref.watch(serverFilterProvider);
    final activeFilterCount = _countActiveFilters(filter);
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        Spacing.lg,
        Spacing.sm,
        Spacing.lg,
        viewInsets + Spacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: l10n.searchServers,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: filter.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            tooltip: l10n.filterClearAll,
                            onPressed: () {
                              _controller.clear();
                              ref.read(serverFilterProvider.notifier).state =
                                  filter.copyWith(searchQuery: '');
                            },
                          )
                        : null,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    ref.read(serverFilterProvider.notifier).state = filter
                        .copyWith(searchQuery: value);
                  },
                  onSubmitted: (_) => Navigator.of(context).pop(),
                ),
              ),
              Spacing.horizontalSm,
              Badge(
                isLabelVisible: activeFilterCount > 0,
                label: Text('$activeFilterCount'),
                child: IconButton.filledTonal(
                  icon: Icon(
                    Icons.tune,
                    color: activeFilterCount > 0
                        ? theme.colorScheme.primary
                        : null,
                  ),
                  tooltip: l10n.filterTitle,
                  onPressed: () => _showFilterSheet(filter),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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

  int _countActiveFilters(ServerFilter filter) {
    var count = 0;
    if (filter.groupId != null) count++;
    count += filter.tagIds.length;
    if (filter.isActive != null) count++;
    return count;
  }
}

List<Widget> _buildActiveFilterChips(
  BuildContext context,
  WidgetRef ref,
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
        padding: const EdgeInsets.only(right: Spacing.sm),
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
        padding: const EdgeInsets.only(right: Spacing.sm),
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
        padding: const EdgeInsets.only(right: Spacing.sm),
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
