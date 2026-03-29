abstract final class AppConstants {
  static const String appName = 'SSH Vault';
  static const String appVersion = '0.1.0';

  // Database
  static const String databaseName = 'sshvault.db';
  static const int databaseVersion = 10;

  // SSH Defaults
  static const int defaultSshPort = 22;
  static const String defaultUsername = 'root';

  // Crypto — v2 KDF parameters (current)
  static const int argon2Iterations = 3;
  static const int argon2MemoryKB = 262144; // 256 MiB
  static const int argon2Parallelism = 1;
  static const int aesKeyLength = 32; // 256 bit
  static const int aesNonceLength = 12; // 96 bit for GCM
  static const int saltLength = 32;

  // Crypto — v1 KDF parameters (legacy, for backward compatibility)
  static const int argon2MemoryKBv1 = 65536; // 64 MiB

  // Export
  static const int exportVersion = 2;
  static const String exportFileName = 'sshvault_export';
  static const String encryptedDataFile = 'data.json.enc';

  // Secure Storage Keys
  static const String credentialPrefix = 'sv_cred_';
  static const String keyPrefix = 'sv_key_';
  static const String dekStorageKey = 'sv_dek';

  // Field Encryption
  static const String encryptedFieldPrefix = 'v1:';

  // Security
  static const int maxPinAttempts = 5;
  static const int lockoutDurationSeconds = 300; // 5 minutes

  // Navigation
  static const int sftpBranchIndex = 1;
  static const int terminalBranchIndex = 6;

  // Pagination
  static const int defaultPageSize = 50;

  // Auth / Sync
  static const String defaultServerUrl = 'https://api.sshvault.app';
  static const String accessTokenKey = 'sv_access_token';
  static const String refreshTokenKey = 'sv_refresh_token';
  static const String tokenExpiryKey = 'sv_token_expiry';
  static const String syncPasswordKey = 'sv_sync_password';
  static const String syncPasswordLastUsedKey = 'sv_sync_password_last_used';
  static const String userEmailKey = 'sv_user_email';
  static const String serverUrlKey = 'sv_server_url';
  static const String deviceIdKey = 'sv_device_id';
  static const String attestationKeyPrefix = 'sv_attest_pubkey_';

  // Security — Server Attestation
  static const String expectedServerId = 'sshvault-api-v1';
  // Ed25519 public key for attestation signature verification (base64-encoded).
  // Replace with the actual server public key before production deployment.
  static const String attestationPublicKeyBase64 =
      'u4hL9b4NSrluOM8TEZDQHrTDOgKnOKpZYJPgnXVX9no=';

  // Security — Heartbeat
  static const int heartbeatIntervalSeconds = 60;
  static const int heartbeatMaxFailures = 3;

  // Typography
  static const String monospaceFontFamily = 'monospace';

  // Alpha values for Color.withAlpha()
  static const int alpha8 = 8;
  static const int alpha13 = 13;
  static const int alpha26 = 26;
  static const int alpha30 = 30;
  static const int alpha38 = 38;
  static const int alpha51 = 51;
  static const int alpha77 = 77;
  static const int alpha102 = 102;
  static const int alpha128 = 128;
  static const int alpha153 = 153;
  static const int alpha179 = 179;
  static const int alpha200 = 200;
  static const int alpha204 = 204;
}
