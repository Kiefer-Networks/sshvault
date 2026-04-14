import 'package:flutter/material.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/core/widgets/error_state.dart';
import 'package:sshvault/core/widgets/shell_aware_app_bar.dart';
import 'package:sshvault/features/connection/domain/entities/ssh_key_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/ssh_key_providers.dart';
import 'package:sshvault/features/connection/presentation/screens/ssh_key_form_dialog.dart';
import 'package:sshvault/features/connection/presentation/widgets/confirm_dialog.dart';
import 'package:sshvault/features/connection/presentation/widgets/empty_state.dart';
import 'package:sshvault/features/connection/presentation/widgets/ssh_key_tile.dart';

class SshKeyListScreen extends ConsumerWidget {
  const SshKeyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keysAsync = ref.watch(sshKeyListProvider);

    final l10n = AppLocalizations.of(context)!;

    return AdaptiveScaffold.withAppBar(
      appBar: buildShellAppBar(
        context,
        title: l10n.sshKeyListTitle,
        actions: null,
      ),
      floatingActionButton: Tooltip(
        message: l10n.sshKeyAddButton,
        child: FloatingActionButton(
          heroTag: 'addSshKeyFab',
          tooltip: l10n.sshKeyAddButton,
          onPressed: () => _addKey(context, ref),
          child: const Icon(Icons.add),
        ),
      ),
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
            padding: const EdgeInsets.only(bottom: Spacing.fabClearance),
            itemCount: keys.length,
            separatorBuilder: (_, _) => Spacing.verticalXxs,
            itemBuilder: (context, index) {
              final key = keys[index];
              return Semantics(
                label: '${key.name}, ${key.keyType.displayName}',
                child: SshKeyTile(
                  sshKey: key,
                  onEdit: () => _editKey(context, ref, key),
                  onDelete: () => _deleteKey(context, ref, key),
                ),
              );
            },
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) => ErrorState(
          error: error,
          onRetry: () => ref.invalidate(sshKeyListProvider),
        ),
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
            AppLocalizations.of(
              ctx,
            )!.sshKeyCannotDeleteMessage(key.name, key.linkedServerCount),
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
        if (context.mounted) {
          AdaptiveNotification.show(
            context,
            message: l10n.sshKeyDeletedSuccess,
          );
        }
      } catch (e) {
        if (context.mounted) {
          AdaptiveNotification.show(
            context,
            message: l10n.error(errorMessage(e)),
          );
        }
      }
    }
  }
}
