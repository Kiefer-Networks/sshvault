import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shellvault/core/utils/auto_sync_mixin.dart';
import 'package:shellvault/features/connection/domain/entities/group_entity.dart';
import 'package:shellvault/features/connection/domain/entities/server_credentials.dart';
import 'package:shellvault/features/connection/domain/entities/server_entity.dart';
import 'package:shellvault/features/connection/domain/entities/server_filter.dart';
import 'package:shellvault/features/connection/presentation/providers/folder_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/repository_providers.dart';

enum ViewMode { list, grid }

final viewModeProvider = StateProvider<ViewMode>((ref) => ViewMode.list);

final serverFilterProvider = StateProvider<ServerFilter>(
  (ref) => const ServerFilter(),
);

final serverListProvider =
    AsyncNotifierProvider<ServerListNotifier, List<ServerEntity>>(
      ServerListNotifier.new,
    );

class ServerListNotifier extends AsyncNotifier<List<ServerEntity>>
    with AutoSyncMixin {
  @override
  Future<List<ServerEntity>> build() async {
    final filter = ref.watch(serverFilterProvider);
    final useCases = ref.watch(serverUseCasesProvider);
    final result = await useCases.getServers(filter: filter);
    return result.fold(
      onSuccess: (servers) => servers,
      onFailure: (failure) => throw failure,
    );
  }

  void _invalidateAll({String? serverId}) {
    ref.invalidateSelf();
    if (serverId != null) {
      ref.invalidate(serverDetailProvider(serverId));
      ref.invalidate(serverCredentialsProvider(serverId));
    }
    triggerAutoSync();
  }

  Future<void> createServer(
    ServerEntity server,
    ServerCredentials? credentials,
  ) async {
    final useCases = ref.read(serverUseCasesProvider);
    final result = await useCases.createServer(server, credentials);
    result.fold(
      onSuccess: (created) => _invalidateAll(serverId: created.id),
      onFailure: (failure) => throw failure,
    );
  }

  Future<void> updateServer(
    ServerEntity server,
    ServerCredentials? credentials,
  ) async {
    final useCases = ref.read(serverUseCasesProvider);
    final result = await useCases.updateServer(server, credentials);
    result.fold(
      onSuccess: (_) => _invalidateAll(serverId: server.id),
      onFailure: (failure) => throw failure,
    );
  }

  Future<void> deleteServer(String id) async {
    final useCases = ref.read(serverUseCasesProvider);
    final result = await useCases.deleteServer(id);
    result.fold(
      onSuccess: (_) => _invalidateAll(serverId: id),
      onFailure: (failure) => throw failure,
    );
  }

  Future<void> duplicateServer(String id, {required String copySuffix}) async {
    final useCases = ref.read(serverUseCasesProvider);
    final result = await useCases.duplicateServer(id, copySuffix: copySuffix);
    result.fold(
      onSuccess: (dup) => _invalidateAll(serverId: dup.id),
      onFailure: (failure) => throw failure,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Servers belonging to a specific group.
final serversByGroupProvider =
    FutureProvider.family<List<ServerEntity>, String>((ref, groupId) async {
      final useCases = ref.watch(serverUseCasesProvider);
      final result = await useCases.getServers(
        filter: ServerFilter(groupId: groupId),
      );
      return result.fold(
        onSuccess: (servers) => servers,
        onFailure: (failure) => throw failure,
      );
    });

final serverDetailProvider = FutureProvider.family<ServerEntity, String>((
  ref,
  id,
) async {
  final useCases = ref.watch(serverUseCasesProvider);
  final result = await useCases.getServer(id);
  return result.fold(
    onSuccess: (server) => server,
    onFailure: (failure) => throw failure,
  );
});

/// Server count for a specific tag.
final serverCountByTagProvider = FutureProvider.family<int, String>((
  ref,
  tagId,
) async {
  final useCases = ref.watch(serverUseCasesProvider);
  final result = await useCases.getServers(
    filter: ServerFilter(tagIds: [tagId]),
  );
  return result.fold(
    onSuccess: (servers) => servers.length,
    onFailure: (_) => 0,
  );
});

final serverCredentialsProvider =
    FutureProvider.family<ServerCredentials, String>((ref, serverId) async {
      final useCases = ref.watch(serverUseCasesProvider);
      final result = await useCases.getCredentials(serverId);
      return result.fold(
        onSuccess: (creds) => creds,
        onFailure: (failure) => throw failure,
      );
    });

class FolderServerGroup {
  final GroupEntity? folder;
  final List<ServerEntity> servers;
  final int depth;

  const FolderServerGroup({
    this.folder,
    required this.servers,
    this.depth = 0,
  });
}

final folderGroupedServersProvider =
    FutureProvider<List<FolderServerGroup>>((ref) async {
  final useCases = ref.watch(serverUseCasesProvider);
  final treeResult = await ref.watch(folderTreeProvider.future);
  final allServersResult = await useCases.getServers();
  final allServers = allServersResult.fold(
    onSuccess: (s) => s,
    onFailure: (f) => throw f,
  );

  final serversByFolder = <String?, List<ServerEntity>>{};
  for (final server in allServers) {
    (serversByFolder[server.groupId] ??= []).add(server);
  }

  final groups = <FolderServerGroup>[];

  void addFolder(GroupEntity folder, int depth) {
    final servers = serversByFolder.remove(folder.id) ?? [];
    if (servers.isNotEmpty || folder.children.isNotEmpty) {
      groups.add(FolderServerGroup(
        folder: folder,
        servers: servers,
        depth: depth,
      ));
    }
    for (final child in folder.children) {
      addFolder(child, depth + 1);
    }
  }

  for (final root in treeResult) {
    addFolder(root, 0);
  }

  // "Uncategorized" at the end
  final uncategorized = serversByFolder[null] ?? [];
  if (uncategorized.isNotEmpty) {
    groups.add(FolderServerGroup(servers: uncategorized));
  }

  return groups;
});
