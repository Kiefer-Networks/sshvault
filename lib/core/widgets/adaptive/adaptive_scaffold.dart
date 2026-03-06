import 'package:flutter/material.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive_app_bar.dart';

/// A scaffold that builds its app bar from [title] or accepts a pre-built one.
///
/// Uses Material [Scaffold] with [AppBar] on all platforms.
class AdaptiveScaffold extends StatelessWidget {
  /// Creates a scaffold that builds its app bar from [title].
  const AdaptiveScaffold({
    super.key,
    required String this.title,
    required this.body,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.floatingActionButton,
    this.backgroundColor,
  }) : appBar = null;

  /// Creates a scaffold with a pre-built [appBar].
  const AdaptiveScaffold.withAppBar({
    super.key,
    required PreferredSizeWidget this.appBar,
    required this.body,
    this.floatingActionButton,
    this.backgroundColor,
  }) : title = null,
       actions = null,
       leading = null,
       automaticallyImplyLeading = true;

  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final resolvedAppBar =
        appBar ??
        buildAdaptiveAppBar(
          context,
          title: title!,
          actions: actions,
          leading: leading,
          automaticallyImplyLeading: automaticallyImplyLeading,
        );

    return Scaffold(
      appBar: resolvedAppBar,
      backgroundColor: backgroundColor,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
