import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/features/connection/domain/entities/tag_entity.dart';

class TagChip extends StatelessWidget {
  final TagEntity tag;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool selected;
  final VisualDensity? visualDensity;
  final MaterialTapTargetSize? materialTapTargetSize;

  const TagChip({
    super.key,
    required this.tag,
    this.onTap,
    this.onDelete,
    this.selected = false,
    this.visualDensity,
    this.materialTapTargetSize,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: selected,
      label: Text(tag.name),
      onSelected: onTap != null ? (_) => onTap!() : null,
      onDeleted: onDelete,
      backgroundColor: Color(tag.color).withAlpha(AppConstants.alpha26),
      selectedColor: Color(tag.color).withAlpha(AppConstants.alpha51),
      side: BorderSide(color: Color(tag.color).withAlpha(AppConstants.alpha77)),
      labelStyle: TextStyle(color: Color(tag.color), fontSize: 12),
      visualDensity: visualDensity,
      materialTapTargetSize: materialTapTargetSize,
    );
  }
}
