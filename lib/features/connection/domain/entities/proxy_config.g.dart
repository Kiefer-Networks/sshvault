// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proxy_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProxyConfig _$ProxyConfigFromJson(Map<String, dynamic> json) => _ProxyConfig(
  type: $enumDecodeNullable(_$ProxyTypeEnumMap, json['type']) ?? ProxyType.none,
  host: json['host'] as String? ?? '',
  port: (json['port'] as num?)?.toInt() ?? 1080,
  username: json['username'] as String?,
);

Map<String, dynamic> _$ProxyConfigToJson(_ProxyConfig instance) =>
    <String, dynamic>{
      'type': _$ProxyTypeEnumMap[instance.type]!,
      'host': instance.host,
      'port': instance.port,
      'username': instance.username,
    };

const _$ProxyTypeEnumMap = {
  ProxyType.none: 'none',
  ProxyType.socks5: 'socks5',
  ProxyType.httpConnect: 'httpConnect',
};
