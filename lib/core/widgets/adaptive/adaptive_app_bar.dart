import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool get _isApplePlatform => Platform.isIOS || Platform.isMacOS;

/// Builds a platform-adaptive app bar.
///
/// Returns a [CupertinoNavigationBar] on iOS/macOS and a Material [AppBar]
/// on all other platforms.
PreferredSizeWidget buildAdaptiveAppBar(
  BuildContext context, {
  required String title,
  List<Widget>? actions,
  Widget? leading,
  bool automaticallyImplyLeading = true,
}) {
  if (_isApplePlatform) {
    return _CupertinoAppBar(
      title: title,
      leading: leading,
      trailing: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }

  return AppBar(
    title: Text(title),
    leading: leading,
    automaticallyImplyLeading: automaticallyImplyLeading,
    actions: actions,
  );
}

class _CupertinoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? trailing;
  final bool automaticallyImplyLeading;

  const _CupertinoAppBar({
    required this.title,
    this.leading,
    this.trailing,
    this.automaticallyImplyLeading = true,
  });

  @override
  Size get preferredSize =>
      const Size.fromHeight(kMinInteractiveDimensionCupertino);

  @override
  Widget build(BuildContext context) {
    Widget? trailingWidget;
    if (trailing != null && trailing!.isNotEmpty) {
      trailingWidget = trailing!.length == 1
          ? trailing!.first
          : Row(mainAxisSize: MainAxisSize.min, children: trailing!);
    }

    return CupertinoNavigationBar(
      middle: Text(title),
      leading: leading,
      trailing: trailingWidget,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }
}
