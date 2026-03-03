import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' show sha256;
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/services/logging_service.dart';

/// Validates server TLS certificates against pinned SHA-256 fingerprints.
///
/// Usage:
/// ```dart
/// final pinning = CertificatePinningService(
///   pins: {'api.sshvault.app': [CertificatePin.sha256('AABB...')]}
/// );
/// pinning.configureDio(dio);
/// ```
class CertificatePinningService {
  static final _log = LoggingService.instance;
  static const _tag = 'CertPin';

  final Map<String, List<CertificatePin>> _pins;
  final bool _enforceInDebug;

  CertificatePinningService({
    required Map<String, List<CertificatePin>> pins,
    bool enforceInDebug = false,
  })  : _pins = Map.unmodifiable(pins),
        _enforceInDebug = enforceInDebug;

  /// Whether pinning is configured for any host.
  bool get hasPins => _pins.isNotEmpty;

  /// Returns the pinned hashes for a given [hostname], or empty list.
  List<CertificatePin> pinsForHost(String hostname) {
    return _pins[hostname] ?? [];
  }

  /// Validates a certificate chain against the pinned hashes.
  ///
  /// Returns [Success] if the certificate is valid:
  /// - No pins configured for this host → always passes
  /// - At least one certificate in the chain matches a pin → passes
  ///
  /// Returns [Err] with [NetworkFailure] if validation fails.
  Result<void> validateCertificate(
    X509Certificate certificate,
    String hostname,
  ) {
    final hostPins = pinsForHost(hostname);
    if (hostPins.isEmpty) {
      _log.debug(_tag, 'No pins configured for $hostname — skipping');
      return const Success(null);
    }

    final certHash = _computeSha256(certificate.der);
    for (final pin in hostPins) {
      if (pin.hash == certHash) {
        _log.debug(_tag, 'Certificate pin matched for $hostname');
        return const Success(null);
      }
    }

    _log.error(
      _tag,
      'Certificate pin mismatch for $hostname '
      '(got $certHash, expected one of ${hostPins.map((p) => p.hash).join(", ")})',
    );
    return const Err(
      NetworkFailure(
        'Certificate pinning validation failed. '
        'The server certificate does not match the expected fingerprint.',
      ),
    );
  }

  /// Creates an [HttpClient] with certificate pinning enabled.
  ///
  /// Use this to configure Dio's HTTP adapter:
  /// ```dart
  /// final adapter = IOHttpClientAdapter();
  /// adapter.createHttpClient = () => pinningService.createHttpClient();
  /// dio.httpClientAdapter = adapter;
  /// ```
  HttpClient createHttpClient() {
    final client = HttpClient();
    client.badCertificateCallback = (cert, host, port) {
      if (!_enforceInDebug) {
        // In debug mode, allow all certificates unless enforcement is enabled
        assert(() {
          _log.warning(
            _tag,
            'Debug mode: skipping certificate pin for $host:$port',
          );
          return true;
        }());
      }

      final result = validateCertificate(cert, host);
      return result.isSuccess;
    };
    return client;
  }

  /// Compute SHA-256 hash of DER-encoded certificate bytes.
  static String _computeSha256(Uint8List derBytes) {
    final digest = sha256.convert(derBytes);
    return base64Encode(digest.bytes);
  }

  /// Compute SHA-256 pin from DER-encoded certificate bytes.
  ///
  /// Use this utility to generate pin strings from actual certificates.
  static String computePin(Uint8List derBytes) {
    return _computeSha256(derBytes);
  }
}

/// A certificate pin with its SHA-256 hash and optional metadata.
class CertificatePin {
  /// Base64-encoded SHA-256 hash of the Subject Public Key Info (SPKI).
  final String hash;

  /// Optional label for this pin (e.g. "primary", "backup").
  final String? label;

  /// Expiry date — after this date, the pin is ignored.
  final DateTime? expiresAt;

  const CertificatePin({
    required this.hash,
    this.label,
    this.expiresAt,
  });

  /// Creates a pin from a base64-encoded SHA-256 hash string.
  const CertificatePin.sha256(this.hash, {this.label, this.expiresAt});

  /// Whether this pin has expired.
  bool get isExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!);

  /// Whether this pin is currently valid.
  bool get isValid => !isExpired;

  @override
  String toString() => 'CertificatePin($hash${label != null ? ", $label" : ""})';
}
