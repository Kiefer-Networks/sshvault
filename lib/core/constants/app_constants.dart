abstract final class AppConstants {
  static const String appName = 'ShellVault';
  static const String appVersion = '0.1.0';

  // Database
  static const String databaseName = 'shellvault.db';
  static const int databaseVersion = 3;

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

  // Pagination
  static const int defaultPageSize = 50;
}
