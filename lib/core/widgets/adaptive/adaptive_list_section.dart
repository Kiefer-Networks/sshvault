import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/utils/platform_utils.dart';

/// A platform-adaptive list section.
///
/// On iOS/macOS: [CupertinoListSection.insetGrouped] with header.
/// On Android/Desktop: [Column] with section header and children.
class AdaptiveListSection extends StatelessWidget {
  final String? header;
  final List<Widget> children;

  const AdaptiveListSection({super.key, this.header, required this.children});

  @override
  Widget build(BuildContext context) {
    if (useCupertinoDesign) {
      return CupertinoListSection.insetGrouped(
        header: header != null ? Text(header!) : null,
        children: children,
      );
    }

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
