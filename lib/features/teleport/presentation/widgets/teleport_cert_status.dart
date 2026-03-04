import 'package:flutter/material.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class TeleportCertStatus extends StatelessWidget {
  final DateTime? expiresAt;

  const TeleportCertStatus({super.key, this.expiresAt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (expiresAt == null) {
      return _badge(
        context,
        icon: Icons.vpn_key_off,
        label: l10n.teleportCertNone,
        color: theme.colorScheme.outline,
      );
    }

    final now = DateTime.now();
    final remaining = expiresAt!.difference(now);

    if (remaining.isNegative) {
      return _badge(
        context,
        icon: Icons.error_outline,
        label: l10n.teleportCertExpired,
        color: theme.colorScheme.error,
      );
    }

    if (remaining.inMinutes < 30) {
      return _badge(
        context,
        icon: Icons.warning_amber,
        label: l10n.teleportCertExpiringSoon,
        color: theme.colorScheme.tertiary,
      );
    }

    final hours = remaining.inHours;
    final label = hours > 0
        ? l10n.teleportCertHoursLeft(hours)
        : l10n.teleportCertMinutesLeft(remaining.inMinutes);

    return _badge(
      context,
      icon: Icons.verified,
      label: label,
      color: theme.colorScheme.primary,
    );
  }

  Widget _badge(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
