import 'dart:async';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/connection/domain/entities/auth_method.dart';
import 'package:shellvault/features/connection/presentation/providers/repository_providers.dart';
import 'package:shellvault/features/terminal/presentation/providers/terminal_providers.dart';

class SftpConnectionManager {
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

        final socket = await SSHSocket.connect(
          server.hostname,
          server.port,
          timeout: const Duration(seconds: 15),
        );

        final privateKey = managedPrivateKey ?? credentials.privateKey;
        final passphrase = managedPassphrase ?? credentials.passphrase;

        client = SSHClient(
          socket,
          username: server.username,
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
                  } catch (_) {
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
