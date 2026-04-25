import 'dart:typed_data';

import 'package:pointycastle/export.dart';

/// AEAD (Authenticated Encryption with Associated Data) cipher for SSH packets.
///
/// Unlike the classic encrypt-then-MAC scheme used with [BlockCipher]+[Mac],
/// AEAD ciphers integrate confidentiality and integrity. The MAC negotiation
/// is implicit: when an AEAD cipher is selected, the MAC list is ignored and
/// no separate MAC is computed.
///
/// Each implementation is responsible for handling per-packet nonce derivation
/// (typically from the SSH packet sequence number).
abstract class SSHAeadCipher {
  /// Total raw key material the SSH key derivation must produce.
  int get keySize;

  /// Size of the IV the SSH key derivation must produce. May be 0 when the
  /// nonce is derived from the packet sequence number alone.
  int get ivSize;

  /// Block size used for packet padding alignment. AEAD ciphers in SSH still
  /// require packets to be aligned to a logical block size.
  int get blockSize;

  /// Authentication tag size in bytes (always 16 for chacha20-poly1305 and
  /// aes-gcm in SSH).
  int get tagSize;

  /// Whether the 4-byte packet length is sent in plaintext (and used as AAD).
  /// `false` for chacha20-poly1305@openssh.com (length is encrypted with K_1).
  /// `true` for aes-gcm@openssh.com.
  bool get plaintextLength;

  /// Initialize this cipher with derived [key] and [iv].
  void init(Uint8List key, Uint8List iv);

  /// Decrypt the 4-byte packet length prefix when [plaintextLength] is `false`.
  ///
  /// [seq] is the SSH packet sequence number used as nonce.
  /// [encryptedLength] is exactly 4 bytes of ciphertext.
  /// Returns the plaintext packet length as a 32-bit big-endian unsigned int.
  int decryptPacketLength(int seq, Uint8List encryptedLength) {
    throw UnsupportedError(
      'decryptPacketLength is only valid when plaintextLength is false',
    );
  }

  /// Build a fully-encrypted SSH packet ready to write to the wire.
  ///
  /// [seq] is the SSH packet sequence number.
  /// [packetLengthBytes] is the 4-byte big-endian packet length field.
  /// [packetBody] is `padding_length || payload || random_padding` as a
  /// contiguous block whose total size matches `packetLengthBytes`.
  ///
  /// Returns the wire bytes: `(4-byte length, possibly encrypted) ||
  /// ciphertext_of_body || authTag`.
  Uint8List sealPacket(
    int seq,
    Uint8List packetLengthBytes,
    Uint8List packetBody,
  );

  /// Authenticate and decrypt a complete encrypted SSH packet.
  ///
  /// [seq] is the SSH packet sequence number.
  /// [packetLengthBytes] is the (possibly encrypted) 4-byte length prefix.
  /// [encryptedBody] is the encrypted packet body (length = decrypted length).
  /// [authTag] is the 16-byte AEAD tag.
  ///
  /// Returns the decrypted packet body. Throws [StateError] if the auth tag
  /// is invalid.
  Uint8List openPacket(
    int seq,
    Uint8List packetLengthBytes,
    Uint8List encryptedBody,
    Uint8List authTag,
  );
}

/// `chacha20-poly1305@openssh.com` (OpenSSH PROTOCOL.chacha20poly1305).
///
/// Uses two 256-bit ChaCha20 keys derived from the 64-byte KEX key:
///   K_2 = key[0..32]   — encrypts the packet body and derives the Poly1305 key.
///   K_1 = key[32..64]  — encrypts the 4-byte packet length field.
/// The packet sequence number (uint64 BE) is the chacha20 nonce.
///
/// Per packet:
///   poly1305_key = ChaCha20(K_2, nonce, counter=0)[0..32]
///   encrypted_length  = ChaCha20(K_1, nonce, counter=0) ⊕ length_4bytes
///   encrypted_payload = ChaCha20(K_2, nonce, counter=1) ⊕ payload
///   tag = Poly1305(poly1305_key, encrypted_length || encrypted_payload)
class SSHChaCha20Poly1305Cipher extends SSHAeadCipher {
  @override
  final int keySize = 64;

