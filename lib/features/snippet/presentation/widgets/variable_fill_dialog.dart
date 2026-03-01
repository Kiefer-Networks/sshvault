import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shellvault/features/snippet/domain/entities/snippet_entity.dart';

class VariableFillDialog extends StatefulWidget {
  final SnippetEntity snippet;
  final bool returnContent;

  const VariableFillDialog({
    super.key,
    required this.snippet,
    this.returnContent = false,
  });

  static Future<String?> show(
    BuildContext context,
    SnippetEntity snippet, {
    bool returnContent = false,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => VariableFillDialog(
        snippet: snippet,
        returnContent: returnContent,
      ),
    );
  }

  @override
  State<VariableFillDialog> createState() => _VariableFillDialogState();
}

class _VariableFillDialogState extends State<VariableFillDialog> {
  late final Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final v in widget.snippet.variables)
        v.name: TextEditingController(text: v.defaultValue),
    };
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _resolveContent() {
    var content = widget.snippet.content;
    for (final entry in _controllers.entries) {
      content = content.replaceAll('{{${entry.key}}}', entry.value.text);
    }
    return content;
  }

  void _copyAndClose() {
    final resolved = _resolveContent();
    if (widget.returnContent) {
      Navigator.of(context).pop(resolved);
      return;
    }
    Clipboard.setData(ClipboardData(text: resolved));
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Fill Variables'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final variable in widget.snippet.variables) ...[
                TextField(
                  controller: _controllers[variable.name],
                  decoration: InputDecoration(
                    labelText: variable.name,
                    hintText: variable.description.isNotEmpty
                        ? variable.description
                        : 'Enter value for {{${variable.name}}}',
                  ),
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.outline.withAlpha(51),
                  ),
                ),
                child: Text(
                  'Preview',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(102),
                  ),
                ),
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
        FilledButton.icon(
          onPressed: _copyAndClose,
          icon: const Icon(Icons.copy, size: 18),
          label: const Text('Copy'),
        ),
      ],
    );
  }
}
