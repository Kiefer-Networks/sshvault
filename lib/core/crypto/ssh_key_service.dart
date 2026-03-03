import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' show sha256;
import 'package:cryptography/cryptography.dart' as crypto;
import 'package:pointycastle/asn1.dart';
import 'package:pointycastle/export.dart';
import 'package:shellvault/core/crypto/ssh_key_type.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';

class SshKeyPair {
  final String privateKey;
  final String publicKey;
  final SshKeyType type;
  final String comment;

  const SshKeyPair({
    required this.privateKey,
    required this.publicKey,
    required this.type,
    required this.comment,
  });
}

class ExtractedKeyInfo {
  final String publicKey;
  final String? comment;
  ExtractedKeyInfo({required this.publicKey, this.comment});
}

class SshKeyService {
  static final _secureRandom = FortunaRandom();
  static bool _initialized = false;

  static void _ensureInitialized() {
    if (_initialized) return;
    final seed = Uint8List(32);
    final random = Random.secure();
    for (var i = 0; i < 32; i++) {
      seed[i] = random.nextInt(256);
    }
    _secureRandom.seed(KeyParameter(seed));
    _initialized = true;
  }

  /// Generate a key pair with full ssh-keygen options.
  Future<Result<SshKeyPair>> generateKeyPair([
    SshKeyOptions options = const SshKeyOptions(),
  ]) async {
    try {
      return switch (options.type) {
        SshKeyType.rsa => _generateRsa(options),
        SshKeyType.ecdsa256 ||
        SshKeyType.ecdsa384 ||
        SshKeyType.ecdsa521 => _generateEcdsa(options),
        SshKeyType.ed25519 => await _generateEd25519(options),
      };
    } catch (e) {
      return Err(CryptoFailure('Key generation failed', cause: e));
    }
  }

  /// Compute SHA-256 fingerprint from an OpenSSH public key string.
  /// Returns format: SHA256:base64(sha256(rawPubKeyBlob))
  String computeFingerprint(String publicKeyLine) {
    final parts = publicKeyLine.trim().split(' ');
    if (parts.length < 2) return '';
    final pubBlob = base64Decode(parts[1]);
    final hash = sha256.convert(pubBlob);
    final b64 = base64Encode(hash.bytes);
    // Remove trailing '=' padding to match ssh-keygen output
    final trimmed = b64.replaceAll(RegExp(r'=+$'), '');
    return 'SHA256:$trimmed';
  }

  /// Extract public key from a PEM-encoded private key (RSA, ECDSA, Ed25519).
  Future<Result<String>> extractPublicKey(
    String privateKeyPem, {
    String comment = 'shellvault-extracted',
  }) async {
    try {
      final trimmed = privateKeyPem.trim();

      if (trimmed.contains('RSA PRIVATE KEY') ||
          (trimmed.contains('BEGIN PRIVATE KEY') &&
              !trimmed.contains('EC PRIVATE KEY') &&
              !trimmed.contains('OPENSSH PRIVATE KEY'))) {
        return _extractRsaPublicKey(trimmed, comment);
      }

      if (trimmed.contains('EC PRIVATE KEY')) {
        return _extractEcdsaPublicKey(trimmed, comment);
      }

      if (trimmed.contains('OPENSSH PRIVATE KEY')) {
        return await _extractOpenSshPublicKey(trimmed, comment);
      }

      // Try RSA as fallback
      final rsaResult = _extractRsaPublicKey(trimmed, comment);
      if (rsaResult.isSuccess) return rsaResult;

      return const Err(
        CryptoFailure(
          'Unsupported private key format. '
          'Supported: RSA (PKCS#1/PKCS#8), ECDSA (SEC1), Ed25519 (OpenSSH).',
        ),
      );
    } catch (e) {
      return Err(CryptoFailure('Failed to extract public key', cause: e));
    }
  }

