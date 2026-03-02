import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:shellvault/core/crypto/encryption_service.dart';
import 'package:shellvault/core/crypto/export_envelope.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/connection/domain/repositories/export_import_repository.dart';
import 'package:shellvault/features/sync/domain/repositories/sync_repository.dart';

class SyncUseCases {
  final SyncRepository _syncRepo;
  final ExportImportRepository _exportImportRepo;
  final EncryptionService _encryptionService;

  SyncUseCases(this._syncRepo, this._exportImportRepo, this._encryptionService);

  /// Push local data to server
  Future<Result<int>> push(String syncPassword, int baseVersion) async {
    // 1. Export to JSON string (with credentials)
    final exportResult = await _exportImportRepo.exportToJsonString(
      includeCredentials: true,
    );
    if (exportResult.isFailure) return Err(exportResult.failure);

    // 2. Encrypt with sync password
    final envelopeResult = _encryptionService.encryptForExport(
      exportResult.value,
      syncPassword,
    );
    if (envelopeResult.isFailure) return Err(envelopeResult.failure);

    // 3. Encode envelope as blob
    final envelopeJson = jsonEncode(envelopeResult.value.toJson());
    final blobBytes = utf8.encode(envelopeJson);
    final blob = base64Encode(blobBytes);

    // 4. Calculate checksum
    final checksum = crypto.sha256.convert(blobBytes).toString();

    // 5. Push to server with incremented version
    final newVersion = baseVersion + 1;
    final putResult = await _syncRepo.putVault(
      version: newVersion,
      blob: blob,
      checksum: checksum,
    );

    return putResult.fold(
      onSuccess: (vault) => Success(vault.version),
      onFailure: (f) => Err(f),
    );
  }

  /// Pull data from server and import locally
  Future<Result<int>> pull(
    String syncPassword, {
    ImportConflictStrategy strategy = ImportConflictStrategy.mergeServerWins,
  }) async {
    // 1. Get vault from server
    final vaultResult = await _syncRepo.getVault();
    if (vaultResult.isFailure) return Err(vaultResult.failure);

    final vault = vaultResult.value;
    if (vault.blob == null || vault.blob!.isEmpty) {
      return Success(vault.version); // Nothing to pull
    }

    // 2. Decode blob
    final blobBytes = base64Decode(vault.blob!);

    // 3. Verify checksum
    if (vault.checksum != null) {
      final checksum = crypto.sha256.convert(blobBytes).toString();
      if (checksum != vault.checksum) {
        return const Err(
          SyncFailure('Checksum mismatch — vault data may be corrupted'),
        );
      }
    }

    // 4. Parse envelope and decrypt
    final envelopeJson = utf8.decode(blobBytes);
    final envelope = ExportEnvelope.fromJson(
      jsonDecode(envelopeJson) as Map<String, dynamic>,
    );
    final decryptResult = _encryptionService.decryptFromExport(
      envelope,
      syncPassword,
    );
    if (decryptResult.isFailure) return Err(decryptResult.failure);

    // 5. Import from JSON string using merge strategy
    final importResult = await _exportImportRepo.importFromJsonString(
      decryptResult.value,
      strategy,
      includeCredentials: true,
    );
    if (importResult.isFailure) return Err(importResult.failure);

    return Success(vault.version);
  }

  /// Validate sync password by attempting to decrypt the vault
  Future<Result<bool>> validatePassword(String syncPassword) async {
    final vaultResult = await _syncRepo.getVault();
    if (vaultResult.isFailure) return Err(vaultResult.failure);

    final vault = vaultResult.value;
    if (vault.blob == null || vault.blob!.isEmpty) {
      // No vault exists yet — any password is valid (new account)
      return const Success(true);
    }

    final blobBytes = base64Decode(vault.blob!);
    final envelopeJson = utf8.decode(blobBytes);
    final envelope = ExportEnvelope.fromJson(
      jsonDecode(envelopeJson) as Map<String, dynamic>,
    );
    final decryptResult = _encryptionService.decryptFromExport(
      envelope,
      syncPassword,
    );

    return Success(decryptResult.isSuccess);
  }

  /// Full sync: pull first (merge), then push
  Future<Result<int>> sync(String syncPassword, int localVersion) async {
    // 1. Pull remote data and merge into local DB
    final pullResult = await pull(syncPassword);
    if (pullResult.isFailure) return pullResult;

    final remoteVersion = pullResult.value;

    // 2. Push merged local data back to server
    return pushWithRetry(syncPassword, remoteVersion);
  }

  /// Push with automatic retry on 409 conflict
  Future<Result<int>> pushWithRetry(
    String syncPassword,
    int version, {
    int maxRetries = 3,
  }) async {
    for (var attempt = 0; attempt < maxRetries; attempt++) {
      final result = await push(syncPassword, version);
      if (result.isSuccess) return result;

      // On 409 conflict: pull latest and retry
      if (result.failure is SyncFailure &&
          (result.failure as SyncFailure).conflictVersion != null) {
        final pullResult = await pull(syncPassword);
        if (pullResult.isFailure) return pullResult;
        version = pullResult.value;
        continue;
      }
      return result; // Other error → abort
    }
    return const Err(SyncFailure('Sync failed after maximum retries'));
  }

  /// Re-encrypt vault with a new password
  Future<Result<int>> changeEncryptionPassword(
    String oldPassword,
    String newPassword,
  ) async {
    // 1. Pull + decrypt with old password to validate
    final pullResult = await pull(
      oldPassword,
      strategy: ImportConflictStrategy.overwrite,
    );
    if (pullResult.isFailure) {
      return const Err(SyncFailure('Wrong current password'));
    }

    // 2. Push with new password
    return push(newPassword, pullResult.value);
  }
}
