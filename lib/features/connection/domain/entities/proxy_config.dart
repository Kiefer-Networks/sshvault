import 'package:freezed_annotation/freezed_annotation.dart';

part 'proxy_config.freezed.dart';
part 'proxy_config.g.dart';

enum ProxyType { none, socks5, httpConnect }

@freezed
abstract class ProxyConfig with _$ProxyConfig {
  const factory ProxyConfig({
    @Default(ProxyType.none) ProxyType type,
    @Default('') String host,
    @Default(1080) int port,
    String? username,
  }) = _ProxyConfig;

  factory ProxyConfig.fromJson(Map<String, dynamic> json) =>
      _$ProxyConfigFromJson(json);
}
