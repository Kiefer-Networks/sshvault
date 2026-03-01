import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/features/settings/presentation/widgets/about_dialog.dart'
    as app;

/// Breakpoints following Material 3 Compact / Medium / Expanded.
abstract final class ShellBreakpoints {
  static const double mobile = 600;
  static const double railExtended = 1200;
}

/// Navigation items shown in Drawer and NavigationRail.
class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

const _navItems = <_NavItem>[
  _NavItem(
    icon: Icons.dns_outlined,
    selectedIcon: Icons.dns,
    label: 'Hosts',
  ),
  _NavItem(
    icon: Icons.code_outlined,
    selectedIcon: Icons.code,
    label: 'Snippets',
  ),
  _NavItem(
    icon: Icons.folder_outlined,
    selectedIcon: Icons.folder,
    label: 'Groups',
  ),
  _NavItem(
    icon: Icons.label_outline,
    selectedIcon: Icons.label,
    label: 'Tags',
  ),
  _NavItem(
    icon: Icons.vpn_key_outlined,
    selectedIcon: Icons.vpn_key,
    label: 'SSH Keys',
  ),
  _NavItem(
    icon: Icons.import_export_outlined,
    selectedIcon: Icons.import_export,
    label: 'Export / Import',
  ),
];

/// The root shell widget used by [StatefulShellRoute].
///
/// Renders a [Drawer] on mobile (< 600 dp) and a [NavigationRail] on
/// tablet / desktop (>= 600 dp).  The rail extends its labels at >= 1200 dp.
///
/// Branch screens can open the drawer via [AppShell.maybeOf(context)].
class AppShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  /// Allows branch screens to access the shell scaffold (e.g. to open the
  /// drawer on mobile).
  static AppShellState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<AppShellState>();
  }

  @override
  State<AppShell> createState() => AppShellState();
}

class AppShellState extends State<AppShell> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() => scaffoldKey.currentState?.openDrawer();

  void _onDestinationSelected(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width < ShellBreakpoints.mobile) {
          return _MobileScaffold(
            scaffoldKey: scaffoldKey,
            currentIndex: widget.navigationShell.currentIndex,
            onDestinationSelected: _onDestinationSelected,
            child: widget.navigationShell,
          );
        }

        return _DesktopScaffold(
          currentIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: _onDestinationSelected,
          extended: width >= ShellBreakpoints.railExtended,
          child: widget.navigationShell,
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Mobile: Scaffold with Drawer
// ---------------------------------------------------------------------------

class _MobileScaffold extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  const _MobileScaffold({
    required this.scaffoldKey,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: _AppDrawer(
        currentIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
      ),
      body: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Desktop: Row with NavigationRail + content
// ---------------------------------------------------------------------------

class _DesktopScaffold extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool extended;
  final Widget child;

  const _DesktopScaffold({
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.extended,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
            extended: extended,
            leading: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: extended ? 16 : 0,
              ),
              child: extended
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'ShellVault',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : Icon(
                      Icons.shield_outlined,
                      color: theme.colorScheme.primary,
                    ),
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.settings_outlined),
                        tooltip: 'Settings',
                        onPressed: () => context.push('/settings'),
                      ),
                      const SizedBox(height: 4),
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: 'About',
                        onPressed: () =>
                            app.showAppAboutDialog(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            destinations: [
              for (final item in _navItems)
                NavigationRailDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon),
                  label: Text(item.label),
                ),
            ],
          ),
          VerticalDivider(
            thickness: 1,
            width: 1,
            color: theme.dividerTheme.color,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Drawer (mobile only)
// ---------------------------------------------------------------------------

class _AppDrawer extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const _AppDrawer({
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Branding header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'ShellVault',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(indent: 16, endIndent: 16),
            const SizedBox(height: 8),

            // Nav items
            for (var i = 0; i < _navItems.length; i++)
              _DrawerItem(
                icon: _navItems[i].icon,
                selectedIcon: _navItems[i].selectedIcon,
                label: _navItems[i].label,
                selected: i == currentIndex,
                onTap: () {
                  Navigator.pop(context); // close drawer
                  onDestinationSelected(i);
                },
              ),

            const Spacer(),

            const Divider(indent: 16, endIndent: 16),
            _DrawerItem(
              icon: Icons.settings_outlined,
              selectedIcon: Icons.settings,
              label: 'Settings',
              selected: false,
              onTap: () {
                Navigator.pop(context);
                context.push('/settings');
              },
            ),
            _DrawerItem(
              icon: Icons.info_outline,
              selectedIcon: Icons.info,
              label: 'About',
              selected: false,
              onTap: () {
                Navigator.pop(context);
                app.showAppAboutDialog(context);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        selected ? theme.colorScheme.primary : theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        leading: Icon(selected ? selectedIcon : icon, color: color),
        title: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: selected,
        selectedTileColor: theme.colorScheme.primary.withAlpha(26),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onTap,
      ),
    );
  }
}
