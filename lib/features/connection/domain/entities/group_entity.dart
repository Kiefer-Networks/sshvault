import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_entity.freezed.dart';
part 'group_entity.g.dart';

@freezed
abstract class GroupEntity with _$GroupEntity {
  const factory GroupEntity({
    required String id,
    required String name,
    @Default(0xFF6C63FF) int color,
    @Default('server') String iconName,
    String? parentId,
    @Default(0) int sortOrder,
    @Default([]) List<GroupEntity> children,
    @Default(0) int serverCount,
    String? ownerId,
    String? sharedWith,
    String? permissions,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _GroupEntity;

  factory GroupEntity.fromJson(Map<String, dynamic> json) =>
      _$GroupEntityFromJson(json);
}
