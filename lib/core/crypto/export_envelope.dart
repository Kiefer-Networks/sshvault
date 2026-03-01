import 'dart:convert';
import 'dart:typed_data';

class ExportEnvelope {
  final int version;
  final String salt;
  final String nonce;
  final String encryptedData;
  final String checksum;

  const ExportEnvelope({
    required this.version,
    required this.salt,
    required this.nonce,
    required this.encryptedData,
    required this.checksum,
  });

  Map<String, dynamic> toJson() => {
        'version': version,
        'salt': salt,
        'nonce': nonce,
        'encryptedData': encryptedData,
        'checksum': checksum,
      };

  factory ExportEnvelope.fromJson(Map<String, dynamic> json) {
    return ExportEnvelope(
      version: json['version'] as int,
      salt: json['salt'] as String,
      nonce: json['nonce'] as String,
      encryptedData: json['encryptedData'] as String,
      checksum: json['checksum'] as String,
    );
  }

  Uint8List get saltBytes => base64Decode(salt);
  Uint8List get nonceBytes => base64Decode(nonce);
  Uint8List get encryptedBytes => base64Decode(encryptedData);
}
