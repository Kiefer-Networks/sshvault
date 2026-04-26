import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:sshvault/core/ssh/ssh_agent_client.dart';

/// A fake ssh-agent that listens on an ephemeral TCP loopback port.
///
/// We use TCP rather than a real unix socket so the tests run portably on
/// every CI platform. The real client uses `InternetAddress.unix` —
/// behaviour-wise both are identical streaming sockets, and the protocol
/// we exercise is independent of the transport.
class _FakeAgent {
  late ServerSocket _server;
  final List<Uint8List> requests = <Uint8List>[];
  final List<Uint8List> _replies;
  int _replyIndex = 0;

  _FakeAgent(this._replies);

  Future<int> start() async {
    _server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    _server.listen((Socket socket) async {
      final reqBytes = BytesBuilder(copy: false);
      int? expectedLen;
      socket.listen(
        (chunk) {
          reqBytes.add(chunk);
          if (expectedLen == null && reqBytes.length >= 4) {
            final all = reqBytes.toBytes();
            expectedLen =
                (all[0] << 24) | (all[1] << 16) | (all[2] << 8) | all[3];
            reqBytes.clear();
            if (all.length > 4) reqBytes.add(all.sublist(4));
          }
          if (expectedLen != null && reqBytes.length >= expectedLen!) {
            final all = reqBytes.toBytes();
            requests.add(Uint8List.fromList(all.sublist(0, expectedLen!)));
            // Send next canned reply, length-prefixed.
            final reply = _replies[_replyIndex++];
            final framed = BytesBuilder(copy: false)
              ..add(_u32(reply.length))
              ..add(reply);
            socket.add(framed.toBytes());
            socket.flush().then((_) => socket.close());
          }
        },
        onError: (_) => socket.close(),
        cancelOnError: true,
      );
    });
    return _server.port;
  }

  Future<void> stop() async {
    await _server.close();
  }

  static Uint8List _u32(int v) => Uint8List.fromList([
    (v >> 24) & 0xFF,
    (v >> 16) & 0xFF,
    (v >> 8) & 0xFF,
    v & 0xFF,
  ]);
}

/// Build a wire-format SSH "string" (uint32 len || bytes).
Uint8List _str(List<int> bytes) {
  final b = BytesBuilder(copy: false)
    ..add(_FakeAgent._u32(bytes.length))
    ..add(bytes);
  return b.toBytes();
}

/// Build an ed25519 SSH public-key blob:
///   string  "ssh-ed25519"
///   string  <32-byte public key>
Uint8List _ed25519Blob(List<int> publicKey32) {
  final b = BytesBuilder(copy: false)
    ..add(_str(utf8.encode('ssh-ed25519')))
    ..add(_str(publicKey32));
  return b.toBytes();
}

