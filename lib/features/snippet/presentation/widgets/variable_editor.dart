import 'package:flutter/material.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:shellvault/features/snippet/domain/entities/snippet_entity.dart';

class VariableEditor extends StatelessWidget {
  final List<SnippetVariableEntity> variables;
  final ValueChanged<List<SnippetVariableEntity>> onChanged;

  const VariableEditor({
    super.key,
    required this.variables,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.variableEditorTitle, style: theme.textTheme.titleSmall),
            TextButton.icon(
              onPressed: _addVariable,
              icon: const Icon(Icons.add, size: 18),
              label: Text(l10n.variableEditorAdd),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (variables.isEmpty)
          Text(
            l10n.variableEditorEmpty,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(AppConstants.alpha102),
            ),
          )
        else
          ...variables.asMap().entries.map((entry) {
            final index = entry.key;
            final variable = entry.value;
            return _VariableRow(
              key: ValueKey(variable.id.isEmpty ? index : variable.id),
              variable: variable,
              onChanged: (updated) {
                final newList = List<SnippetVariableEntity>.from(variables);
                newList[index] = updated;
                onChanged(newList);
              },
              onRemove: () {
                final newList = List<SnippetVariableEntity>.from(variables);
                newList.removeAt(index);
                onChanged(newList);
              },
            );
          }),
      ],
    );
  }

  void _addVariable() {
    final newList = List<SnippetVariableEntity>.from(variables);
    newList.add(
      SnippetVariableEntity(id: '', name: '', sortOrder: newList.length),
    );
    onChanged(newList);
  }
}

class _VariableRow extends StatelessWidget {
  final SnippetVariableEntity variable;
  final ValueChanged<SnippetVariableEntity> onChanged;
  final VoidCallback onRemove;

  const _VariableRow({
    super.key,
    required this.variable,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextFormField(
              initialValue: variable.name,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(
                  context,
                )!.variableEditorNameLabel,
                hintText: AppLocalizations.of(context)!.variableEditorNameHint,
                isDense: true,
              ),
              keyboardType: TextInputType.text,
              onChanged: (value) => onChanged(variable.copyWith(name: value)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              initialValue: variable.defaultValue,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(
                  context,
                )!.variableEditorDefaultLabel,
                hintText: AppLocalizations.of(
                  context,
                )!.variableEditorDefaultHint,
                isDense: true,
              ),
              keyboardType: TextInputType.text,
              onChanged: (value) =>
                  onChanged(variable.copyWith(defaultValue: value)),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: Icon(
              Icons.remove_circle_outline,
              size: 20,
              color: Theme.of(context).colorScheme.error,
            ),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
