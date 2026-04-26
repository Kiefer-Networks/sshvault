import 'dart:typed_data';

/// Interface for a class that implements key exchange logic.
abstract class SSHKex {}

/// Interface for a class that implements ECDH key exchange.
abstract class SSHKexECDH implements SSHKex {
  /// Public key computed from the private key.
  Uint8List get publicKey;

  BigInt computeSecret(Uint8List remotePublicKey);
}

/// Hybrid post-quantum key exchange (e.g. `mlkem768x25519-sha256`,
/// `sntrup761x25519-sha512@openssh.com`).
///
/// On the wire these algorithms concatenate a classical ECDH public key
/// (X25519) with a KEM public key, and the shared secret used for the
/// exchange hash is the raw byte concatenation of the X25519 result with
/// the KEM-derived secret. Unlike [SSHKexECDH] the secret therefore is
/// **not** mpint-encoded into the exchange hash — callers must treat
/// [computeSecretBytes] as the canonical bytes to hash.
abstract class SSHKexHybrid implements SSHKex {
  /// Concatenated public-key blob: `x25519_pub || kem_pub`. The full blob
  /// is sent verbatim as the SSH `f`/`q_c` field.
  Uint8List get publicKey;

  /// Decapsulate (client side) or encapsulate (server side) and combine
  /// with the X25519 result. [remotePublicKey] is the peer's full blob,
  /// matching [publicKey] in shape.
  Uint8List computeSecretBytes(Uint8List remotePublicKey);
}