  @override
  final int ivSize = 0;

  @override
  final int blockSize = 8;

  @override
  final int tagSize = 16;

  @override
  final bool plaintextLength = false;

  Uint8List? _k2;
  Uint8List? _k1;

  @override
  void init(Uint8List key, Uint8List iv) {
    if (key.length != 64) {
      throw ArgumentError.value(key, 'key', 'chacha20-poly1305 needs 64 bytes');
    }
    _k2 = Uint8List.fromList(key.sublist(0, 32));
    _k1 = Uint8List.fromList(key.sublist(32, 64));
  }

  Uint8List _seqNonce(int seq) {
    final nonce = Uint8List(8);
    final view = ByteData.sublistView(nonce);
    // SSH packet sequence number is 32-bit, but the chacha20 nonce per
    // OpenSSH spec is the seq number encoded as 64-bit big-endian.
    view.setUint64(0, seq, Endian.big);
    return nonce;
  }

  /// Run a single ChaCha20 keystream over [data], starting at counter=[counter].
  Uint8List _chacha20(
    Uint8List key,
    Uint8List nonce,
    int counter,
    Uint8List data,
  ) {
    final engine = ChaCha20Engine();
    engine.init(true, ParametersWithIV(KeyParameter(key), nonce));
    if (counter > 0) {
      // ChaCha20 counter advances every 64-byte block. To start at counter=1,
      // process a 64-byte zero buffer first and discard the output.
      final skip = Uint8List(64 * counter);
      engine.processBytes(skip, 0, skip.length, Uint8List(skip.length), 0);
    }
    final out = Uint8List(data.length);
    engine.processBytes(data, 0, data.length, out, 0);
    return out;
  }

  /// Derive the per-packet Poly1305 key from the ChaCha20(K_2) keystream
  /// (first 32 bytes of block 0).
  Uint8List _poly1305Key(Uint8List nonce) {
    return _chacha20(_k2!, nonce, 0, Uint8List(32));
  }

  Uint8List _poly1305Tag(Uint8List polyKey, Uint8List data) {
    final mac = Poly1305()..init(KeyParameter(polyKey));
    mac.update(data, 0, data.length);
    final out = Uint8List(mac.macSize);
    mac.doFinal(out, 0);
    return out;
  }

  bool _constantTimeEquals(Uint8List a, Uint8List b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }

  @override
  int decryptPacketLength(int seq, Uint8List encryptedLength) {
    if (encryptedLength.length != 4) {
      throw ArgumentError('encryptedLength must be 4 bytes');
    }
    final nonce = _seqNonce(seq);
    final plain = _chacha20(_k1!, nonce, 0, encryptedLength);
    return ByteData.sublistView(plain).getUint32(0, Endian.big);
  }

  @override
  Uint8List sealPacket(
    int seq,
    Uint8List packetLengthBytes,
    Uint8List packetBody,
  ) {
    final nonce = _seqNonce(seq);
    final encryptedLength = _chacha20(_k1!, nonce, 0, packetLengthBytes);
    final encryptedBody = _chacha20(_k2!, nonce, 1, packetBody);
    final polyKey = _poly1305Key(nonce);

    final tagInput = Uint8List(encryptedLength.length + encryptedBody.length);
    tagInput.setRange(0, encryptedLength.length, encryptedLength);
    tagInput.setRange(
      encryptedLength.length,
      tagInput.length,
      encryptedBody,
    );
    final tag = _poly1305Tag(polyKey, tagInput);

    final out = Uint8List(tagInput.length + tag.length);
    out.setRange(0, tagInput.length, tagInput);
    out.setRange(tagInput.length, out.length, tag);
    return out;
  }

  @override
  Uint8List openPacket(
    int seq,
    Uint8List packetLengthBytes,
    Uint8List encryptedBody,
    Uint8List authTag,
  ) {
    final nonce = _seqNonce(seq);
    final polyKey = _poly1305Key(nonce);

    final tagInput =
        Uint8List(packetLengthBytes.length + encryptedBody.length);
    tagInput.setRange(0, packetLengthBytes.length, packetLengthBytes);
    tagInput.setRange(
      packetLengthBytes.length,
      tagInput.length,
      encryptedBody,
    );
    final expectedTag = _poly1305Tag(polyKey, tagInput);
    if (!_constantTimeEquals(expectedTag, authTag)) {
      throw StateError('chacha20-poly1305 auth tag mismatch');
    }

    return _chacha20(_k2!, nonce, 1, encryptedBody);
  }
}

