import 'package:flutter/material.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:shellvault/features/terminal/domain/entities/ssh_session_entity.dart';

/// Shows connection status for the active terminal session.
///
/// - Connecting/Authenticating: inline spinner overlay
/// - Error/Disconnected: standard [AlertDialog] shown once
class ConnectionOverlay extends StatefulWidget {
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
  State<ConnectionOverlay> createState() => _ConnectionOverlayState();
}

class _ConnectionOverlayState extends State<ConnectionOverlay> {
  bool _dialogShown = false;

  @override
  void didUpdateWidget(ConnectionOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status != oldWidget.status) {
      _dialogShown = false;
    }
  }

  void _showStatusDialog() {
    if (_dialogShown) return;
    _dialogShown = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final isError = widget.status == SshConnectionStatus.error;
      final l10n = AppLocalizations.of(context)!;

      showAdaptiveConfirmDialog(
        context,
        title: isError ? l10n.connectionError : l10n.connectionLost,
        message: isError && widget.errorMessage != null
            ? widget.errorMessage!
            : '',
        cancelLabel: l10n.close,
        confirmLabel: isError ? l10n.retry : l10n.connectionReconnect,
      ).then((result) {
        if (!mounted) return;
        if (result == true) {
          widget.onRetry?.call();
        } else {
          widget.onClose?.call();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return switch (widget.status) {
      SshConnectionStatus.connecting ||
      SshConnectionStatus.authenticating => Center(
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator.adaptive(),
                const SizedBox(height: 16),
                Text(
                  widget.status == SshConnectionStatus.authenticating
                      ? l10n.connectionAuthenticating
                      : l10n.connectionConnecting(
                          widget.serverName ?? 'server',
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      SshConnectionStatus.error || SshConnectionStatus.disconnected => Builder(
        builder: (_) {
          _showStatusDialog();
          return const SizedBox.shrink();
        },
      ),
      SshConnectionStatus.connected => const SizedBox.shrink(),
    };
  }
}
