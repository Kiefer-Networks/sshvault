import 'package:drift/drift.dart';
import 'package:shellvault/core/storage/database.dart';
import 'package:shellvault/features/snippet/domain/entities/snippet_entity.dart';

abstract final class SnippetMapper {
  static SnippetEntity fromDrift(Snippet row) {
    return SnippetEntity(
      id: row.id,
      name: row.name,
      content: row.content,
      language: row.language,
      description: row.description,
      groupId: row.groupId,
      sortOrder: row.sortOrder,
      ownerId: row.ownerId,
      sharedWith: row.sharedWith,
      permissions: row.permissions,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static SnippetsCompanion toCompanion(SnippetEntity entity) {
    return SnippetsCompanion(
      id: Value(entity.id),
      name: Value(entity.name),
      content: Value(entity.content),
      language: Value(entity.language),
      description: Value(entity.description),
      groupId: Value(entity.groupId),
      sortOrder: Value(entity.sortOrder),
      ownerId: Value(entity.ownerId),
      sharedWith: Value(entity.sharedWith),
      permissions: Value(entity.permissions),
      createdAt: Value(entity.createdAt),
      updatedAt: Value(entity.updatedAt),
    );
  }

  static SnippetVariableEntity variableFromDrift(SnippetVariable row) {
    return SnippetVariableEntity(
      id: row.id,
      name: row.name,
      defaultValue: row.defaultValue,
      description: row.description,
      sortOrder: row.sortOrder,
    );
  }

  static SnippetVariablesCompanion variableToCompanion(
    SnippetVariableEntity entity,
    String snippetId,
  ) {
    return SnippetVariablesCompanion(
      id: Value(entity.id),
      snippetId: Value(snippetId),
      name: Value(entity.name),
      defaultValue: Value(entity.defaultValue),
      description: Value(entity.description),
      sortOrder: Value(entity.sortOrder),
    );
  }
}
