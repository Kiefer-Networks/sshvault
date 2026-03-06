import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/crypto/encryption_service.dart';
import 'package:sshvault/core/crypto/nonce_counter.dart';
import 'package:sshvault/core/crypto/ssh_key_service.dart';

final encryptionServiceProvider = Provider<EncryptionService>((ref) {
  return EncryptionService(nonceCounter: NonceCounter());
});

final sshKeyServiceProvider = Provider<SshKeyService>((ref) {
  return SshKeyService();
});
