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
  Future<Result<int>> push(String syncPassword, int localVersion) async {
    // 1. Export to JSON string (with credentials)
    final exportResult =
        await _exportImportRepo.exportToJsonString(includeCredentials: true);
    if (exportResult.isFailure) return Err(exportResult.failure);

    // 2. Encrypt with sync password
    final envelopeResult =
        _encryptionService.encryptForExport(exportResult.value, syncPassword);
    if (envelopeResult.isFailure) return Err(envelopeResult.failure);

    // 3. Encode envelope as blob
    final envelopeJson = jsonEncode(envelopeResult.value.toJson());
    final blobBytes = utf8.encode(envelopeJson);
    final blob = base64Encode(blobBytes);

    // 4. Calculate checksum
    final checksum = crypto.sha256.convert(blobBytes).toString();

    // 5. Push to server
    final newVersion = localVersion + 1;
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
  Future<Result<int>> pull(String syncPassword) async {
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
            SyncFailure('Checksum mismatch — vault data may be corrupted'));
      }
    }

    // 4. Parse envelope and decrypt
    final envelopeJson = utf8.decode(blobBytes);
    final envelope = ExportEnvelope.fromJson(
        jsonDecode(envelopeJson) as Map<String, dynamic>);
    final decryptResult =
        _encryptionService.decryptFromExport(envelope, syncPassword);
    if (decryptResult.isFailure) return Err(decryptResult.failure);

    // 5. Import from JSON string (overwrite, with credentials)
    final importResult = await _exportImportRepo.importFromJsonString(
      decryptResult.value,
      ImportConflictStrategy.overwrite,
      includeCredentials: true,
    );
    if (importResult.isFailure) return Err(importResult.failure);

    return Success(vault.version);
  }

  /// Full sync: pull first, then push if local data is newer
  Future<Result<int>> sync(String syncPassword, int localVersion) async {
    // Pull first
    final pullResult = await pull(syncPassword);
    if (pullResult.isFailure) return pullResult;

    final remoteVersion = pullResult.value;

    // Push if local is newer or same (to ensure server has latest)
    if (localVersion >= remoteVersion) {
      return push(syncPassword, remoteVersion);
    }

    return Success(remoteVersion);
  }
}
