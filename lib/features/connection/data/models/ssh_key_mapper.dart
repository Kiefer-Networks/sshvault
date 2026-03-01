import 'package:drift/drift.dart';
import 'package:shellvault/core/crypto/ssh_key_type.dart';
import 'package:shellvault/core/storage/database.dart';
import 'package:shellvault/features/connection/domain/entities/ssh_key_entity.dart';

abstract final class SshKeyMapper {
  static SshKeyEntity fromDrift(
    SshKey row, {
    int linkedServerCount = 0,
  }) {
    return SshKeyEntity(
      id: row.id,
      name: row.name,
      keyType: SshKeyType.values.firstWhere(
        (e) => e.name == row.keyType,
        orElse: () => SshKeyType.ed25519,
      ),
      fingerprint: row.fingerprint,
      publicKey: row.publicKey,
      comment: row.comment,
      linkedServerCount: linkedServerCount,
      ownerId: row.ownerId,
      sharedWith: row.sharedWith,
      permissions: row.permissions,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static SshKeysCompanion toCompanion(SshKeyEntity entity) {
    return SshKeysCompanion(
      id: Value(entity.id),
      name: Value(entity.name),
      keyType: Value(entity.keyType.name),
      fingerprint: Value(entity.fingerprint),
      publicKey: Value(entity.publicKey),
      comment: Value(entity.comment),
      ownerId: Value(entity.ownerId),
      sharedWith: Value(entity.sharedWith),
      permissions: Value(entity.permissions),
      createdAt: Value(entity.createdAt),
      updatedAt: Value(entity.updatedAt),
    );
  }
}
