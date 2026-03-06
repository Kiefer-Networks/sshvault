import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/widgets/settings/circle_icon.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sshvault/features/connection/presentation/widgets/tag_chip.dart';
import 'package:sshvault/features/snippet/domain/entities/snippet_entity.dart';

class SnippetTile extends StatelessWidget {
  final SnippetEntity snippet;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const SnippetTile({
    super.key,
    required this.snippet,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          if (onEdit != null)
            SlidableAction(
              onPressed: (_) => onEdit!(),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              icon: Icons.edit,
              label: l10n.edit,
              borderRadius: BorderRadius.circular(12),
            ),
          if (onDelete != null)
            SlidableAction(
              onPressed: (_) => onDelete!(),
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
              icon: Icons.delete,
              label: l10n.delete,
              borderRadius: BorderRadius.circular(12),
            ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleIcon(
          icon: Icons.code,
          color: theme.colorScheme.primary,
          size: 44,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(snippet.name, overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                snippet.language,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (snippet.description.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                snippet.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(
                    AppConstants.alpha153,
                  ),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ] else if (snippet.content.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                snippet.content.length > 80
                    ? '${snippet.content.substring(0, 80)}...'
                    : snippet.content,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: AppConstants.monospaceFontFamily,
                  color: theme.colorScheme.onSurface.withAlpha(
                    AppConstants.alpha153,
                  ),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (snippet.tags.isNotEmpty) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                runSpacing: 2,
                children: snippet.tags
                    .take(3)
                    .map((tag) => TagChip(tag: tag))
                    .toList(),
              ),
            ],
          ],
        ),
        isThreeLine: snippet.tags.isNotEmpty,
      ),
    );
  }
}
