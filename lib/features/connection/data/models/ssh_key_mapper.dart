import 'package:drift/drift.dart';
import 'package:shellvault/core/crypto/field_crypto_service.dart';
import 'package:shellvault/core/crypto/ssh_key_type.dart';
import 'package:shellvault/core/storage/database.dart';
import 'package:shellvault/features/connection/domain/entities/ssh_key_entity.dart';

abstract final class SshKeyMapper {
  static SshKeyEntity fromDrift(
    SshKey row, {
    int linkedServerCount = 0,
    FieldCryptoService? crypto,
  }) {
    final name = crypto?.decryptField(row.name) ?? row.name;
    final fingerprint = crypto?.decryptField(row.fingerprint) ?? row.fingerprint;
    final publicKey = crypto?.decryptField(row.publicKey) ?? row.publicKey;
    final comment = crypto?.decryptNullableField(row.comment) ?? row.comment;
    final keyType = crypto?.decryptField(row.keyType) ?? row.keyType;

    return SshKeyEntity(
      id: row.id,
      name: name,
      keyType: SshKeyType.values.firstWhere(
        (e) => e.name == keyType,
        orElse: () => SshKeyType.ed25519,
      ),
      fingerprint: fingerprint,
      publicKey: publicKey,
      comment: comment,
      linkedServerCount: linkedServerCount,
      ownerId: row.ownerId,
      sharedWith: row.sharedWith,
      permissions: row.permissions,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static SshKeysCompanion toCompanion(
    SshKeyEntity entity, {
    FieldCryptoService? crypto,
  }) {
    final name = crypto?.encryptField(entity.name) ?? entity.name;
    final fingerprint = crypto?.encryptField(entity.fingerprint) ?? entity.fingerprint;
    final publicKey = crypto?.encryptField(entity.publicKey) ?? entity.publicKey;
    final comment = crypto?.encryptNullableField(entity.comment) ?? entity.comment;
    final keyType = crypto?.encryptField(entity.keyType.name) ?? entity.keyType.name;

    return SshKeysCompanion(
      id: Value(entity.id),
      name: Value(name),
      keyType: Value(keyType),
      fingerprint: Value(fingerprint),
      publicKey: Value(publicKey),
      comment: Value(comment),
      ownerId: Value(entity.ownerId),
      sharedWith: Value(entity.sharedWith),
      permissions: Value(entity.permissions),
      createdAt: Value(entity.createdAt),
      updatedAt: Value(entity.updatedAt),
    );
  }
}
