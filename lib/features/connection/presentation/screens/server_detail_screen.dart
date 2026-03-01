import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/constants/icon_constants.dart';
import 'package:shellvault/core/utils/date_formatter.dart';
import 'package:shellvault/core/widgets/info_row.dart';
import 'package:shellvault/features/connection/domain/entities/auth_method.dart';
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

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.serverDetailTitle),
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
                title: l10n.serverDeleteTitle,
                message: l10n.serverDetailDeleteMessage,
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
            ref.read(shellNavigationProvider)?.goBranch(AppConstants.terminalBranchIndex);
          }
        },
        icon: const Icon(Icons.terminal),
        label: Text(l10n.serverConnect),
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
                              switch (server.authMethod) {
                                AuthMethod.password =>
                                  l10n.authMethodPassword,
                                AuthMethod.key => l10n.authMethodKey,
                                AuthMethod.both => l10n.authMethodBoth,
                              },
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
                      Text(l10n.serverDetailConnection,
                          style: theme.textTheme.titleSmall),
                      const SizedBox(height: 12),
                      InfoRow(
                        icon: Icons.dns_outlined,
                        label: l10n.serverDetailHost,
                        value: server.hostname,
                        onTap: () => _copy(context, server.hostname),
                      ),
                      InfoRow(
                        icon: Icons.numbers,
                        label: l10n.serverDetailPort,
                        value: server.port.toString(),
                      ),
                      InfoRow(
                        icon: Icons.person_outline,
                        label: l10n.serverDetailUsername,
                        value: server.username,
                        onTap: () => _copy(context, server.username),
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
                        Text(l10n.serverDetailTags, style: theme.textTheme.titleSmall),
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
                        Text(l10n.serverDetailNotes, style: theme.textTheme.titleSmall),
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
                      Text(l10n.serverDetailInfo, style: theme.textTheme.titleSmall),
                      const SizedBox(height: 12),
                      InfoRow(
                        icon: Icons.calendar_today,
                        label: l10n.serverDetailCreated,
                        value: formatDate(server.createdAt),
                      ),
                      InfoRow(
                        icon: Icons.update,
                        label: l10n.serverDetailUpdated,
                        value: formatDate(server.updatedAt),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(l10n.error(error.toString()))),
      ),
    );
  }

  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.copiedToClipboard)),
    );
  }

}
