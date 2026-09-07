import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/core/storage/database.dart';
import 'package:sshvault/core/storage/database_provider.dart';
import 'package:sshvault/core/storage/keyring_service.dart';
import 'package:sshvault/core/storage/secure_storage_provider.dart';
import 'package:sshvault/core/storage/secure_storage_service.dart';
import 'package:sshvault/core/storage/vault_reset_service.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/sync/presentation/providers/sync_providers.dart';

class _Storage extends Mock implements SecureStorageService {}

class _Keyring extends Mock implements KeyringService {}

class _Sync extends SyncNotifier {
  bool stopped = false;
  @override
  Future<SyncStatus> build() async => SyncStatus.idle;
  @override
  Future<void> stopAndWait() async {
    stopped = true;
  }
}

void main() {
  late AppDatabase db;
  late _Storage storage;
  late _Keyring keyring;
  late _Sync sync;
  late ProviderContainer container;
  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    storage = _Storage();
    keyring = _Keyring();
    sync = _Sync();
    container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        databaseProvider.overrideWithValue(db),
        secureStorageProvider.overrideWithValue(storage),
        keyringServiceProvider.overrideWithValue(keyring),
        syncProvider.overrideWith(() => sync),
      ],
    );
    when(
      () => storage.clearAllData(),
    ).thenAnswer((_) async => const Success(null));
    when(() => keyring.deleteVaultKey()).thenAnswer((_) async {});
    final now = DateTime(2026);
    await db.serverDao.insertServer(
      ServersCompanion.insert(
        id: 's',
        name: 'private',
        hostname: 'private.host',
        username: 'user',
        createdAt: now,
        updatedAt: now,
      ),
    );
  });
  tearDown(() async {
    container.dispose();
    await db.close();
  });

  test(
    'wipe clears cached list and details as well as persisted records',
    () async {
      expect(await container.read(serverListProvider.future), hasLength(1));
      expect(
        (await container.read(serverDetailProvider('s').future)).name,
        'private',
      );
      await resetLocalVault(container);
      expect(sync.stopped, isTrue);
      expect(await db.serverDao.getAllServersIncludingDeleted(), isEmpty);
      expect(await container.read(serverListProvider.future), isEmpty);
      await expectLater(
        container.read(serverDetailProvider('s').future),
        throwsA(isA<NotFoundFailure>()),
      );
    },
  );

  test('a failed credential wipe must not report success', () async {
    when(
      () => storage.clearAllData(),
    ).thenAnswer((_) async => const Err(StorageFailure('denied')));
    await expectLater(
      resetLocalVault(container),
      throwsA(isA<StorageFailure>()),
    );
  });
}
