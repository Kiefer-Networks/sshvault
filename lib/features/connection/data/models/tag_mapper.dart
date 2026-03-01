import 'package:drift/drift.dart';
import 'package:shellvault/core/crypto/field_crypto_service.dart';
import 'package:shellvault/core/storage/database.dart';
import 'package:shellvault/features/connection/domain/entities/tag_entity.dart';
abstract final class TagMapper {
  static TagEntity fromDrift(
    Tag row, {
    FieldCryptoService? crypto,
  }) {
    final name = crypto?.decryptField(row.name) ?? row.name;

    return TagEntity(
      id: row.id,
      name: name,
      color: row.color,
      ownerId: row.ownerId,
      sharedWith: row.sharedWith,
      permissions: row.permissions,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static TagsCompanion toCompanion(
    TagEntity entity, {
    FieldCryptoService? crypto,
  }) {
    final name = crypto?.encryptField(entity.name) ?? entity.name;

    return TagsCompanion(
      id: Value(entity.id),
      name: Value(name),
      color: Value(entity.color),
      ownerId: Value(entity.ownerId),
      sharedWith: Value(entity.sharedWith),
      permissions: Value(entity.permissions),
      createdAt: Value(entity.createdAt),
      updatedAt: Value(entity.updatedAt),
    );
  }
}
