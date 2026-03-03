import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/utils/platform_utils.dart';

/// Builds a platform-adaptive app bar.
///
/// On iOS/macOS: [CupertinoNavigationBar] (translucent, no elevation).
/// On Android/Desktop: [AppBar] with optional drawer toggle.
///
/// Returns an [ObstructingPreferredSizeWidget] so it works as
/// [Scaffold.appBar] or [CupertinoPageScaffold.navigationBar].
PreferredSizeWidget buildAdaptiveAppBar(
  BuildContext context, {
  required String title,
  List<Widget>? actions,
  Widget? leading,
  bool automaticallyImplyLeading = true,
}) {
  if (useCupertinoDesign) {
    return CupertinoNavigationBar(
      middle: Text(title),
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      trailing: actions != null && actions.isNotEmpty
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            )
          : null,
      border: null,
      backgroundColor:
          CupertinoTheme.of(context).barBackgroundColor.withAlpha(230),
    );
  }

  return AppBar(
    title: Text(title),
    leading: leading,
    automaticallyImplyLeading: automaticallyImplyLeading,
    actions: actions,
  );
}
