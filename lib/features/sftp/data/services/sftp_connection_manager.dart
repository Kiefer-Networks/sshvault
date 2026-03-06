import 'dart:async';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:sshvault/core/crypto/crypto_utils.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/features/connection/domain/entities/auth_method.dart';
import 'package:sshvault/features/connection/domain/entities/proxy_config.dart';
import 'package:sshvault/features/connection/domain/usecases/proxy_resolver.dart';
import 'package:sshvault/features/connection/presentation/providers/repository_providers.dart';
import 'package:sshvault/features/host_key/domain/entities/known_host_entity.dart';
import 'package:sshvault/features/host_key/presentation/providers/known_host_providers.dart';
import 'package:sshvault/features/settings/presentation/providers/proxy_settings_provider.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

class SftpConnectionManager {
  static const _tag = 'SftpConnectionManager';
  static final _log = LoggingService.instance;
  static const _uuid = Uuid();

  final Map<String, SftpClient> _clients = {};
  // Keep SSHClient references alive so the underlying connection isn't GC'd
  final Map<String, SSHClient> _sshClients = {};

  /// Returns cached or creates new SftpClient for the given server.
  /// Reuses SSHClient from an existing terminal session if available.
  ///
  /// Accepts a [container] so this can be called from both
  /// Notifier (Ref) and widget (WidgetRef) contexts via `ref.container`.
  Future<Result<SftpClient>> getClient(
    String serverId,
    ProviderContainer container,
  ) async {
    // Return cached client if still valid
    if (_clients.containsKey(serverId)) {
      return Success(_clients[serverId]!);
    }

    try {
      // Try to reuse SSHClient from an active terminal session
      final sessions = container.read(sessionManagerProvider);
      final session = sessions
          .where(
            (s) =>
                s.serverId == serverId &&
                s.client != null &&
                s.status.name == 'connected',
          )
          .firstOrNull;

      SSHClient client;
      if (session?.client != null) {
        client = session!.client!;
      } else {
        // Create a new SSH connection
        final serverUseCases = container.read(serverUseCasesProvider);
        final sshKeyUseCases = container.read(sshKeyUseCasesProvider);

        final serverResult = await serverUseCases.getServer(serverId);
        if (serverResult.isFailure) {
          return Err(
            SftpFailure('Server not found', cause: serverResult.failure),
          );
        }
        final server = serverResult.value;

        final credsResult = await serverUseCases.getCredentials(serverId);
        if (credsResult.isFailure) {
          return Err(
            SftpFailure('Credentials not found', cause: credsResult.failure),
          );
        }
        final credentials = credsResult.value;

        // Load managed key if applicable
        String? managedPrivateKey;
        String? managedPassphrase;
        if (server.sshKeyId != null &&
            server.authMethod != AuthMethod.password) {
          final keyResult = await sshKeyUseCases.getSshKeyPrivateKey(
            server.sshKeyId!,
          );
          managedPrivateKey = keyResult.fold(
            onSuccess: (k) => k,
            onFailure: (_) => null,
          );
          final passphraseResult = await sshKeyUseCases.getSshKeyPassphrase(
            server.sshKeyId!,
          );
          managedPassphrase = passphraseResult.fold(
            onSuccess: (p) => p,
            onFailure: (_) => null,
          );
        }

        // Resolve proxy configuration
        final globalProxy = container.read(globalProxyConfigProvider);
        final resolver = ProxyResolver();
        final proxy = resolver.resolve(server, globalProxy);

        final SSHSocket socket;
        if (proxy != null && proxy.type != ProxyType.none) {
          final proxyCreds = await container.read(
            globalProxyCredentialsProvider.future,
          );
          switch (proxy.type) {
            case ProxyType.socks5:
              socket = await Socks5SSHSocket.connect(
                proxy.host,
                proxy.port,
                server.hostname,
                server.port,
                username: proxy.username,
                password: proxyCreds.password,
                timeout: const Duration(seconds: 15),
              );
            case ProxyType.httpConnect:
              socket = await HttpConnectSSHSocket.connect(
                proxy.host,
                proxy.port,
                server.hostname,
                server.port,
                username: proxy.username,
                password: proxyCreds.password,
                timeout: const Duration(seconds: 15),
              );
            case ProxyType.none:
              socket = await SSHSocket.connect(
                server.hostname,
                server.port,
                timeout: const Duration(seconds: 15),
              );
          }
        } else {
          socket = await SSHSocket.connect(
            server.hostname,
            server.port,
            timeout: const Duration(seconds: 15),
          );
        }

        final privateKey = managedPrivateKey ?? credentials.privateKey;
        final passphrase = managedPassphrase ?? credentials.passphrase;

        client = SSHClient(
          socket,
          username: server.username,
          onVerifyHostKey: _buildHostKeyVerifier(
            server.hostname,
            server.port,
            container,
          ),
          onPasswordRequest:
              server.authMethod != AuthMethod.key &&
                  credentials.password != null &&
                  credentials.password!.isNotEmpty
              ? () => credentials.password!
              : null,
          identities:
              server.authMethod != AuthMethod.password &&
                  privateKey != null &&
                  privateKey.isNotEmpty
              ? () {
                  try {
                    return SSHKeyPair.fromPem(privateKey, passphrase);
                  } catch (e) {
                    _log.warning(_tag, 'Failed to parse SSH key: $e');
                    return <SSHKeyPair>[];
                  }
                }()
              : null,
        );

        await client.authenticated;
      }

      final sftpClient = await client.sftp();
      await sftpClient.handshake.timeout(const Duration(seconds: 10));
      _clients[serverId] = sftpClient;
      _sshClients[serverId] = client;
      return Success(sftpClient);
    } catch (e) {
      return Err(SftpFailure('Failed to connect SFTP', cause: e));
    }
  }

