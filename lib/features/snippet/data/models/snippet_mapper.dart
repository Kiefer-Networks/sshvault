import 'package:drift/drift.dart';
import 'package:shellvault/core/crypto/field_crypto_service.dart';
import 'package:shellvault/core/storage/database.dart';
import 'package:shellvault/features/snippet/domain/entities/snippet_entity.dart';

abstract final class SnippetMapper {
  static SnippetEntity fromDrift(
    Snippet row, {
    FieldCryptoService? crypto,
  }) {
    final name = crypto?.decryptField(row.name) ?? row.name;
    final content = crypto?.decryptField(row.content) ?? row.content;
    final description = crypto?.decryptNullableField(row.description) ?? row.description;
    final language = crypto?.decryptField(row.language) ?? row.language;

    return SnippetEntity(
      id: row.id,
      name: name,
      content: content,
      language: language,
      description: description,
      groupId: row.groupId,
      sortOrder: row.sortOrder,
      ownerId: row.ownerId,
      sharedWith: row.sharedWith,
      permissions: row.permissions,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static SnippetsCompanion toCompanion(
    SnippetEntity entity, {
    FieldCryptoService? crypto,
  }) {
    final name = crypto?.encryptField(entity.name) ?? entity.name;
    final content = crypto?.encryptField(entity.content) ?? entity.content;
    final description = crypto?.encryptNullableField(entity.description) ?? entity.description;
    final language = crypto?.encryptField(entity.language) ?? entity.language;

    return SnippetsCompanion(
      id: Value(entity.id),
      name: Value(name),
      content: Value(content),
      language: Value(language),
      description: Value(description),
      groupId: Value(entity.groupId),
      sortOrder: Value(entity.sortOrder),
      ownerId: Value(entity.ownerId),
      sharedWith: Value(entity.sharedWith),
      permissions: Value(entity.permissions),
      createdAt: Value(entity.createdAt),
      updatedAt: Value(entity.updatedAt),
    );
  }

  static SnippetVariableEntity variableFromDrift(
    SnippetVariable row, {
    FieldCryptoService? crypto,
  }) {
    final name = crypto?.decryptField(row.name) ?? row.name;
    final defaultValue = crypto?.decryptNullableField(row.defaultValue) ?? row.defaultValue;
    final description = crypto?.decryptNullableField(row.description) ?? row.description;

    return SnippetVariableEntity(
      id: row.id,
      name: name,
      defaultValue: defaultValue,
      description: description,
      sortOrder: row.sortOrder,
    );
  }

  static SnippetVariablesCompanion variableToCompanion(
    SnippetVariableEntity entity,
    String snippetId, {
    FieldCryptoService? crypto,
  }) {
    final name = crypto?.encryptField(entity.name) ?? entity.name;
    final defaultValue = crypto?.encryptNullableField(entity.defaultValue) ?? entity.defaultValue;
    final description = crypto?.encryptNullableField(entity.description) ?? entity.description;

    return SnippetVariablesCompanion(
      id: Value(entity.id),
      snippetId: Value(snippetId),
      name: Value(name),
      defaultValue: Value(defaultValue),
      description: Value(description),
      sortOrder: Value(entity.sortOrder),
    );
  }
}
