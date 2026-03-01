import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/core/constants/icon_constants.dart';
import 'package:shellvault/core/routing/shell_navigation_provider.dart';
import 'package:shellvault/core/theme/glassmorphism.dart';
import 'package:shellvault/features/connection/presentation/providers/server_providers.dart';
import 'package:shellvault/features/connection/presentation/widgets/confirm_dialog.dart';
import 'package:shellvault/features/connection/presentation/widgets/status_badge.dart';
import 'package:shellvault/features/connection/presentation/widgets/tag_chip.dart';
import 'package:shellvault/features/terminal/presentation/providers/terminal_providers.dart';

class ServerDetailScreen extends ConsumerWidget {
  final String serverId;

  const ServerDetailScreen({super.key, required this.serverId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverAsync = ref.watch(serverDetailProvider(serverId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Server Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/server/$serverId/edit'),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: theme.colorScheme.error),
            onPressed: () async {
              final confirmed = await ConfirmDialog.show(
                context,
                title: 'Delete Server',
                message: 'This action cannot be undone.',
              );
              if (confirmed == true && context.mounted) {
                await ref
                    .read(serverListProvider.notifier)
                    .deleteServer(serverId);
                if (context.mounted) context.pop();
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'connectFab',
        onPressed: () async {
          await ref
              .read(sessionManagerProvider.notifier)
              .openSession(serverId);
          if (context.mounted) {
            context.pop();
          }
          ref.read(shellNavigationProvider)?.goBranch(6);
        },
        icon: const Icon(Icons.terminal),
        label: const Text('Connect'),
      ),
      body: serverAsync.when(
        data: (server) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                GlassmorphicContainer(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Color(server.color).withAlpha(38),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          IconConstants.getIcon(server.iconName),
                          color: Color(server.color),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    server.name,
                                    style:
                                        theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                StatusBadge(isActive: server.isActive),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              server.authMethod.displayName,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withAlpha(128),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Connection Info
                GlassmorphicContainer(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Connection',
                          style: theme.textTheme.titleSmall),
                      const SizedBox(height: 12),
                      _InfoRow(
                        icon: Icons.dns_outlined,
                        label: 'Host',
                        value: server.hostname,
                        onCopy: () => _copy(context, server.hostname),
                      ),
                      _InfoRow(
                        icon: Icons.numbers,
                        label: 'Port',
                        value: server.port.toString(),
                      ),
                      _InfoRow(
                        icon: Icons.person_outline,
                        label: 'Username',
                        value: server.username,
                        onCopy: () => _copy(context, server.username),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Tags
                if (server.tags.isNotEmpty) ...[
                  GlassmorphicContainer(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tags', style: theme.textTheme.titleSmall),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: server.tags
                              .map((tag) => TagChip(tag: tag))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Notes
                if (server.notes.isNotEmpty) ...[
                  GlassmorphicContainer(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Notes', style: theme.textTheme.titleSmall),
                        const SizedBox(height: 8),
                        Text(
                          server.notes,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withAlpha(179),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Metadata
                GlassmorphicContainer(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Info', style: theme.textTheme.titleSmall),
                      const SizedBox(height: 12),
                      _InfoRow(
                        icon: Icons.calendar_today,
                        label: 'Created',
                        value: _formatDate(server.createdAt),
                      ),
                      _InfoRow(
                        icon: Icons.update,
                        label: 'Updated',
                        value: _formatDate(server.updatedAt),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onCopy;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.onSurface.withAlpha(102)),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(128),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
              ),
              textAlign: TextAlign.end,
            ),
          ),
          if (onCopy != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onCopy,
              child: Icon(Icons.copy, size: 16,
                  color: theme.colorScheme.onSurface.withAlpha(102)),
            ),
          ],
        ],
      ),
    );
  }
}
