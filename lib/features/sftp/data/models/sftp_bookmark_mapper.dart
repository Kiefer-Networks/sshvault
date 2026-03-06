import 'package:drift/drift.dart';
import 'package:sshvault/core/storage/database.dart';
import 'package:sshvault/features/sftp/domain/entities/sftp_bookmark_entity.dart';

abstract final class SftpBookmarkMapper {
  static SftpBookmarkEntity fromDrift(SftpBookmark row) {
    return SftpBookmarkEntity(
      id: row.id,
      serverId: row.serverId,
      path: row.path,
      label: row.label,
      sortOrder: row.sortOrder,
      createdAt: row.createdAt,
    );
  }

  static SftpBookmarksCompanion toCompanion(SftpBookmarkEntity entity) {
    return SftpBookmarksCompanion(
      id: Value(entity.id),
      serverId: Value(entity.serverId),
      path: Value(entity.path),
      label: Value(entity.label),
      sortOrder: Value(entity.sortOrder),
      createdAt: Value(entity.createdAt),
    );
  }
}
