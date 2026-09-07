import 'dart:async';
import 'package:sshvault/features/host_key/domain/services/host_key_verifier.dart';

import 'package:dartssh2/dartssh2.dart';
import 'package:sshvault/core/ssh/ssh_algorithms.dart';
import 'package:sshvault/core/ssh/agent_identities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/features/connection/domain/entities/auth_method.dart';
import 'package:sshvault/features/connection/domain/entities/proxy_config.dart';
import 'package:sshvault/features/connection/domain/usecases/proxy_resolver.dart';
import 'package:sshvault/features/connection/presentation/providers/repository_providers.dart';

import 'package:sshvault/features/host_key/presentation/providers/known_host_providers.dart';
import 'package:sshvault/features/settings/presentation/providers/proxy_settings_provider.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

class SftpConnectionManager {
  static const _tag = 'SftpConnectionManager';
  static final _log = LoggingService.instance;

  final Map<String, SftpClient> _clients = {};
  // Keep SSHClient references alive so the underlying connection isn't GC'd
  final Map<String, SSHClient> _sshClients = {};
  final Set<String> _ownedTransports = {};
  final Map<String, SSHClient> _jumpClients = {};
  final Map<String, Future<Result<SftpClient>>> _inFlight = {};
  final Map<String, Object> _attempts = {};
  int _generation = 0;

  /// Returns cached or creates new SftpClient for the given server.
  /// Reuses SSHClient from an existing terminal session if available.
  ///
  /// Accepts a [container] so this can be called from both
  /// Notifier (Ref) and widget (WidgetRef) contexts via `ref.container`.
  Future<Result<SftpClient>> getClient(
    String serverId,
    ProviderContainer container,
  ) {
    // Return cached client if still valid
    if (_clients.containsKey(serverId) &&
        _sshClients[serverId]?.isClosed == false) {
      return Future.value(Success(_clients[serverId]!));
    }
    final pending = _inFlight[serverId];
    if (pending != null) return pending;

    closeClient(serverId);
    final attempt = Object();
    _attempts[serverId] = attempt;
    final future = _openClient(serverId, container, attempt).whenComplete(() {
      // A closed attempt must not evict a newer attempt for the same host.
      if (identical(_attempts[serverId], attempt)) {
        _attempts.remove(serverId);
        _inFlight.remove(serverId);
      }
    });
    _inFlight[serverId] = future;
    return future;
  }

