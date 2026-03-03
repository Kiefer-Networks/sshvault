import 'package:flutter/material.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shellvault/core/widgets/error_state.dart';
import 'package:shellvault/core/widgets/shell_aware_app_bar.dart';
import 'package:shellvault/features/connection/domain/entities/tag_entity.dart';
import 'package:shellvault/features/connection/domain/entities/server_filter.dart';
import 'package:shellvault/features/connection/presentation/providers/server_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/tag_providers.dart';
import 'package:shellvault/features/connection/presentation/screens/tag_form_dialog.dart';
import 'package:shellvault/features/connection/presentation/widgets/confirm_dialog.dart';
import 'package:shellvault/features/connection/presentation/widgets/empty_state.dart';

class TagListScreen extends ConsumerWidget {
  const TagListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(tagListProvider);

    final l10n = AppLocalizations.of(context)!;

    return AdaptiveScaffold.withAppBar(
      appBar: buildShellAppBar(
        context,
        title: l10n.tagListTitle,
        actions: null,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addTagFab',
        onPressed: () => _showTagForm(context, ref),
        child: const Icon(Icons.add),
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
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: tags.length,
            separatorBuilder: (_, _) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              final tag = tags[index];
              return _TagTile(
                tag: tag,
                onEdit: () => _showTagForm(context, ref, tag: tag),
                onDelete: () => _deleteTag(context, ref, tag),
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
    }
  }
}

class _TagTile extends ConsumerWidget {
  final TagEntity tag;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TagTile({
    required this.tag,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final tagColor = Color(tag.color);
    final serverCountAsync = ref.watch(serverCountByTagProvider(tag.id));

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onEdit(),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: l10n.edit,
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: theme.colorScheme.error,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: l10n.delete,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: tagColor, width: 4)),
        ),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tagColor.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.label, color: tagColor, size: 22),
          ),
          title: Text(tag.name),
          subtitle: serverCountAsync.when(
            data: (count) => Text(
              l10n.tagServerCount(count),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            loading: () => null,
            error: (_, _) => null,
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
          onTap: () {
            // Navigate to hosts filtered by this tag
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
