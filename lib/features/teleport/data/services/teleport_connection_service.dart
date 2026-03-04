import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/foundation.dart';
import 'package:shellvault/core/services/logging_service.dart';
import 'package:shellvault/features/teleport/data/services/teleport_api_service.dart';
import 'package:shellvault/features/teleport/domain/entities/teleport_node_entity.dart';

class TeleportConnection {
  final SSHClient client;
  final TeleportSSHSocket socket;

  TeleportConnection({required this.client, required this.socket});

  Future<void> close() async {
    client.close();
    await socket.close();
  }
}

class TeleportConnectionService {
  static final _log = LoggingService.instance;
  static const _tag = 'TeleportConnection';

  /// Establishes an SSH connection to a Teleport node via the Teleport proxy.
  ///
  /// 1. Opens a TLS connection to the proxy with ALPN `teleport-proxy-ssh`
  /// 2. Uses the SSH certificate for authentication
  /// 3. Returns an SSHClient ready for shell/SFTP
  Future<TeleportConnection> connect({
    required TeleportNodeEntity node,
    required String proxyHost,
    required int proxyPort,
    required TeleportCertificates certs,
    required String username,
    bool Function(X509Certificate)? onBadCertificate,
  }) async {
    // Reject custom certificate callbacks in release builds to prevent
    // TLS validation bypass (MITM protection).
    assert(
      onBadCertificate == null || kDebugMode,
      'onBadCertificate must not be used in release builds',
    );
    if (!kDebugMode && onBadCertificate != null) {
      onBadCertificate = null;
    }

    _log.info(_tag, 'Connecting to Teleport node ${node.hostname} via $proxyHost:$proxyPort');

    // Parse the private key from the certificate response.
    final keyPairs = SSHKeyPair.fromPem(String.fromCharCodes(certs.privateKey));
    if (keyPairs.isEmpty) {
      throw StateError('No key pair found in certificate response');
    }

    // Wrap the key pair with the SSH certificate.
    final certKeyPair = SSHCertificateKeyPair(
      innerKeyPair: keyPairs.first,
      certificateBlob: certs.sshCert,
    );

    // Open TLS+ALPN connection to the Teleport proxy.
    final socket = await TeleportSSHSocket.connect(
      proxyHost,
      proxyPort,
      tlsCertificateBytes: certs.tlsCert,
      tlsPrivateKeyBytes: certs.privateKey,
      timeout: const Duration(seconds: 15),
      onBadCertificate: onBadCertificate,
    );

    _log.info(_tag, 'TLS+ALPN connected (protocol: ${socket.selectedProtocol})');

    // Create SSH client over the TLS tunnel.
    final client = SSHClient(
      socket,
      username: username,
      identities: [certKeyPair],
      onAuthenticated: () {
        _log.info(_tag, 'SSH authenticated to ${node.hostname}');
      },
    );

    return TeleportConnection(client: client, socket: socket);
  }
}