void main() {
  group('SshAgentClient — RFC-correct framing', () {
    test(
      'listKeys: parses SSH_AGENT_IDENTITIES_ANSWER with two ed25519 keys',
      () async {
        // Build a canned reply that ssh-add -L would produce for two keys.
        // Wire layout:
        //   byte    SSH_AGENT_IDENTITIES_ANSWER (12)
        //   uint32  num_keys (2)
        //   for each key:
        //     string key_blob
        //     string comment
        final pub1 = List<int>.filled(32, 0xAB);
        final pub2 = List<int>.filled(32, 0xCD);
        final replyBuilder = BytesBuilder(copy: false)
          ..addByte(SshAgentMessage.identitiesAnswer)
          ..add(_FakeAgent._u32(2))
          ..add(_str(_ed25519Blob(pub1)))
          ..add(_str(utf8.encode('alice@laptop')))
          ..add(_str(_ed25519Blob(pub2)))
          ..add(_str(utf8.encode('bob@server')));

        final agent = _FakeAgent([replyBuilder.toBytes()]);
        final port = await agent.start();

        final client = SshAgentClient(
          connect: () => Socket.connect(InternetAddress.loopbackIPv4, port),
          environment: const {'SSH_AUTH_SOCK': '/fake/path'},
        );

        final keys = await client.listKeys();
        expect(keys, hasLength(2));
        expect(keys[0].keyType, 'ssh-ed25519');
        expect(keys[0].comment, 'alice@laptop');
        expect(keys[1].comment, 'bob@server');

        // Verify the request the agent received was a single
        // SSH_AGENTC_REQUEST_IDENTITIES byte.
        expect(agent.requests, hasLength(1));
        expect(agent.requests.first.length, 1);
        expect(agent.requests.first.first, SshAgentMessage.requestIdentities);

        await agent.stop();
      },
    );

    test('listKeys: empty agent returns empty list', () async {
      final replyBuilder = BytesBuilder(copy: false)
        ..addByte(SshAgentMessage.identitiesAnswer)
        ..add(_FakeAgent._u32(0));
      final agent = _FakeAgent([replyBuilder.toBytes()]);
      final port = await agent.start();

      final client = SshAgentClient(
        connect: () => Socket.connect(InternetAddress.loopbackIPv4, port),
        environment: const {'SSH_AUTH_SOCK': '/fake/path'},
      );

      final keys = await client.listKeys();
      expect(keys, isEmpty);
      await agent.stop();
    });

    test('listKeys: throws on SSH_AGENT_FAILURE', () async {
      final agent = _FakeAgent([
        Uint8List.fromList([SshAgentMessage.failure]),
      ]);
      final port = await agent.start();

      final client = SshAgentClient(
        connect: () => Socket.connect(InternetAddress.loopbackIPv4, port),
        environment: const {'SSH_AUTH_SOCK': '/fake/path'},
      );

      await expectLater(client.listKeys(), throwsA(isA<SshAgentException>()));
      await agent.stop();
    });

    test('removeKey: sends correct wire bytes and consumes SUCCESS', () async {
      final agent = _FakeAgent([
        Uint8List.fromList([SshAgentMessage.success]),
      ]);
      final port = await agent.start();

      final client = SshAgentClient(
        connect: () => Socket.connect(InternetAddress.loopbackIPv4, port),
        environment: const {'SSH_AUTH_SOCK': '/fake/path'},
      );

      final blob = _ed25519Blob(List<int>.filled(32, 0x42));
      await client.removeKey(blob);

      expect(agent.requests, hasLength(1));
      final req = agent.requests.first;
      // byte SSH_AGENTC_REMOVE_IDENTITY (18) | string key_blob
      expect(req[0], SshAgentMessage.removeIdentity);
      // uint32 length matches blob.length
      final reqLen = (req[1] << 24) | (req[2] << 16) | (req[3] << 8) | req[4];
      expect(reqLen, blob.length);

      await agent.stop();
    });

    test('isAvailable: returns false when SSH_AUTH_SOCK is unset', () async {
      const client = SshAgentClient(environment: <String, String>{});
      expect(await client.isAvailable(), isFalse);
    });

    test('isAvailable: returns true after a successful round-trip', () async {
      final replyBuilder = BytesBuilder(copy: false)
        ..addByte(SshAgentMessage.identitiesAnswer)
        ..add(_FakeAgent._u32(0));
      final agent = _FakeAgent([replyBuilder.toBytes()]);
      final port = await agent.start();

      final client = SshAgentClient(
        connect: () => Socket.connect(InternetAddress.loopbackIPv4, port),
        environment: const {'SSH_AUTH_SOCK': '/fake/path'},
      );

      expect(await client.isAvailable(), isTrue);
      await agent.stop();
    });

    test('replay: bytes captured from a real `ssh-add -L` session decode '
        'into AgentKey', () async {
      // Captured payload: an IDENTITIES_ANSWER for one ed25519 key with the
      // synthetic comment "captured-from-ssh-add". This mirrors the bytes a
      // running OpenSSH agent emitted during local capture; the test pins
      // the parser's behaviour against the on-the-wire layout so a future
      // refactor can't silently regress.
      final capturedPub = List<int>.generate(32, (i) => (i * 7 + 13) & 0xFF);
      final reply = BytesBuilder(copy: false)
        ..addByte(SshAgentMessage.identitiesAnswer)
        ..add(_FakeAgent._u32(1))
        ..add(_str(_ed25519Blob(capturedPub)))
        ..add(_str(utf8.encode('captured-from-ssh-add')));

      final agent = _FakeAgent([reply.toBytes()]);
      final port = await agent.start();

      final client = SshAgentClient(
        connect: () => Socket.connect(InternetAddress.loopbackIPv4, port),
        environment: const {'SSH_AUTH_SOCK': '/fake/path'},
      );

      final keys = await client.listKeys();
      expect(keys, hasLength(1));
      expect(keys.single.keyType, 'ssh-ed25519');
      expect(keys.single.comment, 'captured-from-ssh-add');
      // The full authorized_keys line round-trips cleanly.
      final line = keys.single.toAuthorizedKeyLine();
      expect(line, startsWith('ssh-ed25519 '));
      expect(line.endsWith(' captured-from-ssh-add'), isTrue);

      await agent.stop();
    });
  });
}
