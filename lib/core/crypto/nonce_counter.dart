import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/services/logging_service.dart';

/// Generates unique counter-based nonces for AES-256-GCM.
///
/// Format (12 bytes / 96 bits):
///   [4 bytes random prefix][8 bytes big-endian counter]
///
/// The random prefix is generated once per key and persisted.
/// The counter is incremented and persisted after each use.
/// Falls back to fully random nonces if storage is unavailable.
class NonceCounter {
  static const _storageKeyPrefix = 'nonce_prefix_';
  static const _storageKeyCounter = 'nonce_counter_';
  static final _log = LoggingService.instance;

  final FlutterSecureStorage _storage;

  NonceCounter({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  /// Generates the next unique nonce for the given [keyId].
  ///
  /// Returns a 12-byte nonce composed of a 4-byte random prefix and
  /// an 8-byte big-endian counter. The counter is persisted in secure
  /// storage and incremented after each call.
  ///
  /// If secure storage fails, falls back to a random nonce.
  Future<Uint8List> next(String keyId) async {
    try {
      // Load or create the random prefix for this key
      var prefix = await _loadPrefix(keyId);
      if (prefix == null) {
        prefix = _randomBytes(4);
        await _savePrefix(keyId, prefix);
      }

      // Load, increment, and save counter
      final counter = await _loadCounter(keyId);
      final nextCounter = counter + 1;
      await _saveCounter(keyId, nextCounter);

      // Build nonce: prefix (4) + counter (8) = 12 bytes
      final nonce = Uint8List(AppConstants.aesNonceLength);
      nonce.setRange(0, 4, prefix);
      _writeUint64BE(nonce, 4, nextCounter);
      return nonce;
    } catch (e) {
      _log.warning(
        'NonceCounter',
        'Counter unavailable, falling back to random nonce: $e',
      );
      return _randomBytes(AppConstants.aesNonceLength);
    }
  }

  Future<Uint8List?> _loadPrefix(String keyId) async {
    final hex = await _storage.read(key: '$_storageKeyPrefix$keyId');
    if (hex == null) return null;
    return _hexToBytes(hex);
  }

  Future<void> _savePrefix(String keyId, Uint8List prefix) async {
    await _storage.write(key: '$_storageKeyPrefix$keyId', value: _bytesToHex(prefix));
  }

  Future<int> _loadCounter(String keyId) async {
    final str = await _storage.read(key: '$_storageKeyCounter$keyId');
    if (str == null) return 0;
    return int.tryParse(str) ?? 0;
  }

  Future<void> _saveCounter(String keyId, int counter) async {
    await _storage.write(key: '$_storageKeyCounter$keyId', value: counter.toString());
  }

  static Uint8List _randomBytes(int length) {
    final rng = Random.secure();
    return Uint8List.fromList(
      List.generate(length, (_) => rng.nextInt(256)),
    );
  }

  static void _writeUint64BE(Uint8List buf, int offset, int value) {
    for (var i = 7; i >= 0; i--) {
      buf[offset + i] = value & 0xFF;
      value >>= 8;
    }
  }

  static String _bytesToHex(Uint8List bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

  static Uint8List _hexToBytes(String hex) {
    final result = Uint8List(hex.length ~/ 2);
    for (var i = 0; i < result.length; i++) {
      result[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return result;
  }
}
