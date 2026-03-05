import 'package:freezed_annotation/freezed_annotation.dart';

part 'known_host_entity.freezed.dart';
part 'known_host_entity.g.dart';

@freezed
abstract class KnownHostEntity with _$KnownHostEntity {
  const factory KnownHostEntity({
    required String id,
    required String hostname,
    required int port,
    required String keyType,
    required String fingerprint,
    @Default(true) bool trusted,
    required DateTime firstSeenAt,
    required DateTime lastSeenAt,
  }) = _KnownHostEntity;

  factory KnownHostEntity.fromJson(Map<String, dynamic> json) =>
      _$KnownHostEntityFromJson(json);
}
