import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/services/logging_service.dart';
import 'package:shellvault/features/connection/domain/entities/auth_method.dart';
import 'package:shellvault/features/connection/domain/entities/server_credentials.dart';
import 'package:shellvault/features/connection/domain/entities/server_entity.dart';
import 'package:shellvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:xterm/xterm.dart';

typedef SshConnection = ({
  SSHClient client,
  SSHSession session,
  StreamSubscription<Uint8List> stdoutSubscription,
  StreamSubscription<Uint8List> stderrSubscription,
});

class SshService {
  static const _tag = 'SSH';
  final _log = LoggingService.instance;

  Future<Result<SshConnection>> connect({
    required ServerEntity server,
    required ServerCredentials credentials,
    required Terminal terminal,
    String? managedPrivateKey,
    String? managedPassphrase,
  }) async {
    _log.info(
      _tag,
      'Connecting to ${server.hostname}:${server.port} as ${server.username}',
    );
    try {
      final socket = await SSHSocket.connect(
        server.hostname,
        server.port,
        timeout: const Duration(seconds: 15),
      );

      _log.debug(_tag, 'Socket connected to ${server.hostname}:${server.port}');

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
      _log.info(_tag, 'Authenticated to ${server.hostname}:${server.port}');

      final session = await client.shell(
        pty: const SSHPtyConfig(width: 80, height: 24),
      );

      _log.info(_tag, 'Shell session opened for ${server.hostname}');

      // UTF-8 decoder that tolerates malformed sequences (e.g. binary data
      // mixed into terminal output). allowMalformed replaces invalid bytes
      // with U+FFFD instead of throwing.
      const utf8 = Utf8Decoder(allowMalformed: true);

      // Wire terminal output → SSH session
      terminal.onOutput = (data) {
        session.write(Uint8List.fromList(data.codeUnits));
      };

      // Wire SSH stdout → terminal (store subscription for cleanup)
      final stdoutSub = session.stdout.listen(
        (data) => terminal.write(utf8.convert(data)),
        onDone: () {
          _log.info(_tag, 'Connection closed for ${server.hostname}');
          terminal.write('\r\n[Connection closed]\r\n');
        },
      );

      // Wire SSH stderr → terminal (store subscription for cleanup)
      final stderrSub = session.stderr.listen(
        (data) => terminal.write(utf8.convert(data)),
      );

      // Wire terminal resize → SSH
      terminal.onResize = (width, height, pixelWidth, pixelHeight) {
        session.resizeTerminal(width, height);
      };

      return Success((
        client: client,
        session: session,
        stdoutSubscription: stdoutSub,
        stderrSubscription: stderrSub,
      ));
    } on SSHAuthFailError catch (e) {
      _log.error(
        _tag,
        'Authentication failed for ${server.username}@${server.hostname}: $e',
      );
      return Err(
        SshConnectionFailure(
          'Authentication failed for ${server.username}@${server.hostname}',
          cause: e,
        ),
      );
    } on SSHAuthAbortError catch (e) {
      _log.error(_tag, 'Authentication aborted for ${server.hostname}: $e');
      return Err(SshConnectionFailure('Authentication aborted', cause: e));
    } catch (e) {
      _log.error(
        _tag,
        'Failed to connect to ${server.hostname}:${server.port}: $e',
      );
      return Err(
        SshConnectionFailure(
          'Failed to connect to ${server.hostname}:${server.port}',
          cause: e,
        ),
      );
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

  Future<DistroInfo?> detectDistro(SSHClient client) async {
    try {
      final result = await client.run(
        'cat /etc/os-release 2>/dev/null || echo ""',
      );
      final output = utf8.decode(result);
      if (output.trim().isEmpty) return null;

      final map = <String, String>{};
      for (final line in output.split('\n')) {
        final idx = line.indexOf('=');
        if (idx < 0) continue;
        final key = line.substring(0, idx).trim();
        var value = line.substring(idx + 1).trim();
        if (value.startsWith('"') && value.endsWith('"')) {
          value = value.substring(1, value.length - 1);
        }
        map[key] = value;
      }

      final id = map['ID'];
      final name = map['NAME'];
      if (id == null && name == null) return null;

      return DistroInfo(
        id: id ?? name!.toLowerCase(),
        name: name ?? id!,
        version: map['VERSION_ID'],
        prettyName: map['PRETTY_NAME'],
      );
    } catch (e) {
      _log.debug(_tag, 'Distro detection failed: $e');
      return null;
    }
  }

  void disconnect(SSHClient client) {
    _log.info(_tag, 'Disconnecting SSH client');
    client.close();
  }
}
