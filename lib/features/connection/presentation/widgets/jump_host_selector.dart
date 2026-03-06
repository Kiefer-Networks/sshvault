import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';

class JumpHostSelector extends ConsumerWidget {
  final String? currentServerId;
  final String? selectedJumpHostId;
  final ValueChanged<String?> onChanged;

  const JumpHostSelector({
    super.key,
    this.currentServerId,
    required this.selectedJumpHostId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serversAsync = ref.watch(serverListProvider);
    final l10n = AppLocalizations.of(context)!;

    return serversAsync.when(
      data: (servers) {
        final available = servers
            .where((s) => s.id != currentServerId)
            .toList();

        if (available.isEmpty) return const SizedBox.shrink();

        return DropdownMenu<String?>(
          initialSelection: available.any((s) => s.id == selectedJumpHostId)
              ? selectedJumpHostId
              : null,
          expandedInsets: EdgeInsets.zero,
          requestFocusOnTap: false,
          label: Text(l10n.jumpHost),
          leadingIcon: const Icon(Icons.route_outlined),
          dropdownMenuEntries: [
            DropdownMenuEntry<String?>(value: null, label: l10n.jumpHostNone),
            ...available.map(
              (s) => DropdownMenuEntry<String?>(
                value: s.id,
                label: l10n.jumpHostEntryLabel(s.name, s.hostname),
              ),
            ),
          ],
          onSelected: onChanged,
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
