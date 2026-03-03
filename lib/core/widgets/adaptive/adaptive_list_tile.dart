import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/utils/platform_utils.dart';

/// A platform-adaptive list tile.
///
/// On iOS/macOS: [CupertinoListTile] with chevron.
/// On Android/Desktop: [ListTile].
class AdaptiveListTile extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;

  const AdaptiveListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    if (useCupertinoDesign) {
      return CupertinoListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing ??
            (showChevron && onTap != null
                ? const CupertinoListTileChevron()
                : null),
        onTap: onTap,
      );
    }

    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
