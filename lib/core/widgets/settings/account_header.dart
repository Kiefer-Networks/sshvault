import 'package:flutter/material.dart';

class AccountHeader extends StatelessWidget {
  final String? email;
  final bool isAuthenticated;
  final bool isVerified;
  final String unauthenticatedLabel;
  final String authenticatedLabel;
  final VoidCallback? onTap;

  const AccountHeader({
    super.key,
    this.email,
    required this.isAuthenticated,
    this.isVerified = false,
    required this.unauthenticatedLabel,
    required this.authenticatedLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colorScheme.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(
                  isAuthenticated ? Icons.person : Icons.person_outline,
                  color: colorScheme.onPrimaryContainer,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAuthenticated
                          ? (email ?? authenticatedLabel)
                          : unauthenticatedLabel,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isAuthenticated) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          if (isVerified) ...[
                            Icon(
                              Icons.verified,
                              size: 14,
                              color: Colors.green.shade600,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            authenticatedLabel,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
