import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/features/host_key/data/datasources/known_host_dao.dart';
import 'package:sshvault/features/host_key/data/models/known_host_mapper.dart';
import 'package:sshvault/features/host_key/domain/entities/known_host_entity.dart';
import 'package:sshvault/features/host_key/domain/repositories/known_host_repository.dart';

class KnownHostRepositoryImpl implements KnownHostRepository {
  final KnownHostDao _dao;

  KnownHostRepositoryImpl(this._dao);

  @override
  Future<Result<KnownHostEntity?>> findByHostAndPort(
    String hostname,
    int port,
  ) async {
    try {
      final row = await _dao.findByHostAndPort(hostname, port);
      if (row == null) return const Success(null);
      return Success(KnownHostMapper.fromDrift(row));
    } catch (e) {
      return Err(DatabaseFailure('Failed to find known host', cause: e));
    }
  }

  @override
  Future<Result<List<KnownHostEntity>>> getAll() async {
    try {
      final rows = await _dao.getAll();
      return Success(rows.map(KnownHostMapper.fromDrift).toList());
    } catch (e) {
      return Err(DatabaseFailure('Failed to load known hosts', cause: e));
    }
  }

  @override
  Future<Result<void>> save(KnownHostEntity entity) async {
    try {
      final existing = await _dao.findByHostAndPort(
        entity.hostname,
        entity.port,
      );
      final companion = KnownHostMapper.toCompanion(entity);
      if (existing != null) {
        await _dao.updateKnownHost(companion);
      } else {
        await _dao.insertKnownHost(companion);
      }
      return const Success(null);
    } catch (e) {
      return Err(DatabaseFailure('Failed to save known host', cause: e));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await _dao.deleteById(id);
      return const Success(null);
    } catch (e) {
      return Err(DatabaseFailure('Failed to delete known host', cause: e));
    }
  }

  @override
  Future<Result<void>> deleteAll() async {
    try {
      await _dao.deleteAll();
      return const Success(null);
    } catch (e) {
      return Err(DatabaseFailure('Failed to delete all known hosts', cause: e));
    }
  }
}
