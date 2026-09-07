import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/routing/shell_navigation_provider.dart';
import 'package:sshvault/features/connection/presentation/widgets/command_palette.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

/// Global desktop keyboard shortcuts (Ctrl/Cmd+K, +T, +W, +,, font size,
/// terminal-tab switching).
///
/// Wrapped around the *whole* app in `app.dart`'s `MaterialApp.router`
/// builder — not around [AppShell] itself. [AppShell] only covers the
/// `StatefulShellRoute`'s branch content; routes like `/settings`,
/// `/server/:id/edit` and every snippet/key screen are pushed on the root
/// navigator *outside* that subtree (see `app_router.dart`). A
/// `CallbackShortcuts` scoped to [AppShell] stops seeing key events the
/// moment one of those routes is on screen — which is exactly why Ctrl+K
/// went dead while on Settings. Reading the current branch shell via
/// [shellNavigationProvider] (already the pattern the command palette
/// itself uses) instead of a constructor-injected `navigationShell` is
/// what makes hoisting this above the router config possible.
class DesktopShortcuts extends ConsumerStatefulWidget {
  final Widget child;

  const DesktopShortcuts({super.key, required this.child});

  static bool get isDesktop =>
      Platform.isLinux || Platform.isMacOS || Platform.isWindows;

  @override
  ConsumerState<DesktopShortcuts> createState() => _DesktopShortcutsState();
}

class _DesktopShortcutsState extends ConsumerState<DesktopShortcuts> {
  static const _menuChannel = MethodChannel('de.kiefer_networks.sshvault/menu');

  /// Use Meta on macOS, Control everywhere else.
  static final bool _useMeta = Platform.isMacOS;

  @override
  void initState() {
    super.initState();
    _menuChannel.setMethodCallHandler(_handleMenuCall);
  }

  @override
  void dispose() {
    _menuChannel.setMethodCallHandler(null);
    super.dispose();
  }

  Future<void> _handleMenuCall(MethodCall call) async {
    if (call.method == 'openSettings' && mounted) {
      GoRouter.of(context).push('/settings');
    }
  }

  SingleActivator _shortcut(LogicalKeyboardKey key, {bool shift = false}) {
    return SingleActivator(
      key,
      meta: _useMeta,
      control: !_useMeta,
      shift: shift,
    );
  }

  void _goBranch(int index, {bool initialLocation = false}) {
    ref
        .read(shellNavigationProvider)
        ?.goBranch(index, initialLocation: initialLocation);
  }

  @override
  Widget build(BuildContext context) {
    if (!DesktopShortcuts.isDesktop) return widget.child;

    return CallbackShortcuts(
      bindings: {
        // Cmd/Ctrl+, → open Settings
        _shortcut(LogicalKeyboardKey.comma): () {
          GoRouter.of(context).push('/settings');
        },

        // Ctrl/Cmd+K → open the command palette from anywhere in the app
        _shortcut(LogicalKeyboardKey.keyK): () {
          showCommandPalette(context);
        },

        // Ctrl/Cmd+T → navigate to Hosts (to start new connection)
        _shortcut(LogicalKeyboardKey.keyT): () {
          _goBranch(0, initialLocation: true);
        },

        // Ctrl/Cmd+W → close active terminal tab
        _shortcut(LogicalKeyboardKey.keyW): () {
          final sessions = ref.read(sessionManagerProvider);
          if (sessions.isEmpty) return;
          final active = ref.read(activeSessionProvider);
          if (active != null) {
            ref.read(sessionManagerProvider.notifier).closeSession(active.id);
          }
        },

        // Ctrl/Cmd+Plus → increase font size
        _shortcut(LogicalKeyboardKey.equal): () {
          ref.read(terminalFontSizeProvider.notifier).increase();
        },

        // Ctrl/Cmd+Minus → decrease font size
        _shortcut(LogicalKeyboardKey.minus): () {
          ref.read(terminalFontSizeProvider.notifier).decrease();
        },

        // Ctrl/Cmd+1-9 → switch terminal tab
        for (var i = 0; i < 9; i++)
          _shortcut(LogicalKeyboardKey(0x31 + i)): () {
            final sessions = ref.read(sessionManagerProvider);
            if (i < sessions.length) {
              ref.read(activeSessionIndexProvider.notifier).state = i;
              _goBranch(AppConstants.terminalBranchIndex);
            }
          },
      },
      child: Focus(autofocus: true, child: widget.child),
    );
  }
}
