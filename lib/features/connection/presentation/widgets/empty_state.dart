import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: Spacing.paddingAllXxxl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 72,
              color: theme.colorScheme.onSurface.withAlpha(
                AppConstants.alpha51,
              ),
            ),
            Spacing.verticalLg,
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(
                  AppConstants.alpha179,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            Spacing.verticalSm,
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(
                  AppConstants.alpha102,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[Spacing.verticalXxl, action!],
          ],
        ),
      ),
    );
  }
}
