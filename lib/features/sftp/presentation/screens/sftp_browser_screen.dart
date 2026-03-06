import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/widgets/shell_aware_app_bar.dart';
import 'package:sshvault/features/sftp/domain/entities/sftp_pane_source.dart';
import 'package:sshvault/features/sftp/domain/entities/transfer_item.dart';
import 'package:sshvault/features/sftp/presentation/providers/sftp_providers.dart';
import 'package:sshvault/features/sftp/presentation/widgets/sftp_pane.dart';
import 'package:sshvault/features/sftp/presentation/widgets/transfer_panel.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

class SftpBrowserScreen extends ConsumerStatefulWidget {
  const SftpBrowserScreen({super.key});

  @override
  ConsumerState<SftpBrowserScreen> createState() => _SftpBrowserScreenState();
}

class _SftpBrowserScreenState extends ConsumerState<SftpBrowserScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _showDownloadCompleteSheet(BuildContext context, String filePath) {
    final l10n = AppLocalizations.of(context)!;
    final fileName = p.basename(filePath);

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.sftpDownloadComplete(fileName),
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.share),
              title: Text(l10n.share),
              onTap: () {
                Navigator.pop(ctx);
                SharePlus.instance.share(ShareParams(files: [XFile(filePath)]));
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: Text(l10n.sftpSaveToFiles),
              onTap: () async {
                Navigator.pop(ctx);
                await _saveToChosenDirectory(context, filePath);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveToChosenDirectory(
    BuildContext context,
    String sourcePath,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    // Save left pane state — file picker opens an Android Activity that
    // may cause the pane notifier to rebuild and lose remote state.
    final savedPaneSource = ref.read(sftpPaneProvider(PaneSide.left)).source;
    final savedPanePath = ref.read(sftpPaneProvider(PaneSide.left)).currentPath;

    try {
      final fileName = p.basename(sourcePath);
      final fileBytes = await File(sourcePath).readAsBytes();

      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: l10n.sftpSaveToFiles,
        fileName: fileName,
        bytes: fileBytes,
      );

      // Restore pane state if reset during Android activity lifecycle
      await _restorePaneIfNeeded(savedPaneSource, savedPanePath);

      if (savedPath != null && context.mounted) {
        AdaptiveNotification.show(context, message: l10n.sftpFileSaved);
      }
    } catch (e) {
      // Still restore pane even on error
      await _restorePaneIfNeeded(savedPaneSource, savedPanePath);

      if (context.mounted) {
        AdaptiveNotification.show(
          context,
          message: l10n.sftpOperationFailed(errorMessage(e)),
        );
      }
    }
  }

  Future<void> _restorePaneIfNeeded(
    dynamic savedSource,
    String savedPath,
  ) async {
    final currentSource = ref.read(sftpPaneProvider(PaneSide.left)).source;
    if (savedSource is SftpPaneSourceRemote &&
        currentSource is! SftpPaneSourceRemote) {
      await ref
          .read(sftpPaneProvider(PaneSide.left).notifier)
          .restoreTo(savedSource, savedPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final transfers = ref.watch(transferManagerProvider);
    final hasActiveTransfers = transfers.any(
      (t) =>
          t.status.name == 'active' ||
          t.status.name == 'queued' ||
          t.status.name == 'paused',
    );

    // Listen for transfer completions and refresh target pane
    ref.listen<List<TransferItem>>(transferManagerProvider, (previous, next) {
      if (previous == null) return;
      for (final item in next) {
        final prev = previous.where((pi) => pi.id == item.id).firstOrNull;
        if (prev != null &&
            prev.status != TransferStatus.completed &&
            item.status == TransferStatus.completed) {
          // Refresh visible panes so the destination shows the new file
          ref.read(sftpPaneProvider(PaneSide.left).notifier).refresh();
          final screenWidth = MediaQuery.of(context).size.width;
          if (screenWidth >= 600) {
            ref.read(sftpPaneProvider(PaneSide.right).notifier).refresh();
          }

          // On narrow screens, show save/share options for completed downloads
          if (item.direction == TransferDirection.download && context.mounted) {
            final screenWidth = MediaQuery.of(context).size.width;
            if (screenWidth < 600) {
              _showDownloadCompleteSheet(context, item.destinationPath);
            }
          }
        }
      }
    });

    return AdaptiveScaffold.withAppBar(
      appBar: buildShellAppBar(context, title: l10n.sftpTitle),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 600;

          return Column(
            children: [
              Expanded(
                child: isWide
                    ? const Row(
                        children: [
                          Expanded(
                            child: SftpPane(side: PaneSide.left, isWide: true),
                          ),
                          VerticalDivider(width: 1),
                          Expanded(
                            child: SftpPane(side: PaneSide.right, isWide: true),
                          ),
                        ],
                      )
                    : const SftpPane(side: PaneSide.left, isWide: false),
              ),
              if (hasActiveTransfers || transfers.isNotEmpty)
                const TransferPanel(),
            ],
          );
        },
      ),
    );
  }
}
