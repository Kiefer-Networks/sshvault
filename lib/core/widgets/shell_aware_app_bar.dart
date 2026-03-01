import 'package:flutter/material.dart';
import 'package:shellvault/core/routing/app_shell.dart';

/// Builds an [AppBar] that automatically shows a hamburger menu icon on mobile
/// layouts where the [AppShell] provides a [Drawer].
///
/// On desktop (NavigationRail visible) the leading icon is omitted so the
/// default back-button behaviour applies for detail routes.
AppBar buildShellAppBar(
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
