// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TagEntity _$TagEntityFromJson(Map<String, dynamic> json) => _TagEntity(
  id: json['id'] as String,
  name: json['name'] as String,
  color: (json['color'] as num?)?.toInt() ?? 0xFF6C63FF,
  ownerId: json['ownerId'] as String?,
  sharedWith: json['sharedWith'] as String?,
  permissions: json['permissions'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TagEntityToJson(_TagEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
      'ownerId': instance.ownerId,
      'sharedWith': instance.sharedWith,
      'permissions': instance.permissions,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
