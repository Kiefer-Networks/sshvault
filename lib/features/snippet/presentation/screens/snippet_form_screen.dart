import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/features/connection/presentation/providers/group_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/tag_providers.dart';
import 'package:shellvault/features/connection/presentation/widgets/tag_selector.dart';
import 'package:shellvault/features/snippet/domain/entities/snippet_entity.dart';
import 'package:shellvault/features/snippet/presentation/providers/snippet_providers.dart';
import 'package:shellvault/features/snippet/presentation/widgets/variable_editor.dart';

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

  String _language = 'bash';
  String? _groupId;
  List<String> _selectedTagIds = [];
  List<SnippetVariableEntity> _variables = [];
  bool _saving = false;

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
    final snippet =
        await ref.read(snippetDetailProvider(widget.snippetId!).future);
    _nameController.text = snippet.name;
    _contentController.text = snippet.content;
    _descriptionController.text = snippet.description;
    setState(() {
      _language = snippet.language;
      _groupId = snippet.groupId;
      _selectedTagIds = snippet.tags.map((t) => t.id).toList();
      _variables = List.from(snippet.variables);
    });
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
    final groupsAsync = ref.watch(groupListProvider);

    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isEditing ? 'Edit Snippet' : 'New Snippet'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'e.g. Docker cleanup',
                prefixIcon: Icon(Icons.label_outline),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),

            // Language
            DropdownButtonFormField<String>(
              initialValue: _language,
              decoration: const InputDecoration(
                labelText: 'Language',
                prefixIcon: Icon(Icons.code),
              ),
              items: _languages
                  .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _language = v);
              },
            ),
            const SizedBox(height: 16),

            // Content
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                hintText: 'Enter your snippet code...',
                alignLabelWithHint: true,
              ),
              maxLines: 10,
              minLines: 5,
              style: const TextStyle(fontFamily: 'monospace'),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Content is required'
                  : null,
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Optional description...',
                prefixIcon: Icon(Icons.description_outlined),
              ),
              maxLines: 3,
              minLines: 1,
            ),
            const SizedBox(height: 24),

            // Group selector
            groupsAsync.when(
              data: (groups) {
                if (groups.isEmpty) return const SizedBox.shrink();
                return DropdownButtonFormField<String?>(
                  initialValue: _groupId,
                  decoration: const InputDecoration(
                    labelText: 'Group',
                    prefixIcon: Icon(Icons.folder_outlined),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('No Group'),
                    ),
                    ...groups.map(
                      (g) => DropdownMenuItem(
                        value: g.id,
                        child: Text(g.name),
                      ),
                    ),
                  ],
                  onChanged: (v) => setState(() => _groupId = v),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),

            // Tags
            TagSelector(
              selectedTagIds: _selectedTagIds,
              onChanged: (ids) => setState(() => _selectedTagIds = ids),
            ),
            const SizedBox(height: 24),

            // Variables
            VariableEditor(
              variables: _variables,
              onChanged: (vars) => setState(() => _variables = vars),
            ),
            const SizedBox(height: 32),

            // Save button
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(
                  widget.isEditing ? 'Update Snippet' : 'Create Snippet'),
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

    setState(() => _saving = true);

    try {
      final tagsAsync = ref.read(tagListProvider);
      final allTags = tagsAsync.valueOrNull ?? [];
      final selectedTags =
          allTags.where((t) => _selectedTagIds.contains(t.id)).toList();

      final now = DateTime.now();
      final snippet = SnippetEntity(
        id: widget.snippetId ?? '',
        name: _nameController.text.trim(),
        content: _contentController.text,
        language: _language,
        description: _descriptionController.text.trim(),
        groupId: _groupId,
        tags: selectedTags,
        variables: _variables,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
