import 'package:flutter/material.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/core/widgets/settings/section_card.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/features/connection/presentation/providers/group_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/tag_providers.dart';
import 'package:shellvault/features/connection/presentation/widgets/tag_selector.dart';
import 'package:shellvault/features/snippet/domain/entities/snippet_entity.dart';
import 'package:shellvault/features/snippet/presentation/providers/snippet_providers.dart';
import 'package:shellvault/features/snippet/presentation/widgets/variable_editor.dart';

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
    final groupsAsync = ref.watch(groupListProvider);
    final formState = ref.watch(_snippetFormProvider);

    return AdaptiveScaffold(
      title: widget.isEditing
          ? l10n.snippetFormTitleEdit
          : l10n.snippetFormTitleNew,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SectionCard(
              padding: const EdgeInsets.all(16),
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
                  const SizedBox(height: 16),

                  // Language
                  DropdownButtonFormField<String>(
                    initialValue: formState.language,
                    decoration: InputDecoration(
                      labelText: l10n.snippetFormLanguageLabel,
                      prefixIcon: const Icon(Icons.code),
                    ),
                    items: _languages
                        .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        ref.read(_snippetFormProvider.notifier).state =
                            formState.copyWith(language: v);
                      }
                    },
                  ),
                  const SizedBox(height: 16),

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
                  const SizedBox(height: 16),

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
            const SizedBox(height: 16),

            SectionCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Group selector
                  groupsAsync.when(
                    data: (groups) {
                      if (groups.isEmpty) return const SizedBox.shrink();
                      return DropdownButtonFormField<String?>(
                        initialValue: formState.groupId,
                        decoration: InputDecoration(
                          labelText: l10n.snippetFormGroupLabel,
                          prefixIcon: const Icon(Icons.folder_outlined),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(l10n.snippetFormNoGroup),
                          ),
                          ...groups.map(
                            (g) => DropdownMenuItem(
                              value: g.id,
                              child: Text(g.name),
                            ),
                          ),
                        ],
                        onChanged: (v) =>
                            ref.read(_snippetFormProvider.notifier).state =
                                formState.copyWith(groupId: () => v),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 16),

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
            const SizedBox(height: 16),

            // Variables
            SectionCard(
              padding: const EdgeInsets.all(16),
              child: VariableEditor(
                variables: formState.variables,
                onChanged: (vars) =>
                    ref.read(_snippetFormProvider.notifier).state = formState
                        .copyWith(variables: vars),
              ),
            ),
            const SizedBox(height: 32),

            // Save button
            AdaptiveButton.filledIcon(
              onPressed: formState.saving ? null : _save,
              icon: formState.saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(
                widget.isEditing
                    ? l10n.snippetFormUpdateButton
                    : l10n.snippetFormCreateButton,
              ),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
            const SizedBox(height: 32),
          ],
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
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        AdaptiveNotification.show(context, message: l10n.error(e.toString()));
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
