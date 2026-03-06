import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/sftp/domain/entities/sftp_bookmark_entity.dart';

abstract class SftpBookmarkRepository {
  Future<Result<List<SftpBookmarkEntity>>> getByServerId(String serverId);
  Future<Result<void>> save(SftpBookmarkEntity entity);
  Future<Result<void>> delete(String id);
}
