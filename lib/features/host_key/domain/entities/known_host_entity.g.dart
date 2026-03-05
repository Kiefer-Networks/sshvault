// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'known_host_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KnownHostEntity _$KnownHostEntityFromJson(Map<String, dynamic> json) =>
    _KnownHostEntity(
      id: json['id'] as String,
      hostname: json['hostname'] as String,
      port: (json['port'] as num).toInt(),
      keyType: json['keyType'] as String,
      fingerprint: json['fingerprint'] as String,
      trusted: json['trusted'] as bool? ?? true,
      firstSeenAt: DateTime.parse(json['firstSeenAt'] as String),
      lastSeenAt: DateTime.parse(json['lastSeenAt'] as String),
    );

Map<String, dynamic> _$KnownHostEntityToJson(_KnownHostEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hostname': instance.hostname,
      'port': instance.port,
      'keyType': instance.keyType,
      'fingerprint': instance.fingerprint,
      'trusted': instance.trusted,
      'firstSeenAt': instance.firstSeenAt.toIso8601String(),
      'lastSeenAt': instance.lastSeenAt.toIso8601String(),
    };
