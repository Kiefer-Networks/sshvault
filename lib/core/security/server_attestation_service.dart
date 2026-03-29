import 'dart:convert';
import 'package:cryptography/cryptography.dart'
    show Ed25519, KeyPairType, Signature, SimplePublicKey;
import 'package:sshvault/core/crypto/crypto_utils.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/core/services/logging_service.dart';

/// Verifies that the server is the expected SSHVault backend.
///
/// The server provides a signed attestation containing its identity,
/// timestamp, and API version. The client verifies this attestation
/// using the server's Ed25519 public key.
///
/// This prevents connecting to rogue servers that may try to intercept
/// or modify sync data.
class ServerAttestationService {
  static final _log = LoggingService.instance;
  static const _tag = 'Attest';

  /// Maximum allowed clock skew between client and server (seconds).
  static const int maxClockSkewSeconds = 90;

  /// Minimum API version the client supports.
  static const int minApiVersion = 1;

  /// Expected server identity string.
  final String _expectedServerId;

  /// Ed25519 public key for verifying attestation signatures.
  final SimplePublicKey _publicKey;

  /// Ed25519 algorithm instance.
  final Ed25519 _ed25519 = Ed25519();

  ServerAttestationService({
    required String expectedServerId,
    required SimplePublicKey publicKey,
  }) : _expectedServerId = expectedServerId,
       _publicKey = publicKey;

  /// Create an instance from a base64-encoded Ed25519 public key.
  factory ServerAttestationService.fromBase64Key({
    required String expectedServerId,
    required String publicKeyBase64,
  }) {
    final keyBytes = base64Decode(publicKeyBase64);
    return ServerAttestationService(
      expectedServerId: expectedServerId,
      publicKey: SimplePublicKey(keyBytes, type: KeyPairType.ed25519),
    );
  }

  /// Verify a server attestation response.
  ///
  /// The attestation [json] should contain:
  /// - `server_id`: Server identity string
  /// - `timestamp`: Unix timestamp (seconds since epoch)
  /// - `api_version`: Integer API version
  /// - `nonce`: Client-provided nonce (for replay protection)
  /// - `signature`: Base64-encoded Ed25519 signature
  Future<Result<ServerAttestation>> verify(
    Map<String, dynamic> json, {
    required String expectedNonce,
  }) async {
    _log.debug(_tag, 'Verifying server attestation');

    try {
      final attestation = ServerAttestation.fromJson(json);

      // 1. Verify server identity
      if (attestation.serverId != _expectedServerId) {
        _log.error(
          _tag,
          'Server identity mismatch: '
          'expected $_expectedServerId, got ${attestation.serverId}',
        );
        return const Err(
          NetworkFailure(
            'Server identity verification failed. '
            'The server is not the expected SSHVault backend.',
          ),
        );
      }

      // 2. Verify timestamp (clock skew check)
      final now = DateTime.now().toUtc();
      final serverTime = DateTime.fromMillisecondsSinceEpoch(
        attestation.timestamp * 1000,
        isUtc: true,
      );
      final skew = now.difference(serverTime).inSeconds.abs();
      if (skew > maxClockSkewSeconds) {
        _log.error(
          _tag,
          'Attestation timestamp too far from local clock '
          '(skew: ${skew}s, max: ${maxClockSkewSeconds}s)',
        );
        return const Err(
          NetworkFailure(
            'Server attestation timestamp is too far from local time. '
            'Check system clock synchronization.',
          ),
        );
      }

      // 3. Verify API version
      if (attestation.apiVersion < minApiVersion) {
        _log.error(
          _tag,
          'Server API version too old: '
          '${attestation.apiVersion} < $minApiVersion',
        );
        return Err(
          NetworkFailure(
            'Server API version ${attestation.apiVersion} is not supported. '
            'Minimum required: $minApiVersion.',
          ),
        );
      }

      // 4. Verify nonce (required for replay protection)
      if (attestation.nonce != expectedNonce) {
        _log.error(_tag, 'Attestation nonce mismatch (possible replay attack)');
        return const Err(
          NetworkFailure(
            'Server attestation nonce mismatch (replay detected).',
          ),
        );
      }

      // 5. Verify Ed25519 signature
      final message = _buildCanonicalPayload(attestation);
      final signatureBytes = base64Decode(attestation.signature);
      final messageBytes = utf8.encode(message);

      final signature = Signature(signatureBytes, publicKey: _publicKey);
      final isValid = await _ed25519.verify(messageBytes, signature: signature);

      if (!isValid) {
        _log.error(_tag, 'Attestation signature verification failed');
        return const Err(
          NetworkFailure(
            'Server attestation signature is invalid. '
            'The server may be compromised.',
          ),
        );
      }

      _log.info(
        _tag,
        'Server attestation verified '
        '(v${attestation.apiVersion}, skew: ${skew}s)',
      );
      return Success(attestation);
    } catch (e) {
      _log.error(_tag, 'Failed to parse server attestation: $e');
      return Err(NetworkFailure('Invalid server attestation format', cause: e));
    }
  }

  /// Generate a cryptographically secure random nonce for attestation requests.
  static String generateNonce() {
    return base64Url.encode(CryptoUtils.secureRandomBytes(16));
  }

  /// Build canonical payload matching the server's signing format.
  ///
  /// Format: "server_id|unix_timestamp|api_version|nonce"
  String _buildCanonicalPayload(ServerAttestation attestation) {
    return '${attestation.serverId}'
        '|${attestation.timestamp}'
        '|${attestation.rawApiVersion}'
        '|${attestation.nonce}';
  }
}

/// Parsed server attestation data.
class ServerAttestation {
  final String serverId;
  final int timestamp;
  final int apiVersion;

  /// Raw api_version string as received from the server (e.g. "v1").
  /// Used in the canonical payload to match the server's signing format.
  final String rawApiVersion;
  final String nonce;
  final String signature;

  const ServerAttestation({
    required this.serverId,
    required this.timestamp,
    required this.apiVersion,
    required this.rawApiVersion,
    required this.nonce,
    required this.signature,
  });

  factory ServerAttestation.fromJson(Map<String, dynamic> json) {
    final rawVersion = json['api_version'].toString();
    return ServerAttestation(
      serverId: json['server_id'] as String,
      timestamp: _toInt(json['timestamp']),
      apiVersion: _parseVersion(rawVersion),
      rawApiVersion: rawVersion,
      nonce: json['nonce'] as String,
      signature: json['signature'] as String,
    );
  }

  /// Parse a value that may be int or String to int.
  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    throw FormatException(
      'Expected int or numeric String, got ${value.runtimeType}',
    );
  }

  /// Parse a version string that may have a "v" prefix (e.g. "v1" → 1).
  static int _parseVersion(String value) {
    final cleaned = value.startsWith('v') || value.startsWith('V')
        ? value.substring(1)
        : value;
    return int.parse(cleaned);
  }

  Map<String, dynamic> toJson() => {
    'server_id': serverId,
    'timestamp': timestamp,
    'api_version': rawApiVersion,
    'nonce': nonce,
    'signature': signature,
  };
}
