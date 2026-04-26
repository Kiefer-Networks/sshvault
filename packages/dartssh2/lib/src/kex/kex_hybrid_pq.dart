/// Hybrid post-quantum key exchange implementations for SSH.
///
/// Wires two independent KEMs together per OpenSSH `kexmlkem768x25519.c`
/// and `kexsntrup761x25519.c`:
///
/// - Client public-key blob (sent in SSH_MSG_KEX_ECDH_INIT):
///   `kem_pub || x25519_pub` — KEM first, X25519 second.
/// - Server reply blob (sent in SSH_MSG_KEX_ECDH_REPLY):
///   `kem_ciphertext || server_x25519_pub` — same ordering.
/// - Shared secret K passed into the SSH exchange hash and key
///   derivation is `HASH(kem_ss || x25519_ss)`. The hash is then
///   encoded as an SSH `string` (uint32 length + bytes), **not** as
///   an mpint. SHA-256 for `mlkem768x25519-sha256`, SHA-512 for
///   `sntrup761x25519-sha512@openssh.com`.
library;

import 'dart:typed_data';

import 'package:dartssh2/src/algorithm/ssh_kex_type.dart';
import 'package:dartssh2/src/kex/oqs_ffi.dart';
import 'package:dartssh2/src/ssh_kex.dart';
import 'package:dartssh2/src/utils/list.dart';
import 'package:pinenacl/tweetnacl.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/digests/sha512.dart';
import 'package:pointycastle/api.dart' show Digest;

const int _x25519KeyLength = 32;
const int _x25519SharedLength = 32;

/// Hash `kem_ss || x25519_ss` with [digest] and return the digest output.
/// Matches `ssh_digest_buffer(kex->hash_alg, buf, hash, ...)` in
/// OpenSSH's `kexmlkem768x25519.c` / `kexsntrup761x25519.c`.
Uint8List _hashSecrets(Digest digest, Uint8List kemSs, Uint8List x25519Ss) {
  final concat = Uint8List(kemSs.length + x25519Ss.length);
  concat.setRange(0, kemSs.length, kemSs);
  concat.setRange(kemSs.length, concat.length, x25519Ss);
  digest.reset();
  digest.update(concat, 0, concat.length);
  final out = Uint8List(digest.digestSize);
  digest.doFinal(out, 0);
  return out;
}

/// Hybrid X25519 + ML-KEM-768 KEX (`mlkem768x25519-sha256`).
class SSHKexMlkem768X25519 implements SSHKexHybrid {
  static const _kemAlgorithm = 'ML-KEM-768';

  final OqsKem _kem;

  /// X25519 scalar (private key). 32 bytes.
  final Uint8List _x25519Private;

  /// X25519 public point. 32 bytes.
  final Uint8List _x25519Public;

  /// ML-KEM-768 public key.
  final Uint8List _kemPublic;

  /// ML-KEM-768 secret key — kept private to the KEX instance.
  final Uint8List _kemSecret;

  SSHKexMlkem768X25519._({
    required OqsKem kem,
    required Uint8List x25519Private,
    required Uint8List x25519Public,
    required Uint8List kemPublic,
    required Uint8List kemSecret,
  })  : _kem = kem,
        _x25519Private = x25519Private,
        _x25519Public = x25519Public,
        _kemPublic = kemPublic,
        _kemSecret = kemSecret;

  factory SSHKexMlkem768X25519() {
    final kem = OqsKem.lookup(_kemAlgorithm);
    final x25519Private = randomBytes(_x25519KeyLength);
    final x25519Public = Uint8List(_x25519KeyLength);
    TweetNaCl.crypto_scalarmult_base(x25519Public, x25519Private);
    final kemKeys = kem.keypair();
    return SSHKexMlkem768X25519._(
      kem: kem,
      x25519Private: x25519Private,
      x25519Public: x25519Public,
      kemPublic: kemKeys.publicKey,
      kemSecret: kemKeys.secretKey,
    );
  }

  @override
  Uint8List get publicKey {
    // Wire format per OpenSSH kexmlkem768x25519.c::keypair():
    //   kem_pub (1184 bytes) || x25519_pub (32 bytes)
    final blob = Uint8List(_kemPublic.length + _x25519Public.length);
    blob.setRange(0, _kemPublic.length, _kemPublic);
    blob.setRange(_kemPublic.length, blob.length, _x25519Public);
    return blob;
  }

  @override
  Uint8List computeSecretBytes(Uint8List remotePublicKey) {
    // Server reply layout per OpenSSH kexmlkem768x25519.c::dec():
    //   kem_ciphertext (1088 bytes) || server_x25519_pub (32 bytes)
    final kemCiphertextLength = _kem.ciphertextLength;
    final expected = kemCiphertextLength + _x25519KeyLength;
    if (remotePublicKey.length != expected) {
      throw ArgumentError(
        'mlkem768x25519: remote blob is ${remotePublicKey.length} bytes, '
        'expected $expected ($kemCiphertextLength-byte ML-KEM ciphertext || 32-byte X25519)',
      );
    }
    final kemCiphertext = Uint8List.sublistView(
      remotePublicKey,
      0,
      kemCiphertextLength,
    );
    final remoteX25519 = Uint8List.sublistView(
      remotePublicKey,
      kemCiphertextLength,
      kemCiphertextLength + _x25519KeyLength,
    );
    final x25519Shared = Uint8List(_x25519SharedLength);
    TweetNaCl.crypto_scalarmult(x25519Shared, _x25519Private, remoteX25519);
    final kemShared = _kem.decapsulate(kemCiphertext, _kemSecret);
    // K = SHA256(kem_ss || x25519_ss) — exact match for OpenSSH's
    // ssh_digest_buffer(SSH_DIGEST_SHA256, buf, hash, ...).
    return _hashSecrets(SHA256Digest(), kemShared, x25519Shared);
  }
}

