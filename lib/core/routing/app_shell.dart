import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:sshvault/features/terminal/data/services/remote_system_metrics_service.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';

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
        ref.read(shellNavigationProvider.notifier).state =
            widget.navigationShell;

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

  static bool get _isDesktop =>
      Platform.isLinux || Platform.isMacOS || Platform.isWindows;

  @override
  Widget build(BuildContext context) {
    final sessionCount = ref.watch(sessionManagerProvider).length;

    Widget shell = LayoutBuilder(
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

    if (_isDesktop) {
      shell = _DesktopShortcuts(
        ref: ref,
        navigationShell: widget.navigationShell,
        child: shell,
      );
    }

    return shell;
  }
}

// ---------------------------------------------------------------------------
// Desktop Keyboard Shortcuts
// ---------------------------------------------------------------------------

class _DesktopShortcuts extends StatefulWidget {
  final WidgetRef ref;
  final StatefulNavigationShell navigationShell;
  final Widget child;

  const _DesktopShortcuts({
    required this.ref,
    required this.navigationShell,
    required this.child,
  });

  @override
  State<_DesktopShortcuts> createState() => _DesktopShortcutsState();
}

class _DesktopShortcutsState extends State<_DesktopShortcuts> {
  static const _menuChannel = MethodChannel('de.kiefer_networks.sshvault/menu');

  /// Use Meta on macOS, Control everywhere else.
  static final bool _useMeta = Platform.isMacOS;

  @override
  void initState() {
    super.initState();
    _menuChannel.setMethodCallHandler(_handleMenuCall);
  }

  @override
  void dispose() {
    _menuChannel.setMethodCallHandler(null);
    super.dispose();
  }

  Future<void> _handleMenuCall(MethodCall call) async {
    if (call.method == 'openSettings' && mounted) {
      GoRouter.of(context).push('/settings');
    }
  }

  SingleActivator _shortcut(LogicalKeyboardKey key, {bool shift = false}) {
    return SingleActivator(
      key,
      meta: _useMeta,
      control: !_useMeta,
      shift: shift,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        // Cmd/Ctrl+, → open Settings
        _shortcut(LogicalKeyboardKey.comma): () {
          GoRouter.of(context).push('/settings');
        },

        // Ctrl/Cmd+T → navigate to Hosts (to start new connection)
        _shortcut(LogicalKeyboardKey.keyT): () {
          widget.navigationShell.goBranch(0, initialLocation: true);
        },

        // Ctrl/Cmd+W → close active terminal tab
        _shortcut(LogicalKeyboardKey.keyW): () {
          final sessions = widget.ref.read(sessionManagerProvider);
          if (sessions.isEmpty) return;
          final active = widget.ref.read(activeSessionProvider);
          if (active != null) {
            widget.ref
                .read(sessionManagerProvider.notifier)
                .closeSession(active.id);
          }
        },

        // Ctrl/Cmd+Plus → increase font size
        _shortcut(LogicalKeyboardKey.equal): () {
          widget.ref.read(terminalFontSizeProvider.notifier).increase();
        },

        // Ctrl/Cmd+Minus → decrease font size
        _shortcut(LogicalKeyboardKey.minus): () {
          widget.ref.read(terminalFontSizeProvider.notifier).decrease();
        },

        // Ctrl/Cmd+1-9 → switch terminal tab
        for (var i = 0; i < 9; i++)
          _shortcut(LogicalKeyboardKey(0x31 + i)): () {
            final sessions = widget.ref.read(sessionManagerProvider);
            if (i < sessions.length) {
              widget.ref.read(activeSessionIndexProvider.notifier).state = i;
              final sessionCount = sessions.length;
              if (sessionCount > 0) {
                widget.navigationShell.goBranch(
                  AppConstants.terminalBranchIndex,
                );
              }
            }
          },
      },
      child: Focus(autofocus: true, child: widget.child),
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
      body: LayoutBuilder(
        builder: (context, constraints) => Row(
          children: [
            NavigationRail(
              selectedIndex: clampedIndex,
              onDestinationSelected: onDestinationSelected,
              extended: extended,
              leading: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Spacing.sm,
                  horizontal: extended ? Spacing.lg : 0,
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
                          Spacing.horizontalMd,
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
                    padding: const EdgeInsets.only(bottom: Spacing.lg),
                    child: _SettingsRailButton(),
                  ),
                ),
              ),
              destinations: [
                for (var i = 0; i < items.length; i++)
                  NavigationRailDestination(
                    padding: breaks.contains(i)
                        ? const EdgeInsets.only(top: Spacing.md)
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
            if (constraints.maxWidth >= 1100 && currentIndex == 0) ...[
              VerticalDivider(
                thickness: 1,
                width: 1,
                color: theme.dividerTheme.color,
              ),
              const SizedBox(width: 430, child: _DesktopDetailsPane()),
            ],
          ],
        ),
      ),
    );
  }
}

