import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/crypto/crypto_utils.dart';
import 'package:sshvault/core/services/logging_service.dart';

/// Generates unique counter-based nonces for AES-256-GCM.
///
/// Format (12 bytes / 96 bits):
///   [4 bytes random prefix][8 bytes big-endian counter]
///
/// The random prefix is generated once per key and persisted.
/// The counter is incremented and persisted after each use.
/// Falls back to fully random nonces if storage is unavailable.
///
/// Thread-safe: concurrent calls to [next] are serialized per keyId
/// to prevent nonce reuse from TOCTOU race conditions.
class NonceCounter {
  static const _storageKeyPrefix = 'nonce_prefix_';
  static const _storageKeyCounter = 'nonce_counter_';
  static final _log = LoggingService.instance;

  /// Maximum counter value before requiring key rotation.
  /// Uses 2^53-1 to stay safe on all Dart platforms (including JS).
  static const int _maxCounter = 9007199254740991; // 2^53 - 1

  final FlutterSecureStorage _storage;

  /// Per-keyId mutexes to prevent concurrent counter access.
  final Map<String, Completer<void>> _locks = {};

  NonceCounter({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  /// Acquires a per-keyId lock to serialize counter operations.
  Future<void> _acquireLock(String keyId) async {
    while (_locks.containsKey(keyId)) {
      await _locks[keyId]!.future;
    }
    _locks[keyId] = Completer<void>();
  }

  /// Releases the per-keyId lock.
  void _releaseLock(String keyId) {
    final completer = _locks.remove(keyId);
    completer?.complete();
  }

  /// Generates the next unique nonce for the given [keyId].
  ///
  /// Returns a 12-byte nonce composed of a 4-byte random prefix and
  /// an 8-byte big-endian counter. The counter is persisted in secure
  /// storage and incremented after each call.
  ///
  /// Concurrent calls are serialized per keyId to prevent nonce reuse.
  /// Throws [StateError] if the counter has been exhausted (requires key rotation).
  Future<Uint8List> next(String keyId) async {
    await _acquireLock(keyId);
    try {
      return await _nextLocked(keyId);
    } finally {
      _releaseLock(keyId);
    }
  }

  Future<Uint8List> _nextLocked(String keyId) async {
    try {
      // Load or create the random prefix for this key
      var prefix = await _loadPrefix(keyId);
      if (prefix == null) {
        prefix = CryptoUtils.secureRandomBytes(4);
        await _savePrefix(keyId, prefix);
      }

      // Load and validate counter
      final counter = await _loadCounter(keyId);
      if (counter >= _maxCounter) {
        _log.error(
          'NonceCounter',
          'Counter exhausted for key $keyId — key rotation required',
        );
        throw StateError('Nonce counter exhausted for key $keyId');
      }

      // Write-ahead: persist the incremented counter BEFORE building
      // the nonce. If saving fails, the nonce is never returned,
      // preventing nonce reuse on storage errors.
      final nextCounter = counter + 1;
      await _saveCounter(keyId, nextCounter);

      // Build nonce from the already-persisted counter value:
      // prefix (4) + counter (8) = 12 bytes
      final nonce = Uint8List(AppConstants.aesNonceLength);
      nonce.setRange(0, 4, prefix);
      _writeUint64BE(nonce, 4, nextCounter);
      return nonce;
    } catch (e) {
      if (e is StateError) rethrow;
      _log.error(
        'NonceCounter',
        'Counter unavailable for key $keyId, refusing to fall back to random nonce',
      );
      rethrow;
    }
  }

  Future<Uint8List?> _loadPrefix(String keyId) async {
    final hex = await _storage.read(key: '$_storageKeyPrefix$keyId');
    if (hex == null) return null;
    return CryptoUtils.hexToBytes(hex);
  }

  Future<void> _savePrefix(String keyId, Uint8List prefix) async {
    await _storage.write(
      key: '$_storageKeyPrefix$keyId',
      value: CryptoUtils.bytesToHex(prefix),
    );
  }

  Future<int> _loadCounter(String keyId) async {
    final str = await _storage.read(key: '$_storageKeyCounter$keyId');
    if (str == null) return 0;
    return int.tryParse(str) ?? 0;
  }

  Future<void> _saveCounter(String keyId, int counter) async {
    await _storage.write(
      key: '$_storageKeyCounter$keyId',
      value: counter.toString(),
    );
  }

  static void _writeUint64BE(Uint8List buf, int offset, int value) {
    for (var i = 7; i >= 0; i--) {
      buf[offset + i] = value & 0xFF;
      value >>= 8;
    }
  }
}
