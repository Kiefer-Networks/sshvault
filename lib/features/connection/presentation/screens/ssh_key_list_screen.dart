import 'package:flutter/material.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
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

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: buildShellAppBar(context, title: l10n.sshKeyListTitle),
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
                    l10n.sshKeyListEmpty,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.sshKeyListEmptySubtitle,
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
          child: Text(l10n.error(error.toString())),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addSshKeyFab',
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
    final l10n = AppLocalizations.of(context)!;

    if (key.linkedServerCount > 0) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(AppLocalizations.of(ctx)!.sshKeyCannotDeleteTitle),
          content: Text(
            AppLocalizations.of(ctx)!.sshKeyCannotDeleteMessage(
              key.name,
              key.linkedServerCount,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(AppLocalizations.of(ctx)!.close),
            ),
          ],
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx)!.sshKeyDeleteTitle),
        content: Text(AppLocalizations.of(ctx)!.sshKeyDeleteMessage(key.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(ctx)!.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: Text(AppLocalizations.of(ctx)!.delete),
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
            SnackBar(content: Text(l10n.error(e.toString()))),
          );
        }
      }
    }
  }
}
