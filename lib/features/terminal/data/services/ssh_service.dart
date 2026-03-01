import 'dart:async';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/connection/domain/entities/auth_method.dart';
import 'package:shellvault/features/connection/domain/entities/server_credentials.dart';
import 'package:shellvault/features/connection/domain/entities/server_entity.dart';
import 'package:xterm/xterm.dart';

typedef SshConnection = ({SSHClient client, SSHSession session});

class SshService {
  Future<Result<SshConnection>> connect({
    required ServerEntity server,
    required ServerCredentials credentials,
    required Terminal terminal,
    String? managedPrivateKey,
    String? managedPassphrase,
  }) async {
    try {
      final socket = await SSHSocket.connect(
        server.hostname,
        server.port,
        timeout: const Duration(seconds: 15),
      );

      final client = SSHClient(
        socket,
        username: server.username,
        onPasswordRequest: _buildPasswordHandler(server, credentials),
        identities: _buildIdentities(
          server,
          credentials,
          managedPrivateKey,
          managedPassphrase,
        ),
      );

      await client.authenticated;

      final session = await client.shell(
        pty: const SSHPtyConfig(
          width: 80,
          height: 24,
        ),
      );

      // Wire terminal output → SSH session
      terminal.onOutput = (data) {
        session.write(Uint8List.fromList(data.codeUnits));
      };

      // Wire SSH stdout → terminal
      session.stdout.listen(
        (data) => terminal.write(String.fromCharCodes(data)),
        onDone: () => terminal.write('\r\n[Connection closed]\r\n'),
      );

      // Wire SSH stderr → terminal
      session.stderr.listen(
        (data) => terminal.write(String.fromCharCodes(data)),
      );

      // Wire terminal resize → SSH
      terminal.onResize = (width, height, pixelWidth, pixelHeight) {
        session.resizeTerminal(width, height);
      };

      return Success((client: client, session: session));
    } on SSHAuthFailError catch (e) {
      return Err(SshConnectionFailure(
        'Authentication failed for ${server.username}@${server.hostname}',
        cause: e,
      ));
    } on SSHAuthAbortError catch (e) {
      return Err(SshConnectionFailure(
        'Authentication aborted',
        cause: e,
      ));
    } catch (e) {
      return Err(SshConnectionFailure(
        'Failed to connect to ${server.hostname}:${server.port}',
        cause: e,
      ));
    }
  }

  SSHPasswordRequestHandler? _buildPasswordHandler(
    ServerEntity server,
    ServerCredentials credentials,
  ) {
    if (server.authMethod == AuthMethod.key) return null;
    final password = credentials.password;
    if (password == null || password.isEmpty) return null;
    return () => password;
  }

  List<SSHKeyPair>? _buildIdentities(
    ServerEntity server,
    ServerCredentials credentials,
    String? managedPrivateKey,
    String? managedPassphrase,
  ) {
    if (server.authMethod == AuthMethod.password) return null;

    // Managed key takes priority
    final privateKey = managedPrivateKey ?? credentials.privateKey;
    final passphrase = managedPassphrase ?? credentials.passphrase;

    if (privateKey == null || privateKey.isEmpty) return null;

    try {
      return SSHKeyPair.fromPem(privateKey, passphrase);
    } catch (e) {
      return null;
    }
  }

  void disconnect(SSHClient client) {
    client.close();
  }
}
