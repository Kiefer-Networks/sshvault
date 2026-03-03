import 'package:flutter/material.dart';

class SettingsSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  const SettingsSearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SearchBar(
      controller: controller,
      hintText: hintText,
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStatePropertyAll(colorScheme.surfaceContainerHigh),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
      ),
      onChanged: onChanged,
    );
  }
}
