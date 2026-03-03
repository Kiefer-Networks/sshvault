import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shellvault/core/crypto/encryption_service.dart';
import 'package:shellvault/core/crypto/export_envelope.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/connection/domain/repositories/export_import_repository.dart';
import 'package:shellvault/features/sync/domain/entities/vault_entity.dart';
import 'package:shellvault/features/sync/domain/repositories/sync_repository.dart';
import 'package:shellvault/features/sync/domain/usecases/sync_usecases.dart';

class MockSyncRepository extends Mock implements SyncRepository {}

class MockExportImportRepository extends Mock
    implements ExportImportRepository {}

class MockEncryptionService extends Mock implements EncryptionService {}

class FakeExportEnvelope extends Fake implements ExportEnvelope {}

void main() {
  late MockSyncRepository mockSyncRepo;
  late MockExportImportRepository mockExportImportRepo;
  late MockEncryptionService mockEncryption;
  late SyncUseCases sut;

  const syncPassword = 'test-sync-password';
  const jsonData = '{"servers":[],"groups":[],"tags":[]}';
  const importResult = ImportResult(serversImported: 1);

  final envelope = ExportEnvelope(
    version: 1,
    salt: base64Encode([1, 2, 3]),
    nonce: base64Encode([4, 5, 6]),
    encryptedData: base64Encode([7, 8, 9]),
    checksum: 'a' * 64,
  );

  // Pre-compute a valid blob + checksum for pull tests
  final envelopeJson = jsonEncode(envelope.toJson());
  final blobBytes = utf8.encode(envelopeJson);
  final validBlob = base64Encode(blobBytes);
  final validChecksum = crypto.sha256.convert(blobBytes).toString();

  setUp(() {
    mockSyncRepo = MockSyncRepository();
    mockExportImportRepo = MockExportImportRepository();
    mockEncryption = MockEncryptionService();
    sut = SyncUseCases(mockSyncRepo, mockExportImportRepo, mockEncryption);
  });

  setUpAll(() {
    registerFallbackValue(FakeExportEnvelope());
    registerFallbackValue(ImportConflictStrategy.mergeServerWins);
  });

  group('push', () {
    test('exports, encrypts, and pushes successfully', () async {
      when(() => mockExportImportRepo.exportToJsonString(
            includeCredentials: true,
          )).thenAnswer((_) async => const Success(jsonData));

      when(() => mockEncryption.encryptForExport(jsonData, syncPassword))
          .thenAnswer((_) async => Success(envelope));

      when(() => mockSyncRepo.putVault(
            version: any(named: 'version'),
            blob: any(named: 'blob'),
            checksum: any(named: 'checksum'),
          )).thenAnswer(
        (_) async => const Success(VaultEntity(version: 2)),
      );

      final result = await sut.push(syncPassword, 1);
      expect(result.isSuccess, isTrue);
      expect(result.value, 2);
    });

    test('returns failure when export fails', () async {
      when(() => mockExportImportRepo.exportToJsonString(
            includeCredentials: true,
          )).thenAnswer(
        (_) async => const Err(ExportFailure('export failed')),
      );

      final result = await sut.push(syncPassword, 1);
      expect(result.isFailure, isTrue);
    });

    test('returns failure when encryption fails', () async {
      when(() => mockExportImportRepo.exportToJsonString(
            includeCredentials: true,
          )).thenAnswer((_) async => const Success(jsonData));

      when(() => mockEncryption.encryptForExport(any(), any()))
          .thenAnswer(
        (_) async => const Err(CryptoFailure('encryption failed')),
      );

      final result = await sut.push(syncPassword, 1);
      expect(result.isFailure, isTrue);
    });

    test('returns failure when putVault fails', () async {
      when(() => mockExportImportRepo.exportToJsonString(
            includeCredentials: true,
          )).thenAnswer((_) async => const Success(jsonData));

      when(() => mockEncryption.encryptForExport(any(), any()))
          .thenAnswer((_) async => Success(envelope));

      when(() => mockSyncRepo.putVault(
            version: any(named: 'version'),
            blob: any(named: 'blob'),
            checksum: any(named: 'checksum'),
          )).thenAnswer(
        (_) async => const Err(SyncFailure('server error')),
      );

      final result = await sut.push(syncPassword, 1);
      expect(result.isFailure, isTrue);
    });

    test('increments version by 1', () async {
      when(() => mockExportImportRepo.exportToJsonString(
            includeCredentials: true,
          )).thenAnswer((_) async => const Success(jsonData));

      when(() => mockEncryption.encryptForExport(any(), any()))
          .thenAnswer((_) async => Success(envelope));

      when(() => mockSyncRepo.putVault(
            version: any(named: 'version'),
            blob: any(named: 'blob'),
            checksum: any(named: 'checksum'),
          )).thenAnswer(
        (_) async => const Success(VaultEntity(version: 6)),
      );

      await sut.push(syncPassword, 5);
      verify(() => mockSyncRepo.putVault(
            version: 6,
            blob: any(named: 'blob'),
            checksum: any(named: 'checksum'),
          )).called(1);
    });
  });

  group('pull', () {
    test('fetches, decrypts, and imports successfully', () async {
      when(() => mockSyncRepo.getVault()).thenAnswer(
        (_) async => Success(VaultEntity(
          version: 3,
          blob: validBlob,
          checksum: validChecksum,
        )),
      );

      when(() => mockEncryption.decryptFromExport(any(), syncPassword))
          .thenAnswer((_) async => const Success(jsonData));

      when(() => mockExportImportRepo.importFromJsonString(
            any(),
            any(),
            includeCredentials: true,
          )).thenAnswer((_) async => const Success(importResult));

      final result = await sut.pull(syncPassword);
      expect(result.isSuccess, isTrue);
      expect(result.value, 3);
    });

    test('returns version when vault is empty', () async {
      when(() => mockSyncRepo.getVault()).thenAnswer(
        (_) async => const Success(VaultEntity(version: 0)),
      );

      final result = await sut.pull(syncPassword);
      expect(result.isSuccess, isTrue);
      expect(result.value, 0);
      verifyNever(() => mockEncryption.decryptFromExport(any(), any()));
    });

    test('returns failure when getVault fails', () async {
      when(() => mockSyncRepo.getVault()).thenAnswer(
        (_) async => const Err(SyncFailure('network error')),
      );

      final result = await sut.pull(syncPassword);
      expect(result.isFailure, isTrue);
    });

    test('returns failure on checksum mismatch', () async {
      when(() => mockSyncRepo.getVault()).thenAnswer(
        (_) async => Success(VaultEntity(
          version: 3,
          blob: validBlob,
          checksum: 'wrong-checksum',
        )),
      );

      final result = await sut.pull(syncPassword);
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<SyncFailure>());
      expect(result.failure.message, contains('Checksum'));
    });

    test('returns failure when decryption fails', () async {
      when(() => mockSyncRepo.getVault()).thenAnswer(
        (_) async => Success(VaultEntity(
          version: 3,
          blob: validBlob,
          checksum: validChecksum,
        )),
      );

      when(() => mockEncryption.decryptFromExport(any(), any()))
          .thenAnswer(
        (_) async => const Err(CryptoFailure('wrong password')),
      );

      final result = await sut.pull(syncPassword);
      expect(result.isFailure, isTrue);
    });

    test('returns failure when import fails', () async {
      when(() => mockSyncRepo.getVault()).thenAnswer(
        (_) async => Success(VaultEntity(
          version: 3,
          blob: validBlob,
          checksum: validChecksum,
        )),
      );

      when(() => mockEncryption.decryptFromExport(any(), any()))
          .thenAnswer((_) async => const Success(jsonData));

      when(() => mockExportImportRepo.importFromJsonString(
            any(),
            any(),
            includeCredentials: true,
          )).thenAnswer(
        (_) async => const Err(ImportFailure('import error')),
      );

      final result = await sut.pull(syncPassword);
      expect(result.isFailure, isTrue);
    });
  });

  group('validatePassword', () {
    test('returns true when vault is empty', () async {
      when(() => mockSyncRepo.getVault()).thenAnswer(
        (_) async => const Success(VaultEntity(version: 0)),
      );

      final result = await sut.validatePassword(syncPassword);
      expect(result.isSuccess, isTrue);
      expect(result.value, isTrue);
    });

    test('returns true when decryption succeeds', () async {
      when(() => mockSyncRepo.getVault()).thenAnswer(
        (_) async => Success(VaultEntity(
          version: 1,
          blob: validBlob,
          checksum: validChecksum,
        )),
      );

      when(() => mockEncryption.decryptFromExport(any(), syncPassword))
          .thenAnswer((_) async => const Success(jsonData));

      final result = await sut.validatePassword(syncPassword);
      expect(result.isSuccess, isTrue);
      expect(result.value, isTrue);
    });

    test('returns false when decryption fails', () async {
      when(() => mockSyncRepo.getVault()).thenAnswer(
        (_) async => Success(VaultEntity(
          version: 1,
          blob: validBlob,
          checksum: validChecksum,
        )),
      );

      when(() => mockEncryption.decryptFromExport(any(), any()))
          .thenAnswer(
        (_) async => const Err(CryptoFailure('wrong password')),
      );

      final result = await sut.validatePassword('wrong-password');
      expect(result.isSuccess, isTrue);
      expect(result.value, isFalse);
    });

    test('returns failure when getVault fails', () async {
      when(() => mockSyncRepo.getVault()).thenAnswer(
        (_) async => const Err(SyncFailure('network error')),
      );

      final result = await sut.validatePassword(syncPassword);
      expect(result.isFailure, isTrue);
    });
  });

  group('sync', () {
    void stubSuccessfulPull() {
      when(() => mockSyncRepo.getVault()).thenAnswer(
        (_) async => Success(VaultEntity(
          version: 3,
          blob: validBlob,
          checksum: validChecksum,
        )),
      );
      when(() => mockEncryption.decryptFromExport(any(), syncPassword))
          .thenAnswer((_) async => const Success(jsonData));
      when(() => mockExportImportRepo.importFromJsonString(
            any(),
            any(),
            includeCredentials: true,
          )).thenAnswer((_) async => const Success(importResult));
    }

    void stubSuccessfulPush() {
      when(() => mockExportImportRepo.exportToJsonString(
            includeCredentials: true,
          )).thenAnswer((_) async => const Success(jsonData));
      when(() => mockEncryption.encryptForExport(any(), any()))
          .thenAnswer((_) async => Success(envelope));
      when(() => mockSyncRepo.putVault(
            version: any(named: 'version'),
            blob: any(named: 'blob'),
            checksum: any(named: 'checksum'),
          )).thenAnswer(
        (_) async => const Success(VaultEntity(version: 4)),
      );
    }

    test('pulls then pushes successfully', () async {
      stubSuccessfulPull();
      stubSuccessfulPush();

      final result = await sut.sync(syncPassword, 2);
      expect(result.isSuccess, isTrue);
      expect(result.value, 4);
    });

    test('returns failure when pull fails', () async {
      when(() => mockSyncRepo.getVault()).thenAnswer(
        (_) async => const Err(SyncFailure('pull error')),
      );

      final result = await sut.sync(syncPassword, 2);
      expect(result.isFailure, isTrue);
    });
  });

  group('pushWithRetry', () {
    void stubSuccessfulPull() {
      when(() => mockSyncRepo.getVault()).thenAnswer(
        (_) async => Success(VaultEntity(
          version: 5,
          blob: validBlob,
          checksum: validChecksum,
        )),
      );
      when(() => mockEncryption.decryptFromExport(any(), syncPassword))
          .thenAnswer((_) async => const Success(jsonData));
      when(() => mockExportImportRepo.importFromJsonString(
            any(),
            any(),
            includeCredentials: true,
          )).thenAnswer((_) async => const Success(importResult));
    }

    test('succeeds on first attempt', () async {
      when(() => mockExportImportRepo.exportToJsonString(
            includeCredentials: true,
          )).thenAnswer((_) async => const Success(jsonData));
      when(() => mockEncryption.encryptForExport(any(), any()))
          .thenAnswer((_) async => Success(envelope));
      when(() => mockSyncRepo.putVault(
            version: any(named: 'version'),
            blob: any(named: 'blob'),
            checksum: any(named: 'checksum'),
          )).thenAnswer(
        (_) async => const Success(VaultEntity(version: 4)),
      );

      final result = await sut.pushWithRetry(syncPassword, 3);
      expect(result.isSuccess, isTrue);
      expect(result.value, 4);
    });

    test('retries on 409 conflict', () async {
      var callCount = 0;

      when(() => mockExportImportRepo.exportToJsonString(
            includeCredentials: true,
          )).thenAnswer((_) async => const Success(jsonData));
      when(() => mockEncryption.encryptForExport(any(), any()))
          .thenAnswer((_) async => Success(envelope));

      when(() => mockSyncRepo.putVault(
            version: any(named: 'version'),
            blob: any(named: 'blob'),
            checksum: any(named: 'checksum'),
          )).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) {
          return const Err(SyncFailure(
            'Conflict',
            conflictVersion: 3,
          ));
        }
        return const Success(VaultEntity(version: 6));
      });

      stubSuccessfulPull();

      final result = await sut.pushWithRetry(syncPassword, 3);
      expect(result.isSuccess, isTrue);
    });

    test('returns failure after max retries', () async {
      when(() => mockExportImportRepo.exportToJsonString(
            includeCredentials: true,
          )).thenAnswer((_) async => const Success(jsonData));
      when(() => mockEncryption.encryptForExport(any(), any()))
          .thenAnswer((_) async => Success(envelope));
      when(() => mockSyncRepo.putVault(
            version: any(named: 'version'),
            blob: any(named: 'blob'),
            checksum: any(named: 'checksum'),
          )).thenAnswer(
        (_) async => const Err(SyncFailure(
          'Conflict',
          conflictVersion: 3,
        )),
      );

      stubSuccessfulPull();

      final result = await sut.pushWithRetry(syncPassword, 3, maxRetries: 2);
      expect(result.isFailure, isTrue);
    });

    test('aborts immediately on non-conflict failure', () async {
      when(() => mockExportImportRepo.exportToJsonString(
            includeCredentials: true,
          )).thenAnswer((_) async => const Success(jsonData));
      when(() => mockEncryption.encryptForExport(any(), any()))
          .thenAnswer((_) async => Success(envelope));
      when(() => mockSyncRepo.putVault(
            version: any(named: 'version'),
            blob: any(named: 'blob'),
            checksum: any(named: 'checksum'),
          )).thenAnswer(
        (_) async => const Err(SyncFailure('server error')),
      );

      final result = await sut.pushWithRetry(syncPassword, 3);
      expect(result.isFailure, isTrue);
      verify(() => mockSyncRepo.putVault(
            version: any(named: 'version'),
            blob: any(named: 'blob'),
            checksum: any(named: 'checksum'),
          )).called(1); // Only 1 attempt, no retries
    });
  });

  group('changeEncryptionPassword', () {
    test('pulls with old password and pushes with new password', () async {
      // Pull with old password
      when(() => mockSyncRepo.getVault()).thenAnswer(
        (_) async => Success(VaultEntity(
          version: 3,
          blob: validBlob,
          checksum: validChecksum,
        )),
      );
      when(() => mockEncryption.decryptFromExport(any(), 'old-pass'))
          .thenAnswer((_) async => const Success(jsonData));
      when(() => mockExportImportRepo.importFromJsonString(
            any(),
            any(),
            includeCredentials: true,
          )).thenAnswer((_) async => const Success(importResult));

      // Push with new password
      when(() => mockExportImportRepo.exportToJsonString(
            includeCredentials: true,
          )).thenAnswer((_) async => const Success(jsonData));
      when(() => mockEncryption.encryptForExport(jsonData, 'new-pass'))
          .thenAnswer((_) async => Success(envelope));
      when(() => mockSyncRepo.putVault(
            version: any(named: 'version'),
            blob: any(named: 'blob'),
            checksum: any(named: 'checksum'),
          )).thenAnswer(
        (_) async => const Success(VaultEntity(version: 4)),
      );

      final result =
          await sut.changeEncryptionPassword('old-pass', 'new-pass');
      expect(result.isSuccess, isTrue);
      expect(result.value, 4);
    });

    test('returns failure when old password is wrong', () async {
      when(() => mockSyncRepo.getVault()).thenAnswer(
        (_) async => Success(VaultEntity(
          version: 3,
          blob: validBlob,
          checksum: validChecksum,
        )),
      );
      when(() => mockEncryption.decryptFromExport(any(), 'wrong'))
          .thenAnswer(
        (_) async => const Err(CryptoFailure('wrong password')),
      );

      final result =
          await sut.changeEncryptionPassword('wrong', 'new-pass');
      expect(result.isFailure, isTrue);
    });
  });
}
