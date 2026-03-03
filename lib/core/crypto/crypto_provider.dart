import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/crypto/encryption_service.dart';
import 'package:shellvault/core/crypto/nonce_counter.dart';
import 'package:shellvault/core/crypto/ssh_key_service.dart';

final encryptionServiceProvider = Provider<EncryptionService>((ref) {
  return EncryptionService(nonceCounter: NonceCounter());
});

final sshKeyServiceProvider = Provider<SshKeyService>((ref) {
  return SshKeyService();
});
