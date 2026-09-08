import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/core/routing/app_shell.dart' show ShellBreakpoints;
import 'package:sshvault/core/widgets/settings/settings.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

/// One entry in the settings category tree — mirrors what the old
/// `SettingsHubScreen` list used to link to, just as a sidebar row instead
/// of a full-width tappable card.
///
/// No per-category color: every icon renders in the same neutral tone and
/// only picks up the accent color on selection/focus, matching the rail's
/// own `_DeckRailIcon` and the command palette's `_PaletteRow` — a rainbow
/// of unrelated per-row hues was exactly the "doesn't match the rest of
/// the shell" mismatch this replaced.
class _SettingsCategory {
  final String path;
  final IconData icon;
  final String Function(AppLocalizations) label;
  final String Function(AppLocalizations) subtitle;

  const _SettingsCategory({
    required this.path,
    required this.icon,
    required this.label,
    required this.subtitle,
  });
}

final _categories = <_SettingsCategory>[
  _SettingsCategory(
    path: '/settings/account',
    icon: Icons.account_circle_outlined,
    label: (l10n) => l10n.settingsAccountAndSync,
    subtitle: (l10n) => l10n.settingsAccountSubtitleUnauth,
  ),
  _SettingsCategory(
    path: '/settings/appearance',
    icon: Icons.palette_outlined,
    label: (l10n) => l10n.settingsSectionAppearance,
    subtitle: (l10n) => l10n.settingsAppearanceSubtitle,
  ),
  _SettingsCategory(
    path: '/settings/ssh',
    icon: Icons.terminal,
    label: (l10n) => l10n.settingsSectionSshDefaults,
    subtitle: (l10n) => l10n.settingsSshSubtitle,
  ),
  _SettingsCategory(
    path: '/settings/security',
    icon: Icons.security,
    label: (l10n) => l10n.settingsSectionSecurity,
    subtitle: (l10n) => l10n.settingsSecuritySubtitle,
  ),
  _SettingsCategory(
    path: '/settings/network',
    icon: Icons.dns_outlined,
    label: (l10n) => l10n.settingsSectionNetwork,
    subtitle: (l10n) => l10n.settingsNetworkSubtitle,
  ),
  _SettingsCategory(
    path: '/settings/known-hosts',
    icon: Icons.fingerprint,
    label: (l10n) => l10n.knownHostsTitle,
    subtitle: (l10n) => l10n.knownHostsSubtitle,
  ),
  _SettingsCategory(
    path: '/settings/export',
    icon: Icons.import_export,
    label: (l10n) => l10n.settingsSectionExport,
    subtitle: (l10n) => l10n.settingsExportBackupSubtitle,
  ),
  _SettingsCategory(
    path: '/settings/about',
    icon: Icons.info_outline,
    label: (l10n) => l10n.settingsSectionAbout,
    subtitle: (l10n) => l10n.settingsAboutSubtitle,
  ),
];

/// Master/detail settings shell — a persistent, searchable category tree on
/// the left (styled after VS Code / Zed / Claude's own settings screens)
/// and the selected category's content on the right. Wraps every
/// `/settings/*` category route as a nested `ShellRoute` inside the app's
/// own outer shell (see `app_router.dart`), so the app's main rail *and*
/// this settings tree are both visible at once — selecting a category
/// swaps only the right pane, it never re-navigates away from Settings.
///
/// Desktop/wide-window only: below [ShellBreakpoints.mobile] this renders
/// just [child] full-width, same as before this shell existed — there is
/// no room for a persistent tree on a phone, and mobile navigates between
/// categories via [SettingsOverviewPane] (bare `/settings`) instead, the
/// same way it always has.
class SettingsShell extends StatelessWidget {
  final String location;
  final Widget child;

  const SettingsShell({super.key, required this.location, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < ShellBreakpoints.mobile) {
          return child;
        }
        return Row(
          children: [
            SizedBox(
              width: 260,
              child: _CategoryTree(currentLocation: location),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: theme.colorScheme.outlineVariant,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Content for bare `/settings`: a plain tappable list of every category,
/// using the exact same catalog as the tree. This is the *only* way to
/// reach a category on mobile (no persistent tree there — see
/// [SettingsShell]); on desktop it's just what shows in the right pane
/// before a category has been picked.
class SettingsOverviewPane extends StatelessWidget {
  const SettingsOverviewPane({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: Spacing.paddingHorizontalLgVerticalSm,
      children: [
        SettingsPaneHeader(title: l10n.settingsTitle),
        SettingsGroupCard(
          children: [
            for (final category in _categories)
              SettingsCategoryTile(
                icon: category.icon,
                title: category.label(l10n),
                subtitle: category.subtitle(l10n),
                onTap: () => context.go(category.path),
              ),
          ],
        ),
        Spacing.verticalLg,
      ],
    );
  }
}

class _CategoryTree extends StatefulWidget {
  final String currentLocation;

  const _CategoryTree({required this.currentLocation});

  @override
  State<_CategoryTree> createState() => _CategoryTreeState();
}

class _CategoryTreeState extends State<_CategoryTree> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final query = _query.trim().toLowerCase();

    final visible = query.isEmpty
        ? _categories
        : _categories
              .where(
                (c) =>
                    c.label(l10n).toLowerCase().contains(query) ||
                    c.subtitle(l10n).toLowerCase().contains(query),
              )
              .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Spacing.md,
            Spacing.md,
            Spacing.md,
            Spacing.sm,
          ),
          child: SizedBox(
            height: 36,
            child: TextField(
              controller: _searchController,
              // The settings tree has no other obvious keyboard entry
              // point on open (unlike the command palette, which
              // autofocuses its own search field for the same reason) —
              // without this, Tab from nowhere is the only way in.
              autofocus: true,
              onChanged: (v) => setState(() => _query = v),
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                isDense: true,
                hintText: l10n.settingsSearchHint,
                prefixIcon: const Icon(Icons.search, size: 18),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        Expanded(
          child: visible.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(Spacing.lg),
                  child: Text(
                    l10n.settingsSearchNoResults,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.xxs,
                  ),
                  children: [
                    for (final category in visible)
                      _CategoryRow(
                        category: category,
                        selected: widget.currentLocation == category.path,
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final _SettingsCategory category;
  final bool selected;

  const _CategoryRow({required this.category, required this.selected});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: SettingsRow(
        icon: category.icon,
        title: Text(
          category.label(l10n),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        selected: selected,
        // Always set, even on the already-selected row: a disabled onTap
        // makes InkWell skip keyboard focus entirely, which would make
        // Tab/j/k jump over the active category instead of landing on it.
        // Re-navigating to the same route is a harmless no-op.
        onTap: () => context.go(category.path),
      ),
    );
  }
}
