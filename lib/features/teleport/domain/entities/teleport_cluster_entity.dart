import 'package:freezed_annotation/freezed_annotation.dart';

part 'teleport_cluster_entity.freezed.dart';
part 'teleport_cluster_entity.g.dart';

enum TeleportAuthMethod {
  local,
  ssoOidc,
  ssoSaml,
  identityFile,
}

@freezed
abstract class TeleportClusterEntity with _$TeleportClusterEntity {
  const factory TeleportClusterEntity({
    required String id,
    required String name,
    required String proxyAddr,
    @Default(TeleportAuthMethod.local) TeleportAuthMethod authMethod,
    @Default('') String username,
    @Default({}) Map<String, dynamic> metadata,
    DateTime? certExpiresAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TeleportClusterEntity;

  factory TeleportClusterEntity.fromJson(Map<String, dynamic> json) =>
      _$TeleportClusterEntityFromJson(json);
}
