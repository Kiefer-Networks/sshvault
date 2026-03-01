import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/storage/secure_storage_service.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});
