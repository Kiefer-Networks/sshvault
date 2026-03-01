import 'dart:math';
import 'dart:typed_data';

import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/storage/secure_storage_service.dart';

/// Manages the Data Encryption Key (DEK) lifecycle.
///
/// The DEK is a random 256-bit key stored in platform secure storage.
/// It is independent of the PIN — changing the PIN does not require
/// re-encrypting the database.
class DekManager {
  final SecureStorageService _secureStorage;

  DekManager(this._secureStorage);

  /// Generates a new random DEK and stores it in secure storage.
  /// Returns the generated key bytes.
  Future<Uint8List> generateAndStoreDek() async {
    final random = Random.secure();
    final dek = Uint8List.fromList(
      List.generate(AppConstants.aesKeyLength, (_) => random.nextInt(256)),
    );
    await _secureStorage.saveDek(dek);
    return dek;
  }

  /// Loads the DEK from secure storage. Returns null if no DEK exists.
  Future<Uint8List?> loadDek() async {
    return _secureStorage.loadDek();
  }

  /// Deletes the DEK from secure storage.
  Future<void> deleteDek() async {
    await _secureStorage.deleteDek();
  }

  /// Returns true if a DEK exists in secure storage.
  Future<bool> hasDek() async {
    final dek = await loadDek();
    return dek != null;
  }
}
