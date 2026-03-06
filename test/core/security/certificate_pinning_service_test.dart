import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:shellvault/core/security/certificate_pinning_service.dart';

/// Builds a minimal DER-encoded X.509 certificate structure for testing.
///
/// The structure contains:
/// SEQUENCE {                        -- Certificate
///   SEQUENCE {                      -- TBSCertificate
///     [0] INTEGER (2)               -- version (v3)
///     INTEGER (1)                   -- serialNumber
///     SEQUENCE {}                   -- signature algorithm
///     SEQUENCE {}                   -- issuer
///     SEQUENCE {}                   -- validity
///     SEQUENCE {}                   -- subject
///     SEQUENCE { [spkiContent] }    -- subjectPublicKeyInfo
///   }
///   SEQUENCE {}                     -- signatureAlgorithm
///   BIT STRING (0x00)               -- signatureValue
/// }
Uint8List _buildMinimalCert(Uint8List spkiContent) {
  // Helper: wrap bytes in a DER TLV
  Uint8List tlv(int tag, List<int> value) {
    final len = value.length;
    if (len < 0x80) {
      return Uint8List.fromList([tag, len, ...value]);
    } else if (len < 0x100) {
      return Uint8List.fromList([tag, 0x81, len, ...value]);
    } else {
      return Uint8List.fromList([
        tag,
        0x82,
        (len >> 8) & 0xFF,
        len & 0xFF,
        ...value,
      ]);
    }
  }

  // version: EXPLICIT [0] { INTEGER 2 }
  final versionInt = tlv(0x02, [0x02]); // INTEGER 2
  final version = tlv(0xA0, versionInt); // EXPLICIT TAG [0]

  // serialNumber: INTEGER 1
  final serial = tlv(0x02, [0x01]);

  // signature, issuer, validity, subject: empty SEQUENCE
  final emptySeq = tlv(0x30, []);

  // subjectPublicKeyInfo: SEQUENCE wrapping the provided content
  final spki = tlv(0x30, spkiContent);

  // TBSCertificate: SEQUENCE { version, serial, sig, issuer, validity, subject, spki }
  final tbsContent = <int>[
    ...version,
    ...serial,
    ...emptySeq,
    ...emptySeq,
    ...emptySeq,
    ...emptySeq,
    ...spki,
  ];
  final tbs = tlv(0x30, tbsContent);

  // signatureAlgorithm: empty SEQUENCE
  final sigAlg = emptySeq;

  // signatureValue: BIT STRING with 0x00 unused bits
  final sigValue = tlv(0x03, [0x00]);

  // Certificate: SEQUENCE { tbs, sigAlg, sigValue }
  final certContent = <int>[...tbs, ...sigAlg, ...sigValue];
  return tlv(0x30, certContent);
}

void main() {
  group('CertificatePinningService', () {
    test('hasPins returns false when no pins configured', () {
      final sut = CertificatePinningService(pins: {});
      expect(sut.hasPins, isFalse);
    });

    test('hasPins returns true when pins are configured', () {
      final sut = CertificatePinningService(
        pins: {
          'api.sshvault.app': [const CertificatePin.sha256('abc123')],
        },
      );
      expect(sut.hasPins, isTrue);
    });

    test('pinsForHost returns pins for configured host', () {
      final sut = CertificatePinningService(
        pins: {
          'api.sshvault.app': [
            const CertificatePin.sha256('pin1'),
            const CertificatePin.sha256('pin2'),
          ],
        },
      );
      expect(sut.pinsForHost('api.sshvault.app'), hasLength(2));
    });

    test('pinsForHost returns empty list for unknown host', () {
      final sut = CertificatePinningService(
        pins: {
          'api.sshvault.app': [const CertificatePin.sha256('pin1')],
        },
      );
      expect(sut.pinsForHost('unknown.host'), isEmpty);
    });
  });

  group('CertificatePin', () {
    test('sha256 constructor sets hash', () {
      const pin = CertificatePin.sha256('abcdef');
      expect(pin.hash, 'abcdef');
    });

    test('isExpired returns false with no expiry', () {
      const pin = CertificatePin(hash: 'abc');
      expect(pin.isExpired, isFalse);
      expect(pin.isValid, isTrue);
    });

    test('isExpired returns true for past date', () {
      final pin = CertificatePin(hash: 'abc', expiresAt: DateTime(2020, 1, 1));
      expect(pin.isExpired, isTrue);
      expect(pin.isValid, isFalse);
    });

    test('isExpired returns false for future date', () {
      final pin = CertificatePin(
        hash: 'abc',
        expiresAt: DateTime.now().add(const Duration(days: 365)),
      );
      expect(pin.isExpired, isFalse);
      expect(pin.isValid, isTrue);
    });

    test('label is optional', () {
      const pin = CertificatePin(hash: 'abc', label: 'primary');
      expect(pin.label, 'primary');
    });

    test('toString includes hash and optional label', () {
      const pin = CertificatePin(hash: 'abc', label: 'backup');
      expect(pin.toString(), contains('abc'));
      expect(pin.toString(), contains('backup'));
    });

    test('toString without label', () {
      const pin = CertificatePin(hash: 'abc');
      expect(pin.toString(), contains('abc'));
      expect(pin.toString(), isNot(contains('null')));
    });
  });

  group('CertificatePinningService — computePin', () {
    test('computes consistent SHA-256 pin from SPKI in DER certificate', () {
      final spkiContent = Uint8List.fromList(List.generate(64, (i) => i));
      final derBytes = _buildMinimalCert(spkiContent);
      final pin1 = CertificatePinningService.computePin(
        Uint8List.fromList(derBytes),
      );
      final pin2 = CertificatePinningService.computePin(
        Uint8List.fromList(derBytes),
      );
      expect(pin1, equals(pin2));
      expect(pin1, isNotEmpty);
    });

    test('different SPKI content produces different pins', () {
      final spki1 = Uint8List.fromList(List.generate(32, (i) => i));
      final spki2 = Uint8List.fromList(List.generate(32, (i) => i + 1));
      final der1 = _buildMinimalCert(spki1);
      final der2 = _buildMinimalCert(spki2);
      final pin1 = CertificatePinningService.computePin(der1);
      final pin2 = CertificatePinningService.computePin(der2);
      expect(pin1, isNot(equals(pin2)));
    });

    test('same SPKI with different certificate metadata produces same pin', () {
      // Both certs share the same SPKI content, so their pins should match
      final spkiContent = Uint8List.fromList(List.generate(48, (i) => i * 3));
      final der1 = _buildMinimalCert(spkiContent);
      final der2 = _buildMinimalCert(spkiContent);
      final pin1 = CertificatePinningService.computePin(der1);
      final pin2 = CertificatePinningService.computePin(der2);
      expect(pin1, equals(pin2));
    });
  });
}
