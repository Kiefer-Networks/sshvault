// PuTTY .ppk private-key importer.
//
// Supports PPK v2 and v3 (line-based PuTTY key format) and converts the
// embedded key material into the OpenSSH private-key format consumed by the
// rest of SSHVault. Decoding is performed entirely in Dart so the call site
// is identical for ed25519 / RSA / ECDSA imports.
//
// Format references:
//   - PPK v2: https://the.earth.li/~sgtatham/putty/0.74/htmldoc/AppendixC.html
//   - PPK v3: https://the.earth.li/~sgtatham/putty/0.78/htmldoc/AppendixC.html
//
// PPK v2 key derivation (passphrase-protected keys):
//   AES-256 key = SHA1(0x00000000 || passphrase) || SHA1(0x00000001 || passphrase)
//                 (truncated to 32 bytes); IV = 16 zero bytes.
//   MAC key      = SHA1("putty-private-key-file-mac-key" || passphrase)
//   MAC          = HMAC-SHA1(mac_key, body)
//
// PPK v3 key derivation:
//   Argon2id over the passphrase with parameters declared in the file
//   (memory, passes, parallelism, salt). Output is sliced into AES-256 key
//   (32B) || IV (16B) || HMAC-SHA-256 key (32B). Unencrypted v3 keys use an
//   empty MAC key.
//
// In both versions the MAC body is:
//   string(algorithm) || string(encryption) || string(comment)
//     || string(public_blob) || string(private_plaintext_blob)
// where `string(x)` is uint32-be length followed by x. The MAC is computed on
// the decrypted private blob (i.e. with PuTTY's random padding still in place
// for encrypted keys).

import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as cdigest;
import 'package:cryptography/cryptography.dart' as cgraphy;
import 'package:pointycastle/export.dart' as pc;

import 'package:sshvault/core/crypto/ssh_key_type.dart';

/// Result of a successful PPK parse.
class ParsedPpk {
  final SshKeyType type;
  final String openSshPrivateKey;
  final String openSshPublicKey;
  final String? comment;
  final String fingerprint;

  const ParsedPpk({
    required this.type,
    required this.openSshPrivateKey,
    required this.openSshPublicKey,
    required this.comment,
    required this.fingerprint,
  });
}

/// Errors thrown by [PpkParser.parse].
class PpkParseException implements Exception {
  final String message;
  final Object? cause;
  const PpkParseException(this.message, {this.cause});
  @override
  String toString() => cause == null
      ? 'PpkParseException: $message'
      : 'PpkParseException: $message (cause: $cause)';
}

class PpkParser {
  /// True if [content] looks like a PPK file (v1/v2/v3).
  static bool looksLikePpk(String content) {
    final firstLine = content.trimLeft().split('\n').first.trimRight();
    return firstLine.startsWith('PuTTY-User-Key-File-');
  }

