import 'dart:async';

import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/routing/ios_more_screen.dart';
import 'package:shellvault/core/utils/platform_utils.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/core/routing/shell_navigation_provider.dart';
import 'package:shellvault/core/services/terminal_notification_service.dart';
import 'package:shellvault/features/account/presentation/providers/account_providers.dart';
import 'package:shellvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:shellvault/features/settings/presentation/widgets/about_dialog.dart'
    as app;
import 'package:shellvault/features/sync/presentation/providers/sync_providers.dart';
import 'package:shellvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:shellvault/features/terminal/presentation/providers/terminal_providers.dart';

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

/// Section break indices — dividers appear *before* items at these indices.
/// Used by drawer and rail to visually group navigation items.
const _sectionBreaks = {3, 6}; // before SSH Keys, before Export/Import

/// Base nav items (indices 0–6). Terminal (index 7) is appended dynamically
/// only when there are active sessions.
///
/// Order: Hosts, SFTP, Snippets | SSH Keys, Groups, Tags | Export/Import
List<_NavItem> _buildBaseNavItems(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return <_NavItem>[
    // — Main features —
    _NavItem(
      icon: Icons.dns_outlined,
      selectedIcon: Icons.dns,
      label: l10n.navHosts,
    ),
    _NavItem(
      icon: Icons.folder_copy_outlined,
      selectedIcon: Icons.folder_copy,
      label: l10n.navSftp,
    ),
    _NavItem(
      icon: Icons.code_outlined,
      selectedIcon: Icons.code,
      label: l10n.navSnippets,
    ),
    // — Management —
    _NavItem(
      icon: Icons.vpn_key_outlined,
      selectedIcon: Icons.vpn_key,
      label: l10n.navSshKeys,
    ),
    _NavItem(
      icon: Icons.folder_outlined,
      selectedIcon: Icons.folder,
      label: l10n.navGroups,
    ),
    _NavItem(
      icon: Icons.label_outline,
      selectedIcon: Icons.label,
      label: l10n.navTags,
    ),
    // — Data —
    _NavItem(
      icon: Icons.import_export_outlined,
      selectedIcon: Icons.import_export,
      label: l10n.navExportImport,
    ),
  ];
}

_NavItem _buildTerminalNavItem(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return _NavItem(
    icon: Icons.terminal_outlined,
    selectedIcon: Icons.terminal,
    label: l10n.navTerminal,
  );
}

/// The root shell widget used by [StatefulShellRoute].
///
/// Renders a [Drawer] on mobile (< 600 dp) and a [NavigationRail] on
/// tablet / desktop (>= 600 dp).  The rail extends its labels at >= 1200 dp.
///
/// Branch screens can open the drawer via [AppShell.maybeOf(context)].
class AppShell extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  /// Allows branch screens to access the shell scaffold (e.g. to open the
  /// drawer on mobile).
  static AppShellState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<AppShellState>();
  }

  @override
  ConsumerState<AppShell> createState() => AppShellState();
}

