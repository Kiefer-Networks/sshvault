import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:shellvault/core/security/certificate_pinning_service.dart';

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
    test('computes consistent SHA-256 pin from DER bytes', () {
      final derBytes = Uint8List.fromList(List.generate(256, (i) => i % 256));
      final pin1 = CertificatePinningService.computePin(
        Uint8List.fromList(derBytes),
      );
      final pin2 = CertificatePinningService.computePin(
        Uint8List.fromList(derBytes),
      );
      expect(pin1, equals(pin2));
      expect(pin1, isNotEmpty);
    });

    test('different DER bytes produce different pins', () {
      final der1 = Uint8List.fromList(List.generate(32, (i) => i));
      final der2 = Uint8List.fromList(List.generate(32, (i) => i + 1));
      final pin1 = CertificatePinningService.computePin(der1);
      final pin2 = CertificatePinningService.computePin(der2);
      expect(pin1, isNot(equals(pin2)));
    });
  });
}
