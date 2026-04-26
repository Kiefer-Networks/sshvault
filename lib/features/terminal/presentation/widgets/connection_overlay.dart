import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:sshvault/features/terminal/domain/entities/ssh_session_entity.dart';

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

      final title = isError ? l10n.connectionError : l10n.connectionLost;
      final message = isError && widget.errorMessage != null
          ? widget.errorMessage!
          : '';
      final actionLabel = isError ? l10n.retry : l10n.connectionReconnect;

      // Android: surface the disconnect through the OS notification
      // shade with a Reconnect action button instead of an in-app
      // modal dialog. The dialog overlays the terminal output and
      // forces a tap-through; the system notification keeps the
      // terminal visible and lets the user reconnect from anywhere.
      if (Platform.isAndroid) {
        final retry = widget.onRetry;
        AdaptiveNotification.showWithAction(
          title: title,
          message: message.isEmpty ? l10n.connectionLost : message,
          actionLabel: actionLabel,
          onAction: retry ?? () {},
        );
        return;
      }

      // Other platforms still get the plain notification + dialog.
      AdaptiveNotification.show(
        context,
        message: message.isNotEmpty ? '$title: $message' : title,
      );

      showAdaptiveConfirmDialog(
        context,
        title: title,
        message: message,
        cancelLabel: l10n.close,
        confirmLabel: actionLabel,
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
            padding: Spacing.paddingAllXxl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator.adaptive(),
                Spacing.verticalLg,
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
