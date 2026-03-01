import 'package:flutter/material.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shellvault/core/widgets/error_state.dart';
import 'package:shellvault/core/widgets/shell_aware_app_bar.dart';
import 'package:shellvault/features/connection/domain/entities/tag_entity.dart';
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

    return Scaffold(
      appBar: buildShellAppBar(context, title: l10n.tagListTitle),
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
            separatorBuilder: (_, _) =>
                const Divider(height: 1, indent: 72),
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorState(
          error: error,
          onRetry: () => ref.invalidate(tagListProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addTagFab',
        onPressed: () => _showTagForm(context, ref),
        child: const Icon(Icons.add),
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

class _TagTile extends StatelessWidget {
  final TagEntity tag;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TagTile({
    required this.tag,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

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
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Color(tag.color).withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.label, color: Color(tag.color), size: 22),
        ),
        title: Text(tag.name),
        subtitle: Text(
          _colorHex(tag.color),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(153),
            fontFamily: 'monospace',
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
              tooltip: l10n.edit,
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: theme.colorScheme.error),
              onPressed: onDelete,
              tooltip: l10n.delete,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        onTap: onEdit,
      ),
    );
  }

  String _colorHex(int color) {
    return '#${(color & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }
}
