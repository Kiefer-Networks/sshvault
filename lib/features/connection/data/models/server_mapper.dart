import 'package:drift/drift.dart';
import 'package:shellvault/core/storage/database.dart';
import 'package:shellvault/features/connection/domain/entities/auth_method.dart';
import 'package:shellvault/features/connection/domain/entities/server_entity.dart';
import 'package:shellvault/features/connection/domain/entities/tag_entity.dart';
abstract final class ServerMapper {
  static ServerEntity fromDrift(Server row, {List<TagEntity> tags = const []}) {
    return ServerEntity(
      id: row.id,
      name: row.name,
      hostname: row.hostname,
      port: row.port,
      username: row.username,
      authMethod: AuthMethod.values.firstWhere(
        (e) => e.name == row.authMethod,
        orElse: () => AuthMethod.password,
      ),
      notes: row.notes,
      color: row.color,
      iconName: row.iconName,
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

  static ServersCompanion toCompanion(ServerEntity entity) {
    return ServersCompanion(
      id: Value(entity.id),
      name: Value(entity.name),
      hostname: Value(entity.hostname),
      port: Value(entity.port),
      username: Value(entity.username),
      authMethod: Value(entity.authMethod.name),
      notes: Value(entity.notes),
      color: Value(entity.color),
      iconName: Value(entity.iconName),
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
