import 'package:dartssh2/src/ssh_algorithm.dart';
import 'package:dartssh2/src/ssh_kex.dart';
import 'package:pointycastle/export.dart';

class SSHKexType extends SSHAlgorithm {
  static const x25519 = SSHKexType._(
    name: 'curve25519-sha256@libssh.org',
    digestFactory: digestSha256,
  );

  static const nistp256 = SSHKexType._(
    name: 'ecdh-sha2-nistp256',
    digestFactory: digestSha256,
  );

  static const nistp384 = SSHKexType._(
    name: 'ecdh-sha2-nistp384',
    digestFactory: digestSha384,
  );

  static const nistp521 = SSHKexType._(
    name: 'ecdh-sha2-nistp521',
    digestFactory: digestSha512,
  );

  static const dhGexSha256 = SSHKexType._(
    name: 'diffie-hellman-group-exchange-sha256',
    digestFactory: digestSha256,
    isGroupExchange: true,
  );

  static const dhGexSha1 = SSHKexType._(
    name: 'diffie-hellman-group-exchange-sha1',
    digestFactory: digestSha1,
    isGroupExchange: true,
  );

  static const dh14Sha1 = SSHKexType._(
    name: 'diffie-hellman-group14-sha1',
    digestFactory: digestSha1,
  );

  static const dh14Sha256 = SSHKexType._(
    name: 'diffie-hellman-group14-sha256',
    digestFactory: digestSha256,
  );

  static const dh1Sha1 = SSHKexType._(
    name: 'diffie-hellman-group1-sha1',
    digestFactory: digestSha1,
  );

  /// Hybrid post-quantum key exchange combining ML-KEM-768 (FIPS 203)
  /// with X25519. The exchange hash is SHA-256 over the raw concatenated
  /// shared secrets. OpenSSH 9.9+ default.
  static const mlkem768x25519Sha256 = SSHKexType._(
    name: 'mlkem768x25519-sha256',
    digestFactory: digestSha256,
    isHybrid: true,
  );

  /// Hybrid post-quantum key exchange combining Streamlined NTRU Prime
  /// (sntrup761) with X25519. Exchange hash uses SHA-512. OpenSSH 9.0+.
  static const sntrup761x25519Sha512 = SSHKexType._(
    name: 'sntrup761x25519-sha512@openssh.com',
    digestFactory: digestSha512,
    isHybrid: true,
  );

  const SSHKexType._({
    required this.name,
    required this.digestFactory,
    this.isGroupExchange = false,
    this.isHybrid = false,
  });

  /// The name of the algorithm. For example, `"ecdh-sha2-nistp256"`.
  @override
  final String name;

  final Digest Function() digestFactory;

  final bool isGroupExchange;

  /// Whether this KEX uses the hybrid post-quantum protocol — public-key
  /// blobs are concatenated `classical || kem` and the exchange hash
  /// consumes the shared secret as raw bytes instead of mpint.
  final bool isHybrid;

  Digest createDigest() => digestFactory();
}

/// Returns true if [type] denotes one of the hybrid PQ key exchanges
/// added by SSHVault. Used by the transport to switch the
/// SSHKex constructor and the exchange-hash builder.
bool isHybridKex(SSHKexType type) => type.isHybrid;

/// Hook for the transport to register a constructor for a hybrid KEX.
/// Filled in by `kex_hybrid_factory.dart` so `ssh_transport.dart` does
/// not need to import the FFI shim directly (keeps `dart:ffi` out of
/// pure-Dart compile units).
typedef SSHKexHybridFactory = SSHKexHybrid Function();
SSHKexHybridFactory? _mlkem768X25519Factory;
SSHKexHybridFactory? _sntrup761X25519Factory;

void registerMlkem768X25519Factory(SSHKexHybridFactory factory) {
  _mlkem768X25519Factory = factory;
}

void registerSntrup761X25519Factory(SSHKexHybridFactory factory) {
  _sntrup761X25519Factory = factory;
}

SSHKexHybrid createMlkem768X25519() {
  final factory = _mlkem768X25519Factory;
  if (factory == null) {
    throw StateError(
      'mlkem768x25519-sha256 KEX requested but the liboqs FFI factory '
      'has not been registered. Ensure registerHybridKexFactories() is '
      'called at app start (or that liboqs is linked into the build).',
    );
  }
  return factory();
}

SSHKexHybrid createSntrup761X25519() {
  final factory = _sntrup761X25519Factory;
  if (factory == null) {
    throw StateError(
      'sntrup761x25519-sha512@openssh.com KEX requested but the liboqs '
      'FFI factory has not been registered.',
    );
  }
  return factory();
}

Digest digestSha1() => SHA1Digest();
Digest digestSha256() => SHA256Digest();
Digest digestSha384() => SHA384Digest();
Digest digestSha512() => SHA512Digest();
