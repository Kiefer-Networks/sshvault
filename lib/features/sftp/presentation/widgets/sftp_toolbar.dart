import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/features/sftp/domain/entities/sftp_entry.dart';
import 'package:shellvault/features/sftp/domain/entities/sftp_pane_source.dart';
import 'package:shellvault/features/sftp/domain/entities/sftp_pane_state.dart';
import 'package:shellvault/features/sftp/presentation/providers/sftp_providers.dart';
import 'package:shellvault/features/sftp/presentation/widgets/chmod_dialog.dart';
import 'package:shellvault/features/sftp/presentation/widgets/create_symlink_dialog.dart';
import 'package:shellvault/features/sftp/presentation/widgets/new_directory_dialog.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class SftpToolbar extends ConsumerWidget {
  final PaneSide side;
  final bool isWide;

  const SftpToolbar({super.key, required this.side, this.isWide = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paneState = ref.watch(sftpPaneProvider(side));
    final l10n = AppLocalizations.of(context)!;
    final hasSelection = paneState.selectedPaths.isNotEmpty;
    final isRemote = paneState.source is SftpPaneSourceRemote;

    if (hasSelection) {
      return _SelectionToolbar(
        side: side,
        selectedCount: paneState.selectedPaths.length,
        isRemote: isRemote,
        isWide: isWide,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.create_new_folder_outlined, size: 20),
            tooltip: l10n.sftpNewFolder,
            onPressed: () => _showNewFolderDialog(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            tooltip: l10n.sftpRefresh,
            onPressed: () =>
                ref.read(sftpPaneProvider(side).notifier).refresh(),
          ),
          if (isRemote)
            IconButton(
              icon: const Icon(Icons.link, size: 20),
              tooltip: l10n.sftpCreateSymlink,
              onPressed: () => _showSymlinkDialog(context, ref),
            ),
          if (isRemote && !isWide)
            IconButton(
              icon: const Icon(Icons.upload_file, size: 20),
              tooltip: l10n.sftpUpload,
              onPressed: () => _handleUploadFromPicker(context, ref),
            ),
          const Spacer(),
          // Sort menu
          IconButton(
            icon: const Icon(Icons.sort, size: 20),
            tooltip: l10n.sftpSortByName,
            onPressed: () {
              showAdaptiveActionSheet(
                context,
                title: l10n.sftpSortByName,
                actions: [
                  AdaptiveAction(
                    label: l10n.sftpSortByName,
                    icon: Icons.sort_by_alpha,
                    onPressed: () => ref
                        .read(sftpPaneProvider(side).notifier)
                        .setSortField(SortField.name),
                  ),
                  AdaptiveAction(
                    label: l10n.sftpSortBySize,
                    icon: Icons.storage,
                    onPressed: () => ref
                        .read(sftpPaneProvider(side).notifier)
                        .setSortField(SortField.size),
                  ),
                  AdaptiveAction(
                    label: l10n.sftpSortByDate,
                    icon: Icons.calendar_today,
                    onPressed: () => ref
                        .read(sftpPaneProvider(side).notifier)
                        .setSortField(SortField.modified),
                  ),
                  AdaptiveAction(
                    label: l10n.sftpSortByType,
                    icon: Icons.category,
                    onPressed: () => ref
                        .read(sftpPaneProvider(side).notifier)
                        .setSortField(SortField.type),
                  ),
                ],
                cancelLabel: l10n.cancel,
              );
            },
          ),
          IconButton(
            icon: Icon(
              paneState.showHidden ? Icons.visibility : Icons.visibility_off,
              size: 20,
            ),
            tooltip: paneState.showHidden
                ? l10n.sftpHideHidden
                : l10n.sftpShowHidden,
            onPressed: () =>
                ref.read(sftpPaneProvider(side).notifier).toggleShowHidden(),
          ),
        ],
      ),
    );
  }

  void _showNewFolderDialog(BuildContext context, WidgetRef ref) async {
    final name = await NewDirectoryDialog.show(context);
    if (name != null && name.isNotEmpty) {
      ref.read(sftpPaneProvider(side).notifier).createDirectory(name);
    }
  }

  void _handleUploadFromPicker(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;

    final count = await ref
        .read(sftpPaneProvider(side).notifier)
        .uploadFromPicker();

    if (count > 0 && context.mounted) {
      AdaptiveNotification.show(
        context,
        message: l10n.sftpUploadStarted(count),
      );
    }
  }

  void _showSymlinkDialog(BuildContext context, WidgetRef ref) async {
    final result = await CreateSymlinkDialog.show(context);
    if (result != null) {
      ref
          .read(sftpPaneProvider(side).notifier)
          .createSymlink(result.target, result.name);
    }
  }
}

class _SelectionToolbar extends ConsumerWidget {
  final PaneSide side;
  final int selectedCount;
  final bool isRemote;
  final bool isWide;

  const _SelectionToolbar({
    required this.side,
    required this.selectedCount,
    required this.isRemote,
    this.isWide = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () =>
                ref.read(sftpPaneProvider(side).notifier).clearSelection(),
          ),
          Text(
            l10n.sftpItemsSelected(selectedCount),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.select_all, size: 20),
            tooltip: l10n.sftpSelectAll,
            onPressed: () =>
                ref.read(sftpPaneProvider(side).notifier).selectAll(),
          ),
          if (isRemote && !isWide)
            IconButton(
              icon: const Icon(Icons.download, size: 20),
              tooltip: l10n.sftpDownload,
              onPressed: () => _handleBulkDownload(context, ref),
            ),
          if (isRemote)
            IconButton(
              icon: const Icon(Icons.lock_outline, size: 20),
              tooltip: l10n.sftpChmod,
              onPressed: () => _showChmodDialog(context, ref),
            ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              size: 20,
              color: Theme.of(context).colorScheme.error,
            ),
            tooltip: l10n.sftpDelete,
            onPressed: () => _confirmDeleteSelected(context, ref),
          ),
        ],
      ),
    );
  }

  void _handleBulkDownload(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final paneState = ref.read(sftpPaneProvider(side));
    final notifier = ref.read(sftpPaneProvider(side).notifier);

    int count = 0;
    for (final selectedPath in paneState.selectedPaths) {
      final entry = paneState.entries
          .where((e) => e.path == selectedPath)
          .firstOrNull;
      if (entry == null || entry.type != SftpEntryType.file) continue;
      await notifier.downloadToLocal(entry);
      count++;
    }

    notifier.clearSelection();

    if (count > 0 && context.mounted) {
      AdaptiveNotification.show(
        context,
        message: l10n.sftpDownloadStarted(count),
      );
    }
  }

  void _showChmodDialog(BuildContext context, WidgetRef ref) async {
    final permissions = await ChmodDialog.show(context);
    if (permissions != null) {
      final paneState = ref.read(sftpPaneProvider(side));
      for (final selectedPath in paneState.selectedPaths) {
        // Find the entry to preserve file type bits
        final entry = paneState.entries
            .where((e) => e.path == selectedPath)
            .firstOrNull;
        final fileTypeBits = (entry?.permissions ?? 0) & ~0x1FF;
        final fullMode = fileTypeBits | (permissions & 0x1FF);
        await ref
            .read(sftpPaneProvider(side).notifier)
            .chmod(selectedPath, fullMode);
      }
      ref.read(sftpPaneProvider(side).notifier).clearSelection();
    }
  }

  void _confirmDeleteSelected(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.sftpDelete),
        content: Text(l10n.sftpConfirmDelete(selectedCount)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.sftpDelete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(sftpPaneProvider(side).notifier).deleteSelected();
    }
  }
}
