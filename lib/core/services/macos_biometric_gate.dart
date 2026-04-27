// Touch ID / Face ID pre-unlock gate for the Apple (macOS + iOS) Keychain
// backend.
//
// The vault decrypts in many small bursts (one per Keychain read). Surfacing
// the LAContext prompt for every read would be hostile UX, so this gate:
//
//   * Wraps `local_auth` (already a project dependency) and surfaces a
//     biometrics-only authentication prompt. The plugin's iOS implementation
//     routes through `LAContext` exactly like macOS, with the same Dart API
//     surface — so a single gate covers both.
//   * Caches a successful authentication for a short, configurable TTL so
//     subsequent reads inside the same burst pass through silently.
//   * Maps the platform exception codes to typed [Failure] variants the
//     repository layer can switch on (cancel / lockout / unavailable / other).
//   * On non-Apple hosts is a transparent pass-through — Linux uses libsecret
//     and Windows uses DPAPI, neither of which need this prompt. Keeping the
//     gate cross-platform avoids `Platform.isMacOS || Platform.isIOS` guards
//     at every call site.
//
// The class name keeps the historical "Macos" prefix because external
// consumers (tests, providers) reference it; the predicate now activates on
// iOS as well via [Platform.isIOS]. Visible Face ID prompt copy lives in
// `ios/Runner/Info.plist` under `NSFaceIDUsageDescription`.
//
// Tested in `test/core/services/macos_biometric_gate_test.dart`.

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/error/result.dart';

/// Sentinel "no payload" type for [Result] — keeps the gate's success channel
/// expressive without leaking `void` (which can't flow through `Result.map`).
class Unit {
  const Unit._();
  static const Unit instance = Unit._();
}

/// Default reason string shown in the system biometric prompt.
const String kDefaultBiometricReason = 'Unlock SSHVault vault';

/// Default TTL for a successful authentication. Long enough to cover a
/// Keychain burst (vault decrypt typically reads ~10 entries back-to-back),
/// short enough that a left-unattended laptop re-prompts quickly.
const Duration kDefaultBiometricCacheTtl = Duration(seconds: 60);

/// Thin wrapper around [LocalAuthentication] that adds a short-lived success
/// cache and maps platform errors to typed [Failure] variants.
///
/// The gate is intentionally stateless across the public API surface — the
/// only mutable state is the cached "last successful authentication"
/// timestamp, which is invalidated by [invalidateCache] on logout / vault
/// lock.
class MacosBiometricGate {
  MacosBiometricGate({
    LocalAuthentication? auth,
    Duration cacheTtl = kDefaultBiometricCacheTtl,
    DateTime Function()? clock,
    @visibleForTesting bool? isMacOsOverride,
  }) : _auth = auth ?? LocalAuthentication(),
       _cacheTtl = cacheTtl,
       _clock = clock ?? DateTime.now,
       _isMacOsOverride = isMacOsOverride;

  final LocalAuthentication _auth;
  final Duration _cacheTtl;
  final DateTime Function() _clock;
  final bool? _isMacOsOverride;

  DateTime? _lastSuccess;

  /// True when this gate should actually prompt — Apple platforms (macOS +
  /// iOS) engage the LAContext flow; everything else passes through as
  /// success. The override hook keeps the historical name (`isMacOsOverride`)
  /// for back-compat with the existing test fixtures, but it now toggles
  /// the full Apple branch.
  bool get _isApple {
    if (_isMacOsOverride != null) return _isMacOsOverride;
    if (kIsWeb) return false;
    final tp = defaultTargetPlatform;
    return (tp == TargetPlatform.macOS && Platform.isMacOS) ||
        (tp == TargetPlatform.iOS && Platform.isIOS);
  }

  /// Whether a previously cached success is still valid at [now].
  bool _isCached(DateTime now) {
    final last = _lastSuccess;
    if (last == null) return false;
    return now.difference(last) < _cacheTtl;
  }

