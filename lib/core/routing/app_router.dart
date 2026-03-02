import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/core/routing/app_shell.dart';
import 'package:shellvault/features/account/presentation/screens/server_config_screen.dart';
import 'package:shellvault/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:shellvault/features/auth/presentation/screens/login_screen.dart';
import 'package:shellvault/features/auth/presentation/screens/register_screen.dart';
import 'package:shellvault/features/auth/presentation/screens/sync_password_screen.dart';
import 'package:shellvault/features/connection/presentation/screens/export_import_screen.dart';
import 'package:shellvault/features/connection/presentation/screens/group_list_screen.dart';
import 'package:shellvault/features/connection/presentation/screens/server_detail_screen.dart';
import 'package:shellvault/features/connection/presentation/screens/server_form_screen.dart';
import 'package:shellvault/features/connection/presentation/screens/server_list_screen.dart';
import 'package:shellvault/features/connection/presentation/screens/ssh_key_list_screen.dart';
import 'package:shellvault/features/connection/presentation/screens/tag_list_screen.dart';
import 'package:shellvault/features/settings/presentation/screens/settings_screen.dart';
import 'package:shellvault/features/snippet/presentation/screens/snippet_detail_screen.dart';
import 'package:shellvault/features/snippet/presentation/screens/snippet_form_screen.dart';
import 'package:shellvault/features/snippet/presentation/screens/snippet_list_screen.dart';
import 'package:shellvault/features/support/presentation/screens/support_screen.dart';
import 'package:shellvault/features/sync/presentation/screens/sync_settings_screen.dart';
import 'package:shellvault/features/terminal/presentation/screens/terminal_branch_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

abstract final class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
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

          // 1 — Snippets
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/snippets',
                builder: (context, state) => const SnippetListScreen(),
              ),
            ],
          ),

          // 2 — Groups
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/groups',
                builder: (context, state) => const GroupListScreen(),
              ),
            ],
          ),

          // 3 — Tags
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tags',
                builder: (context, state) => const TagListScreen(),
              ),
            ],
          ),

          // 4 — SSH Keys
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/keys',
                builder: (context, state) => const SshKeyListScreen(),
              ),
            ],
          ),

          // 5 — Export / Import
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/export-import',
                builder: (context, state) => const ExportImportScreen(),
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
        parentNavigatorKey: _rootNavigatorKey,
        path: '/server/new',
        builder: (context, state) => const ServerFormScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/server/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ServerDetailScreen(serverId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/server/:id/edit',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ServerFormScreen(serverId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/snippet/new',
        builder: (context, state) => const SnippetFormScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/snippet/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return SnippetDetailScreen(snippetId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/snippet/:id/edit',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return SnippetFormScreen(snippetId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),

      // Auth routes
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/sync-password',
        builder: (context, state) {
          final modeParam = state.uri.queryParameters['mode'];
          final mode = modeParam == 'enter'
              ? SyncPasswordMode.enter
              : SyncPasswordMode.create;
          return SyncPasswordScreen(mode: mode);
        },
      ),

      // Account / Sync routes
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/account',
        redirect: (_, _) => '/sync-settings',
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/server-config',
        builder: (context, state) => const ServerConfigScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/sync-settings',
        builder: (context, state) => const SyncSettingsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/support',
        builder: (context, state) => const SupportScreen(),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
