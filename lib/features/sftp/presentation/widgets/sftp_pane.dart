import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:shellvault/features/sftp/data/services/archive_service.dart';
import 'package:shellvault/features/sftp/domain/entities/sftp_entry.dart';
import 'package:shellvault/features/sftp/domain/entities/sftp_pane_source.dart';
import 'package:shellvault/features/sftp/presentation/providers/sftp_providers.dart';
import 'package:shellvault/features/sftp/presentation/widgets/file_preview_dialog.dart';
import 'package:shellvault/features/sftp/presentation/widgets/overwrite_confirm_dialog.dart';
import 'package:shellvault/features/sftp/presentation/widgets/sftp_breadcrumb.dart';
import 'package:shellvault/features/sftp/presentation/widgets/sftp_empty_state.dart';
import 'package:shellvault/features/sftp/presentation/widgets/sftp_entry_tile.dart';
import 'package:shellvault/features/sftp/presentation/widgets/sftp_server_picker.dart';
import 'package:shellvault/features/sftp/presentation/widgets/sftp_toolbar.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class SftpPane extends ConsumerWidget {
  final PaneSide side;
  final bool isWide;

  const SftpPane({super.key, required this.side, this.isWide = false});

  PaneSide get _oppositeSide =>
      side == PaneSide.left ? PaneSide.right : PaneSide.left;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paneState = ref.watch(sftpPaneProvider(side));
    final l10n = AppLocalizations.of(context)!;

    Widget fileList;

    if (paneState.isLoading) {
      fileList = const Center(child: CircularProgressIndicator());
    } else if (paneState.error != null) {
      fileList = Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 8),
              Text(
                paneState.error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () =>
                    ref.read(sftpPaneProvider(side).notifier).refresh(),
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    } else if (paneState.entries.isEmpty) {
      fileList = const SftpEmptyState();
    } else {
      fileList = RefreshIndicator(
        onRefresh: () => ref.read(sftpPaneProvider(side).notifier).refresh(),
        child: ListView.builder(
          itemCount: paneState.entries.length,
          itemBuilder: (context, index) {
            final entry = paneState.entries[index];
            final isSelected = paneState.selectedPaths.contains(entry.path);

            final isRemoteSource = paneState.source is SftpPaneSourceRemote;
            return SftpEntryTile(
              entry: entry,
              isSelected: isSelected,
              hasSelection: paneState.selectedPaths.isNotEmpty,
              isWideMode: isWide,
              onTap: () => _handleTap(context, ref, entry, paneState),
              onTransfer: () => _handleFileTransfer(context, ref, entry),
              onDownload:
                  (!isWide &&
                      isRemoteSource &&
                      entry.type == SftpEntryType.file)
                  ? () => _handleMobileDownload(context, ref, entry)
                  : null,
              side: side,
            );
          },
        ),
      );
    }

    // Wrap in DragTarget only in wide mode
    if (isWide) {
      fileList = _buildDragTarget(context, ref, fileList);
    }

    return Column(
      children: [
        SftpServerPicker(side: side),
        const Divider(height: 1),
        SftpBreadcrumb(side: side),
        const Divider(height: 1),
        SftpToolbar(side: side, isWide: isWide),
        const Divider(height: 1),
        Expanded(child: fileList),
      ],
    );
  }

  void _handleTap(
    BuildContext context,
    WidgetRef ref,
    SftpEntry entry,
    dynamic paneState,
  ) {
    // Selection mode: toggle selection
    if (paneState.selectedPaths.isNotEmpty) {
      ref.read(sftpPaneProvider(side).notifier).toggleSelection(entry.path);
      return;
    }

    // Directory: navigate into it
    if (entry.type == SftpEntryType.directory) {
      ref.read(sftpPaneProvider(side).notifier).navigateTo(entry.path);
      return;
    }

    // File: ask user what to do
    _showFileActionChoice(context, ref, entry);
  }

  void _showFileActionChoice(
    BuildContext context,
    WidgetRef ref,
    SftpEntry entry,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final paneSource = ref.read(sftpPaneProvider(side)).source;
    final isRemote = paneSource is SftpPaneSourceRemote;

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                entry.name,
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Divider(height: 1),
            if (isWide)
              ListTile(
                leading: const Icon(Icons.swap_horiz),
                title: Text(l10n.sftpCopyToOtherPane),
                onTap: () {
                  Navigator.pop(ctx);
                  _handleFileTransfer(context, ref, entry);
                },
              ),
            if (!isWide && isRemote)
              ListTile(
                leading: const Icon(Icons.download),
                title: Text(l10n.sftpDownload),
                onTap: () {
                  Navigator.pop(ctx);
                  _handleMobileDownload(context, ref, entry);
                },
              ),
            ListTile(
              leading: const Icon(Icons.visibility),
              title: Text(l10n.sftpFilePreview),
              onTap: () {
                Navigator.pop(ctx);
                showDialog(
                  context: context,
                  builder: (_) => FilePreviewDialog(entry: entry, side: side),
                );
              },
            ),
            if (ArchiveService.isArchive(entry.name))
              ListTile(
                leading: const Icon(Icons.unarchive),
                title: Text(l10n.sftpExtractArchive),
                onTap: () {
                  Navigator.pop(ctx);
                  _extractArchive(context, ref, entry);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _extractArchive(
    BuildContext context,
    WidgetRef ref,
    SftpEntry entry,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    messenger.showSnackBar(SnackBar(content: Text(l10n.sftpExtracting)));

    final result = await ref
        .read(sftpPaneProvider(side).notifier)
        .extractArchive(entry.path);

    if (!context.mounted) return;
    messenger.hideCurrentSnackBar();

    result.fold(
      onSuccess: (_) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.sftpExtractSuccess)),
        );
      },
      onFailure: (failure) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.sftpExtractFailed(failure.message))),
        );
      },
    );
  }

  void _handleMobileDownload(
    BuildContext context,
    WidgetRef ref,
    SftpEntry entry,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    await ref.read(sftpPaneProvider(side).notifier).downloadToLocal(entry);

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.sftpDownloadStarted(1))));
    }
  }

  Future<void> _handleFileTransfer(
    BuildContext context,
    WidgetRef ref,
    SftpEntry entry,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    // In narrow mode, no opposite pane available
    if (!isWide) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.sftpNoPaneSelected)));
      return;
    }

    // Directory transfers not yet supported
    if (entry.type == SftpEntryType.directory) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.sftpDirectoryTransferNotSupported)),
      );
      return;
    }

    final srcState = ref.read(sftpPaneProvider(side));
    final dstState = ref.read(sftpPaneProvider(_oppositeSide));
    final srcSource = srcState.source;
    final dstSource = dstState.source;

    // Build destination path
    final destPath = dstSource is SftpPaneSourceLocal
        ? p.join(dstState.currentPath, entry.name)
        : p.posix.join(dstState.currentPath, entry.name);

    // Check if file exists at destination
    final exists = await _checkDestinationExists(ref, dstSource, destPath);
    if (exists && context.mounted) {
      final overwrite = await OverwriteConfirmDialog.show(context, entry.name);
      if (!overwrite) return;
    }

    // Determine transfer type and enqueue
    final transferManager = ref.read(transferManagerProvider.notifier);

    switch ((srcSource, dstSource)) {
      // Local → Remote = Upload
      case (SftpPaneSourceLocal(), SftpPaneSourceRemote()):
        await transferManager.enqueueUpload(
          entry.path,
          dstSource,
          destPath,
          totalBytes: entry.size,
        );

      // Remote → Local = Download
      case (SftpPaneSourceRemote(), SftpPaneSourceLocal()):
        await transferManager.enqueueDownload(
          srcSource,
          entry.path,
          destPath,
          totalBytes: entry.size,
        );

      // Remote → Remote = Host-to-Host
      case (SftpPaneSourceRemote(), SftpPaneSourceRemote()):
        await transferManager.enqueueHostToHost(
          srcSource,
          entry.path,
          dstSource,
          destPath,
          totalBytes: entry.size,
        );

      // Local → Local: just copy via local file system (not a typical use case)
      case (SftpPaneSourceLocal(), SftpPaneSourceLocal()):
        // Local-to-local copy not handled via transfer manager
        return;
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.sftpTransferStarted(entry.name))),
      );
    }
  }

  Future<bool> _checkDestinationExists(
    WidgetRef ref,
    SftpPaneSource dstSource,
    String destPath,
  ) async {
    switch (dstSource) {
      case SftpPaneSourceLocal():
        final localService = ref.read(localFileServiceProvider);
        return localService.exists(destPath);

      case SftpPaneSourceRemote(:final serverId):
        final connMgr = ref.read(sftpConnectionManagerProvider);
        final clientResult = await connMgr.getClient(serverId, ref.container);
        if (clientResult.isFailure) return false;
        final sftpService = ref.read(sftpServiceProvider);
        final statResult = await sftpService.stat(clientResult.value, destPath);
        return statResult.isSuccess;
    }
  }

  Widget _buildDragTarget(BuildContext context, WidgetRef ref, Widget child) {
    return DragTarget<SftpEntry>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (details) {
        _handleFileTransfer(context, ref, details.data);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isHovering
                ? Theme.of(context).colorScheme.primary.withAlpha(20)
                : null,
          ),
          child: child,
        );
      },
    );
  }
}
