import 'package:flutter/material.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sshvault/core/constants/color_constants.dart';
import 'package:sshvault/core/constants/icon_constants.dart';
import 'package:sshvault/features/connection/domain/entities/group_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/folder_providers.dart';
import 'package:sshvault/features/connection/presentation/widgets/color_picker_field.dart';
import 'package:sshvault/features/connection/presentation/widgets/folder_tree_picker.dart';
import 'package:sshvault/features/connection/presentation/widgets/icon_picker_field.dart';

class _FolderFormReactiveState {
  final int color;
  final String iconName;
  final String? parentId;

  const _FolderFormReactiveState({
    this.color = ColorConstants.defaultServerColor,
    this.iconName = IconConstants.defaultIconName,
    this.parentId,
  });

  _FolderFormReactiveState copyWith({
    int? color,
    String? iconName,
    String? Function()? parentId,
  }) {
    return _FolderFormReactiveState(
      color: color ?? this.color,
      iconName: iconName ?? this.iconName,
      parentId: parentId != null ? parentId() : this.parentId,
    );
  }
}

final _folderFormStateProvider =
    StateProvider.autoDispose<_FolderFormReactiveState>(
      (ref) => const _FolderFormReactiveState(),
    );

class FolderFormDialog extends ConsumerStatefulWidget {
  final GroupEntity? folder;

  const FolderFormDialog({super.key, this.folder});

  bool get isEditing => folder != null;

  static Future<void> show(BuildContext context, {GroupEntity? folder}) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => FolderFormDialog(folder: folder),
      ),
    );
  }

  @override
  ConsumerState<FolderFormDialog> createState() => _FolderFormDialogState();
}

class _FolderFormDialogState extends ConsumerState<FolderFormDialog> {
  final _nameController = TextEditingController();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.folder != null) {
      _nameController.text = widget.folder!.name;
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
    if (widget.folder != null) {
      ref
          .read(_folderFormStateProvider.notifier)
          .state = _FolderFormReactiveState(
        color: widget.folder!.color,
        iconName: widget.folder!.iconName,
        parentId: widget.folder!.parentId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _ensureInitialized();
    final formState = ref.watch(_folderFormStateProvider);
    final foldersAsync = ref.watch(folderListProvider);

    final l10n = AppLocalizations.of(context)!;

    final titleText = widget.isEditing
        ? l10n.folderFormTitleEdit
        : l10n.folderFormTitleNew;
    final saveText = widget.isEditing ? l10n.update : l10n.create;

    // Resolve parent folder name
    final parentName = foldersAsync.whenOrNull(
      data: (folders) =>
          folders.where((f) => f.id == formState.parentId).firstOrNull?.name,
    );

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
              labelText: l10n.folderFormNameLabel,
              prefixIcon: const Icon(Icons.folder_outlined),
            ),
            keyboardType: TextInputType.text,
            autofocus: true,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.account_tree),
            title: Text(parentName ?? l10n.folderFormParentNone),
            subtitle: Text(l10n.folderFormParentLabel),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final result = await FolderTreePicker.show(
                context,
                selectedFolderId: formState.parentId,
                excludeFolderId: widget.folder?.id,
              );
              if (result != formState.parentId) {
                ref.read(_folderFormStateProvider.notifier).state = formState
                    .copyWith(parentId: () => result);
              }
            },
          ),
          const SizedBox(height: 16),
          ColorPickerField(
            selectedColor: formState.color,
            onColorChanged: (c) =>
                ref.read(_folderFormStateProvider.notifier).state = formState
                    .copyWith(color: c),
          ),
          const SizedBox(height: 16),
          IconPickerField(
            selectedIcon: formState.iconName,
            onIconChanged: (i) =>
                ref.read(_folderFormStateProvider.notifier).state = formState
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

    final formState = ref.read(_folderFormStateProvider);
    final now = DateTime.now();
    final notifier = ref.read(folderListProvider.notifier);

    if (widget.isEditing) {
      await notifier.updateFolder(
        widget.folder!.copyWith(
          name: name,
          color: formState.color,
          iconName: formState.iconName,
          parentId: formState.parentId,
        ),
      );
    } else {
      await notifier.createFolder(
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
