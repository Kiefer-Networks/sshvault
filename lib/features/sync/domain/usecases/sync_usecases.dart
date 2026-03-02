import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:shellvault/core/crypto/encryption_service.dart';
import 'package:shellvault/core/crypto/export_envelope.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/services/logging_service.dart';
import 'package:shellvault/features/connection/domain/repositories/export_import_repository.dart';
import 'package:shellvault/features/sync/domain/repositories/sync_repository.dart';

class SyncUseCases {
  static final _log = LoggingService.instance;
  static const _tag = 'Sync';

  final SyncRepository _syncRepo;
  final ExportImportRepository _exportImportRepo;
  final EncryptionService _encryptionService;

  SyncUseCases(this._syncRepo, this._exportImportRepo, this._encryptionService);

  /// Push local data to server
  Future<Result<int>> push(String syncPassword, int baseVersion) async {
    _log.info(_tag, 'Push started (baseVersion=$baseVersion)');
    final sw = Stopwatch()..start();

    // 1. Export to JSON string (with credentials)
    final exportResult = await _exportImportRepo.exportToJsonString(
      includeCredentials: true,
    );
    if (exportResult.isFailure) {
      _log.error(_tag, 'Push failed: export error — ${exportResult.failure}');
      return Err(exportResult.failure);
    }
    _log.debug(
      _tag,
      'Export completed (${exportResult.value.length} chars) '
      'in ${sw.elapsedMilliseconds}ms',
    );

    // 2. Encrypt with sync password
    final envelopeResult = await _encryptionService.encryptForExport(
      exportResult.value,
      syncPassword,
    );
    if (envelopeResult.isFailure) {
      _log.error(
        _tag,
        'Push failed: encryption error — ${envelopeResult.failure}',
      );
      return Err(envelopeResult.failure);
    }

    // 3. Encode envelope as blob
    final envelopeJson = jsonEncode(envelopeResult.value.toJson());
    final blobBytes = utf8.encode(envelopeJson);
    final blob = base64Encode(blobBytes);

    // 4. Calculate checksum
    final checksum = crypto.sha256.convert(blobBytes).toString();

    // 5. Push to server with incremented version
    final newVersion = baseVersion + 1;
    _log.info(
      _tag,
      'Uploading vault (version=$newVersion, ${blob.length} chars)',
    );
    final putResult = await _syncRepo.putVault(
      version: newVersion,
      blob: blob,
      checksum: checksum,
    );

    sw.stop();
    return putResult.fold(
      onSuccess: (vault) {
        _log.info(
          _tag,
          'Push completed (version=${vault.version}) in ${sw.elapsedMilliseconds}ms',
        );
        return Success(vault.version);
      },
      onFailure: (f) {
        _log.error(_tag, 'Push failed: server error — $f');
        return Err(f);
      },
    );
  }

  /// Pull data from server and import locally
  Future<Result<int>> pull(
    String syncPassword, {
    ImportConflictStrategy strategy = ImportConflictStrategy.mergeServerWins,
  }) async {
    _log.info(_tag, 'Pull started (strategy=${strategy.name})');
    final sw = Stopwatch()..start();

    // 1. Get vault from server
    final vaultResult = await _syncRepo.getVault();
    if (vaultResult.isFailure) {
      _log.error(_tag, 'Pull failed: fetch error — ${vaultResult.failure}');
      return Err(vaultResult.failure);
    }

    final vault = vaultResult.value;
    if (vault.blob == null || vault.blob!.isEmpty) {
      _log.info(
        _tag,
        'Pull completed: server vault is empty (version=${vault.version})',
      );
      return Success(vault.version); // Nothing to pull
    }
    _log.debug(
      _tag,
      'Vault fetched (version=${vault.version}, ${vault.blob!.length} chars blob)',
    );

    // 2. Decode blob
    final blobBytes = base64Decode(vault.blob!);

    // 3. Verify checksum
    if (vault.checksum != null) {
      final checksum = crypto.sha256.convert(blobBytes).toString();
      if (checksum != vault.checksum) {
        _log.error(_tag, 'Pull failed: blob checksum mismatch');
        return const Err(
          SyncFailure('Checksum mismatch — vault data may be corrupted'),
        );
      }
      _log.debug(_tag, 'Blob checksum verified');
    }

    // 4. Parse envelope and decrypt
    final envelopeJson = utf8.decode(blobBytes);
    final envelope = ExportEnvelope.fromJson(
      jsonDecode(envelopeJson) as Map<String, dynamic>,
    );
    _log.debug(_tag, 'Envelope parsed (v${envelope.version})');

    final decryptResult = await _encryptionService.decryptFromExport(
      envelope,
      syncPassword,
    );
    if (decryptResult.isFailure) {
      _log.error(
        _tag,
        'Pull failed: decryption error — ${decryptResult.failure}',
      );
      return Err(decryptResult.failure);
    }
    _log.debug(
      _tag,
      'Decrypted vault data (${decryptResult.value.length} chars)',
    );

    // 5. Import from JSON string using merge strategy
    final importResult = await _exportImportRepo.importFromJsonString(
      decryptResult.value,
      strategy,
      includeCredentials: true,
    );
    if (importResult.isFailure) {
      _log.error(_tag, 'Pull failed: import error — ${importResult.failure}');
      return Err(importResult.failure);
    }

    sw.stop();
    _log.info(
      _tag,
      'Pull completed (version=${vault.version}) in ${sw.elapsedMilliseconds}ms',
    );
    return Success(vault.version);
  }

