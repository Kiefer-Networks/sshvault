import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/error/result.dart';

class SecureStorageService {
  static const Duration _passwordTimeout = Duration(days: 30);

  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            // ignore: deprecated_member_use
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
            mOptions: MacOsOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
            lOptions: LinuxOptions(),
            wOptions: WindowsOptions(),
          );

  String _credentialKey(String serverId) =>
      '${AppConstants.credentialPrefix}$serverId';

  String _sshKeyKey(String keyId) => '${AppConstants.keyPrefix}$keyId';

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
      await _storage.write(key: '${_credentialKey(serverId)}_key', value: key);
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('Failed to save SSH key', cause: e));
    }
  }

  Future<Result<String?>> getPrivateKey(String serverId) async {
    try {
      final value = await _storage.read(key: '${_credentialKey(serverId)}_key');
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
      await _storage.write(key: '${_sshKeyKey(keyId)}_privatekey', value: key);
      return const Success(null);
    } catch (e) {
      return Err(
        StorageFailure('Failed to save SSH key private key', cause: e),
      );
    }
  }

  Future<Result<String?>> getSshKeyPrivateKey(String keyId) async {
    try {
      final value = await _storage.read(key: '${_sshKeyKey(keyId)}_privatekey');
      return Success(value);
    } catch (e) {
      return Err(
        StorageFailure('Failed to read SSH key private key', cause: e),
      );
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
      final value = await _storage.read(key: '${_sshKeyKey(keyId)}_passphrase');
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

  Future<Result<void>> saveDek(Uint8List dek) async {
    try {
      final encoded = base64Encode(dek);
      await _storage.write(key: AppConstants.dekStorageKey, value: encoded);
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('Failed to save DEK', cause: e));
    }
  }

  Future<Result<Uint8List?>> loadDek() async {
    try {
      final encoded = await _storage.read(key: AppConstants.dekStorageKey);
      if (encoded == null) return const Success(null);
      return Success(base64Decode(encoded));
    } catch (e) {
      return Err(StorageFailure('Failed to load DEK', cause: e));
    }
  }

  Future<Result<void>> deleteDek() async {
    try {
      await _storage.delete(key: AppConstants.dekStorageKey);
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('Failed to delete DEK', cause: e));
    }
  }

  // --- Auth Tokens ---

  Future<Result<void>> saveAccessToken(String token) async {
    try {
      await _storage.write(key: AppConstants.accessTokenKey, value: token);
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('Failed to save access token', cause: e));
    }
  }

  Future<Result<String?>> getAccessToken() async {
    try {
      final value = await _storage.read(key: AppConstants.accessTokenKey);
      return Success(value);
    } catch (e) {
      return Err(StorageFailure('Failed to read access token', cause: e));
    }
  }

  Future<Result<void>> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: AppConstants.refreshTokenKey, value: token);
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('Failed to save refresh token', cause: e));
    }
  }

  Future<Result<String?>> getRefreshToken() async {
    try {
      final value = await _storage.read(key: AppConstants.refreshTokenKey);
      return Success(value);
    } catch (e) {
      return Err(StorageFailure('Failed to read refresh token', cause: e));
    }
  }

  Future<Result<void>> saveTokenExpiry(String isoDate) async {
    try {
      await _storage.write(key: AppConstants.tokenExpiryKey, value: isoDate);
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('Failed to save token expiry', cause: e));
    }
  }

  Future<Result<String?>> getTokenExpiry() async {
    try {
      final value = await _storage.read(key: AppConstants.tokenExpiryKey);
      return Success(value);
    } catch (e) {
      return Err(StorageFailure('Failed to read token expiry', cause: e));
    }
  }

  Future<Result<void>> saveSyncPassword(String password) async {
    try {
      await _storage.write(key: AppConstants.syncPasswordKey, value: password);
      await _storage.write(
        key: AppConstants.syncPasswordLastUsedKey,
        value: DateTime.now().toUtc().toIso8601String(),
      );
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('Failed to save sync password', cause: e));
    }
  }

  Future<Result<String?>> getSyncPassword() async {
    try {
      final lastUsed = await _storage.read(
        key: AppConstants.syncPasswordLastUsedKey,
      );
      if (lastUsed != null) {
        final lastUsedDate = DateTime.tryParse(lastUsed);
        if (lastUsedDate != null &&
            DateTime.now().toUtc().difference(lastUsedDate) >
                _passwordTimeout) {
          await _deleteSyncPasswordKeys();
          return const Success(null);
        }
      }

      final value = await _storage.read(key: AppConstants.syncPasswordKey);
      if (value != null) {
        await _storage.write(
          key: AppConstants.syncPasswordLastUsedKey,
          value: DateTime.now().toUtc().toIso8601String(),
        );
      }
      return Success(value);
    } catch (e) {
      return Err(StorageFailure('Failed to read sync password', cause: e));
    }
  }

  Future<Result<void>> deleteSyncPassword() async {
    try {
      await _deleteSyncPasswordKeys();
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('Failed to delete sync password', cause: e));
    }
  }

  Future<void> _deleteSyncPasswordKeys() async {
    await _storage.delete(key: AppConstants.syncPasswordKey);
    await _storage.delete(key: AppConstants.syncPasswordLastUsedKey);
  }

  Future<Result<void>> saveUserEmail(String email) async {
    try {
      await _storage.write(key: AppConstants.userEmailKey, value: email);
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('Failed to save user email', cause: e));
    }
  }

  Future<Result<String?>> getUserEmail() async {
    try {
      final value = await _storage.read(key: AppConstants.userEmailKey);
      return Success(value);
    } catch (e) {
      return Err(StorageFailure('Failed to read user email', cause: e));
    }
  }

  Future<Result<void>> clearAuthTokens({
    bool forgetPasswordOnLogout = false,
  }) async {
    try {
      await _storage.delete(key: AppConstants.accessTokenKey);
      await _storage.delete(key: AppConstants.refreshTokenKey);
      await _storage.delete(key: AppConstants.tokenExpiryKey);
      await _storage.delete(key: AppConstants.userEmailKey);
      if (forgetPasswordOnLogout) {
        await _deleteSyncPasswordKeys();
      }
      // Unless forgetPasswordOnLogout is set, sync password, DEK, and
      // device ID are intentionally preserved so re-login doesn't
      // require the user to re-enter the encryption passphrase.
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('Failed to clear auth tokens', cause: e));
    }
  }

  // --- Device ID ---

  Future<Result<void>> saveDeviceId(String id) async {
    try {
      await _storage.write(key: AppConstants.deviceIdKey, value: id);
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('Failed to save device ID', cause: e));
    }
  }

  Future<Result<String?>> getDeviceId() async {
    try {
      final value = await _storage.read(key: AppConstants.deviceIdKey);
      return Success(value);
    } catch (e) {
      return Err(StorageFailure('Failed to read device ID', cause: e));
    }
  }

  Future<Result<void>> deleteDeviceId() async {
    try {
      await _storage.delete(key: AppConstants.deviceIdKey);
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('Failed to delete device ID', cause: e));
    }
  }

  Future<Result<void>> clearAllData() async {
    try {
      await _storage.deleteAll();
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('Failed to clear all data', cause: e));
    }
  }

  // --- Attestation Public Key (per server URL) ---

  String _attestationKeyId(String serverUrl) =>
      '${AppConstants.attestationKeyPrefix}${Uri.parse(serverUrl).host}';

  Future<Result<void>> saveAttestationKey(
    String serverUrl,
    String publicKeyBase64,
  ) async {
    try {
      await _storage.write(
        key: _attestationKeyId(serverUrl),
        value: publicKeyBase64,
      );
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('Failed to save attestation key', cause: e));
    }
  }

  Future<Result<String?>> getAttestationKey(String serverUrl) async {
    try {
      final value = await _storage.read(key: _attestationKeyId(serverUrl));
      return Success(value);
    } catch (e) {
      return Err(StorageFailure('Failed to read attestation key', cause: e));
    }
  }

  // --- Generic key-value access ---

  /// Writes an arbitrary key-value pair to secure storage.
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  /// Reads an arbitrary value from secure storage. Returns null if not found.
  Future<String?> read({required String key}) async {
    return _storage.read(key: key);
  }

  /// Deletes an arbitrary key from secure storage.
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }
}
