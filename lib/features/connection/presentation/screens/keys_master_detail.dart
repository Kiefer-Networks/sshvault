import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/features/connection/presentation/providers/ssh_key_providers.dart';
import 'package:sshvault/features/connection/presentation/screens/ssh_key_form_dialog.dart';
import 'package:sshvault/features/connection/presentation/screens/ssh_key_list_screen.dart';

/// Desktop SSH Keys branch: a key list column next to a detail/edit pane
/// for whichever key is selected — same master/detail pattern as
/// `HostsMasterDetail`. "Add Key" keeps its full-screen Generate/Import
/// tabbed flow rather than being embedded here, same as Hosts' own
/// "Add Server".
class KeysMasterDetail extends StatelessWidget {
  const KeysMasterDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: Consumer(
            builder: (context, ref, _) => SshKeyListScreen(
              dense: true,
              onKeySelected: (id) =>
                  ref.read(desktopSelectedKeyIdProvider.notifier).state = id,
            ),
          ),
        ),
        VerticalDivider(
          width: 1,
          thickness: 1,
          color: theme.colorScheme.outlineVariant,
        ),
        const Expanded(child: _KeyDetailPane()),
      ],
    );
  }
}

class _KeyDetailPane extends ConsumerWidget {
  const _KeyDetailPane();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(desktopSelectedKeyIdProvider);
    if (selectedId == null) {
      final theme = Theme.of(context);
      return Center(
        child: Text(
          'Select a key to view its details',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final keysAsync = ref.watch(sshKeyListProvider);
    final key = keysAsync.value?.where((k) => k.id == selectedId).firstOrNull;
    if (key == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    return SshKeyFormDialog(
      key: ValueKey('key-${key.id}'),
      existingKey: key,
      embedded: true,
      onSaved: () {},
      onCancel: () =>
          ref.read(desktopSelectedKeyIdProvider.notifier).state = null,
    );
  }
}
