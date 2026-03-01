import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/features/connection/domain/entities/tag_entity.dart';
import 'package:shellvault/features/connection/presentation/providers/tag_providers.dart';
import 'package:shellvault/features/connection/presentation/widgets/tag_chip.dart';

class TagSelector extends ConsumerWidget {
  final List<String> selectedTagIds;
  final ValueChanged<List<String>> onChanged;

  const TagSelector({
    super.key,
    required this.selectedTagIds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(tagListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tags', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        tagsAsync.when(
          data: (tags) {
            if (tags.isEmpty) {
              return Text(
                'No tags yet',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(102),
                    ),
              );
            }
            return Wrap(
              spacing: 8,
              runSpacing: 4,
              children: tags.map((tag) {
                return TagChip(
                  tag: tag,
                  selected: selectedTagIds.contains(tag.id),
                  onTap: () => _toggleTag(tag),
                );
              }).toList(),
            );
          },
          loading: () =>
              const SizedBox(height: 32, child: CircularProgressIndicator()),
          error: (_, _) => const Text('Failed to load tags'),
        ),
      ],
    );
  }

  void _toggleTag(TagEntity tag) {
    final newIds = List<String>.from(selectedTagIds);
    if (newIds.contains(tag.id)) {
      newIds.remove(tag.id);
    } else {
      newIds.add(tag.id);
    }
    onChanged(newIds);
  }
}
