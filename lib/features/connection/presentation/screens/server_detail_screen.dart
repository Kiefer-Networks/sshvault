import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/constants/icon_constants.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/core/utils/date_formatter.dart';
import 'package:sshvault/core/widgets/info_row.dart';
import 'package:sshvault/features/connection/domain/entities/auth_method.dart';
import 'package:sshvault/features/connection/domain/entities/proxy_config.dart';
import 'package:sshvault/core/services/vpn_detector_service.dart';
import 'package:sshvault/core/routing/shell_navigation_provider.dart';
import 'package:sshvault/core/widgets/settings/section_card.dart';
import 'package:sshvault/features/connection/presentation/providers/folder_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/connection/presentation/widgets/confirm_dialog.dart';
import 'package:sshvault/features/connection/presentation/widgets/status_badge.dart';
import 'package:sshvault/features/connection/presentation/widgets/tag_chip.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

class ServerDetailScreen extends ConsumerWidget {
  final String serverId;

  const ServerDetailScreen({super.key, required this.serverId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverAsync = ref.watch(serverDetailProvider(serverId));
    final theme = Theme.of(context);

    final l10n = AppLocalizations.of(context)!;

    Future<void> connect() async {
      await ref.read(sessionManagerProvider.notifier).openSession(serverId);
      if (context.mounted) {
        ref
            .read(shellNavigationProvider)
            ?.goBranch(AppConstants.terminalBranchIndex);
      }
    }

    return AdaptiveScaffold.withAppBar(
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
        onPressed: connect,
        icon: const Icon(Icons.terminal),
        label: Text(l10n.serverConnect),
      ),
      body: serverAsync.when(
        data: (server) {
          return SingleChildScrollView(
            padding: Spacing.paddingAllLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                SectionCard(
                  padding: Spacing.paddingAllXl,
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Color(
                            server.color,
                          ).withAlpha(AppConstants.alpha38),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          IconConstants.getIcon(server.iconName),
                          color: Color(server.color),
                          size: 28,
                        ),
                      ),
                      Spacing.horizontalLg,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    server.name,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                StatusBadge(isActive: server.isActive),
                              ],
                            ),
                            Spacing.verticalXxs,
                            Text(
                              switch (server.authMethod) {
                                AuthMethod.password => l10n.authMethodPassword,
                                AuthMethod.key => l10n.authMethodKey,
                                AuthMethod.both => l10n.authMethodBoth,
                              },
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withAlpha(
                                  AppConstants.alpha128,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Spacing.verticalLg,

                // Connection Info
                SectionCard(
                  padding: Spacing.paddingAllLg,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.serverDetailConnection,
                        style: theme.textTheme.titleSmall,
                      ),
                      Spacing.verticalMd,
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
                      if (server.jumpHostId != null)
                        _JumpHostInfoRow(jumpHostId: server.jumpHostId!),
                    ],
                  ),
                ),

                // Proxy
                if (server.proxyType != ProxyType.none ||
                    server.useGlobalProxy) ...[
                  Spacing.verticalLg,
                  SectionCard(
                    padding: Spacing.paddingAllLg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.proxySettings,
                          style: theme.textTheme.titleSmall,
                        ),
                        Spacing.verticalMd,
                        if (server.useGlobalProxy &&
                            server.proxyType == ProxyType.none)
                          InfoRow(
                            icon: Icons.public,
                            label: l10n.proxyType,
                            value: l10n.proxyGlobal,
                          )
                        else ...[
                          InfoRow(
                            icon: Icons.vpn_key_outlined,
                            label: l10n.proxyType,
                            value: switch (server.proxyType) {
                              ProxyType.socks5 => l10n.proxySocks5,
                              ProxyType.httpConnect => l10n.proxyHttpConnect,
                              ProxyType.none => l10n.proxyNone,
                            },
                          ),
                          if (server.proxyHost.isNotEmpty)
                            InfoRow(
                              icon: Icons.dns_outlined,
                              label: l10n.proxyHost,
                              value: '${server.proxyHost}:${server.proxyPort}',
                            ),
                        ],
                        if (server.requiresVpn)
                          _VpnStatusRow(serverId: serverId),
                      ],
                    ),
                  ),
                ],

                // Folder
                if (server.groupId != null) ...[
                  Spacing.verticalLg,
                  _FolderSection(groupId: server.groupId!),
                ],

                // Distro
                _DistroSection(
                  serverId: serverId,
                  distroId: server.distroId,
                  distroName: server.distroName,
                ),

                Spacing.verticalLg,

                // Tags
                if (server.tags.isNotEmpty) ...[
                  SectionCard(
                    padding: Spacing.paddingAllLg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.serverDetailTags,
                          style: theme.textTheme.titleSmall,
                        ),
                        Spacing.verticalSm,
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
                  Spacing.verticalLg,
                ],

                // Notes
                if (server.notes.isNotEmpty) ...[
                  SectionCard(
                    padding: Spacing.paddingAllLg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.serverDetailNotes,
                          style: theme.textTheme.titleSmall,
                        ),
                        Spacing.verticalSm,
                        Text(
                          server.notes,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(
                              AppConstants.alpha179,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacing.verticalLg,
                ],

                // Metadata
                SectionCard(
                  padding: Spacing.paddingAllLg,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.serverDetailInfo,
                        style: theme.textTheme.titleSmall,
                      ),
                      Spacing.verticalMd,
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
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) =>
            Center(child: Text(l10n.error(errorMessage(error)))),
      ),
    );
  }

  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    AdaptiveNotification.show(
      context,
      message: AppLocalizations.of(context)!.copiedToClipboard,
    );
  }
}

