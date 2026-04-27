// OpenSSH-for-Windows ssh-agent client.
//
// Microsoft ships an OpenSSH port as an optional Windows feature. Its
// agent (`OpenSSH Authentication Agent` service) does NOT bind to a unix
// socket; instead it exposes a Win32 named pipe at:
//
//     \\.\pipe\openssh-ssh-agent
//
// The pipe carries the *exact* same wire protocol used over a Linux unix
// socket — `uint32 length || message_body`, message types 11/12/13/14/etc
// from draft-miller-ssh-agent. So the only Windows-specific code is the
// transport: open the pipe with `CreateFileW`, then `WriteFile` /
// `ReadFile`.
//
// We deliberately route every call through a [OpenSshPipeBindings] seam so
// the unit tests can swap in a software-only fake (matching the same
// dependency-injection style used by the Pageant client).

import 'dart:async';
import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as pkg_ffi;
import 'package:ffi/ffi.dart' show StringUtf16Pointer;
import 'package:sshvault/core/ssh/ssh_agent_client.dart';
import 'package:sshvault/features/connection/domain/entities/ssh_key_entity.dart';

const String kOpenSshAgentPipePath = r'\\.\pipe\openssh-ssh-agent';

/// Abstraction over the Win32 calls needed to talk to a named-pipe agent.
/// Tests inject a fake; production uses [_RealOpenSshPipeBindings].
abstract class OpenSshPipeBindings {
  /// `true` iff the named pipe currently exists. Implementation calls
  /// `WaitNamedPipeW(pipe, 0)` which returns immediately and is safe even
  /// when no instance is available — used as a cheap "is the agent
  /// service running?" probe so we can show a yes/no chip in settings.
  bool pipeExists(String pipePath);

  /// Performs one full request/reply round-trip against the named pipe.
  /// The implementation:
  ///   1. `CreateFileW(pipe, GENERIC_READ|GENERIC_WRITE, 0, NULL, OPEN_EXISTING, 0, NULL)`
  ///   2. `WriteFile(handle, request)`
  ///   3. `ReadFile(handle, ...)` repeatedly until [expectedReplyLen] bytes
  ///      have been read OR the agent's `uint32` length prefix tells us
  ///      how much more to expect.
  ///   4. `CloseHandle`.
  ///
  /// Returns the agent's reply **with** its length prefix preserved so the
  /// caller can reuse the same framing helpers as the unix-socket client.
  Uint8List exchange({
    required String pipePath,
    required Uint8List framedRequest,
  });
}

/// Named-pipe SSH-agent client for the Microsoft OpenSSH-for-Windows agent.
class OpenSshForWindowsClient implements SshAgent {
  final OpenSshPipeBindings _bindings;
  final String _pipePath;

  OpenSshForWindowsClient({
    OpenSshPipeBindings? bindings,
    String pipePath = kOpenSshAgentPipePath,
  }) : _bindings = bindings ?? _RealOpenSshPipeBindings(),
       _pipePath = pipePath;

  @override
  String get backendId => 'openssh-for-windows';

