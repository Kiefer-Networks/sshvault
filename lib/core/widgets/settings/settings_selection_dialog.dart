import 'package:flutter/material.dart';

class SelectionOption<T> {
  final T value;
  final String label;

  const SelectionOption({required this.value, required this.label});
}

Future<T?> showSettingsSelectionDialog<T>({
  required BuildContext context,
  required String title,
  required List<SelectionOption<T>> options,
  required T currentValue,
}) {
  return showDialog<T>(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        title: Text(title),
        children: [
          RadioGroup<T>(
            groupValue: currentValue,
            onChanged: (v) => Navigator.pop(ctx, v),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final option in options)
                  RadioListTile<T>(
                    title: Text(option.label),
                    value: option.value,
                  ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
