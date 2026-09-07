import 'dart:typed_data';

/// Interface for a class that implements key exchange logic.
abstract class SSHKex {}

/// Interface for a class that implements ECDH key exchange.
abstract class SSHKexECDH implements SSHKex {
  /// Public key computed from the private key.
  Uint8List get publicKey;

  BigInt computeSecret(Uint8List remotePublicKey);
}

/// Interface for hybrid post-quantum exchanges whose shared secret is raw
/// bytes rather than an SSH mpint.
abstract class SSHKexHybrid implements SSHKex {
  Uint8List get publicKey;

  Uint8List computeSecretBytes(Uint8List remotePublicKey);
}
