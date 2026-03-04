// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teleport_cluster_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeleportClusterEntity _$TeleportClusterEntityFromJson(
  Map<String, dynamic> json,
) => _TeleportClusterEntity(
  id: json['id'] as String,
  name: json['name'] as String,
  proxyAddr: json['proxyAddr'] as String,
  authMethod:
      $enumDecodeNullable(_$TeleportAuthMethodEnumMap, json['authMethod']) ??
      TeleportAuthMethod.local,
  username: json['username'] as String? ?? '',
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
  certExpiresAt: json['certExpiresAt'] == null
      ? null
      : DateTime.parse(json['certExpiresAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TeleportClusterEntityToJson(
  _TeleportClusterEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'proxyAddr': instance.proxyAddr,
  'authMethod': _$TeleportAuthMethodEnumMap[instance.authMethod]!,
  'username': instance.username,
  'metadata': instance.metadata,
  'certExpiresAt': instance.certExpiresAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$TeleportAuthMethodEnumMap = {
  TeleportAuthMethod.local: 'local',
  TeleportAuthMethod.ssoOidc: 'ssoOidc',
  TeleportAuthMethod.ssoSaml: 'ssoSaml',
  TeleportAuthMethod.identityFile: 'identityFile',
};
