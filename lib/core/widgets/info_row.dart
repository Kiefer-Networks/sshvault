import 'package:flutter/material.dart';
import 'package:shellvault/core/constants/app_constants.dart';

/// A reusable row that displays an icon, label, and value.
///
/// Optionally supports [onTap] (e.g. for copy-to-clipboard) and a custom
/// [trailing] widget shown after the value.
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final Widget? trailing;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: theme.colorScheme.onSurface.withAlpha(AppConstants.alpha102),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(
                AppConstants.alpha128,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: AppConstants.monospaceFontFamily,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 4),
            IconButton(
              onPressed: onTap,
              icon: Icon(
                Icons.copy,
                size: 16,
                color: theme.colorScheme.onSurface.withAlpha(
                  AppConstants.alpha102,
                ),
              ),
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              padding: EdgeInsets.zero,
            ),
          ],
          if (trailing != null) ...[const SizedBox(width: 4), trailing!],
        ],
      ),
    );
  }
}
