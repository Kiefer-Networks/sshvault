import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/storage/keyring_service.dart';
import 'package:sshvault/core/storage/secure_storage_service.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

/// Wraps `flutter_secure_storage` for the master vault key only. Backed by
/// libsecret (GNOME Keyring / KWallet) on Linux, the platform default
/// keyring elsewhere, and a file fallback on headless boxes.
final keyringServiceProvider = Provider<KeyringService>((ref) {
  return KeyringService();
});
