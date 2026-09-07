import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/routing/shell_navigation_provider.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/connection/presentation/widgets/confirm_dialog.dart';
import 'package:sshvault/features/connection/presentation/widgets/server_import_flow.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

/// Opens the Command Deck's ⌘K palette — the desktop shell's single entry
/// point for connecting to a host or jumping to any section. There is no
/// persistent host list or search bar in the Command Deck shell; this is
/// the whole of it.
Future<void> showCommandPalette(BuildContext context) {
  return showGeneralDialog<void>(
    context: context,
    barrierLabel: 'Command palette',
    barrierDismissible: true,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 120),
    pageBuilder: (context, _, _) => const _CommandPalette(),
    transitionBuilder: (context, animation, _, child) => FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: ScaleTransition(
        scale: Tween(
          begin: 0.97,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      ),
    ),
  );
}

sealed class _PaletteEntry {
  String get sortKey;
}

class _ServerEntry extends _PaletteEntry {
  final ServerEntity server;
  _ServerEntry(this.server);
  @override
  String get sortKey => server.name;
}

class _CommandEntry extends _PaletteEntry {
  final String label;
  final String hint;
  final IconData icon;
  final void Function(BuildContext context, WidgetRef ref) run;
  _CommandEntry({
    required this.label,
    required this.hint,
    required this.icon,
    required this.run,
  });
  @override
  String get sortKey => label;
}

void _goBranch(WidgetRef ref, int index) {
  ref.read(shellNavigationProvider)?.goBranch(index, initialLocation: true);
}

// Hint strings are shown verbatim in the palette row — only ones backed by
// a real binding in `_DesktopShortcuts` (app_shell.dart) belong here. A
// hint for a shortcut that doesn't exist would be a lie the UI tells.
List<_CommandEntry> _navigationCommands() => [
  _CommandEntry(
    label: 'Go to Hosts',
    hint: _mod('T'),
    icon: Icons.dns_outlined,
    run: (context, ref) => _goBranch(ref, 0),
  ),
  _CommandEntry(
    label: 'Go to SFTP',
    hint: '',
    icon: Icons.folder_copy_outlined,
    run: (context, ref) => _goBranch(ref, 1),
  ),
  _CommandEntry(
    label: 'Go to Snippets',
    hint: '',
    icon: Icons.code_outlined,
    run: (context, ref) => _goBranch(ref, 2),
  ),
  _CommandEntry(
    label: 'Go to SSH Keys',
    hint: '',
    icon: Icons.vpn_key_outlined,
    run: (context, ref) => _goBranch(ref, 3),
  ),
  _CommandEntry(
    label: 'Go to Folders',
    hint: '',
    icon: Icons.folder_outlined,
    run: (context, ref) => _goBranch(ref, 4),
  ),
  _CommandEntry(
    label: 'Go to Tags',
    hint: '',
    icon: Icons.label_outline,
    run: (context, ref) => _goBranch(ref, 5),
  ),
  _CommandEntry(
    label: 'Go to Terminal',
    hint: '',
    icon: Icons.terminal_outlined,
    run: (context, ref) => _goBranch(ref, AppConstants.terminalBranchIndex),
  ),
  _CommandEntry(
    label: 'Open Settings',
    hint: _mod(','),
    icon: Icons.settings_outlined,
    run: (context, ref) => context.push('/settings'),
  ),
  _CommandEntry(
    label: 'Add Server…',
    hint: '',
    icon: Icons.add,
    run: (context, ref) => ServerImportFlow.addServer(context, ref),
  ),
];

String _mod(String key) => '${Platform.isMacOS ? '⌘' : 'Ctrl+'}$key';

class _CommandPalette extends ConsumerStatefulWidget {
  const _CommandPalette();

  @override
  ConsumerState<_CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends ConsumerState<_CommandPalette> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  int _selected = 0;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<_PaletteEntry> _filtered(List<ServerEntity> servers) {
    final query = _controller.text.trim().toLowerCase();
    final commands = _navigationCommands();
    if (query.isEmpty) {
      final recents = [...servers]
        ..sort((a, b) {
          final ad = a.lastConnectedAt;
          final bd = b.lastConnectedAt;
          if (ad == null && bd == null) return a.name.compareTo(b.name);
          if (ad == null) return 1;
          if (bd == null) return -1;
          return bd.compareTo(ad);
        });
      return [...recents.take(6).map(_ServerEntry.new), ...commands];
    }
    bool matches(String haystack) => haystack.toLowerCase().contains(query);
    final serverMatches = servers.where(
      (s) =>
          matches(s.name) ||
          matches(s.hostname) ||
          s.tags.any((t) => matches(t.name)),
    );
    final commandMatches = commands.where((c) => matches(c.label));
    return [...serverMatches.map(_ServerEntry.new), ...commandMatches];
  }

