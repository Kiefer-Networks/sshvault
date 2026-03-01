import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/crypto/dek_manager.dart';
import 'package:shellvault/core/crypto/field_crypto_service.dart';
import 'package:shellvault/core/storage/secure_storage_provider.dart';

/// Provider for the DEK manager.
final dekManagerProvider = Provider<DekManager>((ref) {
  return DekManager(ref.watch(secureStorageProvider));
});

/// Provider for the field crypto service.
/// Returns null if no DEK is loaded (encryption not active).
final fieldCryptoServiceProvider = StateProvider<FieldCryptoService?>((ref) {
  return null;
});