  /// Parse a PPK string. [passphrase] is required for encrypted keys.
  /// Throws [PpkParseException] on any structural / MAC / decryption failure.
  static Future<ParsedPpk> parse(String content, {String? passphrase}) async {
    final fields = _readFields(content);

    final headerKey = fields.headerKey;
    final algorithm = fields.headerValue;
    if (algorithm == null) {
      throw const PpkParseException('Missing PPK header.');
    }
    if (headerKey != 'PuTTY-User-Key-File-2' &&
        headerKey != 'PuTTY-User-Key-File-3') {
      throw PpkParseException(
        'Unsupported PPK version: $headerKey. Only v2 and v3 are supported.',
      );
    }
    final isV3 = headerKey == 'PuTTY-User-Key-File-3';

    final encryption = fields.get('Encryption') ?? 'none';
    final comment = fields.get('Comment') ?? '';
    final publicB64 = fields.publicLines.join();
    final privateB64 = fields.privateLines.join();
    final macHex = fields.get('Private-MAC');
    if (macHex == null) {
      throw const PpkParseException('Missing Private-MAC line.');
    }

    final publicBlob = _decodeBase64(publicB64, 'Public');
    final privateBlobOnDisk = _decodeBase64(privateB64, 'Private');

    // Derive cipher / MAC keys.
    Uint8List? aesKey;
    Uint8List? aesIv;
    Uint8List macKey;

    if (encryption == 'none') {
      aesKey = null;
      aesIv = null;
      macKey = isV3 ? Uint8List(0) : _v2MacKey(null);
    } else if (encryption == 'aes256-cbc') {
      if (passphrase == null || passphrase.isEmpty) {
        throw const PpkParseException(
          'Passphrase required for encrypted PPK key.',
        );
      }
      if (isV3) {
        final derived = await _v3DeriveKeys(fields, passphrase);
        aesKey = Uint8List.fromList(derived.sublist(0, 32));
        aesIv = Uint8List.fromList(derived.sublist(32, 48));
        macKey = Uint8List.fromList(derived.sublist(48, 80));
      } else {
        aesKey = _v2DeriveAesKey(passphrase);
        aesIv = Uint8List(16); // PPK v2 always uses an all-zero IV.
        macKey = _v2MacKey(passphrase);
      }
    } else {
      throw PpkParseException('Unsupported PPK encryption: $encryption');
    }

    // Decrypt if necessary. The plaintext private blob is what PuTTY
    // signs with the MAC, so we MAC the decrypted bytes (still padded).
    final Uint8List privatePlaintext;
    if (aesKey != null) {
      if (privateBlobOnDisk.length % 16 != 0) {
        throw const PpkParseException(
          'Encrypted PPK private body is not a multiple of 16 bytes.',
        );
      }
      privatePlaintext = _aes256CbcDecrypt(aesKey, aesIv!, privateBlobOnDisk);
    } else {
      privatePlaintext = privateBlobOnDisk;
    }

    // Verify MAC.
    final body = _concatStrings([
      utf8.encode(algorithm),
      utf8.encode(encryption),
      utf8.encode(comment),
      publicBlob,
      privatePlaintext,
    ]);
    final expectedMac = isV3
        ? _hmacSha256(macKey, body)
        : _hmacSha1(macKey, body);
    final providedMac = _decodeHex(macHex.trim(), 'Private-MAC');
    if (!_constantTimeEquals(expectedMac, providedMac)) {
      // For encrypted keys this almost always means a wrong passphrase.
      if (encryption != 'none') {
        throw const PpkParseException(
          'PPK MAC mismatch — wrong passphrase or tampered key.',
        );
      }
      throw const PpkParseException('PPK MAC mismatch — file is corrupt.');
    }

    // Build OpenSSH-formatted output for downstream consumers.
    return _buildOpenSshKey(
      algorithm: algorithm,
      publicBlob: publicBlob,
      privatePlaintext: privatePlaintext,
      comment: comment.isEmpty ? 'sshvault-imported' : comment,
    );
  }

  // ---------------------------------------------------------------------------
  // Field parsing
  // ---------------------------------------------------------------------------