  void _activate(_PaletteEntry entry) {
    final navigator = Navigator.of(context);
    switch (entry) {
      case _ServerEntry(:final server):
        ref.read(sessionManagerProvider.notifier).openSession(server.id);
        _goBranch(ref, AppConstants.terminalBranchIndex);
        navigator.pop();
      case _CommandEntry(:final run):
        navigator.pop();
        run(context, ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final servers = ref.watch(serverListProvider).value ?? const [];
    final entries = _filtered(servers);
    final selected = entries.isEmpty
        ? 0
        : _selected.clamp(0, entries.length - 1);

    void move(int delta) {
      if (entries.isEmpty) return;
      setState(() => _selected = (selected + delta) % entries.length);
    }

    return Align(
      alignment: const Alignment(0, -0.4),
      child: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outlineVariant),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 40,
                  offset: Offset(0, 16),
                ),
              ],
            ),
            child: Focus(
              autofocus: true,
              onKeyEvent: (node, event) {
                if (event is! KeyDownEvent) return KeyEventResult.ignored;
                switch (event.logicalKey) {
                  case LogicalKeyboardKey.arrowDown:
                    move(1);
                    return KeyEventResult.handled;
                  case LogicalKeyboardKey.arrowUp:
                    move(-1);
                    return KeyEventResult.handled;
                  case LogicalKeyboardKey.enter:
                  case LogicalKeyboardKey.numpadEnter:
                    if (entries.isNotEmpty) _activate(entries[selected]);
                    return KeyEventResult.handled;
                  case LogicalKeyboardKey.escape:
                    Navigator.of(context).pop();
                    return KeyEventResult.handled;
                  default:
                    return KeyEventResult.ignored;
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: true,
                      style: const TextStyle(
                        fontFamily: AppConstants.monospaceFontFamily,
                        fontSize: 15,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            'Quick connect — type a host, tag, or command…',
                        prefixIcon: Icon(Icons.search, size: 20),
                      ),
                      onChanged: (_) => setState(() => _selected = 0),
                      onSubmitted: (_) {
                        if (entries.isNotEmpty) _activate(entries[selected]);
                      },
                    ),
                  ),
                  Divider(height: 1, color: theme.colorScheme.outlineVariant),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 360),
                    child: entries.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'No matches',
                              style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            itemCount: entries.length,
                            itemBuilder: (context, index) {
                              final entry = entries[index];
                              final isSelected = index == selected;
                              return _PaletteRow(
                                entry: entry,
                                isSelected: isSelected,
                                onTap: () => _activate(entry),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PaletteRow extends ConsumerWidget {
  final _PaletteEntry entry;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaletteRow({
    required this.entry,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final (icon, title, subtitle, hint) = switch (entry) {
      _ServerEntry(:final server) => (
        Icons.dns_outlined,
        server.name,
        '${server.username}@${server.hostname}:${server.port}',
        '↵ connect',
      ),
      _CommandEntry(:final icon, :final label, :final hint) => (
        icon,
        label,
        null,
        hint,
      ),
    };

    return Material(
      color: isSelected
          ? theme.colorScheme.primary.withAlpha(31)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          child: Row(
            children: [
              Icon(
                icon,
                size: 17,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: AppConstants.monospaceFontFamily,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: AppConstants.monospaceFontFamily,
                          fontSize: 11,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (hint.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    hint,
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              if (entry case _ServerEntry(:final server)) ...[
                const SizedBox(width: 2),
                _ServerRowActions(server: server),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Server management (details / edit / duplicate / delete) — connecting is
/// the row's primary action (click or Enter), management is everything the
/// Fleet grid used to offer via its own per-card menu. Without this, the
/// palette can add hosts but never edit, retag, or remove one again.
class _ServerRowActions extends ConsumerWidget {
  final ServerEntity server;
  const _ServerRowActions({required this.server});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<String>(
      tooltip: l10n.navMore,
      icon: Icon(
        Icons.more_vert,
        size: 16,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      onSelected: (action) async {
        switch (action) {
          case 'detail':
            Navigator.of(context).pop();
            context.push('/server/${server.id}');
          case 'edit':
            Navigator.of(context).pop();
            context.push('/server/${server.id}/edit');
          case 'duplicate':
            Navigator.of(context).pop();
            await ref
                .read(serverListProvider.notifier)
                .duplicateServer(server.id, copySuffix: l10n.serverCopySuffix);
          case 'delete':
            final confirmed = await ConfirmDialog.show(
              context,
              title: l10n.serverDeleteTitle,
              message: l10n.serverDeleteMessage(server.name),
            );
            if (confirmed == true) {
              await ref
                  .read(serverListProvider.notifier)
                  .deleteServer(server.id);
              if (context.mounted) Navigator.of(context).pop();
            }
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'detail',
          child: ListTile(
            leading: const Icon(Icons.info_outlined),
            title: Text(l10n.serverDetails),
          ),
        ),
        PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: const Icon(Icons.edit),
            title: Text(l10n.edit),
          ),
        ),
        PopupMenuItem(
          value: 'duplicate',
          child: ListTile(
            leading: const Icon(Icons.copy),
            title: Text(l10n.serverDuplicate),
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: const Icon(Icons.delete),
            title: Text(l10n.delete),
          ),
        ),
      ],
    );
  }
}
