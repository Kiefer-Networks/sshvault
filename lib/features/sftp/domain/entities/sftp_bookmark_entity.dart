import 'package:freezed_annotation/freezed_annotation.dart';

part 'sftp_bookmark_entity.freezed.dart';
part 'sftp_bookmark_entity.g.dart';

@freezed
abstract class SftpBookmarkEntity with _$SftpBookmarkEntity {
  const factory SftpBookmarkEntity({
    required String id,
    required String serverId,
    required String path,
    required String label,
    @Default(0) int sortOrder,
    required DateTime createdAt,
  }) = _SftpBookmarkEntity;

  factory SftpBookmarkEntity.fromJson(Map<String, dynamic> json) =>
      _$SftpBookmarkEntityFromJson(json);
}
