import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/constants/color_constants.dart';
import 'package:shellvault/core/constants/icon_constants.dart';
import 'package:shellvault/features/connection/domain/entities/group_entity.dart';
import 'package:shellvault/features/connection/presentation/providers/group_providers.dart';
import 'package:shellvault/features/connection/presentation/widgets/color_picker_field.dart';
import 'package:shellvault/features/connection/presentation/widgets/icon_picker_field.dart';

class GroupFormDialog extends StatefulWidget {
  final GroupEntity? group;
  final WidgetRef ref;

  const GroupFormDialog({super.key, this.group, required this.ref});

  bool get isEditing => group != null;

  static Future<void> show(
    BuildContext context,
    WidgetRef ref, {
    GroupEntity? group,
  }) {
    return showDialog(
      context: context,
      builder: (_) => GroupFormDialog(group: group, ref: ref),
    );
  }

  @override
  State<GroupFormDialog> createState() => _GroupFormDialogState();
}

class _GroupFormDialogState extends State<GroupFormDialog> {
  final _nameController = TextEditingController();
  int _color = ColorConstants.defaultServerColor;
  String _iconName = IconConstants.defaultIconName;
  String? _parentId;

  @override
  void initState() {
    super.initState();
    if (widget.group != null) {
      _nameController.text = widget.group!.name;
      _color = widget.group!.color;
      _iconName = widget.group!.iconName;
      _parentId = widget.group!.parentId;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupsAsync = widget.ref.watch(groupListProvider);

    return AlertDialog(
      title: Text(widget.isEditing ? 'Edit Group' : 'New Group'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Group Name',
                  prefixIcon: Icon(Icons.folder_outlined),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              groupsAsync.when(
                data: (groups) {
                  final availableGroups = groups
                      .where((g) => g.id != widget.group?.id)
                      .toList();
                  if (availableGroups.isEmpty) return const SizedBox.shrink();
                  return DropdownButtonFormField<String?>(
                    initialValue: _parentId,
                    decoration: const InputDecoration(
                      labelText: 'Parent Group',
                      prefixIcon: Icon(Icons.account_tree),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('None (Root)'),
                      ),
                      ...availableGroups.map(
                        (g) => DropdownMenuItem(
                          value: g.id,
                          child: Text(g.name),
                        ),
                      ),
                    ],
                    onChanged: (v) => setState(() => _parentId = v),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),
              ColorPickerField(
                selectedColor: _color,
                onColorChanged: (c) => setState(() => _color = c),
              ),
              const SizedBox(height: 16),
              IconPickerField(
                selectedIcon: _iconName,
                onIconChanged: (i) => setState(() => _iconName = i),
                accentColor: _color,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(widget.isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final now = DateTime.now();
    final notifier = widget.ref.read(groupListProvider.notifier);

    if (widget.isEditing) {
      await notifier.updateGroup(widget.group!.copyWith(
        name: name,
        color: _color,
        iconName: _iconName,
        parentId: _parentId,
      ));
    } else {
      await notifier.createGroup(GroupEntity(
        id: '',
        name: name,
        color: _color,
        iconName: _iconName,
        parentId: _parentId,
        createdAt: now,
        updatedAt: now,
      ));
    }

    if (mounted) Navigator.of(context).pop();
  }
}
