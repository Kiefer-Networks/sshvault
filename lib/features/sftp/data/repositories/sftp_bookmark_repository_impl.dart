import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/sftp/data/datasources/sftp_bookmark_dao.dart';
import 'package:shellvault/features/sftp/data/models/sftp_bookmark_mapper.dart';
import 'package:shellvault/features/sftp/domain/entities/sftp_bookmark_entity.dart';
import 'package:shellvault/features/sftp/domain/repositories/sftp_bookmark_repository.dart';

class SftpBookmarkRepositoryImpl implements SftpBookmarkRepository {
  final SftpBookmarkDao _dao;

  SftpBookmarkRepositoryImpl(this._dao);

  @override
  Future<Result<List<SftpBookmarkEntity>>> getByServerId(
    String serverId,
  ) async {
    try {
      final rows = await _dao.getByServerId(serverId);
      return Success(rows.map(SftpBookmarkMapper.fromDrift).toList());
    } catch (e) {
      return Err(DatabaseFailure('Failed to load bookmarks', cause: e));
    }
  }

  @override
  Future<Result<void>> save(SftpBookmarkEntity entity) async {
    try {
      final companion = SftpBookmarkMapper.toCompanion(entity);
      await _dao.insertBookmark(companion);
      return const Success(null);
    } catch (e) {
      return Err(DatabaseFailure('Failed to save bookmark', cause: e));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await _dao.deleteById(id);
      return const Success(null);
    } catch (e) {
      return Err(DatabaseFailure('Failed to delete bookmark', cause: e));
    }
  }
}
