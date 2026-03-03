import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/utils/platform_utils.dart';

/// A platform-adaptive switch list tile.
///
/// On iOS/macOS: [CupertinoListTile] with [CNSwitch] (Liquid Glass on iOS 26+).
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
        trailing: CNSwitch(
          value: value,
          onChanged: onChanged ?? (_) {},
          enabled: onChanged != null,
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