  /// Builds a host key verification callback for SFTP connections.
  ///
  /// Uses Trust-On-First-Use (TOFU): new keys are accepted and stored,
  /// known matching keys are accepted silently, and changed keys are
  /// rejected (no UI dialog available in the SFTP context).
  static SSHHostkeyVerifyHandler _buildHostKeyVerifier(
    String hostname,
    int port,
    ProviderContainer container,
  ) {
    return (String type, Uint8List fingerprint) async {
      final hex = _fingerprintToHex(fingerprint);
      final repo = container.read(knownHostRepositoryProvider);
      final existing = await repo.findByHostAndPort(hostname, port);

      KnownHostEntity? known;
      if (existing.isSuccess) {
        known = existing.value;
      }

      if (known != null) {
        if (CryptoUtils.constantTimeStringEquals(known.fingerprint, hex)) {
          // Known host, fingerprint matches — update lastSeenAt
          await repo.save(known.copyWith(lastSeenAt: DateTime.now()));
          return true;
        }
        // Key CHANGED — reject without dialog (no BuildContext in SFTP)
        _log.warning(
          _tag,
          'Host key CHANGED for $hostname:$port '
          '(expected ${known.fingerprint}, got $hex). '
          'Rejecting SFTP connection.',
        );
        return false;
      }

      // First connection — TOFU: accept and store
      final now = DateTime.now();
      await repo.save(
        KnownHostEntity(
          id: _uuid.v4(),
          hostname: hostname,
          port: port,
          keyType: type,
          fingerprint: hex,
          firstSeenAt: now,
          lastSeenAt: now,
        ),
      );
      _log.info(_tag, 'TOFU: Stored new host key for $hostname:$port ($type)');
      return true;
    };
  }

  static String _fingerprintToHex(Uint8List bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(':');
  }

  void closeClient(String serverId) {
    _clients.remove(serverId);
    _sshClients[serverId]?.close();
    _sshClients.remove(serverId);
  }

  void closeAll() {
    _clients.clear();
    for (final client in _sshClients.values) {
      client.close();
    }
    _sshClients.clear();
  }
}
