// SSH agent client (pure Dart).
//
// Implements the OpenSSH agent wire protocol as documented in
// draft-miller-ssh-agent (the de-facto standard referenced by SSHVault's
// agent-integration spec as "RFC 4252 SSH-agent protocol").
//
// Supported message types:
//   SSH_AGENTC_REQUEST_IDENTITIES (11)  -> SSH_AGENT_IDENTITIES_ANSWER (12)
//   SSH_AGENTC_SIGN_REQUEST       (13)  -> SSH_AGENT_SIGN_RESPONSE     (14)
//   SSH_AGENTC_ADD_IDENTITY       (17)  -> SSH_AGENT_SUCCESS / FAILURE
//   SSH_AGENTC_REMOVE_IDENTITY    (18)  -> SSH_AGENT_SUCCESS / FAILURE
//   SSH_AGENTC_ADD_ID_CONSTRAINED (25)  -> used when a lifetime is supplied
//
// All wire integers are big-endian uint32 length-prefixed strings, mirroring
// the SSH binary packet protocol's "string" encoding (RFC 4251 §5).
//
// The client connects to the AF_UNIX socket pointed to by `$SSH_AUTH_SOCK`
// and is therefore Linux/macOS only. On Windows or in environments without
// an agent the higher-level providers should call [isAvailable] first and
// degrade gracefully.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:sshvault/features/connection/domain/entities/ssh_key_entity.dart';
import 'package:sshvault/core/ssh/windows_ssh_agent.dart';

/// Message type codes (draft-miller-ssh-agent §5.1).
class SshAgentMessage {
  static const int failure = 5;
  static const int success = 6;
  static const int requestIdentities = 11;
  static const int identitiesAnswer = 12;
  static const int signRequest = 13;
  static const int signResponse = 14;
  static const int addIdentity = 17;
  static const int removeIdentity = 18;
  static const int removeAllIdentities = 19;
  static const int addIdConstrained = 25;

  // Constraint extensions used when adding constrained identities.
  static const int constraintLifetime = 1;
  static const int constraintConfirm = 2;
}

/// Public-key material returned by `SSH_AGENT_IDENTITIES_ANSWER`.
///
/// [keyBlob] is the raw SSH wire-format public key (the bytes that, when
/// base64-encoded, sit between the algorithm name and the comment in an
/// `authorized_keys` line). [comment] is the operator-supplied label.
/// [keyType] is the algorithm identifier extracted from the blob, e.g.
/// `ssh-ed25519`, `ssh-rsa`, `ecdsa-sha2-nistp256`.
class AgentKey {
  final Uint8List keyBlob;
  final String comment;
  final String keyType;

  const AgentKey({
    required this.keyBlob,
    required this.comment,
    required this.keyType,
  });

  /// `authorized_keys`-style public key line: `<type> <base64-blob> <comment>`.
  String toAuthorizedKeyLine() {
    final b64 = base64.encode(keyBlob);
    return comment.isEmpty ? '$keyType $b64' : '$keyType $b64 $comment';
  }

  @override
  String toString() => 'AgentKey($keyType, "$comment")';
}

/// Thrown when the agent returns SSH_AGENT_FAILURE or otherwise misbehaves.
class SshAgentException implements Exception {
  final String message;
  const SshAgentException(this.message);
  @override
  String toString() => 'SshAgentException: $message';
}

/// Cross-platform SSH-agent surface implemented by both [SshAgentClient]
/// (Linux/macOS unix-socket) and `WindowsSshAgent` (named-pipe + Pageant
/// shared-memory). Higher layers should program against this interface and
/// obtain an instance via [SshAgentClient.create].
///
/// Methods that aren't supported by a transport (e.g. Pageant doesn't expose
/// add/remove over its WM_COPYDATA protocol) throw [SshAgentException] so
/// callers can surface a clear error.
abstract class SshAgent {
  Future<bool> isAvailable();
  Future<List<AgentKey>> listKeys();
  Future<Uint8List> sign({
    required Uint8List publicKeyBlob,
    required Uint8List data,
    int flags = 0,
  });
  Future<void> addKey(
    SshKeyEntity key, {
    required String unencryptedPrivateKey,
    Duration? lifetime,
  });
  Future<void> removeKey(Uint8List publicKeyBlob);

