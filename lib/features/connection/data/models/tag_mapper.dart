import 'package:drift/drift.dart';
import 'package:shellvault/core/storage/database.dart';
import 'package:shellvault/features/connection/domain/entities/tag_entity.dart';
abstract final class TagMapper {
  static TagEntity fromDrift(Tag row) {
    return TagEntity(
      id: row.id,
      name: row.name,
      color: row.color,
      ownerId: row.ownerId,
      sharedWith: row.sharedWith,
      permissions: row.permissions,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static TagsCompanion toCompanion(TagEntity entity) {
    return TagsCompanion(
      id: Value(entity.id),
      name: Value(entity.name),
      color: Value(entity.color),
      ownerId: Value(entity.ownerId),
      sharedWith: Value(entity.sharedWith),
      permissions: Value(entity.permissions),
      createdAt: Value(entity.createdAt),
      updatedAt: Value(entity.updatedAt),
    );
  }
}
