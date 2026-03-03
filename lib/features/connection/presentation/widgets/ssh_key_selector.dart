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
            DropdownButtonFormField<String?>(
              initialValue: keys.any((k) => k.id == selectedKeyId)
                  ? selectedKeyId
                  : null,
              decoration: InputDecoration(
                labelText: l10n.sshKeySelectorLabel,
                prefixIcon: const Icon(Icons.vpn_key_outlined),
              ),
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(l10n.sshKeySelectorNone),
                ),
                ...keys.map(
                  (k) => DropdownMenuItem(
                    value: k.id,
                    child: Text(
                      '${k.name} (${k.keyType.displayName})',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
              onChanged: onChanged,
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