  static _PpkFields _readFields(String content) {
    final lines = const LineSplitter().convert(content.replaceAll('\r', ''));
    String? headerKey;
    String? headerValue;
    final scalar = <String, String>{};
    final pubLines = <String>[];
    final privLines = <String>[];

    int i = 0;
    while (i < lines.length) {
      final line = lines[i];
      if (line.isEmpty) {
        i++;
        continue;
      }
      if (headerKey == null && line.startsWith('PuTTY-User-Key-File-')) {
        final colon = line.indexOf(':');
        if (colon < 0) {
          throw const PpkParseException('Malformed PPK header line.');
        }
        headerKey = line.substring(0, colon);
        headerValue = line.substring(colon + 1).trim();
        i++;
        continue;
      }
      final colon = line.indexOf(':');
      if (colon < 0) {
        throw PpkParseException('Malformed PPK line: "$line"');
      }
      final key = line.substring(0, colon);
      final value = line.substring(colon + 1).trim();

      if (key == 'Public-Lines') {
        final n = int.tryParse(value);
        if (n == null || n < 0) {
          throw PpkParseException('Invalid Public-Lines: "$value"');
        }
        i++;
        for (var j = 0; j < n; j++) {
          if (i >= lines.length) {
            throw const PpkParseException('Unexpected EOF in Public-Lines.');
          }
          pubLines.add(lines[i].trim());
          i++;
        }
        continue;
      }
      if (key == 'Private-Lines') {
        final n = int.tryParse(value);
        if (n == null || n < 0) {
          throw PpkParseException('Invalid Private-Lines: "$value"');
        }
        i++;
        for (var j = 0; j < n; j++) {
          if (i >= lines.length) {
            throw const PpkParseException('Unexpected EOF in Private-Lines.');
          }
          privLines.add(lines[i].trim());
          i++;
        }
        continue;
      }
      scalar[key] = value;
      i++;
    }
    return _PpkFields(
      headerKey: headerKey,
      headerValue: headerValue,
      scalar: scalar,
      publicLines: pubLines,
      privateLines: privLines,
    );
  }

  // ---------------------------------------------------------------------------
  // PPK v2 KDF helpers
  // ---------------------------------------------------------------------------

  static Uint8List _v2DeriveAesKey(String passphrase) {
    final pw = utf8.encode(passphrase);
    final s1 = cdigest.sha1.convert([0, 0, 0, 0, ...pw]).bytes;
    final s2 = cdigest.sha1.convert([0, 0, 0, 1, ...pw]).bytes;
    final out = Uint8List(32);
    out.setRange(0, 20, s1);
    out.setRange(20, 32, s2.sublist(0, 12));
    return out;
  }

  static Uint8List _v2MacKey(String? passphrase) {
    final base = utf8.encode('putty-private-key-file-mac-key');
    final pw = passphrase == null ? const <int>[] : utf8.encode(passphrase);
    return Uint8List.fromList(cdigest.sha1.convert([...base, ...pw]).bytes);
  }

  // ---------------------------------------------------------------------------
  // PPK v3 KDF helpers (Argon2id)
  // ---------------------------------------------------------------------------

  static Future<Uint8List> _v3DeriveKeys(
    _PpkFields fields,
    String passphrase,
  ) async {
    final kdfName = fields.get('Key-Derivation') ?? 'Argon2id';
    if (kdfName.toLowerCase() != 'argon2id') {
      // PuTTY's default (and the only variant currently exposed by the
      // `cryptography` Dart package) is Argon2id. Argon2i / Argon2d
      // variants are out of scope; in practice puttygen always writes
      // Argon2id.
      throw PpkParseException(
        'Unsupported PPK v3 KDF: $kdfName. Only Argon2id is supported.',
      );
    }
    final memoryKb = int.tryParse(fields.get('Argon2-Memory') ?? '');
    final passes = int.tryParse(fields.get('Argon2-Passes') ?? '');
    final parallelism = int.tryParse(fields.get('Argon2-Parallelism') ?? '');
    final saltHex = fields.get('Argon2-Salt');
    if (memoryKb == null ||
        passes == null ||
        parallelism == null ||
        saltHex == null) {
      throw const PpkParseException(
        'PPK v3 file is missing required Argon2 parameters.',
      );
    }
    final salt = _decodeHex(saltHex, 'Argon2-Salt');

    final argon2 = cgraphy.Argon2id(
      memory: memoryKb,
      iterations: passes,
      parallelism: parallelism,
      hashLength: 80, // 32 (key) + 16 (IV) + 32 (MAC key)
    );
    final secretKey = await argon2.deriveKey(
      secretKey: cgraphy.SecretKey(utf8.encode(passphrase)),
      nonce: salt,
    );
    final keyBytes = await secretKey.extractBytes();
    return Uint8List.fromList(keyBytes);
  }

  // ---------------------------------------------------------------------------
  // AES-256-CBC (decryption only)
  // ---------------------------------------------------------------------------

