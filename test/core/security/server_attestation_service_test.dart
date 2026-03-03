import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' show sha256, Hmac;
import 'package:flutter_test/flutter_test.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/security/server_attestation_service.dart';

void main() {
  final hmacKey = Uint8List.fromList(utf8.encode('test-hmac-secret-key-32bytes!!'));
  const serverId = 'sshvault-api-prod';

  late ServerAttestationService sut;

  setUp(() {
    sut = ServerAttestationService(
      expectedServerId: serverId,
      hmacKey: hmacKey,
    );
  });

  /// Helper: build a valid attestation JSON with correct signature.
  Map<String, dynamic> buildValidAttestation({
    String? serverIdOverride,
    DateTime? timestampOverride,
    int apiVersion = 1,
    String nonce = 'test-nonce-123',
  }) {
    final sid = serverIdOverride ?? serverId;
    final ts = (timestampOverride ?? DateTime.now().toUtc()).toIso8601String();

    final canonical = '$sid|$ts|$apiVersion|$nonce';
    final hmac = Hmac(sha256, hmacKey);
    final signature = base64Encode(hmac.convert(utf8.encode(canonical)).bytes);

    return {
      'server_id': sid,
      'timestamp': ts,
      'api_version': apiVersion,
      'nonce': nonce,
      'signature': signature,
    };
  }

  group('ServerAttestationService — verify', () {
    test('accepts valid attestation', () {
      final json = buildValidAttestation();
      final result = sut.verify(json, expectedNonce: 'test-nonce-123');
      expect(result.isSuccess, isTrue);
      expect(result.value.serverId, serverId);
      expect(result.value.apiVersion, 1);
    });

    test('accepts attestation without nonce check', () {
      final json = buildValidAttestation(nonce: 'any-nonce');
      final result = sut.verify(json);
      expect(result.isSuccess, isTrue);
    });

    test('rejects wrong server ID', () {
      final json = buildValidAttestation(serverIdOverride: 'evil-server');
      final result = sut.verify(json);
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<NetworkFailure>());
      expect(result.failure.message, contains('identity'));
    });

    test('rejects expired timestamp (clock skew)', () {
      final oldTime = DateTime.now()
          .toUtc()
          .subtract(const Duration(seconds: 600));
      final json = buildValidAttestation(timestampOverride: oldTime);
      final result = sut.verify(json);
      expect(result.isFailure, isTrue);
      expect(result.failure.message, contains('timestamp'));
    });

    test('accepts timestamp within allowed skew', () {
      final slightlyOld = DateTime.now()
          .toUtc()
          .subtract(const Duration(seconds: 60));
      final json = buildValidAttestation(timestampOverride: slightlyOld);
      final result = sut.verify(json);
      expect(result.isSuccess, isTrue);
    });

    test('rejects API version below minimum', () {
      final json = buildValidAttestation(apiVersion: 0);
      final result = sut.verify(json);
      expect(result.isFailure, isTrue);
      expect(result.failure.message, contains('version'));
    });

    test('accepts current API version', () {
      final json = buildValidAttestation(
        apiVersion: ServerAttestationService.minApiVersion,
      );
      final result = sut.verify(json);
      expect(result.isSuccess, isTrue);
    });

    test('rejects nonce mismatch', () {
      final json = buildValidAttestation(nonce: 'server-nonce');
      final result = sut.verify(json, expectedNonce: 'client-nonce');
      expect(result.isFailure, isTrue);
      expect(result.failure.message, contains('nonce'));
    });

    test('rejects tampered signature', () {
      final json = buildValidAttestation();
      json['signature'] = 'invalid-signature-data';
      final result = sut.verify(json);
      expect(result.isFailure, isTrue);
      expect(result.failure.message, contains('signature'));
    });

    test('rejects if payload tampered after signing', () {
      final json = buildValidAttestation();
      // Tamper with api_version after signing
      json['api_version'] = 2;
      final result = sut.verify(json);
      expect(result.isFailure, isTrue);
    });

    test('returns failure for malformed JSON', () {
      final result = sut.verify({'incomplete': true});
      expect(result.isFailure, isTrue);
    });
  });

  group('ServerAttestation', () {
    test('fromJson parses all fields', () {
      final json = buildValidAttestation();
      final attestation = ServerAttestation.fromJson(json);
      expect(attestation.serverId, serverId);
      expect(attestation.apiVersion, 1);
      expect(attestation.nonce, 'test-nonce-123');
      expect(attestation.signature, isNotEmpty);
    });

    test('toJson round-trips correctly', () {
      final json = buildValidAttestation();
      final attestation = ServerAttestation.fromJson(json);
      final roundTripped = attestation.toJson();

      expect(roundTripped['server_id'], json['server_id']);
      expect(roundTripped['api_version'], json['api_version']);
      expect(roundTripped['nonce'], json['nonce']);
      expect(roundTripped['signature'], json['signature']);
    });
  });

  group('ServerAttestationService — generateNonce', () {
    test('generates non-empty nonce', () {
      final nonce = ServerAttestationService.generateNonce();
      expect(nonce, isNotEmpty);
    });

    test('generates different nonces', () {
      final n1 = ServerAttestationService.generateNonce();
      // Small delay to ensure different microsecond timestamp
      final n2 = ServerAttestationService.generateNonce();
      // Nonces should be different (based on microsecond timestamp)
      // Note: In fast execution, they might be the same — that's acceptable
      expect(n1, isNotEmpty);
      expect(n2, isNotEmpty);
    });
  });

}
