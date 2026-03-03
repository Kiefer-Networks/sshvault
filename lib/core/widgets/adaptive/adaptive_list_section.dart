import 'package:flutter/material.dart';

/// A list section with an optional header.
class AdaptiveListSection extends StatelessWidget {
  final String? header;
  final List<Widget> children;

  const AdaptiveListSection({super.key, this.header, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              header!,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ...children,
      ],
    );
  }
}
