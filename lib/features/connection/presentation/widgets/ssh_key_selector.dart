import 'package:flutter/material.dart';
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

    return keysAsync.when(
      data: (keys) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String?>(
              initialValue: keys.any((k) => k.id == selectedKeyId)
                  ? selectedKeyId
                  : null,
              decoration: const InputDecoration(
                labelText: 'SSH Key',
                prefixIcon: Icon(Icons.vpn_key_outlined),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('No managed key'),
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
              child: TextButton.icon(
                onPressed: () => context.push('/keys'),
                icon: const Icon(Icons.settings, size: 16),
                label: const Text('Manage Keys...'),
              ),
            ),
          ],
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (_, _) => const Text('Failed to load SSH keys'),
    );
  }
}
