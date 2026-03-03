import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/utils/platform_utils.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive_app_bar.dart';

/// A platform-adaptive scaffold.
///
/// On iOS/macOS: renders [CupertinoPageScaffold] with [CupertinoNavigationBar].
/// On Android/Linux/Windows: renders Material [Scaffold] with [AppBar].
///
/// Use the default constructor when a simple title-based app bar suffices.
/// Use [AdaptiveScaffold.withAppBar] when passing a pre-built app bar
/// (e.g. from [buildShellAppBar] or custom platform logic).
class AdaptiveScaffold extends StatelessWidget {
  /// Creates an adaptive scaffold that builds its app bar from [title].
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

  /// Creates an adaptive scaffold with a pre-built [appBar].
  ///
  /// On Cupertino the [appBar] must be an [ObstructingPreferredSizeWidget]
  /// (e.g. [CupertinoNavigationBar]).
  const AdaptiveScaffold.withAppBar({
    super.key,
    required PreferredSizeWidget this.appBar,
    required this.body,
    this.floatingActionButton,
    this.backgroundColor,
  })  : title = null,
        actions = null,
        leading = null,
        automaticallyImplyLeading = true;

  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? appBar;
  final Widget body;

  /// Only rendered on Material platforms; ignored on Cupertino.
  final Widget? floatingActionButton;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final resolvedAppBar = appBar ??
        buildAdaptiveAppBar(
          context,
          title: title!,
          actions: actions,
          leading: leading,
          automaticallyImplyLeading: automaticallyImplyLeading,
        );

    if (useCupertinoDesign) {
      return CupertinoPageScaffold(
        navigationBar: resolvedAppBar as ObstructingPreferredSizeWidget,
        backgroundColor: backgroundColor,
        child: body,
      );
    }

    return Scaffold(
      appBar: resolvedAppBar,
      backgroundColor: backgroundColor,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
