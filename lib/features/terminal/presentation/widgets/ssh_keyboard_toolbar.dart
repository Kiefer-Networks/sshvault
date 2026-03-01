import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart';

import 'package:shellvault/features/terminal/presentation/widgets/virtual_keyboard.dart';

class SshKeyboardToolbar extends StatelessWidget {
  final VirtualKeyboard virtualKeyboard;
  final VoidCallback? onSnippetTap;

  const SshKeyboardToolbar({
    super.key,
    required this.virtualKeyboard,
    this.onSnippetTap,
  });

  static bool get shouldShow {
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: virtualKeyboard,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outline.withAlpha(51),
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Row 1: Special keys
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    children: [
                      _KeyButton(
                        label: 'Esc',
                        onTap: () =>
                            virtualKeyboard.sendKey(TerminalKey.escape),
                      ),
                      _KeyButton(
                        label: 'Tab',
                        onTap: () => virtualKeyboard.sendKey(TerminalKey.tab),
                      ),
                      _KeyButton(
                        label: 'Home',
                        onTap: () => virtualKeyboard.sendKey(TerminalKey.home),
                      ),
                      _KeyButton(
                        label: 'End',
                        onTap: () => virtualKeyboard.sendKey(TerminalKey.end),
                      ),
                      _KeyButton(
                        label: 'PgUp',
                        onTap: () =>
                            virtualKeyboard.sendKey(TerminalKey.pageUp),
                      ),
                      _KeyButton(
                        label: 'PgDn',
                        onTap: () =>
                            virtualKeyboard.sendKey(TerminalKey.pageDown),
                      ),
                      const SizedBox(width: 8),
                      _KeyButton(
                        icon: Icons.arrow_back,
                        onTap: () =>
                            virtualKeyboard.sendKey(TerminalKey.arrowLeft),
                      ),
                      _KeyButton(
                        icon: Icons.arrow_upward,
                        onTap: () =>
                            virtualKeyboard.sendKey(TerminalKey.arrowUp),
                      ),
                      _KeyButton(
                        icon: Icons.arrow_downward,
                        onTap: () =>
                            virtualKeyboard.sendKey(TerminalKey.arrowDown),
                      ),
                      _KeyButton(
                        icon: Icons.arrow_forward,
                        onTap: () =>
                            virtualKeyboard.sendKey(TerminalKey.arrowRight),
                      ),
                      const SizedBox(width: 8),
                      for (int i = 1; i <= 12; i++)
                        _KeyButton(
                          label: 'F$i',
                          onTap: () => virtualKeyboard.sendKey(
                            TerminalKey.values.firstWhere(
                              (k) => k.name == 'f$i',
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Row 2: Modifier toggles + snippet
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      const SizedBox(width: 4),
                      _ModifierButton(
                        label: 'Ctrl',
                        isActive: virtualKeyboard.ctrl,
                        onTap: virtualKeyboard.toggleCtrl,
                      ),
                      _ModifierButton(
                        label: 'Alt',
                        isActive: virtualKeyboard.alt,
                        onTap: virtualKeyboard.toggleAlt,
                      ),
                      _ModifierButton(
                        label: 'Shift',
                        isActive: virtualKeyboard.shift,
                        onTap: virtualKeyboard.toggleShift,
                      ),
                      const Spacer(),
                      if (onSnippetTap != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: IconButton(
                            icon: const Icon(Icons.content_paste, size: 20),
                            tooltip: 'Insert Snippet',
                            onPressed: onSnippetTap,
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
                              foregroundColor:
                                  theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _KeyButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onTap;

  const _KeyButton({this.label, this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: Material(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minWidth: 36),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            child: icon != null
                ? Icon(icon, size: 16, color: theme.colorScheme.onSurface)
                : Text(
                    label!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _ModifierButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ModifierButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: Material(
        color: isActive
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minWidth: 48),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            child: Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontFamily: 'monospace',
                color: isActive
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
