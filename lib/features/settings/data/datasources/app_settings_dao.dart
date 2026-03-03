import 'package:drift/drift.dart';
import 'package:shellvault/core/storage/database.dart';
import 'package:shellvault/features/connection/data/models/drift_tables.dart';

part 'app_settings_dao.g.dart';

@DriftAccessor(tables: [AppSettings])
class AppSettingsDao extends DatabaseAccessor<AppDatabase>
    with _$AppSettingsDaoMixin {
  AppSettingsDao(super.db);

  Future<String?> getValue(String key) async {
    final result = await (select(
      appSettings,
    )..where((s) => s.key.equals(key))).getSingleOrNull();
    return result?.value;
  }

  /// Fetches all settings in a single query and returns them as a Map.
  Future<Map<String, String>> getAll() async {
    final rows = await select(appSettings).get();
    return {for (final row in rows) row.key: row.value};
  }

  Future<void> setValue(String key, String value) async {
    await into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion.insert(key: key, value: value),
    );
  }

  Future<int> deleteValue(String key) =>
      (delete(appSettings)..where((s) => s.key.equals(key))).go();
}
