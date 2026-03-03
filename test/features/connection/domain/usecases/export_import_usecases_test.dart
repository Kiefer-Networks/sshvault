import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/connection/domain/repositories/export_import_repository.dart';
import 'package:shellvault/features/connection/domain/usecases/export_import_usecases.dart';

class MockExportImportRepository extends Mock
    implements ExportImportRepository {}

void main() {
  late MockExportImportRepository mockRepo;
  late ExportImportUseCases sut;

  setUp(() {
    mockRepo = MockExportImportRepository();
    sut = ExportImportUseCases(mockRepo);
  });

  setUpAll(() {
    registerFallbackValue(ImportConflictStrategy.skip);
  });

  group('exportToJson', () {
    test('delegates to repository and returns JSON', () async {
      when(() => mockRepo.exportToJson())
          .thenAnswer((_) async => const Success('{"servers":[]}'));

      final result = await sut.exportToJson();
      expect(result.isSuccess, isTrue);
      expect(result.value, '{"servers":[]}');
      verify(() => mockRepo.exportToJson()).called(1);
    });

    test('propagates failure', () async {
      when(() => mockRepo.exportToJson())
          .thenAnswer((_) async => const Err(ExportFailure('export error')));

      final result = await sut.exportToJson();
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ExportFailure>());
    });
  });

  group('exportToEncryptedZip', () {
    test('delegates to repository with password', () async {
      when(() => mockRepo.exportToEncryptedZip('my-pass'))
          .thenAnswer((_) async => const Success('/tmp/export.zip'));

      final result = await sut.exportToEncryptedZip('my-pass');
      expect(result.isSuccess, isTrue);
      expect(result.value, '/tmp/export.zip');
    });

    test('propagates failure', () async {
      when(() => mockRepo.exportToEncryptedZip(any()))
          .thenAnswer((_) async => const Err(ExportFailure('zip error')));

      final result = await sut.exportToEncryptedZip('pass');
      expect(result.isFailure, isTrue);
    });
  });

  group('importFromFile', () {
    test('delegates to repository with path, strategy, and password', () async {
      const importResult = ImportResult(
        serversImported: 3,
        groupsImported: 1,
        tagsImported: 2,
      );
      when(() => mockRepo.importFromFile(
            '/tmp/data.zip',
            ImportConflictStrategy.overwrite,
            password: 'pass',
          )).thenAnswer((_) async => const Success(importResult));

      final result = await sut.importFromFile(
        '/tmp/data.zip',
        ImportConflictStrategy.overwrite,
        password: 'pass',
      );
      expect(result.isSuccess, isTrue);
      expect(result.value.serversImported, 3);
      expect(result.value.groupsImported, 1);
      expect(result.value.tagsImported, 2);
    });

    test('propagates failure', () async {
      when(() => mockRepo.importFromFile(
            any(),
            any(),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Err(ImportFailure('import error')));

      final result = await sut.importFromFile(
        '/tmp/bad.zip',
        ImportConflictStrategy.skip,
      );
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ImportFailure>());
    });
  });
}
