import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/utils/platform_utils.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/constants/color_constants.dart';
import 'package:shellvault/core/constants/icon_constants.dart';
import 'package:shellvault/features/connection/domain/entities/group_entity.dart';
import 'package:shellvault/features/connection/presentation/providers/group_providers.dart';
import 'package:shellvault/features/connection/presentation/widgets/color_picker_field.dart';
import 'package:shellvault/features/connection/presentation/widgets/icon_picker_field.dart';

class GroupFormDialog extends ConsumerStatefulWidget {
  final GroupEntity? group;

  const GroupFormDialog({super.key, this.group});

  bool get isEditing => group != null;

  static Future<void> show(BuildContext context, {GroupEntity? group}) {
    return showDialog(
      context: context,
      builder: (_) => GroupFormDialog(group: group),
    );
  }

  @override
  ConsumerState<GroupFormDialog> createState() => _GroupFormDialogState();
}

class _GroupFormDialogState extends ConsumerState<GroupFormDialog> {
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
    final groupsAsync = ref.watch(groupListProvider);

    final l10n = AppLocalizations.of(context)!;

    final titleText = widget.isEditing
        ? l10n.groupFormTitleEdit
        : l10n.groupFormTitleNew;
    final saveText = widget.isEditing ? l10n.update : l10n.create;

    final formContent = SizedBox(
      width: 400,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.groupFormNameLabel,
                prefixIcon: const Icon(Icons.folder_outlined),
              ),
              keyboardType: TextInputType.text,
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
                  decoration: InputDecoration(
                    labelText: l10n.groupFormParentLabel,
                    prefixIcon: const Icon(Icons.account_tree),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(l10n.groupFormParentNone),
                    ),
                    ...availableGroups.map(
                      (g) =>
                          DropdownMenuItem(value: g.id, child: Text(g.name)),
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
    );

    if (useCupertinoDesign) {
      return CupertinoAlertDialog(
        title: Text(titleText),
        content: Material(color: Colors.transparent, child: formContent),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: _save,
            child: Text(saveText),
          ),
        ],
      );
    }

    return AlertDialog(
      title: Text(titleText),
      content: formContent,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(saveText),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final now = DateTime.now();
    final notifier = ref.read(groupListProvider.notifier);

    if (widget.isEditing) {
      await notifier.updateGroup(
        widget.group!.copyWith(
          name: name,
          color: _color,
          iconName: _iconName,
          parentId: _parentId,
        ),
      );
    } else {
      await notifier.createGroup(
        GroupEntity(
          id: '',
          name: name,
          color: _color,
          iconName: _iconName,
          parentId: _parentId,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    if (mounted) Navigator.of(context).pop();
  }
}
