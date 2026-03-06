import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:shellvault/features/sftp/domain/entities/sftp_bookmark_entity.dart';
import 'package:shellvault/features/sftp/domain/entities/sftp_pane_source.dart';
import 'package:shellvault/features/sftp/presentation/providers/sftp_bookmark_providers.dart';
import 'package:shellvault/features/sftp/presentation/providers/sftp_providers.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class SftpBookmarkBar extends ConsumerWidget {
  final PaneSide side;

  const SftpBookmarkBar({super.key, required this.side});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paneState = ref.watch(sftpPaneProvider(side));
    final source = paneState.source;
    if (source is! SftpPaneSourceRemote) return const SizedBox.shrink();

    final bookmarksAsync = ref.watch(sftpBookmarksProvider(source.serverId));

    return bookmarksAsync.when(
      data: (bookmarks) {
        if (bookmarks.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: bookmarks.length,
            separatorBuilder: (_, _) => const SizedBox(width: 4),
            itemBuilder: (context, index) {
              final bm = bookmarks[index];
              final isCurrent = paneState.currentPath == bm.path;

              return InputChip(
                label: Text(bm.label, style: const TextStyle(fontSize: 12)),
                avatar: const Icon(Icons.bookmark_outline, size: 14),
                selected: isCurrent,
                onPressed: () => ref
                    .read(sftpPaneProvider(side).notifier)
                    .navigateTo(bm.path),
                onDeleted: () => _deleteBookmark(ref, bm.id, source.serverId),
                deleteIcon: const Icon(Icons.close, size: 14),
                tooltip: bm.path,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              );
            },
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Future<void> _deleteBookmark(
    WidgetRef ref,
    String id,
    String serverId,
  ) async {
    final repo = ref.read(sftpBookmarkRepositoryProvider);
    await repo.delete(id);
    ref.invalidate(sftpBookmarksProvider(serverId));
  }

  static Future<void> addBookmark({
    required WidgetRef ref,
    required BuildContext context,
    required String serverId,
    required String path,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final segments = path.split('/');
    final defaultLabel = segments.where((s) => s.isNotEmpty).lastOrNull ?? '/';

    final controller = TextEditingController(text: defaultLabel);
    final label = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.sftpBookmarkAdd),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l10n.sftpBookmarkLabel,
            hintText: defaultLabel,
          ),
          onSubmitted: (v) =>
              Navigator.of(ctx).pop(v.trim().isEmpty ? defaultLabel : v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final text = controller.text.trim();
              Navigator.of(ctx).pop(text.isEmpty ? defaultLabel : text);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    controller.dispose();

    if (label == null) return;

    final repo = ref.read(sftpBookmarkRepositoryProvider);
    await repo.save(
      SftpBookmarkEntity(
        id: const Uuid().v4(),
        serverId: serverId,
        path: path,
        label: label,
        createdAt: DateTime.now(),
      ),
    );
    ref.invalidate(sftpBookmarksProvider(serverId));
  }
}
