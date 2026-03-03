import 'package:flutter/material.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/features/connection/presentation/providers/ssh_key_providers.dart';

class SshKeySelector extends ConsumerWidget {
  final String? selectedKeyId;
  final ValueChanged<String?> onChanged;

  const SshKeySelector({
    super.key,
    required this.selectedKeyId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keysAsync = ref.watch(sshKeyListProvider);
    final l10n = AppLocalizations.of(context)!;

    return keysAsync.when(
      data: (keys) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownMenu<String?>(
              initialSelection: keys.any((k) => k.id == selectedKeyId)
                  ? selectedKeyId
                  : null,
              expandedInsets: EdgeInsets.zero,
              requestFocusOnTap: false,
              label: Text(l10n.sshKeySelectorLabel),
              leadingIcon: const Icon(Icons.vpn_key_outlined),
              dropdownMenuEntries: [
                DropdownMenuEntry<String?>(
                  value: null,
                  label: l10n.sshKeySelectorNone,
                ),
                ...keys.map(
                  (k) => DropdownMenuEntry<String?>(
                    value: k.id,
                    label: '${k.name} (${k.keyType.displayName})',
                  ),
                ),
              ],
              onSelected: onChanged,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: AdaptiveButton.textIcon(
                onPressed: () => context.push('/keys'),
                icon: const Icon(Icons.settings, size: 16),
                label: Text(l10n.sshKeySelectorManage),
              ),
            ),
          ],
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (_, _) => Text(l10n.sshKeySelectorError),
    );
  }
}
