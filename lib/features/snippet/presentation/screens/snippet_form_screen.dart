import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/widgets/settings/section_card.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/features/connection/presentation/providers/folder_providers.dart';
import 'package:sshvault/features/connection/presentation/widgets/folder_tree_picker.dart';
import 'package:sshvault/features/connection/presentation/providers/tag_providers.dart';
import 'package:sshvault/features/connection/presentation/widgets/tag_selector.dart';
import 'package:sshvault/features/snippet/domain/entities/snippet_entity.dart';
import 'package:sshvault/features/snippet/presentation/providers/snippet_providers.dart';
import 'package:sshvault/features/snippet/presentation/widgets/variable_editor.dart';

class _SnippetFormState {
  final String language;
  final String? groupId;
  final List<String> selectedTagIds;
  final List<SnippetVariableEntity> variables;
  final bool saving;

  const _SnippetFormState({
    this.language = 'bash',
    this.groupId,
    this.selectedTagIds = const [],
    this.variables = const [],
    this.saving = false,
  });

  _SnippetFormState copyWith({
    String? language,
    String? Function()? groupId,
    List<String>? selectedTagIds,
    List<SnippetVariableEntity>? variables,
    bool? saving,
  }) {
    return _SnippetFormState(
      language: language ?? this.language,
      groupId: groupId != null ? groupId() : this.groupId,
      selectedTagIds: selectedTagIds ?? this.selectedTagIds,
      variables: variables ?? this.variables,
      saving: saving ?? this.saving,
    );
  }
}

final _snippetFormProvider = StateProvider.autoDispose<_SnippetFormState>(
  (ref) => const _SnippetFormState(),
);

class SnippetFormScreen extends ConsumerStatefulWidget {
  final String? snippetId;

  const SnippetFormScreen({super.key, this.snippetId});

  bool get isEditing => snippetId != null;

  @override
  ConsumerState<SnippetFormScreen> createState() => _SnippetFormScreenState();
}

