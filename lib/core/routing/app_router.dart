import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/core/routing/app_shell.dart';
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
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}
