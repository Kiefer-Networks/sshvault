import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/core/utils/byte_format.dart';
import 'package:sshvault/core/widgets/info_row.dart';
import 'package:sshvault/features/terminal/data/services/remote_system_metrics_service.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

/// Renders a [RemoteSystemMetrics] snapshot: kernel, CPU, RAM, and disks.
///
/// Docker/Podman overlay mounts (one per running container) are collapsed
/// into a single "Docker" usage line instead of listed individually. This
/// is the one place that grouping happens — every screen that shows a
/// host's system info (currently [ServerDetailScreen]) renders through
/// here so they can't drift out of sync with each other again.
class SystemMetricsCard extends StatelessWidget {
  final RemoteSystemMetrics metrics;
  const SystemMetricsCard({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final mutedIconColor = theme.colorScheme.onSurface.withAlpha(
      AppConstants.alpha102,
    );
    final mutedLabelColor = theme.colorScheme.onSurface.withAlpha(
      AppConstants.alpha128,
    );

    final rows = <Widget>[];
    if (metrics.kernelName != null || metrics.kernelVersion != null) {
      rows.add(
        InfoRow(
          icon: Icons.memory,
          label: l10n.serverDetailKernel,
          value: [
            metrics.kernelName,
            metrics.kernelVersion,
          ].whereType<String>().where((v) => v.isNotEmpty).join(' '),
        ),
      );
    }
    if (metrics.cpuModel != null || metrics.cpuCores != null) {
      rows.add(
        InfoRow(
          icon: Icons.developer_board,
          label: l10n.serverDetailCpu,
          value: [
            metrics.cpuModel,
            if (metrics.cpuVendor != null) metrics.cpuVendor,
            if (metrics.cpuCores != null) '${metrics.cpuCores}',
          ].whereType<String>().where((v) => v.isNotEmpty).join(' · '),
        ),
      );
    }
    if (metrics.isVirtualMachine == true) {
      rows.add(
        InfoRow(
          icon: Icons.cloud_outlined,
          label: l10n.serverDetailVirtualMachine,
          value: l10n.serverDetailVirtualMachine,
        ),
      );
    }
    if (metrics.serialNumber != null) {
      rows.add(
        InfoRow(
          icon: Icons.confirmation_number_outlined,
          label: l10n.serverDetailSerial,
          value: metrics.serialNumber!,
        ),
      );
    }
    if (metrics.ramBytes != null) {
      rows.add(
        InfoRow(
          icon: Icons.memory,
          label: l10n.serverDetailRam,
          value: formatBytes(metrics.ramBytes!),
        ),
      );
    }

    // realDisks already excludes Docker overlays, kernel pseudo-filesystems
    // (proc/tmpfs/squashfs/...) and network mounts — those three used to
    // all be lumped in here together, which is what pushed real disks (a
    // ZFS pool's several datasets, say) out of the old fixed 6-row cap on
    // any host with more than a couple of them. No cap here now: once the
    // noise is filtered out, whatever's left over is exactly what a user
    // means by "my disks".
    final realDisks = metrics.disks.realDisks;
    final dockerDisks = metrics.disks.dockerMountsOnly;
    final networkMounts = metrics.disks.networkMounts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...rows,
        if (realDisks.isNotEmpty || dockerDisks.isNotEmpty) ...[
          Spacing.verticalXs,
          Row(
            children: [
              Icon(Icons.storage, size: 18, color: mutedIconColor),
              Spacing.horizontalSm,
              Text(
                l10n.serverDetailDisks,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: mutedLabelColor,
                ),
              ),
            ],
          ),
          Spacing.verticalSm,
          for (final disk in realDisks)
            _DiskRow(
              label: disk.mountPoint,
              used: disk.usedBytes,
              total: disk.totalBytes,
            ),
          if (dockerDisks.isNotEmpty)
            _DiskRow(
              label: 'Docker',
              used: dockerDisks.fold<int>(0, (sum, d) => sum + d.usedBytes),
              total: dockerDisks.fold<int>(0, (sum, d) => sum + d.totalBytes),
              emphasized: true,
            ),
        ],
        if (networkMounts.isNotEmpty) ...[
          Spacing.verticalMd,
          Row(
            children: [
              Icon(Icons.dns_outlined, size: 18, color: mutedIconColor),
              Spacing.horizontalSm,
              // Hardcoded English: this label has no existing l10n key and
              // adding one means regenerating all 28 locales, same reason
              // other brand-new desktop-shell text in this app is English.
              Text(
                'Network Mounts',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: mutedLabelColor,
                ),
              ),
            ],
          ),
          Spacing.verticalSm,
          for (final mount in networkMounts)
            _DiskRow(
              label: '${mount.mountPoint}  ·  ${mount.fsType}',
              used: mount.usedBytes,
              total: mount.totalBytes,
              icon: Icons.dns_outlined,
            ),
        ],
        if (metrics.proxmoxGuests.isNotEmpty) ...[
          Spacing.verticalMd,
          Row(
            children: [
              Icon(Icons.dns, size: 18, color: mutedIconColor),
              Spacing.horizontalSm,
              const Text('Proxmox'),
            ],
          ),
          Spacing.verticalSm,
          for (final guest in metrics.proxmoxGuests)
            _ProxmoxGuestRow(guest: guest),
        ],
      ],
    );
  }
}

class _ProxmoxGuestRow extends StatelessWidget {
  final ProxmoxGuest guest;
  const _ProxmoxGuestRow({required this.guest});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = guest.running
        ? theme.colorScheme.tertiary
        : theme.colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.xs),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          Spacing.horizontalSm,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              guest.type == 'lxc' ? 'LXC' : 'VM',
              style: theme.textTheme.labelSmall?.copyWith(
                fontFamily: AppConstants.monospaceFontFamily,
              ),
            ),
          ),
          Spacing.horizontalSm,
          Expanded(
            child: Text(
              guest.name,
              style: theme.textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '#${guest.vmid}',
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: AppConstants.monospaceFontFamily,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiskRow extends StatelessWidget {
  final String label;
  final int used;
  final int total;
  final bool emphasized;
  final IconData? icon;

  const _DiskRow({
    required this.label,
    required this.used,
    required this.total,
    this.emphasized = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio = total > 0 ? (used / total).clamp(0.0, 1.0) : 0.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon ?? (emphasized ? Icons.view_in_ar : Icons.folder_open),
                size: 16,
                color: theme.colorScheme.onSurface.withAlpha(
                  AppConstants.alpha102,
                ),
              ),
              Spacing.horizontalXs,
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${formatBytes(used)} / ${formatBytes(total)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: AppConstants.monospaceFontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 5,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              color: ratio > 0.9
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
