import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/core/routing/shell_navigation_provider.dart';
import 'package:sshvault/core/services/terminal_notification_service.dart';
import 'package:window_manager/window_manager.dart';
import 'package:sshvault/features/account/presentation/providers/account_providers.dart';
import 'package:sshvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/features/sync/presentation/providers/sync_providers.dart';
import 'package:sshvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';
import 'package:sshvault/features/connection/presentation/screens/command_deck_home_screen.dart';
import 'package:sshvault/features/connection/presentation/widgets/command_palette.dart';

/// Breakpoint following Material 3 Compact vs. Medium/Expanded.
abstract final class ShellBreakpoints {
  static const double mobile = 600;
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

/// Registers the current [StatefulNavigationShell] into
/// [shellNavigationProvider] and renders it unchanged.
///
/// This exists because [AppShell] is now the *outer* `ShellRoute`'s builder
/// (see `app_router.dart`) rather than the `StatefulShellRoute`'s own — it
/// wraps Settings as well as the branches, so Settings keeps the rail
/// instead of covering it with a second, rail-less screen. That means
/// `AppShell` no longer receives a `navigationShell` directly; this tiny
/// widget is the `StatefulShellRoute`'s builder instead, and publishes the
/// shell into the provider so the persistent rail above it can still drive
/// `goBranch`/`currentIndex`.
class ShellNavigationRegistrar extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const ShellNavigationRegistrar({super.key, required this.navigationShell});

  @override
  ConsumerState<ShellNavigationRegistrar> createState() =>
      ShellNavigationRegistrarState();
}

class ShellNavigationRegistrarState
    extends ConsumerState<ShellNavigationRegistrar> {
  void _register() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(shellNavigationProvider.notifier).state =
            widget.navigationShell;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _register();
  }

  @override
  void didUpdateWidget(covariant ShellNavigationRegistrar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _register();
  }

  @override
  Widget build(BuildContext context) => widget.navigationShell;
}

/// The persistent desktop rail / mobile drawer shell, wrapping the outer
/// `ShellRoute` in `app_router.dart` — meaning it wraps *both* the
/// `StatefulShellRoute` branches (Hosts, SFTP, …) and `/settings` (plus its
/// sub-routes), so navigating into Settings keeps the same rail on screen
/// instead of replacing it with a second, unrelated navigation surface.
///
/// Renders a [Drawer] on mobile (< 600 dp) and a compact icon rail on
/// tablet / desktop (>= 600 dp).
///
/// Branch screens can open the drawer via [AppShell.maybeOf(context)].
class AppShell extends ConsumerStatefulWidget {
  final String location;
  final Widget child;

  const AppShell({super.key, required this.location, required this.child});

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
  TerminalNotificationService? _notificationService;

  void openDrawer() => scaffoldKey.currentState?.openDrawer();

