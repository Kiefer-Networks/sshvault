import 'package:flutter/material.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/core/widgets/error_state.dart';
import 'package:sshvault/core/widgets/shell_aware_app_bar.dart';
import 'package:sshvault/features/connection/domain/entities/tag_entity.dart';
import 'package:sshvault/features/connection/domain/entities/server_filter.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/tag_providers.dart';
import 'package:sshvault/features/snippet/presentation/providers/snippet_providers.dart';
import 'package:sshvault/features/connection/presentation/screens/tag_form_dialog.dart';
import 'package:sshvault/features/connection/presentation/widgets/confirm_dialog.dart';
import 'package:sshvault/features/connection/presentation/widgets/empty_state.dart';

class TagListScreen extends ConsumerWidget {
  /// Tighter rows for the desktop Tags master/detail column — see
  /// `TagsMasterDetail`.
  final bool dense;

  /// When set (desktop master/detail), tapping a tag selects it for the
  /// detail pane instead of the mobile behavior of jumping to the Hosts
  /// list pre-filtered by that tag.
  final ValueChanged<String>? onTagSelected;

  /// Overrides the "+" FAB (desktop master/detail only) to open the
  /// inline create form in the detail pane instead of the mobile/default
  /// full-screen `TagFormDialog`.
  final VoidCallback? onAddPressed;

  const TagListScreen({
    super.key,
    this.dense = false,
    this.onTagSelected,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(tagListProvider);
    final selectedId = dense ? ref.watch(desktopSelectedTagIdProvider) : null;

    final l10n = AppLocalizations.of(context)!;

    return AdaptiveScaffold.withAppBar(
      appBar: buildShellAppBar(
        context,
        title: l10n.tagListTitle,
        actions: null,
      ),
      floatingActionButton: Tooltip(
        message: l10n.tagAddButton,
        child: FloatingActionButton(
          heroTag: 'addTagFab',
          tooltip: l10n.tagAddButton,
          onPressed: onAddPressed ?? () => _showTagForm(context, ref),
          child: const Icon(Icons.add),
        ),
      ),
      body: tagsAsync.when(
        data: (tags) {
          if (tags.isEmpty) {
            return EmptyState(
              icon: Icons.label_outline,
              title: l10n.tagListEmpty,
              subtitle: l10n.tagListEmptySubtitle,
              action: FilledButton.icon(
                onPressed: () => _showTagForm(context, ref),
                icon: const Icon(Icons.add),
                label: Text(l10n.tagAddButton),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.only(bottom: Spacing.fabClearance),
            itemCount: tags.length,
            separatorBuilder: (_, _) => Spacing.verticalXxs,
            itemBuilder: (context, index) {
              final tag = tags[index];
              return Semantics(
                label: tag.name,
                child: _TagTile(
                  tag: tag,
                  dense: dense,
                  selected: tag.id == selectedId,
                  onTap: onTagSelected == null
                      ? null
                      : () => onTagSelected!(tag.id),
                  onEdit: () => _showTagForm(context, ref, tag: tag),
                  onDelete: () => _deleteTag(context, ref, tag),
                ),
              );
            },
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) => ErrorState(
          error: error,
          onRetry: () => ref.invalidate(tagListProvider),
        ),
      ),
    );
  }

  void _showTagForm(BuildContext context, WidgetRef ref, {TagEntity? tag}) {
    TagFormDialog.show(context, tag: tag);
  }

  Future<void> _deleteTag(
    BuildContext context,
    WidgetRef ref,
    TagEntity tag,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.tagDeleteTitle,
      message: l10n.tagDeleteMessage(tag.name),
    );
    if (confirmed == true) {
      await ref.read(tagListProvider.notifier).deleteTag(tag.id);
      if (context.mounted) {
        AdaptiveNotification.show(context, message: l10n.tagDeletedSuccess);
      }
    }
  }
}

class _TagTile extends ConsumerWidget {
  final TagEntity tag;
  final bool dense;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TagTile({
    required this.tag,
    this.dense = false,
    this.selected = false,
    this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final tagColor = Color(tag.color);
    final serverCountAsync = ref.watch(serverCountByTagProvider(tag.id));
    final snippetCountAsync = ref.watch(snippetCountByTagProvider(tag.id));
    final iconSize = dense ? 30.0 : 40.0;

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onEdit(),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            icon: Icons.edit,
            label: l10n.edit,
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
            icon: Icons.delete,
            label: l10n.delete,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.primary.withAlpha(22) : null,
          border: Border(left: BorderSide(color: tagColor, width: 4)),
        ),
        child: ListTile(
          dense: dense,
          visualDensity: dense ? VisualDensity.compact : null,
          contentPadding: dense
              ? const EdgeInsets.symmetric(horizontal: 12, vertical: 2)
              : null,
          leading: Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: tagColor.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.label, color: tagColor, size: dense ? 16 : 22),
          ),
          title: Text(
            tag.name,
            style: dense ? const TextStyle(fontSize: 13.5) : null,
          ),
          subtitle: Builder(
            builder: (_) {
              final serverCount = serverCountAsync.whenOrNull(data: (c) => c);
              final snippetCount = snippetCountAsync.whenOrNull(data: (c) => c);
              final parts = <String>[];
              if (serverCount != null) {
                parts.add(l10n.tagServerCount(serverCount));
              }
              if (snippetCount != null) {
                parts.add(l10n.tagSnippetCount(snippetCount));
              }
              if (parts.isEmpty) return const SizedBox.shrink();
              return Text(
                parts.join(' · '),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              );
            },
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                onPressed: onEdit,
                tooltip: l10n.edit,
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: theme.colorScheme.error,
                ),
                onPressed: onDelete,
                tooltip: l10n.delete,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          onTap:
              onTap ??
              () {
                // Mobile only: navigate to hosts filtered by this tag.
                ref.read(serverFilterProvider.notifier).state = ServerFilter(
                  tagIds: [tag.id],
                );
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
        ),
      ),
    );
  }
}
