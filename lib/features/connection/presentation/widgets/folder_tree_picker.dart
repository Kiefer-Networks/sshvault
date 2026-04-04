import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/constants/icon_constants.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/features/connection/domain/entities/group_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/folder_providers.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

class FolderTreePicker {
  static Future<String?> show(
    BuildContext context, {
    String? selectedFolderId,
    bool allowNone = true,
    String? excludeFolderId,
  }) {
    return showDialog<String?>(
      context: context,
      builder: (_) => _FolderTreePickerDialog(
        selectedFolderId: selectedFolderId,
        allowNone: allowNone,
        excludeFolderId: excludeFolderId,
      ),
    );
  }
}

class _FolderTreePickerDialog extends ConsumerWidget {
  final String? selectedFolderId;
  final bool allowNone;
  final String? excludeFolderId;

  const _FolderTreePickerDialog({
    this.selectedFolderId,
    this.allowNone = true,
    this.excludeFolderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final treeAsync = ref.watch(folderTreeProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SimpleDialog(
      title: Text(l10n.navFolders),
      children: [
        if (allowNone)
          _FolderOption(
            icon: Icons.folder_off_outlined,
            label: l10n.folderFormParentNone,
            isSelected: selectedFolderId == null,
            onTap: () => Navigator.pop(context, null),
          ),
        treeAsync.when(
          data: (folders) {
            final nodes = <Widget>[];
            _buildNodes(context, folders, nodes, depth: 0);
            if (nodes.isEmpty) {
              return Padding(
                padding: Spacing.paddingAllXxl,
                child: Text(
                  l10n.folderListEmpty,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }
            return Column(mainAxisSize: MainAxisSize.min, children: nodes);
          },
          loading: () => Padding(
            padding: Spacing.paddingAllXxl,
            child: Center(child: CircularProgressIndicator.adaptive()),
          ),
          error: (_, _) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  void _buildNodes(
    BuildContext context,
    List<GroupEntity> folders,
    List<Widget> nodes, {
    required int depth,
  }) {
    for (final folder in folders) {
      if (folder.id == excludeFolderId) continue;
      nodes.add(
        _FolderOption(
          icon: IconConstants.getIcon(folder.iconName),
          iconColor: Color(folder.color),
          label: folder.name,
          depth: depth,
          serverCount: folder.serverCount,
          isSelected: selectedFolderId == folder.id,
          onTap: () => Navigator.pop(context, folder.id),
        ),
      );
      if (folder.children.isNotEmpty) {
        _buildNodes(context, folder.children, nodes, depth: depth + 1);
      }
    }
  }
}

class _FolderOption extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final int depth;
  final int? serverCount;
  final bool isSelected;
  final VoidCallback onTap;

  const _FolderOption({
    required this.icon,
    this.iconColor,
    required this.label,
    this.depth = 0,
    this.serverCount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.only(
        left: Spacing.xxl + depth * Spacing.xxl,
        right: Spacing.xxl,
      ),
      leading: Icon(icon, color: iconColor, size: 22),
      title: Text(label),
      trailing: isSelected
          ? Icon(Icons.check, color: theme.colorScheme.primary)
          : null,
      selected: isSelected,
      dense: true,
      onTap: onTap,
    );
  }
}
