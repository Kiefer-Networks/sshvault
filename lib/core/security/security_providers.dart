import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/network/api_provider.dart';
import 'package:sshvault/core/security/doh_resolver_service.dart';
import 'package:sshvault/core/security/heartbeat_service.dart';
import 'package:sshvault/core/security/server_attestation_service.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/features/auth/presentation/providers/auth_providers.dart';

// ---------------------------------------------------------------------------
// DNS-over-HTTPS
// ---------------------------------------------------------------------------

/// Provides a [DohResolverService] instance for secure DNS resolution.
final dohResolverProvider = Provider<DohResolverService>((ref) {
  final service = DohResolverService(
    providers: [DohProvider.quad9, DohProvider.cloudflare],
  );
  ref.onDispose(service.close);
  return service;
});

// ---------------------------------------------------------------------------
// Server Attestation
// ---------------------------------------------------------------------------

/// Result of an attestation check.
enum AttestationStatus {
  /// Attestation passed or skipped (not authenticated).
  passed,

  /// Attestation signature or identity verification failed.
  failed,

  /// The server's attestation public key has changed since it was first
  /// pinned (TOFU). This may indicate a MITM attack.
  keyChanged,
}

/// Performs a background attestation check after the user authenticates.
///
/// Resolves the attestation public key via Trust-On-First-Use (TOFU):
/// fetches the key from `/v1/attestation/pubkey` on first connect and pins
/// it in secure storage. Subsequent connections verify against the pinned key.
///
/// If the server's public key changes after initial pinning, returns
/// [AttestationStatus.keyChanged] (critical security event).
final attestationCheckProvider = FutureProvider.autoDispose<AttestationStatus>((
  ref,
) async {
  final log = LoggingService.instance;
  const tag = 'Attest';

  final authAsync = ref.watch(authProvider);
  if (authAsync.isLoading || authAsync.value != AuthStatus.authenticated) {
    return AttestationStatus.passed;
  }

  final serverUrl = ref.read(serverUrlProvider);
  final apiClient = ref.read(apiClientProvider);
  final storage = ref.read(secureStorageProvider);

  try {
    // --- Step 1: Resolve the attestation public key ---
    String? publicKeyBase64;

    // Check for a stored (pinned) key for this server.
    final storedKeyResult = await storage.getAttestationKey(serverUrl);
    final storedKey = storedKeyResult.isSuccess ? storedKeyResult.value : null;

    if (storedKey != null) {
      publicKeyBase64 = storedKey;
      log.debug(
        tag,
        'Using pinned attestation key for ${Uri.parse(serverUrl).host}',
      );
    } else {
      // First connection: TOFU — fetch and pin the key.
      final pubKeyResult = await apiClient.get('/v1/attestation/pubkey');
      if (pubKeyResult.isFailure) {
        log.warning(
          tag,
          'Cannot fetch attestation public key: ${pubKeyResult.failure}. '
          'Skipping attestation for first connection.',
        );
        return AttestationStatus.passed;
      }
      final fetchedKey = pubKeyResult.value['public_key'] as String?;
      if (fetchedKey == null || fetchedKey.isEmpty) {
        log.warning(tag, 'Server returned empty attestation public key');
        return AttestationStatus.failed;
      }
      publicKeyBase64 = fetchedKey;
      await storage.saveAttestationKey(serverUrl, publicKeyBase64);
      log.info(
        tag,
        'TOFU: pinned attestation key for ${Uri.parse(serverUrl).host}',
      );
    }

    // --- Step 2: Verify attestation with the resolved key ---
    final attestation = ServerAttestationService.fromBase64Key(
      expectedServerId: AppConstants.expectedServerId,
      publicKeyBase64: publicKeyBase64,
    );

    final nonce = ServerAttestationService.generateNonce();
    final result = await apiClient.get(
      '/v1/attestation',
      queryParameters: {'nonce': nonce},
    );

    if (result.isFailure) {
      log.warning(
        tag,
        'Attestation endpoint unreachable: ${result.failure}. '
        'Rejecting — a MITM could be blocking the attestation endpoint.',
      );
      return AttestationStatus.failed;
    }

    final verification = await attestation.verify(
      result.value,
      expectedNonce: nonce,
    );

    if (verification.isSuccess) {
      log.info(tag, 'Server attestation passed');
      return AttestationStatus.passed;
    }

    // --- Step 3: Verification failed — check if key changed ---
    log.error(tag, 'Server attestation FAILED: ${verification.failure}');

    final pubKeyResult = await apiClient.get('/v1/attestation/pubkey');
    if (pubKeyResult.isSuccess) {
      final currentKey = pubKeyResult.value['public_key'] as String?;
      if (currentKey != null && currentKey != publicKeyBase64) {
        log.error(
          tag,
          'ATTESTATION KEY CHANGED! '
          'Stored: ${publicKeyBase64.substring(0, 8)}..., '
          'Server: ${currentKey.substring(0, 8)}...',
        );
        return AttestationStatus.keyChanged;
      }
    }

    return AttestationStatus.failed;
  } catch (e) {
    log.error(tag, 'Attestation check threw: $e');
    return AttestationStatus.failed;
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
