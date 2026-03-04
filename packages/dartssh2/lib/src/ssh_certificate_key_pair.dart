import 'dart:typed_data';

import 'package:dartssh2/src/ssh_hostkey.dart';
import 'package:dartssh2/src/ssh_key_pair.dart';
import 'package:dartssh2/src/ssh_message.dart';

/// A map from base key type to OpenSSH certificate type.
const _certTypeMap = {
  'ssh-rsa': 'ssh-rsa-cert-v01@openssh.com',
  'rsa-sha2-256': 'ssh-rsa-cert-v01@openssh.com',
  'rsa-sha2-512': 'ssh-rsa-cert-v01@openssh.com',
  'ssh-ed25519': 'ssh-ed25519-cert-v01@openssh.com',
  'ecdsa-sha2-nistp256': 'ecdsa-sha2-nistp256-cert-v01@openssh.com',
  'ecdsa-sha2-nistp384': 'ecdsa-sha2-nistp384-cert-v01@openssh.com',
  'ecdsa-sha2-nistp521': 'ecdsa-sha2-nistp521-cert-v01@openssh.com',
};

/// An [SSHKeyPair] wrapper that presents an OpenSSH certificate as the
/// public key during authentication.
///
/// Teleport (and other CA-based SSH systems) issue short-lived SSH
/// certificates that wrap a user's key pair. During the SSH handshake the
/// client must advertise the **certificate type** (e.g.
/// `ssh-ed25519-cert-v01@openssh.com`) and send the **full certificate blob**
/// instead of the raw public key. The signature is still produced by the
/// underlying private key.
///
/// Usage:
/// ```dart
/// final keyPair = SSHKeyPair.fromPem(pemText).first;
/// final certKeyPair = SSHCertificateKeyPair(
///   innerKeyPair: keyPair,
///   certificateBlob: certBytes,
/// );
/// final client = SSHClient(socket, identities: [certKeyPair], ...);
/// ```
class SSHCertificateKeyPair implements SSHKeyPair {
  /// The underlying key pair used for signing.
  final SSHKeyPair innerKeyPair;

  /// The raw OpenSSH certificate blob (wire format, starting with the
  /// certificate type string).
  final Uint8List certificateBlob;

  /// The certificate type string extracted from the blob, e.g.
  /// `ssh-ed25519-cert-v01@openssh.com`.
  final String _certType;

  /// Creates a certificate key pair.
  ///
  /// [innerKeyPair] is the private key that matches the public key inside
  /// the certificate.
  ///
  /// [certificateBlob] is the raw certificate in SSH wire format. The type
  /// string is extracted automatically from the blob. If the blob does not
  /// start with a recognised certificate type, [certType] can be provided
  /// explicitly.
  SSHCertificateKeyPair({
    required this.innerKeyPair,
    required this.certificateBlob,
    String? certType,
  }) : _certType = certType ?? _extractCertType(innerKeyPair, certificateBlob);

  /// Derives the certificate type from the inner key pair's type, falling back
  /// to reading the type string from the certificate blob header.
  static String _extractCertType(
    SSHKeyPair keyPair,
    Uint8List certificateBlob,
  ) {
    // Try mapping from the key pair's signing type.
    final mapped = _certTypeMap[keyPair.type];
    if (mapped != null) return mapped;

    // Fall back: read the type string from the certificate blob.
    if (certificateBlob.length >= 4) {
      final reader = SSHMessageReader(certificateBlob);
      return reader.readUtf8();
    }

    throw ArgumentError(
      'Cannot determine certificate type for key type "${keyPair.type}". '
      'Provide certType explicitly.',
    );
  }

  /// The certificate type, e.g. `ssh-ed25519-cert-v01@openssh.com`.
  @override
  String get name => _certType;

  /// The certificate type used during authentication.
  @override
  String get type => _certType;

  /// Returns an [SSHHostKey] whose [encode] yields the full certificate blob.
  @override
  SSHHostKey toPublicKey() => _SSHCertificateHostKey(certificateBlob);

  /// Signs [data] using the underlying private key.
  @override
  SSHSignature sign(Uint8List data) => innerKeyPair.sign(data);

  /// PEM export delegates to the inner key pair (the certificate itself is
  /// not a PEM private key).
  @override
  String toPem() => innerKeyPair.toPem();

  @override
  String toString() => 'SSHCertificateKeyPair(type: $_certType)';
}

/// An [SSHHostKey] that returns the raw certificate blob from [encode].
class _SSHCertificateHostKey implements SSHHostKey {
  final Uint8List _blob;

  _SSHCertificateHostKey(this._blob);

  @override
  Uint8List encode() => _blob;
}
