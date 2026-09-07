import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/routing/app_router.dart';
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
/// navigator *outside* that subtree (see `app_router.dart`).
///
/// Registered via [HardwareKeyboard.addHandler] rather than a
/// `CallbackShortcuts`/`Focus(autofocus: true)` pair: the latter only
/// fires while a descendant of *this* widget holds primary focus, and a
/// modal route, a text field grabbing focus on open, or simply nothing
/// having claimed focus yet all break that silently. A hardware-level
/// handler runs for every key event regardless of what currently has
/// focus, which is what "the shortcut works everywhere" actually requires.
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
    if (DesktopShortcuts.isDesktop) {
      HardwareKeyboard.instance.addHandler(_handleKeyEvent);
    }
  }

  @override
  void dispose() {
    _menuChannel.setMethodCallHandler(null);
    if (DesktopShortcuts.isDesktop) {
      HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    }
    super.dispose();
  }

  Future<void> _handleMenuCall(MethodCall call) async {
    if (call.method == 'openSettings' && mounted) {
      final ctx = rootNavigatorKey.currentContext;
      if (ctx != null) GoRouter.of(ctx).push('/settings');
    }
  }

  bool get _modifierPressed {
    final pressed = HardwareKeyboard.instance.logicalKeysPressed;
    return _useMeta
        ? (pressed.contains(LogicalKeyboardKey.metaLeft) ||
              pressed.contains(LogicalKeyboardKey.metaRight))
        : (pressed.contains(LogicalKeyboardKey.controlLeft) ||
              pressed.contains(LogicalKeyboardKey.controlRight));
  }

  void _goBranch(int index, {bool initialLocation = false}) {
    ref
        .read(shellNavigationProvider)
        ?.goBranch(index, initialLocation: initialLocation);
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    if (!_modifierPressed) return false;

    final key = event.logicalKey;
    final ctx = rootNavigatorKey.currentContext;

    if (key == LogicalKeyboardKey.keyK) {
      if (ctx != null) showCommandPalette(ctx);
      return true;
    }

    if (key == LogicalKeyboardKey.comma) {
      if (ctx != null) GoRouter.of(ctx).push('/settings');
      return true;
    }

    if (key == LogicalKeyboardKey.keyT) {
      _goBranch(0, initialLocation: true);
      return true;
    }

    if (key == LogicalKeyboardKey.keyW) {
      final sessions = ref.read(sessionManagerProvider);
      if (sessions.isEmpty) return false;
      final active = ref.read(activeSessionProvider);
      if (active != null) {
        ref.read(sessionManagerProvider.notifier).closeSession(active.id);
      }
      return true;
    }

    if (key == LogicalKeyboardKey.equal) {
      ref.read(terminalFontSizeProvider.notifier).increase();
      return true;
    }

    if (key == LogicalKeyboardKey.minus) {
      ref.read(terminalFontSizeProvider.notifier).decrease();
      return true;
    }

    for (var i = 0; i < 9; i++) {
      if (key == LogicalKeyboardKey(0x31 + i)) {
        final sessions = ref.read(sessionManagerProvider);
        if (i < sessions.length) {
          ref.read(activeSessionIndexProvider.notifier).state = i;
          _goBranch(AppConstants.terminalBranchIndex);
        }
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
