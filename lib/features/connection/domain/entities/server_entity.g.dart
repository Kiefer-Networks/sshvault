// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServerEntity _$ServerEntityFromJson(Map<String, dynamic> json) =>
    _ServerEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      hostname: json['hostname'] as String,
      port: (json['port'] as num).toInt(),
      username: json['username'] as String,
      authMethod: $enumDecode(_$AuthMethodEnumMap, json['authMethod']),
      notes: json['notes'] as String? ?? '',
      color: (json['color'] as num).toInt(),
      iconName: json['iconName'] as String? ?? 'server',
      isActive: json['isActive'] as bool? ?? true,
      groupId: json['groupId'] as String?,
      sshKeyId: json['sshKeyId'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      distroId: json['distroId'] as String?,
      distroName: json['distroName'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)
              ?.map((e) => TagEntity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      jumpHostId: json['jumpHostId'] as String?,
      ownerId: json['ownerId'] as String?,
      sharedWith: json['sharedWith'] as String?,
      permissions: json['permissions'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ServerEntityToJson(_ServerEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'hostname': instance.hostname,
      'port': instance.port,
      'username': instance.username,
      'authMethod': _$AuthMethodEnumMap[instance.authMethod]!,
      'notes': instance.notes,
      'color': instance.color,
      'iconName': instance.iconName,
      'isActive': instance.isActive,
      'groupId': instance.groupId,
      'sshKeyId': instance.sshKeyId,
      'sortOrder': instance.sortOrder,
      'distroId': instance.distroId,
      'distroName': instance.distroName,
      'tags': instance.tags.map((e) => e.toJson()).toList(),
      'jumpHostId': instance.jumpHostId,
      'ownerId': instance.ownerId,
      'sharedWith': instance.sharedWith,
      'permissions': instance.permissions,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$AuthMethodEnumMap = {
  AuthMethod.password: 'password',
  AuthMethod.key: 'key',
  AuthMethod.both: 'both',
};
