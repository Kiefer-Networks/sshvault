import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/features/sftp/domain/entities/sftp_entry.dart';
import 'package:sshvault/features/sftp/domain/entities/sftp_pane_source.dart';
import 'package:sshvault/features/sftp/presentation/providers/sftp_providers.dart';
import 'package:sshvault/features/sftp/presentation/widgets/chmod_dialog.dart';
import 'package:sshvault/features/sftp/presentation/widgets/create_symlink_dialog.dart';
import 'package:sshvault/features/sftp/presentation/widgets/file_preview_dialog.dart';
import 'package:sshvault/features/sftp/presentation/widgets/rename_dialog.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

class SftpEntryTile extends ConsumerWidget {
  final SftpEntry entry;
  final bool isSelected;
  final bool hasSelection;
  final bool isWideMode;
  final VoidCallback onTap;
  final VoidCallback onTransfer;
  final VoidCallback? onDownload;
  final PaneSide side;

  const SftpEntryTile({
    super.key,
    required this.entry,
    required this.isSelected,
    required this.hasSelection,
    this.isWideMode = false,
    required this.onTap,
    required this.onTransfer,
    this.onDownload,
    required this.side,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final l10n = AppLocalizations.of(context)!;
    final paneSource = ref.watch(sftpPaneProvider(side)).source;
    final isRemote = paneSource is SftpPaneSourceRemote;
    final isFile = entry.type == SftpEntryType.file;

    // Start action pane (swipe right): Transfer / Download / Preview
    final startActions = <SlidableAction>[];
    if (isFile && isWideMode) {
      startActions.add(
        SlidableAction(
          onPressed: (_) => onTransfer(),
          backgroundColor: theme.colorScheme.tertiary,
          foregroundColor: theme.colorScheme.onTertiary,
          icon: Icons.swap_horiz,
          label: l10n.sftpCopyToOtherPane,
        ),
      );
    }
    if (isFile && !isWideMode && isRemote && onDownload != null) {
      startActions.add(
        SlidableAction(
          onPressed: (_) => onDownload!(),
          backgroundColor: theme.colorScheme.tertiary,
          foregroundColor: theme.colorScheme.onTertiary,
          icon: Icons.download,
          label: l10n.sftpDownload,
        ),
      );
    }
    if (isFile) {
      startActions.add(
        SlidableAction(
          onPressed: (_) => showDialog(
            context: context,
            builder: (_) => FilePreviewDialog(entry: entry, side: side),
          ),
          backgroundColor: theme.colorScheme.secondary,
          foregroundColor: theme.colorScheme.onSecondary,
          icon: Icons.visibility,
          label: l10n.sftpFilePreview,
        ),
      );
    }
    if (isFile && entry.isArchive) {
      startActions.add(
        SlidableAction(
          onPressed: (_) => _extractArchive(context, ref),
          backgroundColor: theme.colorScheme.primaryContainer,
          foregroundColor: theme.colorScheme.onPrimaryContainer,
          icon: Icons.unarchive,
          label: l10n.sftpExtractArchive,
        ),
      );
    }

    // End action pane (swipe left): Rename, [Chmod], Delete
    final endActions = <SlidableAction>[
      SlidableAction(
        onPressed: (_) => _showRenameDialog(context, ref),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        icon: Icons.edit,
        label: l10n.sftpRename,
      ),
    ];
    if (isRemote) {
      endActions.add(
        SlidableAction(
          onPressed: (_) => _showChmodDialog(context, ref),
          backgroundColor: theme.colorScheme.inversePrimary,
          foregroundColor: theme.colorScheme.onPrimaryContainer,
          icon: Icons.security,
          label: l10n.sftpChmod,
        ),
      );
    }
    endActions.add(
      SlidableAction(
        onPressed: (_) => _confirmDelete(context, ref),
        backgroundColor: theme.colorScheme.error,
        foregroundColor: theme.colorScheme.onError,
        icon: Icons.delete,
        label: l10n.sftpDelete,
      ),
    );

    final tile = Slidable(
      startActionPane: startActions.isNotEmpty
          ? ActionPane(motion: const BehindMotion(), children: startActions)
          : null,
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: endActions,
      ),
      child: ListTile(
        leading: hasSelection
            ? Checkbox(
                value: isSelected,
                onChanged: (_) => ref
                    .read(sftpPaneProvider(side).notifier)
                    .toggleSelection(entry.path),
              )
            : Icon(_iconForEntry(entry), color: _colorForEntry(entry, theme)),
        title: Text(entry.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(_subtitle(entry), style: theme.textTheme.bodySmall),
        trailing: entry.type == SftpEntryType.directory && !hasSelection
            ? const Icon(Icons.chevron_right)
            : null,
        selected: isSelected,
        selectedTileColor: theme.colorScheme.primary.withAlpha(26),
        onTap: onTap,
      ),
    );

    return GestureDetector(
      onSecondaryTapDown: (details) =>
          _showContextMenu(context, ref, details.globalPosition),
      onLongPressStart: (details) =>
          _showContextMenu(context, ref, details.globalPosition),
      child: tile,
    );
  }

  void _showContextMenu(BuildContext context, WidgetRef ref, Offset position) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final paneSource = ref.read(sftpPaneProvider(side)).source;
    final isRemote = paneSource is SftpPaneSourceRemote;
    final isFile = entry.type == SftpEntryType.file;
    final isDirectory = entry.type == SftpEntryType.directory;

    final items = <PopupMenuEntry<String>>[];

    // Directory: Open
    if (isDirectory) {
      items.add(
        PopupMenuItem(
          value: 'open',
          child: ListTile(
            leading: const Icon(Icons.folder_open),
            title: Text(l10n.sftpOpen),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      );
    }

    // File: Transfer (only wide mode)
    if (isFile && isWideMode) {
      items.add(
        PopupMenuItem(
          value: 'transfer',
          child: ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: Text(l10n.sftpCopyToOtherPane),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      );
    }

    // File: Download (mobile + remote only)
    if (isFile && !isWideMode && isRemote) {
      items.add(
        PopupMenuItem(
          value: 'download',
          child: ListTile(
            leading: const Icon(Icons.download),
            title: Text(l10n.sftpDownload),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      );
    }

    // File: Preview
    if (isFile) {
      items.add(
        PopupMenuItem(
          value: 'preview',
          child: ListTile(
            leading: const Icon(Icons.visibility),
            title: Text(l10n.sftpFilePreview),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      );
    }

    // Extract (archive files only)
    if (isFile && entry.isArchive) {
      items.add(
        PopupMenuItem(
          value: 'extract',
          child: ListTile(
            leading: const Icon(Icons.unarchive),
            title: Text(l10n.sftpExtractArchive),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      );
    }

    // Select
    items.add(
      PopupMenuItem(
        value: 'select',
        child: ListTile(
          leading: const Icon(Icons.check_circle_outline),
          title: Text(l10n.sftpSelect),
          dense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );

    // Rename
    items.add(
      PopupMenuItem(
        value: 'rename',
        child: ListTile(
          leading: const Icon(Icons.edit),
          title: Text(l10n.sftpRename),
          dense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );

    // Chmod (remote only)
    if (isRemote) {
      items.add(
        PopupMenuItem(
          value: 'chmod',
          child: ListTile(
            leading: const Icon(Icons.security),
            title: Text(l10n.sftpChmod),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      );
    }

    // Symlink (remote + directory only)
    if (isRemote && isDirectory) {
      items.add(
        PopupMenuItem(
          value: 'symlink',
          child: ListTile(
            leading: const Icon(Icons.link),
            title: Text(l10n.sftpCreateSymlink),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      );
    }

    // Divider before delete
    items.add(const PopupMenuDivider());

    // Delete
    items.add(
      PopupMenuItem(
        value: 'delete',
        child: ListTile(
          leading: Icon(Icons.delete, color: theme.colorScheme.error),
          title: Text(
            l10n.sftpDelete,
            style: TextStyle(color: theme.colorScheme.error),
          ),
          dense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx,
        position.dy,
      ),
      items: items,
    ).then((value) {
      if (value != null && context.mounted) {
        _handleMenuAction(context, ref, value);
      }
    });
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'open':
        onTap();
      case 'transfer':
        onTransfer();
      case 'download':
        onDownload?.call();
      case 'preview':
        showDialog(
          context: context,
          builder: (_) => FilePreviewDialog(entry: entry, side: side),
        );
      case 'extract':
        _extractArchive(context, ref);
      case 'select':
        ref.read(sftpPaneProvider(side).notifier).toggleSelection(entry.path);
      case 'rename':
        _showRenameDialog(context, ref);
      case 'chmod':
        _showChmodDialog(context, ref);
      case 'symlink':
        _showCreateSymlinkDialog(context, ref);
      case 'delete':
        _confirmDelete(context, ref);
    }
  }

  IconData _iconForEntry(SftpEntry entry) {
    switch (entry.type) {
      case SftpEntryType.directory:
        return Icons.folder;
      case SftpEntryType.link:
        return Icons.link;
      case SftpEntryType.file:
        final ext = entry.name.split('.').last.toLowerCase();
        return switch (ext) {
          'txt' ||
          'md' ||
          'log' ||
          'conf' ||
          'cfg' ||
          'ini' => Icons.description,
          'jpg' || 'jpeg' || 'png' || 'gif' || 'svg' || 'webp' => Icons.image,
          'mp3' || 'wav' || 'flac' || 'ogg' => Icons.audio_file,
          'mp4' || 'avi' || 'mkv' || 'mov' => Icons.video_file,
          'zip' || 'tar' || 'gz' || 'bz2' || '7z' || 'rar' => Icons.archive,
          'sh' ||
          'bash' ||
          'py' ||
          'rb' ||
          'js' ||
          'dart' ||
          'go' => Icons.code,
          'pdf' => Icons.picture_as_pdf,
          _ => Icons.insert_drive_file,
        };
    }
  }

  Color _colorForEntry(SftpEntry entry, ThemeData theme) {
    switch (entry.type) {
      case SftpEntryType.directory:
        return theme.colorScheme.primary;
      case SftpEntryType.link:
        return theme.colorScheme.tertiary;
      case SftpEntryType.file:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  String _subtitle(SftpEntry entry) {
    final parts = <String>[];
    if (entry.type == SftpEntryType.file) {
      parts.add(_formatSize(entry.size));
    }
    if (entry.type == SftpEntryType.link && entry.linkTarget != null) {
      parts.add('-> ${entry.linkTarget}');
    }
    parts.add(_formatDate(entry.modified));
    if (entry.permissions != null) {
      parts.add(_formatPermissions(entry.permissions!));
    }
    return parts.join('  ');
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatPermissions(int mode) {
    String result = '';
    const rwx = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx'];
    result += rwx[(mode >> 6) & 7];
    result += rwx[(mode >> 3) & 7];
    result += rwx[mode & 7];
    return result;
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref) async {
    final newName = await RenameDialog.show(context, currentName: entry.name);
    if (newName != null && newName.isNotEmpty && newName != entry.name) {
      ref.read(sftpPaneProvider(side).notifier).rename(entry.path, newName);
    }
  }

  void _showChmodDialog(BuildContext context, WidgetRef ref) async {
    final newPermissions = await ChmodDialog.show(
      context,
      initialPermissions: entry.permissions,
    );
    if (newPermissions != null) {
      // Preserve file type bits from original mode, replace only permission bits
      final fileTypeBits = (entry.permissions ?? 0) & ~0x1FF;
      final fullMode = fileTypeBits | (newPermissions & 0x1FF);
      ref.read(sftpPaneProvider(side).notifier).chmod(entry.path, fullMode);
    }
  }

  void _showCreateSymlinkDialog(BuildContext context, WidgetRef ref) async {
    final result = await CreateSymlinkDialog.show(context);
    if (result != null) {
      ref
          .read(sftpPaneProvider(side).notifier)
          .createSymlink(result.target, result.name);
    }
  }

  void _extractArchive(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;

    AdaptiveNotification.show(context, message: l10n.sftpExtracting);

    final result = await ref
        .read(sftpPaneProvider(side).notifier)
        .extractArchive(entry.path);

    if (!context.mounted) return;

    result.fold(
      onSuccess: (_) {
        AdaptiveNotification.show(context, message: l10n.sftpExtractSuccess);
      },
      onFailure: (failure) {
        AdaptiveNotification.show(
          context,
          message: l10n.sftpExtractFailed(failure.message),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showAdaptiveConfirmDialog(
      context,
      title: l10n.sftpDelete,
      message: l10n.sftpConfirmDeleteSingle(entry.name),
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.sftpDelete,
      isDestructive: true,
    );
    if (confirmed == true) {
      ref.read(sftpPaneProvider(side).notifier).toggleSelection(entry.path);
      ref.read(sftpPaneProvider(side).notifier).deleteSelected();
    }
  }
}
