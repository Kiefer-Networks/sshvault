import 'dart:typed_data';

import 'package:dartssh2/src/algorithm/ssh_aead_cipher.dart';
import 'package:dartssh2/src/ssh_algorithm.dart';
import 'package:pointycastle/export.dart';

class SSHCipherType extends SSHAlgorithm {
  static const values = [
    chacha20Poly1305,
    aes256gcm,
    aes128gcm,
    aes256ctr,
    aes192ctr,
    aes128ctr,
    aes256cbc,
    aes192cbc,
    aes128cbc,
  ];

  static const aes128ctr = SSHCipherType._(
    name: 'aes128-ctr',
    keySize: 16,
    ivSize: 16,
    blockSize: 16,
    cipherFactory: _aesCtrFactory,
  );

  static const aes192ctr = SSHCipherType._(
    name: 'aes192-ctr',
    keySize: 24,
    ivSize: 16,
    blockSize: 16,
    cipherFactory: _aesCtrFactory,
  );

  static const aes256ctr = SSHCipherType._(
    name: 'aes256-ctr',
    keySize: 32,
    ivSize: 16,
    blockSize: 16,
    cipherFactory: _aesCtrFactory,
  );

  static const aes128cbc = SSHCipherType._(
    name: 'aes128-cbc',
    keySize: 16,
    ivSize: 16,
    blockSize: 16,
    cipherFactory: _aesCbcFactory,
  );

  static const aes192cbc = SSHCipherType._(
    name: 'aes192-cbc',
    keySize: 24,
    ivSize: 16,
    blockSize: 16,
    cipherFactory: _aesCbcFactory,
  );

  static const aes256cbc = SSHCipherType._(
    name: 'aes256-cbc',
    keySize: 32,
    ivSize: 16,
    blockSize: 16,
    cipherFactory: _aesCbcFactory,
  );

  static const chacha20Poly1305 = SSHCipherType._(
    name: 'chacha20-poly1305@openssh.com',
    keySize: 64,
    ivSize: 0,
    blockSize: 8,
    aeadFactory: _chacha20Poly1305Factory,
  );

  static const aes128gcm = SSHCipherType._(
    name: 'aes128-gcm@openssh.com',
    keySize: 16,
    ivSize: 12,
    blockSize: 16,
    aeadFactory: _aes128GcmFactory,
  );

  static const aes256gcm = SSHCipherType._(
    name: 'aes256-gcm@openssh.com',
    keySize: 32,
    ivSize: 12,
    blockSize: 16,
    aeadFactory: _aes256GcmFactory,
  );

  static SSHCipherType? fromName(String name) {
    for (final value in values) {
      if (value.name == name) {
        return value;
      }
    }
    return null;
  }

  const SSHCipherType._({
    required this.name,
    required this.keySize,
    required this.ivSize,
    required this.blockSize,
    this.cipherFactory,
    this.aeadFactory,
  });

  /// The name of the algorithm. For example, `"aes256-ctr`"`.
  @override
  final String name;

  /// Size in bytes of the symmetric key derived from KEX.
  final int keySize;

  /// Size in bytes of the IV / nonce derived from KEX. Some AEAD ciphers
  /// (chacha20-poly1305@openssh.com) derive the nonce from the sequence
  /// number alone and have an [ivSize] of 0.
  final int ivSize;

  /// Block size used for SSH packet padding alignment.
  final int blockSize;

  /// Factory for the classic CBC/CTR block cipher path. `null` for AEAD
  /// ciphers.
  final BlockCipher Function()? cipherFactory;

  /// Factory for AEAD ciphers (chacha20-poly1305, aes-gcm). `null` for
  /// classic block ciphers.
  final SSHAeadCipher Function()? aeadFactory;

  /// Whether this cipher is an AEAD cipher (integrated authentication).
  bool get isAead => aeadFactory != null;

  BlockCipher createCipher(
    Uint8List key,
    Uint8List iv, {
    required bool forEncryption,
  }) {
    final factory = cipherFactory;
    if (factory == null) {
      throw StateError('createCipher is not supported on AEAD cipher $name');
    }

    if (key.length != keySize) {
      throw ArgumentError.value(key, 'key', 'Key must be $keySize bytes long');
    }

    if (iv.length != ivSize) {
      throw ArgumentError.value(iv, 'iv', 'IV must be $ivSize bytes long');
    }

    final cipher = factory();
    cipher.init(forEncryption, ParametersWithIV(KeyParameter(key), iv));
    return cipher;
  }

  /// Create and initialize the AEAD cipher associated with this type.
  /// Throws [StateError] if this is not an AEAD cipher.
  SSHAeadCipher createAeadCipher(Uint8List key, Uint8List iv) {
    final factory = aeadFactory;
    if (factory == null) {
      throw StateError('createAeadCipher is not supported on $name');
    }
    final cipher = factory();
    cipher.init(key, iv);
    return cipher;
  }
}

BlockCipher _aesCtrFactory() {
  final aes = AESEngine();
  return CTRBlockCipher(aes.blockSize, CTRStreamCipher(aes));
}

BlockCipher _aesCbcFactory() {
  return CBCBlockCipher(AESEngine());
}

SSHAeadCipher _chacha20Poly1305Factory() => SSHChaCha20Poly1305Cipher();

SSHAeadCipher _aes128GcmFactory() => SSHAesGcmCipher(keyBytes: 16);

SSHAeadCipher _aes256GcmFactory() => SSHAesGcmCipher(keyBytes: 32);
