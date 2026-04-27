import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/services/secure_clipboard.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:sshvault/features/snippet/domain/entities/snippet_entity.dart';

class VariableFillDialog extends ConsumerStatefulWidget {
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
      builder: (context) =>
          VariableFillDialog(snippet: snippet, returnContent: returnContent),
    );
  }

  @override
  ConsumerState<VariableFillDialog> createState() => _VariableFillDialogState();
}

class _VariableFillDialogState extends ConsumerState<VariableFillDialog> {
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
    ref.read(secureClipboardProvider).copySecret(resolved);
    Navigator.of(context).pop();
    AdaptiveNotification.show(
      context,
      message: AppLocalizations.of(context)!.copiedToClipboard,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(l10n.variableFillTitle),
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
                        : l10n.variableFillHint(variable.name),
                  ),
                  keyboardType: TextInputType.text,
                ),
                Spacing.verticalMd,
              ],
              Spacing.verticalSm,
              Container(
                width: double.infinity,
                padding: Spacing.paddingAllMd,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.outline.withAlpha(
                      AppConstants.alpha51,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.variablePreviewResolved,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(
                          AppConstants.alpha102,
                        ),
                      ),
                    ),
                    Spacing.verticalSm,
                    ListenableBuilder(
                      listenable: Listenable.merge(
                        _controllers.values.toList(),
                      ),
                      builder: (context, _) => SelectableText(
                        _resolveContent(),
                        style: const TextStyle(
                          fontFamily: AppConstants.monospaceFontFamily,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
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
        FilledButton.icon(
          onPressed: _copyAndClose,
          icon: Icon(widget.returnContent ? Icons.input : Icons.copy, size: 18),
          label: Text(widget.returnContent ? l10n.variableInsert : l10n.copy),
        ),
      ],
    );
  }
}
