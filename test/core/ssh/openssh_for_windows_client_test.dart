// Software-only verification of [OpenSshForWindowsClient] wire framing.
//
// We swap the real CreateFileW/ReadFile/WriteFile-backed bindings for a
// fake that records the bytes the client wrote and replays canned
// responses, so the protocol round-trip can be verified without a real
// OpenSSH agent and without running on Windows.

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:sshvault/core/ssh/openssh_for_windows_client.dart';
import 'package:sshvault/core/ssh/ssh_agent_client.dart';

class _FakePipeBindings implements OpenSshPipeBindings {
  final List<Uint8List> requests = <Uint8List>[];
  final List<Uint8List> _replies;
  int _replyIndex = 0;
  bool exists;

  _FakePipeBindings(this._replies, {this.exists = true});

  @override
  bool pipeExists(String pipePath) => exists;

  @override
  Uint8List exchange({
    required String pipePath,
    required Uint8List framedRequest,
  }) {
    requests.add(Uint8List.fromList(framedRequest));
    final reply = _replies[_replyIndex++];
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
    ..add(_FakePipeBindings._u32(bytes.length))
    ..add(bytes);
  return b.toBytes();
}

Uint8List _ed25519Blob(List<int> pub32) {
  final b = BytesBuilder(copy: false)
    ..add(_str(utf8.encode('ssh-ed25519')))
    ..add(_str(pub32));
  return b.toBytes();
}

void main() {
  group('OpenSshForWindowsClient — named-pipe wire framing', () {
    test('isAvailable: false when pipe does not exist', () async {
      final client = OpenSshForWindowsClient(
        bindings: _FakePipeBindings(const [], exists: false),
      );
      expect(await client.isAvailable(), isFalse);
    });

    test('isAvailable: true after a successful round-trip', () async {
      final reply = BytesBuilder(copy: false)
        ..addByte(SshAgentMessage.identitiesAnswer)
        ..add(_FakePipeBindings._u32(0));
      final client = OpenSshForWindowsClient(
        bindings: _FakePipeBindings([reply.toBytes()]),
      );
      expect(await client.isAvailable(), isTrue);
    });

    test('listKeys: parses two-key IDENTITIES_ANSWER', () async {
      final pub1 = List<int>.filled(32, 0x11);
      final pub2 = List<int>.filled(32, 0x22);
      final reply = BytesBuilder(copy: false)
        ..addByte(SshAgentMessage.identitiesAnswer)
        ..add(_FakePipeBindings._u32(2))
        ..add(_str(_ed25519Blob(pub1)))
        ..add(_str(utf8.encode('one@host')))
        ..add(_str(_ed25519Blob(pub2)))
        ..add(_str(utf8.encode('two@host')));
      final bindings = _FakePipeBindings([reply.toBytes()]);
      final client = OpenSshForWindowsClient(bindings: bindings);

      final keys = await client.listKeys();
      expect(keys, hasLength(2));
      expect(keys[0].comment, 'one@host');
      expect(keys[1].comment, 'two@host');

      // Outgoing framing: uint32 length(=1) || REQUEST_IDENTITIES (11).
      final req = bindings.requests.single;
      expect(req.length, 5);
      expect(req[0], 0);
      expect(req[3], 1);
      expect(req[4], SshAgentMessage.requestIdentities);
    });

    test('sign: parses SIGN_RESPONSE and frames request', () async {
      final reply = BytesBuilder(copy: false)
        ..addByte(SshAgentMessage.signResponse)
        ..add(_str(List<int>.filled(64, 0x77)));
      final bindings = _FakePipeBindings([reply.toBytes()]);
      final client = OpenSshForWindowsClient(bindings: bindings);

      final sig = await client.sign(
        publicKeyBlob: _ed25519Blob(List<int>.filled(32, 0x42)),
        data: Uint8List.fromList([1, 2, 3, 4]),
      );
      expect(sig, hasLength(64));
      expect(sig.every((b) => b == 0x77), isTrue);

      final req = bindings.requests.single;
      // Body length matches reqLength - 4 (the prefix).
      final bodyLen = (req[0] << 24) | (req[1] << 16) | (req[2] << 8) | req[3];
      expect(bodyLen, req.length - 4);
      expect(req[4], SshAgentMessage.signRequest);
    });

    test('removeKey: SUCCESS path consumes single byte response', () async {
      final reply = Uint8List.fromList([SshAgentMessage.success]);
      final bindings = _FakePipeBindings([reply]);
      final client = OpenSshForWindowsClient(bindings: bindings);

      await client.removeKey(_ed25519Blob(List<int>.filled(32, 0x42)));

      final req = bindings.requests.single;
      expect(req[4], SshAgentMessage.removeIdentity);
    });

    test('removeKey: FAILURE path raises SshAgentException', () async {
      final reply = Uint8List.fromList([SshAgentMessage.failure]);
      final bindings = _FakePipeBindings([reply]);
      final client = OpenSshForWindowsClient(bindings: bindings);
      await expectLater(
        client.removeKey(_ed25519Blob(List<int>.filled(32, 0))),
        throwsA(isA<SshAgentException>()),
      );
    });

    test('listKeys: throws on truncated reply', () async {
      // Fake returns *framed* zero-byte body — strip leaves an empty
      // body, so readUint8() throws.
      final bindings = _FakePipeBindings([Uint8List(0)]);
      final client = OpenSshForWindowsClient(bindings: bindings);
      await expectLater(client.listKeys(), throwsA(isA<SshAgentException>()));
    });
  });
}