  Future<Result<SftpClient>> _openClient(
    String serverId,
    ProviderContainer container,
    Object attempt,
  ) async {
    final generation = _generation;

    SSHClient? ownedClient;
    SSHClient? jumpClient;
    SSHSocket? pendingSocket;
    SftpClient? pendingSftp;
    try {
      // Try to reuse SSHClient from an active terminal session
      final sessions = container.read(sessionManagerProvider);
      final session = sessions
          .where(
            (s) =>
                s.serverId == serverId &&
                s.client != null &&
                !s.client!.isClosed &&
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
            server.sshKeyId != kSshAgentSentinelKeyId &&
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

        Future<SSHSocket> connectSocket(String host, int port) async {
          const timeout = Duration(seconds: 15);
          if (proxy == null || proxy.type == ProxyType.none) {
            return SSHSocket.connect(host, port, timeout: timeout);
          }
          final proxyCreds = await container.read(
            globalProxyCredentialsProvider.future,
          );
          if (proxy.type == ProxyType.socks5) {
            return Socks5SSHSocket.connect(
              proxy.host,
              proxy.port,
              host,
              port,
              username: proxy.username,
              password: proxyCreds.password,
              timeout: timeout,
            );
          }
          return HttpConnectSSHSocket.connect(
            proxy.host,
            proxy.port,
            host,
            port,
            username: proxy.username,
            password: proxyCreds.password,
            timeout: timeout,
          );
        }

        final SSHSocket socket;
        if (server.jumpHostId != null) {
          final jumpResult = await serverUseCases.getServer(server.jumpHostId!);
          if (jumpResult.isFailure) throw jumpResult.failure;
          final jump = jumpResult.value;
          final credsResult = await serverUseCases.getCredentials(jump.id);
          if (credsResult.isFailure) throw credsResult.failure;
          final creds = credsResult.value;
          List<SSHIdentity>? identities;
          if (jump.authMethod != AuthMethod.password) {
            if (jump.sshKeyId == kSshAgentSentinelKeyId) {
              identities = await loadAgentIdentities();
            } else {
              var pem = creds.privateKey;
              var passphrase = creds.passphrase;
              if (jump.sshKeyId != null) {
                final keyResult = await sshKeyUseCases.getSshKeyPrivateKey(
                  jump.sshKeyId!,
                );
                if (keyResult.isFailure) throw keyResult.failure;
                pem = keyResult.value;
                final passResult = await sshKeyUseCases.getSshKeyPassphrase(
                  jump.sshKeyId!,
                );
                if (passResult.isFailure) throw passResult.failure;
                passphrase = passResult.value;
              }
              if (pem != null && pem.isNotEmpty) {
                identities = SSHKeyPair.fromPem(pem, passphrase);
              }
            }
          }
          final jumpSocket = await connectSocket(jump.hostname, jump.port);
          pendingSocket = jumpSocket;
          jumpClient = SSHClient(
            jumpSocket,
            username: jump.username,
            algorithms: sshVaultAlgorithms,
            identities: identities,
            onPasswordRequest:
                jump.authMethod != AuthMethod.key && creds.password != null
                ? () => creds.password!
                : null,
            onVerifyHostKey: _buildHostKeyVerifier(
              jump.hostname,
              jump.port,
              container,
            ),
          );
          await jumpClient.authenticated;
          socket = await jumpClient.forwardLocal(server.hostname, server.port);
        } else {
          socket = await connectSocket(server.hostname, server.port);
        }
        pendingSocket = socket;
        final privateKey = managedPrivateKey ?? credentials.privateKey;
        final passphrase = managedPassphrase ?? credentials.passphrase;

        client = SSHClient(
          socket,
          username: server.username,
          algorithms: sshVaultAlgorithms,
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
                  server.sshKeyId == kSshAgentSentinelKeyId
              ? await loadAgentIdentities()
              : server.authMethod != AuthMethod.password &&
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

        ownedClient = client;
        await client.authenticated;
      }

      final sftpClient = await client.sftp();
      pendingSftp = sftpClient;
      await sftpClient.handshake.timeout(const Duration(seconds: 10));
      if (generation != _generation ||
          !identical(_attempts[serverId], attempt)) {
        throw StateError('SFTP connection cancelled');
      }
      _clients[serverId] = sftpClient;
      _sshClients[serverId] = client;
      if (ownedClient != null) _ownedTransports.add(serverId);
      if (jumpClient != null) _jumpClients[serverId] = jumpClient;
      return Success(sftpClient);
    } catch (e) {
      pendingSftp?.close();
      ownedClient?.close();
      jumpClient?.close();
      pendingSocket?.destroy();
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
    return HostKeyVerifier(
      repository: container.read(knownHostRepositoryProvider),
      hostname: hostname,
      port: port,
      trustNewHosts: true,
    ).verify;
  }

  void closeClient(String serverId) {
    _attempts.remove(serverId);
    _inFlight.remove(serverId);
    _clients.remove(serverId)?.close();
    if (_ownedTransports.remove(serverId)) _sshClients[serverId]?.close();
    _jumpClients.remove(serverId)?.close();
    _sshClients.remove(serverId);
  }

  void closeAll() {
    _generation++;
    _attempts.clear();
    _inFlight.clear();
    for (final serverId in _sshClients.keys.toList()) {
      closeClient(serverId);
    }
  }
}
