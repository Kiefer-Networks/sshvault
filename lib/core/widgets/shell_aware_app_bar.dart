import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/routing/app_shell.dart';
import 'package:shellvault/core/utils/platform_utils.dart';

/// Builds a platform-adaptive app bar.
///
/// On iOS: Returns a [CupertinoNavigationBar] (translucent, no hamburger menu).
/// Actions are placed in [trailing].
///
/// On Android/Desktop: Returns a Material [AppBar] that shows a hamburger menu
/// icon on mobile layouts where the [AppShell] provides a [Drawer].
PreferredSizeWidget buildShellAppBar(
  BuildContext context, {
  required String title,
  List<Widget>? actions,
}) {
  if (useCupertinoDesign) {
    return CupertinoNavigationBar(
      middle: Text(title),
      trailing: actions != null && actions.isNotEmpty
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            )
          : null,
    );
  }

  final shellState = AppShell.maybeOf(context);
  final width = MediaQuery.sizeOf(context).width;
  final isMobile = width < ShellBreakpoints.mobile;

  return AppBar(
    title: Text(title),
    leading: isMobile && shellState != null
        ? IconButton(
            icon: const Icon(Icons.menu),
            onPressed: shellState.openDrawer,
          )
        : null,
    actions: actions,
  );
}
