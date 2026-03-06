import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/features/connection/domain/entities/server_credentials.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/connection/domain/entities/server_filter.dart';

abstract class ServerRepository {
  Future<Result<List<ServerEntity>>> getServers({ServerFilter? filter});
  Future<Result<ServerEntity>> getServer(String id);
  Future<Result<ServerEntity>> createServer(
    ServerEntity server,
    ServerCredentials? credentials,
  );
  Future<Result<ServerEntity>> updateServer(
    ServerEntity server,
    ServerCredentials? credentials,
  );
  Future<Result<void>> deleteServer(String id);
  Future<Result<ServerEntity>> duplicateServer(
    String id, {
    required String copySuffix,
  });
  Future<Result<void>> reorderServers(List<String> orderedIds);
  Future<Result<ServerCredentials>> getCredentials(String serverId);
  Future<Result<void>> toggleFavorite(String id, bool value);
  Future<Result<void>> setLastConnectedAt(String id, DateTime time);
  Future<Result<List<ServerEntity>>> getFavorites();
  Future<Result<List<ServerEntity>>> getRecents({int limit = 5});
}
