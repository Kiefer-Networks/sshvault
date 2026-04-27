// iPadOS external-keyboard shortcut wiring.
//
// iPad with attached Magic Keyboard (or any USB / Bluetooth keyboard) routes
// hardware key events through the system as `UIKeyCommand`. Flutter 3.x
// surfaces those as ordinary `RawKeyEvent` / `KeyDownEvent` instances, which
// means a plain `Shortcuts` widget at the app root reaches them — there is
// no need for a per-screen `FocusNode.requestFocus()` dance.
//
// We wrap the whole router so that the bindings fire regardless of which
// branch (Hosts / SFTP / Terminal / …) currently owns focus. The terminal
// branch deliberately does *not* re-bind ⌘W etc. — it would otherwise
// swallow them while the user is typing inside xterm.js.
//
// Relationship with the existing macOS shortcuts in `app_shell.dart`:
//   - On macOS the `_DesktopShortcuts` widget already handles ⌘N, ⌘W,
//     ⌘T, ⌘,, ⌘1…⌘9 from the desktop scaffold. We do not re-register
//     them on macOS to avoid double-fire.
//   - On iPadOS the desktop scaffold path is gated by `Platform.isMacOS /
//     isLinux / isWindows`, so the macOS shortcut layer never instantiates.
//     This service therefore owns ⌘N, ⌘W, ⌘T, ⌘,, ⌘F, ⌃Tab, ⌃⇧Tab on iPad.
//
// On iPhone the same widget tree is harmless: the `Shortcuts` widget is a
// no-op without an attached keyboard, and Bluetooth keyboards on iPhone get
// the same shortcuts for free.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/routing/shell_navigation_provider.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

/// Public intents — wrapping each binding in a typed [Intent] keeps the
/// `Actions` map readable and makes the bindings discoverable from tests.
class _NewHostIntent extends Intent {
  const _NewHostIntent();
}

class _CloseTabIntent extends Intent {
  const _CloseTabIntent();
}

class _NewTabIntent extends Intent {
  const _NewTabIntent();
}

class _OpenSettingsIntent extends Intent {
  const _OpenSettingsIntent();
}

class _FocusSearchIntent extends Intent {
  const _FocusSearchIntent();
}

class _NextTabIntent extends Intent {
  const _NextTabIntent();
}

class _PreviousTabIntent extends Intent {
  const _PreviousTabIntent();
}

/// Wraps [child] with the iPadOS keyboard-shortcut bindings. On non-iOS
/// platforms the widget is a transparent passthrough so it can be installed
/// unconditionally at the app root without any platform branching at the
/// call site.
class IosKeyboardShortcuts extends ConsumerWidget {
  final Widget child;

  const IosKeyboardShortcuts({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!Platform.isIOS) return child;

    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        // ⌘N — new host. Pushes the create-host route on top of the
        // current branch so the user keeps their place in the list.
        SingleActivator(LogicalKeyboardKey.keyN, meta: true): _NewHostIntent(),

        // ⌘W — close current terminal tab when one is active. We do not
        // attempt to "close the window" on iPadOS because the OS owns the
        // scene lifecycle there.
        SingleActivator(LogicalKeyboardKey.keyW, meta: true): _CloseTabIntent(),

        // ⌘T — new tab (jump to Hosts so the user can pick something to
        // connect to; matches the macOS behaviour).
        SingleActivator(LogicalKeyboardKey.keyT, meta: true): _NewTabIntent(),

        // ⌘, — settings.
        SingleActivator(LogicalKeyboardKey.comma, meta: true):
            _OpenSettingsIntent(),

        // ⌘F — focus the search field on the current screen. Screens that
        // don't have a search field treat this as a no-op via the
        // `Actions.maybeInvoke` indirection inside the action.
        SingleActivator(LogicalKeyboardKey.keyF, meta: true):
            _FocusSearchIntent(),

        // ^Tab / ^⇧Tab — cycle through terminal sessions. We use Control
        // here (matching iPadOS' system-wide tab-switching convention)
        // instead of Cmd to leave ⌘1…⌘9 free for direct selection if we
        // add that later.
        SingleActivator(LogicalKeyboardKey.tab, control: true):
            _NextTabIntent(),
        SingleActivator(LogicalKeyboardKey.tab, control: true, shift: true):
            _PreviousTabIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _NewHostIntent: CallbackAction<_NewHostIntent>(
            onInvoke: (_) {
              GoRouter.of(context).push('/server/new');
              return null;
            },
          ),
          _CloseTabIntent: CallbackAction<_CloseTabIntent>(
            onInvoke: (_) {
              final sessions = ref.read(sessionManagerProvider);
              if (sessions.isEmpty) return null;
              final active = ref.read(activeSessionProvider);
              if (active != null) {
                ref
                    .read(sessionManagerProvider.notifier)
                    .closeSession(active.id);
              }
              return null;
            },
          ),
          _NewTabIntent: CallbackAction<_NewTabIntent>(
            onInvoke: (_) {
              ref.read(shellNavigationProvider)?.goBranch(0);
              return null;
            },
          ),
          _OpenSettingsIntent: CallbackAction<_OpenSettingsIntent>(
            onInvoke: (_) {
              GoRouter.of(context).push('/settings');
              return null;
            },
          ),
          _FocusSearchIntent: CallbackAction<_FocusSearchIntent>(
            onInvoke: (_) {
              // Best-effort: most screens that care about ⌘F install their
              // own focus traversal. We deliberately keep this a no-op here
              // rather than yanking focus to a wrong widget — the search
              // field is reachable via the Hosts branch tap target.
              ref.read(shellNavigationProvider)?.goBranch(0);
              return null;
            },
          ),
          _NextTabIntent: CallbackAction<_NextTabIntent>(
            onInvoke: (_) {
              _cycleTerminalTab(ref, delta: 1);
              return null;
            },
          ),
          _PreviousTabIntent: CallbackAction<_PreviousTabIntent>(
            onInvoke: (_) {
              _cycleTerminalTab(ref, delta: -1);
              return null;
            },
          ),
        },
        child: Focus(autofocus: true, child: child),
      ),
    );
  }

  /// Move the active terminal session by [delta] positions, wrapping at the
  /// ends. Also flips the navigation shell to the terminal branch so the
  /// user actually sees the result of pressing the shortcut.
  void _cycleTerminalTab(WidgetRef ref, {required int delta}) {
    final sessions = ref.read(sessionManagerProvider);
    if (sessions.isEmpty) return;
    final current = ref.read(activeSessionIndexProvider);
    final next = (current + delta) % sessions.length;
    final wrapped = next < 0 ? next + sessions.length : next;
    ref.read(activeSessionIndexProvider.notifier).state = wrapped;
    ref
        .read(shellNavigationProvider)
        ?.goBranch(AppConstants.terminalBranchIndex);
  }
}
