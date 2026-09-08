import 'package:flutter/material.dart';

/// Groups related [SettingsTile]/[SettingsSwitchTile] rows into one card.
///
/// Renders via the ambient `CardTheme` with no overrides of its own — on
/// desktop this picks up `AppTheme.buildCommandDeck()`'s flat, bordered
/// card style (`surfaceContainerLow` + an outline, no shadow). An earlier
/// version pinned its own `shape`/`elevation`/`color` here, which silently
/// discarded that theme's border on every settings screen — the one
/// visible difference between a "Command Deck" card and a plain Material
/// one.
class SettingsGroupCard extends StatelessWidget {
  final List<Widget> children;

  const SettingsGroupCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}
