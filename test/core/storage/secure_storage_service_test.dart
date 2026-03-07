import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/storage/secure_storage_service.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockStorage;
  late SecureStorageService sut;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    sut = SecureStorageService(storage: mockStorage);
  });

  group('SecureStorageService — password', () {
    test('savePassword writes to storage', () async {
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      final result = await sut.savePassword('server1', 'mypass');
      expect(result.isSuccess, isTrue);
      verify(
        () => mockStorage.write(
          key: '${AppConstants.credentialPrefix}server1_password',
          value: 'mypass',
        ),
      ).called(1);
    });

    test('getPassword reads from storage', () async {
      when(
        () => mockStorage.read(key: any(named: 'key')),
      ).thenAnswer((_) async => 'mypass');

      final result = await sut.getPassword('server1');
      expect(result.isSuccess, isTrue);
      expect(result.value, 'mypass');
    });

    test('getPassword returns null when not found', () async {
      when(
        () => mockStorage.read(key: any(named: 'key')),
      ).thenAnswer((_) async => null);

      final result = await sut.getPassword('server1');
      expect(result.isSuccess, isTrue);
      expect(result.value, isNull);
    });

    test('savePassword returns StorageFailure on error', () async {
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenThrow(Exception('storage error'));

      final result = await sut.savePassword('server1', 'mypass');
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<StorageFailure>());
    });

    test('getPassword returns StorageFailure on error', () async {
      when(
        () => mockStorage.read(key: any(named: 'key')),
      ).thenThrow(Exception('storage error'));

      final result = await sut.getPassword('server1');
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<StorageFailure>());
    });
  });

  group('SecureStorageService — private key', () {
    test('savePrivateKey writes to storage', () async {
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      final result = await sut.savePrivateKey('server1', 'pem-key');
      expect(result.isSuccess, isTrue);
      verify(
        () => mockStorage.write(
          key: '${AppConstants.credentialPrefix}server1_key',
          value: 'pem-key',
        ),
      ).called(1);
    });

    test('getPrivateKey reads from storage', () async {
      when(
        () => mockStorage.read(key: any(named: 'key')),
      ).thenAnswer((_) async => 'pem-key');

      final result = await sut.getPrivateKey('server1');
      expect(result.isSuccess, isTrue);
      expect(result.value, 'pem-key');
    });
  });

  group('SecureStorageService — public key', () {
    test('savePublicKey writes to storage', () async {
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      final result = await sut.savePublicKey('server1', 'ssh-ed25519 AAAA...');
      expect(result.isSuccess, isTrue);
    });

    test('getPublicKey reads from storage', () async {
      when(
        () => mockStorage.read(key: any(named: 'key')),
      ).thenAnswer((_) async => 'ssh-ed25519 AAAA...');

      final result = await sut.getPublicKey('server1');
      expect(result.isSuccess, isTrue);
      expect(result.value, 'ssh-ed25519 AAAA...');
    });
  });

  group('SecureStorageService — passphrase', () {
    test('savePassphrase writes to storage', () async {
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      final result = await sut.savePassphrase('server1', 'my-passphrase');
      expect(result.isSuccess, isTrue);
    });

    test('getPassphrase reads from storage', () async {
      when(
        () => mockStorage.read(key: any(named: 'key')),
      ).thenAnswer((_) async => 'my-passphrase');

      final result = await sut.getPassphrase('server1');
      expect(result.isSuccess, isTrue);
      expect(result.value, 'my-passphrase');
    });
  });

  group('SecureStorageService — deleteCredentials', () {
    test('deletes all credential keys for a server', () async {
      when(
        () => mockStorage.delete(key: any(named: 'key')),
      ).thenAnswer((_) async {});

      final result = await sut.deleteCredentials('server1');
      expect(result.isSuccess, isTrue);

      const prefix = '${AppConstants.credentialPrefix}server1';
      verify(() => mockStorage.delete(key: '${prefix}_password')).called(1);
      verify(() => mockStorage.delete(key: '${prefix}_key')).called(1);
      verify(() => mockStorage.delete(key: '${prefix}_pubkey')).called(1);
      verify(() => mockStorage.delete(key: '${prefix}_passphrase')).called(1);
    });

    test('deleteCredentials returns StorageFailure on error', () async {
      when(
        () => mockStorage.delete(key: any(named: 'key')),
      ).thenThrow(Exception('delete error'));

      final result = await sut.deleteCredentials('server1');
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<StorageFailure>());
    });
  });

  group('SecureStorageService — getAllCredentials', () {
    test('returns map of all credential values', () async {
      when(() => mockStorage.read(key: any(named: 'key'))).thenAnswer((
        invocation,
      ) async {
        final key = invocation.namedArguments[#key] as String;
        if (key.endsWith('_password')) return 'pass123';
        if (key.endsWith('_key')) return 'private-key';
        if (key.endsWith('_pubkey')) return 'public-key';
        if (key.endsWith('_passphrase')) return 'phrase';
        return null;
      });

      final result = await sut.getAllCredentials('server1');
      expect(result.isSuccess, isTrue);
      expect(result.value['password'], 'pass123');
      expect(result.value['privateKey'], 'private-key');
      expect(result.value['publicKey'], 'public-key');
      expect(result.value['passphrase'], 'phrase');
    });
  });

  group('SecureStorageService — SSH key secrets', () {
    test('saveSshKeyPrivateKey writes to storage', () async {
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      final result = await sut.saveSshKeyPrivateKey('key1', 'pem-data');
      expect(result.isSuccess, isTrue);
      verify(
        () => mockStorage.write(
          key: '${AppConstants.keyPrefix}key1_privatekey',
          value: 'pem-data',
        ),
      ).called(1);
    });

    test('getSshKeyPrivateKey reads from storage', () async {
      when(
        () => mockStorage.read(key: any(named: 'key')),
      ).thenAnswer((_) async => 'pem-data');

      final result = await sut.getSshKeyPrivateKey('key1');
      expect(result.isSuccess, isTrue);
      expect(result.value, 'pem-data');
    });

    test('saveSshKeyPassphrase writes to storage', () async {
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      final result = await sut.saveSshKeyPassphrase('key1', 'phrase');
      expect(result.isSuccess, isTrue);
    });

    test('getSshKeyPassphrase reads from storage', () async {
      when(
        () => mockStorage.read(key: any(named: 'key')),
      ).thenAnswer((_) async => 'phrase');

      final result = await sut.getSshKeyPassphrase('key1');
      expect(result.isSuccess, isTrue);
      expect(result.value, 'phrase');
    });

    test('deleteSshKeySecrets deletes both keys', () async {
      when(
        () => mockStorage.delete(key: any(named: 'key')),
      ).thenAnswer((_) async {});

      final result = await sut.deleteSshKeySecrets('key1');
      expect(result.isSuccess, isTrue);

      const prefix = '${AppConstants.keyPrefix}key1';
      verify(() => mockStorage.delete(key: '${prefix}_privatekey')).called(1);
      verify(() => mockStorage.delete(key: '${prefix}_passphrase')).called(1);
    });
  });

  group('SecureStorageService — DEK', () {
    test('saveDek encodes and writes to storage', () async {
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      final dek = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);
      final result = await sut.saveDek(dek);
      expect(result.isSuccess, isTrue);
      verify(
        () => mockStorage.write(
          key: AppConstants.dekStorageKey,
          value: base64Encode(dek),
        ),
      ).called(1);
    });

    test('loadDek returns decoded bytes', () async {
      const dek = [1, 2, 3, 4, 5, 6, 7, 8];
      when(
        () => mockStorage.read(key: AppConstants.dekStorageKey),
      ).thenAnswer((_) async => base64Encode(Uint8List.fromList(dek)));

      final result = await sut.loadDek();
      expect(result.isSuccess, isTrue);
      expect(result.value, Uint8List.fromList(dek));
    });

    test('loadDek returns null when not stored', () async {
      when(
        () => mockStorage.read(key: AppConstants.dekStorageKey),
      ).thenAnswer((_) async => null);

      final result = await sut.loadDek();
      expect(result.isSuccess, isTrue);
      expect(result.value, isNull);
    });

    test('deleteDek removes key from storage', () async {
      when(
        () => mockStorage.delete(key: any(named: 'key')),
      ).thenAnswer((_) async {});

      final result = await sut.deleteDek();
      expect(result.isSuccess, isTrue);
      verify(
        () => mockStorage.delete(key: AppConstants.dekStorageKey),
      ).called(1);
    });
  });

  group('SecureStorageService — auth tokens', () {
    test('saveAccessToken writes to storage', () async {
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      final result = await sut.saveAccessToken('jwt-token');
      expect(result.isSuccess, isTrue);
      verify(
        () => mockStorage.write(
          key: AppConstants.accessTokenKey,
          value: 'jwt-token',
        ),
      ).called(1);
    });

    test('getAccessToken reads from storage', () async {
      when(
        () => mockStorage.read(key: AppConstants.accessTokenKey),
      ).thenAnswer((_) async => 'jwt-token');

      final result = await sut.getAccessToken();
      expect(result.isSuccess, isTrue);
      expect(result.value, 'jwt-token');
    });

    test('saveRefreshToken writes to storage', () async {
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      final result = await sut.saveRefreshToken('refresh-token');
      expect(result.isSuccess, isTrue);
    });

    test('getRefreshToken reads from storage', () async {
      when(
        () => mockStorage.read(key: AppConstants.refreshTokenKey),
      ).thenAnswer((_) async => 'refresh-token');

      final result = await sut.getRefreshToken();
      expect(result.isSuccess, isTrue);
      expect(result.value, 'refresh-token');
    });

    test('saveTokenExpiry writes ISO date', () async {
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      final result = await sut.saveTokenExpiry('2025-12-31T23:59:59Z');
      expect(result.isSuccess, isTrue);
    });

    test('getTokenExpiry reads ISO date', () async {
      when(
        () => mockStorage.read(key: AppConstants.tokenExpiryKey),
      ).thenAnswer((_) async => '2025-12-31T23:59:59Z');

      final result = await sut.getTokenExpiry();
      expect(result.isSuccess, isTrue);
      expect(result.value, '2025-12-31T23:59:59Z');
    });
  });

  group('SecureStorageService — sync password and email', () {
    test('saveSyncPassword writes to storage', () async {
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      final result = await sut.saveSyncPassword('sync-pass');
      expect(result.isSuccess, isTrue);
    });

    test('getSyncPassword reads from storage', () async {
      when(
        () => mockStorage.read(key: AppConstants.syncPasswordKey),
      ).thenAnswer((_) async => 'sync-pass');

      final result = await sut.getSyncPassword();
      expect(result.isSuccess, isTrue);
      expect(result.value, 'sync-pass');
    });

    test('saveUserEmail writes to storage', () async {
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      final result = await sut.saveUserEmail('user@example.com');
      expect(result.isSuccess, isTrue);
    });

    test('getUserEmail reads from storage', () async {
      when(
        () => mockStorage.read(key: AppConstants.userEmailKey),
      ).thenAnswer((_) async => 'user@example.com');

      final result = await sut.getUserEmail();
      expect(result.isSuccess, isTrue);
      expect(result.value, 'user@example.com');
    });
  });

  group('SecureStorageService — clearAuthTokens', () {
    test('deletes all auth-related keys', () async {
      when(
        () => mockStorage.delete(key: any(named: 'key')),
      ).thenAnswer((_) async {});

      final result = await sut.clearAuthTokens();
      expect(result.isSuccess, isTrue);

      verify(
        () => mockStorage.delete(key: AppConstants.accessTokenKey),
      ).called(1);
      verify(
        () => mockStorage.delete(key: AppConstants.refreshTokenKey),
      ).called(1);
      verify(
        () => mockStorage.delete(key: AppConstants.tokenExpiryKey),
      ).called(1);
      verify(
        () => mockStorage.delete(key: AppConstants.userEmailKey),
      ).called(1);
      // Sync password, DEK, and device ID are intentionally preserved
      // so re-login doesn't require re-entering the encryption passphrase.
      verifyNever(() => mockStorage.delete(key: AppConstants.syncPasswordKey));
      verifyNever(() => mockStorage.delete(key: AppConstants.dekStorageKey));
      verifyNever(() => mockStorage.delete(key: AppConstants.deviceIdKey));
    });

    test('clearAuthTokens returns StorageFailure on error', () async {
      when(
        () => mockStorage.delete(key: any(named: 'key')),
      ).thenThrow(Exception('clear error'));

      final result = await sut.clearAuthTokens();
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<StorageFailure>());
    });
  });

  group('SecureStorageService — device ID', () {
    test('saveDeviceId writes to storage', () async {
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      final result = await sut.saveDeviceId('device-uuid');
      expect(result.isSuccess, isTrue);
      verify(
        () => mockStorage.write(
          key: AppConstants.deviceIdKey,
          value: 'device-uuid',
        ),
      ).called(1);
    });

    test('getDeviceId reads from storage', () async {
      when(
        () => mockStorage.read(key: AppConstants.deviceIdKey),
      ).thenAnswer((_) async => 'device-uuid');

      final result = await sut.getDeviceId();
      expect(result.isSuccess, isTrue);
      expect(result.value, 'device-uuid');
    });

    test('deleteDeviceId removes from storage', () async {
      when(
        () => mockStorage.delete(key: any(named: 'key')),
      ).thenAnswer((_) async {});

      final result = await sut.deleteDeviceId();
      expect(result.isSuccess, isTrue);
      verify(() => mockStorage.delete(key: AppConstants.deviceIdKey)).called(1);
    });
  });
}