/// Hybrid X25519 + sntrup761 KEX
/// (`sntrup761x25519-sha512@openssh.com`).
class SSHKexSntrup761X25519 implements SSHKexHybrid {
  static const _kemAlgorithm = 'sntrup761';

  final OqsKem _kem;
  final Uint8List _x25519Private;
  final Uint8List _x25519Public;
  final Uint8List _kemPublic;
  final Uint8List _kemSecret;

  SSHKexSntrup761X25519._({
    required OqsKem kem,
    required Uint8List x25519Private,
    required Uint8List x25519Public,
    required Uint8List kemPublic,
    required Uint8List kemSecret,
  })  : _kem = kem,
        _x25519Private = x25519Private,
        _x25519Public = x25519Public,
        _kemPublic = kemPublic,
        _kemSecret = kemSecret;

  factory SSHKexSntrup761X25519() {
    final kem = OqsKem.lookup(_kemAlgorithm);
    final x25519Private = randomBytes(_x25519KeyLength);
    final x25519Public = Uint8List(_x25519KeyLength);
    TweetNaCl.crypto_scalarmult_base(x25519Public, x25519Private);
    final kemKeys = kem.keypair();
    return SSHKexSntrup761X25519._(
      kem: kem,
      x25519Private: x25519Private,
      x25519Public: x25519Public,
      kemPublic: kemKeys.publicKey,
      kemSecret: kemKeys.secretKey,
    );
  }

  @override
  Uint8List get publicKey {
    // sntrup761x25519@openssh.com reverses the order: KEM public first,
    // then X25519. Matches OpenSSH's PROTOCOL.sntrup761x25519.
    final blob = Uint8List(_kemPublic.length + _x25519Public.length);
    blob.setRange(0, _kemPublic.length, _kemPublic);
    blob.setRange(_kemPublic.length, blob.length, _x25519Public);
    return blob;
  }

  @override
  Uint8List computeSecretBytes(Uint8List remotePublicKey) {
    // Server reply per OpenSSH kexsntrup761x25519.c::dec():
    //   kem_ciphertext || server_x25519_pub.
    final kemCiphertextLength = _kem.ciphertextLength;
    final expected = kemCiphertextLength + _x25519KeyLength;
    if (remotePublicKey.length != expected) {
      throw ArgumentError(
        'sntrup761x25519: remote blob is ${remotePublicKey.length} bytes, '
        'expected $expected ($kemCiphertextLength-byte sntrup761 ciphertext || 32-byte X25519)',
      );
    }
    final kemCiphertext = Uint8List.sublistView(
      remotePublicKey,
      0,
      kemCiphertextLength,
    );
    final remoteX25519 = Uint8List.sublistView(
      remotePublicKey,
      kemCiphertextLength,
      kemCiphertextLength + _x25519KeyLength,
    );
    final x25519Shared = Uint8List(_x25519SharedLength);
    TweetNaCl.crypto_scalarmult(x25519Shared, _x25519Private, remoteX25519);
    final kemShared = _kem.decapsulate(kemCiphertext, _kemSecret);
    // K = SHA512(kem_ss || x25519_ss).
    return _hashSecrets(SHA512Digest(), kemShared, x25519Shared);
  }
}

/// Registers the hybrid KEX factories with [SSHKexType] so the transport
/// can construct them without importing `dart:ffi` itself. Idempotent —
/// safe to call from every [SSHTransport] constructor.
void registerHybridKexFactories() {
  registerMlkem768X25519Factory(SSHKexMlkem768X25519.new);
  registerSntrup761X25519Factory(SSHKexSntrup761X25519.new);
}

/// Cached availability — `true` means the bundled liboqs build offers
/// the KEM, `false` means it does not (or the library could not be
/// loaded), and `null` means we have not checked yet. Checking is
/// deferred so platforms that don't ship liboqs simply omit the names
/// from the advertised KEX list instead of crashing the handshake.
bool? _mlkem768Available;
bool? _sntrup761Available;

bool _isMlkem768Available() {
  return _mlkem768Available ??= OqsKem.isAvailable('ML-KEM-768');
}

bool _isSntrup761Available() {
  return _sntrup761Available ??= OqsKem.isAvailable('sntrup761');
}

/// Strips hybrid PQ KEX names from [requested] when the underlying KEM
/// is not available on this platform. Other entries are returned in
/// order. Used by the transport before it advertises the local KEX
/// list — keeps the negotiation honest on builds that omit one or both
/// hybrids (e.g. a future minimal Web build).
List<String> filterAvailableKex(List<String> requested) {
  return requested.where((name) {
    switch (name) {
      case 'mlkem768x25519-sha256':
        return _isMlkem768Available();
      case 'sntrup761x25519-sha512@openssh.com':
        return _isSntrup761Available();
      default:
        return true;
    }
  }).toList(growable: false);
}