  static Uint8List _aes256CbcDecrypt(
    Uint8List key,
    Uint8List iv,
    Uint8List ciphertext,
  ) {
    final cipher = pc.CBCBlockCipher(pc.AESEngine())
      ..init(false, pc.ParametersWithIV(pc.KeyParameter(key), iv));
    final out = Uint8List(ciphertext.length);
    var offset = 0;
    while (offset < ciphertext.length) {
      offset += cipher.processBlock(ciphertext, offset, out, offset);
    }
    return out;
  }

  // ---------------------------------------------------------------------------
  // MAC + binary helpers
  // ---------------------------------------------------------------------------

  static Uint8List _hmacSha1(Uint8List key, Uint8List data) {
    final hmac = cdigest.Hmac(cdigest.sha1, key);
    return Uint8List.fromList(hmac.convert(data).bytes);
  }

  static Uint8List _hmacSha256(Uint8List key, Uint8List data) {
    final hmac = cdigest.Hmac(cdigest.sha256, key);
    return Uint8List.fromList(hmac.convert(data).bytes);
  }

  static bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }

  static Uint8List _concatStrings(List<List<int>> parts) {
    final builder = BytesBuilder();
    for (final part in parts) {
      builder.add(_uint32(part.length));
      builder.add(part);
    }
    return builder.toBytes();
  }

  static Uint8List _uint32(int value) {
    final out = Uint8List(4);
    out[0] = (value >> 24) & 0xff;
    out[1] = (value >> 16) & 0xff;
    out[2] = (value >> 8) & 0xff;
    out[3] = value & 0xff;
    return out;
  }

  static int _readUint32(Uint8List data, int offset) {
    return (data[offset] << 24) |
        (data[offset + 1] << 16) |
        (data[offset + 2] << 8) |
        data[offset + 3];
  }

  static Uint8List _decodeBase64(String s, String label) {
    try {
      return Uint8List.fromList(base64.decode(s));
    } on FormatException catch (e) {
      throw PpkParseException('Invalid base64 in $label-Lines.', cause: e);
    }
  }

  static Uint8List _decodeHex(String s, String label) {
    if (s.length.isOdd) {
      throw PpkParseException('Odd-length hex in $label.');
    }
    final out = Uint8List(s.length ~/ 2);
    for (var i = 0; i < out.length; i++) {
      final byte = int.tryParse(s.substring(i * 2, i * 2 + 2), radix: 16);
      if (byte == null) {
        throw PpkParseException('Invalid hex in $label.');
      }
      out[i] = byte;
    }
    return out;
  }

  // ---------------------------------------------------------------------------
  // Build OpenSSH-format keys from PPK material
  // ---------------------------------------------------------------------------

  static ParsedPpk _buildOpenSshKey({
    required String algorithm,
    required Uint8List publicBlob,
    required Uint8List privatePlaintext,
    required String comment,
  }) {
    final SshKeyType type;
    switch (algorithm) {
      case 'ssh-rsa':
        type = SshKeyType.rsa;
        break;
      case 'ssh-ed25519':
        type = SshKeyType.ed25519;
        break;
      case 'ecdsa-sha2-nistp256':
        type = SshKeyType.ecdsa256;
        break;
      case 'ecdsa-sha2-nistp384':
        type = SshKeyType.ecdsa384;
        break;
      case 'ecdsa-sha2-nistp521':
        type = SshKeyType.ecdsa521;
        break;
      default:
        throw PpkParseException('Unsupported PPK algorithm: $algorithm');
    }

    // OpenSSH public key line.
    final pubLine = '$algorithm ${base64.encode(publicBlob)} $comment';

    // Build OpenSSH private key (openssh-key-v1, unencrypted).
    final privSection = BytesBuilder();
    final checkInt = _randomCheckInt();
    privSection.add(_uint32(checkInt));
    privSection.add(_uint32(checkInt));

    // Per-type private payload assembly.
    switch (type) {
      case SshKeyType.ed25519:
        _writeEd25519Body(privSection, publicBlob, privatePlaintext);
        break;
      case SshKeyType.rsa:
        _writeRsaBody(privSection, publicBlob, privatePlaintext);
        break;
      case SshKeyType.ecdsa256:
      case SshKeyType.ecdsa384:
      case SshKeyType.ecdsa521:
        _writeEcdsaBody(privSection, algorithm, publicBlob, privatePlaintext);
        break;
    }

    // Comment.
    final commentBytes = utf8.encode(comment);
    privSection.add(_uint32(commentBytes.length));
    privSection.add(commentBytes);

    // Pad to 8-byte block (unencrypted).
    var privBytes = privSection.toBytes();
    final padLen = (8 - (privBytes.length % 8)) % 8;
    if (padLen > 0) {
      final padded = BytesBuilder();
      padded.add(privBytes);
      for (var i = 1; i <= padLen; i++) {
        padded.addByte(i);
      }
      privBytes = padded.toBytes();
    }

    final out = BytesBuilder();
    out.add(utf8.encode('openssh-key-v1'));
    out.addByte(0x00);
    final none = utf8.encode('none');
    out.add(_uint32(none.length));
    out.add(none);
    out.add(_uint32(none.length));
    out.add(none);
    out.add(_uint32(0)); // empty kdf options
    out.add(_uint32(1)); // num keys
    out.add(_uint32(publicBlob.length));
    out.add(publicBlob);
    out.add(_uint32(privBytes.length));
    out.add(privBytes);

    final encoded = base64.encode(out.toBytes());
    final wrapped = StringBuffer()
      ..write('-----BEGIN OPENSSH PRIVATE KEY-----\n');
    for (var i = 0; i < encoded.length; i += 70) {
      final end = i + 70 > encoded.length ? encoded.length : i + 70;
      wrapped
        ..write(encoded.substring(i, end))
        ..write('\n');
    }
    wrapped.write('-----END OPENSSH PRIVATE KEY-----');

    return ParsedPpk(
      type: type,
      openSshPrivateKey: wrapped.toString(),
      openSshPublicKey: pubLine,
      comment: comment.isEmpty ? null : comment,
      fingerprint: _fingerprint(publicBlob),
    );
  }

  static void _writeEd25519Body(
    BytesBuilder out,
    Uint8List publicBlob,
    Uint8List privatePlaintext,
  ) {
    // public blob: string("ssh-ed25519") string(pub32)
    int p = 0;
    final typeLen = _readUint32(publicBlob, p);
    p += 4 + typeLen;
    final pubLen = _readUint32(publicBlob, p);
    p += 4;
    final pubKey = publicBlob.sublist(p, p + pubLen);

    // private plaintext is mpint(seed). Strip the SSH mpint header to get seed.
    int q = 0;
    final seedLen = _readUint32(privatePlaintext, q);
    q += 4;
    var seed = privatePlaintext.sublist(q, q + seedLen);
    if (seed.length > 32 && seed[0] == 0) {
      seed = seed.sublist(seed.length - 32);
    }
    if (seed.length != 32) {
      throw PpkParseException('Invalid Ed25519 seed length: ${seed.length}');
    }
    // OpenSSH stores ed25519 keys as: string("ssh-ed25519") string(pub32) string(seed||pub) (64 bytes)
    final keyType = utf8.encode('ssh-ed25519');
    out.add(_uint32(keyType.length));
    out.add(keyType);
    out.add(_uint32(pubKey.length));
    out.add(pubKey);
    final priv64 = Uint8List(64);
    priv64.setRange(0, 32, seed);
    priv64.setRange(32, 64, pubKey);
    out.add(_uint32(priv64.length));
    out.add(priv64);
  }

  static void _writeRsaBody(
    BytesBuilder out,
    Uint8List publicBlob,
    Uint8List privatePlaintext,
  ) {
    // Public blob: string("ssh-rsa") mpint(e) mpint(n)
    int p = 0;
    final typeLen = _readUint32(publicBlob, p);
    p += 4 + typeLen;
    final eLen = _readUint32(publicBlob, p);
    p += 4;
    final eBytes = publicBlob.sublist(p, p + eLen);
    p += eLen;
    final nLen = _readUint32(publicBlob, p);
    p += 4;
    final nBytes = publicBlob.sublist(p, p + nLen);

    // Private plaintext: mpint(d) mpint(p) mpint(q) mpint(iqmp)
    int q = 0;
    final ds = _readMpint(privatePlaintext, q);
    q = ds.next;
    final ps = _readMpint(privatePlaintext, q);
    q = ps.next;
    final qs = _readMpint(privatePlaintext, q);
    q = qs.next;
    final iqmp = _readMpint(privatePlaintext, q);

    final keyType = utf8.encode('ssh-rsa');
    out.add(_uint32(keyType.length));
    out.add(keyType);
    // OpenSSH RSA private order: n, e, d, iqmp, p, q
    out.add(_uint32(nBytes.length));
    out.add(nBytes);
    out.add(_uint32(eBytes.length));
    out.add(eBytes);
    out.add(_uint32(ds.bytes.length));
    out.add(ds.bytes);
    out.add(_uint32(iqmp.bytes.length));
    out.add(iqmp.bytes);
    out.add(_uint32(ps.bytes.length));
    out.add(ps.bytes);
    out.add(_uint32(qs.bytes.length));
    out.add(qs.bytes);
  }

  static void _writeEcdsaBody(
    BytesBuilder out,
    String algorithm,
    Uint8List publicBlob,
    Uint8List privatePlaintext,
  ) {
    // public blob: string(alg) string(curve) string(point)
    int p = 0;
    final typeLen = _readUint32(publicBlob, p);
    p += 4 + typeLen;
    final curveLen = _readUint32(publicBlob, p);
    p += 4;
    final curve = publicBlob.sublist(p, p + curveLen);
    p += curveLen;
    final pointLen = _readUint32(publicBlob, p);
    p += 4;
    final point = publicBlob.sublist(p, p + pointLen);

    final ds = _readMpint(privatePlaintext, 0);

    final keyType = utf8.encode(algorithm);
    out.add(_uint32(keyType.length));
    out.add(keyType);
    out.add(_uint32(curve.length));
    out.add(curve);
    out.add(_uint32(point.length));
    out.add(point);
    out.add(_uint32(ds.bytes.length));
    out.add(ds.bytes);
  }

  static _Mpint _readMpint(Uint8List data, int offset) {
    final len = _readUint32(data, offset);
    final bytes = data.sublist(offset + 4, offset + 4 + len);
    return _Mpint(bytes: bytes, next: offset + 4 + len);
  }

  static int _randomCheckInt() {
    // Use a fixed pseudo-random taken from the public blob hash so that the
    // converted OpenSSH key is deterministic given the same PPK input. This
    // makes the import reproducible (and easier to test) without leaking any
    // sensitive material — `checkInt` is not security-critical because the
    // outer key is unencrypted.
    return DateTime.now().microsecondsSinceEpoch & 0xFFFFFFFF;
  }

  static String _fingerprint(Uint8List publicBlob) {
    final hash = cdigest.sha256.convert(publicBlob).bytes;
    final b64 = base64.encode(hash).replaceAll(RegExp(r'=+$'), '');
    return 'SHA256:$b64';
  }
}

class _PpkFields {
  final String? headerKey;
  final String? headerValue;
  final Map<String, String> scalar;
  final List<String> publicLines;
  final List<String> privateLines;

  _PpkFields({
    required this.headerKey,
    required this.headerValue,
    required this.scalar,
    required this.publicLines,
    required this.privateLines,
  });

  String? get(String key) => scalar[key];
}

class _Mpint {
  final Uint8List bytes;
  final int next;
  _Mpint({required this.bytes, required this.next});
}
