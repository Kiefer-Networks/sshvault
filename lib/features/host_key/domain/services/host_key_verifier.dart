import 'dart:typed_data';
import 'package:sshvault/core/crypto/crypto_utils.dart';
import 'package:sshvault/core/ssh/host_key_fingerprint.dart';
import 'package:sshvault/features/host_key/domain/entities/known_host_entity.dart';
import 'package:sshvault/features/host_key/domain/repositories/known_host_repository.dart';
import 'package:uuid/uuid.dart';

/// Shared host pin policy for interactive terminal and noninteractive SFTP.
class HostKeyVerifier {
  final KnownHostRepository repository;
  final String hostname;
  final int port;
  final bool trustNewHosts;
  final Future<bool> Function(
    String type,
    String fingerprint,
    KnownHostEntity? previous,
  )?
  confirm;
  final void Function()? onStored;

  HostKeyVerifier({
    required this.repository,
    required this.hostname,
    required this.port,
    this.trustNewHosts = false,
    this.confirm,
    this.onStored,
  });

  Future<bool> verify(String type, Uint8List fingerprint) async {
    try {
      return await _verify(type, fingerprint);
    } catch (_) {
      // A repository or confirmation failure must never authorize a key.
      return false;
    }
  }

  Future<bool> _verify(String type, Uint8List fingerprint) async {
    final hex = hostKeyDigest(
      fingerprint,
    ).map((b) => b.toRadixString(16).padLeft(2, '0')).join(':');
    final result = await repository.findByHostAndPort(hostname, port);
    if (result.isFailure) return false;
    final known = result.value;
    final matches =
        known != null &&
        CryptoUtils.constantTimeStringEquals(known.fingerprint, hex);
    if (!matches) {
      final accepted =
          known == null && trustNewHosts ||
          (await confirm?.call(type, hex, known) ?? false);
      if (!accepted) return false;
    }
    final now = DateTime.now();
    final updated =
        known?.copyWith(keyType: type, fingerprint: hex, lastSeenAt: now) ??
        KnownHostEntity(
          id: const Uuid().v4(),
          hostname: hostname,
          port: port,
          keyType: type,
          fingerprint: hex,
          firstSeenAt: now,
          lastSeenAt: now,
        );
    final saved = await repository.save(updated);
    if (saved.isFailure) return false;
    if (!matches) onStored?.call();
    return true;
  }
}
