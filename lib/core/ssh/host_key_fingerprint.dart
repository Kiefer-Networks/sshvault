import 'dart:convert';
import 'dart:typed_data';

/// Keeps persisted host pins stable across dartssh2's fingerprint format change.
Uint8List hostKeyDigest(Uint8List fingerprint) {
  if (fingerprint.length == 32) return fingerprint;
  final text = utf8.decode(fingerprint);
  if (!text.startsWith('SHA256:')) {
    throw const FormatException('Invalid host fingerprint');
  }
  final digest = base64.decode(base64.normalize(text.substring(7)));
  if (digest.length != 32) {
    throw const FormatException('Invalid SHA256 fingerprint length');
  }
  return digest;
}