  /// Human-readable label, e.g. `unix-socket`, `openssh-for-windows`,
  /// `pageant`. Surfaced read-only in the security settings UI so the user
  /// knows which backend is actually in use.
  String get backendId;
}

/// Pure-Dart SSH agent client.
///
/// Each public method opens a fresh connection to `$SSH_AUTH_SOCK`, sends a
/// single request, reads exactly one response, and closes the socket. This
/// matches how `ssh-add` / OpenSSH itself talk to the agent and avoids any
/// long-lived socket state.
class SshAgentClient implements SshAgent {
  /// Override for tests. When non-null, [connect] is used instead of opening
  /// the unix socket at `$SSH_AUTH_SOCK`. Callers must return a fresh
  /// [Socket]-compatible duplex stream on each invocation.
  final Future<Socket> Function()? _connectOverride;

  /// Override for [Platform.environment] reads (for tests).
  final Map<String, String>? _environment;

  const SshAgentClient({
    Future<Socket> Function()? connect,
    Map<String, String>? environment,
  }) : _connectOverride = connect,
       _environment = environment;

  @override
  String get backendId => 'unix-socket';

  /// Platform-aware factory. Linux/macOS get the unix-socket client; Windows
  /// gets the [WindowsSshAgent] facade which transparently picks between
  /// OpenSSH-for-Windows (named pipe `\\.\pipe\openssh-ssh-agent`) and
  /// Pageant (PuTTY's WM_COPYDATA + shared-memory protocol).
  ///
  /// The import is deferred via a relative path so test-only code that
  /// already constructs `SshAgentClient(...)` directly continues to work
  /// unchanged.
  static SshAgent create() {
    if (Platform.isWindows) {
      // The facade is safe to import on any platform; its FFI calls only
      // fire on Windows (every method short-circuits via Platform.isWindows
      // guards), so non-Windows test runs that accidentally instantiate it
      // simply report the agent as unavailable.
      return WindowsSshAgent();
    }
    return const SshAgentClient();
  }

  /// The path the client will try to connect to.
  String? get socketPath {
    final env = _environment ?? Platform.environment;
    return env['SSH_AUTH_SOCK'];
  }

