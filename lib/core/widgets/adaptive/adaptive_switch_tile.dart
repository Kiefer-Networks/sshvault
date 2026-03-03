import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/utils/platform_utils.dart';

/// A platform-adaptive switch list tile.
///
/// On iOS/macOS: [CupertinoListTile] with [CupertinoSwitch].
/// On Android/Desktop: [SwitchListTile].
class AdaptiveSwitchTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? secondary;

  const AdaptiveSwitchTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    if (useCupertinoDesign) {
      return CupertinoListTile(
        leading: secondary,
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: CupertinoSwitch(
          value: value,
          onChanged: onChanged,
        ),
      );
    }

    return SwitchListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      value: value,
      onChanged: onChanged,
      secondary: secondary,
    );
  }
}
