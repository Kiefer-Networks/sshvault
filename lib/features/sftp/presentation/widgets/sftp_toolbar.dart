import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/features/sftp/domain/entities/sftp_entry.dart';
import 'package:sshvault/features/sftp/domain/entities/sftp_pane_source.dart';
import 'package:sshvault/features/sftp/domain/entities/sftp_pane_state.dart';
import 'package:sshvault/features/sftp/presentation/providers/sftp_providers.dart';
import 'package:sshvault/features/sftp/presentation/widgets/chmod_dialog.dart';
import 'package:sshvault/features/sftp/presentation/widgets/create_symlink_dialog.dart';
import 'package:sshvault/features/sftp/presentation/widgets/new_directory_dialog.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

class SftpFloatingToolbar extends ConsumerWidget {
  final PaneSide side;
  final bool isWide;

  const SftpFloatingToolbar({
    super.key,
    required this.side,
    this.isWide = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paneState = ref.watch(sftpPaneProvider(side));

    final shouldShow =
        !paneState.isLoading &&
        paneState.error == null &&
        !paneState.needsHostSelection;

    return AnimatedSlide(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      offset: shouldShow ? Offset.zero : const Offset(0, 1),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: shouldShow ? 1.0 : 0.0,
        child: Padding(
          padding: const EdgeInsets.only(bottom: Spacing.md),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              final slide = Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(animation);
              return SlideTransition(
                position: slide,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: paneState.selectedPaths.isNotEmpty
                ? _SelectionToolbarContent(
                    key: const ValueKey('selection'),
                    side: side,
                    selectedCount: paneState.selectedPaths.length,
                    isRemote: paneState.source is SftpPaneSourceRemote,
                    isWide: isWide,
                  )
                : _NormalToolbarContent(
                    key: const ValueKey('normal'),
                    side: side,
                    isRemote: paneState.source is SftpPaneSourceRemote,
                    isWide: isWide,
                    showHidden: paneState.showHidden,
                  ),
          ),
        ),
      ),
    );
  }
}

class _FloatingToolbarContainer extends StatelessWidget {
  final Color color;
  final List<Widget> children;

  const _FloatingToolbarContainer({
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const StadiumBorder(),
      elevation: 1,
      color: color,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: Spacing.paddingHorizontalXxs,
        child: Row(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}

class _ToolbarDivider extends StatelessWidget {
  const _ToolbarDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
      child: SizedBox(
        height: 24,
        child: VerticalDivider(
          width: 1,
          thickness: 1,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
    );
  }
}

class _NormalToolbarContent extends ConsumerWidget {
  final PaneSide side;
  final bool isRemote;
  final bool isWide;
  final bool showHidden;

  const _NormalToolbarContent({
    super.key,
    required this.side,
    required this.isRemote,
    required this.isWide,
    required this.showHidden,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return _FloatingToolbarContainer(
      color: colorScheme.surfaceContainer,
      children: [
        IconButton(
          icon: const Icon(Icons.create_new_folder_outlined, size: 20),
          tooltip: l10n.sftpNewFolder,
          onPressed: () => _showNewFolderDialog(context, ref),
        ),
        IconButton(
          icon: const Icon(Icons.refresh, size: 20),
          tooltip: l10n.sftpRefresh,
          onPressed: () => ref.read(sftpPaneProvider(side).notifier).refresh(),
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
        const _ToolbarDivider(),
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
            showHidden ? Icons.visibility : Icons.visibility_off,
            size: 20,
          ),
          tooltip: showHidden ? l10n.sftpHideHidden : l10n.sftpShowHidden,
          onPressed: () =>
              ref.read(sftpPaneProvider(side).notifier).toggleShowHidden(),
        ),
      ],
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

class _SelectionToolbarContent extends ConsumerWidget {
  final PaneSide side;
  final int selectedCount;
  final bool isRemote;
  final bool isWide;

  const _SelectionToolbarContent({
    super.key,
    required this.side,
    required this.selectedCount,
    required this.isRemote,
    this.isWide = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return _FloatingToolbarContainer(
      color: colorScheme.primaryContainer,
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
        const _ToolbarDivider(),
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
          icon: Icon(Icons.delete_outline, size: 20, color: colorScheme.error),
          tooltip: l10n.sftpDelete,
          onPressed: () => _confirmDeleteSelected(context, ref),
        ),
      ],
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
    final confirmed = await showAdaptiveConfirmDialog(
      context,
      title: l10n.sftpDelete,
      message: l10n.sftpConfirmDelete(selectedCount),
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.sftpDelete,
      isDestructive: true,
    );
    if (confirmed == true) {
      ref.read(sftpPaneProvider(side).notifier).deleteSelected();
    }
  }
}