  /// Validate sync password by attempting to decrypt the vault
  Future<Result<bool>> validatePassword(String syncPassword) async {
    _log.info(_tag, 'Validating sync password');

    final vaultResult = await _syncRepo.getVault();
    if (vaultResult.isFailure) {
      _log.error(
        _tag,
        'Password validation failed: fetch error — ${vaultResult.failure}',
      );
      return Err(vaultResult.failure);
    }

    final vault = vaultResult.value;
    if (vault.blob == null || vault.blob!.isEmpty) {
      _log.info(
        _tag,
        'No vault on server — any password is valid (new account)',
      );
      return const Success(true);
    }

    final blobBytes = base64Decode(vault.blob!);
    final envelopeJson = utf8.decode(blobBytes);
    final envelope = ExportEnvelope.fromJson(
      jsonDecode(envelopeJson) as Map<String, dynamic>,
    );
    final decryptResult = await _encryptionService.decryptFromExport(
      envelope,
      syncPassword,
    );

    if (decryptResult.isSuccess) {
      _log.info(_tag, 'Sync password validated successfully');
    } else {
      _log.warning(_tag, 'Sync password validation failed — wrong password');
    }
    return Success(decryptResult.isSuccess);
  }

  /// Full sync: pull first (merge), then push
  Future<Result<int>> sync(String syncPassword, int localVersion) async {
    _log.info(_tag, 'Full sync started (localVersion=$localVersion)');
    final sw = Stopwatch()..start();

    // 1. Pull remote data and merge into local DB
    final pullResult = await pull(syncPassword);
    if (pullResult.isFailure) {
      _log.error(_tag, 'Full sync aborted: pull failed');
      return pullResult;
    }

    final remoteVersion = pullResult.value;
    _log.debug(
      _tag,
      'Pull phase done (remoteVersion=$remoteVersion), starting push',
    );

    // 2. Push merged local data back to server
    final pushResult = await pushWithRetry(syncPassword, remoteVersion);
    sw.stop();
    if (pushResult.isSuccess) {
      _log.info(
        _tag,
        'Full sync completed (version=${pushResult.value}) in ${sw.elapsedMilliseconds}ms',
      );
    } else {
      _log.error(_tag, 'Full sync failed in push phase: ${pushResult.failure}');
    }
    return pushResult;
  }

  /// Push with automatic retry on 409 conflict
  Future<Result<int>> pushWithRetry(
    String syncPassword,
    int version, {
    int maxRetries = 3,
  }) async {
    for (var attempt = 0; attempt < maxRetries; attempt++) {
      if (attempt > 0) {
        _log.info(_tag, 'Push retry attempt ${attempt + 1}/$maxRetries');
      }
      final result = await push(syncPassword, version);
      if (result.isSuccess) return result;

      // On 409 conflict: pull latest and retry
      if (result.failure is SyncFailure &&
          (result.failure as SyncFailure).conflictVersion != null) {
        _log.warning(
          _tag,
          'Version conflict detected, pulling latest before retry',
        );
        final pullResult = await pull(syncPassword);
        if (pullResult.isFailure) return pullResult;
        version = pullResult.value;
        continue;
      }
      return result; // Other error → abort
    }
    _log.error(_tag, 'Push failed after $maxRetries retries');
    return const Err(SyncFailure('Sync failed after maximum retries'));
  }

  /// Re-encrypt vault with a new password
  Future<Result<int>> changeEncryptionPassword(
    String oldPassword,
    String newPassword,
  ) async {
    _log.info(_tag, 'Changing encryption password');

    // 1. Pull + decrypt with old password to validate
    final pullResult = await pull(
      oldPassword,
      strategy: ImportConflictStrategy.overwrite,
    );
    if (pullResult.isFailure) {
      _log.error(_tag, 'Password change failed: old password incorrect');
      return const Err(SyncFailure('Wrong current password'));
    }

    // 2. Push with new password
    _log.info(_tag, 'Re-encrypting vault with new password');
    return push(newPassword, pullResult.value);
  }
}
