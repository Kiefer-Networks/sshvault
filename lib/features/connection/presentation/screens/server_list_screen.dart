import 'package:flutter/material.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/core/routing/shell_navigation_provider.dart';
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

    return Scaffold(
      appBar: buildShellAppBar(
        context,
        title: l10n.serverListTitle,
        actions: const [ViewModeToggle(), SizedBox(width: 8)],
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
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 16),
                    Text(l10n.error(error.toString())),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => ref.invalidate(serverListProvider),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addServerFab',
        onPressed: () => context.push('/server/new'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref, List servers) {
    return ListView.separated(
      key: const ValueKey('list'),
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: servers.length,
      separatorBuilder: (_, _) => const Divider(height: 1, indent: 72),
      itemBuilder: (context, index) {
        final server = servers[index];
        return ServerListTile(
          server: server,
          onTap: () async {
            await ref
                .read(sessionManagerProvider.notifier)
                .openSession(server.id);
            ref.read(shellNavigationProvider)?.goBranch(6);
          },
          onConnect: () async {
            await ref
                .read(sessionManagerProvider.notifier)
                .openSession(server.id);
            ref.read(shellNavigationProvider)?.goBranch(6);
          },
          onDetail: () => context.push('/server/${server.id}'),
          onEdit: () => context.push('/server/${server.id}/edit'),
          onDuplicate: () async {
            await ref
                .read(serverListProvider.notifier)
                .duplicateServer(server.id);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.serverDuplicated)),
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
            ref.read(shellNavigationProvider)?.goBranch(6);
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
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.terminal),
              title: Text(l10n.serverConnect),
              onTap: () async {
                Navigator.pop(ctx);
                await ref
                    .read(sessionManagerProvider.notifier)
                    .openSession(server.id);
                ref.read(shellNavigationProvider)?.goBranch(6);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outlined),
              title: Text(l10n.serverDetails),
              onTap: () {
                Navigator.pop(ctx);
                context.push('/server/${server.id}');
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(l10n.edit),
              onTap: () {
                Navigator.pop(ctx);
                context.push('/server/${server.id}/edit');
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: Text(l10n.serverDuplicate),
              onTap: () async {
                Navigator.pop(ctx);
                await ref
                    .read(serverListProvider.notifier)
                    .duplicateServer(server.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete,
                  color: Theme.of(context).colorScheme.error),
              title: Text(l10n.delete,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error)),
              onTap: () async {
                Navigator.pop(ctx);
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
        ),
      ),
    );
  }
}