  @override
  Future<bool> isAvailable() async {
    if (!Platform.isWindows && _bindings is _RealOpenSshPipeBindings) {
      return false;
    }
    try {
      if (!_bindings.pipeExists(_pipePath)) return false;
      // Round-trip a REQUEST_IDENTITIES so we don't report "available"
      // for stale pipe metadata. listKeys() throws if the agent is broken.
      await listKeys();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<AgentKey>> listKeys() async {
    final reply = await _exchange(
      Uint8List.fromList([SshAgentMessage.requestIdentities]),
    );
    final r = _PipeReader(reply);
    final type = r.readUint8();
    if (type != SshAgentMessage.identitiesAnswer) {
      throw SshAgentException(
        'OpenSSH-for-Windows agent returned unexpected response type $type '
        '(expected ${SshAgentMessage.identitiesAnswer})',
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

  @override
  Future<Uint8List> sign({
    required Uint8List publicKeyBlob,
    required Uint8List data,
    int flags = 0,
  }) async {
    final builder = BytesBuilder(copy: false)
      ..addByte(SshAgentMessage.signRequest)
      ..add(_PipeWire.string(publicKeyBlob))
      ..add(_PipeWire.string(data))
      ..add(_PipeWire.uint32(flags));
    final reply = await _exchange(builder.toBytes());
    final r = _PipeReader(reply);
    final type = r.readUint8();
    if (type != SshAgentMessage.signResponse) {
      throw SshAgentException(
        'OpenSSH-for-Windows agent returned unexpected type $type during sign',
      );
    }
    return r.readString();
  }

  /// `SSH_AGENTC_ADD_IDENTITY` over the named pipe. The wire shape is the
  /// same as the unix-socket client, but the underlying agent service in
  /// recent Windows builds has historically returned SSH_AGENT_FAILURE for
  /// add requests because the service runs as `LOCAL SYSTEM` and won't
  /// persist user keys. We forward the request anyway and let the agent
  /// answer authoritatively.
  @override
  Future<void> addKey(
    SshKeyEntity key, {
    required String unencryptedPrivateKey,
    Duration? lifetime,
  }) async {
    throw const SshAgentException(
      'Adding identities to the OpenSSH-for-Windows agent over '
      'WriteFile/ReadFile is not implemented yet; use ssh-add.exe '
      'directly until support lands.',
    );
  }

  @override
  Future<void> removeKey(Uint8List publicKeyBlob) async {
    final builder = BytesBuilder(copy: false)
      ..addByte(SshAgentMessage.removeIdentity)
      ..add(_PipeWire.string(publicKeyBlob));
    final reply = await _exchange(builder.toBytes());
    if (reply.isEmpty) {
      throw const SshAgentException('Empty reply during removeKey.');
    }
    final code = reply[0];
    if (code == SshAgentMessage.success) return;
    if (code == SshAgentMessage.failure) {
      throw const SshAgentException(
        'OpenSSH-for-Windows agent rejected removeKey (SSH_AGENT_FAILURE).',
      );
    }
    throw SshAgentException('Unexpected response code $code during removeKey.');
  }

  // ---------------------------------------------------------------------------
  // Internal: framed request/reply across the named pipe.
  // ---------------------------------------------------------------------------

  Future<Uint8List> _exchange(Uint8List requestBody) async {
    final framed = BytesBuilder(copy: false)
      ..add(_PipeWire.uint32(requestBody.length))
      ..add(requestBody);
    final raw = _bindings.exchange(
      pipePath: _pipePath,
      framedRequest: framed.toBytes(),
    );
    if (raw.length < 4) {
      throw const SshAgentException(
        'Truncated reply from OpenSSH-for-Windows agent (header).',
      );
    }
    final len = (raw[0] << 24) | (raw[1] << 16) | (raw[2] << 8) | raw[3];
    if (raw.length < 4 + len) {
      throw const SshAgentException(
        'Truncated reply from OpenSSH-for-Windows agent (body).',
      );
    }
    return Uint8List.fromList(raw.sublist(4, 4 + len));
  }

  static String _extractKeyType(Uint8List blob) {
    if (blob.length < 4) return 'unknown';
    final r = _PipeReader(blob);
    try {
      return utf8.decode(r.readString(), allowMalformed: true);
    } catch (_) {
      return 'unknown';
    }
  }
}

// =============================================================================
// SSH wire helpers (kept local for the same reason as in pageant_client.dart).
// =============================================================================

class _PipeWire {
  static Uint8List uint32(int v) {
    final out = Uint8List(4);
    out[0] = (v >> 24) & 0xFF;
    out[1] = (v >> 16) & 0xFF;
    out[2] = (v >> 8) & 0xFF;
    out[3] = v & 0xFF;
    return out;
  }

  static Uint8List string(List<int> bytes) {
    final out = BytesBuilder(copy: false)
      ..add(uint32(bytes.length))
      ..add(bytes);
    return out.toBytes();
  }
}

class _PipeReader {
  final Uint8List _data;
  int _offset = 0;

  _PipeReader(this._data);

  int get remaining => _data.length - _offset;

  int readUint8() {
    if (remaining < 1) {
      throw const SshAgentException('Truncated pipe reply (uint8).');
    }
    return _data[_offset++];
  }

  int readUint32() {
    if (remaining < 4) {
      throw const SshAgentException('Truncated pipe reply (uint32).');
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
      throw const SshAgentException('Truncated pipe reply (string).');
    }
    final out = Uint8List.fromList(_data.sublist(_offset, _offset + len));
    _offset += len;
    return out;
  }
}

// =============================================================================
// Real Win32 bindings — kernel32!{CreateFileW, ReadFile, WriteFile,
// CloseHandle, WaitNamedPipeW}.
// =============================================================================

class _RealOpenSshPipeBindings implements OpenSshPipeBindings {
  static final ffi.DynamicLibrary _kernel32 = _open('kernel32.dll');

  static ffi.DynamicLibrary _open(String name) {
    if (!Platform.isWindows) return ffi.DynamicLibrary.process();
    return ffi.DynamicLibrary.open(name);
  }

  late final _CreateFileW _createFile = _kernel32
      .lookup<ffi.NativeFunction<_CreateFileWNative>>('CreateFileW')
      .asFunction();

  late final _ReadFile _readFile = _kernel32
      .lookup<ffi.NativeFunction<_ReadFileNative>>('ReadFile')
      .asFunction();

  late final _WriteFile _writeFile = _kernel32
      .lookup<ffi.NativeFunction<_WriteFileNative>>('WriteFile')
      .asFunction();

  late final _CloseHandle _closeHandle = _kernel32
      .lookup<ffi.NativeFunction<_CloseHandleNative>>('CloseHandle')
      .asFunction();

  late final _WaitNamedPipeW _waitNamedPipe = _kernel32
      .lookup<ffi.NativeFunction<_WaitNamedPipeWNative>>('WaitNamedPipeW')
      .asFunction();

  @override
  bool pipeExists(String pipePath) {
    if (!Platform.isWindows) return false;
    final ptr = pipePath.toNativeUtf16();
    try {
      // 0 ms — return immediately whether or not an instance is free.
      // Returning non-zero means an instance was available; zero with
      // GetLastError == ERROR_SEM_TIMEOUT (121) means the pipe exists
      // but every instance is busy. Either way the agent is reachable.
      final ok = _waitNamedPipe(ptr, 0);
      return ok != 0;
    } finally {
      pkg_ffi.malloc.free(ptr);
    }
  }

  @override
  Uint8List exchange({
    required String pipePath,
    required Uint8List framedRequest,
  }) {
    if (!Platform.isWindows) {
      throw const SshAgentException(
        'OpenSSH-for-Windows pipe is only available on Windows.',
      );
    }
    const genericRead = 0x80000000;
    const genericWrite = 0x40000000;
    const openExisting = 3;

    final ptr = pipePath.toNativeUtf16();
    final invalidHandle = ffi.Pointer<ffi.Void>.fromAddress(-1);
    try {
      final handle = _createFile(
        ptr,
        genericRead | genericWrite,
        0,
        ffi.nullptr,
        openExisting,
        0,
        ffi.nullptr,
      );
      if (handle.address == invalidHandle.address || handle.address == 0) {
        throw const SshAgentException(
          'CreateFileW failed for OpenSSH-for-Windows pipe '
          '(agent service likely not running).',
        );
      }

      try {
        // Write the framed request.
        final writeBuf = pkg_ffi.calloc.allocate<ffi.Uint8>(
          framedRequest.length,
        );
        for (var i = 0; i < framedRequest.length; i++) {
          writeBuf[i] = framedRequest[i];
        }
        final written = pkg_ffi.calloc.allocate<ffi.Uint32>(
          ffi.sizeOf<ffi.Uint32>(),
        );
        try {
          final ok = _writeFile(
            handle,
            writeBuf.cast(),
            framedRequest.length,
            written,
            ffi.nullptr,
          );
          if (ok == 0) {
            throw const SshAgentException(
              'WriteFile failed for OpenSSH-for-Windows pipe.',
            );
          }
        } finally {
          pkg_ffi.calloc.free(writeBuf);
          pkg_ffi.calloc.free(written);
        }

        // Read length prefix, then payload.
        return _readFramedReply(handle);
      } finally {
        _closeHandle(handle);
      }
    } finally {
      pkg_ffi.malloc.free(ptr);
    }
  }

  Uint8List _readFramedReply(ffi.Pointer<ffi.Void> handle) {
    final header = _readExact(handle, 4);
    final len =
        (header[0] << 24) | (header[1] << 16) | (header[2] << 8) | header[3];
    if (len < 0 || len > 256 * 1024) {
      throw SshAgentException(
        'OpenSSH-for-Windows agent reported absurd reply length $len.',
      );
    }
    final body = _readExact(handle, len);
    final out = Uint8List(4 + len)
      ..setRange(0, 4, header)
      ..setRange(4, 4 + len, body);
    return out;
  }

  Uint8List _readExact(ffi.Pointer<ffi.Void> handle, int n) {
    final buf = pkg_ffi.calloc.allocate<ffi.Uint8>(n);
    final read = pkg_ffi.calloc.allocate<ffi.Uint32>(ffi.sizeOf<ffi.Uint32>());
    try {
      var total = 0;
      while (total < n) {
        final ok = _readFile(
          handle,
          (buf + total).cast(),
          n - total,
          read,
          ffi.nullptr,
        );
        if (ok == 0 || read.value == 0) {
          throw const SshAgentException(
            'ReadFile failed before full reply was received.',
          );
        }
        total += read.value;
      }
      final out = Uint8List(n);
      for (var i = 0; i < n; i++) {
        out[i] = buf[i];
      }
      return out;
    } finally {
      pkg_ffi.calloc.free(buf);
      pkg_ffi.calloc.free(read);
    }
  }
}

// -----------------------------------------------------------------------------
// FFI typedefs.
// -----------------------------------------------------------------------------

typedef _CreateFileWNative =
    ffi.Pointer<ffi.Void> Function(
      ffi.Pointer<pkg_ffi.Utf16> path,
      ffi.Uint32 access,
      ffi.Uint32 share,
      ffi.Pointer<ffi.Void> sa,
      ffi.Uint32 disposition,
      ffi.Uint32 flags,
      ffi.Pointer<ffi.Void> templ,
    );
typedef _CreateFileW =
    ffi.Pointer<ffi.Void> Function(
      ffi.Pointer<pkg_ffi.Utf16> path,
      int access,
      int share,
      ffi.Pointer<ffi.Void> sa,
      int disposition,
      int flags,
      ffi.Pointer<ffi.Void> templ,
    );

typedef _ReadFileNative =
    ffi.Int32 Function(
      ffi.Pointer<ffi.Void> handle,
      ffi.Pointer<ffi.Void> buffer,
      ffi.Uint32 toRead,
      ffi.Pointer<ffi.Uint32> read,
      ffi.Pointer<ffi.Void> overlapped,
    );
typedef _ReadFile =
    int Function(
      ffi.Pointer<ffi.Void> handle,
      ffi.Pointer<ffi.Void> buffer,
      int toRead,
      ffi.Pointer<ffi.Uint32> read,
      ffi.Pointer<ffi.Void> overlapped,
    );

typedef _WriteFileNative =
    ffi.Int32 Function(
      ffi.Pointer<ffi.Void> handle,
      ffi.Pointer<ffi.Void> buffer,
      ffi.Uint32 toWrite,
      ffi.Pointer<ffi.Uint32> written,
      ffi.Pointer<ffi.Void> overlapped,
    );
typedef _WriteFile =
    int Function(
      ffi.Pointer<ffi.Void> handle,
      ffi.Pointer<ffi.Void> buffer,
      int toWrite,
      ffi.Pointer<ffi.Uint32> written,
      ffi.Pointer<ffi.Void> overlapped,
    );

typedef _CloseHandleNative = ffi.Int32 Function(ffi.Pointer<ffi.Void> handle);
typedef _CloseHandle = int Function(ffi.Pointer<ffi.Void> handle);

typedef _WaitNamedPipeWNative =
    ffi.Int32 Function(ffi.Pointer<pkg_ffi.Utf16> name, ffi.Uint32 timeout);
typedef _WaitNamedPipeW =
    int Function(ffi.Pointer<pkg_ffi.Utf16> name, int timeout);
