import 'package:flutter/material.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shellvault/core/constants/color_constants.dart';
import 'package:shellvault/features/connection/domain/entities/tag_entity.dart';
import 'package:shellvault/features/connection/presentation/providers/tag_providers.dart';
import 'package:shellvault/features/connection/presentation/widgets/color_picker_field.dart';

final _tagFormColorProvider = StateProvider.autoDispose<int>(
  (ref) => ColorConstants.defaultServerColor,
);

class TagFormDialog extends ConsumerStatefulWidget {
  final TagEntity? tag;

  const TagFormDialog({super.key, this.tag});

  bool get isEditing => tag != null;

  static Future<void> show(BuildContext context, {TagEntity? tag}) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => TagFormDialog(tag: tag),
      ),
    );
  }

  @override
  ConsumerState<TagFormDialog> createState() => _TagFormDialogState();
}

class _TagFormDialogState extends ConsumerState<TagFormDialog> {
  final _nameController = TextEditingController();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.tag != null) {
      _nameController.text = widget.tag!.name;
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
    if (widget.tag != null) {
      ref.read(_tagFormColorProvider.notifier).state = widget.tag!.color;
    }
  }

  @override
  Widget build(BuildContext context) {
    _ensureInitialized();
    final color = ref.watch(_tagFormColorProvider);
    final l10n = AppLocalizations.of(context)!;

    final titleText = widget.isEditing
        ? l10n.tagFormTitleEdit
        : l10n.tagFormTitleNew;
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
              labelText: l10n.tagFormNameLabel,
              prefixIcon: const Icon(Icons.label_outline),
            ),
            keyboardType: TextInputType.text,
            autofocus: true,
          ),
          const SizedBox(height: 16),
          ColorPickerField(
            selectedColor: color,
            onColorChanged: (c) =>
                ref.read(_tagFormColorProvider.notifier).state = c,
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final color = ref.read(_tagFormColorProvider);
    final now = DateTime.now();
    final notifier = ref.read(tagListProvider.notifier);

    if (widget.isEditing) {
      await notifier.updateTag(widget.tag!.copyWith(name: name, color: color));
    } else {
      await notifier.createTag(
        TagEntity(
          id: '',
          name: name,
          color: color,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    if (mounted) Navigator.of(context).pop();
  }
}
