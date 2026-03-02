import 'package:flutter/material.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/features/connection/presentation/widgets/confirm_dialog.dart';
import 'package:shellvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:shellvault/features/terminal/presentation/providers/terminal_providers.dart';

class SessionTabBar extends ConsumerWidget {
  const SessionTabBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(sessionManagerProvider);
    final activeIndex = ref.watch(activeSessionIndexProvider);
    final theme = Theme.of(context);

    if (sessions.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withAlpha(AppConstants.alpha204),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withAlpha(AppConstants.alpha51),
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          final isActive = index == activeIndex;

          return GestureDetector(
            onTap: () {
              ref.read(activeSessionIndexProvider.notifier).state = index;
            },
            child: Container(
              constraints: const BoxConstraints(maxWidth: 180),
              margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: isActive
                    ? theme.colorScheme.primaryContainer.withAlpha(
                        AppConstants.alpha153,
                      )
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StatusDot(status: session.status),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      session.title,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isActive
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurface.withAlpha(
                                AppConstants.alpha179,
                              ),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  _CloseButton(
                    session: session,
                    onClose: () {
                      ref
                          .read(sessionManagerProvider.notifier)
                          .closeSession(session.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final SshConnectionStatus status;

  const _StatusDot({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      SshConnectionStatus.connected => Colors.green,
      SshConnectionStatus.connecting ||
      SshConnectionStatus.authenticating => Colors.amber,
      SshConnectionStatus.error ||
      SshConnectionStatus.disconnected => Colors.red,
    };

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _CloseButton extends StatelessWidget {
  final SshSessionEntity session;
  final VoidCallback onClose;

  const _CloseButton({required this.session, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () async {
        if (session.status == SshConnectionStatus.connected) {
          final l10n = AppLocalizations.of(context)!;
          final confirmed = await ConfirmDialog.show(
            context,
            title: l10n.terminalCloseTitle,
            message: l10n.terminalCloseMessage(session.title),
            confirmLabel: l10n.close,
          );
          if (confirmed == true) onClose();
        } else {
          onClose();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Icon(
          Icons.close,
          size: 14,
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withAlpha(AppConstants.alpha128),
        ),
      ),
    );
  }
}