class _SnippetFormScreenState extends ConsumerState<SnippetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contentController = TextEditingController();
  final _descriptionController = TextEditingController();

  static const _languages = [
    'bash',
    'sh',
    'zsh',
    'fish',
    'powershell',
    'python',
    'ruby',
    'perl',
    'javascript',
    'typescript',
    'go',
    'rust',
    'sql',
    'yaml',
    'json',
    'toml',
    'dockerfile',
    'terraform',
    'ansible',
    'other',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _loadSnippet();
    }
  }

  Future<void> _loadSnippet() async {
    final snippet = await ref.read(
      snippetDetailProvider(widget.snippetId!).future,
    );
    if (!mounted) return;
    _nameController.text = snippet.name;
    _contentController.text = snippet.content;
    _descriptionController.text = snippet.description;
    ref.read(_snippetFormProvider.notifier).state = _SnippetFormState(
      language: snippet.language,
      groupId: snippet.groupId,
      selectedTagIds: snippet.tags.map((t) => t.id).toList(),
      variables: List.from(snippet.variables),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contentController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final foldersAsync = ref.watch(folderListProvider);
    final formState = ref.watch(_snippetFormProvider);

    return AdaptiveScaffold.withAppBar(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: l10n.close,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.isEditing
              ? l10n.snippetFormTitleEdit
              : l10n.snippetFormTitleNew,
        ),
        actions: [
          TextButton(
            onPressed: formState.saving ? null : _save,
            child: formState.saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.save),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: Spacing.paddingAllLg,
              children: [
                SectionCard(
                  padding: Spacing.paddingAllLg,
                  child: Column(
                    children: [
                      // Name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: l10n.snippetFormNameLabel,
                          hintText: l10n.snippetFormNameHint,
                          prefixIcon: const Icon(Icons.label_outline),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? l10n.snippetFormNameRequired
                            : null,
                      ),
                      Spacing.verticalLg,

                      // Language
                      DropdownMenu<String>(
                        initialSelection: formState.language,
                        expandedInsets: EdgeInsets.zero,
                        requestFocusOnTap: false,
                        label: Text(l10n.snippetFormLanguageLabel),
                        leadingIcon: const Icon(Icons.code),
                        dropdownMenuEntries: _languages
                            .map((l) => DropdownMenuEntry(value: l, label: l))
                            .toList(),
                        onSelected: (v) {
                          if (v != null) {
                            ref.read(_snippetFormProvider.notifier).state =
                                formState.copyWith(language: v);
                          }
                        },
                      ),
                      Spacing.verticalLg,

                      // Content
                      TextFormField(
                        controller: _contentController,
                        decoration: InputDecoration(
                          labelText: l10n.snippetFormContentLabel,
                          hintText: l10n.snippetFormContentHint,
                          alignLabelWithHint: true,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        minLines: 5,
                        style: const TextStyle(
                          fontFamily: AppConstants.monospaceFontFamily,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? l10n.snippetFormContentRequired
                            : null,
                      ),
                      Spacing.verticalLg,

                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: l10n.snippetFormDescriptionLabel,
                          hintText: l10n.snippetFormDescriptionHint,
                          prefixIcon: const Icon(Icons.description_outlined),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        minLines: 1,
                      ),
                    ],
                  ),
                ),
                Spacing.verticalLg,

                SectionCard(
                  padding: Spacing.paddingAllLg,
                  child: Column(
                    children: [
                      // Folder selector
                      Builder(
                        builder: (context) {
                          final folderName = foldersAsync.whenOrNull(
                            data: (folders) => folders
                                .where((f) => f.id == formState.groupId)
                                .firstOrNull
                                ?.name,
                          );
                          return ListTile(
                            leading: const Icon(Icons.folder_outlined),
                            title: Text(folderName ?? l10n.snippetFormNoFolder),
                            subtitle: Text(l10n.snippetFormFolderLabel),
                            trailing: const Icon(Icons.chevron_right),
                            contentPadding: EdgeInsets.zero,
                            onTap: () async {
                              final result = await FolderTreePicker.show(
                                context,
                                selectedFolderId: formState.groupId,
                              );
                              if (result != formState.groupId) {
                                ref.read(_snippetFormProvider.notifier).state =
                                    formState.copyWith(groupId: () => result);
                              }
                            },
                          );
                        },
                      ),
                      Spacing.verticalLg,

                      // Tags
                      TagSelector(
                        selectedTagIds: formState.selectedTagIds,
                        onChanged: (ids) =>
                            ref.read(_snippetFormProvider.notifier).state =
                                formState.copyWith(selectedTagIds: ids),
                      ),
                    ],
                  ),
                ),
                Spacing.verticalLg,

                // Variables
                SectionCard(
                  padding: Spacing.paddingAllLg,
                  child: VariableEditor(
                    variables: formState.variables,
                    onChanged: (vars) =>
                        ref.read(_snippetFormProvider.notifier).state =
                            formState.copyWith(variables: vars),
                  ),
                ),
                Spacing.verticalXxxl,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final formState = ref.read(_snippetFormProvider);
    ref.read(_snippetFormProvider.notifier).state = formState.copyWith(
      saving: true,
    );

    final l10n = AppLocalizations.of(context)!;
    try {
      final tagsAsync = ref.read(tagListProvider);
      final allTags = tagsAsync.value ?? [];
      final selectedTags = allTags
          .where((t) => formState.selectedTagIds.contains(t.id))
          .toList();

      final now = DateTime.now();
      final snippet = SnippetEntity(
        id: widget.snippetId ?? '',
        name: _nameController.text.trim(),
        content: _contentController.text,
        language: formState.language,
        description: _descriptionController.text.trim(),
        groupId: formState.groupId,
        tags: selectedTags,
        variables: formState.variables,
        createdAt: now,
        updatedAt: now,
      );

      final notifier = ref.read(snippetListProvider.notifier);
      if (widget.isEditing) {
        await notifier.updateSnippet(snippet);
      } else {
        await notifier.createSnippet(snippet);
      }

      if (mounted) {
        AdaptiveNotification.show(context, message: l10n.snippetFormSaved);
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        AdaptiveNotification.show(
          context,
          message: l10n.error(errorMessage(e)),
        );
      }
    } finally {
      if (mounted) {
        final current = ref.read(_snippetFormProvider);
        ref.read(_snippetFormProvider.notifier).state = current.copyWith(
          saving: false,
        );
      }
    }
  }
}
