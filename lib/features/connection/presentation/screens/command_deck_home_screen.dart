import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/routing/shell_navigation_provider.dart';
import 'package:sshvault/features/connection/presentation/widgets/command_palette.dart';
import 'package:sshvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

/// Desktop-only Command Deck home for the Hosts branch (>= 600 dp — see
/// [AppShell]'s `_DesktopScaffold`). There is no host list, search bar, or
/// tab strip here by design: the whole surface is the command palette's
/// canvas, opened with Ctrl+K from anywhere in the desktop shell. This
/// screen is only what's visible before you press it.
class CommandDeckHomeScreen extends ConsumerWidget {
  const CommandDeckHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final sessions = ref.watch(sessionManagerProvider);

    return ColoredBox(
      color: theme.colorScheme.surface,
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.terminal,
                  size: 52,
                  color: theme.colorScheme.primary.withAlpha(140),
                ),
                const SizedBox(height: 20),
                Text(
                  'SSHVault',
                  style: TextStyle(
                    fontFamily: AppConstants.monospaceFontFamily,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 24),
                _QuickConnectHint(onTap: () => showCommandPalette(context)),
              ],
            ),
          ),
          if (sessions.isNotEmpty)
            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: _ActiveSessionsStrip(sessions: sessions),
            ),
        ],
      ),
    );
  }
}

class _QuickConnectHint extends StatelessWidget {
  final VoidCallback onTap;
  const _QuickConnectHint({required this.onTap});

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
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Press',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(width: 8),
              _KeyCap(Platform.isMacOS ? '⌘' : 'Ctrl'),
              const SizedBox(width: 4),
              Text(
                '+',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(width: 4),
              const _KeyCap('K'),
              const SizedBox(width: 8),
              Text(
                'to connect',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
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

class _ActiveSessionsStrip extends ConsumerWidget {
  final List<SshSessionEntity> sessions;
  const _ActiveSessionsStrip({required this.sessions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${sessions.length} session${sessions.length == 1 ? '' : 's'} active · '
              '${sessions.map((s) => s.title).join(', ')}',
              style: TextStyle(
                fontFamily: AppConstants.monospaceFontFamily,
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(activeSessionIndexProvider.notifier).state = 0;
              ref
                  .read(shellNavigationProvider)
                  ?.goBranch(AppConstants.terminalBranchIndex);
            },
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }
}
