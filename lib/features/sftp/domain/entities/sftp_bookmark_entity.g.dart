// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sftp_bookmark_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SftpBookmarkEntity _$SftpBookmarkEntityFromJson(Map<String, dynamic> json) =>
    _SftpBookmarkEntity(
      id: json['id'] as String,
      serverId: json['serverId'] as String,
      path: json['path'] as String,
      label: json['label'] as String,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$SftpBookmarkEntityToJson(_SftpBookmarkEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serverId': instance.serverId,
      'path': instance.path,
      'label': instance.label,
      'sortOrder': instance.sortOrder,
      'createdAt': instance.createdAt.toIso8601String(),
    };
