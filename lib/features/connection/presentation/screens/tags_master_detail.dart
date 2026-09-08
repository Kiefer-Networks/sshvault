import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/features/connection/presentation/providers/tag_providers.dart';
import 'package:sshvault/features/connection/presentation/screens/tag_form_dialog.dart';
import 'package:sshvault/features/connection/presentation/screens/tag_list_screen.dart';

/// Desktop Tags branch: a tag list column next to a detail/edit pane for
/// whichever tag is selected — same master/detail pattern as
/// `HostsMasterDetail`.
class TagsMasterDetail extends StatelessWidget {
  const TagsMasterDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: Consumer(
            builder: (context, ref, _) => TagListScreen(
              dense: true,
              onTagSelected: (id) {
                ref.read(tagsCreatingProvider.notifier).state = false;
                ref.read(desktopSelectedTagIdProvider.notifier).state = id;
              },
              onAddPressed: () {
                ref.read(desktopSelectedTagIdProvider.notifier).state = null;
                ref.read(tagsCreatingProvider.notifier).state = true;
              },
            ),
          ),
        ),
        VerticalDivider(
          width: 1,
          thickness: 1,
          color: theme.colorScheme.outlineVariant,
        ),
        const Expanded(child: _TagDetailPane()),
      ],
    );
  }
}

class _TagDetailPane extends ConsumerWidget {
  const _TagDetailPane();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creating = ref.watch(tagsCreatingProvider);
    if (creating) {
      return TagFormDialog(
        key: const ValueKey('create'),
        embedded: true,
        onSaved: () => ref.read(tagsCreatingProvider.notifier).state = false,
        onCancel: () => ref.read(tagsCreatingProvider.notifier).state = false,
      );
    }

    final selectedId = ref.watch(desktopSelectedTagIdProvider);
    if (selectedId == null) {
      final theme = Theme.of(context);
      return Center(
        child: Text(
          'Select a tag to view its details',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final tagsAsync = ref.watch(tagListProvider);
    final tag = tagsAsync.value?.where((t) => t.id == selectedId).firstOrNull;
    if (tag == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    return TagFormDialog(
      key: ValueKey('tag-${tag.id}'),
      tag: tag,
      embedded: true,
      onSaved: () {},
      onCancel: () =>
          ref.read(desktopSelectedTagIdProvider.notifier).state = null,
    );
  }
}
