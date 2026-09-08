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

/// Global desktop keyboard shortcuts: Ctrl/Cmd+K, +T, +W, +,, font size,
/// terminal-tab switching, a global Escape (close topmost dialog, else go
/// back one level), and bare vim-style navigation (j/k, gg/G, /).
///
/// Wrapped around the *whole* app in `app.dart`'s `MaterialApp.router`
/// builder — not around [AppShell] itself, so login/register/auth screens
/// (which sit fully outside the shell, on the root navigator) get the
/// modifier shortcuts and Escape too, not just the shell's own content.
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

  bool get _shiftPressed {
    final pressed = HardwareKeyboard.instance.logicalKeysPressed;
    return pressed.contains(LogicalKeyboardKey.shiftLeft) ||
        pressed.contains(LogicalKeyboardKey.shiftRight);
  }

  void _goBranch(int index, {bool initialLocation = false}) {
    ref
        .read(shellNavigationProvider)
        ?.goBranch(index, initialLocation: initialLocation);
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    if (_modifierPressed) return _handleModifierShortcut(event);

    // Escape always runs, even while a text field is focused — pressing
    // Escape never types a character, so there is no "typing into a field"
    // case to protect against here (unlike the vim keys below).
    if (event.logicalKey == LogicalKeyboardKey.escape) return _handleEscape();

    // Bare letter keys below are real characters — never fire them while
    // the user is actually typing into a field.
    if (_isTextInputFocused) return false;
    return _handleVimKey(event);
  }

  bool _handleModifierShortcut(KeyEvent event) {
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

  /// True while the currently focused widget is a text-editing field
  /// (`TextField`/`TextFormField`, which are built on `EditableText`) — the
  /// gate that keeps bare vim keys (j/k/g//) from hijacking normal typing.
  bool get _isTextInputFocused {
    final focusedContext = FocusManager.instance.primaryFocus?.context;
    if (focusedContext == null) return false;
    return focusedContext.findAncestorWidgetOfExactType<EditableText>() != null;
  }

  /// Closes the topmost dialog/route first; if nothing is poppable there,
  /// steps back one level in whichever navigator is actually current —
  /// matching the convergent pattern found across mRemoteNG, Linear,
  /// Superhuman and Raycast (close overlay, else go back one level).
  ///
  /// Resolving the navigator from whatever currently holds keyboard focus
  /// (rather than hardcoding "the root navigator") is what makes this
  /// correct regardless of how a dialog was actually shown: `showDialog`
  /// defaults to the root navigator, but the app's own
  /// `showAdaptiveConfirmDialog`/`showAdaptiveFormDialog` render as a
  /// `showModalBottomSheet` on Windows/Linux, which attaches to the
  /// nearest enclosing navigator of whatever context opened it instead —
  /// a focused button inside that sheet is a descendant of that same
  /// navigator, so `Navigator.maybeOf` from there still finds it. When
  /// nothing holds focus at all (e.g. the user only ever used the mouse),
  /// fall back to explicitly checking the shell navigator, then the root
  /// navigator — the only two navigators this app has.
  bool _handleEscape() {
    final focusedContext = FocusManager.instance.primaryFocus?.context;
    if (focusedContext != null) {
      final navigator = Navigator.maybeOf(focusedContext);
      if (navigator != null && navigator.canPop()) {
        // maybePop (not pop) so a route that guards itself with
        // PopScope(canPop: false) — e.g. SecurityWarningDialog — is
        // actually respected instead of force-closed. Every other dialog
        // in the app either has no such guard (this is then a normal
        // pop, unchanged) or already treats a bare/cancelled pop as its
        // own safe default (reject/cancel), same as clicking its own
        // Cancel button would.
        navigator.maybePop();
        return true;
      }
    }

    final shellState = shellNavigatorKey.currentState;
    if (shellState != null && shellState.canPop()) {
      shellState.maybePop();
      return true;
    }

    final rootState = rootNavigatorKey.currentState;
    if (rootState != null && rootState.canPop()) {
      rootState.maybePop();
      return true;
    }

    return false;
  }

  DateTime? _pendingLowerG;

  /// Bare vim-style navigation: j/k move focus to the next/previous
  /// focusable widget (mirroring what Tab/Shift+Tab already do), gg/G jump
  /// to the first/last focusable in the current scope, and / opens the
  /// command palette (the same "/" search convention as GitHub, Slack,
  /// Notion). Intentionally navigation-only — no destructive `dd`-style
  /// shortcut, since wiring per-row delete safely across half a dozen
  /// unrelated list screens is a separate, higher-risk piece of work.
  bool _handleVimKey(KeyEvent event) {
    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.keyJ) {
      FocusManager.instance.primaryFocus?.nextFocus();
      return true;
    }

    if (key == LogicalKeyboardKey.keyK) {
      FocusManager.instance.primaryFocus?.previousFocus();
      return true;
    }

    if (key == LogicalKeyboardKey.keyG) {
      if (_shiftPressed) {
        _pendingLowerG = null;
        _focusEdge(first: false);
        return true;
      }
      final now = DateTime.now();
      final pending = _pendingLowerG;
      if (pending != null && now.difference(pending) < _chordWindow) {
        _pendingLowerG = null;
        _focusEdge(first: true);
      } else {
        _pendingLowerG = now;
      }
      return true;
    }

    if (key == LogicalKeyboardKey.slash) {
      final ctx = rootNavigatorKey.currentContext;
      if (ctx != null) showCommandPalette(ctx);
      return true;
    }

    return false;
  }

  static const _chordWindow = Duration(milliseconds: 600);

  /// Walks focus to the start/end of the current traversal order using
  /// only the stable `FocusNode.nextFocus()`/`previousFocus()` API (rather
  /// than a `FocusTraversalPolicy`'s less certain "first/last" methods):
  /// repeatedly step until focus stops moving, capped so a runaway focus
  /// scope can never hang the key handler.
  void _focusEdge({required bool first}) {
    for (var i = 0; i < 200; i++) {
      final before = FocusManager.instance.primaryFocus;
      if (before == null) return;
      if (first) {
        before.previousFocus();
      } else {
        before.nextFocus();
      }
      if (identical(FocusManager.instance.primaryFocus, before)) return;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
