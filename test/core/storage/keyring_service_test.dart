import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:sshvault/core/storage/keyring_service.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  // Required so mocktail can synthesize matchers for the named arg variants
  // we use throughout this suite.
  setUpAll(() {
    registerFallbackValue('');
  });

  late _MockSecureStorage storage;
  late Directory tempDir;
  late KeyringService sut;

  setUp(() async {
    storage = _MockSecureStorage();
    tempDir = await Directory.systemTemp.createTemp('keyring_test_');
    sut = KeyringService(storage: storage, supportDirOverride: tempDir.path);
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('KeyringService — schema metadata', () {
    test('exposes the expected libsecret schema name', () {
      expect(kVaultKeyringSchemaName, 'de.kiefer_networks.SSHVault.Vault');
    });

    test('exposes the expected libsecret label', () {
      expect(kVaultKeyringLabel, 'SSHVault master key');
    });

    test('uses a stable storage key for the master vault key', () {
      expect(kVaultMasterKeyId, 'sv_vault_master_key');
    });
  });

  group('KeyringService — read/write/delete', () {
    test('readVaultKey delegates to FlutterSecureStorage', () async {
      when(
        () => storage.read(key: kVaultMasterKeyId),
      ).thenAnswer((_) async => 'super-secret');

      final value = await sut.readVaultKey();

      expect(value, 'super-secret');
      verify(() => storage.read(key: kVaultMasterKeyId)).called(1);
    });

    test(
      'writeVaultKey writes via the keyring and reports systemKeyring',
      () async {
        when(
          () => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        final backend = await sut.writeVaultKey('top-secret');

        expect(backend, MasterKeyBackend.systemKeyring);
        verify(
          () => storage.write(key: kVaultMasterKeyId, value: 'top-secret'),
        ).called(1);
      },
    );

    test(
      'deleteVaultKey removes the keyring entry and the fallback file',
      () async {
        // Prime a fallback file so we can confirm it is also wiped.
        final legacyFile = File(
          p.join(tempDir.path, kVaultMasterKeyLegacyFile),
        );
        await legacyFile.writeAsString('stale');
        when(
          () => storage.delete(key: kVaultMasterKeyId),
        ).thenAnswer((_) async {});

        await sut.deleteVaultKey();

        expect(await legacyFile.exists(), isFalse);
        verify(() => storage.delete(key: kVaultMasterKeyId)).called(1);
      },
    );
  });

  group('KeyringService — fallback when libsecret is unavailable', () {
    test(
      'writeVaultKey writes the fallback file when keyring throws',
      () async {
        when(
          () => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenThrow(PlatformException(code: 'no_secret_service'));

        final backend = await sut.writeVaultKey('fallback-value');

        expect(backend, MasterKeyBackend.encryptedFile);
        final legacyFile = File(
          p.join(tempDir.path, kVaultMasterKeyLegacyFile),
        );
        expect(await legacyFile.exists(), isTrue);
        expect(await legacyFile.readAsString(), 'fallback-value');
      },
    );

    test('readVaultKey falls back to the file when keyring throws', () async {
      final legacyFile = File(p.join(tempDir.path, kVaultMasterKeyLegacyFile));
      await legacyFile.writeAsString('on-disk');
      when(
        () => storage.read(key: kVaultMasterKeyId),
      ).thenThrow(PlatformException(code: 'no_secret_service'));

      final value = await sut.readVaultKey();

      expect(value, 'on-disk');
    });

    test('readVaultKey returns null when neither backend has data', () async {
      when(
        () => storage.read(key: kVaultMasterKeyId),
      ).thenAnswer((_) async => null);

      expect(await sut.readVaultKey(), isNull);
    });
  });

  group('KeyringService — migrateLegacyFileIfNeeded', () {
    test('returns false when no legacy file is present', () async {
      expect(await sut.migrateLegacyFileIfNeeded(), isFalse);
      verifyNever(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      );
    });

    test('moves the legacy file into the keyring when one exists', () async {
      final legacyFile = File(p.join(tempDir.path, kVaultMasterKeyLegacyFile));
      await legacyFile.writeAsString('legacy-key');
      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      final migrated = await sut.migrateLegacyFileIfNeeded();

      expect(migrated, isTrue);
      expect(await legacyFile.exists(), isFalse);
      verify(
        () => storage.write(key: kVaultMasterKeyId, value: 'legacy-key'),
      ).called(1);
    });

    test('keeps the legacy file when the keyring write fails', () async {
      final legacyFile = File(p.join(tempDir.path, kVaultMasterKeyLegacyFile));
      await legacyFile.writeAsString('legacy-key');
      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenThrow(PlatformException(code: 'no_secret_service'));

      final migrated = await sut.migrateLegacyFileIfNeeded();

      expect(migrated, isFalse);
      expect(await legacyFile.exists(), isTrue);
    });
  });

  group('KeyringService — currentBackend', () {
    test('reports systemKeyring when the keyring has the master key', () async {
      when(
        () => storage.read(key: kVaultMasterKeyId),
      ).thenAnswer((_) async => 'present');

      expect(await sut.currentBackend(), MasterKeyBackend.systemKeyring);
    });

    test('reports encryptedFile when only the fallback file exists', () async {
      when(
        () => storage.read(key: kVaultMasterKeyId),
      ).thenAnswer((_) async => null);
      await File(
        p.join(tempDir.path, kVaultMasterKeyLegacyFile),
      ).writeAsString('on-disk');

      expect(await sut.currentBackend(), MasterKeyBackend.encryptedFile);
    });

    test('returns null when nothing is stored anywhere', () async {
      when(
        () => storage.read(key: kVaultMasterKeyId),
      ).thenAnswer((_) async => null);

      expect(await sut.currentBackend(), isNull);
    });
  });
}

/// Minimal stand-in for `flutter`'s `PlatformException` so the test does not
/// depend on the Flutter binding being initialized. `flutter_secure_storage`
/// surfaces these on libsecret failures; the keyring service only inspects
/// the fact that *something* threw, not the exception type.
class PlatformException implements Exception {
  PlatformException({required this.code});
  final String code;

  @override
  String toString() => 'PlatformException($code)';
}
