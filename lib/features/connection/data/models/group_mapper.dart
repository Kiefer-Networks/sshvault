import 'package:drift/drift.dart';
import 'package:shellvault/core/crypto/field_crypto_service.dart';
import 'package:shellvault/core/storage/database.dart';
import 'package:shellvault/features/connection/domain/entities/group_entity.dart';
abstract final class GroupMapper {
  static GroupEntity fromDrift(
    Group row, {
    List<GroupEntity> children = const [],
    int serverCount = 0,
    FieldCryptoService? crypto,
  }) {
    final name = crypto?.decryptField(row.name) ?? row.name;
    final iconName = crypto?.decryptNullableField(row.iconName) ?? row.iconName;

    return GroupEntity(
      id: row.id,
      name: name,
      color: row.color,
      iconName: iconName,
      parentId: row.parentId,
      sortOrder: row.sortOrder,
      children: children,
      serverCount: serverCount,
      ownerId: row.ownerId,
      sharedWith: row.sharedWith,
      permissions: row.permissions,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static GroupsCompanion toCompanion(
    GroupEntity entity, {
    FieldCryptoService? crypto,
  }) {
    final name = crypto?.encryptField(entity.name) ?? entity.name;
    final iconName = crypto?.encryptNullableField(entity.iconName) ?? entity.iconName;

    return GroupsCompanion(
      id: Value(entity.id),
      name: Value(name),
      color: Value(entity.color),
      iconName: Value(iconName),
      parentId: Value(entity.parentId),
      sortOrder: Value(entity.sortOrder),
      ownerId: Value(entity.ownerId),
      sharedWith: Value(entity.sharedWith),
      permissions: Value(entity.permissions),
      createdAt: Value(entity.createdAt),
      updatedAt: Value(entity.updatedAt),
    );
  }
}
