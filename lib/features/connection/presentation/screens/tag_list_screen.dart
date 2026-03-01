import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return Scaffold(
      appBar: buildShellAppBar(context, title: 'Tags'),
      body: tagsAsync.when(
        data: (tags) {
          if (tags.isEmpty) {
            return EmptyState(
              icon: Icons.label_outline,
              title: 'No tags yet',
              subtitle: 'Create tags to label and filter your servers.',
              action: FilledButton.icon(
                onPressed: () => _showTagForm(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Add Tag'),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: tags.length,
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
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTagForm(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showTagForm(BuildContext context, WidgetRef ref, {TagEntity? tag}) {
    TagFormDialog.show(context, ref, tag: tag);
  }

  Future<void> _deleteTag(
    BuildContext context,
    WidgetRef ref,
    TagEntity tag,
  ) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Delete Tag',
      message: 'Delete "${tag.name}"? It will be removed from all servers.',
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
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Color(tag.color).withAlpha(26),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.label, color: Color(tag.color), size: 20),
      ),
      title: Text(tag.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete, size: 20, color: theme.colorScheme.error),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
