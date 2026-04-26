// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ssh_key_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SshKeyEntity _$SshKeyEntityFromJson(Map<String, dynamic> json) =>
    _SshKeyEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      keyType: $enumDecode(_$SshKeyTypeEnumMap, json['keyType']),
      fingerprint: json['fingerprint'] as String? ?? '',
      publicKey: json['publicKey'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      linkedServerCount: (json['linkedServerCount'] as num?)?.toInt() ?? 0,
      ownerId: json['ownerId'] as String?,
      sharedWith: json['sharedWith'] as String?,
      permissions: json['permissions'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$SshKeyEntityToJson(_SshKeyEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'keyType': _$SshKeyTypeEnumMap[instance.keyType]!,
      'fingerprint': instance.fingerprint,
      'publicKey': instance.publicKey,
      'comment': instance.comment,
      'linkedServerCount': instance.linkedServerCount,
      'ownerId': instance.ownerId,
      'sharedWith': instance.sharedWith,
      'permissions': instance.permissions,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };

const _$SshKeyTypeEnumMap = {
  SshKeyType.rsa: 'rsa',
  SshKeyType.ecdsa256: 'ecdsa256',
  SshKeyType.ecdsa384: 'ecdsa384',
  SshKeyType.ecdsa521: 'ecdsa521',
  SshKeyType.ed25519: 'ed25519',
};
