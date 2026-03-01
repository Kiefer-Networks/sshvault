import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/connection/domain/repositories/export_import_repository.dart';

class ExportImportUseCases {
  final ExportImportRepository _repository;

  ExportImportUseCases(this._repository);

  Future<Result<String>> exportToJson() {
    return _repository.exportToJson();
  }

  Future<Result<String>> exportToEncryptedZip(String password) {
    return _repository.exportToEncryptedZip(password);
  }

  Future<Result<ImportResult>> importFromFile(
    String filePath,
    ImportConflictStrategy strategy, {
    String? password,
  }) {
    return _repository.importFromFile(filePath, strategy, password: password);
  }
}
