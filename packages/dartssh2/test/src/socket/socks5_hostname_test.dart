import 'dart:io';
import 'package:dartssh2/dartssh2.dart';
import 'package:test/test.dart';

void main() {
  test('SOCKS5 accepts a proxy DNS hostname', () async {
    final address = (await InternetAddress.lookup('localhost')).first;
    final server = await ServerSocket.bind(address, 0);
    final peers = <Socket>[];
    final subscription = server.listen((peer) {
      peers.add(peer);
      var greeting = true;
      peer.listen((bytes) {
        if (greeting) {
          greeting = false;
          peer.add([5, 0]);
        } else {
          peer.add([5, 0, 0, 1, 127, 0, 0, 1, 0, 22]);
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
    final socket = await Socks5SSHSocket.connect(
        'localhost', server.port, 'target.example', 22,
        timeout: const Duration(seconds: 2));
    socket.destroy();
  });
}
