import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/connection/domain/entities/server_credentials.dart';
import 'package:shellvault/features/connection/domain/entities/server_entity.dart';
import 'package:shellvault/features/connection/domain/entities/server_filter.dart';

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
  Future<Result<ServerEntity>> duplicateServer(String id);
  Future<Result<void>> reorderServers(List<String> orderedIds);
  Future<Result<ServerCredentials>> getCredentials(String serverId);
}
