import 'dart:convert';
import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/features/sftp/domain/entities/sftp_entry.dart';
import 'package:shellvault/features/sftp/domain/entities/sftp_pane_source.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/sftp/presentation/providers/sftp_providers.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class FilePreviewDialog extends ConsumerStatefulWidget {
  final SftpEntry entry;
  final PaneSide side;

  const FilePreviewDialog({super.key, required this.entry, required this.side});

  @override
  ConsumerState<FilePreviewDialog> createState() => _FilePreviewDialogState();
}

class _FilePreviewDialogState extends ConsumerState<FilePreviewDialog> {
  String? _content;
  bool _loading = true;
  String? _error;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _loadPreview();
    }
  }

  Future<void> _loadPreview() async {
    final paneState = ref.read(sftpPaneProvider(widget.side));
    final source = paneState.source;

    if (source is SftpPaneSourceRemote) {
      final connMgr = ref.read(sftpConnectionManagerProvider);
      final container = ProviderScope.containerOf(context);
      final clientResult = await connMgr.getClient(source.serverId, container);

      switch (clientResult) {
        case Success(:final data):
          final sftpService = ref.read(sftpServiceProvider);
          final result = await sftpService.readFilePreview(
            data,
            widget.entry.path,
          );
          result.fold(
            onSuccess: (bytes) {
              if (mounted) {
                setState(() {
                  _content = const Utf8Decoder(
                    allowMalformed: true,
                  ).convert(bytes);
                  _loading = false;
                });
              }
            },
            onFailure: (f) {
              if (mounted) {
                setState(() {
                  _error = f.message;
                  _loading = false;
                });
              }
            },
          );
        case Err(:final error):
          if (mounted) {
            setState(() {
              _error = error.message;
              _loading = false;
            });
          }
      }
    } else {
      // Local file preview
      try {
        final bytes = await File(widget.entry.path).readAsBytes();
        // Only read first 64KB
        final preview = bytes.length > 65536 ? bytes.sublist(0, 65536) : bytes;
        if (mounted) {
          setState(() {
            _content = const Utf8Decoder(allowMalformed: true).convert(preview);
            _loading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _error = e.toString();
            _loading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(l10n.sftpFilePreview)),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [_FileInfoView(entry: widget.entry)],
                ),
              )
            : SingleChildScrollView(
                child: SelectableText(
                  _content ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
              ),
      ),
    );
  }
}

class _FileInfoView extends StatelessWidget {
  final SftpEntry entry;

  const _FileInfoView({required this.entry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.info_outline, size: 48, color: theme.colorScheme.primary),
        const SizedBox(height: 16),
        _infoRow(l10n.sftpFileType, entry.type.name, theme),
        _infoRow(l10n.sftpFileSize, _formatSize(entry.size), theme),
        _infoRow(
          l10n.sftpFileModified,
          '${entry.modified.year}-${entry.modified.month.toString().padLeft(2, '0')}-${entry.modified.day.toString().padLeft(2, '0')}',
          theme,
        ),
        if (entry.permissions != null)
          _infoRow(
            l10n.sftpFilePermissions,
            entry.permissions!.toRadixString(8),
            theme,
          ),
        if (entry.owner != null)
          _infoRow(l10n.sftpFileOwner, entry.owner!, theme),
        if (entry.linkTarget != null)
          _infoRow(l10n.sftpFileLinkTarget, entry.linkTarget!, theme),
      ],
    );
  }

  Widget _infoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
