import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/features/connection/presentation/screens/server_list_screen.dart';
import 'package:shellvault/features/connection/presentation/screens/server_detail_screen.dart';
import 'package:shellvault/features/connection/presentation/screens/server_form_screen.dart';
import 'package:shellvault/features/connection/presentation/screens/group_list_screen.dart';
import 'package:shellvault/features/connection/presentation/screens/tag_list_screen.dart';
import 'package:shellvault/features/connection/presentation/screens/export_import_screen.dart';
import 'package:shellvault/features/connection/presentation/screens/ssh_key_list_screen.dart';

abstract final class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ServerListScreen(),
      ),
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
        path: '/groups',
        builder: (context, state) => const GroupListScreen(),
      ),
      GoRoute(
        path: '/tags',
        builder: (context, state) => const TagListScreen(),
      ),
      GoRoute(
        path: '/keys',
        builder: (context, state) => const SshKeyListScreen(),
      ),
      GoRoute(
        path: '/export-import',
        builder: (context, state) => const ExportImportScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}
