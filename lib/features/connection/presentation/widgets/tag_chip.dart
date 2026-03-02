import 'package:flutter/material.dart';
import 'package:shellvault/features/connection/domain/entities/tag_entity.dart';

class TagChip extends StatelessWidget {
  final TagEntity tag;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool selected;

  const TagChip({
    super.key,
    required this.tag,
    this.onTap,
    this.onDelete,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: selected,
      label: Text(tag.name),
      onSelected: onTap != null ? (_) => onTap!() : null,
      onDeleted: onDelete,
      backgroundColor: Color(tag.color).withAlpha(26),
      selectedColor: Color(tag.color).withAlpha(51),
      side: BorderSide(color: Color(tag.color).withAlpha(77)),
      labelStyle: TextStyle(color: Color(tag.color), fontSize: 12),
    );
  }
}
