// Software-only verification of [PageantClient] wire framing.
//
// We can't unit-test the real Win32 calls portably, so we substitute a
// software [PageantBindings] that captures every request the client emits
// and replays canned replies — exactly the same pattern used by
// `ssh_agent_client_test.dart` for the unix-socket path.

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:sshvault/core/ssh/pageant_client.dart';
import 'package:sshvault/core/ssh/ssh_agent_client.dart';

class _FakePageantBindings implements PageantBindings {
  final List<Uint8List> requests = <Uint8List>[];
  final List<String> mappingNames = <String>[];
  final List<Uint8List> _replies;
  int _replyIndex = 0;
  bool pageantRunning;
  int pid;

  _FakePageantBindings(
    this._replies, {
    this.pageantRunning = true,
    this.pid = 4242,
  });

  @override
  int findPageantWindow() => pageantRunning ? 0xCAFE : 0;

  @override
  int currentProcessId() => pid;

  @override
  Uint8List exchange({
    required int hwnd,
    required String mappingName,
    required Uint8List request,
  }) {
    requests.add(Uint8List.fromList(request));
    mappingNames.add(mappingName);
    final reply = _replies[_replyIndex++];
    // Return reply *with* uint32 length prefix — the real bindings copy
    // both the header and body straight out of the shared mapping, and
    // PageantClient._stripFraming peels off the prefix.
    final framed = BytesBuilder(copy: false)
      ..add(_u32(reply.length))
      ..add(reply);
    return framed.toBytes();
  }

  static Uint8List _u32(int v) => Uint8List.fromList([
    (v >> 24) & 0xFF,
    (v >> 16) & 0xFF,
    (v >> 8) & 0xFF,
    v & 0xFF,
  ]);
}

Uint8List _str(List<int> bytes) {
  final b = BytesBuilder(copy: false)
    ..add(_FakePageantBindings._u32(bytes.length))
    ..add(bytes);
  return b.toBytes();
}

Uint8List _ed25519Blob(List<int> publicKey32) {
  final b = BytesBuilder(copy: false)
    ..add(_str(utf8.encode('ssh-ed25519')))
    ..add(_str(publicKey32));
  return b.toBytes();
}

void main() {
  group('PageantClient — WM_COPYDATA wire framing', () {
    test('isAvailable: true when FindWindow returns non-NULL', () async {
      final client = PageantClient(
        bindings: _FakePageantBindings(const [], pageantRunning: true),
      );
      expect(await client.isAvailable(), isTrue);
    });

    test('isAvailable: false when Pageant is not running', () async {
      final client = PageantClient(
        bindings: _FakePageantBindings(const [], pageantRunning: false),
      );
      expect(await client.isAvailable(), isFalse);
    });

    test('listKeys: parses two-key IDENTITIES_ANSWER', () async {
      final pub1 = List<int>.filled(32, 0xAB);
      final pub2 = List<int>.filled(32, 0xCD);
      final reply = BytesBuilder(copy: false)
        ..addByte(SshAgentMessage.identitiesAnswer)
        ..add(_FakePageantBindings._u32(2))
        ..add(_str(_ed25519Blob(pub1)))
        ..add(_str(utf8.encode('alice@laptop')))
        ..add(_str(_ed25519Blob(pub2)))
        ..add(_str(utf8.encode('bob@server')));
      final bindings = _FakePageantBindings([reply.toBytes()], pid: 4242);
      final client = PageantClient(bindings: bindings);

      final keys = await client.listKeys();
      expect(keys, hasLength(2));
      expect(keys[0].keyType, 'ssh-ed25519');
      expect(keys[0].comment, 'alice@laptop');
      expect(keys[1].comment, 'bob@server');

      // Verify the request the bindings received was framed correctly:
      // uint32 length(=1) || REQUEST_IDENTITIES (11)
      expect(bindings.requests, hasLength(1));
      final req = bindings.requests.first;
      expect(req.length, 5);
      expect(req[0], 0);
      expect(req[1], 0);
      expect(req[2], 0);
      expect(req[3], 1);
      expect(req[4], SshAgentMessage.requestIdentities);

      // Mapping name should encode the current PID.
      expect(bindings.mappingNames.first, 'PageantRequest4242');
    });

    test('listKeys: empty list', () async {
      final reply = BytesBuilder(copy: false)
        ..addByte(SshAgentMessage.identitiesAnswer)
        ..add(_FakePageantBindings._u32(0));
      final client = PageantClient(
        bindings: _FakePageantBindings([reply.toBytes()]),
      );
      expect(await client.listKeys(), isEmpty);
    });

    test('sign: framed request + parses SIGN_RESPONSE blob', () async {
      final reply = BytesBuilder(copy: false)
        ..addByte(SshAgentMessage.signResponse)
        ..add(_str(List<int>.filled(64, 0x99)));
      final bindings = _FakePageantBindings([reply.toBytes()]);
      final client = PageantClient(bindings: bindings);

      final blob = _ed25519Blob(List<int>.filled(32, 0x42));
      final data = Uint8List.fromList(utf8.encode('hello world'));
      final sig = await client.sign(publicKeyBlob: blob, data: data);

      expect(sig, hasLength(64));
      expect(sig.every((b) => b == 0x99), isTrue);

      // Inspect outgoing request.
      final req = bindings.requests.first;
      // First 4 bytes = total body length prefix.
      final bodyLen = (req[0] << 24) | (req[1] << 16) | (req[2] << 8) | req[3];
      expect(bodyLen, req.length - 4);
      // Message type byte = SIGN_REQUEST (13).
      expect(req[4], SshAgentMessage.signRequest);
    });

    test('listKeys: throws when Pageant is not running', () async {
      final client = PageantClient(
        bindings: _FakePageantBindings(const [], pageantRunning: false),
      );
      await expectLater(client.listKeys(), throwsA(isA<SshAgentException>()));
    });

    test('addKey/removeKey throw — not supported via WM_COPYDATA', () async {
      final client = PageantClient(bindings: _FakePageantBindings(const []));
      await expectLater(
        client.removeKey(Uint8List(8)),
        throwsA(isA<SshAgentException>()),
      );
    });

    test('truncated reply surfaces a typed exception', () async {
      // Reply too short to even hold the length prefix.
      final bindings = _FakePageantBindings([Uint8List(0)]);
      final client = PageantClient(bindings: bindings);
      await expectLater(client.listKeys(), throwsA(isA<SshAgentException>()));
    });
  });
}
