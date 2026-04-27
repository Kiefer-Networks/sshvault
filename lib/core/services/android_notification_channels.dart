/// Centralised registry of Android notification channel ids used by
/// SSHVault.
///
/// The native channels themselves are registered once at startup from
/// `MainActivity.onCreate` (Kotlin side). `NotificationManager
/// .createNotificationChannel` is idempotent — calling it for an
/// existing id is a no-op — so registration is safe across cold starts.
///
/// Dart-side call sites must reference these constants instead of
/// hard-coding strings so the channel id used by
/// `flutter_local_notifications` always matches the channel registered
/// natively (channels created through the plugin's first-show fallback
/// inherit no metadata and cannot be reconfigured by the user).
///
/// Channel categories — split by *severity* so the user can mute the
/// noisy ones (sync errors) without silencing security-critical
/// fingerprint warnings:
///
/// * [sshSessions] — IMPORTANCE_LOW — silent persistent ongoing
///   notification while SSH sessions are active.
/// * [fingerprintWarnings] — IMPORTANCE_HIGH — host key changes /
///   verification failures. Sound + vibration so the user notices.
/// * [syncErrors] — IMPORTANCE_DEFAULT — sync conflicts and transport
///   failures. Sound, no vibration.
/// * [keyRotationReminders] — IMPORTANCE_LOW — passive reminder that a
///   stored key is past its rotation horizon.
class AndroidNotificationChannels {
  AndroidNotificationChannels._();

  /// Persistent ongoing notification shown while SSH sessions are
  /// connected. Silent (IMPORTANCE_LOW) — never alerts.
  static const String sshSessions = 'ssh_sessions';
  static const String sshSessionsName = 'Active SSH connections';
  static const String sshSessionsDescription =
      'Persistent notification shown while SSH terminal sessions are open.';

  /// Host key warnings (mismatch, first-time-trust prompts that escape
  /// the foreground). IMPORTANCE_HIGH — sound + vibration.
  static const String fingerprintWarnings = 'fingerprint_warnings';
  static const String fingerprintWarningsName = 'Host key warnings';
  static const String fingerprintWarningsDescription =
      'Security-critical alerts about SSH host key changes or '
      'fingerprint verification failures.';

  /// Sync transport / conflict failures. IMPORTANCE_DEFAULT — sound,
  /// no vibration.
  static const String syncErrors = 'sync_errors';
  static const String syncErrorsName = 'Sync issues';
  static const String syncErrorsDescription =
      'Errors and conflicts encountered while synchronising the vault '
      'with the configured backend.';

  /// Periodic reminder that a stored key is older than the configured
  /// rotation horizon. IMPORTANCE_LOW — passive.
  static const String keyRotationReminders = 'key_rotation_reminders';
  static const String keyRotationRemindersName = 'Key rotation reminders';
  static const String keyRotationRemindersDescription =
      'Reminders to rotate SSH keys that exceed the configured age.';
}