  /// Extract public key and comment from a PEM-encoded private key.
  /// Comment extraction is only supported for unencrypted OpenSSH keys.
  Future<Result<ExtractedKeyInfo>> extractKeyInfo(String privateKeyPem) async {
    try {
      final trimmed = privateKeyPem.trim();

      if (trimmed.contains('OPENSSH PRIVATE KEY')) {
        return await _extractOpenSshKeyInfo(trimmed);
      }

      // For non-OpenSSH formats, fall back to extractPublicKey (no comment available)
      final result = await extractPublicKey(trimmed);
      if (result.isSuccess) {
        return Success(ExtractedKeyInfo(publicKey: result.value));
      }
      return Err(result.failure);
    } catch (e) {
      return Err(CryptoFailure('Failed to extract key info', cause: e));
    }
  }

  // ---------------------------------------------------------------------------
  // RSA
  // ---------------------------------------------------------------------------

  Result<SshKeyPair> _generateRsa(SshKeyOptions options) {
    _ensureInitialized();
    final bits = options.effectiveBits;

    final keyGen = RSAKeyGenerator()
      ..init(
        ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.from(65537), bits, 64),
          _secureRandom,
        ),
      );

    final pair = keyGen.generateKeyPair();
    final pub = pair.publicKey;
    final priv = pair.privateKey;

    return Success(
      SshKeyPair(
        privateKey: _rsaPrivateKeyToPem(priv),
        publicKey: _rsaPublicKeyToOpenSsh(pub, options.comment),
        type: SshKeyType.rsa,
        comment: options.comment,
      ),
    );
  }

  Result<String> _extractRsaPublicKey(String pem, String comment) {
    final rsaPrivate = _pemToRsaPrivateKey(pem);
    if (rsaPrivate == null) {
      return const Err(CryptoFailure('Could not parse RSA private key.'));
    }
    final rsaPublic = RSAPublicKey(
      rsaPrivate.modulus!,
      rsaPrivate.publicExponent!,
    );
    return Success(_rsaPublicKeyToOpenSsh(rsaPublic, comment));
  }

  // ---------------------------------------------------------------------------
  // ECDSA
  // ---------------------------------------------------------------------------

  Result<SshKeyPair> _generateEcdsa(SshKeyOptions options) {
    _ensureInitialized();

    final curveName = switch (options.type) {
      SshKeyType.ecdsa256 => 'secp256r1',
      SshKeyType.ecdsa384 => 'secp384r1',
      SshKeyType.ecdsa521 => 'secp521r1',
      _ => throw ArgumentError('Not an ECDSA type: ${options.type}'),
    };

    final domainParams = ECDomainParameters(curveName);
    final keyGen = ECKeyGenerator()
      ..init(
        ParametersWithRandom(
          ECKeyGeneratorParameters(domainParams),
          _secureRandom,
        ),
      );

    final pair = keyGen.generateKeyPair();
    final pub = pair.publicKey;
    final priv = pair.privateKey;

    return Success(
      SshKeyPair(
        privateKey: _ecPrivateKeyToPem(priv, domainParams),
        publicKey: _ecPublicKeyToOpenSsh(pub, options.type, options.comment),
        type: options.type,
        comment: options.comment,
      ),
    );
  }

  Result<String> _extractEcdsaPublicKey(String pem, String comment) {
    final lines = pem.split('\n');
    final b64 = lines.where((l) => !l.startsWith('-----')).join();
    final bytes = base64Decode(b64);

    final parser = ASN1Parser(Uint8List.fromList(bytes));
    final seq = parser.nextObject() as ASN1Sequence;

    // SEC1 format: SEQ { version(1), privateKey OCTET STRING, [0] parameters, [1] publicKey }
    if (seq.elements!.length < 3) {
      return const Err(CryptoFailure('Invalid EC private key format.'));
    }

    // Find the OID to determine curve
    ASN1ObjectIdentifier? oid;
    ECDomainParameters? domainParams;
    SshKeyType? keyType;

    for (final elem in seq.elements!) {
      if (elem.tag == 0xA0) {
        // Context-specific [0] — contains OID
        final innerParser = ASN1Parser(elem.valueBytes!);
        final innerObj = innerParser.nextObject();
        if (innerObj is ASN1ObjectIdentifier) {
          oid = innerObj;
        }
      }
    }

    if (oid != null) {
      final oidStr = oid.objectIdentifierAsString;
      if (oidStr == '1.2.840.10045.3.1.7') {
        domainParams = ECDomainParameters('secp256r1');
        keyType = SshKeyType.ecdsa256;
      } else if (oidStr == '1.3.132.0.34') {
        domainParams = ECDomainParameters('secp384r1');
        keyType = SshKeyType.ecdsa384;
      } else if (oidStr == '1.3.132.0.35') {
        domainParams = ECDomainParameters('secp521r1');
        keyType = SshKeyType.ecdsa521;
      }
    }

    if (domainParams == null || keyType == null) {
      return const Err(CryptoFailure('Unsupported EC curve.'));
    }

    // Extract public key from [1] context tag
    for (final elem in seq.elements!) {
      if (elem.tag == 0xA1) {
        final innerParser = ASN1Parser(elem.valueBytes!);
        final bitString = innerParser.nextObject() as ASN1BitString;
        final pubBytes = bitString.valueBytes!;

        // pubBytes is uncompressed point (04 || x || y)
        final point = domainParams.curve.decodePoint(pubBytes);
        if (point == null) {
          return const Err(CryptoFailure('Invalid EC public key point.'));
        }
        final ecPub = ECPublicKey(point, domainParams);
        return Success(_ecPublicKeyToOpenSsh(ecPub, keyType, comment));
      }
    }

    return const Err(CryptoFailure('No public key found in EC private key.'));
  }

  // ---------------------------------------------------------------------------
  // Ed25519
  // ---------------------------------------------------------------------------

  Future<Result<SshKeyPair>> _generateEd25519(SshKeyOptions options) async {
    final algorithm = crypto.Ed25519();
    final keyPair = await algorithm.newKeyPair();
    final privateKeyData = await keyPair.extractPrivateKeyBytes();
    final publicKey = await keyPair.extractPublicKey();
    final publicKeyBytes = Uint8List.fromList(publicKey.bytes);
    final privateKeyBytes = Uint8List.fromList(privateKeyData);

    return Success(
      SshKeyPair(
        privateKey: _ed25519ToOpenSshPrivateKey(
          privateKeyBytes,
          publicKeyBytes,
          options.comment,
        ),
        publicKey: _ed25519ToOpenSshPublicKey(publicKeyBytes, options.comment),
        type: SshKeyType.ed25519,
        comment: options.comment,
      ),
    );
  }

  Future<Result<String>> _extractOpenSshPublicKey(
    String pem,
    String comment,
  ) async {
    try {
      final lines = pem.split('\n');
      final b64 = lines.where((l) => !l.startsWith('-----')).join();
      final bytes = Uint8List.fromList(base64Decode(b64));

      // OpenSSH private key format:
      // "openssh-key-v1\0" magic
      // ciphername (string), kdfname (string), kdfoptions (string)
      // number of keys (uint32)
      // public key (string)
      // private section (string)

      int offset = 0;

      // Skip magic "openssh-key-v1\0"
      const magic = 'openssh-key-v1\x00';
      offset = magic.length;

      // ciphername
      final cipherLen = _readUint32(bytes, offset);
      offset += 4;
      final cipherName = utf8.decode(bytes.sublist(offset, offset + cipherLen));
      offset += cipherLen;

      if (cipherName != 'none') {
        return const Err(
          CryptoFailure(
            'Encrypted OpenSSH keys are not supported for extraction. '
            'Remove the passphrase first with ssh-keygen -p.',
          ),
        );
      }

      // kdfname
      final kdfLen = _readUint32(bytes, offset);
      offset += 4 + kdfLen;

      // kdfoptions
      final kdfOptLen = _readUint32(bytes, offset);
      offset += 4 + kdfOptLen;

      // number of keys
      final numKeys = _readUint32(bytes, offset);
      offset += 4;

      if (numKeys < 1) {
        return const Err(CryptoFailure('No keys found in OpenSSH file.'));
      }

      // Read public key blob
      final pubBlobLen = _readUint32(bytes, offset);
      offset += 4;
      final pubBlob = bytes.sublist(offset, offset + pubBlobLen);

      // Parse key type from public blob
      int pOff = 0;
      final typeLen = _readUint32(pubBlob, pOff);
      pOff += 4;
      final keyType = utf8.decode(pubBlob.sublist(pOff, pOff + typeLen));
      pOff += typeLen;

      if (keyType == 'ssh-ed25519') {
        final pkLen = _readUint32(pubBlob, pOff);
        pOff += 4;
        final publicKeyBytes = Uint8List.fromList(
          pubBlob.sublist(pOff, pOff + pkLen),
        );
        return Success(_ed25519ToOpenSshPublicKey(publicKeyBytes, comment));
      }

      return Err(CryptoFailure('Unsupported OpenSSH key type: $keyType'));
    } catch (e) {
      return Err(
        CryptoFailure('Failed to parse OpenSSH private key', cause: e),
      );
    }
  }

  /// Extract public key + comment from an OpenSSH private key.
  Future<Result<ExtractedKeyInfo>> _extractOpenSshKeyInfo(String pem) async {
    try {
      final lines = pem.split('\n');
      final b64 = lines.where((l) => !l.startsWith('-----')).join();
      final bytes = Uint8List.fromList(base64Decode(b64));

      int offset = 0;

      // Skip magic "openssh-key-v1\0"
      const magic = 'openssh-key-v1\x00';
      offset = magic.length;

      // ciphername
      final cipherLen = _readUint32(bytes, offset);
      offset += 4;
      final cipherName = utf8.decode(bytes.sublist(offset, offset + cipherLen));
      offset += cipherLen;

      if (cipherName != 'none') {
        return const Err(
          CryptoFailure(
            'Encrypted OpenSSH keys are not supported for extraction. '
            'Remove the passphrase first with ssh-keygen -p.',
          ),
        );
      }

      // kdfname
      final kdfLen = _readUint32(bytes, offset);
      offset += 4 + kdfLen;

      // kdfoptions
      final kdfOptLen = _readUint32(bytes, offset);
      offset += 4 + kdfOptLen;

      // number of keys
      final numKeys = _readUint32(bytes, offset);
      offset += 4;

      if (numKeys < 1) {
        return const Err(CryptoFailure('No keys found in OpenSSH file.'));
      }

      // Read public key blob
      final pubBlobLen = _readUint32(bytes, offset);
      offset += 4;
      final pubBlob = bytes.sublist(offset, offset + pubBlobLen);
      offset += pubBlobLen;

      // Parse key type from public blob
      int pOff = 0;
      final typeLen = _readUint32(pubBlob, pOff);
      pOff += 4;
      final keyType = utf8.decode(pubBlob.sublist(pOff, pOff + typeLen));
      pOff += typeLen;

      String? publicKey;
      if (keyType == 'ssh-ed25519') {
        final pkLen = _readUint32(pubBlob, pOff);
        pOff += 4;
        final publicKeyBytes = Uint8List.fromList(
          pubBlob.sublist(pOff, pOff + pkLen),
        );
        publicKey = _ed25519ToOpenSshPublicKey(
          publicKeyBytes,
          'shellvault-extracted',
        );
      }

      if (publicKey == null) {
        return Err(CryptoFailure('Unsupported OpenSSH key type: $keyType'));
      }

      // Parse private section to extract comment
      String? comment;
      final privSectionLen = _readUint32(bytes, offset);
      offset += 4;
      final privSection = bytes.sublist(offset, offset + privSectionLen);

      // Private section format:
      // checkInt1 (uint32) | checkInt2 (uint32) | keyType (string) |
      // ... key data ... | comment (string) | padding
      int sOff = 0;
      // checkInt1 + checkInt2
      sOff += 8;
      // keyType string
      final sTypeLen = _readUint32(privSection, sOff);
      sOff += 4 + sTypeLen;

      if (keyType == 'ssh-ed25519') {
        // pubkey (string) + privkey (string)
        final sPubLen = _readUint32(privSection, sOff);
        sOff += 4 + sPubLen;
        final sPrivLen = _readUint32(privSection, sOff);
        sOff += 4 + sPrivLen;
      }

      // Comment string
      if (sOff + 4 <= privSection.length) {
        final commentLen = _readUint32(privSection, sOff);
        sOff += 4;
        if (sOff + commentLen <= privSection.length) {
          comment = utf8.decode(privSection.sublist(sOff, sOff + commentLen));
        }
      }

      // Replace placeholder comment in publicKey line if we found a real comment
      if (comment != null && comment.isNotEmpty) {
        publicKey = publicKey.replaceFirst(
          ' shellvault-extracted',
          ' $comment',
        );
      }

      return Success(
        ExtractedKeyInfo(
          publicKey: publicKey,
          comment: (comment != null && comment.isNotEmpty) ? comment : null,
        ),
      );
    } catch (e) {
      return Err(
        CryptoFailure('Failed to parse OpenSSH private key', cause: e),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // PEM / OpenSSH encoding helpers
  // ---------------------------------------------------------------------------

  RSAPrivateKey? _pemToRsaPrivateKey(String pem) {
    final lines = pem.split('\n');
    final isRsa = lines.any(
      (l) => l.contains('RSA PRIVATE KEY') || l.contains('PRIVATE KEY'),
    );
    if (!isRsa) return null;

    final b64 = lines.where((l) => !l.startsWith('-----')).join();
    final bytes = base64Decode(b64);

    final parser = ASN1Parser(Uint8List.fromList(bytes));
    final seq = parser.nextObject() as ASN1Sequence;

    // PKCS#8 wraps PKCS#1 — detect by checking element count
    if (seq.elements!.length == 3) {
      final innerOctet = seq.elements![2] as ASN1OctetString;
      final innerParser = ASN1Parser(innerOctet.octets!);
      final innerSeq = innerParser.nextObject() as ASN1Sequence;
      return _parseRsaPrivateKeyFromSequence(innerSeq);
    }

    return _parseRsaPrivateKeyFromSequence(seq);
  }

  RSAPrivateKey _parseRsaPrivateKeyFromSequence(ASN1Sequence seq) {
    final modulus = (seq.elements![1] as ASN1Integer).integer!;
    final privateExponent = (seq.elements![3] as ASN1Integer).integer!;
    final p = (seq.elements![4] as ASN1Integer).integer!;
    final q = (seq.elements![5] as ASN1Integer).integer!;
    return RSAPrivateKey(modulus, privateExponent, p, q);
  }

  String _rsaPrivateKeyToPem(RSAPrivateKey key) {
    final seq = ASN1Sequence(elements: []);
    seq.add(ASN1Integer(BigInt.zero));
    seq.add(ASN1Integer(key.modulus!));
    seq.add(ASN1Integer(key.publicExponent!));
    seq.add(ASN1Integer(key.privateExponent!));
    seq.add(ASN1Integer(key.p!));
    seq.add(ASN1Integer(key.q!));
    seq.add(ASN1Integer(key.privateExponent! % (key.p! - BigInt.one)));
    seq.add(ASN1Integer(key.privateExponent! % (key.q! - BigInt.one)));
    seq.add(ASN1Integer(key.q!.modInverse(key.p!)));

    return _wrapPem('RSA PRIVATE KEY', seq.encode());
  }

  String _rsaPublicKeyToOpenSsh(RSAPublicKey key, String comment) {
    final eBytes = _encodeMpint(key.publicExponent!);
    final nBytes = _encodeMpint(key.modulus!);
    final typeBytes = utf8.encode('ssh-rsa');

    final buffer = BytesBuilder();
    buffer.add(_uint32Bytes(typeBytes.length));
    buffer.add(typeBytes);
    buffer.add(_uint32Bytes(eBytes.length));
    buffer.add(eBytes);
    buffer.add(_uint32Bytes(nBytes.length));
    buffer.add(nBytes);

    return 'ssh-rsa ${base64Encode(buffer.toBytes())} $comment';
  }

  // --- EC helpers ---

  String _ecPrivateKeyToPem(ECPrivateKey key, ECDomainParameters domainParams) {
    final privBytes = _bigIntToBytes(key.d!);
    final pubPoint = domainParams.G * key.d!;
    final pubBytes = pubPoint!.getEncoded(false); // uncompressed

    // SEC1 format
    final seq = ASN1Sequence(elements: []);
    seq.add(ASN1Integer(BigInt.one)); // version

    final privOctet = ASN1OctetString(octets: Uint8List.fromList(privBytes));
    seq.add(privOctet);

    // [0] OID
    final oid = switch (domainParams.domainName) {
      'secp256r1' => '1.2.840.10045.3.1.7',
      'secp384r1' => '1.3.132.0.34',
      'secp521r1' => '1.3.132.0.35',
      _ => throw ArgumentError('Unknown curve: ${domainParams.domainName}'),
    };

    final oidObj = ASN1ObjectIdentifier.fromIdentifierString(oid);
    final oidWrapper = ASN1Sequence(elements: [oidObj], tag: 0xA0);
    seq.add(oidWrapper);

    // [1] Public key bit string
    final pubBitString = ASN1BitString(elements: [], tag: 0x03);
    pubBitString.valueBytes = Uint8List.fromList([0x00, ...pubBytes]);
    final pubWrapper = ASN1Sequence(elements: [pubBitString], tag: 0xA1);
    seq.add(pubWrapper);

    return _wrapPem('EC PRIVATE KEY', seq.encode());
  }

  String _ecPublicKeyToOpenSsh(
    ECPublicKey key,
    SshKeyType type,
    String comment,
  ) {
    final curveName = type.curveName!;
    final sshType = type.sshName;

    final pubPoint = key.Q!.getEncoded(false); // uncompressed 04||x||y

    final typeBytes = utf8.encode(sshType);
    final curveBytes = utf8.encode(curveName);

    final buffer = BytesBuilder();
    buffer.add(_uint32Bytes(typeBytes.length));
    buffer.add(typeBytes);
    buffer.add(_uint32Bytes(curveBytes.length));
    buffer.add(curveBytes);
    buffer.add(_uint32Bytes(pubPoint.length));
    buffer.add(pubPoint);

    return '$sshType ${base64Encode(buffer.toBytes())} $comment';
  }

  // --- Ed25519 helpers ---

  String _ed25519ToOpenSshPublicKey(Uint8List publicKey, String comment) {
    final typeBytes = utf8.encode('ssh-ed25519');
    final buffer = BytesBuilder();
    buffer.add(_uint32Bytes(typeBytes.length));
    buffer.add(typeBytes);
    buffer.add(_uint32Bytes(publicKey.length));
    buffer.add(publicKey);
    return 'ssh-ed25519 ${base64Encode(buffer.toBytes())} $comment';
  }

  String _ed25519ToOpenSshPrivateKey(
    Uint8List privateKey,
    Uint8List publicKey,
    String comment,
  ) {
    // OpenSSH private key format (unencrypted)
    final random = Random.secure();
    final checkInt = random.nextInt(0xFFFFFFFF);

    // Build public key blob
    final pubBlob = BytesBuilder();
    final typeBytes = utf8.encode('ssh-ed25519');
    pubBlob.add(_uint32Bytes(typeBytes.length));
    pubBlob.add(typeBytes);
    pubBlob.add(_uint32Bytes(publicKey.length));
    pubBlob.add(publicKey);
    final pubBlobBytes = pubBlob.toBytes();

    // Build private section
    final privSection = BytesBuilder();
    privSection.add(_uint32Bytes(checkInt)); // check1
    privSection.add(_uint32Bytes(checkInt)); // check2
    privSection.add(_uint32Bytes(typeBytes.length));
    privSection.add(typeBytes);
    privSection.add(_uint32Bytes(publicKey.length));
    privSection.add(publicKey);
    // Ed25519 private key is 64 bytes: 32 seed + 32 public
    final fullPrivKey = Uint8List(64);
    fullPrivKey.setRange(0, 32, privateKey);
    fullPrivKey.setRange(32, 64, publicKey);
    privSection.add(_uint32Bytes(fullPrivKey.length));
    privSection.add(fullPrivKey);
    // Comment
    final commentBytes = utf8.encode(comment);
    privSection.add(_uint32Bytes(commentBytes.length));
    privSection.add(commentBytes);
    // Padding (1, 2, 3, ... until aligned to 8 bytes)
    var privSectionBytes = privSection.toBytes();
    final padLen = (8 - (privSectionBytes.length % 8)) % 8;
    if (padLen > 0) {
      final padded = BytesBuilder();
      padded.add(privSectionBytes);
      for (var i = 1; i <= padLen; i++) {
        padded.addByte(i);
      }
      privSectionBytes = padded.toBytes();
    }

    // Assemble full key
    final output = BytesBuilder();
    // Magic
    output.add(utf8.encode('openssh-key-v1'));
    output.addByte(0x00);
    // ciphername: "none"
    final noneBytes = utf8.encode('none');
    output.add(_uint32Bytes(noneBytes.length));
    output.add(noneBytes);
    // kdfname: "none"
    output.add(_uint32Bytes(noneBytes.length));
    output.add(noneBytes);
    // kdfoptions: empty
    output.add(_uint32Bytes(0));
    // number of keys: 1
    output.add(_uint32Bytes(1));
    // public key blob
    output.add(_uint32Bytes(pubBlobBytes.length));
    output.add(pubBlobBytes);
    // private section
    output.add(_uint32Bytes(privSectionBytes.length));
    output.add(privSectionBytes);

    final encoded = base64Encode(output.toBytes());
    final lines = <String>[];
    for (var i = 0; i < encoded.length; i += 70) {
      lines.add(
        encoded.substring(i, i + 70 > encoded.length ? encoded.length : i + 70),
      );
    }

    return '-----BEGIN OPENSSH PRIVATE KEY-----\n${lines.join('\n')}\n-----END OPENSSH PRIVATE KEY-----';
  }

  // ---------------------------------------------------------------------------
  // Shared utilities
  // ---------------------------------------------------------------------------

  String _wrapPem(String label, List<int> derBytes) {
    final encoded = base64Encode(derBytes);
    final lines = <String>[];
    for (var i = 0; i < encoded.length; i += 64) {
      lines.add(
        encoded.substring(i, i + 64 > encoded.length ? encoded.length : i + 64),
      );
    }
    return '-----BEGIN $label-----\n${lines.join('\n')}\n-----END $label-----';
  }

  Uint8List _encodeMpint(BigInt value) {
    final bytes = _bigIntToBytes(value);
    if (bytes.isNotEmpty && bytes[0] & 0x80 != 0) {
      return Uint8List.fromList([0, ...bytes]);
    }
    return bytes;
  }

  Uint8List _bigIntToBytes(BigInt value) {
    var hex = value.toRadixString(16);
    if (hex.length % 2 != 0) hex = '0$hex';
    final bytes = Uint8List(hex.length ~/ 2);
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return bytes;
  }

  Uint8List _uint32Bytes(int value) {
    final bytes = Uint8List(4);
    bytes[0] = (value >> 24) & 0xFF;
    bytes[1] = (value >> 16) & 0xFF;
    bytes[2] = (value >> 8) & 0xFF;
    bytes[3] = value & 0xFF;
    return bytes;
  }

  int _readUint32(Uint8List bytes, int offset) {
    return (bytes[offset] << 24) |
        (bytes[offset + 1] << 16) |
        (bytes[offset + 2] << 8) |
        bytes[offset + 3];
  }
}
