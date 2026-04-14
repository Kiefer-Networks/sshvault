import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';

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
  final Color? valueColor;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.trailing,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: '$label: $value',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: Spacing.sm),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: theme.colorScheme.onSurface.withAlpha(
                AppConstants.alpha102,
              ),
            ),
            Spacing.horizontalSm,
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(
                  AppConstants.alpha128,
                ),
              ),
            ),
            Spacing.horizontalMd,
            Expanded(
              child: Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: AppConstants.monospaceFontFamily,
                  color: valueColor,
                ),
                textAlign: TextAlign.end,
              ),
            ),
            if (onTap != null) ...[
              Spacing.horizontalXxs,
              Tooltip(
                message: label,
                child: IconButton(
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
              ),
            ],
            if (trailing != null) ...[Spacing.horizontalXxs, trailing!],
          ],
        ),
      ),
    );
  }
}