  /// Drops the cached success — call on logout, vault lock, or any other
  /// trust boundary crossing where re-prompt is desired.
  void invalidateCache() {
    _lastSuccess = null;
  }

  /// Surfaces the biometric prompt and returns a typed [Result].
  ///
  /// Maps to the following error variants:
  ///
  ///   * [AuthFailure] for user-cancel and fallback selection (recoverable;
  ///     callers usually display a "Try again" affordance).
  ///   * [SecurityViolation] for biometric lockout (too many failed attempts
  ///     or hardware lockout) — callers should refuse to proceed and prompt
  ///     for the master password instead.
  ///   * [AuthFailure] with descriptive message for "no biometrics enrolled"
  ///     and "no hardware" — distinct enough that the UI layer can route
  ///     them to setup help.
  Future<Result<Unit>> authenticate({
    String reason = kDefaultBiometricReason,
  }) async {
    // Non-Apple pass-through: libsecret / DPAPI / Android Keystore handle
    // their own gating elsewhere.
    if (!_isApple) return const Success(Unit.instance);

    // Cache hit: skip the prompt entirely. We do NOT bump the timestamp on
    // hit — that would let a long-running session refresh indefinitely.
    if (_isCached(_clock())) return const Success(Unit.instance);

    try {
      final ok = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
      );
      if (!ok) {
        // local_auth 3.x returns false only for "user failed silently"
        // (e.g. wrong finger N times under the threshold). Treat as cancel.
        return const Err(AuthFailure('Biometric authentication declined'));
      }
      _lastSuccess = _clock();
      return const Success(Unit.instance);
    } on LocalAuthException catch (e) {
      return Err(_mapException(e));
    } catch (e) {
      // Defensive fallback — local_auth should always raise LocalAuthException
      // but if a platform implementation leaks a PlatformException we still
      // want a typed failure rather than a crash at the call site.
      return Err(AuthFailure('Biometric authentication failed', cause: e));
    }
  }

  Failure _mapException(LocalAuthException e) {
    switch (e.code) {
      // User-driven cancellation — recoverable.
      case LocalAuthExceptionCode.userCanceled:
      case LocalAuthExceptionCode.systemCanceled:
      case LocalAuthExceptionCode.timeout:
      case LocalAuthExceptionCode.userRequestedFallback:
        return AuthFailure(
          e.description ?? 'Biometric prompt canceled',
          cause: e,
        );

      // Hard lockout — must escalate to master password.
      case LocalAuthExceptionCode.biometricLockout:
      case LocalAuthExceptionCode.temporaryLockout:
        return SecurityViolation(
          e.description ?? 'Biometric authentication locked out',
          cause: e,
        );

      // Hardware / enrollment problems — the caller should surface a setup
      // prompt rather than retrying blindly.
      case LocalAuthExceptionCode.noBiometricsEnrolled:
      case LocalAuthExceptionCode.noBiometricHardware:
      case LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable:
      case LocalAuthExceptionCode.noCredentialsSet:
      case LocalAuthExceptionCode.uiUnavailable:
        return AuthFailure(
          e.description ?? 'Biometric authentication unavailable',
          cause: e,
        );

      // Catch-all for unknown / device errors / in-progress collisions.
      // Adding new codes upstream is *not* a breaking change per the
      // platform interface docs, so this default branch is mandatory.
      case LocalAuthExceptionCode.authInProgress:
      case LocalAuthExceptionCode.deviceError:
      case LocalAuthExceptionCode.unknownError:
        return AuthFailure(
          e.description ?? 'Biometric authentication error',
          cause: e,
        );
    }
  }
}

/// Riverpod provider so callers can wrap their Keychain reads in a single
/// `ref.read(macosBiometricGateProvider).authenticate()` call.
final macosBiometricGateProvider = Provider<MacosBiometricGate>(
  (ref) => MacosBiometricGate(),
);
