import 'package:flutter/material.dart';
import 'package:shellvault/core/constants/icon_constants.dart';
import 'package:shellvault/features/connection/domain/entities/group_entity.dart';

class GroupChip extends StatelessWidget {
  final GroupEntity group;
  final VoidCallback? onTap;
  final bool selected;

  const GroupChip({
    super.key,
    required this.group,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: selected,
      label: Text(group.name),
      avatar: Icon(
        IconConstants.getIcon(group.iconName),
        size: 18,
        color: Color(group.color),
      ),
      onSelected: onTap != null ? (_) => onTap!() : null,
      side: BorderSide(
        color: Color(group.color).withAlpha(77),
      ),
    );
  }
}
