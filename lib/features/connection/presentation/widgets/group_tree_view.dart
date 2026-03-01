import 'package:flutter/material.dart';
import 'package:shellvault/core/constants/icon_constants.dart';
import 'package:shellvault/features/connection/domain/entities/group_entity.dart';

class GroupTreeView extends StatelessWidget {
  final List<GroupEntity> groups;
  final String? selectedGroupId;
  final ValueChanged<String?> onGroupSelected;
  final int depth;

  const GroupTreeView({
    super.key,
    required this.groups,
    required this.selectedGroupId,
    required this.onGroupSelected,
    this.depth = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (depth == 0)
          ListTile(
            leading: const Icon(Icons.clear_all),
            title: const Text('No Group'),
            selected: selectedGroupId == null,
            onTap: () => onGroupSelected(null),
            dense: true,
          ),
        ...groups.map((group) {
          final isSelected = selectedGroupId == group.id;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding:
                    EdgeInsets.only(left: 16.0 + depth * 24),
                leading: Icon(
                  IconConstants.getIcon(group.iconName),
                  color: Color(group.color),
                  size: 22,
                ),
                title: Text(group.name),
                trailing: Text(
                  '${group.serverCount}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(102),
                  ),
                ),
                selected: isSelected,
                onTap: () => onGroupSelected(group.id),
                dense: true,
              ),
              if (group.children.isNotEmpty)
                GroupTreeView(
                  groups: group.children,
                  selectedGroupId: selectedGroupId,
                  onGroupSelected: onGroupSelected,
                  depth: depth + 1,
                ),
            ],
          );
        }),
      ],
    );
  }
}
