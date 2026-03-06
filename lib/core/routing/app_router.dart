import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:shellvault/core/routing/app_shell.dart';
import 'package:shellvault/features/account/presentation/screens/audit_log_screen.dart';
import 'package:shellvault/features/account/presentation/screens/server_config_screen.dart';
import 'package:shellvault/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:shellvault/features/auth/presentation/screens/login_screen.dart';
import 'package:shellvault/features/auth/presentation/screens/register_screen.dart';
import 'package:shellvault/features/auth/presentation/screens/sync_password_screen.dart';
import 'package:shellvault/features/connection/presentation/screens/folder_browser_screen.dart';
import 'package:shellvault/features/connection/presentation/screens/server_detail_screen.dart';
import 'package:shellvault/features/connection/presentation/screens/server_form_screen.dart';
import 'package:shellvault/features/connection/presentation/screens/server_list_screen.dart';
import 'package:shellvault/features/connection/presentation/screens/ssh_key_list_screen.dart';
import 'package:shellvault/features/connection/presentation/screens/tag_list_screen.dart';
import 'package:shellvault/features/host_key/presentation/screens/known_host_list_screen.dart';
import 'package:shellvault/features/host_key/presentation/screens/ssh_config_import_screen.dart';
import 'package:shellvault/features/settings/presentation/screens/about_screen.dart';
import 'package:shellvault/features/settings/presentation/screens/account_sync_screen.dart';
import 'package:shellvault/features/settings/presentation/screens/appearance_settings_screen.dart';
import 'package:shellvault/features/settings/presentation/screens/export_settings_screen.dart';
import 'package:shellvault/features/settings/presentation/screens/network_settings_screen.dart';
import 'package:shellvault/features/settings/presentation/screens/security_settings_screen.dart';
import 'package:shellvault/features/settings/presentation/screens/settings_hub_screen.dart';
import 'package:shellvault/features/settings/presentation/screens/ssh_settings_screen.dart';
import 'package:shellvault/features/snippet/presentation/screens/snippet_detail_screen.dart';
import 'package:shellvault/features/snippet/presentation/screens/snippet_form_screen.dart';
import 'package:shellvault/features/snippet/presentation/screens/snippet_list_screen.dart';
import 'package:shellvault/features/sftp/presentation/screens/sftp_browser_screen.dart';
import 'package:shellvault/features/terminal/presentation/screens/terminal_branch_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

abstract final class AppRouter {
  static final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // ------------------------------------------------------------------
      // Shell: indexed-stack keeps each branch's state alive.
      // ------------------------------------------------------------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
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

      // ------------------------------------------------------------------
      // Detail routes — outside the shell (root navigator).
      // ------------------------------------------------------------------
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/server/new',
        builder: (context, state) => const ServerFormScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/server/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ServerDetailScreen(serverId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/server/:id/edit',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ServerFormScreen(serverId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/snippet/new',
        builder: (context, state) => const SnippetFormScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/snippet/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return SnippetDetailScreen(snippetId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/snippet/:id/edit',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return SnippetFormScreen(snippetId: id);
        },
      ),

      // Settings hub + sub-routes
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/settings',
        builder: (context, state) => const SettingsHubScreen(),
        routes: [
          GoRoute(
            path: 'account',
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const AccountSyncScreen(),
          ),
          GoRoute(
            path: 'security',
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const SecuritySettingsScreen(),
          ),
          GoRoute(
            path: 'ssh',
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const SshSettingsScreen(),
          ),
          GoRoute(
            path: 'appearance',
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const AppearanceSettingsScreen(),
          ),
          GoRoute(
            path: 'network',
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const NetworkSettingsScreen(),
          ),
          GoRoute(
            path: 'export',
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const ExportSettingsScreen(),
          ),
          GoRoute(
            path: 'known-hosts',
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const KnownHostListScreen(),
          ),
          GoRoute(
            path: 'import-ssh-config',
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const SshConfigImportScreen(),
          ),
          GoRoute(
            path: 'about',
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const AboutScreen(),
          ),
        ],
      ),

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
