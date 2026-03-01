import 'package:drift/drift.dart';
import 'package:shellvault/core/crypto/field_crypto_service.dart';
import 'package:shellvault/core/storage/database.dart';
import 'package:shellvault/features/connection/domain/entities/auth_method.dart';
import 'package:shellvault/features/connection/domain/entities/server_entity.dart';
import 'package:shellvault/features/connection/domain/entities/tag_entity.dart';
abstract final class ServerMapper {
  static ServerEntity fromDrift(
    Server row, {
    List<TagEntity> tags = const [],
    FieldCryptoService? crypto,
  }) {
    final name = crypto?.decryptField(row.name) ?? row.name;
    final hostname = crypto?.decryptField(row.hostname) ?? row.hostname;
    final username = crypto?.decryptField(row.username) ?? row.username;
    final notes = crypto?.decryptNullableField(row.notes) ?? row.notes;
    final authMethod = crypto?.decryptField(row.authMethod) ?? row.authMethod;
    final iconName = crypto?.decryptNullableField(row.iconName) ?? row.iconName;

    return ServerEntity(
      id: row.id,
      name: name,
      hostname: hostname,
      port: row.port,
      username: username,
      authMethod: AuthMethod.values.firstWhere(
        (e) => e.name == authMethod,
        orElse: () => AuthMethod.password,
      ),
      notes: notes,
      color: row.color,
      iconName: iconName,
      isActive: row.isActive,
      groupId: row.groupId,
      sshKeyId: row.sshKeyId,
      sortOrder: row.sortOrder,
      tags: tags,
      ownerId: row.ownerId,
      sharedWith: row.sharedWith,
      permissions: row.permissions,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static ServersCompanion toCompanion(
    ServerEntity entity, {
    FieldCryptoService? crypto,
  }) {
    final name = crypto?.encryptField(entity.name) ?? entity.name;
    final hostname = crypto?.encryptField(entity.hostname) ?? entity.hostname;
    final username = crypto?.encryptField(entity.username) ?? entity.username;
    final notes = crypto?.encryptNullableField(entity.notes) ?? entity.notes;
    final authMethod = crypto?.encryptField(entity.authMethod.name) ?? entity.authMethod.name;
    final iconName = crypto?.encryptNullableField(entity.iconName) ?? entity.iconName;

    return ServersCompanion(
      id: Value(entity.id),
      name: Value(name),
      hostname: Value(hostname),
      port: Value(entity.port),
      username: Value(username),
      authMethod: Value(authMethod),
      notes: Value(notes),
      color: Value(entity.color),
      iconName: Value(iconName),
      isActive: Value(entity.isActive),
      groupId: Value(entity.groupId),
      sshKeyId: Value(entity.sshKeyId),
      sortOrder: Value(entity.sortOrder),
      ownerId: Value(entity.ownerId),
      sharedWith: Value(entity.sharedWith),
      permissions: Value(entity.permissions),
      createdAt: Value(entity.createdAt),
      updatedAt: Value(entity.updatedAt),
    );
  }
}