/// Persistent context pane used by the wide Windows/Linux/macOS shell.
/// It follows the active SSH session and keeps connection details visible
/// without opening a second route or dialog.
class _DesktopDetailsPane extends ConsumerWidget {
  const _DesktopDetailsPane();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final selectedId = ref.watch(desktopSelectedServerIdProvider);
    final session = ref.watch(activeSessionProvider);
    final serverId = selectedId ?? session?.serverId;
    final server = serverId == null
        ? null
        : ref.watch(serverDetailProvider(serverId)).value;

    return ColoredBox(
      color: theme.colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: server == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.serverDetails, style: theme.textTheme.titleLarge),
                  Spacing.verticalMd,
                  Text(
                    l10n.desktopDetailsEmpty,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              )
            : ListView(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(server.name, style: theme.textTheme.titleLarge)),
                      PopupMenuButton<String>(
                        tooltip: l10n.navMore,
                        onSelected: (action) async {
                          if (action == 'edit') {
                            context.push('/server/${server.id}/edit');
                          } else if (action == 'delete') {
                            final confirmed = await showAdaptiveConfirmDialog(
                              context,
                              title: l10n.serverDeleteTitle,
                              message: l10n.serverDeleteMessage(server.name),
                              cancelLabel: l10n.cancel,
                              confirmLabel: l10n.delete,
                              isDestructive: true,
                            );
                            if (confirmed == true && context.mounted) {
                              await ref.read(serverListProvider.notifier).deleteServer(server.id);
                              ref.read(desktopSelectedServerIdProvider.notifier).state = null;
                            }
                          } else if (action == 'connect') {
                            await ref.read(sessionManagerProvider.notifier).openSession(server.id);
                            ref.read(shellNavigationProvider)?.goBranch(AppConstants.terminalBranchIndex);
                          }
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(value: 'connect', child: ListTile(leading: const Icon(Icons.terminal), title: Text(l10n.serverConnect))),
                          PopupMenuItem(value: 'edit', child: ListTile(leading: const Icon(Icons.edit), title: Text(l10n.edit))),
                          PopupMenuItem(value: 'delete', child: ListTile(leading: const Icon(Icons.delete), title: Text(l10n.delete))),
                        ],
                      ),
                    ],
                  ),
                  Spacing.verticalXs,
                  Text(
                    '${server.username}@${server.hostname}:${server.port}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: AppConstants.monospaceFontFamily,
                    ),
                  ),
                  Spacing.verticalLg,
                  FilledButton.icon(
                    onPressed: () async {
                      await ref
                          .read(sessionManagerProvider.notifier)
                          .openSession(server.id);
                      ref
                          .read(shellNavigationProvider)
                          ?.goBranch(AppConstants.terminalBranchIndex);
                    },
                    icon: const Icon(Icons.terminal),
                    label: Text(l10n.serverConnect),
                  ),
                  Spacing.verticalMd,
                  Card(margin: EdgeInsets.zero, elevation: 0, child: Padding(
                    padding: const EdgeInsets.all(Spacing.md),
                    child: Column(children: [
                      _DetailsRow(icon: Icons.dns_outlined, label: l10n.serverDetailHost, value: server.hostname),
                      _DetailsRow(icon: Icons.numbers, label: l10n.serverDetailPort, value: '${server.port}'),
                      _DetailsRow(icon: Icons.person_outline, label: l10n.serverDetailUsername, value: server.username),
                    ]),
                  )),
                  if (server.osName != null || server.osVersion != null) ...[
                    Spacing.verticalLg,
                    Card(
                      margin: EdgeInsets.zero,
                      elevation: 0,
                      color: theme.colorScheme.primaryContainer.withAlpha(90),
                      child: ListTile(
                        leading: Icon(_osIcon(server.osFamily)),
                        title: Text(l10n.serverDetailSystemInfo),
                        subtitle: Text([server.osName, server.osVersion]
                            .whereType<String>().where((v) => v.isNotEmpty).join(' ')),
                        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                          if (server.osDetectedAt != null) Text(_relativeTime(server.osDetectedAt!), style: theme.textTheme.labelSmall),
                          IconButton(icon: const Icon(Icons.refresh), tooltip: l10n.retry, onPressed: () async {
                            final active = session?.serverId == server.id ? session : null;
                            if (active != null) { await ref.read(sessionManagerProvider.notifier).reconnectSession(active.id); }
                            else { await ref.read(sessionManagerProvider.notifier).openSession(server.id); }
                          }),
                        ]),
                      ),
                    ),
                  ],
                  if (server.systemMetricsJson != null) ...[
                    ..._systemMetricRows(server.systemMetricsJson!, l10n, theme),
                  ],
                  if (server.tags.isNotEmpty) ...[
                    Spacing.verticalMd,
                    Text(l10n.navTags, style: theme.textTheme.titleSmall),
                    Spacing.verticalXs,
                    Wrap(
                      spacing: Spacing.xs,
                      runSpacing: Spacing.xs,
                      children: server.tags
                          .map((tag) => Chip(label: Text(tag.name)))
                          .toList(),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  List<Widget> _systemMetricRows(String raw, AppLocalizations l10n, ThemeData theme) {
    try {
      final value = jsonDecode(raw);
      if (value is! Map) return const [];
      final metrics = RemoteSystemMetrics.fromJson(
        Map<String, Object?>.from(value),
      );
      final rows = <Widget>[];
      if (metrics.kernelVersion != null || metrics.kernelName != null) {
        rows.add(_MetricCard(icon: Icons.memory, label: l10n.serverDetailKernel,
          value: [metrics.kernelName, metrics.kernelVersion].whereType<String>().where((v) => v.isNotEmpty).join(' ')));
      }
      if (metrics.cpuModel != null || metrics.cpuCores != null) {
        rows.add(_MetricCard(icon: Icons.developer_board, label: l10n.serverDetailCpu,
          value: [metrics.cpuModel, if (metrics.cpuVendor != null) metrics.cpuVendor, if (metrics.cpuCores != null) '${metrics.cpuCores}', if (metrics.cpuPhysicalCores != null) '${metrics.cpuPhysicalCores}'].whereType<String>().join(' · ')));
      }
      if (metrics.isVirtualMachine == true) {
        rows.add(_MetricCard(icon: Icons.cloud_outlined, label: l10n.serverDetailVirtualMachine, value: l10n.serverDetailVirtualMachine));
      }
      if (metrics.serialNumber != null) {
        rows.add(_MetricCard(icon: Icons.confirmation_number_outlined, label: l10n.serverDetailSerial, value: metrics.serialNumber!));
      }
      if (metrics.ramBytes != null) {
        rows.add(_MetricCard(icon: Icons.memory, label: l10n.serverDetailRam,
          value: _formatBytes(metrics.ramBytes!)));
      }
      if (metrics.disks.isNotEmpty) {
        final docker = metrics.disks.where((d) => d.mountPoint.contains('overlay2') || d.mountPoint.contains('/docker/')).toList();
        final regular = metrics.disks.where((d) => !docker.contains(d)).toList();
        rows.add(Card(margin: EdgeInsets.zero, elevation: 0, child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [const Icon(Icons.storage, size: 18), Spacing.horizontalSm, Text(l10n.serverDetailDisks, style: theme.textTheme.titleSmall)]),
            Spacing.verticalSm,
            ...regular.take(6).map((d) => _StorageLine(mount: d.mountPoint, free: d.freeBytes, total: d.totalBytes)),
            if (docker.isNotEmpty) _StorageLine(mount: 'Docker', free: docker.fold<int>(0, (a, d) => a + d.freeBytes), total: docker.fold<int>(0, (a, d) => a + d.totalBytes), emphasized: true),
          ]),
        )));
      }
      return rows.isEmpty ? const [] : [Spacing.verticalMd, ...rows];
    } catch (_) {
      return const [];
    }
  }

  IconData _osIcon(String? family) => switch (family?.toLowerCase()) {
    'windows' => Icons.window,
    'macos' => Icons.laptop_mac,
    'linux' => Icons.computer,
    'bsd' => Icons.dns,
    _ => Icons.computer_outlined,
  };

  String _relativeTime(DateTime value) {
    final age = DateTime.now().difference(value);
    if (age.inMinutes < 1) return '<1 min';
    if (age.inHours < 1) return '${age.inMinutes} min';
    return '${age.inHours} h';
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon; final String label; final String value;
  const _MetricCard({required this.icon, required this.label, required this.value});
  @override Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: Spacing.sm), elevation: 0,
    child: ListTile(dense: true, leading: Icon(icon), title: Text(label), subtitle: Text(value)),
  );
}

