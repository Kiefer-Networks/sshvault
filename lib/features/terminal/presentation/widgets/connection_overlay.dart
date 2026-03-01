import 'package:flutter/material.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:shellvault/core/theme/glassmorphism.dart';
import 'package:shellvault/features/terminal/domain/entities/ssh_session_entity.dart';

class ConnectionOverlay extends StatelessWidget {
  final SshConnectionStatus status;
  final String? serverName;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final VoidCallback? onClose;

  const ConnectionOverlay({
    super.key,
    required this.status,
    this.serverName,
    this.errorMessage,
    this.onRetry,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      SshConnectionStatus.connecting ||
      SshConnectionStatus.authenticating =>
        _buildConnecting(context),
      SshConnectionStatus.error => _buildError(context),
      SshConnectionStatus.disconnected => _buildDisconnected(context),
      SshConnectionStatus.connected => const SizedBox.shrink(),
    };
  }

  Widget _buildConnecting(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Center(
      child: GlassmorphicContainer(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              status == SshConnectionStatus.authenticating
                  ? l10n.connectionAuthenticating
                  : l10n.connectionConnecting(serverName ?? 'server'),
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Center(
      child: GlassmorphicContainer(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              l10n.connectionError,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: Text(
                  errorMessage!,
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  onPressed: onClose,
                  child: Text(l10n.close),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(l10n.retry),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisconnected(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Center(
      child: GlassmorphicContainer(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.link_off, size: 48,
                color: theme.colorScheme.onSurface.withAlpha(153)),
            const SizedBox(height: 16),
            Text(
              l10n.connectionLost,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  onPressed: onClose,
                  child: Text(l10n.close),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(l10n.connectionReconnect),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
