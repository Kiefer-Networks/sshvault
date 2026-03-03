import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/features/sftp/domain/entities/transfer_item.dart';
import 'package:shellvault/features/sftp/presentation/providers/sftp_providers.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class TransferPanel extends ConsumerStatefulWidget {
  const TransferPanel({super.key});

  @override
  ConsumerState<TransferPanel> createState() => _TransferPanelState();
}

class _TransferPanelState extends ConsumerState<TransferPanel> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final transfers = ref.watch(transferManagerProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final activeCount = transfers
        .where((t) => t.status == TransferStatus.active)
        .length;
    final completedCount = transfers
        .where((t) => t.status == TransferStatus.completed)
        .length;
    final failedCount = transfers
        .where((t) => t.status == TransferStatus.failed)
        .length;
    final totalCount = transfers.length;

    // Build a clear summary: "2 active" / "3 completed" / "1 failed"
    final summaryParts = <String>[];
    if (activeCount > 0) {
      summaryParts.add(l10n.sftpTransferCountActive(activeCount));
    }
    if (completedCount > 0) {
      summaryParts.add(l10n.sftpTransferCountCompleted(completedCount));
    }
    if (failedCount > 0) {
      summaryParts.add(l10n.sftpTransferCountFailed(failedCount));
    }
    final summary = summaryParts.isEmpty
        ? l10n.sftpTransferCount(activeCount, totalCount)
        : summaryParts.join(' · ');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 1),
        // Header bar — always visible
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  activeCount > 0
                      ? Icons.swap_vert
                      : Icons.check_circle_outline,
                  size: 20,
                  color: activeCount > 0
                      ? theme.colorScheme.primary
                      : Colors.green,
                ),
                const SizedBox(width: 8),
                Text(l10n.sftpTransfers, style: theme.textTheme.titleSmall),
                const SizedBox(width: 8),
                Text(summary, style: theme.textTheme.bodySmall),
                const Spacer(),
                if (transfers.any(
                  (t) =>
                      t.status == TransferStatus.completed ||
                      t.status == TransferStatus.failed ||
                      t.status == TransferStatus.cancelled,
                ))
                  TextButton(
                    onPressed: () => ref
                        .read(transferManagerProvider.notifier)
                        .clearCompleted(),
                    child: Text(l10n.sftpClearCompleted),
                  ),
                Icon(
                  _expanded ? Icons.expand_more : Icons.expand_less,
                  size: 20,
                ),
              ],
            ),
          ),
        ),

        // Active transfer progress
        if (!_expanded && activeCount > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LinearProgressIndicator(value: _overallProgress(transfers)),
          ),

        // Expanded transfer list
        if (_expanded)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: transfers.length,
              itemBuilder: (context, index) {
                final item = transfers[index];
                return _TransferItemTile(item: item);
              },
            ),
          ),
      ],
    );
  }

  double? _overallProgress(List<TransferItem> transfers) {
    final active = transfers
        .where((t) => t.status == TransferStatus.active)
        .toList();
    if (active.isEmpty) return null;

    final totalBytes = active.fold<int>(0, (sum, t) => sum + t.totalBytes);
    if (totalBytes == 0) return null;

    final transferred = active.fold<int>(
      0,
      (sum, t) => sum + t.transferredBytes,
    );
    return transferred / totalBytes;
  }
}

class _TransferItemTile extends ConsumerWidget {
  final TransferItem item;

  const _TransferItemTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final progress = item.totalBytes > 0
        ? item.transferredBytes / item.totalBytes
        : 0.0;

    final fileName = item.sourcePath.split('/').last;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(
            _directionIcon(item.direction),
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 2),
                if (item.status == TransferStatus.active)
                  LinearProgressIndicator(value: progress)
                else
                  Text(
                    _statusText(item.status, l10n),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: _statusColor(item.status, theme),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (item.status == TransferStatus.active)
            IconButton(
              icon: const Icon(Icons.pause, size: 16),
              onPressed: () => ref
                  .read(transferManagerProvider.notifier)
                  .pauseTransfer(item.id),
            )
          else if (item.status == TransferStatus.paused)
            IconButton(
              icon: const Icon(Icons.play_arrow, size: 16),
              onPressed: () => ref
                  .read(transferManagerProvider.notifier)
                  .resumeTransfer(item.id),
            ),
          if (item.status == TransferStatus.active ||
              item.status == TransferStatus.paused ||
              item.status == TransferStatus.queued)
            IconButton(
              icon: const Icon(Icons.close, size: 16),
              onPressed: () => ref
                  .read(transferManagerProvider.notifier)
                  .cancelTransfer(item.id),
            ),
        ],
      ),
    );
  }

  IconData _directionIcon(TransferDirection dir) {
    switch (dir) {
      case TransferDirection.download:
        return Icons.download;
      case TransferDirection.upload:
        return Icons.upload;
      case TransferDirection.hostToHost:
        return Icons.swap_horiz;
    }
  }

  String _statusText(TransferStatus status, AppLocalizations l10n) {
    switch (status) {
      case TransferStatus.queued:
        return l10n.sftpTransferQueued;
      case TransferStatus.active:
        return l10n.sftpTransferActive;
      case TransferStatus.paused:
        return l10n.sftpTransferPaused;
      case TransferStatus.completed:
        return l10n.sftpTransferCompleted;
      case TransferStatus.failed:
        return l10n.sftpTransferFailed;
      case TransferStatus.cancelled:
        return l10n.sftpTransferCancelled;
    }
  }

  Color _statusColor(TransferStatus status, ThemeData theme) {
    switch (status) {
      case TransferStatus.completed:
        return Colors.green;
      case TransferStatus.failed:
        return theme.colorScheme.error;
      case TransferStatus.cancelled:
        return theme.colorScheme.onSurfaceVariant;
      default:
        return theme.colorScheme.primary;
    }
  }
}
