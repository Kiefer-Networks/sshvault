import 'package:shellvault/core/crypto/field_crypto_service.dart';
import 'package:shellvault/core/storage/database.dart';

/// Encrypts or decrypts all sensitive fields in the database.
///
/// Used when:
/// - PIN is set for the first time → encrypt all fields
/// - PIN is removed → decrypt all fields
class DatabaseMigrationService {
  final AppDatabase _db;

  DatabaseMigrationService(this._db);

  /// Encrypts all sensitive fields in the database using the given crypto service.
  Future<void> encryptDatabase(FieldCryptoService crypto) async {
    await _migrateServers(crypto, encrypt: true);
    await _migrateSshKeys(crypto, encrypt: true);
    await _migrateGroups(crypto, encrypt: true);
    await _migrateTags(crypto, encrypt: true);
    await _migrateSnippets(crypto, encrypt: true);
    await _migrateSnippetVariables(crypto, encrypt: true);
  }

  /// Decrypts all sensitive fields in the database using the given crypto service.
  Future<void> decryptDatabase(FieldCryptoService crypto) async {
    await _migrateServers(crypto, encrypt: false);
    await _migrateSshKeys(crypto, encrypt: false);
    await _migrateGroups(crypto, encrypt: false);
    await _migrateTags(crypto, encrypt: false);
    await _migrateSnippets(crypto, encrypt: false);
    await _migrateSnippetVariables(crypto, encrypt: false);
  }

  String _transform(FieldCryptoService crypto, String value, {required bool encrypt}) {
    if (value.isEmpty) return value;
    if (encrypt) {
      if (FieldCryptoService.isEncrypted(value)) return value;
      return crypto.encryptField(value);
    } else {
      return crypto.decryptField(value);
    }
  }

  String? _transformNullable(FieldCryptoService crypto, String? value, {required bool encrypt}) {
    if (value == null || value.isEmpty) return value;
    return _transform(crypto, value, encrypt: encrypt);
  }

  Future<void> _migrateServers(FieldCryptoService crypto, {required bool encrypt}) async {
    final rows = await _db.serverDao.getAllServers();
    for (final row in rows) {
      final updated = row.copyWith(
        name: _transform(crypto, row.name, encrypt: encrypt),
        hostname: _transform(crypto, row.hostname, encrypt: encrypt),
        username: _transform(crypto, row.username, encrypt: encrypt),
        notes: _transformNullable(crypto, row.notes, encrypt: encrypt),
        authMethod: _transform(crypto, row.authMethod, encrypt: encrypt),
        iconName: _transformNullable(crypto, row.iconName, encrypt: encrypt),
      );
      await (_db.update(_db.servers)..where((t) => t.id.equals(row.id)))
          .write(updated.toCompanion(false));
    }
  }

  Future<void> _migrateSshKeys(FieldCryptoService crypto, {required bool encrypt}) async {
    final rows = await _db.sshKeyDao.getAllSshKeys();
    for (final row in rows) {
      final updated = row.copyWith(
        name: _transform(crypto, row.name, encrypt: encrypt),
        fingerprint: _transform(crypto, row.fingerprint, encrypt: encrypt),
        publicKey: _transform(crypto, row.publicKey, encrypt: encrypt),
        comment: _transformNullable(crypto, row.comment, encrypt: encrypt),
        keyType: _transform(crypto, row.keyType, encrypt: encrypt),
      );
      await (_db.update(_db.sshKeys)..where((t) => t.id.equals(row.id)))
          .write(updated.toCompanion(false));
    }
  }

  Future<void> _migrateGroups(FieldCryptoService crypto, {required bool encrypt}) async {
    final rows = await _db.groupDao.getAllGroups();
    for (final row in rows) {
      final updated = row.copyWith(
        name: _transform(crypto, row.name, encrypt: encrypt),
        iconName: _transformNullable(crypto, row.iconName, encrypt: encrypt),
      );
      await (_db.update(_db.groups)..where((t) => t.id.equals(row.id)))
          .write(updated.toCompanion(false));
    }
  }

  Future<void> _migrateTags(FieldCryptoService crypto, {required bool encrypt}) async {
    final rows = await _db.tagDao.getAllTags();
    for (final row in rows) {
      final updated = row.copyWith(
        name: _transform(crypto, row.name, encrypt: encrypt),
      );
      await (_db.update(_db.tags)..where((t) => t.id.equals(row.id)))
          .write(updated.toCompanion(false));
    }
  }

  Future<void> _migrateSnippets(FieldCryptoService crypto, {required bool encrypt}) async {
    final rows = await _db.snippetDao.getAllSnippets();
    for (final row in rows) {
      final updated = row.copyWith(
        name: _transform(crypto, row.name, encrypt: encrypt),
        content: _transform(crypto, row.content, encrypt: encrypt),
        description: _transformNullable(crypto, row.description, encrypt: encrypt),
        language: _transform(crypto, row.language, encrypt: encrypt),
      );
      await (_db.update(_db.snippets)..where((t) => t.id.equals(row.id)))
          .write(updated.toCompanion(false));
    }
  }

  Future<void> _migrateSnippetVariables(FieldCryptoService crypto, {required bool encrypt}) async {
    final rows = await _db.snippetDao.getAllSnippetVariables();
    for (final row in rows) {
      final updated = row.copyWith(
        name: _transform(crypto, row.name, encrypt: encrypt),
        defaultValue: _transformNullable(crypto, row.defaultValue, encrypt: encrypt),
        description: _transformNullable(crypto, row.description, encrypt: encrypt),
      );
      await (_db.update(_db.snippetVariables)..where((t) => t.id.equals(row.id)))
          .write(updated.toCompanion(false));
    }
  }
}
