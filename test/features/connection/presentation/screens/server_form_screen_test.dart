import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/features/connection/domain/entities/auth_method.dart';
import 'package:sshvault/features/connection/domain/entities/group_entity.dart';
import 'package:sshvault/features/connection/domain/entities/server_credentials.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/connection/domain/entities/tag_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/folder_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/ssh_agent_provider.dart';
import 'package:sshvault/features/connection/presentation/providers/tag_providers.dart';
import 'package:sshvault/features/connection/presentation/screens/server_form_screen.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

class _Folders extends FolderListNotifier {
  @override
  Future<List<GroupEntity>> build() async => [];
}

class _Tags extends TagListNotifier {
  @override
  Future<List<TagEntity>> build() async => [];
}

class _Servers extends ServerListNotifier {
  final ServerEntity original;
  ServerEntity? saved;
  _Servers(this.original);
  @override
  Future<List<ServerEntity>> build() async => [original];
  @override
  Future<void> updateServer(
    ServerEntity server,
    ServerCredentials? credentials,
  ) async {
    saved = server;
  }
}

void main() {
  testWidgets(
    'editing a server name preserves favorite and non-form metadata',
    (tester) async {
      final original = ServerEntity(
        id: 'server',
        name: 'Before edit',
        hostname: 'example.com',
        port: 22,
        username: 'user',
        authMethod: AuthMethod.password,
        color: 0xff123456,
        createdAt: DateTime(2024, 2, 3),
        updatedAt: DateTime(2025, 3, 4),
        isFavorite: true,
        lastConnectedAt: DateTime(2026, 4, 5),
        sortOrder: 7,
        distroId: 'ubuntu',
        distroName: 'Ubuntu 24.04',
        ownerId: 'owner',
        sharedWith: 'team',
        permissions: 'read-write',
      );
      final servers = _Servers(original);
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const Scaffold(body: Text('Home')),
          ),
          GoRoute(
            path: '/edit',
            builder: (_, _) => const ServerFormScreen(serverId: 'server'),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            serverDetailProvider('server').overrideWith((_) async => original),
            serverCredentialsProvider(
              'server',
            ).overrideWith((_) async => const ServerCredentials()),
            folderListProvider.overrideWith(_Folders.new),
            tagListProvider.overrideWith(_Tags.new),
            serverListProvider.overrideWith(() => servers),
            sshAgentAvailableProvider.overrideWith((_) async => false),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
          ),
        ),
      );
      router.push('/edit');
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Before edit'),
        'After edit',
      );
      await tester.tap(find.widgetWithText(TextButton, 'Save'));
      await tester.pumpAndSettle();
      final saved = servers.saved!;
      expect(saved.name, 'After edit');
      expect(saved.isFavorite, isTrue);
      expect(saved.lastConnectedAt, DateTime(2026, 4, 5));
      expect(saved.createdAt, DateTime(2024, 2, 3));
      expect(saved.sortOrder, 7);
      expect(saved.distroId, 'ubuntu');
      expect(saved.distroName, 'Ubuntu 24.04');
      expect(saved.ownerId, 'owner');
      expect(saved.sharedWith, 'team');
      expect(saved.permissions, 'read-write');
      expect(tester.takeException(), isNull);
    },
  );
}
