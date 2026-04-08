import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive_app_bar.dart';

bool get _isApplePlatform => Platform.isIOS || Platform.isMacOS;

/// A scaffold that builds its app bar from [title] or accepts a pre-built one.
///
/// Uses [CupertinoPageScaffold] on iOS/macOS and Material [Scaffold]
/// on other platforms.
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

    if (_isApplePlatform && appBar == null) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(title!),
          leading: leading,
          trailing: actions != null && actions!.isNotEmpty
              ? actions!.length == 1
                    ? actions!.first
                    : Row(mainAxisSize: MainAxisSize.min, children: actions!)
              : null,
          automaticallyImplyLeading: automaticallyImplyLeading,
        ),
        backgroundColor: backgroundColor,
        child: SafeArea(
          child: Stack(
            children: [
              body,
              if (floatingActionButton != null)
                Positioned(right: 16, bottom: 16, child: floatingActionButton!),
            ],
          ),
        ),
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
