import 'dart:typed_data';
import 'package:dartssh2/src/ssh_hostkey.dart';
import 'package:dartssh2/src/ssh_identity.dart';

/// Compatibility adapter for an external agent's SSH-format signature callback.
class SSHAgentKeyPair extends SSHIdentity {
  final Uint8List publicKey;
  @override
  final String type;
  final Future<Uint8List> Function(Uint8List data) signer;

  SSHAgentKeyPair(
      {required this.publicKey, required this.type, required this.signer});
  @override
  bool get shouldProbe => true;
  @override
  SSHHostKey toPublicKey() => SSHRawHostKey(publicKey);
  @override
  Future<SSHSignature> sign(Uint8List data) async =>
      SSHRawSignature(await signer(data));
  Future<Uint8List> signAsync(Uint8List data) => signer(data);
}
