import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool get _isApplePlatform => Platform.isIOS || Platform.isMacOS;

/// A switch list tile that uses [CupertinoSwitch] on Apple platforms
/// and Material [SwitchListTile] elsewhere.
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
    if (_isApplePlatform) {
      return ListTile(
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
