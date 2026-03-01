import 'package:shellvault/core/error/result.dart';

enum ImportConflictStrategy { skip, overwrite, rename }

class ImportResult {
  final int serversImported;
  final int groupsImported;
  final int tagsImported;
  final int sshKeysImported;
  final int skipped;
  final List<String> errors;

  const ImportResult({
    this.serversImported = 0,
    this.groupsImported = 0,
    this.tagsImported = 0,
    this.sshKeysImported = 0,
    this.skipped = 0,
    this.errors = const [],
  });
}

abstract class ExportImportRepository {
  Future<Result<String>> exportToJson();
  Future<Result<String>> exportToEncryptedZip(String password);
  Future<Result<ImportResult>> importFromFile(
    String filePath,
    ImportConflictStrategy strategy, {
    String? password,
  });

  /// Export data as a JSON string (no file I/O). Used by Sync.
  Future<Result<String>> exportToJsonString({bool includeCredentials = false});

  /// Import data from a JSON string (no file I/O). Used by Sync.
  Future<Result<ImportResult>> importFromJsonString(
    String jsonString,
    ImportConflictStrategy strategy, {
    bool includeCredentials = false,
  });
}
