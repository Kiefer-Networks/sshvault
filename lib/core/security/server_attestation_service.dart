import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' show sha256, Hmac;
import 'package:shellvault/core/crypto/crypto_utils.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/services/logging_service.dart';

/// Verifies that the server is the expected ShellVault backend.
///
/// The server provides a signed attestation containing its identity,
/// timestamp, and API version. The client verifies this attestation
/// using a shared trust anchor (HMAC-SHA256 with a known key).
///
/// This prevents connecting to rogue servers that may try to intercept
/// or modify sync data.
class ServerAttestationService {
  static final _log = LoggingService.instance;
  static const _tag = 'Attest';

  /// Maximum allowed clock skew between client and server (seconds).
  static const int maxClockSkewSeconds = 300;

  /// Minimum API version the client supports.
  static const int minApiVersion = 1;

  /// Expected server identity string.
  final String _expectedServerId;

  /// HMAC key for verifying attestation signatures.
  final Uint8List _hmacKey;

  ServerAttestationService({
    required String expectedServerId,
    required Uint8List hmacKey,
  }) : _expectedServerId = expectedServerId,
       _hmacKey = hmacKey;

  /// Verify a server attestation response.
  ///
  /// The attestation [json] should contain:
  /// - `server_id`: Server identity string
  /// - `timestamp`: ISO-8601 UTC timestamp
  /// - `api_version`: Integer API version
  /// - `nonce`: Client-provided nonce (for replay protection)
  /// - `signature`: HMAC-SHA256 of the canonical payload
  Result<ServerAttestation> verify(
    Map<String, dynamic> json, {
    String? expectedNonce,
  }) {
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
            'The server is not the expected ShellVault backend.',
          ),
        );
      }

      // 2. Verify timestamp (clock skew check)
      final now = DateTime.now().toUtc();
      final skew = now.difference(attestation.timestamp).inSeconds.abs();
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
      if (expectedNonce == null) {
        _log.warning(
          _tag,
          'No expected nonce provided — replay protection disabled',
        );
      }
      if (expectedNonce != null && attestation.nonce != expectedNonce) {
        _log.error(_tag, 'Attestation nonce mismatch (possible replay attack)');
        return const Err(
          NetworkFailure(
            'Server attestation nonce mismatch (replay detected).',
          ),
        );
      }

      // 5. Verify HMAC signature
      final canonical = _buildCanonicalPayload(attestation);
      final expectedSignature = _computeHmac(canonical);

      // Constant-time comparison to prevent timing side-channel
      final sigBytes = utf8.encode(attestation.signature);
      final expectedBytes = utf8.encode(expectedSignature);
      final sigMatch =
          sigBytes.length == expectedBytes.length &&
          CryptoUtils.constantTimeEquals(sigBytes, expectedBytes);
      if (!sigMatch) {
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

  /// Build canonical payload for HMAC verification.
  ///
  /// Format: "server_id|timestamp_iso|api_version|nonce"
  String _buildCanonicalPayload(ServerAttestation attestation) {
    return '${attestation.serverId}'
        '|${attestation.timestamp.toIso8601String()}'
        '|${attestation.apiVersion}'
        '|${attestation.nonce}';
  }

  /// Compute HMAC-SHA256 of a payload.
  String _computeHmac(String payload) {
    final hmac = Hmac(sha256, _hmacKey);
    final digest = hmac.convert(utf8.encode(payload));
    return base64Encode(digest.bytes);
  }
}

/// Parsed server attestation data.
class ServerAttestation {
  final String serverId;
  final DateTime timestamp;
  final int apiVersion;
  final String nonce;
  final String signature;

  const ServerAttestation({
    required this.serverId,
    required this.timestamp,
    required this.apiVersion,
    required this.nonce,
    required this.signature,
  });

  factory ServerAttestation.fromJson(Map<String, dynamic> json) {
    return ServerAttestation(
      serverId: json['server_id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      apiVersion: json['api_version'] as int,
      nonce: json['nonce'] as String,
      signature: json['signature'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'server_id': serverId,
    'timestamp': timestamp.toIso8601String(),
    'api_version': apiVersion,
    'nonce': nonce,
    'signature': signature,
  };
}
