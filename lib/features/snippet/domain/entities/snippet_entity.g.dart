// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snippet_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SnippetEntity _$SnippetEntityFromJson(Map<String, dynamic> json) =>
    _SnippetEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      content: json['content'] as String,
      language: json['language'] as String? ?? 'bash',
      description: json['description'] as String? ?? '',
      groupId: json['groupId'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      tags:
          (json['tags'] as List<dynamic>?)
              ?.map((e) => TagEntity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      variables:
          (json['variables'] as List<dynamic>?)
              ?.map(
                (e) =>
                    SnippetVariableEntity.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      ownerId: json['ownerId'] as String?,
      sharedWith: json['sharedWith'] as String?,
      permissions: json['permissions'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SnippetEntityToJson(_SnippetEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'content': instance.content,
      'language': instance.language,
      'description': instance.description,
      'groupId': instance.groupId,
      'sortOrder': instance.sortOrder,
      'tags': instance.tags.map((e) => e.toJson()).toList(),
      'variables': instance.variables.map((e) => e.toJson()).toList(),
      'ownerId': instance.ownerId,
      'sharedWith': instance.sharedWith,
      'permissions': instance.permissions,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_SnippetVariableEntity _$SnippetVariableEntityFromJson(
  Map<String, dynamic> json,
) => _SnippetVariableEntity(
  id: json['id'] as String,
  name: json['name'] as String,
  defaultValue: json['defaultValue'] as String? ?? '',
  description: json['description'] as String? ?? '',
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SnippetVariableEntityToJson(
  _SnippetVariableEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'defaultValue': instance.defaultValue,
  'description': instance.description,
  'sortOrder': instance.sortOrder,
};
