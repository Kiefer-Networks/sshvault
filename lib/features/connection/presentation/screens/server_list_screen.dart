import 'package:flutter/material.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/routing/shell_navigation_provider.dart';
import 'package:shellvault/core/widgets/error_state.dart';
import 'package:shellvault/core/widgets/shell_aware_app_bar.dart';
import 'package:shellvault/features/connection/presentation/providers/server_providers.dart';
import 'package:shellvault/features/connection/presentation/widgets/confirm_dialog.dart';
import 'package:shellvault/features/connection/presentation/widgets/empty_state.dart';
import 'package:shellvault/features/connection/presentation/widgets/search_filter_bar.dart';
import 'package:shellvault/features/connection/presentation/widgets/server_grid_card.dart';
import 'package:shellvault/features/connection/presentation/widgets/server_list_tile.dart';
import 'package:shellvault/features/connection/presentation/widgets/view_mode_toggle.dart';
import 'package:shellvault/features/terminal/presentation/providers/terminal_providers.dart';

class ServerListScreen extends ConsumerWidget {
  const ServerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serversAsync = ref.watch(serverListProvider);
    final viewMode = ref.watch(viewModeProvider);

    final l10n = AppLocalizations.of(context)!;

    return AdaptiveScaffold.withAppBar(
      appBar: buildShellAppBar(
        context,
        title: l10n.serverListTitle,
        actions: [const ViewModeToggle(), const SizedBox(width: 8)],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addServerFab',
        onPressed: () => context.push('/server/new'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SearchFilterBar(),
          const SizedBox(height: 8),
          Expanded(
            child: serversAsync.when(
              data: (servers) {
                if (servers.isEmpty) {
                  return EmptyState(
                    icon: Icons.dns_outlined,
                    title: l10n.serverListEmpty,
                    subtitle: l10n.serverListEmptySubtitle,
                    action: FilledButton.icon(
                      onPressed: () => context.push('/server/new'),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.serverAddButton),
                    ),
                  );
                }

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: viewMode == ViewMode.list
                      ? _buildList(context, ref, servers)
                      : _buildGrid(context, ref, servers),
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator.adaptive()),
              error: (error, _) => ErrorState(
                error: error,
                onRetry: () => ref.invalidate(serverListProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref, List servers) {
    return ListView.separated(
      key: const ValueKey('list'),
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: servers.length,
      separatorBuilder: (_, _) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        final server = servers[index];
        return ServerListTile(
          server: server,
          onTap: () async {
            await ref
                .read(sessionManagerProvider.notifier)
                .openSession(server.id);
            ref
                .read(shellNavigationProvider)
                ?.goBranch(AppConstants.terminalBranchIndex);
          },
          onConnect: () async {
            await ref
                .read(sessionManagerProvider.notifier)
                .openSession(server.id);
            ref
                .read(shellNavigationProvider)
                ?.goBranch(AppConstants.terminalBranchIndex);
          },
          onDetail: () => context.push('/server/${server.id}'),
          onEdit: () => context.push('/server/${server.id}/edit'),
          onDuplicate: () async {
            final l10nDup = AppLocalizations.of(context)!;
            await ref
                .read(serverListProvider.notifier)
                .duplicateServer(
                  server.id,
                  copySuffix: l10nDup.serverCopySuffix,
                );
            if (context.mounted) {
              AdaptiveNotification.show(
                context,
                message: l10nDup.serverDuplicated,
              );
            }
          },
          onDelete: () async {
            final l10n = AppLocalizations.of(context)!;
            final confirmed = await ConfirmDialog.show(
              context,
              title: l10n.serverDeleteTitle,
              message: l10n.serverDeleteMessage(server.name),
            );
            if (confirmed == true) {
              await ref
                  .read(serverListProvider.notifier)
                  .deleteServer(server.id);
            }
          },
        );
      },
    );
  }

  Widget _buildGrid(BuildContext context, WidgetRef ref, List servers) {
    return GridView.builder(
      key: const ValueKey('grid'),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: servers.length,
      itemBuilder: (context, index) {
        final server = servers[index];
        return ServerGridCard(
          server: server,
          onTap: () async {
            await ref
                .read(sessionManagerProvider.notifier)
                .openSession(server.id);
            ref
                .read(shellNavigationProvider)
                ?.goBranch(AppConstants.terminalBranchIndex);
          },
          onDetail: () => context.push('/server/${server.id}'),
          onEdit: () => context.push('/server/${server.id}/edit'),
          onLongPress: () {
            _showServerActions(context, ref, server);
          },
        );
      },
    );
  }

  void _showServerActions(BuildContext context, WidgetRef ref, server) {
    final l10n = AppLocalizations.of(context)!;
    showAdaptiveActionSheet(
      context,
      title: server.name,
      actions: [
        AdaptiveAction(
          label: l10n.serverConnect,
          icon: Icons.terminal,
          onPressed: () async {
            await ref
                .read(sessionManagerProvider.notifier)
                .openSession(server.id);
            ref
                .read(shellNavigationProvider)
                ?.goBranch(AppConstants.terminalBranchIndex);
          },
        ),
        AdaptiveAction(
          label: l10n.serverDetails,
          icon: Icons.info_outlined,
          onPressed: () => context.push('/server/${server.id}'),
        ),
        AdaptiveAction(
          label: l10n.edit,
          icon: Icons.edit,
          onPressed: () => context.push('/server/${server.id}/edit'),
        ),
        AdaptiveAction(
          label: l10n.serverDuplicate,
          icon: Icons.copy,
          onPressed: () async {
            await ref
                .read(serverListProvider.notifier)
                .duplicateServer(server.id, copySuffix: l10n.serverCopySuffix);
          },
        ),
        AdaptiveAction(
          label: l10n.delete,
          icon: Icons.delete,
          isDestructive: true,
          onPressed: () async {
            final confirmed = await ConfirmDialog.show(
              context,
              title: l10n.serverDeleteTitle,
              message: l10n.serverDeleteShort(server.name),
            );
            if (confirmed == true) {
              await ref
                  .read(serverListProvider.notifier)
                  .deleteServer(server.id);
            }
          },
        ),
      ],
      cancelLabel: l10n.cancel,
    );
  }
}
