import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:sshvault/features/terminal/data/services/terminal_io.dart';

import 'package:dartssh2/dartssh2.dart';
import 'package:sshvault/core/ssh/ssh_algorithms.dart';
import 'package:sshvault/core/ssh/agent_identities.dart';
import 'package:sshvault/core/ssh/local_agent_forwarder.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/features/connection/domain/entities/auth_method.dart';
import 'package:sshvault/features/connection/domain/entities/proxy_config.dart';
import 'package:sshvault/features/connection/domain/entities/proxy_credentials.dart';
import 'package:sshvault/features/connection/domain/entities/server_credentials.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:xterm/xterm.dart';

typedef SshConnection = ({
  SSHClient client,
  SSHSession session,
  StreamSubscription<String> stdoutSubscription,
  StreamSubscription<String> stderrSubscription,
  SSHClient? jumpHostClient,
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
    ServerEntity? jumpHost,
    ServerCredentials? jumpHostCredentials,
    String? jumpHostPrivateKey,
    String? jumpHostPassphrase,
    ProxyConfig? proxyConfig,
    ProxyCredentials? proxyCredentials,
    SSHHostkeyVerifyHandler? onVerifyHostKey,
    SSHHostkeyVerifyHandler? onVerifyJumpHostKey,
    // Explicit opt-in: expose local agent listing/signing to the destination.
    bool forwardAgent = false,
  }) async {
    _log.info(
      _tag,
      'Connecting to ${server.hostname}:${server.port} as ${server.username}'
      '${forwardAgent ? ' (agent forwarding requested)' : ''}',
    );
    SSHClient? jumpHostClient;
    SSHClient? client;
    final openedSockets = <SSHSocket>[];
    var connected = false;
    try {
      if (jumpHost != null && jumpHostCredentials != null) {
        _log.info(
          _tag,
          'Using jump host ${jumpHost.hostname}:${jumpHost.port}',
        );

        final jumpSocket = await _connectSocket(
          jumpHost.hostname,
          jumpHost.port,
          proxyConfig,
          proxyCredentials,
        );
        openedSockets.add(jumpSocket);

        jumpHostClient = SSHClient(
          jumpSocket,
          username: jumpHost.username,
          algorithms: sshVaultAlgorithms,
          printDebug: (message) => _log.debug(_tag, '[jump] $message'),
          onPasswordRequest: _buildPasswordHandler(
            jumpHost,
            jumpHostCredentials,
          ),
          identities: await _buildIdentities(
            jumpHost,
            jumpHostCredentials,
            jumpHostPrivateKey,
            jumpHostPassphrase,
          ),
          onVerifyHostKey: onVerifyJumpHostKey,
        );

        await jumpHostClient.authenticated;
        _log.info(_tag, 'Authenticated to jump host ${jumpHost.hostname}');

        final forward = await jumpHostClient.forwardLocal(
          server.hostname,
          server.port,
        );
        openedSockets.add(forward);

        client = SSHClient(
          forward,
          agentHandler: forwardAgent ? LocalAgentForwarder() : null,
          username: server.username,
          algorithms: sshVaultAlgorithms,
          printDebug: (message) => _log.debug(_tag, message ?? ''),
          onPasswordRequest: _buildPasswordHandler(server, credentials),
          identities: await _buildIdentities(
            server,
            credentials,
            managedPrivateKey,
            managedPassphrase,
          ),
          onVerifyHostKey: onVerifyHostKey,
        );
      } else {
        final socket = await _connectSocket(
          server.hostname,
          server.port,
          proxyConfig,
          proxyCredentials,
        );
        openedSockets.add(socket);

        _log.debug(
          _tag,
          'Socket connected to ${server.hostname}:${server.port}',
        );

        client = SSHClient(
          socket,
          agentHandler: forwardAgent ? LocalAgentForwarder() : null,
          username: server.username,
          algorithms: sshVaultAlgorithms,
          printDebug: (message) => _log.debug(_tag, message ?? ''),
          onPasswordRequest: _buildPasswordHandler(server, credentials),
          identities: await _buildIdentities(
            server,
            credentials,
            managedPrivateKey,
            managedPassphrase,
          ),
          onVerifyHostKey: onVerifyHostKey,
        );
      }

      await client.authenticated;
      _log.info(_tag, 'Authenticated to ${server.hostname}:${server.port}');

      final session = await client.shell(
        pty: const SSHPtyConfig(width: 80, height: 24),
      );

      _log.info(_tag, 'Shell session opened for ${server.hostname}');

      final subscriptions = wireTerminalIo(
        session,
        terminal,
        onDone: () {
          _log.info(_tag, 'Connection closed for ${server.hostname}');
          terminal.write('\r\n[Connection closed]\r\n');
        },
      );
      connected = true;
      return Success((
        client: client,
        session: session,
        stdoutSubscription: subscriptions.stdout,
        stderrSubscription: subscriptions.stderr,
        jumpHostClient: jumpHostClient,
      ));
    } on SSHHandshakeError catch (e) {
      _log.error(_tag, 'SSH handshake failed for ${server.hostname}: $e');
      return Err(
        SshConnectionFailure('SSH handshake failed: ${e.message}', cause: e),
      );
    } on SSHInternalError catch (e) {
      // dartssh2 reports an empty algorithm intersection as an internal
      // transport error. Preserve the actual reason so the UI does not show
      // the misleading generic "authentication aborted" message.
      final detail = e.error.toString();
      _log.error(
        _tag,
        'SSH transport negotiation failed for ${server.hostname}: $detail',
      );
      return Err(
        SshConnectionFailure(
          'SSH negotiation failed for ${server.hostname}: $detail',
          cause: e,
        ),
      );
    } on SSHAuthFailError catch (e) {
      _log.error(
        _tag,
        'Authentication failed for ${server.username}@${server.hostname}: ${e.message}',
      );
      return Err(
        SshConnectionFailure(
          'SSH-Authentifizierung fehlgeschlagen: ${e.message}',
          cause: e,
        ),
      );
    } on SSHAuthAbortError catch (e) {
      _log.error(_tag, 'Authentication aborted for ${server.hostname}: $e');
      final reason = e.reason?.toString() ?? e.message;
      if (reason.contains('No matching key exchange algorithm') ||
          reason.contains('ML-KEM unavailable') ||
          reason.contains('sntrup unavailable')) {
        return Err(
          SshConnectionFailure(
            'PQ-SSH-Schlüsselaustausch ist nicht verfügbar: ${hybridKexAvailabilityError ?? 'liboqs.dll fehlt oder konnte nicht geladen werden'}. Lege liboqs.dll neben sshvault.exe ab oder erlaube auf dem Server curve25519-sha256.',
            cause: e,
          ),
        );
      }
      return Err(
        SshConnectionFailure('Authentication aborted: $reason', cause: e),
      );
    } on TimeoutException catch (e) {
      _log.error(
        _tag,
        'Connection timed out for ${server.hostname}:${server.port}: $e',
      );
      return Err(
        SshConnectionFailure(
          'Zeitüberschreitung beim Verbinden mit ${server.hostname}:${server.port}. Prüfe Erreichbarkeit, Firewall und Port.',
          cause: e,
        ),
      );
    } on SocketException catch (e) {
      _log.error(
        _tag,
        'Network connection failed for ${server.hostname}:${server.port}: $e',
      );
      return Err(
        SshConnectionFailure(
          'Server ${server.hostname}:${server.port} ist nicht erreichbar: ${e.message}',
          cause: e,
        ),
      );
    } catch (e) {
      _log.error(
        _tag,
        'Failed to connect to ${server.hostname}:${server.port}: $e',
      );
      final detail = e.toString();
      if (detail.contains('No matching key exchange algorithm')) {
        return Err(
          SshConnectionFailure(
            'Kein kompatibler SSH-Schlüsselaustausch. Der Server verlangt PQ-KEX; Windows benötigt dafür liboqs.dll im Programmordner.',
            cause: e,
          ),
        );
      }
      return Err(
        SshConnectionFailure(
          'Failed to connect to ${server.hostname}:${server.port}',
          cause: e,
        ),
      );
    } finally {
      if (!connected) {
        client?.close();
        jumpHostClient?.close();
        for (final socket in openedSockets) {
          socket.destroy();
        }
      }
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

  Future<List<SSHIdentity>?> _buildIdentities(
    ServerEntity server,
    ServerCredentials credentials,
    String? managedPrivateKey,
    String? managedPassphrase,
  ) async {
    if (server.authMethod == AuthMethod.password) return null;
    if (server.sshKeyId == kSshAgentSentinelKeyId) {
      final agentKeys = await loadAgentIdentities();
      _log.info(
        _tag,
        'Using Windows ssh-agent (${agentKeys.length} identities)',
      );
      return agentKeys;
    }

    // Managed key takes priority
    final privateKey = managedPrivateKey ?? credentials.privateKey;
    final passphrase = managedPassphrase ?? credentials.passphrase;

    if (privateKey == null || privateKey.isEmpty) {
      _log.error(
        _tag,
        'No usable private key for ${server.username}@${server.hostname} '
        '(sshKeyId=${server.sshKeyId ?? 'none'})',
      );
      return null;
    }

    try {
      final identities = SSHKeyPair.fromPem(privateKey, passphrase);
      _log.info(
        _tag,
        'Loaded ${identities.length} private-key identity(ies) for '
        '${server.username}@${server.hostname}',
      );
      return identities;
    } catch (e) {
      _log.error(
        _tag,
        'Private-key parse failed for ${server.username}@${server.hostname}: $e',
      );
      return null;
    }
  }

  Future<DistroInfo?> detectDistro(SSHClient client) async {
    try {
      final osRelease = await client.run(
        'cat /etc/os-release 2>/dev/null || true',
      );
      final output = utf8.decode(osRelease);

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
      if (id != null || name != null) {
        return DistroInfo(
          id: id ?? name!.toLowerCase(),
          name: name ?? id!,
          version: map['VERSION_ID'],
          prettyName: map['PRETTY_NAME'],
        );
      }

      // /etc/os-release is Linux-specific. uname works on macOS, BSD and
      // other Unix systems; Windows OpenSSH falls through to `ver`.
      final uname = utf8
          .decode(await client.run('uname -s 2>/dev/null || true'))
          .trim();
      final kernel = utf8
          .decode(await client.run('uname -r 2>/dev/null || true'))
          .trim();
      if (uname.isNotEmpty) {
        return DistroInfo(
          id: uname.toLowerCase(),
          name: uname,
          version: kernel.isEmpty ? null : kernel,
          prettyName: kernel.isEmpty ? uname : '$uname $kernel',
        );
      }

      final windows = utf8
          .decode(
            await client.run('cmd /c ver 2>NUL || ver 2>/dev/null || true'),
          )
          .trim();
      if (windows.isNotEmpty && windows.toLowerCase().contains('windows')) {
        return DistroInfo(id: 'windows', name: 'Windows', prettyName: windows);
      }

      return null;
    } catch (e) {
      _log.debug(_tag, 'Distro detection failed: $e');
      return null;
    }
  }

  Future<SSHSocket> _connectSocket(
    String host,
    int port,
    ProxyConfig? proxy,
    ProxyCredentials? proxyCreds,
  ) async {
    const timeout = Duration(seconds: 15);
    if (proxy == null || proxy.type == ProxyType.none) {
      return SSHSocket.connect(host, port, timeout: timeout);
    }
    _log.info(
      _tag,
      'Connecting via ${proxy.type.name} proxy ${proxy.host}:${proxy.port}',
    );
    switch (proxy.type) {
      case ProxyType.socks5:
        return Socks5SSHSocket.connect(
          proxy.host,
          proxy.port,
          host,
          port,
          username: proxy.username,
          password: proxyCreds?.password,
          timeout: timeout,
        );
      case ProxyType.httpConnect:
        return HttpConnectSSHSocket.connect(
          proxy.host,
          proxy.port,
          host,
          port,
          username: proxy.username,
          password: proxyCreds?.password,
          timeout: timeout,
        );
      case ProxyType.none:
        return SSHSocket.connect(host, port, timeout: timeout);
    }
  }

  void disconnect(SSHClient client) {
    _log.info(_tag, 'Disconnecting SSH client');
    client.close();
  }
}
