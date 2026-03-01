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

final _rootNavigatorKey = GlobalKey<NavigatorState>();

abstract final class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // ------------------------------------------------------------------
      // Shell: indexed‐stack keeps each branch's state alive.
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

          // 1 — Groups
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/groups',
                builder: (context, state) => const GroupListScreen(),
              ),
            ],
          ),

          // 2 — Tags
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tags',
                builder: (context, state) => const TagListScreen(),
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

          // 4 — Export / Import
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
      // Back button works automatically.
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
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}
