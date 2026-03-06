import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/features/sftp/domain/entities/sftp_pane_source.dart';
import 'package:sshvault/features/sftp/presentation/providers/sftp_providers.dart';
import 'package:sshvault/features/sftp/presentation/widgets/sftp_bookmark_bar.dart';

class SftpBreadcrumb extends ConsumerStatefulWidget {
  final PaneSide side;

  const SftpBreadcrumb({super.key, required this.side});

  @override
  ConsumerState<SftpBreadcrumb> createState() => _SftpBreadcrumbState();
}

class _SftpBreadcrumbState extends ConsumerState<SftpBreadcrumb> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent > 0) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final paneState = ref.watch(sftpPaneProvider(widget.side));
    final theme = Theme.of(context);
    final isLocal = paneState.source is SftpPaneSourceLocal;
    final separator = isLocal ? '/' : '/';

    final segments = paneState.currentPath.split(separator);
    final parts = segments.where((s) => s.isNotEmpty).toList();

    _scrollToEnd();

    return SizedBox(
      height: 36,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 18),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              onPressed: () =>
                  ref.read(sftpPaneProvider(widget.side).notifier).navigateUp(),
            ),
            const SizedBox(width: 4),
            if (paneState.source is SftpPaneSourceRemote)
              IconButton(
                icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: () {
                  final source = paneState.source as SftpPaneSourceRemote;
                  SftpBookmarkBar.addBookmark(
                    ref: ref,
                    context: context,
                    serverId: source.serverId,
                    path: paneState.currentPath,
                  );
                },
              ),
            Expanded(
              child: ListView.separated(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: parts.length + 1,
                separatorBuilder: (_, _) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(Icons.chevron_right, size: 14),
                ),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: () => ref
                          .read(sftpPaneProvider(widget.side).notifier)
                          .navigateTo(separator),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        child: Text(
                          separator,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    );
                  }

                  final pathUpToIndex =
                      separator + parts.sublist(0, index).join(separator);
                  final isLast = index == parts.length;

                  return InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: isLast
                        ? null
                        : () => ref
                              .read(sftpPaneProvider(widget.side).notifier)
                              .navigateTo(pathUpToIndex),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
                      ),
                      child: Text(
                        parts[index - 1],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isLast
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.primary,
                          fontWeight: isLast
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
