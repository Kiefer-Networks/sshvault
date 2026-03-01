import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/core/widgets/shell_aware_app_bar.dart';
import 'package:shellvault/features/connection/presentation/providers/server_providers.dart';
import 'package:shellvault/features/connection/presentation/widgets/confirm_dialog.dart';
import 'package:shellvault/features/connection/presentation/widgets/empty_state.dart';
import 'package:shellvault/features/connection/presentation/widgets/search_filter_bar.dart';
import 'package:shellvault/features/connection/presentation/widgets/server_grid_card.dart';
import 'package:shellvault/features/connection/presentation/widgets/server_list_tile.dart';
import 'package:shellvault/features/connection/presentation/widgets/view_mode_toggle.dart';

class ServerListScreen extends ConsumerWidget {
  const ServerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serversAsync = ref.watch(serverListProvider);
    final viewMode = ref.watch(viewModeProvider);

    return Scaffold(
      appBar: buildShellAppBar(
        context,
        title: 'Hosts',
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
                    title: 'No servers yet',
                    subtitle: 'Add your first SSH server to get started.',
                    action: FilledButton.icon(
                      onPressed: () => context.push('/server/new'),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Server'),
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
                    Text('Error: $error'),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => ref.invalidate(serverListProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
          onTap: () => context.push('/server/${server.id}'),
          onEdit: () => context.push('/server/${server.id}/edit'),
          onDuplicate: () async {
            await ref
                .read(serverListProvider.notifier)
                .duplicateServer(server.id);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Server duplicated')),
              );
            }
          },
          onDelete: () async {
            final confirmed = await ConfirmDialog.show(
              context,
              title: 'Delete Server',
              message:
                  'Are you sure you want to delete "${server.name}"? This action cannot be undone.',
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
          onTap: () => context.push('/server/${server.id}'),
          onLongPress: () {
            _showServerActions(context, ref, server);
          },
        );
      },
    );
  }

  void _showServerActions(BuildContext context, WidgetRef ref, server) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(ctx);
                context.push('/server/${server.id}/edit');
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Duplicate'),
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
              title: Text('Delete',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error)),
              onTap: () async {
                Navigator.pop(ctx);
                final confirmed = await ConfirmDialog.show(
                  context,
                  title: 'Delete Server',
                  message: 'Delete "${server.name}"?',
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
