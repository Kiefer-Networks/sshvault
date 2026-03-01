import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/constants/icon_constants.dart';
import 'package:shellvault/features/connection/domain/entities/group_entity.dart';
import 'package:shellvault/features/connection/presentation/providers/group_providers.dart';
import 'package:shellvault/features/connection/presentation/screens/group_form_dialog.dart';
import 'package:shellvault/features/connection/presentation/widgets/confirm_dialog.dart';
import 'package:shellvault/features/connection/presentation/widgets/empty_state.dart';

class GroupListScreen extends ConsumerWidget {
  const GroupListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(groupListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
      ),
      body: groupsAsync.when(
        data: (groups) {
          if (groups.isEmpty) {
            return EmptyState(
              icon: Icons.folder_outlined,
              title: 'No groups yet',
              subtitle: 'Create groups to organize your servers.',
              action: FilledButton.icon(
                onPressed: () => _showGroupForm(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Add Group'),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return _GroupTile(
                group: group,
                onEdit: () => _showGroupForm(context, ref, group: group),
                onDelete: () => _deleteGroup(context, ref, group),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showGroupForm(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showGroupForm(
    BuildContext context,
    WidgetRef ref, {
    GroupEntity? group,
  }) {
    GroupFormDialog.show(context, ref, group: group);
  }

  Future<void> _deleteGroup(
    BuildContext context,
    WidgetRef ref,
    GroupEntity group,
  ) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Delete Group',
      message:
          'Delete "${group.name}"? Servers in this group will become ungrouped.',
    );
    if (confirmed == true) {
      await ref.read(groupListProvider.notifier).deleteGroup(group.id);
    }
  }
}

class _GroupTile extends StatelessWidget {
  final GroupEntity group;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _GroupTile({
    required this.group,
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
          color: Color(group.color).withAlpha(26),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          IconConstants.getIcon(group.iconName),
          color: Color(group.color),
          size: 20,
        ),
      ),
      title: Text(group.name),
      subtitle: Text(
        '${group.serverCount} server${group.serverCount == 1 ? '' : 's'}',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withAlpha(128),
        ),
      ),
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
