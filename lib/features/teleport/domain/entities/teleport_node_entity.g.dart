// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teleport_node_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeleportNodeEntity _$TeleportNodeEntityFromJson(Map<String, dynamic> json) =>
    _TeleportNodeEntity(
      id: json['id'] as String,
      clusterId: json['clusterId'] as String,
      clusterName: json['clusterName'] as String,
      hostname: json['hostname'] as String,
      addr: json['addr'] as String,
      labels:
          (json['labels'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      osType: json['osType'] as String? ?? '',
    );

Map<String, dynamic> _$TeleportNodeEntityToJson(_TeleportNodeEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clusterId': instance.clusterId,
      'clusterName': instance.clusterName,
      'hostname': instance.hostname,
      'addr': instance.addr,
      'labels': instance.labels,
      'osType': instance.osType,
    };
