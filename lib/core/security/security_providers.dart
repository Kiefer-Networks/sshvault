import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/network/api_provider.dart';
import 'package:shellvault/core/security/certificate_pinning_service.dart';
import 'package:shellvault/core/security/doh_resolver_service.dart';
import 'package:shellvault/core/security/heartbeat_service.dart';
import 'package:shellvault/core/security/server_attestation_service.dart';
import 'package:shellvault/core/services/logging_service.dart';
import 'package:shellvault/features/auth/presentation/providers/auth_providers.dart';

// ---------------------------------------------------------------------------
// Certificate Pinning
// ---------------------------------------------------------------------------

/// Provides a [CertificatePinningService] configured with the SPKI pins
/// for the production API domain.
///
/// Returns `null` when pinning is disabled (self-hosted / development).
final certificatePinningProvider = Provider<CertificatePinningService?>((ref) {
  if (!AppConstants.enforceCertificatePinning) {
    LoggingService.instance.info(
      'Security',
      'Certificate pinning disabled by configuration',
    );
    return null;
  }

  final apiHost = Uri.parse(ref.watch(serverUrlProvider)).host;
  if (apiHost.isEmpty) return null;

  final pins = AppConstants.certificatePinHashes
      .map((h) => CertificatePin.sha256(h))
      .toList();

  return CertificatePinningService(pins: {apiHost: pins});
});

// ---------------------------------------------------------------------------
// DNS-over-HTTPS
// ---------------------------------------------------------------------------

/// Provides a [DohResolverService] instance for secure DNS resolution.
final dohResolverProvider = Provider<DohResolverService>((ref) {
  final service = DohResolverService();
  ref.onDispose(service.close);
  return service;
});

// ---------------------------------------------------------------------------
// Server Attestation
// ---------------------------------------------------------------------------

/// Provides a [ServerAttestationService] for verifying server identity.
final serverAttestationProvider = Provider<ServerAttestationService>((ref) {
  return ServerAttestationService.fromBase64Key(
    expectedServerId: AppConstants.expectedServerId,
    publicKeyBase64: AppConstants.attestationPublicKeyBase64,
  );
});

/// Performs a background attestation check after the user authenticates.
///
/// Returns `true` if attestation passed or was skipped, `false` if it failed.
/// Does not block the UI — callers should handle failure asynchronously.
final attestationCheckProvider = FutureProvider.autoDispose<bool>((ref) async {
  final log = LoggingService.instance;
  const tag = 'Attest';

  final authStatus = ref.watch(authProvider).value;
  if (authStatus != AuthStatus.authenticated) {
    return true; // Not authenticated, nothing to check
  }

  final apiClient = ref.read(apiClientProvider);
  final attestation = ref.read(serverAttestationProvider);

  try {
    final nonce = ServerAttestationService.generateNonce();
    final result = await apiClient.get(
      '/v1/attest',
      queryParameters: {'nonce': nonce},
    );

    if (result.isFailure) {
      log.warning(tag, 'Attestation endpoint unreachable: ${result.failure}');
      // Treat as soft failure — server may not support attestation yet
      return true;
    }

    final verification = await attestation.verify(
      result.value,
      expectedNonce: nonce,
    );
    if (verification.isFailure) {
      log.error(tag, 'Server attestation FAILED: ${verification.failure}');
      return false;
    }

    log.info(tag, 'Server attestation passed');
    return true;
  } catch (e) {
    log.error(tag, 'Attestation check threw: $e');
    return false;
  }
});

// ---------------------------------------------------------------------------
// Heartbeat
// ---------------------------------------------------------------------------

/// Manages the [HeartbeatService] lifecycle tied to authentication state.
///
/// Starts on authentication, stops on logout / unauthentication.
/// Fires [onSessionExpired] when max consecutive failures are reached.
final heartbeatProvider = Provider<HeartbeatService?>((ref) {
  final log = LoggingService.instance;
  const tag = 'Heartbeat';

  final authStatus = ref.watch(authProvider).value;
  if (authStatus != AuthStatus.authenticated) {
    return null;
  }

  final apiClient = ref.read(apiClientProvider);

  final heartbeat = HeartbeatService(
    apiClient: apiClient,
    interval: const Duration(seconds: AppConstants.heartbeatIntervalSeconds),
    maxFailures: AppConstants.heartbeatMaxFailures,
    onSessionExpired: () {
      log.error(tag, 'Heartbeat session expired — forcing logout');
      // Mark as heartbeat-triggered for the UI to show warning
      ref.read(heartbeatExpiredProvider.notifier).state = true;
      ref.read(authProvider.notifier).logout();
    },
  );

  heartbeat.start();
  ref.onDispose(heartbeat.stop);

  log.info(tag, 'Heartbeat service started for authenticated session');
  return heartbeat;
});

/// Tracks whether the most recent logout was caused by heartbeat failure.
/// The UI reads this to show the [SecurityWarningDialog].
final heartbeatExpiredProvider = StateProvider<bool>((ref) => false);

/// Tracks whether server attestation failed.
/// The UI reads this to show the [SecurityWarningDialog].
final attestationFailedProvider = StateProvider<bool>((ref) => false);
