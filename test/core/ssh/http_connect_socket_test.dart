import 'dart:convert';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'CONNECT preserves coalesced SSH banner and supports stream consumer',
    () async {
      final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      final peers = <Socket>[];
      final subscription = server.listen((peer) {
        peers.add(peer);
        var replied = false;
        peer.listen((data) {
          if (!replied) {
            replied = true;
            peer.write(
              'HTTP/1.1 200 Connection established\r\n\r\nSSH-2.0-test\r\n',
            );
          }
        });
      });
      addTearDown(() async {
        for (final peer in peers) {
          peer.destroy();
        }
        await subscription.cancel();
        await server.close();
      });
      final socket = await HttpConnectSSHSocket.connect(
        '127.0.0.1',
        server.port,
        'example.test',
        22,
        timeout: const Duration(seconds: 2),
      );
      addTearDown(socket.destroy);
      expect(
        utf8.decode(
          await socket.stream.first.timeout(const Duration(seconds: 2)),
        ),
        'SSH-2.0-test\r\n',
      );
    },
  );
}
