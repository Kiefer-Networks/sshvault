import 'package:flutter/material.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/constants/color_constants.dart';
import 'package:shellvault/features/connection/domain/entities/tag_entity.dart';
import 'package:shellvault/features/connection/presentation/providers/tag_providers.dart';
import 'package:shellvault/features/connection/presentation/widgets/color_picker_field.dart';

class TagFormDialog extends ConsumerStatefulWidget {
  final TagEntity? tag;

  const TagFormDialog({super.key, this.tag});

  bool get isEditing => tag != null;

  static Future<void> show(BuildContext context, {TagEntity? tag}) {
    return showDialog(
      context: context,
      builder: (_) => TagFormDialog(tag: tag),
    );
  }

  @override
  ConsumerState<TagFormDialog> createState() => _TagFormDialogState();
}

class _TagFormDialogState extends ConsumerState<TagFormDialog> {
  final _nameController = TextEditingController();
  int _color = ColorConstants.defaultServerColor;

  @override
  void initState() {
    super.initState();
    if (widget.tag != null) {
      _nameController.text = widget.tag!.name;
      _color = widget.tag!.color;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(
        widget.isEditing ? l10n.tagFormTitleEdit : l10n.tagFormTitleNew,
      ),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.tagFormNameLabel,
                  prefixIcon: const Icon(Icons.label_outline),
                ),
                keyboardType: TextInputType.text,
                autofocus: true,
              ),
              const SizedBox(height: 16),
              ColorPickerField(
                selectedColor: _color,
                onColorChanged: (c) => setState(() => _color = c),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(widget.isEditing ? l10n.update : l10n.create),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final now = DateTime.now();
    final notifier = ref.read(tagListProvider.notifier);

    if (widget.isEditing) {
      await notifier.updateTag(widget.tag!.copyWith(name: name, color: _color));
    } else {
      await notifier.createTag(
        TagEntity(
          id: '',
          name: name,
          color: _color,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    if (mounted) Navigator.of(context).pop();
  }
}