class AppShellState extends ConsumerState<AppShell> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool _securityDialogShown = false;
  late final AppLifecycleListener _lifecycleListener;
  Timer? _billingRefreshTimer;

  /// How often to re-check billing status from the server.
  static const _billingRefreshInterval = Duration(minutes: 15);

  void openDrawer() => scaffoldKey.currentState?.openDrawer();

  @override
  void initState() {
    super.initState();

    // Refresh billing/device providers on app resume (e.g. returning from
    // browser after subscription purchase, or after extended background).
    _lifecycleListener = AppLifecycleListener(
      onResume: _refreshAccountProviders,
    );

    // Periodic billing refresh so an expired subscription is reflected
    // even if the user never leaves/returns to the app.
    _billingRefreshTimer = Timer.periodic(_billingRefreshInterval, (_) {
      _refreshAccountProviders();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(shellNavigationProvider.notifier).state =
            widget.navigationShell;

        // Navigate to terminal when the notification is tapped
        TerminalNotificationService.onNotificationTapped = () {
          ref
              .read(shellNavigationProvider)
              ?.goBranch(AppConstants.terminalBranchIndex);
        };

        // Update notification when terminal sessions change
        ref.listenManual(sessionManagerProvider, (_, next) {
          _updateSessionNotification(next);
        });

        // Listen for settings to load, then show security dialog if needed
        ref.listenManual(settingsProvider, (_, next) {
          final settings = next.value;
          if (settings == null || _securityDialogShown) return;
          if (!settings.hasAnyLock && !settings.dismissedSecurityHint) {
            _securityDialogShown = true;
            _showSecurityDialog();
          }
        }, fireImmediately: true);
      }
    });
  }

  void _refreshAccountProviders() {
    final auth = ref.read(authProvider).value;
    if (auth != AuthStatus.authenticated) return;
    ref.invalidate(billingStatusProvider);
    ref.invalidate(deviceListProvider);
  }

  void _updateSessionNotification(List<SshSessionEntity> sessions) {
    final service = ref.read(terminalNotificationProvider);
    final active = sessions
        .where(
          (s) =>
              s.status == SshConnectionStatus.connected ||
              s.status == SshConnectionStatus.connecting ||
              s.status == SshConnectionStatus.authenticating,
        )
        .toList();

    if (active.isEmpty) {
      service.dismiss();
      return;
    }

    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;

    service.show(
      title: l10n.notificationTerminalTitle(active.length),
      body: active.map((s) => s.title).join(', '),
    );
  }

  @override
  void dispose() {
    _billingRefreshTimer?.cancel();
    _lifecycleListener.dispose();
    TerminalNotificationService.onNotificationTapped = null;
    ref.read(terminalNotificationProvider).dismiss();
    super.dispose();
  }

  Future<void> _showSecurityDialog() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ref.read(settingsProvider.notifier).setDismissedSecurityHint(true);
    final goToSettings = await showAdaptiveConfirmDialog(
      context,
      title: l10n.settingsSectionSecurity,
      message: l10n.securityBannerMessage,
      cancelLabel: l10n.securityBannerDismiss,
      confirmLabel: l10n.navSettings,
    );
    if (goToSettings == true && mounted) {
      context.push('/settings');
    }
  }

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(shellNavigationProvider.notifier).state =
            widget.navigationShell;
      }
    });
  }

  void _onDestinationSelected(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionCount = ref.watch(sessionManagerProvider).length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (isCupertinoMobile && width < ShellBreakpoints.mobile) {
          return _CupertinoMobileScaffold(
            currentIndex: widget.navigationShell.currentIndex,
            onDestinationSelected: _onDestinationSelected,
            sessionCount: sessionCount,
            child: widget.navigationShell,
          );
        }

        if (width < ShellBreakpoints.mobile) {
          return _MobileScaffold(
            scaffoldKey: scaffoldKey,
            currentIndex: widget.navigationShell.currentIndex,
            onDestinationSelected: _onDestinationSelected,
            sessionCount: sessionCount,
            child: widget.navigationShell,
          );
        }

        return _DesktopScaffold(
          currentIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: _onDestinationSelected,
          extended: width >= ShellBreakpoints.railExtended,
          sessionCount: sessionCount,
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
  final int sessionCount;
  final Widget child;

  const _MobileScaffold({
    required this.scaffoldKey,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.sessionCount,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: _AppDrawer(
        currentIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
        sessionCount: sessionCount,
      ),
      body: child,
    );
  }
}

// ---------------------------------------------------------------------------
// iOS Mobile: CupertinoTabBar with 5 tabs
// ---------------------------------------------------------------------------

/// Maps GoRouter branch index → iOS tab index.
///
/// Branches 0-2 map to tabs 0-2 (Hosts, SFTP, Snippets).
/// Branch 7 (Terminal) maps to tab 3.
/// Branches 3-6 (SSH Keys, Groups, Tags, Export/Import) map to tab 4 (More).
int _branchToTab(int branchIndex) {
  if (branchIndex <= 2) return branchIndex;
  if (branchIndex == 7) return 3;
  return 4; // branches 3–6 → More
}

/// Maps iOS tab index → GoRouter branch index (for primary tabs only).
int _tabToBranch(int tabIndex) {
  if (tabIndex <= 2) return tabIndex;
  if (tabIndex == 3) return 7; // Terminal
  return -1; // More — not a branch
}

final _showMoreProvider = StateProvider.autoDispose<bool>((_) => false);

class _CupertinoMobileScaffold extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final int sessionCount;
  final Widget child;

  const _CupertinoMobileScaffold({
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.sessionCount,
    required this.child,
  });

  int _currentTab(bool showMore) {
    if (showMore) return 4;
    return _branchToTab(currentIndex);
  }

  void _onTabTapped(WidgetRef ref, int tabIndex) {
    if (tabIndex == 4) {
      ref.read(_showMoreProvider.notifier).state = true;
      return;
    }
    ref.read(_showMoreProvider.notifier).state = false;
    final branchIndex = _tabToBranch(tabIndex);
    if (branchIndex >= 0) {
      onDestinationSelected(branchIndex);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final showMore = ref.watch(_showMoreProvider);

    final content = showMore
        ? IosMoreScreen(
            onBranchSelected: (branchIndex) {
              ref.read(_showMoreProvider.notifier).state = false;
              onDestinationSelected(branchIndex);
            },
          )
        : child;

    return ColoredBox(
      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Expanded(child: content),
          CNTabBar(
            currentIndex: _currentTab(showMore),
            onTap: (index) => _onTabTapped(ref, index),
            items: [
              CNTabBarItem(
                icon: const CNSymbol('desktopcomputer'),
                activeIcon: const CNSymbol('desktopcomputer'),
                label: l10n.navHosts,
              ),
              CNTabBarItem(
                icon: const CNSymbol('folder'),
                activeIcon: const CNSymbol('folder.fill'),
                label: l10n.navSftp,
              ),
              CNTabBarItem(
                icon: const CNSymbol('chevron.left.forwardslash.chevron.right'),
                label: l10n.navSnippets,
              ),
              CNTabBarItem(
                icon: const CNSymbol('terminal'),
                activeIcon: const CNSymbol('terminal.fill'),
                badge: sessionCount > 0 ? '$sessionCount' : null,
                label: l10n.navTerminal,
              ),
              CNTabBarItem(
                icon: const CNSymbol('ellipsis.circle'),
                activeIcon: const CNSymbol('ellipsis.circle.fill'),
                label: l10n.navMore,
              ),
            ],
          ),
        ],
      ),
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
  final int sessionCount;
  final Widget child;

  const _DesktopScaffold({
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.extended,
    required this.sessionCount,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final showTerminal = sessionCount > 0;

    // Build visible nav items — Terminal only when sessions exist
    final visibleItems = [
      ..._buildBaseNavItems(context),
      if (showTerminal) _buildTerminalNavItem(context),
    ];

    // Clamp selectedIndex if Terminal is hidden but was selected
    final clampedIndex = currentIndex < visibleItems.length ? currentIndex : 0;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: clampedIndex,
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
                          l10n.appName,
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
                      _SyncRailButton(),
                      const SizedBox(height: 4),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined),
                        tooltip: l10n.navSettings,
                        onPressed: () => context.push('/settings'),
                      ),
                      const SizedBox(height: 4),
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: l10n.navAbout,
                        onPressed: () => app.showAppAboutDialog(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            destinations: [
              for (var i = 0; i < visibleItems.length; i++)
                NavigationRailDestination(
                  padding: _sectionBreaks.contains(i)
                      ? const EdgeInsets.only(top: 12)
                      : EdgeInsets.zero,
                  icon: showTerminal && i == visibleItems.length - 1
                      ? Badge(
                          label: Text('$sessionCount'),
                          child: Icon(visibleItems[i].icon),
                        )
                      : Icon(visibleItems[i].icon),
                  selectedIcon: showTerminal && i == visibleItems.length - 1
                      ? Badge(
                          label: Text('$sessionCount'),
                          child: Icon(visibleItems[i].selectedIcon),
                        )
                      : Icon(visibleItems[i].selectedIcon),
                  label: Text(visibleItems[i].label),
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

class _SyncStatusIcon extends ConsumerWidget {
  const _SyncStatusIcon();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState.value == AuthStatus.authenticated;
    if (!isAuthenticated) return const SizedBox.shrink();

    final syncState = ref.watch(syncProvider);
    final billingActive =
        ref.watch(billingStatusProvider).value?.active ?? false;
    final isSyncing = syncState.value == SyncStatus.syncing;
    final hasError = syncState.hasError;

    final IconData icon;
    final Color color;
    if (isSyncing) {
      return const Padding(
        padding: EdgeInsets.only(left: 8),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    } else if (hasError) {
      icon = Icons.cloud_off;
      color = Theme.of(context).colorScheme.error;
    } else if (billingActive && syncState.value == SyncStatus.success) {
      icon = Icons.cloud_done_outlined;
      color = Theme.of(context).colorScheme.primary;
    } else {
      icon = Icons.cloud_outlined;
      color = Theme.of(context).colorScheme.onSurfaceVariant;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Icon(icon, size: 20, color: color),
    );
  }
}

class _SyncRailButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState.value == AuthStatus.authenticated;
    final syncState = ref.watch(syncProvider);
    final billingActive =
        ref.watch(billingStatusProvider).value?.active ?? false;
    final isSyncing = syncState.value == SyncStatus.syncing;
    final hasError = syncState.hasError;

    final IconData icon;
    final Color? color;
    if (!isAuthenticated) {
      icon = Icons.cloud_off_outlined;
      color = null;
    } else if (hasError) {
      icon = Icons.cloud_off;
      color = Theme.of(context).colorScheme.error;
    } else if (billingActive && syncState.value == SyncStatus.success) {
      icon = Icons.cloud_done_outlined;
      color = null;
    } else {
      icon = Icons.cloud_outlined;
      color = null;
    }

    return IconButton(
      icon: isSyncing
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icon, color: color),
      tooltip: l10n.settingsSectionSync,
      onPressed: () {
        if (isAuthenticated) {
          context.push('/sync-settings');
        } else {
          context.push('/login');
        }
      },
    );
  }
}

class _AppDrawer extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final int sessionCount;

  const _AppDrawer({
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.sessionCount,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final showTerminal = sessionCount > 0;

    // Build visible nav items — Terminal only when sessions exist
    final visibleItems = [
      ..._buildBaseNavItems(context),
      if (showTerminal) _buildTerminalNavItem(context),
    ];

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
                    l10n.appName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const _SyncStatusIcon(),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(indent: 16, endIndent: 16),
            const SizedBox(height: 8),

            // Nav items with section dividers
            for (var i = 0; i < visibleItems.length; i++) ...[
              if (_sectionBreaks.contains(i))
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Divider(indent: 28, endIndent: 28, height: 1),
                ),
              _DrawerItem(
                icon: visibleItems[i].icon,
                selectedIcon: visibleItems[i].selectedIcon,
                label: visibleItems[i].label,
                selected: i == currentIndex,
                badge: showTerminal && i == visibleItems.length - 1
                    ? sessionCount
                    : null,
                onTap: () {
                  Navigator.pop(context); // close drawer
                  onDestinationSelected(i);
                },
              ),
            ],

            const Spacer(),

            const Divider(indent: 16, endIndent: 16),
            _SyncDrawerItem(),
            _DrawerItem(
              icon: Icons.settings_outlined,
              selectedIcon: Icons.settings,
              label: l10n.navSettings,
              selected: false,
              onTap: () {
                Navigator.pop(context);
                context.push('/settings');
              },
            ),
            _DrawerItem(
              icon: Icons.info_outline,
              selectedIcon: Icons.info,
              label: l10n.navAbout,
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

class _SyncDrawerItem extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState.value == AuthStatus.authenticated;
    final syncState = ref.watch(syncProvider);
    final billingActive =
        ref.watch(billingStatusProvider).value?.active ?? false;
    final isSyncing = syncState.value == SyncStatus.syncing;
    final hasError = syncState.hasError;

    final IconData icon;
    if (!isAuthenticated) {
      icon = Icons.cloud_off_outlined;
    } else if (isSyncing) {
      icon = Icons.cloud_sync_outlined;
    } else if (hasError) {
      icon = Icons.cloud_off;
    } else if (billingActive && syncState.value == SyncStatus.success) {
      icon = Icons.cloud_done_outlined;
    } else {
      icon = Icons.cloud_outlined;
    }

    final subtitle = !isAuthenticated
        ? l10n.settingsSyncNotLoggedIn
        : isSyncing
        ? l10n.syncSyncing
        : hasError
        ? l10n.syncError
        : billingActive
        ? l10n.syncSuccess
        : l10n.accountPaymentInactive;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        leading: Icon(icon),
        title: Text(l10n.settingsSectionSync),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: () {
          Navigator.pop(context);
          if (isAuthenticated) {
            context.push('/sync-settings');
          } else {
            context.push('/login');
          }
        },
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final int? badge;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface;

    Widget iconWidget = Icon(selected ? selectedIcon : icon, color: color);
    if (badge != null) {
      iconWidget = Badge(label: Text('$badge'), child: iconWidget);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        leading: iconWidget,
        title: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: selected,
        selectedTileColor: theme.colorScheme.primary.withAlpha(
          AppConstants.alpha26,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onTap,
      ),
    );
  }
}
