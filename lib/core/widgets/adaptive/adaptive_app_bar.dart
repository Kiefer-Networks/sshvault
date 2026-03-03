import 'package:flutter/material.dart';

/// Builds a Material [AppBar].
PreferredSizeWidget buildAdaptiveAppBar(
  BuildContext context, {
  required String title,
  List<Widget>? actions,
  Widget? leading,
  bool automaticallyImplyLeading = true,
}) {
  return AppBar(
    title: Text(title),
    leading: leading,
    automaticallyImplyLeading: automaticallyImplyLeading,
    actions: actions,
  );
}
