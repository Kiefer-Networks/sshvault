import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/core/routing/shell_navigation_provider.dart';
import 'package:shellvault/core/services/terminal_notification_service.dart';
import 'package:shellvault/features/account/presentation/providers/account_providers.dart';
import 'package:shellvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';
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
const _baseSectionBreaks = {3}; // before SSH Keys

/// Builds the visible nav items based on auth state and session count.
/// Returns the items list and the set of section break indices.
({List<_NavItem> items, Set<int> breaks}) _buildVisibleNavItems(
  BuildContext context, {
  required bool showTerminal,
  required int sessionCount,
}) {
  final l10n = AppLocalizations.of(context)!;
  final items = <_NavItem>[
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
      label: l10n.navFolders,
    ),
    _NavItem(
      icon: Icons.label_outline,
      selectedIcon: Icons.label,
      label: l10n.navTags,
    ),
  ];

  final breaks = <int>{..._baseSectionBreaks};

  // — Terminal (only when sessions exist) —
  if (showTerminal) {
    items.add(
      _NavItem(
        icon: Icons.terminal_outlined,
        selectedIcon: Icons.terminal,
        label: l10n.navTerminal,
      ),
    );
  }

  return (items: items, breaks: breaks);
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
  TerminalNotificationService? _notificationService;

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

        _notificationService = ref.read(terminalNotificationProvider);

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

        // Auto-recovery: when server comes back online, refresh account
        // data and trigger sync if auto-sync is enabled.
        ref.listenManual(serverReachableProvider, (prev, next) {
          final wasFalse = prev?.value == false;
          final isTrue = next.value == true;
          if (wasFalse && isTrue) {
            _refreshAccountProviders();
            final settings = ref.read(settingsProvider).value;
            if (settings?.autoSync ?? false) {
              ref.read(syncProvider.notifier).sync();
            }
          }
        });
      }
    });
  }

  void _refreshAccountProviders() {
    final auth = ref.read(authProvider).value;
    if (auth != AuthStatus.authenticated) return;
    ref.invalidate(userProfileProvider);
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
    _notificationService?.dismiss();
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

    final (:items, :breaks) = _buildVisibleNavItems(
      context,
      showTerminal: showTerminal,
      sessionCount: sessionCount,
    );

    // Clamp selectedIndex if a dynamic item is hidden but was selected
    final clampedIndex = currentIndex < items.length ? currentIndex : 0;

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
                        Image.asset(
                          'assets/images/app_icon.png',
                          width: 24,
                          height: 24,
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
                  : Image.asset(
                      'assets/images/app_icon.png',
                      width: 24,
                      height: 24,
                    ),
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _SettingsRailButton(),
                ),
              ),
            ),
            destinations: [
              for (var i = 0; i < items.length; i++)
                NavigationRailDestination(
                  padding: breaks.contains(i)
                      ? const EdgeInsets.only(top: 12)
                      : EdgeInsets.zero,
                  icon: showTerminal && i == items.length - 1
                      ? Badge(
                          label: Text('$sessionCount'),
                          child: Icon(items[i].icon),
                        )
                      : Icon(items[i].icon),
                  selectedIcon: showTerminal && i == items.length - 1
                      ? Badge(
                          label: Text('$sessionCount'),
                          child: Icon(items[i].selectedIcon),
                        )
                      : Icon(items[i].selectedIcon),
                  label: Text(items[i].label),
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
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState.value == AuthStatus.authenticated;
    if (!isAuthenticated) return const SizedBox.shrink();

    final syncState = ref.watch(syncProvider);
    final billingActive =
        ref.watch(billingStatusProvider).value?.active ?? false;
    final serverReachable = ref.watch(serverReachableProvider).value ?? true;
    final isSyncing = syncState.value == SyncStatus.syncing;
    final hasError = syncState.hasError;

    final IconData icon;
    final Color color;
    final String? tooltip;
    if (isSyncing) {
      return const Padding(
        padding: EdgeInsets.only(left: 8),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    } else if (!serverReachable) {
      icon = Icons.cloud_off;
      color = Theme.of(context).colorScheme.error;
      tooltip = l10n.syncServerUnreachable;
    } else if (hasError) {
      icon = Icons.cloud_off;
      color = Theme.of(context).colorScheme.error;
      tooltip = null;
    } else if (billingActive && syncState.value == SyncStatus.success) {
      icon = Icons.cloud_done_outlined;
      color = Theme.of(context).colorScheme.primary;
      tooltip = null;
    } else {
      icon = Icons.cloud_outlined;
      color = Theme.of(context).colorScheme.onSurfaceVariant;
      tooltip = null;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Tooltip(
        message: tooltip ?? '',
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}

class _SettingsRailButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final syncState = ref.watch(syncProvider);
    final serverReachable = ref.watch(serverReachableProvider).value ?? true;
    final showBadge = syncState.hasError || !serverReachable;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          tooltip: l10n.navSettings,
          onPressed: () => context.push('/settings'),
        ),
        if (showBadge)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
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

    final (:items, :breaks) = _buildVisibleNavItems(
      context,
      showTerminal: showTerminal,
      sessionCount: sessionCount,
    );

    final clampedIndex = currentIndex < items.length ? currentIndex : 0;

    return NavigationDrawer(
      selectedIndex: clampedIndex,
      onDestinationSelected: (i) {
        Navigator.pop(context);
        onDestinationSelected(i);
      },
      children: [
        // Branding header
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 8),
          child: Row(
            children: [
              Image.asset('assets/images/app_icon.png', width: 28, height: 28),
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
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 8, 28, 8),
          child: Divider(),
        ),

        // Nav destinations with section dividers
        for (var i = 0; i < items.length; i++) ...[
          if (breaks.contains(i))
            const Padding(
              padding: EdgeInsets.fromLTRB(28, 4, 28, 4),
              child: Divider(),
            ),
          NavigationDrawerDestination(
            icon: showTerminal && i == items.length - 1
                ? Badge(
                    label: Text('$sessionCount'),
                    child: Icon(items[i].icon),
                  )
                : Icon(items[i].icon),
            selectedIcon: showTerminal && i == items.length - 1
                ? Badge(
                    label: Text('$sessionCount'),
                    child: Icon(items[i].selectedIcon),
                  )
                : Icon(items[i].selectedIcon),
            label: Text(items[i].label),
          ),
        ],

        // Settings at bottom via spacer workaround
        const _DrawerSettingsSection(),
      ],
    );
  }
}

class _DrawerSettingsSection extends ConsumerWidget {
  const _DrawerSettingsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final syncState = ref.watch(syncProvider);
    final serverReachable = ref.watch(serverReachableProvider).value ?? true;
    final showBadge = syncState.hasError || !serverReachable;

    Widget iconWidget = const Icon(Icons.settings_outlined);
    if (showBadge) {
      iconWidget = Badge(
        smallSize: 8,
        backgroundColor: theme.colorScheme.error,
        child: iconWidget,
      );
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 8),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: ListTile(
            leading: iconWidget,
            title: Text(l10n.navSettings),
            shape: const StadiumBorder(),
            onTap: () {
              Navigator.pop(context);
              context.push('/settings');
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
