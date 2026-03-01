import 'package:flutter/material.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xterm/xterm.dart';

import 'package:shellvault/core/routing/shell_navigation_provider.dart';
import 'package:shellvault/core/widgets/shell_aware_app_bar.dart';
import 'package:shellvault/features/connection/presentation/widgets/empty_state.dart';
import 'package:shellvault/features/terminal/domain/entities/terminal_theme_data.dart';
import 'package:shellvault/features/terminal/presentation/providers/terminal_providers.dart';
import 'package:shellvault/features/terminal/presentation/widgets/connection_overlay.dart';
import 'package:shellvault/features/terminal/presentation/widgets/session_tab_bar.dart';
import 'package:shellvault/features/terminal/presentation/widgets/snippet_quick_panel.dart';
import 'package:shellvault/features/terminal/presentation/widgets/ssh_keyboard_toolbar.dart';
import 'package:shellvault/features/terminal/presentation/widgets/virtual_keyboard.dart';

/// Terminal branch screen — shown as a shell branch (index 6).
///
/// Displays all active SSH sessions from [sessionManagerProvider].
/// If no sessions exist, shows an empty state prompting the user
/// to navigate to Hosts.
class TerminalBranchScreen extends ConsumerStatefulWidget {
  const TerminalBranchScreen({super.key});

  @override
  ConsumerState<TerminalBranchScreen> createState() =>
      _TerminalBranchScreenState();
}

class _TerminalBranchScreenState extends ConsumerState<TerminalBranchScreen> {
  VirtualKeyboard? _virtualKeyboard;

  @override
  void dispose() {
    _virtualKeyboard?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(sessionManagerProvider);
    final activeSession = ref.watch(activeSessionProvider);
    final themeKeyAsync = ref.watch(terminalThemeKeyProvider);
    final fontSizeAsync = ref.watch(terminalFontSizeProvider);

    final terminalTheme = themeKeyAsync.when(
      data: (key) => TerminalThemePresets.getTheme(key),
      loading: () =>
          TerminalThemePresets.getTheme(TerminalThemeKey.defaultDark),
      error: (_, _) =>
          TerminalThemePresets.getTheme(TerminalThemeKey.defaultDark),
    );

    final fontSize = fontSizeAsync.when(
      data: (size) => size,
      loading: () => 14.0,
      error: (_, _) => 14.0,
    );

    // Update virtual keyboard when active session changes
    if (activeSession != null) {
      if (_virtualKeyboard?.terminal != activeSession.terminal) {
        _virtualKeyboard?.dispose();
        _virtualKeyboard = VirtualKeyboard(activeSession.terminal);
      }
    }

    final l10n = AppLocalizations.of(context)!;

    // Empty state — no sessions
    if (sessions.isEmpty) {
      return Scaffold(
        appBar: buildShellAppBar(context, title: l10n.terminalTitle),
        body: EmptyState(
          icon: Icons.terminal,
          title: l10n.terminalEmpty,
          subtitle: l10n.terminalEmptySubtitle,
          action: FilledButton.icon(
            onPressed: () {
              ref.read(shellNavigationProvider)?.goBranch(0);
            },
            icon: const Icon(Icons.dns),
            label: Text(l10n.terminalGoToHosts),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: terminalTheme.background,
      appBar: buildShellAppBar(
        context,
        title: l10n.terminalTitle,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'close_all') {
                ref.read(sessionManagerProvider.notifier).closeAllSessions();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'close_all',
                child: Text(l10n.terminalCloseAll),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Tab bar (always visible when sessions exist)
            const SessionTabBar(),

            // Terminal + overlay
            Expanded(
              child: activeSession == null
                  ? const Center(child: CircularProgressIndicator())
                  : Stack(
                      children: [
                        TerminalView(
                          activeSession.terminal,
                          theme: terminalTheme,
                          textStyle: TerminalStyle(
                            fontSize: fontSize,
                          ),
                          autofocus: true,
                          keyboardAppearance: Brightness.dark,
                          deleteDetection: true,
                        ),
                        ConnectionOverlay(
                          status: activeSession.status,
                          serverName: activeSession.title,
                          errorMessage: activeSession.errorMessage,
                          onRetry: () {
                            ref
                                .read(sessionManagerProvider.notifier)
                                .reconnectSession(activeSession.id);
                          },
                          onClose: () {
                            ref
                                .read(sessionManagerProvider.notifier)
                                .closeSession(activeSession.id);
                          },
                        ),
                      ],
                    ),
            ),

            // Mobile keyboard toolbar
            if (SshKeyboardToolbar.shouldShow && _virtualKeyboard != null)
              SshKeyboardToolbar(
                virtualKeyboard: _virtualKeyboard!,
                onSnippetTap: _insertSnippet,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _insertSnippet() async {
    final result = await SnippetQuickPanel.show(context);
    if (result != null) {
      final session = ref.read(activeSessionProvider);
      session?.terminal.textInput(result);
    }
  }
}
