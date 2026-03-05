import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/host_key/domain/entities/known_host_entity.dart';

abstract class KnownHostRepository {
  Future<Result<KnownHostEntity?>> findByHostAndPort(
    String hostname,
    int port,
  );
  Future<Result<List<KnownHostEntity>>> getAll();
  Future<Result<void>> save(KnownHostEntity entity);
  Future<Result<void>> delete(String id);
  Future<Result<void>> deleteAll();
}
