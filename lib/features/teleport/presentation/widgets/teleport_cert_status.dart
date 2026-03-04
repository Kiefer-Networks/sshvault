import 'package:flutter/material.dart';

class TeleportCertStatus extends StatelessWidget {
  final DateTime? expiresAt;

  const TeleportCertStatus({super.key, this.expiresAt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (expiresAt == null) {
      return _badge(
        context,
        icon: Icons.vpn_key_off,
        label: 'No cert',
        color: theme.colorScheme.outline,
      );
    }

    final now = DateTime.now();
    final remaining = expiresAt!.difference(now);

    if (remaining.isNegative) {
      return _badge(
        context,
        icon: Icons.error_outline,
        label: 'Expired',
        color: theme.colorScheme.error,
      );
    }

    if (remaining.inMinutes < 30) {
      return _badge(
        context,
        icon: Icons.warning_amber,
        label: 'Expiring soon',
        color: theme.colorScheme.tertiary,
      );
    }

    final hours = remaining.inHours;
    final label = hours > 0 ? '${hours}h left' : '${remaining.inMinutes}m left';

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
