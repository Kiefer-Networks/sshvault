import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/features/connection/presentation/providers/folder_providers.dart';
import 'package:sshvault/features/connection/presentation/screens/folder_browser_screen.dart';
import 'package:sshvault/features/connection/presentation/screens/folder_form_dialog.dart';

/// Desktop Folders branch: a folder list column next to a detail/edit pane
/// for whichever folder is selected — same master/detail pattern as
/// `HostsMasterDetail`.
class FoldersMasterDetail extends StatelessWidget {
  const FoldersMasterDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: Consumer(
            builder: (context, ref, _) => FolderBrowserScreen(
              dense: true,
              onFolderSelected: (id) {
                // Selecting an existing folder always wins over a
                // half-filled create form still open in the pane.
                ref.read(foldersCreatingProvider.notifier).state = false;
                ref.read(desktopSelectedFolderIdProvider.notifier).state = id;
              },
              onAddPressed: () {
                ref.read(desktopSelectedFolderIdProvider.notifier).state = null;
                ref.read(foldersCreatingProvider.notifier).state = true;
              },
            ),
          ),
        ),
        VerticalDivider(
          width: 1,
          thickness: 1,
          color: theme.colorScheme.outlineVariant,
        ),
        const Expanded(child: _FolderDetailPane()),
      ],
    );
  }
}

class _FolderDetailPane extends ConsumerWidget {
  const _FolderDetailPane();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creating = ref.watch(foldersCreatingProvider);
    if (creating) {
      return FolderFormDialog(
        key: const ValueKey('create'),
        embedded: true,
        onSaved: () => ref.read(foldersCreatingProvider.notifier).state = false,
        onCancel: () =>
            ref.read(foldersCreatingProvider.notifier).state = false,
      );
    }

    final selectedId = ref.watch(desktopSelectedFolderIdProvider);
    if (selectedId == null) {
      final theme = Theme.of(context);
      return Center(
        child: Text(
          'Select a folder to view its details',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final foldersAsync = ref.watch(folderListProvider);
    final folder = foldersAsync.value
        ?.where((f) => f.id == selectedId)
        .firstOrNull;
    if (folder == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    return FolderFormDialog(
      key: ValueKey('folder-${folder.id}'),
      folder: folder,
      embedded: true,
      onSaved: () {},
      onCancel: () =>
          ref.read(desktopSelectedFolderIdProvider.notifier).state = null,
    );
  }
}
