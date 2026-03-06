import 'package:flutter/material.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xterm/xterm.dart';

import 'package:sshvault/core/routing/shell_navigation_provider.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/widgets/shell_aware_app_bar.dart';
import 'package:sshvault/features/connection/presentation/widgets/empty_state.dart';
import 'package:sshvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:sshvault/features/terminal/presentation/models/terminal_theme_data.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';
import 'package:sshvault/features/terminal/presentation/widgets/connection_overlay.dart';
import 'package:sshvault/features/terminal/presentation/widgets/session_tab_bar.dart';
import 'package:sshvault/features/terminal/presentation/widgets/snippet_quick_panel.dart';
import 'package:sshvault/features/terminal/presentation/widgets/ssh_keyboard_toolbar.dart';
import 'package:sshvault/features/terminal/presentation/widgets/virtual_keyboard.dart';

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
    final splitMode = ref.watch(splitModeProvider);
    final secondarySession = ref.watch(secondarySessionProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    // Auto-reset split when less than 2 sessions
    if (sessions.length < 2 && splitMode != SplitMode.none) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(splitModeProvider.notifier).state = SplitMode.none;
        ref.read(secondarySessionIndexProvider.notifier).state = null;
      });
    }

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
      return AdaptiveScaffold.withAppBar(
        appBar: buildShellAppBar(context, title: l10n.terminalTitle),
        body: EmptyState(
          icon: Icons.terminal,
          title: l10n.terminalEmpty,
          subtitle: l10n.terminalEmptySubtitle,
          action: AdaptiveButton.filledIcon(
            onPressed: () {
              ref.read(shellNavigationProvider)?.goBranch(0);
            },
            icon: const Icon(Icons.dns),
            label: Text(l10n.terminalGoToHosts),
          ),
        ),
      );
    }

    return AdaptiveScaffold.withAppBar(
      backgroundColor: terminalTheme.background,
      appBar: buildShellAppBar(
        context,
        title: l10n.terminalTitle,
        actions: [
          if (sessions.length >= 2 && screenWidth >= 600)
            IconButton(
              icon: Icon(
                splitMode == SplitMode.none
                    ? Icons.vertical_split
                    : Icons.close_fullscreen,
              ),
              tooltip: splitMode == SplitMode.none
                  ? l10n.terminalSplit
                  : l10n.terminalUnsplit,
              onPressed: () => _toggleSplit(sessions),
            ),
          if (activeSession != null)
            IconButton(
              icon: const Icon(Icons.content_paste),
              tooltip: l10n.snippetQuickPanelInsertTooltip,
              onPressed: _insertSnippet,
            ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showAdaptiveActionSheet(
                context,
                actions: [
                  AdaptiveAction(
                    label: l10n.terminalCloseAll,
                    icon: Icons.close,
                    isDestructive: true,
                    onPressed: () {
                      ref
                          .read(sessionManagerProvider.notifier)
                          .closeAllSessions();
                    },
                  ),
                ],
                cancelLabel: l10n.cancel,
              );
            },
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

            // Terminal + overlay (with optional split)
            Expanded(
              child: activeSession == null
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : splitMode == SplitMode.horizontal &&
                        secondarySession != null
                  ? Row(
                      children: [
                        Expanded(
                          child: _TerminalPane(
                            session: activeSession,
                            theme: terminalTheme,
                            fontSize: fontSize,
                            autofocus: true,
                            onRetry: () => ref
                                .read(sessionManagerProvider.notifier)
                                .reconnectSession(activeSession.id),
                            onClose: () => ref
                                .read(sessionManagerProvider.notifier)
                                .closeSession(activeSession.id),
                          ),
                        ),
                        const VerticalDivider(width: 2),
                        Expanded(
                          child: _TerminalPane(
                            session: secondarySession,
                            theme: terminalTheme,
                            fontSize: fontSize,
                            autofocus: false,
                            onRetry: () => ref
                                .read(sessionManagerProvider.notifier)
                                .reconnectSession(secondarySession.id),
                            onClose: () => ref
                                .read(sessionManagerProvider.notifier)
                                .closeSession(secondarySession.id),
                          ),
                        ),
                      ],
                    )
                  : _TerminalPane(
                      session: activeSession,
                      theme: terminalTheme,
                      fontSize: fontSize,
                      autofocus: true,
                      onRetry: () => ref
                          .read(sessionManagerProvider.notifier)
                          .reconnectSession(activeSession.id),
                      onClose: () => ref
                          .read(sessionManagerProvider.notifier)
                          .closeSession(activeSession.id),
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

  void _toggleSplit(List<SshSessionEntity> sessions) {
    final current = ref.read(splitModeProvider);
    if (current == SplitMode.none) {
      // Find first session that isn't the active one
      final activeIndex = ref.read(activeSessionIndexProvider);
      int? secondaryIndex;
      for (var i = 0; i < sessions.length; i++) {
        if (i != activeIndex) {
          secondaryIndex = i;
          break;
        }
      }
      if (secondaryIndex != null) {
        ref.read(secondarySessionIndexProvider.notifier).state = secondaryIndex;
        ref.read(splitModeProvider.notifier).state = SplitMode.horizontal;
      }
    } else {
      ref.read(splitModeProvider.notifier).state = SplitMode.none;
      ref.read(secondarySessionIndexProvider.notifier).state = null;
    }
  }

  Future<void> _insertSnippet() async {
    final result = await SnippetQuickPanel.show(context);
    if (result != null) {
      final session = ref.read(activeSessionProvider);
      session?.terminal.textInput(result);
    }
  }
}

class _TerminalPane extends StatelessWidget {
  final SshSessionEntity session;
  final TerminalTheme theme;
  final double fontSize;
  final bool autofocus;
  final VoidCallback onRetry;
  final VoidCallback onClose;

  const _TerminalPane({
    required this.session,
    required this.theme,
    required this.fontSize,
    required this.autofocus,
    required this.onRetry,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TerminalView(
          session.terminal,
          theme: theme,
          textStyle: TerminalStyle(fontSize: fontSize),
          autofocus: autofocus,
          keyboardAppearance: Brightness.dark,
          deleteDetection: true,
        ),
        ConnectionOverlay(
          status: session.status,
          serverName: session.title,
          errorMessage: session.errorMessage,
          onRetry: onRetry,
          onClose: onClose,
        ),
      ],
    );
  }
}