  /// Returns true when `$SSH_AUTH_SOCK` is set, the socket exists, and a
  /// `SSH_AGENTC_REQUEST_IDENTITIES` round-trip succeeds. Catches every
  /// error so callers can use this as a guard without try/catch.
  @override
  Future<bool> isAvailable() async {
    final path = socketPath;
    if (path == null || path.isEmpty) return false;
    if (_connectOverride == null &&
        !FileSystemEntity.isFileSync(path) &&
        !FileSystemEntity.isLinkSync(path) &&
        FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      return false;
    }
    try {
      await listKeys();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// `SSH_AGENTC_REQUEST_IDENTITIES`. Returns the keys currently held by the
  /// agent. An empty list is a valid response (agent is running but holds
  /// no keys).
  @override
  Future<List<AgentKey>> listKeys() async {
    final reply = await _exchange(
      _SshWire.message(SshAgentMessage.requestIdentities),
    );
    final r = _SshReader(reply);
    final type = r.readUint8();
    if (type != SshAgentMessage.identitiesAnswer) {
      throw SshAgentException(
        'Unexpected response type $type (expected ${SshAgentMessage.identitiesAnswer})',
      );
    }
    final count = r.readUint32();
    final keys = <AgentKey>[];
    for (var i = 0; i < count; i++) {
      final blob = r.readString();
      final comment = utf8.decode(r.readString(), allowMalformed: true);
      keys.add(
        AgentKey(
          keyBlob: blob,
          comment: comment,
          keyType: _extractKeyType(blob),
        ),
      );
    }
    return keys;
  }

  /// `SSH_AGENTC_ADD_IDENTITY` / `SSH_AGENTC_ADD_ID_CONSTRAINED`.
  ///
  /// Builds the agent-format private-key payload for the supplied SSHVault
  /// key. The caller must have already decrypted any passphrase-protected
  /// material — this method takes the plain OpenSSH-format private key in
  /// [unencryptedPrivateKey].
  ///
  /// Pass [lifetime] to have the agent auto-evict the key after the given
  /// duration. A null or zero lifetime means "keep until ssh-add -d".
  @override
  Future<void> addKey(
    SshKeyEntity key, {
    required String unencryptedPrivateKey,
    Duration? lifetime,
  }) async {
    final payload = _AgentPrivateKeyEncoder.encode(
      key: key,
      unencryptedPrivateKey: unencryptedPrivateKey,
    );

    final builder = BytesBuilder(copy: false);
    final useConstraints = lifetime != null && lifetime.inSeconds > 0;
    builder.addByte(
      useConstraints
          ? SshAgentMessage.addIdConstrained
          : SshAgentMessage.addIdentity,
    );
    builder.add(payload);
    if (useConstraints) {
      builder.addByte(SshAgentMessage.constraintLifetime);
      builder.add(_SshWire.uint32(lifetime.inSeconds));
    }

    final reply = await _exchange(builder.toBytes());
    _expectSuccess(reply, 'addKey');
  }

  /// `SSH_AGENTC_REMOVE_IDENTITY`. [publicKeyBlob] is the raw wire-format
  /// blob (matching [AgentKey.keyBlob]).
  @override
  Future<void> removeKey(Uint8List publicKeyBlob) async {
    final builder = BytesBuilder(copy: false);
    builder.addByte(SshAgentMessage.removeIdentity);
    builder.add(_SshWire.string(publicKeyBlob));
    final reply = await _exchange(builder.toBytes());
    _expectSuccess(reply, 'removeKey');
  }

  /// `SSH_AGENTC_SIGN_REQUEST`. Asks the agent to sign [data] using the key
  /// identified by [publicKeyBlob]. Returns the SSH-format signature blob.
  @override
  Future<Uint8List> sign({
    required Uint8List publicKeyBlob,
    required Uint8List data,
    int flags = 0,
  }) async {
    final builder = BytesBuilder(copy: false);
    builder.addByte(SshAgentMessage.signRequest);
    builder.add(_SshWire.string(publicKeyBlob));
    builder.add(_SshWire.string(data));
    builder.add(_SshWire.uint32(flags));

    final reply = await _exchange(builder.toBytes());
    final r = _SshReader(reply);
    final type = r.readUint8();
    if (type != SshAgentMessage.signResponse) {
      throw SshAgentException('Unexpected response type $type during sign');
    }
    return r.readString();
  }

  // ---------------------------------------------------------------------------
  // Internal: framed request/reply
  // ---------------------------------------------------------------------------

  Future<Uint8List> _exchange(Uint8List requestBody) async {
    final socket = await _openSocket();
    try {
      final framed = BytesBuilder(copy: false);
      framed.add(_SshWire.uint32(requestBody.length));
      framed.add(requestBody);
      socket.add(framed.toBytes());
      await socket.flush();

      final reply = await _readFramedMessage(socket);
      return reply;
    } finally {
      try {
        await socket.close();
      } catch (_) {}
    }
  }

  Future<Socket> _openSocket() async {
    final override = _connectOverride;
    if (override != null) return await override();
    final path = socketPath;
    if (path == null || path.isEmpty) {
      throw const SshAgentException(
        'SSH_AUTH_SOCK is not set; no ssh-agent available.',
      );
    }
    return Socket.connect(
      InternetAddress(path, type: InternetAddressType.unix),
      0,
    );
  }

  /// Reads a single length-prefixed message from [socket].
  ///
  /// The agent protocol frames every message as `uint32 length || payload`.
  /// We accumulate stream chunks until we have the full payload, then return
  /// it. If the socket closes before the full length is delivered we throw.
  static Future<Uint8List> _readFramedMessage(Stream<List<int>> socket) async {
    final buffer = BytesBuilder(copy: false);
    int? expected;
    final completer = Completer<Uint8List>();

    late StreamSubscription<List<int>> sub;
    sub = socket.listen(
      (chunk) {
        buffer.add(chunk);
        if (expected == null && buffer.length >= 4) {
          final all = buffer.toBytes();
          expected = (all[0] << 24) | (all[1] << 16) | (all[2] << 8) | all[3];
          buffer.clear();
          if (all.length > 4) buffer.add(all.sublist(4));
        }
        if (expected != null && buffer.length >= expected!) {
          final all = buffer.toBytes();
          final payload = Uint8List.fromList(all.sublist(0, expected!));
          if (!completer.isCompleted) completer.complete(payload);
          sub.cancel();
        }
      },
      onError: (Object e, StackTrace st) {
        if (!completer.isCompleted) completer.completeError(e, st);
      },
      onDone: () {
        if (!completer.isCompleted) {
          completer.completeError(
            const SshAgentException(
              'Agent closed the connection before sending a complete reply.',
            ),
          );
        }
      },
      cancelOnError: true,
    );

    return completer.future;
  }

  void _expectSuccess(Uint8List reply, String op) {
    if (reply.isEmpty) {
      throw SshAgentException('Empty reply during $op');
    }
    final code = reply[0];
    if (code == SshAgentMessage.success) return;
    if (code == SshAgentMessage.failure) {
      throw SshAgentException('Agent rejected $op (SSH_AGENT_FAILURE)');
    }
    throw SshAgentException('Unexpected response code $code during $op');
  }

  static String _extractKeyType(Uint8List blob) {
    if (blob.length < 4) return 'unknown';
    final r = _SshReader(blob);
    try {
      return utf8.decode(r.readString(), allowMalformed: true);
    } catch (_) {
      return 'unknown';
    }
  }
}

// =============================================================================
// SSH binary packet wire encoding helpers.
// =============================================================================

class _SshWire {
  static Uint8List uint32(int v) {
    final out = Uint8List(4);
    out[0] = (v >> 24) & 0xFF;
    out[1] = (v >> 16) & 0xFF;
    out[2] = (v >> 8) & 0xFF;
    out[3] = v & 0xFF;
    return out;
  }

  static Uint8List string(List<int> bytes) {
    final out = BytesBuilder(copy: false);
    out.add(uint32(bytes.length));
    out.add(bytes);
    return out.toBytes();
  }

  static Uint8List sshString(String s) => string(utf8.encode(s));

  static Uint8List message(int type) {
    final out = Uint8List(1);
    out[0] = type;
    return out;
  }
}

class _SshReader {
  final Uint8List _data;
  int _offset = 0;

  _SshReader(this._data);

  int get remaining => _data.length - _offset;

  int readUint8() {
    if (remaining < 1) {
      throw const SshAgentException('Truncated agent reply (uint8)');
    }
    return _data[_offset++];
  }

  int readUint32() {
    if (remaining < 4) {
      throw const SshAgentException('Truncated agent reply (uint32)');
    }
    final v =
        (_data[_offset] << 24) |
        (_data[_offset + 1] << 16) |
        (_data[_offset + 2] << 8) |
        _data[_offset + 3];
    _offset += 4;
    return v;
  }

  Uint8List readString() {
    final len = readUint32();
    if (remaining < len) {
      throw const SshAgentException('Truncated agent reply (string)');
    }
    final out = Uint8List.fromList(_data.sublist(_offset, _offset + len));
    _offset += len;
    return out;
  }
}

// =============================================================================
// Agent private-key payload encoder.
// =============================================================================

/// Builds the wire-format payload that follows the SSH_AGENTC_ADD_IDENTITY
/// header byte.
///
/// Per draft-miller-ssh-agent §3.2:
///
///     byte SSH_AGENTC_ADD_IDENTITY
///     string key_type
///     <key-type-specific fields>
///     string comment
///
/// Only `ssh-ed25519` is fully implemented today; other types raise an
/// `SshAgentException` so the UI can surface a clear error. Ed25519 is the
/// dominant algorithm SSHVault generates and matches the most common use case
/// (loading SSHVault-managed keys into the running agent).
class _AgentPrivateKeyEncoder {
  static Uint8List encode({
    required SshKeyEntity key,
    required String unencryptedPrivateKey,
  }) {
    // Determine algorithm from the public-key line if present; fall back to
    // the entity's enum name.
    final algo = _detectAlgorithm(key);
    if (algo != 'ssh-ed25519') {
      throw SshAgentException(
        'Adding $algo keys to ssh-agent is not yet implemented; '
        'currently only ssh-ed25519 is supported via SSHVault.',
      );
    }
    final ed25519 = _parseOpenSshEd25519(unencryptedPrivateKey);
    final builder = BytesBuilder(copy: false)
      ..add(_SshWire.sshString('ssh-ed25519'))
      // ENC(A) — the 32-byte public key.
      ..add(_SshWire.string(ed25519.publicKey))
      // k || ENC(A) — the 64-byte secret (seed || public).
      ..add(_SshWire.string(ed25519.secret))
      ..add(
        _SshWire.sshString(
          ed25519.comment.isEmpty ? key.comment : ed25519.comment,
        ),
      );
    return builder.toBytes();
  }

  static String _detectAlgorithm(SshKeyEntity key) {
    final pub = key.publicKey.trim();
    if (pub.isNotEmpty) {
      final firstSpace = pub.indexOf(' ');
      if (firstSpace > 0) return pub.substring(0, firstSpace);
    }
    // Map enum name to wire identifier. ed25519 is what we currently support.
    final name = key.keyType.toString().split('.').last;
    if (name.startsWith('ed25519')) return 'ssh-ed25519';
    if (name == 'rsa') return 'ssh-rsa';
    if (name.startsWith('ecdsa')) return 'ecdsa-sha2-${name.substring(5)}';
    return name;
  }

  static _Ed25519Parts _parseOpenSshEd25519(String pem) {
    final lines = pem.trim().split('\n');
    final b64 = lines.where((l) => !l.startsWith('-----')).join();
    final bytes = Uint8List.fromList(base64.decode(b64));

    int off = 0;
    const magic = 'openssh-key-v1\x00';
    if (bytes.length < magic.length ||
        utf8.decode(bytes.sublist(0, magic.length)) != magic) {
      throw const SshAgentException(
        'Private key is not in OpenSSH format; cannot add to agent.',
      );
    }
    off += magic.length;

    int readU32() {
      final v =
          (bytes[off] << 24) |
          (bytes[off + 1] << 16) |
          (bytes[off + 2] << 8) |
          bytes[off + 3];
      off += 4;
      return v;
    }

    Uint8List readStr() {
      final n = readU32();
      final s = Uint8List.fromList(bytes.sublist(off, off + n));
      off += n;
      return s;
    }

    final cipher = utf8.decode(readStr());
    if (cipher != 'none') {
      throw const SshAgentException(
        'Encrypted OpenSSH keys must be decrypted before adding to the agent.',
      );
    }
    readStr(); // kdfname
    readStr(); // kdfoptions
    final numKeys = readU32();
    if (numKeys != 1) {
      throw SshAgentException('Unexpected key count $numKeys in OpenSSH file');
    }
    final pubBlob = readStr();
    final privSection = readStr();

    // Parse the public-key half to recover ENC(A).
    int pOff = 0;
    final pTypeLen =
        (pubBlob[0] << 24) |
        (pubBlob[1] << 16) |
        (pubBlob[2] << 8) |
        pubBlob[3];
    pOff = 4 + pTypeLen;
    final pkLen =
        (pubBlob[pOff] << 24) |
        (pubBlob[pOff + 1] << 16) |
        (pubBlob[pOff + 2] << 8) |
        pubBlob[pOff + 3];
    pOff += 4;
    final publicKey = Uint8List.fromList(pubBlob.sublist(pOff, pOff + pkLen));

    // Parse private section: check1 | check2 | type | pub | priv64 | comment.
    int sOff = 8; // skip checkInts
    int sReadU32() {
      final v =
          (privSection[sOff] << 24) |
          (privSection[sOff + 1] << 16) |
          (privSection[sOff + 2] << 8) |
          privSection[sOff + 3];
      sOff += 4;
      return v;
    }

    Uint8List sReadStr() {
      final n = sReadU32();
      final s = Uint8List.fromList(privSection.sublist(sOff, sOff + n));
      sOff += n;
      return s;
    }

    sReadStr(); // type
    sReadStr(); // public key (again)
    final secret = sReadStr(); // 64-byte secret
    final comment = utf8.decode(sReadStr(), allowMalformed: true);

    return _Ed25519Parts(
      publicKey: publicKey,
      secret: secret,
      comment: comment,
    );
  }
}

class _Ed25519Parts {
  final Uint8List publicKey;
  final Uint8List secret;
  final String comment;
  _Ed25519Parts({
    required this.publicKey,
    required this.secret,
    required this.comment,
  });
}
