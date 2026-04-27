import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:sshvault/core/storage/keyring_service.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

/// In-memory [SecretPortalClient] stub that returns a configurable byte
/// array. Lets the tests drive the portal-fallback path without binding
/// to a real D-Bus session bus.
class _FakePortalClient implements SecretPortalClient {
  _FakePortalClient(this._bytes);
  final Uint8List? _bytes;
  int callCount = 0;

  @override
  Future<Uint8List?> retrieveSecret() async {
    callCount++;
    return _bytes;
  }
}

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

  group('KeyringService — org.freedesktop.portal.Secret fallback', () {
    test('writeVaultKey reports portalSecret when libsecret throws and '
        'the portal answers', () async {
      final portal = _FakePortalClient(
        Uint8List.fromList(<int>[0xDE, 0xAD, 0xBE, 0xEF]),
      );
      final svc = KeyringService(
        storage: storage,
        supportDirOverride: tempDir.path,
        portalClient: portal,
      );
      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenThrow(PlatformException(code: 'access_denied'));

      final backend = await svc.writeVaultKey('user-passphrase');

      expect(backend, MasterKeyBackend.portalSecret);
      expect(portal.callCount, 1);
      // The user's passphrase is still persisted to the local
      // fallback file (the portal supplies an *app* secret, not the
      // master key itself).
      final fallback = File(p.join(tempDir.path, kVaultMasterKeyLegacyFile));
      expect(await fallback.exists(), isTrue);
      expect(await fallback.readAsString(), 'user-passphrase');
    });

    test('writeVaultKey reports encryptedFile when neither libsecret nor '
        'the portal answer', () async {
      final portal = _FakePortalClient(null);
      final svc = KeyringService(
        storage: storage,
        supportDirOverride: tempDir.path,
        portalClient: portal,
      );
      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenThrow(PlatformException(code: 'no_secret_service'));

      final backend = await svc.writeVaultKey('user-passphrase');

      expect(backend, MasterKeyBackend.encryptedFile);
      expect(portal.callCount, 1);
    });

    test('readVaultKey hits the portal when the keyring throws and no '
        'fallback file exists', () async {
      final portal = _FakePortalClient(
        Uint8List.fromList(<int>[0x01, 0x02, 0x03]),
      );
      final svc = KeyringService(
        storage: storage,
        supportDirOverride: tempDir.path,
        portalClient: portal,
      );
      when(
        () => storage.read(key: kVaultMasterKeyId),
      ).thenThrow(PlatformException(code: 'no_secret_service'));

      final value = await svc.readVaultKey();

      // Bytes are surfaced as a hex string so the rest of the
      // pipeline (which expects UTF-8) doesn't choke.
      expect(value, '010203');
      expect(portal.callCount, 1);
    });

    test('readVaultKey prefers the legacy file over the portal when both '
        'exist', () async {
      final portal = _FakePortalClient(Uint8List.fromList(<int>[0xAA]));
      final svc = KeyringService(
        storage: storage,
        supportDirOverride: tempDir.path,
        portalClient: portal,
      );
      await File(
        p.join(tempDir.path, kVaultMasterKeyLegacyFile),
      ).writeAsString('on-disk');
      when(
        () => storage.read(key: kVaultMasterKeyId),
      ).thenThrow(PlatformException(code: 'no_secret_service'));

      final value = await svc.readVaultKey();

      expect(value, 'on-disk');
      // The portal must not be hit when the file fallback already
      // resolved the value.
      expect(portal.callCount, 0);
    });

    test('currentBackend reports portalSecret when both the legacy file '
        'and the portal cache are present', () async {
      final svc = KeyringService(
        storage: storage,
        supportDirOverride: tempDir.path,
        portalClient: _FakePortalClient(null),
      );
      // Simulate a previous portal-mediated write: legacy file +
      // portal secret cache co-exist under the support dir.
      await File(
        p.join(tempDir.path, kVaultMasterKeyLegacyFile),
      ).writeAsString('cached');
      await File(
        p.join(tempDir.path, 'portal.secret.bin'),
      ).writeAsBytes(<int>[0xCA, 0xFE]);
      when(
        () => storage.read(key: kVaultMasterKeyId),
      ).thenAnswer((_) async => null);

      expect(await svc.currentBackend(), MasterKeyBackend.portalSecret);
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
