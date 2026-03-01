import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_entity.freezed.dart';
part 'device_entity.g.dart';

@freezed
abstract class DeviceEntity with _$DeviceEntity {
  const factory DeviceEntity({
    required String id,
    required String name,
    @Default('') String platform,
    @JsonKey(name: 'last_sync') DateTime? lastSync,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _DeviceEntity;

  factory DeviceEntity.fromJson(Map<String, dynamic> json) =>
      _$DeviceEntityFromJson(json);
}
