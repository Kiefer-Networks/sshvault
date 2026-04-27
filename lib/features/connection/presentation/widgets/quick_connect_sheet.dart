// Quick connect overlay surfaced by the Super+Shift+S global shortcut.
//
// A modal bottom sheet anchored to the root navigator, with a search field
// pre-focused and a list of matching hosts. Selecting an entry opens an SSH
// session via [sessionManagerProvider.openSession] and dismisses the sheet.
// The sheet is intentionally lightweight (no folder/tag filtering) — it's a
// "I know which host I want, let me type a few letters" affordance, not a
// replacement for the main host browser.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

class QuickConnectSheet extends ConsumerStatefulWidget {
  const QuickConnectSheet({super.key});

  /// Convenience launcher. Uses the root navigator so the sheet sits on top
  /// of any screen the user happens to be on (settings, terminal, etc).
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const QuickConnectSheet(),
    );
  }

  @override
  ConsumerState<QuickConnectSheet> createState() => _QuickConnectSheetState();
}

class _QuickConnectSheetState extends ConsumerState<QuickConnectSheet> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';

  @override
  void initState() {
    super.initState();
    // Autofocus so the user can start typing immediately after the hotkey.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Case-insensitive substring match across the user-visible fields. We do
  /// the filter on the client because the host list is bounded (typically
  /// dozens, not thousands) and a fuzzy/Trigram match would be overkill.
  List<ServerEntity> _filter(List<ServerEntity> servers) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return servers;
    return servers
        .where((s) {
          return s.name.toLowerCase().contains(q) ||
              s.hostname.toLowerCase().contains(q) ||
              s.username.toLowerCase().contains(q);
        })
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final asyncServers = ref.watch(serverListProvider);
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: media.size.height * 0.7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.bolt_outlined),
                  hintText: 'Quick connect — search hosts',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                ),
                onChanged: (v) => setState(() => _query = v),
                onSubmitted: (_) {
                  final servers = asyncServers.value ?? const <ServerEntity>[];
                  final filtered = _filter(servers);
                  if (filtered.isNotEmpty) _connect(filtered.first);
                },
              ),
            ),
            Flexible(
              child: asyncServers.when(
                data: (servers) {
                  final filtered = _filter(servers);
                  if (filtered.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          servers.isEmpty
                              ? 'No hosts saved yet'
                              : 'No hosts match "$_query"',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final s = filtered[i];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(s.color),
                          child: const Icon(Icons.dns, color: Colors.white),
                        ),
                        title: Text(s.name),
                        subtitle: Text('${s.username}@${s.hostname}:${s.port}'),
                        onTap: () => _connect(s),
                      );
                    },
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Failed to load hosts: $e'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _connect(ServerEntity server) {
    Navigator.of(context, rootNavigator: true).maybePop();
    // Defer slightly so the sheet's pop animation runs before the terminal
    // route transition starts — avoids a janky double-transition.
    Future.microtask(() {
      ref.read(sessionManagerProvider.notifier).openSession(server.id);
    });
  }
}