  @override
  void initState() {
    super.initState();

    // Refresh device providers on app resume (e.g. after extended background).
    _lifecycleListener = AppLifecycleListener(
      onResume: _refreshAccountProviders,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Navigate to terminal when the notification is tapped
        TerminalNotificationService.onNotificationTapped = () {
          ref
              .read(shellNavigationProvider)
              ?.goBranch(AppConstants.terminalBranchIndex);
        };

        _notificationService = ref.read(terminalNotificationProvider);

        // Desktop toast action wiring: opaque tags emitted by the native
        // toast (or its persisted Action-Center / Notification-Center
        // entry) are pattern-matched here and dispatched to the right
        // session. The Windows + macOS callbacks share the same handler
        // because the tag vocabulary matches.
        void handleDesktopAction(String tag) {
          if (tag.startsWith('disconnect:')) {
            final sessionId = tag.substring('disconnect:'.length);
            ref.read(sessionManagerProvider.notifier).closeSession(sessionId);
          } else if (tag.startsWith('show:')) {
            windowManager.show();
            windowManager.focus();
            ref
                .read(shellNavigationProvider)
                ?.goBranch(AppConstants.terminalBranchIndex);
          }
        }

        if (Platform.isWindows) {
          _notificationService!.onWindowsAction(handleDesktopAction);
        }
        if (Platform.isMacOS) {
          _notificationService!.onMacosAction(handleDesktopAction);
          // Kick off the macOS permission prompt the first time the shell
          // mounts. Subsequent calls are cheap — UNUserNotificationCenter
          // returns the cached decision without re-prompting the user.
          unawaited(_notificationService!.ensureMacosAuthorized());
        }

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

    // For the disconnect action we wire the FIRST active session — the
    // toast is a single rolling entry, so we let "Disconnect" close the
    // most recently surfaced one. The Action-Center / Notification-Center
    // entry stays in sync via replace-by-id semantics in the platform
    // notification services.
    final settings = ref.read(settingsProvider).value;
    final winActionsEnabled = settings?.windowsToastActionsEnabled ?? true;
    final macActionsEnabled = settings?.macosToastActionsEnabled ?? true;
    final disconnectTag = 'disconnect:${active.first.id}';

    service.show(
      title: l10n.notificationTerminalTitle(active.length),
      body: active.map((s) => s.title).join(', '),
      windowsActionsEnabled: winActionsEnabled,
      macosActionsEnabled: macActionsEnabled,
      windowsDisconnectTag: disconnectTag,
      macosDisconnectTag: disconnectTag,
    );
  }

  @override
  void dispose() {
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

  void _onDestinationSelected(int index) {
    final shell = ref.read(shellNavigationProvider);
    if (shell == null) return;
    shell.goBranch(index, initialLocation: index == shell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final sessionCount = ref.watch(sessionManagerProvider).length;
    // shellNavigationProvider keeps the last-registered branch shell even
    // while /settings is on top of it (pushed, not replacing — the
    // StatefulShellRoute stays mounted underneath), so the rail can keep
    // highlighting where you'll land when you leave Settings.
    final currentIndex = ref.watch(shellNavigationProvider)?.currentIndex ?? 0;
    final isSettings = widget.location.startsWith('/settings');

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width < ShellBreakpoints.mobile) {
          return _MobileScaffold(
            scaffoldKey: scaffoldKey,
            currentIndex: currentIndex,
            onDestinationSelected: _onDestinationSelected,
            sessionCount: sessionCount,
            child: widget.child,
          );
        }

        return _DesktopScaffold(
          currentIndex: currentIndex,
          isSettings: isSettings,
          onDestinationSelected: _onDestinationSelected,
          sessionCount: sessionCount,
          child: widget.child,
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
      // Edge-to-edge: the mobile shell hosts branch screens that may not
      // declare their own AppBar / SafeArea. Wrap the body so content
      // never collides with the (now transparent) status / nav bars on
      // Android 15+ (SDK 35). Branch screens that *do* have their own
      // AppBar still see the full inset via MediaQuery.viewPadding.
      body: SafeArea(
        top: true,
        bottom: true,
        left: false,
        right: false,
        child: child,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Desktop: Command Deck shell — compact icon rail + full-bleed content.
//
// Runs under AppTheme.buildCommandDeck() — a dark, amber-accented theme
// applied above the router in app.dart's MaterialApp.router builder, so it
// also covers /settings and every other route this same outer ShellRoute
// wraps (see app_router.dart). Mobile and tablet keep the user's own
// light/dark choice; the desktop shell commits to one look on purpose, the
// same way a terminal emulator doesn't ship a "light mode" for the buffer
// itself.
// ---------------------------------------------------------------------------

class _DesktopScaffold extends StatelessWidget {
  final int currentIndex;
  final bool isSettings;
  final ValueChanged<int> onDestinationSelected;
  final int sessionCount;
  final Widget child;

  const _DesktopScaffold({
    required this.currentIndex,
    required this.isSettings,
    required this.onDestinationSelected,
    required this.sessionCount,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showTerminal = sessionCount > 0;

    final (:items, :breaks) = _buildVisibleNavItems(
      context,
      showTerminal: showTerminal,
      sessionCount: sessionCount,
    );

    // Clamp selectedIndex if a dynamic item is hidden but was selected.
    // -1 while on Settings so no branch icon falsely shows as active —
    // _SettingsRailButton carries its own active state instead.
    final clampedIndex = isSettings
        ? -1
        : (currentIndex < items.length ? currentIndex : 0);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Row(
        children: [
          _DeckRail(
            items: items,
            breaks: breaks,
            selectedIndex: clampedIndex,
            onDestinationSelected: onDestinationSelected,
            sessionCount: sessionCount,
            showTerminal: showTerminal,
            settingsActive: isSettings,
          ),
          VerticalDivider(
            thickness: 1,
            width: 1,
            color: theme.colorScheme.outlineVariant,
          ),
          Expanded(
            // /settings (and its sub-routes) is a sibling route under the
            // same outer ShellRoute as the branches — not a child of branch
            // 0 — so it never needs the Offstage/CommandDeckHomeScreen
            // substitution below; `child` is already exactly the settings
            // screen and nothing else is mounted underneath it right now.
            child: isSettings
                ? child
                : Stack(
                    children: [
                      // Branch 0's own route (ServerListScreen) stays
                      // mounted — via Offstage, not omitted — so the
                      // StatefulShellRoute branch keeps its Navigator/state
                      // alive for when the window narrows back below the
                      // mobile breakpoint.
                      Offstage(offstage: currentIndex == 0, child: child),
                      if (currentIndex == 0) const CommandDeckHomeScreen(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

/// Compact, icon-only rail — the Command Deck shell has no extended/labeled
/// mode. Discoverability comes from tooltips and the command palette's own
/// "Go to …" entries, not from a wordmark next to every icon.
class _DeckRail extends StatelessWidget {
  final List<_NavItem> items;
  final Set<int> breaks;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final int sessionCount;
  final bool showTerminal;
  final bool settingsActive;

  const _DeckRail({
    required this.items,
    required this.breaks,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.sessionCount,
    required this.showTerminal,
    required this.settingsActive,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Container(
      width: 56,
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          const SizedBox(height: 14),
          Image.asset('assets/images/app_icon.png', width: 26, height: 26),
          const SizedBox(height: 4),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  if (breaks.contains(i))
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        height: 1,
                        indent: 14,
                        endIndent: 14,
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                  _DeckRailIcon(
                    icon: items[i].icon,
                    selectedIcon: items[i].selectedIcon,
                    label: items[i].label,
                    selected: i == selectedIndex,
                    badge: showTerminal && i == items.length - 1
                        ? sessionCount
                        : null,
                    onTap: () => onDestinationSelected(i),
                  ),
                ],
              ],
            ),
          ),
          _DeckRailIcon(
            icon: Icons.search,
            selectedIcon: Icons.search,
            label: '${l10n.searchServers} (Ctrl+K)',
            selected: false,
            onTap: () => showCommandPalette(context),
          ),
          const SizedBox(height: 2),
          _SettingsRailButton(active: settingsActive),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}

class _DeckRailIcon extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final int? badge;
  final VoidCallback onTap;

  const _DeckRailIcon({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget iconWidget = Icon(
      selected ? selectedIcon : icon,
      size: 20,
      color: selected
          ? theme.colorScheme.primary
          : theme.colorScheme.onSurfaceVariant,
    );
    if (badge != null && badge! > 0) {
      iconWidget = Badge(label: Text('$badge'), child: iconWidget);
    }
    return Tooltip(
      message: label,
      waitDuration: const Duration(milliseconds: 400),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 44,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: selected
                  ? theme.colorScheme.primary.withAlpha(31)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: selected
                  ? Border.all(color: theme.colorScheme.primary.withAlpha(90))
                  : null,
            ),
            alignment: Alignment.center,
            child: iconWidget,
          ),
        ),
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
    final serverReachable = ref.watch(serverReachableProvider).value ?? true;
    final isSyncing = syncState.value == SyncStatus.syncing;
    final hasError = syncState.hasError;

    final IconData icon;
    final Color color;
    final String? tooltip;
    if (isSyncing) {
      return const Padding(
        padding: EdgeInsets.only(left: Spacing.sm),
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
    } else if (syncState.value == SyncStatus.success) {
      icon = Icons.cloud_done_outlined;
      color = Theme.of(context).colorScheme.primary;
      tooltip = null;
    } else {
      icon = Icons.cloud_outlined;
      color = Theme.of(context).colorScheme.onSurfaceVariant;
      tooltip = null;
    }

    return Padding(
      padding: const EdgeInsets.only(left: Spacing.sm),
      child: Tooltip(
        message: tooltip ?? '',
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}

class _SettingsRailButton extends ConsumerWidget {
  final bool active;

  const _SettingsRailButton({this.active = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final syncState = ref.watch(syncProvider);
    final serverReachable = ref.watch(serverReachableProvider).value ?? true;
    final showBadge = syncState.hasError || !serverReachable;

    return Badge(
      smallSize: 8,
      isLabelVisible: showBadge,
      backgroundColor: theme.colorScheme.error,
      child: IconButton(
        icon: Icon(
          active ? Icons.settings : Icons.settings_outlined,
          color: active ? theme.colorScheme.primary : null,
        ),
        tooltip: l10n.navSettings,
        onPressed: () => context.push('/settings'),
      ),
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
          padding: const EdgeInsets.fromLTRB(
            Spacing.xxxl,
            Spacing.xxl,
            Spacing.xxxl,
            Spacing.sm,
          ),
          child: Row(
            children: [
              Image.asset('assets/images/app_icon.png', width: 28, height: 28),
              Spacing.horizontalMd,
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
          padding: EdgeInsets.fromLTRB(
            Spacing.xxxl,
            Spacing.sm,
            Spacing.xxxl,
            Spacing.sm,
          ),
          child: Divider(),
        ),

        // Nav destinations with section dividers
        for (var i = 0; i < items.length; i++) ...[
          if (breaks.contains(i))
            const Padding(
              padding: EdgeInsets.fromLTRB(
                Spacing.xxxl,
                Spacing.xxs,
                Spacing.xxxl,
                Spacing.xxs,
              ),
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
          padding: EdgeInsets.fromLTRB(
            Spacing.xxxl,
            Spacing.lg,
            Spacing.xxxl,
            Spacing.sm,
          ),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.xxxs,
          ),
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
        Spacing.verticalSm,
      ],
    );
  }
}
