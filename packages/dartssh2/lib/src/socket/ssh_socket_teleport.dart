import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartssh2/src/socket/ssh_socket.dart';

/// An [SSHSocket] that connects to a Teleport proxy via TLS with ALPN
/// protocol negotiation (`teleport-proxy-ssh`).
///
/// Teleport tunnels SSH traffic inside a TLS connection using ALPN to
/// multiplex protocols on a single port (typically 443). The client opens a
/// [SecureSocket] with `supportedProtocols: ['teleport-proxy-ssh']`, and the
/// proxy routes the connection to the SSH service.
///
/// Usage:
/// ```dart
/// final socket = await TeleportSSHSocket.connect(
///   'teleport.example.com',
///   443,
///   tlsCertificateBytes: clientCertPem,
///   tlsPrivateKeyBytes: clientKeyPem,
/// );
/// final client = SSHClient(socket, ...);
/// ```
class TeleportSSHSocket implements SSHSocket {
  final SecureSocket _socket;

  TeleportSSHSocket._(this._socket);

  /// Connects to a Teleport proxy and performs TLS+ALPN negotiation.
  ///
  /// [host] and [port] identify the Teleport proxy (usually port 443).
  ///
  /// [securityContext] is an optional pre-configured [SecurityContext] with
  /// client certificates loaded. If provided, [tlsCertificateBytes] and
  /// [tlsPrivateKeyBytes] are ignored.
  ///
  /// [tlsCertificateBytes] and [tlsPrivateKeyBytes] are PEM-encoded client
  /// certificate and private key used for mutual TLS. A temporary
  /// [SecurityContext] will be created from them if [securityContext] is null.
  ///
  /// [alpnProtocol] defaults to `teleport-proxy-ssh` which is the standard
  /// Teleport ALPN protocol for SSH tunneling.
  ///
  /// [timeout] limits the connection attempt duration.
  ///
  /// [onBadCertificate] can be used to accept self-signed or otherwise
  /// invalid server certificates (use with caution).
  static Future<TeleportSSHSocket> connect(
    String host,
    int port, {
    SecurityContext? securityContext,
    List<int>? tlsCertificateBytes,
    List<int>? tlsPrivateKeyBytes,
    String alpnProtocol = 'teleport-proxy-ssh',
    Duration? timeout,
    bool Function(X509Certificate)? onBadCertificate,
  }) async {
    final context = securityContext ??
        _buildSecurityContext(
          tlsCertificateBytes: tlsCertificateBytes,
          tlsPrivateKeyBytes: tlsPrivateKeyBytes,
        );

    final socket = await SecureSocket.connect(
      host,
      port,
      context: context,
      supportedProtocols: [alpnProtocol],
      timeout: timeout,
      onBadCertificate: onBadCertificate,
    );

    return TeleportSSHSocket._(socket);
  }

  /// Creates a [TeleportSSHSocket] from an already-connected [SecureSocket].
  ///
  /// Use this when you have an existing TLS connection (e.g. after a
  /// WebSocket upgrade fallback).
  factory TeleportSSHSocket.fromSecureSocket(SecureSocket socket) {
    return TeleportSSHSocket._(socket);
  }

  static SecurityContext _buildSecurityContext({
    List<int>? tlsCertificateBytes,
    List<int>? tlsPrivateKeyBytes,
  }) {
    final context = SecurityContext(withTrustedRoots: true);

    if (tlsCertificateBytes != null) {
      context.useCertificateChainBytes(tlsCertificateBytes);
    }

    if (tlsPrivateKeyBytes != null) {
      context.usePrivateKeyBytes(tlsPrivateKeyBytes);
    }

    return context;
  }

  /// The ALPN protocol selected by the server, or null if none.
  String? get selectedProtocol => _socket.selectedProtocol;

  @override
  Stream<Uint8List> get stream => _socket;

  @override
  StreamSink<List<int>> get sink => _socket;

  @override
  Future<void> get done => _socket.done;

  @override
  Future<void> close() async {
    await _socket.close();
  }

  @override
  void destroy() {
    _socket.destroy();
  }

  @override
  String toString() {
    final address = '${_socket.remoteAddress.host}:${_socket.remotePort}';
    final proto = selectedProtocol ?? 'none';
    return 'TeleportSSHSocket($address, alpn: $proto)';
  }
}
