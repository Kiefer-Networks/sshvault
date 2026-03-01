import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/features/connection/domain/entities/server_credentials.dart';
import 'package:shellvault/features/connection/domain/entities/server_entity.dart';
import 'package:shellvault/features/connection/domain/entities/server_filter.dart';
import 'package:shellvault/features/connection/presentation/providers/repository_providers.dart';

enum ViewMode { list, grid }

final viewModeProvider = StateProvider<ViewMode>((ref) => ViewMode.list);

final serverFilterProvider =
    StateProvider<ServerFilter>((ref) => const ServerFilter());

final serverListProvider =
    AsyncNotifierProvider<ServerListNotifier, List<ServerEntity>>(
  ServerListNotifier.new,
);

class ServerListNotifier extends AsyncNotifier<List<ServerEntity>> {
  @override
  Future<List<ServerEntity>> build() async {
    final filter = ref.watch(serverFilterProvider);
    final useCases = ref.watch(serverUseCasesProvider);
    final result = await useCases.getServers(filter: filter);
    return result.fold(
      onSuccess: (servers) => servers,
      onFailure: (failure) => throw Exception(failure.message),
    );
  }

  void _invalidateAll({String? serverId}) {
    ref.invalidateSelf();
    if (serverId != null) {
      ref.invalidate(serverDetailProvider(serverId));
      ref.invalidate(serverCredentialsProvider(serverId));
    }
  }

  Future<void> createServer(
    ServerEntity server,
    ServerCredentials? credentials,
  ) async {
    final useCases = ref.read(serverUseCasesProvider);
    final result = await useCases.createServer(server, credentials);
    result.fold(
      onSuccess: (created) => _invalidateAll(serverId: created.id),
      onFailure: (failure) => throw Exception(failure.message),
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
      onFailure: (failure) => throw Exception(failure.message),
    );
  }

  Future<void> deleteServer(String id) async {
    final useCases = ref.read(serverUseCasesProvider);
    final result = await useCases.deleteServer(id);
    result.fold(
      onSuccess: (_) => _invalidateAll(serverId: id),
      onFailure: (failure) => throw Exception(failure.message),
    );
  }

  Future<void> duplicateServer(String id, {required String copySuffix}) async {
    final useCases = ref.read(serverUseCasesProvider);
    final result = await useCases.duplicateServer(id, copySuffix: copySuffix);
    result.fold(
      onSuccess: (dup) => _invalidateAll(serverId: dup.id),
      onFailure: (failure) => throw Exception(failure.message),
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
    onFailure: (failure) => throw Exception(failure.message),
  );
});

final serverDetailProvider =
    FutureProvider.family<ServerEntity, String>((ref, id) async {
  final useCases = ref.watch(serverUseCasesProvider);
  final result = await useCases.getServer(id);
  return result.fold(
    onSuccess: (server) => server,
    onFailure: (failure) => throw Exception(failure.message),
  );
});

final serverCredentialsProvider =
    FutureProvider.family<ServerCredentials, String>((ref, serverId) async {
  final useCases = ref.watch(serverUseCasesProvider);
  final result = await useCases.getCredentials(serverId);
  return result.fold(
    onSuccess: (creds) => creds,
    onFailure: (failure) => throw Exception(failure.message),
  );
});
