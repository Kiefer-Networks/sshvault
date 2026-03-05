import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartssh2/src/socket/ssh_socket.dart';
import 'package:socks5_proxy/socks_client.dart';

/// SSHSocket implementation that connects through a SOCKS5 proxy.
class Socks5SSHSocket implements SSHSocket {
  final Socket _socket;

  Socks5SSHSocket._(this._socket);

  /// Connects to [targetHost]:[targetPort] via a SOCKS5 proxy at
  /// [proxyHost]:[proxyPort]. Optional [username]/[password] for proxy auth.
  static Future<Socks5SSHSocket> connect(
    String proxyHost,
    int proxyPort,
    String targetHost,
    int targetPort, {
    String? username,
    String? password,
    Duration? timeout,
  }) async {
    final proxyAddress = InternetAddress(proxyHost);
    final targetAddress = InternetAddress(
      targetHost,
      type: InternetAddressType.unix,
    );

    final proxy = ProxySettings(
      proxyAddress,
      proxyPort,
      username: username,
      password: password,
    );

    final Socket socket;
    if (timeout != null) {
      socket = await SocksTCPClient.connect(
        [proxy],
        targetAddress,
        targetPort,
      ).timeout(timeout);
    } else {
      socket = await SocksTCPClient.connect(
        [proxy],
        targetAddress,
        targetPort,
      );
    }

    return Socks5SSHSocket._(socket);
  }

  @override
  Stream<Uint8List> get stream => _socket;

  @override
  StreamSink<List<int>> get sink => _socket;

  @override
  Future<void> close() async {
    await _socket.close();
  }

  @override
  Future<void> get done => _socket.done;

  @override
  void destroy() {
    _socket.destroy();
  }

  @override
  String toString() {
    return 'Socks5SSHSocket(${_socket.remoteAddress.host}:${_socket.remotePort})';
  }
}
