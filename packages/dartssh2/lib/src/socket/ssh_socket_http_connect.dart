import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartssh2/src/socket/ssh_socket.dart';

/// SSHSocket implementation that connects through an HTTP CONNECT proxy.
class HttpConnectSSHSocket implements SSHSocket {
  final Socket _socket;
  final Stream<Uint8List> _stream;

  HttpConnectSSHSocket._(this._socket, this._stream);

  /// Connects to [targetHost]:[targetPort] via an HTTP CONNECT proxy at
  /// [proxyHost]:[proxyPort]. Optional [username]/[password] for Basic auth.
  static Future<HttpConnectSSHSocket> connect(
    String proxyHost,
    int proxyPort,
    String targetHost,
    int targetPort, {
    String? username,
    String? password,
    Duration? timeout,
  }) async {
    final socket = await Socket.connect(
      proxyHost,
      proxyPort,
      timeout: timeout,
    );

    // Build CONNECT request
    final buffer = StringBuffer()
      ..write('CONNECT $targetHost:$targetPort HTTP/1.1\r\n')
      ..write('Host: $targetHost:$targetPort\r\n');

    if (username != null && username.isNotEmpty) {
      final credentials =
          base64Encode(utf8.encode('$username:${password ?? ''}'));
      buffer.write('Proxy-Authorization: Basic $credentials\r\n');
    }

    buffer.write('\r\n');

    socket.write(buffer.toString());
    await socket.flush();

    // Read proxy response
    final completer = Completer<void>();
    final responseBuffer = <int>[];
    late final StreamSubscription<Uint8List> sub;
    var connected = false;
    final output = StreamController<Uint8List>(
      onPause: () => sub.pause(),
      onResume: () => sub.resume(),
      onCancel: () => sub.cancel(),
    );

    sub = socket.listen(
      (data) {
        if (connected) {
          output.add(data);
          return;
        }
        responseBuffer.addAll(data);
        final response = latin1.decode(responseBuffer);
        final headerEnd = response.indexOf('\r\n\r\n');
        if (headerEnd >= 0) {
          // Check for 200 status
          final statusLine = response.split('\r\n').first;
          final parts = statusLine.split(' ');
          final statusCode = parts.length > 1 ? int.tryParse(parts[1]) : null;
          if (statusCode == 200) {
            connected = true;
            final remaining = responseBuffer.sublist(headerEnd + 4);
            responseBuffer.clear();
            if (remaining.isNotEmpty) output.add(Uint8List.fromList(remaining));
            completer.complete();
          } else {
            socket.destroy();
            completer.completeError(
              SocketException('HTTP CONNECT failed: $statusLine'),
            );
          }
        } else if (responseBuffer.length > 65536) {
          socket.destroy();
          completer.completeError(
              const SocketException('HTTP CONNECT headers too large'));
        }
      },
      onError: (Object error) {
        if (!completer.isCompleted) {
          completer.completeError(error);
        } else if (connected) {
          output.addError(error);
        }
        output.close();
      },
      onDone: () {
        if (!completer.isCompleted) {
          completer.completeError(
            const SocketException('Connection closed during HTTP CONNECT'),
          );
        }
      },
    );

    try {
      if (timeout != null) {
        await completer.future.timeout(timeout);
      } else {
        await completer.future;
      }
    } catch (_) {
      socket.destroy();
      await sub.cancel();
      output.close();
      rethrow;
    }

    return HttpConnectSSHSocket._(socket, output.stream);
  }

  @override
  Stream<Uint8List> get stream => _stream;

  @override
  StreamSink<List<int>> get sink => _socket;

  @override
  Future<void> flush() => _socket.flush();

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
    final address = '${_socket.remoteAddress.host}:${_socket.remotePort}';
    return 'HttpConnectSSHSocket($address)';
  }
}
