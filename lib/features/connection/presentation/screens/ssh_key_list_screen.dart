import 'package:flutter/material.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/widgets/shell_aware_app_bar.dart';
import 'package:shellvault/features/connection/domain/entities/ssh_key_entity.dart';
import 'package:shellvault/features/connection/presentation/providers/ssh_key_providers.dart';
import 'package:shellvault/features/connection/presentation/screens/ssh_key_form_dialog.dart';
import 'package:shellvault/features/connection/presentation/widgets/confirm_dialog.dart';
import 'package:shellvault/features/connection/presentation/widgets/empty_state.dart';
import 'package:shellvault/features/connection/presentation/widgets/ssh_key_tile.dart';

class SshKeyListScreen extends ConsumerWidget {
  const SshKeyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keysAsync = ref.watch(sshKeyListProvider);

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: buildShellAppBar(context, title: l10n.sshKeyListTitle),
      body: keysAsync.when(
        data: (keys) {
          if (keys.isEmpty) {
            return EmptyState(
              icon: Icons.vpn_key_outlined,
              title: l10n.sshKeyListEmpty,
              subtitle: l10n.sshKeyListEmptySubtitle,
              action: FilledButton.icon(
                onPressed: () => _addKey(context, ref),
                icon: const Icon(Icons.add),
                label: Text(l10n.sshKeyAddButton),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: keys.length,
            separatorBuilder: (_, _) =>
                const Divider(height: 1, indent: 72),
            itemBuilder: (context, index) {
              final key = keys[index];
              return SshKeyTile(
                sshKey: key,
                onEdit: () => _editKey(context, ref, key),
                onDelete: () => _deleteKey(context, ref, key),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              Text(l10n.error(error.toString())),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(sshKeyListProvider),
                child: Text(l10n.retry),
              ),
            ],
          ),
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
    SshKeyEntity key,
  ) async {
    await SshKeyFormDialog.show(context, existingKey: key);
  }

  Future<void> _deleteKey(
    BuildContext context,
    WidgetRef ref,
    SshKeyEntity key,
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

    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.sshKeyDeleteTitle,
      message: l10n.sshKeyDeleteMessage(key.name),
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
