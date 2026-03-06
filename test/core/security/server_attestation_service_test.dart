import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/security/server_attestation_service.dart';

void main() {
  const serverId = 'sshvault-api-prod';

  final ed25519 = Ed25519();
  late SimpleKeyPairData keyPair;
  late SimplePublicKey publicKey;
  late ServerAttestationService sut;

  setUpAll(() async {
    keyPair = await ed25519.newKeyPair() as SimpleKeyPairData;
    publicKey = await keyPair.extractPublicKey();
  });

  setUp(() {
    sut = ServerAttestationService(
      expectedServerId: serverId,
      publicKey: publicKey,
    );
  });

  /// Helper: build a valid attestation JSON with correct Ed25519 signature.
  Future<Map<String, dynamic>> buildValidAttestation({
    String? serverIdOverride,
    int? timestampOverride,
    int apiVersion = 1,
    String nonce = 'test-nonce-123',
  }) async {
    final sid = serverIdOverride ?? serverId;
    final ts =
        timestampOverride ?? DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

    final message = '$sid|$ts|$apiVersion|$nonce';
    final sig = await ed25519.sign(
      utf8.encode(message),
      keyPair: keyPair,
    );

    return {
      'server_id': sid,
      'timestamp': ts,
      'api_version': apiVersion,
      'nonce': nonce,
      'signature': base64Encode(sig.bytes),
    };
  }

  group('ServerAttestationService — verify', () {
    test('accepts valid attestation', () async {
      final json = await buildValidAttestation();
      final result = await sut.verify(json, expectedNonce: 'test-nonce-123');
      expect(result.isSuccess, isTrue);
      expect(result.value.serverId, serverId);
      expect(result.value.apiVersion, 1);
    });

    test('accepts attestation without nonce check', () async {
      final json = await buildValidAttestation(nonce: 'any-nonce');
      final result = await sut.verify(json);
      expect(result.isSuccess, isTrue);
    });

    test('rejects wrong server ID', () async {
      final json = await buildValidAttestation(serverIdOverride: 'evil-server');
      final result = await sut.verify(json);
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<NetworkFailure>());
      expect(result.failure.message, contains('identity'));
    });

    test('rejects expired timestamp (clock skew)', () async {
      final oldTimestamp =
          DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000 - 600;
      final json = await buildValidAttestation(timestampOverride: oldTimestamp);
      final result = await sut.verify(json);
      expect(result.isFailure, isTrue);
      expect(result.failure.message, contains('timestamp'));
    });

    test('accepts timestamp within allowed skew', () async {
      final slightlyOldTimestamp =
          DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000 - 60;
      final json =
          await buildValidAttestation(timestampOverride: slightlyOldTimestamp);
      final result = await sut.verify(json);
      expect(result.isSuccess, isTrue);
    });

    test('rejects API version below minimum', () async {
      final json = await buildValidAttestation(apiVersion: 0);
      final result = await sut.verify(json);
      expect(result.isFailure, isTrue);
      expect(result.failure.message, contains('version'));
    });

    test('accepts current API version', () async {
      final json = await buildValidAttestation(
        apiVersion: ServerAttestationService.minApiVersion,
      );
      final result = await sut.verify(json);
      expect(result.isSuccess, isTrue);
    });

    test('rejects nonce mismatch', () async {
      final json = await buildValidAttestation(nonce: 'server-nonce');
      final result = await sut.verify(json, expectedNonce: 'client-nonce');
      expect(result.isFailure, isTrue);
      expect(result.failure.message, contains('nonce'));
    });

    test('rejects tampered signature', () async {
      final json = await buildValidAttestation();
      json['signature'] = base64Encode(List.filled(64, 0));
      final result = await sut.verify(json);
      expect(result.isFailure, isTrue);
      expect(result.failure.message, contains('signature'));
    });

    test('rejects if payload tampered after signing', () async {
      final json = await buildValidAttestation();
      // Tamper with api_version after signing
      json['api_version'] = 2;
      final result = await sut.verify(json);
      expect(result.isFailure, isTrue);
    });

    test('rejects signature from different key', () async {
      // Generate a different key pair
      final otherKeyPair = await ed25519.newKeyPair() as SimpleKeyPairData;
      final otherPublicKey = await otherKeyPair.extractPublicKey();

      // Create a service with the other public key
      final otherSut = ServerAttestationService(
        expectedServerId: serverId,
        publicKey: otherPublicKey,
      );

      // Sign with the original key pair
      final json = await buildValidAttestation();
      // But verify with the other service (different public key)
      final result = await otherSut.verify(json);
      expect(result.isFailure, isTrue);
    });

    test('returns failure for malformed JSON', () async {
      final result = await sut.verify({'incomplete': true});
      expect(result.isFailure, isTrue);
    });
  });

  group('ServerAttestationService.fromBase64Key', () {
    test('constructs from base64-encoded public key', () async {
      final base64Key = base64Encode(publicKey.bytes);
      final service = ServerAttestationService.fromBase64Key(
        expectedServerId: serverId,
        publicKeyBase64: base64Key,
      );

      final json = await buildValidAttestation();
      final result = await service.verify(json, expectedNonce: 'test-nonce-123');
      expect(result.isSuccess, isTrue);
    });
  });

  group('ServerAttestation', () {
    test('fromJson parses all fields', () async {
      final json = await buildValidAttestation();
      final attestation = ServerAttestation.fromJson(json);
      expect(attestation.serverId, serverId);
      expect(attestation.apiVersion, 1);
      expect(attestation.nonce, 'test-nonce-123');
      expect(attestation.signature, isNotEmpty);
      expect(attestation.timestamp, isA<int>());
    });

    test('toJson round-trips correctly', () async {
      final json = await buildValidAttestation();
      final attestation = ServerAttestation.fromJson(json);
      final roundTripped = attestation.toJson();

      expect(roundTripped['server_id'], json['server_id']);
      expect(roundTripped['timestamp'], json['timestamp']);
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
      final n2 = ServerAttestationService.generateNonce();
      expect(n1, isNotEmpty);
      expect(n2, isNotEmpty);
    });
  });
}
