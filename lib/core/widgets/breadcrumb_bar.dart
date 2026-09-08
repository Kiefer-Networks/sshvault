import 'package:flutter/material.dart';

/// One segment of a [BreadcrumbBar]. The last segment in a list is always
/// rendered as plain (non-tappable) text — it's "you are here" — earlier
/// segments are tappable when [onTap] is given.
class BreadcrumbSegment {
  final String label;
  final VoidCallback? onTap;

  const BreadcrumbSegment(this.label, {this.onTap});
}

/// A thin "Hosts / prod-db-01 / Edit"-style trail shown above a nested
/// desktop screen's content, modeled on VS Code's clickable breadcrumb bar.
/// Desktop-only by design — see call sites in `AdaptiveScaffold`.
class BreadcrumbBar extends StatelessWidget {
  final List<BreadcrumbSegment> segments;

  const BreadcrumbBar({super.key, required this.segments});

  @override
  Widget build(BuildContext context) {
    if (segments.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final onSurfaceVariant = theme.colorScheme.onSurfaceVariant;

    final children = <Widget>[];
    for (var i = 0; i < segments.length; i++) {
      if (i > 0) {
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(Icons.chevron_right, size: 14, color: onSurfaceVariant),
          ),
        );
      }

      final segment = segments[i];
      final isLast = i == segments.length - 1;
      final style = TextStyle(
        fontSize: 12.5,
        fontWeight: isLast ? FontWeight.w600 : FontWeight.w400,
        color: isLast ? theme.colorScheme.onSurface : onSurfaceVariant,
      );

      if (segment.onTap == null || isLast) {
        children.add(
          Text(segment.label, style: style, overflow: TextOverflow.ellipsis),
        );
      } else {
        children.add(
          InkWell(
            onTap: segment.onTap,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
              child: Text(segment.label, style: style),
            ),
          ),
        );
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: children,
      ),
    );
  }
}
