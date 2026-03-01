import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock_this_device,
              ),
              mOptions: MacOsOptions(
                accessibility: KeychainAccessibility.first_unlock_this_device,
              ),
            );

  String _credentialKey(String serverId) =>
      '${AppConstants.credentialPrefix}$serverId';

  String _sshKeyKey(String keyId) =>
      '${AppConstants.keyPrefix}$keyId';

  Future<Result<void>> savePassword(String serverId, String password) async {
    try {
      await _storage.write(
        key: '${_credentialKey(serverId)}_password',
        value: password,
      );
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('Failed to save password', cause: e));
    }
  }

  Future<Result<String?>> getPassword(String serverId) async {
    try {
      final value = await _storage.read(
        key: '${_credentialKey(serverId)}_password',
      );
      return Success(value);
    } catch (e) {
      return Err(StorageFailure('Failed to read password', cause: e));
    }
  }

  Future<Result<void>> savePrivateKey(String serverId, String key) async {
    try {
      await _storage.write(
        key: '${_credentialKey(serverId)}_key',
        value: key,
      );
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('Failed to save SSH key', cause: e));
    }
  }

  Future<Result<String?>> getPrivateKey(String serverId) async {
    try {
      final value = await _storage.read(
        key: '${_credentialKey(serverId)}_key',
      );
      return Success(value);
    } catch (e) {
      return Err(StorageFailure('Failed to read SSH key', cause: e));
    }
  }

  Future<Result<void>> savePublicKey(String serverId, String key) async {
    try {
      await _storage.write(
        key: '${_credentialKey(serverId)}_pubkey',
        value: key,
      );
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('Failed to save public key', cause: e));
    }
  }

  Future<Result<String?>> getPublicKey(String serverId) async {
    try {
      final value = await _storage.read(
        key: '${_credentialKey(serverId)}_pubkey',
      );
      return Success(value);
    } catch (e) {
      return Err(StorageFailure('Failed to read public key', cause: e));
    }
  }

  Future<Result<void>> savePassphrase(
    String serverId,
    String passphrase,
  ) async {
    try {
      await _storage.write(
        key: '${_credentialKey(serverId)}_passphrase',
        value: passphrase,
      );
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('Failed to save passphrase', cause: e));
    }
  }

  Future<Result<String?>> getPassphrase(String serverId) async {
    try {
      final value = await _storage.read(
        key: '${_credentialKey(serverId)}_passphrase',
      );
      return Success(value);
    } catch (e) {
      return Err(StorageFailure('Failed to read passphrase', cause: e));
    }
  }

  Future<Result<void>> deleteCredentials(String serverId) async {
    try {
      final prefix = _credentialKey(serverId);
      await _storage.delete(key: '${prefix}_password');
      await _storage.delete(key: '${prefix}_key');
      await _storage.delete(key: '${prefix}_pubkey');
      await _storage.delete(key: '${prefix}_passphrase');
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('Failed to delete credentials', cause: e));
    }
  }

  Future<Result<Map<String, String?>>> getAllCredentials(
    String serverId,
  ) async {
    try {
      final prefix = _credentialKey(serverId);
      final password = await _storage.read(key: '${prefix}_password');
      final key = await _storage.read(key: '${prefix}_key');
      final pubkey = await _storage.read(key: '${prefix}_pubkey');
      final passphrase = await _storage.read(key: '${prefix}_passphrase');
      return Success({
        'password': password,
        'privateKey': key,
        'publicKey': pubkey,
        'passphrase': passphrase,
      });
    } catch (e) {
      return Err(StorageFailure('Failed to read credentials', cause: e));
    }
  }

  // --- SSH Key (managed, key-scoped) ---

  Future<Result<void>> saveSshKeyPrivateKey(String keyId, String key) async {
    try {
      await _storage.write(
        key: '${_sshKeyKey(keyId)}_privatekey',
        value: key,
      );
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('Failed to save SSH key private key', cause: e));
    }
  }

  Future<Result<String?>> getSshKeyPrivateKey(String keyId) async {
    try {
      final value = await _storage.read(
        key: '${_sshKeyKey(keyId)}_privatekey',
      );
      return Success(value);
    } catch (e) {
      return Err(StorageFailure('Failed to read SSH key private key', cause: e));
    }
  }

  Future<Result<void>> saveSshKeyPassphrase(
    String keyId,
    String passphrase,
  ) async {
    try {
      await _storage.write(
        key: '${_sshKeyKey(keyId)}_passphrase',
        value: passphrase,
      );
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('Failed to save SSH key passphrase', cause: e));
    }
  }

  Future<Result<String?>> getSshKeyPassphrase(String keyId) async {
    try {
      final value = await _storage.read(
        key: '${_sshKeyKey(keyId)}_passphrase',
      );
      return Success(value);
    } catch (e) {
      return Err(StorageFailure('Failed to read SSH key passphrase', cause: e));
    }
  }

  Future<Result<void>> deleteSshKeySecrets(String keyId) async {
    try {
      final prefix = _sshKeyKey(keyId);
      await _storage.delete(key: '${prefix}_privatekey');
      await _storage.delete(key: '${prefix}_passphrase');
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('Failed to delete SSH key secrets', cause: e));
    }
  }

  // --- DEK (Data Encryption Key) ---

  Future<void> saveDek(Uint8List dek) async {
    final encoded = base64Encode(dek);
    await _storage.write(key: AppConstants.dekStorageKey, value: encoded);
  }

  Future<Uint8List?> loadDek() async {
    final encoded = await _storage.read(key: AppConstants.dekStorageKey);
    if (encoded == null) return null;
    return base64Decode(encoded);
  }

  Future<void> deleteDek() async {
    await _storage.delete(key: AppConstants.dekStorageKey);
  }
}
