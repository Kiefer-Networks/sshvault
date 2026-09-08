import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:sshvault/core/routing/app_shell.dart';
import 'package:sshvault/features/account/presentation/screens/audit_log_screen.dart';
import 'package:sshvault/features/account/presentation/screens/server_config_screen.dart';
import 'package:sshvault/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:sshvault/features/auth/presentation/screens/login_screen.dart';
import 'package:sshvault/features/auth/presentation/screens/register_screen.dart';
import 'package:sshvault/features/auth/presentation/screens/sync_password_screen.dart';
import 'package:sshvault/features/connection/presentation/screens/folder_browser_screen.dart';
import 'package:sshvault/features/connection/presentation/screens/server_detail_screen.dart';
import 'package:sshvault/features/connection/presentation/screens/server_form_screen.dart';
import 'package:sshvault/features/connection/presentation/screens/server_list_screen.dart';
import 'package:sshvault/features/connection/presentation/screens/ssh_key_list_screen.dart';
import 'package:sshvault/features/connection/presentation/screens/tag_list_screen.dart';
import 'package:sshvault/features/host_key/presentation/screens/known_host_list_screen.dart';
import 'package:sshvault/features/host_key/presentation/screens/ssh_config_import_screen.dart';
import 'package:sshvault/features/settings/presentation/screens/about_screen.dart';
import 'package:sshvault/features/settings/presentation/screens/account_sync_screen.dart';
import 'package:sshvault/features/settings/presentation/screens/appearance_settings_screen.dart';
import 'package:sshvault/features/settings/presentation/screens/export_settings_screen.dart';
import 'package:sshvault/features/settings/presentation/screens/network_settings_screen.dart';
import 'package:sshvault/features/settings/presentation/screens/security_settings_screen.dart';
import 'package:sshvault/core/routing/settings_shell.dart';
import 'package:sshvault/features/settings/presentation/screens/ssh_settings_screen.dart';
import 'package:sshvault/features/snippet/presentation/screens/snippet_detail_screen.dart';
import 'package:sshvault/features/snippet/presentation/screens/snippet_form_screen.dart';
import 'package:sshvault/features/snippet/presentation/screens/snippet_list_screen.dart';
import 'package:sshvault/features/sftp/presentation/screens/sftp_browser_screen.dart';
import 'package:sshvault/features/terminal/presentation/screens/terminal_branch_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// The outer [ShellRoute]'s own navigator — server/snippet detail+edit and
/// `/settings` all live here as siblings, so a global Escape handler can
/// pop exactly this navigator (keeping the rail on screen) without
/// guessing whether the root navigator has something poppable too.
final shellNavigatorKey = GlobalKey<NavigatorState>();