class _FolderSection extends ConsumerWidget {
  final String groupId;

  const _FolderSection({required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final folders = ref.watch(folderListProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return folders.when(
      data: (allFolders) {
        final group = allFolders.where((g) => g.id == groupId).firstOrNull;
        if (group == null) return const SizedBox.shrink();

        return SectionCard(
          padding: Spacing.paddingAllLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.serverDetailFolder, style: theme.textTheme.titleSmall),
              Spacing.verticalSm,
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(group.color).withAlpha(AppConstants.alpha38),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      IconConstants.getIcon(group.iconName),
                      color: Color(group.color),
                      size: 18,
                    ),
                  ),
                  Spacing.horizontalMd,
                  Text(group.name, style: theme.textTheme.bodyLarge),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _DistroSection extends ConsumerWidget {
  final String serverId;
  final String? distroId;
  final String? distroName;

  const _DistroSection({
    required this.serverId,
    this.distroId,
    this.distroName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Live session distro info takes priority
    final sessions = ref.watch(sessionManagerProvider);
    final session = sessions
        .where((s) => s.serverId == serverId && s.distroInfo != null)
        .firstOrNull;

    final effectiveId = session?.distroInfo?.id ?? distroId;
    final effectiveName = session?.distroInfo?.displayName ?? distroName;

    if (effectiveId == null || effectiveName == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(top: Spacing.lg),
      child: SectionCard(
        padding: Spacing.paddingAllLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.serverDetailDistro, style: theme.textTheme.titleSmall),
            Spacing.verticalSm,
            Row(
              children: [
                _DistroLogo(distroId: effectiveId),
                Spacing.horizontalMd,
                Expanded(
                  child: Text(effectiveName, style: theme.textTheme.bodyLarge),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DistroLogo extends StatelessWidget {
  final String distroId;

  const _DistroLogo({required this.distroId});

  @override
  Widget build(BuildContext context) {
    final icon = _distroIcon(distroId);
    final color = _distroColor(distroId);

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withAlpha(AppConstants.alpha30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  static IconData _distroIcon(String id) {
    return switch (id) {
      'ubuntu' ||
      'kubuntu' ||
      'xubuntu' ||
      'lubuntu' ||
      'pop' => Icons.circle_outlined,
      'debian' => Icons.hexagon_outlined,
      'fedora' => Icons.donut_large,
      'centos' || 'rhel' || 'rocky' || 'almalinux' => Icons.shield_outlined,
      'arch' || 'manjaro' || 'endeavouros' => Icons.change_history,
      'opensuse' || 'sles' => Icons.eco_outlined,
      'alpine' => Icons.landscape_outlined,
      'gentoo' => Icons.science_outlined,
      'nixos' => Icons.ac_unit,
      'freebsd' || 'openbsd' || 'netbsd' => Icons.bug_report_outlined,
      'amzn' => Icons.cloud_outlined,
      'coreos' || 'flatcar' => Icons.settings_outlined,
      _ => Icons.terminal,
    };
  }

  static Color _distroColor(String id) {
    return switch (id) {
      'ubuntu' ||
      'kubuntu' ||
      'xubuntu' ||
      'lubuntu' ||
      'pop' => const Color(0xFFE95420),
      'debian' => const Color(0xFFD70A53),
      'fedora' => const Color(0xFF3C6EB4),
      'centos' || 'rhel' || 'rocky' || 'almalinux' => const Color(0xFFEE0000),
      'arch' || 'manjaro' || 'endeavouros' => const Color(0xFF1793D1),
      'opensuse' || 'sles' => const Color(0xFF73BA25),
      'alpine' => const Color(0xFF0D597F),
      'gentoo' => const Color(0xFF54487A),
      'nixos' => const Color(0xFF7EBAE4),
      'freebsd' || 'openbsd' || 'netbsd' => const Color(0xFFAB2B28),
      'amzn' => const Color(0xFFFF9900),
      'coreos' || 'flatcar' => const Color(0xFF3D6AA2),
      _ => const Color(0xFF78909C),
    };
  }
}

class _VpnStatusRow extends ConsumerWidget {
  final String serverId;

  const _VpnStatusRow({required this.serverId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnActive = ref.watch(vpnActiveProvider).value ?? false;
    final l10n = AppLocalizations.of(context)!;

    return InfoRow(
      icon: Icons.shield_outlined,
      label: l10n.vpnRequired,
      value: vpnActive ? l10n.vpnActive : l10n.vpnInactive,
      valueColor: vpnActive
          ? Theme.of(context).colorScheme.tertiary
          : Theme.of(context).colorScheme.error,
    );
  }
}

class _JumpHostInfoRow extends ConsumerWidget {
  final String jumpHostId;

  const _JumpHostInfoRow({required this.jumpHostId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jumpHostAsync = ref.watch(serverDetailProvider(jumpHostId));
    final l10n = AppLocalizations.of(context)!;

    return jumpHostAsync.when(
      data: (jumpHost) => InfoRow(
        icon: Icons.route_outlined,
        label: l10n.jumpHost,
        value: jumpHost.name,
      ),
      loading: () => InfoRow(
        icon: Icons.route_outlined,
        label: l10n.jumpHost,
        value: '...',
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
