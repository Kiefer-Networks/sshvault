import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/core/network/api_provider.dart';
import 'package:sshvault/core/storage/secure_storage_service.dart';
import 'package:sshvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:sshvault/features/settings/domain/entities/app_settings_entity.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/features/sync/domain/usecases/sync_usecases.dart';
import 'package:sshvault/features/sync/presentation/providers/sync_providers.dart';

class _Auth extends AuthNotifier {
  @override
  Future<AuthStatus> build() async => AuthStatus.authenticated;
}

class _Settings extends SettingsNotifier {
  @override
  Future<AppSettingsEntity> build() async =>
      const AppSettingsEntity(localVaultVersion: 3);
  int? savedVersion;
  @override
  Future<void> setLocalVaultVersion(int version) async {
    savedVersion = version;
  }
}

class _Storage extends Mock implements SecureStorageService {}

class _UseCases extends Mock implements SyncUseCases {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;
  late _UseCases useCases;
  late _Storage storage;
  setUp(() async {
    storage = _Storage();
    when(
      () => storage.getSyncPassword(),
    ).thenAnswer((_) async => const Success('wrong'));
    useCases = _UseCases();
    container = ProviderContainer(
      overrides: [
        authProvider.overrideWith(_Auth.new),
        settingsProvider.overrideWith(_Settings.new),
        secureStorageProvider.overrideWithValue(storage),
        syncUseCasesProvider.overrideWithValue(useCases),
      ],
    );
    await container.read(authProvider.future);
    await container.read(settingsProvider.future);
    await container.read(syncProvider.future);
  });
  tearDown(() => container.dispose());

  test(
    'changing encryption password saves replacement and version without logout',
    () async {
      when(
        () => useCases.changeEncryptionPassword('old', 'new-password'),
      ).thenAnswer((_) async => const Success(4));
      when(
        () => storage.saveSyncPassword('new-password'),
      ).thenAnswer((_) async => const Success(null));
      final settings = container.read(settingsProvider.notifier) as _Settings;
      final result = await container
          .read(syncProvider.notifier)
          .changeEncryptionPassword('old', 'new-password');
      expect(result.isSuccess, isTrue);
      expect(settings.savedVersion, 4);
      expect(container.read(authProvider).value, AuthStatus.authenticated);
      verify(() => storage.saveSyncPassword('new-password')).called(1);
      verifyNever(() => storage.clearAllData());
    },
  );

  test('decryption failure never overwrites the remote vault', () async {
    when(
      () => useCases.sync('wrong', 3),
    ).thenAnswer((_) async => const Err(CryptoFailure('wrong password')));
    when(
      () => useCases.push(any(), any()),
    ).thenAnswer((_) async => const Err(SyncFailure('unexpected upload')));
    await container.read(syncProvider.notifier).sync();
    verifyNever(() => useCases.push(any(), any()));
    expect(container.read(syncProvider).error, isA<CryptoFailure>());
  });

  test(
    'overlapping sync commands cannot import and upload concurrently',
    () async {
      final gate = Completer<Result<int>>();
      when(() => useCases.sync('wrong', 3)).thenAnswer((_) => gate.future);
      when(
        () => useCases.pushWithRetry(any(), any()),
      ).thenAnswer((_) async => const Err(SyncFailure('unexpected upload')));
      final first = container.read(syncProvider.notifier).sync();
      await Future<void>.delayed(Duration.zero);
      final second = container.read(syncProvider.notifier).pushOnly();
      await Future<void>.delayed(Duration.zero);
      verifyNever(() => useCases.pushWithRetry(any(), any()));
      gate.complete(const Success(4));
      await Future.wait([first, second]);
      verify(() => useCases.pushWithRetry(any(), any())).called(1);
    },
  );

  test('stopAndWait settles active sync and blocks subsequent work', () async {
    final gate = Completer<Result<int>>();
    when(() => useCases.sync('wrong', 3)).thenAnswer((_) => gate.future);
    final notifier = container.read(syncProvider.notifier);
    final active = notifier.sync();
    await Future<void>.delayed(Duration.zero);
    var stopped = false;
    final stopping = notifier.stopAndWait().then((_) => stopped = true);
    await Future<void>.delayed(Duration.zero);
    expect(stopped, isFalse);
    gate.complete(const Err(SyncFailure('offline')));
    await Future.wait([active, stopping]);
    expect(stopped, isTrue);
    await notifier.sync();
    verify(() => useCases.sync('wrong', 3)).called(1);
  });
}
