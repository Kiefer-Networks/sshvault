import 'package:shellvault/core/crypto/field_crypto_service.dart';
import 'package:shellvault/core/services/logging_service.dart';
import 'package:shellvault/core/storage/database.dart';

/// Encrypts or decrypts all sensitive fields in the database.
///
/// Used when:
/// - PIN is set for the first time -> encrypt all fields
/// - PIN is removed -> decrypt all fields
///
/// All operations run inside a drift transaction so that a failure
/// mid-way rolls back every change, preventing a partially
/// encrypted/decrypted database state.
class DatabaseMigrationService {
  static const _tag = 'DatabaseMigration';

  final AppDatabase _db;
  final LoggingService _log = LoggingService.instance;

  DatabaseMigrationService(this._db);

  /// Encrypts all sensitive fields in the database using the given crypto service.
  ///
  /// The entire operation is wrapped in a database transaction. If any table
  /// fails to encrypt, all changes are rolled back and the error is rethrown.
  Future<void> encryptDatabase(FieldCryptoService crypto) async {
    _log.info(_tag, 'Starting full database encryption');
    try {
      await _db.transaction(() async {
        await _migrateServers(crypto, encrypt: true);
        await _migrateSshKeys(crypto, encrypt: true);
        await _migrateGroups(crypto, encrypt: true);
        await _migrateTags(crypto, encrypt: true);
        await _migrateSnippets(crypto, encrypt: true);
        await _migrateSnippetVariables(crypto, encrypt: true);
      });
      _log.info(_tag, 'Database encryption completed successfully');
    } catch (e, stackTrace) {
      _log.error(
        _tag,
        'Database encryption failed — transaction rolled back: $e',
      );
      throw DatabaseMigrationException(
        'Failed to encrypt database',
        cause: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Decrypts all sensitive fields in the database using the given crypto service.
  ///
  /// The entire operation is wrapped in a database transaction. If any table
  /// fails to decrypt, all changes are rolled back and the error is rethrown.
  Future<void> decryptDatabase(FieldCryptoService crypto) async {
    _log.info(_tag, 'Starting full database decryption');
    try {
      await _db.transaction(() async {
        await _migrateServers(crypto, encrypt: false);
        await _migrateSshKeys(crypto, encrypt: false);
        await _migrateGroups(crypto, encrypt: false);
        await _migrateTags(crypto, encrypt: false);
        await _migrateSnippets(crypto, encrypt: false);
        await _migrateSnippetVariables(crypto, encrypt: false);
      });
      _log.info(_tag, 'Database decryption completed successfully');
    } catch (e, stackTrace) {
      _log.error(
        _tag,
        'Database decryption failed — transaction rolled back: $e',
      );
      throw DatabaseMigrationException(
        'Failed to decrypt database',
        cause: e,
        stackTrace: stackTrace,
      );
    }
  }

  String _transform(
    FieldCryptoService crypto,
    String value, {
    required bool encrypt,
  }) {
    if (value.isEmpty) return value;
    if (encrypt) {
      if (FieldCryptoService.isEncrypted(value)) return value;
      return crypto.encryptField(value);
    } else {
      if (!FieldCryptoService.isEncrypted(value)) return value;
      return crypto.decryptField(value);
    }
  }

  String? _transformNullable(
    FieldCryptoService crypto,
    String? value, {
    required bool encrypt,
  }) {
    if (value == null || value.isEmpty) return value;
    return _transform(crypto, value, encrypt: encrypt);
  }

  Future<void> _migrateServers(
    FieldCryptoService crypto, {
    required bool encrypt,
  }) async {
    final rows = await _db.serverDao.getAllServers();
    _log.debug(_tag, 'Migrating ${rows.length} servers (encrypt=$encrypt)');
    for (final row in rows) {
      try {
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
      } catch (e) {
        _log.error(_tag, 'Failed to migrate server id=${row.id}: $e');
        rethrow;
      }
    }
  }

  Future<void> _migrateSshKeys(
    FieldCryptoService crypto, {
    required bool encrypt,
  }) async {
    final rows = await _db.sshKeyDao.getAllSshKeys();
    _log.debug(_tag, 'Migrating ${rows.length} SSH keys (encrypt=$encrypt)');
    for (final row in rows) {
      try {
        final updated = row.copyWith(
          name: _transform(crypto, row.name, encrypt: encrypt),
          fingerprint: _transform(crypto, row.fingerprint, encrypt: encrypt),
          publicKey: _transform(crypto, row.publicKey, encrypt: encrypt),
          comment: _transformNullable(crypto, row.comment, encrypt: encrypt),
          keyType: _transform(crypto, row.keyType, encrypt: encrypt),
        );
        await (_db.update(_db.sshKeys)..where((t) => t.id.equals(row.id)))
            .write(updated.toCompanion(false));
      } catch (e) {
        _log.error(_tag, 'Failed to migrate SSH key id=${row.id}: $e');
        rethrow;
      }
    }
  }

  Future<void> _migrateGroups(
    FieldCryptoService crypto, {
    required bool encrypt,
  }) async {
    final rows = await _db.groupDao.getAllGroups();
    _log.debug(_tag, 'Migrating ${rows.length} groups (encrypt=$encrypt)');
    for (final row in rows) {
      try {
        final updated = row.copyWith(
          name: _transform(crypto, row.name, encrypt: encrypt),
          iconName: _transformNullable(crypto, row.iconName, encrypt: encrypt),
        );
        await (_db.update(_db.groups)..where((t) => t.id.equals(row.id)))
            .write(updated.toCompanion(false));
      } catch (e) {
        _log.error(_tag, 'Failed to migrate group id=${row.id}: $e');
        rethrow;
      }
    }
  }

  Future<void> _migrateTags(
    FieldCryptoService crypto, {
    required bool encrypt,
  }) async {
    final rows = await _db.tagDao.getAllTags();
    _log.debug(_tag, 'Migrating ${rows.length} tags (encrypt=$encrypt)');
    for (final row in rows) {
      try {
        final updated = row.copyWith(
          name: _transform(crypto, row.name, encrypt: encrypt),
        );
        await (_db.update(_db.tags)..where((t) => t.id.equals(row.id)))
            .write(updated.toCompanion(false));
      } catch (e) {
        _log.error(_tag, 'Failed to migrate tag id=${row.id}: $e');
        rethrow;
      }
    }
  }

  Future<void> _migrateSnippets(
    FieldCryptoService crypto, {
    required bool encrypt,
  }) async {
    final rows = await _db.snippetDao.getAllSnippets();
    _log.debug(_tag, 'Migrating ${rows.length} snippets (encrypt=$encrypt)');
    for (final row in rows) {
      try {
        final updated = row.copyWith(
          name: _transform(crypto, row.name, encrypt: encrypt),
          content: _transform(crypto, row.content, encrypt: encrypt),
          description:
              _transformNullable(crypto, row.description, encrypt: encrypt),
          language: _transform(crypto, row.language, encrypt: encrypt),
        );
        await (_db.update(_db.snippets)..where((t) => t.id.equals(row.id)))
            .write(updated.toCompanion(false));
      } catch (e) {
        _log.error(_tag, 'Failed to migrate snippet id=${row.id}: $e');
        rethrow;
      }
    }
  }

  Future<void> _migrateSnippetVariables(
    FieldCryptoService crypto, {
    required bool encrypt,
  }) async {
    final rows = await _db.snippetDao.getAllSnippetVariables();
    _log.debug(
      _tag,
      'Migrating ${rows.length} snippet variables (encrypt=$encrypt)',
    );
    for (final row in rows) {
      try {
        final updated = row.copyWith(
          name: _transform(crypto, row.name, encrypt: encrypt),
          defaultValue:
              _transformNullable(crypto, row.defaultValue, encrypt: encrypt),
          description:
              _transformNullable(crypto, row.description, encrypt: encrypt),
        );
        await (_db.update(_db.snippetVariables)
              ..where((t) => t.id.equals(row.id)))
            .write(updated.toCompanion(false));
      } catch (e) {
        _log.error(
          _tag,
          'Failed to migrate snippet variable id=${row.id}: $e',
        );
        rethrow;
      }
    }
  }
}

/// Exception thrown when a database encryption/decryption migration fails.
///
/// Contains the original [cause] and [stackTrace] for debugging.
class DatabaseMigrationException implements Exception {
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  const DatabaseMigrationException(
    this.message, {
    this.cause,
    this.stackTrace,
  });

  @override
  String toString() {
    final buffer = StringBuffer('DatabaseMigrationException: $message');
    if (cause != null) {
      buffer.write(' (cause: $cause)');
    }
    return buffer.toString();
  }
}
