import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' show sha256;
import 'package:shellvault/core/crypto/crypto_utils.dart';
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

  CertificatePinningService({required Map<String, List<CertificatePin>> pins})
    : _pins = Map.unmodifiable(pins);

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

    // Filter out expired pins
    final validPins = hostPins.where((p) => p.isValid).toList();
    if (validPins.isEmpty) {
      _log.error(
        _tag,
        'All ${hostPins.length} pin(s) for $hostname have expired',
      );
      return const Err(
        NetworkFailure(
          'All certificate pins have expired. App update required.',
        ),
      );
    }

    final certHash = _computeSha256(certificate.der);
    for (final pin in validPins) {
      // Constant-time comparison for defense-in-depth
      if (CryptoUtils.constantTimeStringEquals(pin.hash, certHash)) {
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
      final result = validateCertificate(cert, host);
      if (!result.isSuccess) {
        _log.error(
          _tag,
          'Rejecting certificate for $host:$port — pin validation failed',
        );
      }
      return result.isSuccess;
    };
    return client;
  }

  /// Compute SHA-256 hash of the SubjectPublicKeyInfo (SPKI) from a
  /// DER-encoded X.509 certificate.
  static String _computeSha256(Uint8List derBytes) {
    final spki = _extractSpki(derBytes);
    final digest = sha256.convert(spki);
    return base64Encode(digest.bytes);
  }

  /// Compute SHA-256 pin from DER-encoded certificate bytes.
  ///
  /// Extracts the SubjectPublicKeyInfo (SPKI) and hashes only that,
  /// matching the standard RFC 7469 public key pinning approach.
  static String computePin(Uint8List derBytes) {
    return _computeSha256(derBytes);
  }

  /// Extracts the SubjectPublicKeyInfo from a DER-encoded X.509 certificate.
  ///
  /// X.509 structure: SEQUENCE { tbsCertificate, signatureAlgorithm, signature }
  /// tbsCertificate: SEQUENCE { version, serialNumber, signature, issuer,
  ///                            validity, subject, subjectPublicKeyInfo, ... }
  static Uint8List _extractSpki(Uint8List der) {
    // Parse outer SEQUENCE (Certificate)
    final outer = _parseSequence(der, 0);
    // Parse TBSCertificate (first element of outer SEQUENCE)
    final tbs = _parseSequence(der, outer.contentOffset);

    // Navigate through TBSCertificate fields:
    var offset = tbs.contentOffset;

    // 1. version (EXPLICIT TAG [0], optional — present in v2/v3 certs)
    if (der[offset] == 0xA0) {
      offset = _skipTlv(der, offset);
    }
    // 2. serialNumber (INTEGER)
    offset = _skipTlv(der, offset);
    // 3. signature algorithm (SEQUENCE)
    offset = _skipTlv(der, offset);
    // 4. issuer (SEQUENCE)
    offset = _skipTlv(der, offset);
    // 5. validity (SEQUENCE)
    offset = _skipTlv(der, offset);
    // 6. subject (SEQUENCE)
    offset = _skipTlv(der, offset);
    // 7. subjectPublicKeyInfo (SEQUENCE) — extract this
    final spki = _readTlv(der, offset);
    return Uint8List.fromList(der.sublist(offset, offset + spki.totalLength));
  }

  /// Parses a SEQUENCE tag at [offset] and returns content info.
  static _TlvInfo _parseSequence(Uint8List der, int offset) {
    if (der[offset] != 0x30) {
      throw FormatException(
        'Expected SEQUENCE tag (0x30) at offset $offset, got 0x${der[offset].toRadixString(16)}',
      );
    }
    return _readTlv(der, offset);
  }

  /// Reads TLV (tag-length-value) at [offset] and returns the total
  /// length and content offset.
  static _TlvInfo _readTlv(Uint8List der, int offset) {
    final tag = der[offset];
    var lengthOffset = offset + 1;
    int length;
    int headerLength;

    final firstByte = der[lengthOffset];
    if (firstByte < 0x80) {
      // Short form: length is single byte
      length = firstByte;
      headerLength = 2;
    } else {
      // Long form: first byte indicates number of length bytes
      final numLengthBytes = firstByte & 0x7F;
      length = 0;
      for (var i = 0; i < numLengthBytes; i++) {
        length = (length << 8) | der[lengthOffset + 1 + i];
      }
      headerLength = 2 + numLengthBytes;
    }

    return _TlvInfo(
      tag: tag,
      contentOffset: offset + headerLength,
      contentLength: length,
      totalLength: headerLength + length,
    );
  }

  /// Skips the TLV at [offset] and returns the offset of the next element.
  static int _skipTlv(Uint8List der, int offset) {
    final info = _readTlv(der, offset);
    return offset + info.totalLength;
  }
}

/// Internal helper for ASN.1 TLV parsing results.
class _TlvInfo {
  final int tag;
  final int contentOffset;
  final int contentLength;
  final int totalLength;

  const _TlvInfo({
    required this.tag,
    required this.contentOffset,
    required this.contentLength,
    required this.totalLength,
  });
}

/// A certificate pin with its SHA-256 hash and optional metadata.
class CertificatePin {
  /// Base64-encoded SHA-256 hash of the Subject Public Key Info (SPKI).
  final String hash;

  /// Optional label for this pin (e.g. "primary", "backup").
  final String? label;

  /// Expiry date — after this date, the pin is ignored.
  final DateTime? expiresAt;

  const CertificatePin({required this.hash, this.label, this.expiresAt});

  /// Creates a pin from a base64-encoded SHA-256 hash string.
  const CertificatePin.sha256(this.hash, {this.label, this.expiresAt});

  /// Whether this pin has expired.
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  /// Whether this pin is currently valid.
  bool get isValid => !isExpired;

  @override
  String toString() =>
      'CertificatePin($hash${label != null ? ", $label" : ""})';
}
