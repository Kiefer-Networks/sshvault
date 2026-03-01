abstract final class AppConstants {
  static const String appName = 'SSH Vault';
  static const String appVersion = '0.1.0';

  // Database
  static const String databaseName = 'shellvault.db';
  static const int databaseVersion = 4;

  // SSH Defaults
  static const int defaultSshPort = 22;
  static const String defaultUsername = 'root';

  // Crypto
  static const int argon2Iterations = 3;
  static const int argon2MemoryKB = 65536; // 64 MiB
  static const int argon2Parallelism = 4;
  static const int aesKeyLength = 32; // 256 bit
  static const int aesNonceLength = 12; // 96 bit for GCM
  static const int saltLength = 32;

  // Export
  static const int exportVersion = 1;
  static const String exportFileName = 'shellvault_export';
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
  static const int terminalBranchIndex = 6;

  // Pagination
  static const int defaultPageSize = 50;

  // Auth / Sync
  static const String defaultServerUrl = 'https://api.shellvault.app';
  static const String accessTokenKey = 'sv_access_token';
  static const String refreshTokenKey = 'sv_refresh_token';
  static const String tokenExpiryKey = 'sv_token_expiry';
  static const String syncPasswordKey = 'sv_sync_password';
  static const String userEmailKey = 'sv_user_email';
  static const String serverUrlKey = 'sv_server_url';
}
