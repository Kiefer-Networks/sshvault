import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/utils/validators.dart';
import 'package:shellvault/features/connection/domain/entities/server_credentials.dart';
import 'package:shellvault/features/connection/domain/entities/server_entity.dart';
import 'package:shellvault/features/connection/domain/entities/server_filter.dart';
import 'package:shellvault/features/connection/domain/repositories/server_repository.dart';

class ServerUseCases {
  final ServerRepository _repository;

  ServerUseCases(this._repository);

  Future<Result<List<ServerEntity>>> getServers({ServerFilter? filter}) {
    return _repository.getServers(filter: filter);
  }

  Future<Result<ServerEntity>> getServer(String id) {
    return _repository.getServer(id);
  }

  Future<Result<ServerEntity>> createServer(
    ServerEntity server,
    ServerCredentials? credentials,
  ) {
    final validation = _validate(server);
    if (validation != null) {
      return Future.value(Err(ValidationFailure(validation)));
    }
    return _repository.createServer(server, credentials);
  }

  Future<Result<ServerEntity>> updateServer(
    ServerEntity server,
    ServerCredentials? credentials,
  ) {
    final validation = _validate(server);
    if (validation != null) {
      return Future.value(Err(ValidationFailure(validation)));
    }
    return _repository.updateServer(server, credentials);
  }

  Future<Result<void>> deleteServer(String id) {
    return _repository.deleteServer(id);
  }

  Future<Result<ServerEntity>> duplicateServer(String id) {
    return _repository.duplicateServer(id);
  }

  Future<Result<void>> reorderServers(List<String> orderedIds) {
    return _repository.reorderServers(orderedIds);
  }

  Future<Result<ServerCredentials>> getCredentials(String serverId) {
    return _repository.getCredentials(serverId);
  }

  String? _validate(ServerEntity server) {
    return Validators.validateServerName(server.name) ??
        Validators.validateHostname(server.hostname) ??
        Validators.validatePort(server.port.toString()) ??
        Validators.validateUsername(server.username);
  }
}
