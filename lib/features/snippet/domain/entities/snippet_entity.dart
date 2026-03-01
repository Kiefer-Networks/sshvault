import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shellvault/features/connection/domain/entities/tag_entity.dart';

part 'snippet_entity.freezed.dart';
part 'snippet_entity.g.dart';

@freezed
abstract class SnippetEntity with _$SnippetEntity {
  const factory SnippetEntity({
    required String id,
    required String name,
    required String content,
    @Default('bash') String language,
    @Default('') String description,
    String? groupId,
    @Default(0) int sortOrder,
    @Default([]) List<TagEntity> tags,
    @Default([]) List<SnippetVariableEntity> variables,
    String? ownerId,
    String? sharedWith,
    String? permissions,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SnippetEntity;

  factory SnippetEntity.fromJson(Map<String, dynamic> json) =>
      _$SnippetEntityFromJson(json);
}

@freezed
abstract class SnippetVariableEntity with _$SnippetVariableEntity {
  const factory SnippetVariableEntity({
    required String id,
    required String name,
    @Default('') String defaultValue,
    @Default('') String description,
    @Default(0) int sortOrder,
  }) = _SnippetVariableEntity;

  factory SnippetVariableEntity.fromJson(Map<String, dynamic> json) =>
      _$SnippetVariableEntityFromJson(json);
}
