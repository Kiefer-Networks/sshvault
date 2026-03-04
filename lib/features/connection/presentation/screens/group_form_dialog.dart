import 'package:flutter/material.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shellvault/core/constants/color_constants.dart';
import 'package:shellvault/core/constants/icon_constants.dart';
import 'package:shellvault/features/connection/domain/entities/group_entity.dart';
import 'package:shellvault/features/connection/presentation/providers/group_providers.dart';
import 'package:shellvault/features/connection/presentation/widgets/color_picker_field.dart';
import 'package:shellvault/features/connection/presentation/widgets/icon_picker_field.dart';

class _GroupFormReactiveState {
  final int color;
  final String iconName;
  final String? parentId;

  const _GroupFormReactiveState({
    this.color = ColorConstants.defaultServerColor,
    this.iconName = IconConstants.defaultIconName,
    this.parentId,
  });

  _GroupFormReactiveState copyWith({
    int? color,
    String? iconName,
    String? Function()? parentId,
  }) {
    return _GroupFormReactiveState(
      color: color ?? this.color,
      iconName: iconName ?? this.iconName,
      parentId: parentId != null ? parentId() : this.parentId,
    );
  }
}

final _groupFormStateProvider =
    StateProvider.autoDispose<_GroupFormReactiveState>(
      (ref) => const _GroupFormReactiveState(),
    );

class GroupFormDialog extends ConsumerStatefulWidget {
  final GroupEntity? group;

  const GroupFormDialog({super.key, this.group});

  bool get isEditing => group != null;

  static Future<void> show(BuildContext context, {GroupEntity? group}) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => GroupFormDialog(group: group),
      ),
    );
  }

  @override
  ConsumerState<GroupFormDialog> createState() => _GroupFormDialogState();
}

class _GroupFormDialogState extends ConsumerState<GroupFormDialog> {
  final _nameController = TextEditingController();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.group != null) {
      _nameController.text = widget.group!.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _ensureInitialized() {
    if (_initialized) return;
    _initialized = true;
    if (widget.group != null) {
      ref
          .read(_groupFormStateProvider.notifier)
          .state = _GroupFormReactiveState(
        color: widget.group!.color,
        iconName: widget.group!.iconName,
        parentId: widget.group!.parentId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _ensureInitialized();
    final formState = ref.watch(_groupFormStateProvider);
    final groupsAsync = ref.watch(groupListProvider);

    final l10n = AppLocalizations.of(context)!;

    final titleText = widget.isEditing
        ? l10n.groupFormTitleEdit
        : l10n.groupFormTitleNew;
    final saveText = widget.isEditing ? l10n.update : l10n.create;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(titleText),
        actions: [TextButton(onPressed: _save, child: Text(saveText))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
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
              return DropdownMenu<String?>(
                initialSelection: formState.parentId,
                expandedInsets: EdgeInsets.zero,
                requestFocusOnTap: false,
                label: Text(l10n.groupFormParentLabel),
                leadingIcon: const Icon(Icons.account_tree),
                dropdownMenuEntries: [
                  DropdownMenuEntry<String?>(
                    value: null,
                    label: l10n.groupFormParentNone,
                  ),
                  ...availableGroups.map(
                    (g) =>
                        DropdownMenuEntry<String?>(value: g.id, label: g.name),
                  ),
                ],
                onSelected: (v) =>
                    ref.read(_groupFormStateProvider.notifier).state = formState
                        .copyWith(parentId: () => v),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),
          ColorPickerField(
            selectedColor: formState.color,
            onColorChanged: (c) =>
                ref.read(_groupFormStateProvider.notifier).state = formState
                    .copyWith(color: c),
          ),
          const SizedBox(height: 16),
          IconPickerField(
            selectedIcon: formState.iconName,
            onIconChanged: (i) =>
                ref.read(_groupFormStateProvider.notifier).state = formState
                    .copyWith(iconName: i),
            accentColor: formState.color,
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final formState = ref.read(_groupFormStateProvider);
    final now = DateTime.now();
    final notifier = ref.read(groupListProvider.notifier);

    if (widget.isEditing) {
      await notifier.updateGroup(
        widget.group!.copyWith(
          name: name,
          color: formState.color,
          iconName: formState.iconName,
          parentId: formState.parentId,
        ),
      );
    } else {
      await notifier.createGroup(
        GroupEntity(
          id: '',
          name: name,
          color: formState.color,
          iconName: formState.iconName,
          parentId: formState.parentId,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    if (mounted) Navigator.of(context).pop();
  }
}
