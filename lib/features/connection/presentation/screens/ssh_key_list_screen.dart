import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/widgets/shell_aware_app_bar.dart';
import 'package:shellvault/features/connection/presentation/providers/ssh_key_providers.dart';
import 'package:shellvault/features/connection/presentation/screens/ssh_key_form_dialog.dart';
import 'package:shellvault/features/connection/presentation/widgets/ssh_key_tile.dart';

class SshKeyListScreen extends ConsumerWidget {
  const SshKeyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keysAsync = ref.watch(sshKeyListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: buildShellAppBar(context, title: 'SSH Keys'),
      body: keysAsync.when(
        data: (keys) {
          if (keys.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.vpn_key_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No SSH keys yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Generate or import SSH keys to manage them centrally',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(sshKeyListProvider.notifier).refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: keys.length,
              itemBuilder: (context, index) {
                final key = keys[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SshKeyTile(
                    sshKey: key,
                    onEdit: () => _editKey(context, ref, key),
                    onDelete: () => _deleteKey(context, ref, key),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('Error: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addKey(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addKey(BuildContext context, WidgetRef ref) async {
    await SshKeyFormDialog.show(context);
  }

  Future<void> _editKey(
    BuildContext context,
    WidgetRef ref,
    dynamic key,
  ) async {
    await SshKeyFormDialog.show(context, existingKey: key);
  }

  Future<void> _deleteKey(
    BuildContext context,
    WidgetRef ref,
    dynamic key,
  ) async {
    if (key.linkedServerCount > 0) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Cannot Delete'),
          content: Text(
            "Cannot delete '${key.name}'. "
            'Used by ${key.linkedServerCount} server(s). '
            'Unlink from all servers first.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ],
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete SSH Key'),
        content: Text("Delete '${key.name}'? This cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(sshKeyListProvider.notifier).deleteSshKey(key.id);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }
}