String _formatBytes(int bytes) {
  const tb = 1024 * 1024 * 1024 * 1024;
  const gb = 1024 * 1024 * 1024;
  const mb = 1024 * 1024;
  if (bytes >= tb) return '${(bytes / tb).toStringAsFixed(1)} TB';
  if (bytes >= gb) return '${(bytes / gb).toStringAsFixed(1)} GB';
  return '${(bytes / mb).toStringAsFixed(1)} MB';
}

class _StorageLine extends StatelessWidget {
  final String mount; final int free; final int total; final bool emphasized;
  const _StorageLine({required this.mount, required this.free, required this.total, this.emphasized = false});
  @override Widget build(BuildContext context) {
    final ratio = total > 0 ? (1 - free / total).clamp(0.0, 1.0) : 0.0;
    final freeText = _formatBytes(free);
    final totalText = _formatBytes(total);
    return Padding(padding: const EdgeInsets.only(bottom: Spacing.sm), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(emphasized ? Icons.view_in_ar : Icons.folder_open, size: 16), Spacing.horizontalXs, Expanded(child: Text(mount, overflow: TextOverflow.ellipsis)), Text('$freeText / $totalText')]),
      const SizedBox(height: 4), LinearProgressIndicator(value: ratio, minHeight: 5),
    ]));
  }
}

class _DetailsRow extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String value;

  const _DetailsRow({this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Spacing.sm),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16),
          const SizedBox(width: 8),
        ],
        SizedBox(width: 72, child: Text(label)),
        Expanded(child: Text(value, textAlign: TextAlign.end)),
      ],
    ),
  );
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
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final syncState = ref.watch(syncProvider);
    final serverReachable = ref.watch(serverReachableProvider).value ?? true;
    final showBadge = syncState.hasError || !serverReachable;

    return Badge(
      smallSize: 8,
      isLabelVisible: showBadge,
      backgroundColor: Theme.of(context).colorScheme.error,
      child: IconButton(
        icon: const Icon(Icons.settings_outlined),
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