abstract final class AppRouter {
  static final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // ------------------------------------------------------------------
      // Persistent shell: the rail/drawer wraps *both* the indexed-stack
      // branches below (Hosts, SFTP, …) and /settings, as siblings under
      // this one ShellRoute — so opening Settings pushes onto this
      // shell's own nested navigator instead of the root one, keeping the
      // rail on screen instead of covering it with a second, unrelated
      // navigation surface. Only true full-screen flows (auth, a server's
      // own detail/edit form, …) still use parentNavigatorKey:
      // rootNavigatorKey below to bypass this shell entirely.
      // ------------------------------------------------------------------
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return AppShell(location: state.uri.path, child: child);
        },
        routes: [
          // Indexed-stack keeps each branch's state alive.
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return ShellNavigationRegistrar(navigationShell: navigationShell);
            },
            branches: [
              // 0 — Hosts
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/',
                    builder: (context, state) => const ServerListScreen(),
                  ),
                ],
              ),

              // 1 — SFTP
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/sftp',
                    builder: (context, state) => const SftpBrowserScreen(),
                  ),
                ],
              ),

              // 2 — Snippets
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/snippets',
                    builder: (context, state) => const SnippetListScreen(),
                  ),
                ],
              ),

              // 3 — SSH Keys
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/keys',
                    builder: (context, state) => const SshKeyListScreen(),
                  ),
                ],
              ),

              // 4 — Folders
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/folders',
                    builder: (context, state) => const FolderBrowserScreen(),
                  ),
                ],
              ),

              // 5 — Tags
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/tags',
                    builder: (context, state) => const TagListScreen(),
                  ),
                ],
              ),

              // 6 — Terminal
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/terminal',
                    builder: (context, state) => const TerminalBranchScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Settings — a *nested* ShellRoute (its own master/detail tree +
          // search sidebar) inside this outer one, so the app's main rail
          // and the settings category tree are both visible together;
          // selecting a category swaps only the right pane instead of
          // re-navigating away from Settings. See settings_shell.dart.
          ShellRoute(
            builder: (context, state, child) =>
                SettingsShell(location: state.uri.path, child: child),
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsOverviewPane(),
              ),
              GoRoute(
                path: '/settings/account',
                builder: (context, state) => const AccountSyncScreen(),
              ),
              GoRoute(
                path: '/settings/security',
                builder: (context, state) => const SecuritySettingsScreen(),
              ),
              GoRoute(
                path: '/settings/ssh',
                builder: (context, state) => const SshSettingsScreen(),
              ),
              GoRoute(
                path: '/settings/appearance',
                builder: (context, state) => const AppearanceSettingsScreen(),
              ),
              GoRoute(
                path: '/settings/network',
                builder: (context, state) => const NetworkSettingsScreen(),
              ),
              GoRoute(
                path: '/settings/export',
                builder: (context, state) => const ExportSettingsScreen(),
              ),
              GoRoute(
                path: '/settings/known-hosts',
                builder: (context, state) => const KnownHostListScreen(),
              ),
              GoRoute(
                path: '/settings/about',
                builder: (context, state) => const AboutScreen(),
              ),
            ],
          ),

          // Not a category — a one-off import wizard reached FROM Settings,
          // so it stays a sibling full-bleed pane (still under the app's
          // main rail) rather than living inside the category tree.
          GoRoute(
            path: '/settings/import-ssh-config',
            builder: (context, state) => const SshConfigImportScreen(),
          ),

          // Server/snippet detail + edit — siblings of /settings under the
          // same outer ShellRoute (not parentNavigatorKey: rootNavigatorKey
          // like before) so the rail stays visible here too, matching how
          // /settings already works. Each screen still builds its own
          // Scaffold/AppBar and back control; only the *navigator* they
          // push onto changed.
          GoRoute(
            path: '/server/new',
            builder: (context, state) => const ServerFormScreen(),
          ),
          GoRoute(
            path: '/server/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ServerDetailScreen(serverId: id);
            },
          ),
          GoRoute(
            path: '/server/:id/edit',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ServerFormScreen(serverId: id);
            },
          ),
          GoRoute(
            path: '/snippet/new',
            builder: (context, state) => const SnippetFormScreen(),
          ),
          GoRoute(
            path: '/snippet/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return SnippetDetailScreen(snippetId: id);
            },
          ),
          GoRoute(
            path: '/snippet/:id/edit',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return SnippetFormScreen(snippetId: id);
            },
          ),
        ],
      ),

      // ------------------------------------------------------------------
      // Everything below stays outside the shell (root navigator): auth is
      // pre-account (no host list to show a rail for), and these others are
      // narrow, transient flows that intentionally take over the window.
      // ------------------------------------------------------------------

      // Auth routes
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/sync-password',
        builder: (context, state) {
          final modeParam = state.uri.queryParameters['mode'];
          final mode = modeParam == 'enter'
              ? SyncPasswordMode.enter
              : SyncPasswordMode.create;
          return SyncPasswordScreen(mode: mode);
        },
      ),

      // Redirects for backward compatibility
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/account',
        redirect: (_, _) => '/settings/account',
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/sync-settings',
        redirect: (_, _) => '/settings/account',
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/export-import',
        redirect: (_, _) => '/settings/export',
      ),

      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/server-config',
        builder: (context, state) => const ServerConfigScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/audit-log',
        builder: (context, state) => const AuditLogScreen(),
      ),
    ],
    errorBuilder: (context, state) {
      final l10n = AppLocalizations.of(context);
      return Scaffold(
        body: Center(child: Text(l10n?.pageNotFound ?? 'Page not found')),
      );
    },
  );
}
