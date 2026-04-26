/// Hybrid post-quantum key exchange implementations for SSH.
///
/// These wire two independent KEMs together:
///   - X25519 ECDH (TweetNaCl, classical)
///   - ML-KEM-768 or sntrup761 (liboqs via FFI, post-quantum)
///
/// On the wire the public-key blob is `x25519_pub || kem_pub` and the
/// shared-secret bytes fed into the SSH exchange hash are
/// `x25519_ss || kem_ss` (raw concatenation, **not** mpint encoding).
library;

import 'dart:typed_data';

import 'package:dartssh2/src/algorithm/ssh_kex_type.dart';
import 'package:dartssh2/src/kex/oqs_ffi.dart';
import 'package:dartssh2/src/ssh_kex.dart';
import 'package:dartssh2/src/utils/list.dart';
import 'package:pinenacl/tweetnacl.dart';

const int _x25519KeyLength = 32;
const int _x25519SharedLength = 32;

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
    final blob = Uint8List(_x25519Public.length + _kemPublic.length);
    blob.setRange(0, _x25519Public.length, _x25519Public);
    blob.setRange(_x25519Public.length, blob.length, _kemPublic);
    return blob;
  }

  @override
  Uint8List computeSecretBytes(Uint8List remotePublicKey) {
    // Server response layout (RFC draft-josefsson-ntruprime-ssh):
    //   server_x25519_pub (32 bytes) || kem_ciphertext (kem.ciphertextLength)
    final kemCiphertextLength = _kem.ciphertextLength;
    final expected = _x25519KeyLength + kemCiphertextLength;
    if (remotePublicKey.length != expected) {
      throw ArgumentError(
        'mlkem768x25519: remote blob is ${remotePublicKey.length} bytes, '
        'expected $expected (32-byte X25519 || $kemCiphertextLength-byte ML-KEM ciphertext)',
      );
    }
    final remoteX25519 = Uint8List.sublistView(
      remotePublicKey,
      0,
      _x25519KeyLength,
    );
    final kemCiphertext = Uint8List.sublistView(
      remotePublicKey,
      _x25519KeyLength,
      _x25519KeyLength + kemCiphertextLength,
    );
    final x25519Shared = Uint8List(_x25519SharedLength);
    TweetNaCl.crypto_scalarmult(x25519Shared, _x25519Private, remoteX25519);
    final kemShared = _kem.decapsulate(kemCiphertext, _kemSecret);
    final out = Uint8List(x25519Shared.length + kemShared.length);
    out.setRange(0, x25519Shared.length, x25519Shared);
    out.setRange(x25519Shared.length, out.length, kemShared);
    return out;
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
    final out = Uint8List(kemShared.length + x25519Shared.length);
    out.setRange(0, kemShared.length, kemShared);
    out.setRange(kemShared.length, out.length, x25519Shared);
    return out;
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
