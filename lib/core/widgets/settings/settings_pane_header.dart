import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';

/// The right-pane title for a settings category — e.g. "Security" — shown
/// once at the top of the pane's content instead of in an `AppBar`. Used by
/// every settings category screen once they became panes inside
/// `SettingsShell`'s master/detail layout rather than their own pushed,
/// separately-chromed routes (see `SettingsShell` for the surrounding
/// tree+search sidebar this pairs with).
class SettingsPaneHeader extends StatelessWidget {
  final String title;
  final List<Widget>? actions;

  const SettingsPaneHeader({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: Spacing.lg, bottom: Spacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          ...?actions,
        ],
      ),
    );
  }
}
