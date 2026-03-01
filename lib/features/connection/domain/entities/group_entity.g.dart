// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupEntity _$GroupEntityFromJson(Map<String, dynamic> json) => _GroupEntity(
  id: json['id'] as String,
  name: json['name'] as String,
  color: (json['color'] as num?)?.toInt() ?? 0xFF6C63FF,
  iconName: json['iconName'] as String? ?? 'server',
  parentId: json['parentId'] as String?,
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
  children:
      (json['children'] as List<dynamic>?)
          ?.map((e) => GroupEntity.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  serverCount: (json['serverCount'] as num?)?.toInt() ?? 0,
  ownerId: json['ownerId'] as String?,
  sharedWith: json['sharedWith'] as String?,
  permissions: json['permissions'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$GroupEntityToJson(_GroupEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
      'iconName': instance.iconName,
      'parentId': instance.parentId,
      'sortOrder': instance.sortOrder,
      'children': instance.children.map((e) => e.toJson()).toList(),
      'serverCount': instance.serverCount,
      'ownerId': instance.ownerId,
      'sharedWith': instance.sharedWith,
      'permissions': instance.permissions,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
