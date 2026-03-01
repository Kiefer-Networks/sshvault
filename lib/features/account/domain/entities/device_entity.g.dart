// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeviceEntity _$DeviceEntityFromJson(Map<String, dynamic> json) =>
    _DeviceEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      platform: json['platform'] as String? ?? '',
      lastSync: json['last_sync'] == null
          ? null
          : DateTime.parse(json['last_sync'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$DeviceEntityToJson(_DeviceEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'platform': instance.platform,
      'last_sync': instance.lastSync?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };
