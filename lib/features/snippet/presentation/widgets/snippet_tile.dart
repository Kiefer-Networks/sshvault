import 'package:flutter/material.dart';
import 'package:shellvault/features/connection/presentation/widgets/tag_chip.dart';
import 'package:shellvault/features/snippet/domain/entities/snippet_entity.dart';

class SnippetTile extends StatelessWidget {
  final SnippetEntity snippet;
  final VoidCallback? onTap;

  const SnippetTile({
    super.key,
    required this.snippet,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withAlpha(26),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.code, color: theme.colorScheme.primary, size: 20),
      ),
      title: Row(
        children: [
          Expanded(child: Text(snippet.name)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(6),
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
          if (snippet.content.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              snippet.content.length > 80
                  ? '${snippet.content.substring(0, 80)}...'
                  : snippet.content,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: theme.colorScheme.onSurface.withAlpha(128),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (snippet.tags.isNotEmpty) ...[
            const SizedBox(height: 6),
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
    );
  }
}
