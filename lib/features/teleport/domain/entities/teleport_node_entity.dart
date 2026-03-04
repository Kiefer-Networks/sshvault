import 'package:freezed_annotation/freezed_annotation.dart';

part 'teleport_node_entity.freezed.dart';
part 'teleport_node_entity.g.dart';

@freezed
abstract class TeleportNodeEntity with _$TeleportNodeEntity {
  const factory TeleportNodeEntity({
    required String id,
    required String clusterId,
    required String clusterName,
    required String hostname,
    required String addr,
    @Default({}) Map<String, String> labels,
    @Default('') String osType,
  }) = _TeleportNodeEntity;

  factory TeleportNodeEntity.fromJson(Map<String, dynamic> json) =>
      _$TeleportNodeEntityFromJson(json);
}
