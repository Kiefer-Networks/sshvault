import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/connection/presentation/screens/server_detail_screen.dart';
import 'package:sshvault/features/connection/presentation/screens/server_form_screen.dart';
import 'package:sshvault/features/connection/presentation/screens/server_list_screen.dart';
import 'package:sshvault/features/connection/presentation/widgets/command_palette.dart';

/// Desktop Hosts branch: a fixed-width host list column (the existing,
/// unchanged [ServerListScreen] — its own tap handler already sets
/// [desktopSelectedServerIdProvider], this just gives it somewhere to be
/// read) next to a detail/edit pane for whichever host is selected.
///
/// Replaces the old `CommandDeckHomeScreen`, which showed nothing but a
/// Ctrl+K hint and hid the real host list entirely — this restores an
/// actual, browsable list while keeping Ctrl+K just as available (it's a
/// global shortcut in `desktop_shortcuts.dart`, wired above the router,
/// completely unaffected by whatever renders in this branch).
class HostsMasterDetail extends StatelessWidget {
  const HostsMasterDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
          width: 320,
          child: Consumer(
            builder: (context, ref, _) => ServerListScreen(
              dense: true,
              // The list's own "+" skips the SSH-config bulk-import
              // prompt (ServerImportFlow.addServer) and goes straight to
              // a blank inline form in the detail pane — a quick, single-
              // host add. Bulk-importing many hosts from ~/.ssh/config
              // stays reachable from the command palette's own "Add
              // Server…" entry, unchanged, since that's a deliberately
              // different, heavier flow.
              onAddPressed: () {
                ref.read(desktopSelectedServerIdProvider.notifier).state = null;
                ref.read(hostsCreatingProvider.notifier).state = true;
              },
            ),
          ),
        ),
        VerticalDivider(
          width: 1,
          thickness: 1,
          color: theme.colorScheme.outlineVariant,
        ),
        const Expanded(child: _HostDetailPane()),
      ],
    );
  }
}

class _HostDetailPane extends ConsumerStatefulWidget {
  const _HostDetailPane();

  @override
  ConsumerState<_HostDetailPane> createState() => _HostDetailPaneState();
}

class _HostDetailPaneState extends ConsumerState<_HostDetailPane> {
  bool _editing = false;

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(desktopSelectedServerIdProvider);
    final creating = ref.watch(hostsCreatingProvider);

    // Picking a different host always drops back to view mode — carrying
    // an edit session for host A over onto host B would silently discard
    // whatever B's fields actually are underneath a stale form.
    ref.listen<String?>(desktopSelectedServerIdProvider, (previous, next) {
      if (previous == next) return;
      // Clicking a row while the create form was open means the user
      // picked an existing host instead — drop the half-filled create
      // form rather than leaving it stuck in front of the newly selected
      // host's real detail view.
      if (ref.read(hostsCreatingProvider)) {
        ref.read(hostsCreatingProvider.notifier).state = false;
      }
      if (_editing) setState(() => _editing = false);
    });

    if (creating) {
      return ServerFormScreen(
        key: const ValueKey('create'),
        embedded: true,
        onSaved: () {
          ref.read(hostsCreatingProvider.notifier).state = false;
        },
        onCancel: () => ref.read(hostsCreatingProvider.notifier).state = false,
      );
    }

    if (selectedId == null) {
      return const _NoHostSelected();
    }

    if (_editing) {
      return ServerFormScreen(
        key: ValueKey('edit-$selectedId'),
        serverId: selectedId,
        embedded: true,
        onSaved: () => setState(() => _editing = false),
        onCancel: () => setState(() => _editing = false),
      );
    }

    return ServerDetailScreen(
      key: ValueKey('detail-$selectedId'),
      serverId: selectedId,
      embedded: true,
      onEdit: () => setState(() => _editing = true),
      onDeleted: () =>
          ref.read(desktopSelectedServerIdProvider.notifier).state = null,
    );
  }
}

class _NoHostSelected extends StatelessWidget {
  const _NoHostSelected();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.dns_outlined,
            size: 40,
            color: theme.colorScheme.onSurfaceVariant.withAlpha(140),
          ),
          const SizedBox(height: 16),
          // Hardcoded English, matching the same precedent already set by
          // CommandDeckHomeScreen's own quick-connect hint — new desktop-
          // only UI text in this shell is not routed through the 28-locale
          // ARB pipeline.
          Text(
            'Select a host to view its details',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          _QuickConnectChip(onTap: () => showCommandPalette(context)),
        ],
      ),
    );
  }
}

class _QuickConnectChip extends StatelessWidget {
  final VoidCallback onTap;
  const _QuickConnectChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _KeyCap(Platform.isMacOS ? '⌘' : 'Ctrl'),
              const SizedBox(width: 4),
              Text(
                '+',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(width: 4),
              const _KeyCap('K'),
            ],
          ),
        ),
      ),
    );
  }
}

class _KeyCap extends StatelessWidget {
  final String label;
  const _KeyCap(this.label);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppConstants.monospaceFontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
