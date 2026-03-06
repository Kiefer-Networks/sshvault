import 'package:flutter/material.dart';
import 'package:sshvault/core/routing/app_shell.dart';

/// Builds a Material [AppBar] that shows a hamburger menu icon on mobile
/// layouts where the [AppShell] provides a [Drawer].
PreferredSizeWidget buildShellAppBar(
  BuildContext context, {
  required String title,
  List<Widget>? actions,
}) {
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
