import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/features/host_key/domain/entities/known_host_entity.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

class HostKeyVerificationDialog extends StatelessWidget {
  final String hostname;
  final int port;
  final String keyType;
  final String fingerprint;
  final KnownHostEntity? existingHost;

  const HostKeyVerificationDialog({
    super.key,
    required this.hostname,
    required this.port,
    required this.keyType,
    required this.fingerprint,
    this.existingHost,
  });

  bool get _isChanged => existingHost != null;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      icon: Icon(
        _isChanged ? Icons.warning_amber_rounded : Icons.shield_outlined,
        size: 48,
        color: _isChanged ? colorScheme.error : colorScheme.primary,
      ),
      title: Text(
        _isChanged ? l10n.hostKeyChangedTitle : l10n.hostKeyNewTitle,
        style: _isChanged
            ? textTheme.titleLarge?.copyWith(color: colorScheme.error)
            : null,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isChanged
                  ? l10n.hostKeyChangedMessage(hostname, port)
                  : l10n.hostKeyNewMessage(hostname, port),
            ),
            Spacing.verticalLg,
            _buildInfoRow(l10n.hostKeyType, keyType, textTheme),
            Spacing.verticalSm,
            _buildFingerprintRow(
              _isChanged ? l10n.hostKeyFingerprint : l10n.hostKeyFingerprint,
              fingerprint,
              textTheme,
            ),
            if (_isChanged && existingHost != null) ...[
              Spacing.verticalSm,
              _buildFingerprintRow(
                l10n.hostKeyPreviousFingerprint,
                existingHost!.fingerprint,
                textTheme,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.hostKeyReject),
        ),
        FilledButton(
          style: _isChanged
              ? FilledButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                )
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            _isChanged ? l10n.hostKeyAcceptNew : l10n.hostKeyTrustConnect,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelSmall),
        const SizedBox(height: Spacing.xxxs),
        Text(value, style: textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildFingerprintRow(String label, String hex, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelSmall),
        const SizedBox(height: Spacing.xxxs),
        Container(
          width: double.infinity,
          padding: Spacing.paddingAllSm,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            _formatFingerprint(hex),
            style: textTheme.bodySmall?.copyWith(
              fontFamily: AppConstants.monospaceFontFamily,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  static String _formatFingerprint(String hex) {
    if (hex.contains(':')) return hex;
    final buf = StringBuffer();
    for (int i = 0; i < hex.length; i += 2) {
      if (i > 0) buf.write(':');
      buf.write(hex.substring(i, (i + 2).clamp(0, hex.length)));
    }
    return buf.toString();
  }
}
