import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sshvault/core/storage/database.dart';
import 'package:sshvault/core/storage/database_provider.dart';
import 'package:sshvault/core/storage/secure_storage_provider.dart';
import 'package:sshvault/core/storage/secure_storage_service.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';

class _Storage extends Mock implements SecureStorageService {}

void main() {
  test(
    'unavailable PIN storage fails settings loading instead of removing lock',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      await db.appSettingsDao.setValue('keyring_migration_completed', 'true');
      final storage = _Storage();
      when(
        () => storage.read(key: any(named: 'key')),
      ).thenThrow(StateError('keyring unavailable'));
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          secureStorageProvider.overrideWithValue(storage),
        ],
      );
      addTearDown(container.dispose);
      addTearDown(db.close);
      await expectLater(
        container.read(settingsProvider.future),
        throwsA(isA<StateError>()),
      );
    },
  );
}