/// `aes128-gcm@openssh.com` / `aes256-gcm@openssh.com` (RFC 5647).
///
/// Uses 12-byte IV constructed as `fixed_field(4) || invocation_counter(8)`.
/// The fixed field plus the initial 8-byte counter come from the SSH KEX.
/// The 8-byte counter is incremented as a 64-bit unsigned integer for each
/// packet processed.
///
/// The 4-byte packet length is sent in plaintext and used as AAD.
/// The packet body (padding_length || payload || padding) is encrypted, and
/// a 16-byte tag follows the ciphertext.
class SSHAesGcmCipher extends SSHAeadCipher {
  SSHAesGcmCipher({required int keyBytes}) : keySize = keyBytes;

  @override
  final int keySize;

  @override
  final int ivSize = 12;

  /// AES block size (used for packet padding alignment).
  @override
  final int blockSize = 16;

  @override
  final int tagSize = 16;

  @override
  final bool plaintextLength = true;

  Uint8List? _key;
  Uint8List? _fixedIv;
  BigInt _counter = BigInt.zero;

  @override
  void init(Uint8List key, Uint8List iv) {
    if (key.length != keySize) {
      throw ArgumentError.value(key, 'key', 'aes-gcm key must be $keySize bytes');
    }
    if (iv.length != 12) {
      throw ArgumentError.value(iv, 'iv', 'aes-gcm needs 12-byte IV');
    }
    _key = Uint8List.fromList(key);
    _fixedIv = Uint8List.fromList(iv.sublist(0, 4));
    final initialCounter = ByteData.sublistView(iv, 4, 12)
        .getUint64(0, Endian.big);
    _counter = BigInt.from(initialCounter).toUnsigned(64);
  }

  Uint8List _nextIv() {
    final iv = Uint8List(12);
    iv.setRange(0, 4, _fixedIv!);
    final view = ByteData.sublistView(iv);
    final counter = _counter.toUnsigned(64).toInt();
    view.setUint64(4, counter, Endian.big);
    _counter = (_counter + BigInt.one).toUnsigned(64);
    return iv;
  }

  GCMBlockCipher _newGcm({
    required bool forEncryption,
    required Uint8List iv,
    required Uint8List aad,
  }) {
    final gcm = GCMBlockCipher(AESEngine());
    gcm.init(
      forEncryption,
      AEADParameters(KeyParameter(_key!), tagSize * 8, iv, aad),
    );
    return gcm;
  }

  @override
  Uint8List sealPacket(
    int seq,
    Uint8List packetLengthBytes,
    Uint8List packetBody,
  ) {
    final iv = _nextIv();
    final gcm = _newGcm(
      forEncryption: true,
      iv: iv,
      aad: packetLengthBytes,
    );
    final ciphertext = gcm.process(packetBody);
    // GCM in pointycastle returns ciphertext with the tag appended.
    final out = Uint8List(packetLengthBytes.length + ciphertext.length);
    out.setRange(0, packetLengthBytes.length, packetLengthBytes);
    out.setRange(packetLengthBytes.length, out.length, ciphertext);
    return out;
  }

  @override
  Uint8List openPacket(
    int seq,
    Uint8List packetLengthBytes,
    Uint8List encryptedBody,
    Uint8List authTag,
  ) {
    final iv = _nextIv();
    final gcm = _newGcm(
      forEncryption: false,
      iv: iv,
      aad: packetLengthBytes,
    );
    final combined = Uint8List(encryptedBody.length + authTag.length);
    combined.setRange(0, encryptedBody.length, encryptedBody);
    combined.setRange(encryptedBody.length, combined.length, authTag);
    try {
      return gcm.process(combined);
    } catch (e) {
      throw StateError('aes-gcm auth tag mismatch: $e');
    }
  }
}
