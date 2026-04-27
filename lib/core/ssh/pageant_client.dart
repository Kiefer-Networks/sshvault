// Pageant (PuTTY ssh-agent) client.
//
// Pageant predates the unix-domain-socket conventions used by OpenSSH and
// instead exposes its agent over a Windows-specific transport built on top
// of two Win32 primitives:
//
//   1. A hidden top-level window with class+title both set to "Pageant".
//      Detection is `FindWindowW(L"Pageant", L"Pageant")` returning a
//      non-NULL HWND.
//
//   2. A request/reply round-trip per agent operation:
//        a. The client allocates a named shared-memory section
//           `CreateFileMappingW("PageantRequest{processId}", AGENT_MAX_MSGLEN)`.
//        b. The client maps it (`MapViewOfFile`), writes the standard
//           SSH-agent wire-format request — same length-prefixed framing
//           as draft-miller-ssh-agent — into the first bytes.
//        c. The client sends `WM_COPYDATA(0x804E50BA, mapping_name)` to
//           Pageant's HWND. Pageant reads the request from the mapping,
//           processes it, and writes the response back into the same
//           mapping before returning from SendMessage.
//        d. The client reads the response, unmaps, closes the handle.
//
// The wire format inside the mapping is byte-for-byte identical to the
// unix-socket protocol (RFC 4251 §5 strings, draft-miller-ssh-agent message
// types) so we reuse [SshAgentMessage] and the [_PageantWire] helpers.
//
// Limitations: Pageant historically exposes only REQUEST_IDENTITIES (11) /
// IDENTITIES_ANSWER (12) and SIGN_REQUEST (13) / SIGN_RESPONSE (14). It
// does NOT implement SSH_AGENTC_ADD_IDENTITY or SSH_AGENTC_REMOVE_IDENTITY
// over WM_COPYDATA — keys must be added via the Pageant tray UI or
// `pageant.exe key.ppk` on the command line. Calling [addKey] / [removeKey]
// on this client therefore throws [SshAgentException] with a clear message.

import 'dart:async';
import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as pkg_ffi;
// Bring the `toNativeUtf16` String extension into the unprefixed namespace.
// The `Utf16` type itself is referenced via the prefix.
import 'package:ffi/ffi.dart' show StringUtf16Pointer;
import 'package:sshvault/core/ssh/ssh_agent_client.dart';
import 'package:sshvault/features/connection/domain/entities/ssh_key_entity.dart';

/// Pageant's WM_COPYDATA cookie. PuTTY hard-codes this magic in
/// `windows/pageant.c` (`AGENT_COPYDATA_ID`) and every third-party Pageant
/// client must echo it verbatim or the request is silently ignored.
const int kPageantCopyDataId = 0x804E50BA;

/// PuTTY's `AGENT_MAX_MSGLEN`. Hard-coded in `pageant.c`; requests larger
/// than this are rejected.
const int kPageantMaxMessageLen = 8192;

/// `WM_COPYDATA = 0x004A` — sent to deliver an arbitrary blob to another
/// window. We reach for it via FFI because Flutter has no built-in
/// equivalent, and routing through `package:win32`'s `SendMessage` would
/// pull in the full Win32 type system for a single call.
const int kWmCopyData = 0x004A;

/// Tunable carrier for the Win32 entry points Pageant's protocol needs.
/// All methods are typed in plain Dart so the unit tests can substitute a
/// fully software-only fake (see `test/core/ssh/pageant_client_test.dart`).
///
/// The default implementation, [_RealPageantBindings], routes every call
/// through `dart:ffi` against `user32.dll` / `kernel32.dll`. On non-Windows
/// platforms instantiating it throws — the production code path always
/// gates on `Platform.isWindows` first.
abstract class PageantBindings {
  /// Returns the Pageant window handle, or `0` if Pageant is not running.
  /// Mirrors `FindWindowW(L"Pageant", L"Pageant")`.
  int findPageantWindow();

  /// Returns the current process id (`GetCurrentProcessId`). Used to build
  /// a mapping name unique per requesting process so concurrent SSH agents
  /// in the same desktop session don't collide.
  int currentProcessId();

  /// Performs one full round-trip: write [request] into a freshly created
  /// shared-memory section named [mappingName], deliver a `WM_COPYDATA`
  /// message to [hwnd], then read the response back from the same mapping
  /// and return it. Implementations must clean up the mapping and view
  /// regardless of success.
  ///
  /// [request] is the SSH-agent message body **including** the leading
  /// `uint32 length` prefix — exactly the bytes Pageant expects to find
  /// at offset 0 of the mapping.
  Uint8List exchange({
    required int hwnd,
    required String mappingName,
    required Uint8List request,
  });
}

/// Minimal Pageant client. Produces and consumes the same SSH-agent wire
/// format the unix-socket [SshAgentClient] speaks; only the transport
/// differs.
class PageantClient implements SshAgent {
  final PageantBindings _bindings;

  /// Constructs a client. Pass a custom [bindings] in tests; production
  /// callers fall through to [_RealPageantBindings] which uses dart:ffi.
  PageantClient({PageantBindings? bindings})
    : _bindings = bindings ?? _RealPageantBindings();

  @override
  String get backendId => 'pageant';

  /// `true` iff Pageant's hidden window is currently registered. The check
  /// is cheap (a single `FindWindowW`) so callers can poll it without
  /// worrying about cost. We do not perform a full round-trip here because
  /// some Pageant builds reject early requests during start-up; the
  /// simpler "window exists" probe matches what `plink.exe` does.
  @override
  Future<bool> isAvailable() async {
    if (!Platform.isWindows && _bindings is _RealPageantBindings) return false;
    try {
      return _bindings.findPageantWindow() != 0;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<AgentKey>> listKeys() async {
    final reply = await _exchange(
      Uint8List.fromList([SshAgentMessage.requestIdentities]),
    );
    final r = _PageantReader(reply);
    final type = r.readUint8();
    if (type != SshAgentMessage.identitiesAnswer) {
      throw SshAgentException(
        'Pageant returned unexpected response type $type '
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
      ..add(_PageantWire.string(publicKeyBlob))
      ..add(_PageantWire.string(data))
      ..add(_PageantWire.uint32(flags));
    final reply = await _exchange(builder.toBytes());
    final r = _PageantReader(reply);
    final type = r.readUint8();
    if (type != SshAgentMessage.signResponse) {
      throw SshAgentException(
        'Pageant returned unexpected response type $type during sign',
      );
    }
    return r.readString();
  }

  /// Pageant intentionally does not implement
  /// `SSH_AGENTC_ADD_IDENTITY` / `SSH_AGENTC_REMOVE_IDENTITY` over its
  /// WM_COPYDATA channel. PuTTY's design loads keys exclusively via the
  /// tray UI or `pageant.exe key.ppk`. Surfacing a typed exception here
  /// lets the higher layers show "Use Pageant's tray icon to add this
  /// key" rather than failing silently.
  @override
  Future<void> addKey(
    SshKeyEntity key, {
    required String unencryptedPrivateKey,
    Duration? lifetime,
  }) async {
    throw const SshAgentException(
      'Pageant does not expose key-add over its WM_COPYDATA protocol; '
      'use the Pageant tray icon or `pageant.exe key.ppk` instead.',
    );
  }

  @override
  Future<void> removeKey(Uint8List publicKeyBlob) async {
    throw const SshAgentException(
      'Pageant does not expose key-remove over its WM_COPYDATA protocol; '
      'use the Pageant tray icon to delete this identity.',
    );
  }

  // ---------------------------------------------------------------------------
  // Internal: framed request/reply through the shared-memory transport.
  // ---------------------------------------------------------------------------

  Future<Uint8List> _exchange(Uint8List requestBody) async {
    final hwnd = _bindings.findPageantWindow();
    if (hwnd == 0) {
      throw const SshAgentException('Pageant is not running.');
    }
    if (1 + requestBody.length + 4 > kPageantMaxMessageLen) {
      throw SshAgentException(
        'Pageant request exceeds AGENT_MAX_MSGLEN '
        '(${requestBody.length + 4} > $kPageantMaxMessageLen).',
      );
    }
    final framed = BytesBuilder(copy: false)
      ..add(_PageantWire.uint32(requestBody.length))
      ..add(requestBody);
    final mappingName = 'PageantRequest${_bindings.currentProcessId()}';
    final raw = _bindings.exchange(
      hwnd: hwnd,
      mappingName: mappingName,
      request: framed.toBytes(),
    );
    return _stripFraming(raw);
  }

  /// Pageant writes its response with the same `uint32 length || payload`
  /// framing it expects on the request side; strip the prefix so callers
  /// see the raw message body.
  static Uint8List _stripFraming(Uint8List raw) {
    if (raw.length < 4) {
      throw const SshAgentException('Truncated Pageant reply (header).');
    }
    final len = (raw[0] << 24) | (raw[1] << 16) | (raw[2] << 8) | raw[3];
    if (raw.length < 4 + len) {
      throw const SshAgentException('Truncated Pageant reply (body).');
    }
    return Uint8List.fromList(raw.sublist(4, 4 + len));
  }

  static String _extractKeyType(Uint8List blob) {
    if (blob.length < 4) return 'unknown';
    final r = _PageantReader(blob);
    try {
      return utf8.decode(r.readString(), allowMalformed: true);
    } catch (_) {
      return 'unknown';
    }
  }
}

// =============================================================================
// SSH wire helpers — duplicated locally so this file remains self-contained
// and importable on non-Windows platforms without dragging the unix-socket
// client's transitive code into the Windows build.
// =============================================================================

class _PageantWire {
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

class _PageantReader {
  final Uint8List _data;
  int _offset = 0;

  _PageantReader(this._data);

  int get remaining => _data.length - _offset;

  int readUint8() {
    if (remaining < 1) {
      throw const SshAgentException('Truncated Pageant reply (uint8).');
    }
    return _data[_offset++];
  }

  int readUint32() {
    if (remaining < 4) {
      throw const SshAgentException('Truncated Pageant reply (uint32).');
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
      throw const SshAgentException('Truncated Pageant reply (string).');
    }
    final out = Uint8List.fromList(_data.sublist(_offset, _offset + len));
    _offset += len;
    return out;
  }
}

// =============================================================================
// Real Win32 bindings.
//
// We talk to four functions:
//   user32!FindWindowW          — locate the Pageant HWND.
//   user32!SendMessageW         — deliver WM_COPYDATA.
//   kernel32!CreateFileMappingW — allocate the shared section.
//   kernel32!MapViewOfFile      — get a pointer into it.
//   kernel32!UnmapViewOfFile / CloseHandle — clean up.
//   kernel32!GetCurrentProcessId — derive the mapping name.
//
// Constants:
//   PAGE_READWRITE       = 0x04
//   FILE_MAP_WRITE       = 0x0002
//   INVALID_HANDLE_VALUE = -1 (used for system paging file)
// =============================================================================

class _RealPageantBindings implements PageantBindings {
  static final ffi.DynamicLibrary _user32 = _open(
    'user32.dll',
    allowMissing: true,
  );
  static final ffi.DynamicLibrary _kernel32 = _open(
    'kernel32.dll',
    allowMissing: true,
  );

  static ffi.DynamicLibrary _open(String name, {bool allowMissing = false}) {
    if (!Platform.isWindows) {
      // Returning a sentinel keeps `static final` initialisation off the
      // critical path for Linux/macOS smoke tests; lookups against it will
      // throw the moment a real call is attempted.
      return ffi.DynamicLibrary.process();
    }
    return ffi.DynamicLibrary.open(name);
  }

  late final _FindWindowW _findWindow = _user32
      .lookup<ffi.NativeFunction<_FindWindowWNative>>('FindWindowW')
      .asFunction();

  late final _SendMessageW _sendMessage = _user32
      .lookup<ffi.NativeFunction<_SendMessageWNative>>('SendMessageW')
      .asFunction();

  late final _CreateFileMappingW _createFileMapping = _kernel32
      .lookup<ffi.NativeFunction<_CreateFileMappingWNative>>(
        'CreateFileMappingW',
      )
      .asFunction();

  late final _MapViewOfFile _mapViewOfFile = _kernel32
      .lookup<ffi.NativeFunction<_MapViewOfFileNative>>('MapViewOfFile')
      .asFunction();

  late final _UnmapViewOfFile _unmapViewOfFile = _kernel32
      .lookup<ffi.NativeFunction<_UnmapViewOfFileNative>>('UnmapViewOfFile')
      .asFunction();

  late final _CloseHandle _closeHandle = _kernel32
      .lookup<ffi.NativeFunction<_CloseHandleNative>>('CloseHandle')
      .asFunction();

  late final _GetCurrentProcessId _getCurrentProcessId = _kernel32
      .lookup<ffi.NativeFunction<_GetCurrentProcessIdNative>>(
        'GetCurrentProcessId',
      )
      .asFunction();

  @override
  int findPageantWindow() {
    if (!Platform.isWindows) return 0;
    final cls = 'Pageant'.toNativeUtf16();
    final title = 'Pageant'.toNativeUtf16();
    try {
      return _findWindow(cls, title);
    } finally {
      pkg_ffi.malloc.free(cls);
      pkg_ffi.malloc.free(title);
    }
  }

  @override
  int currentProcessId() {
    if (!Platform.isWindows) return 0;
    return _getCurrentProcessId();
  }

  @override
  Uint8List exchange({
    required int hwnd,
    required String mappingName,
    required Uint8List request,
  }) {
    if (!Platform.isWindows) {
      throw const SshAgentException('Pageant is only available on Windows.');
    }
    const pageReadWrite = 0x04;
    const fileMapWrite = 0x0002;
    final invalidHandle = ffi.Pointer<ffi.Void>.fromAddress(-1);

    final namePtr = mappingName.toNativeUtf16();
    final mapping = _createFileMapping(
      invalidHandle,
      ffi.nullptr,
      pageReadWrite,
      0,
      kPageantMaxMessageLen,
      namePtr,
    );
    if (mapping.address == 0) {
      pkg_ffi.malloc.free(namePtr);
      throw const SshAgentException(
        'CreateFileMappingW failed for Pageant request.',
      );
    }
    final view = _mapViewOfFile(
      mapping,
      fileMapWrite,
      0,
      0,
      kPageantMaxMessageLen,
    );
    if (view.address == 0) {
      _closeHandle(mapping);
      pkg_ffi.malloc.free(namePtr);
      throw const SshAgentException(
        'MapViewOfFile failed for Pageant request.',
      );
    }
    try {
      // Copy request into the mapping at offset 0.
      final byteView = view.cast<ffi.Uint8>();
      for (var i = 0; i < request.length; i++) {
        byteView[i] = request[i];
      }

      // Build COPYDATASTRUCT { dwData, cbData, lpData }.
      final cds = pkg_ffi.calloc.allocate<_CopyDataStruct>(
        ffi.sizeOf<_CopyDataStruct>(),
      );
      // ANSI mapping name: Pageant historically expects an ANSI string
      // with a terminating NUL.
      final ansiBytes = utf8.encode(mappingName);
      final cdsName = pkg_ffi.calloc.allocate<ffi.Uint8>(ansiBytes.length + 1);
      for (var i = 0; i < ansiBytes.length; i++) {
        cdsName[i] = ansiBytes[i];
      }
      cdsName[ansiBytes.length] = 0;

      cds.ref.dwData = kPageantCopyDataId;
      cds.ref.cbData = ansiBytes.length + 1;
      cds.ref.lpData = cdsName.cast();

      final rc = _sendMessage(
        hwnd,
        kWmCopyData,
        0,
        cds.cast<ffi.Void>().address,
      );

      pkg_ffi.calloc.free(cdsName);
      pkg_ffi.calloc.free(cds);

      if (rc == 0) {
        throw const SshAgentException(
          'Pageant returned 0 to WM_COPYDATA — request rejected.',
        );
      }

      // Read back the response. Pageant leaves the reply in the mapping,
      // again `uint32 length || payload`.
      final lenBytes = Uint8List(4);
      for (var i = 0; i < 4; i++) {
        lenBytes[i] = byteView[i];
      }
      final len =
          (lenBytes[0] << 24) |
          (lenBytes[1] << 16) |
          (lenBytes[2] << 8) |
          lenBytes[3];
      if (len < 0 || len > kPageantMaxMessageLen - 4) {
        throw SshAgentException('Pageant reported invalid reply length $len.');
      }
      final out = Uint8List(4 + len);
      for (var i = 0; i < 4 + len; i++) {
        out[i] = byteView[i];
      }
      return out;
    } finally {
      _unmapViewOfFile(view);
      _closeHandle(mapping);
      pkg_ffi.malloc.free(namePtr);
    }
  }
}

// -----------------------------------------------------------------------------
// FFI typedefs.
// -----------------------------------------------------------------------------

typedef _FindWindowWNative =
    ffi.IntPtr Function(ffi.Pointer<pkg_ffi.Utf16>, ffi.Pointer<pkg_ffi.Utf16>);
typedef _FindWindowW =
    int Function(ffi.Pointer<pkg_ffi.Utf16>, ffi.Pointer<pkg_ffi.Utf16>);

typedef _SendMessageWNative =
    ffi.IntPtr Function(
      ffi.IntPtr hwnd,
      ffi.Uint32 msg,
      ffi.IntPtr wParam,
      ffi.IntPtr lParam,
    );
typedef _SendMessageW = int Function(int hwnd, int msg, int wParam, int lParam);

typedef _CreateFileMappingWNative =
    ffi.Pointer<ffi.Void> Function(
      ffi.Pointer<ffi.Void> hFile,
      ffi.Pointer<ffi.Void> attrs,
      ffi.Uint32 protect,
      ffi.Uint32 maxSizeHigh,
      ffi.Uint32 maxSizeLow,
      ffi.Pointer<pkg_ffi.Utf16> name,
    );
typedef _CreateFileMappingW =
    ffi.Pointer<ffi.Void> Function(
      ffi.Pointer<ffi.Void> hFile,
      ffi.Pointer<ffi.Void> attrs,
      int protect,
      int maxSizeHigh,
      int maxSizeLow,
      ffi.Pointer<pkg_ffi.Utf16> name,
    );

typedef _MapViewOfFileNative =
    ffi.Pointer<ffi.Void> Function(
      ffi.Pointer<ffi.Void> mapping,
      ffi.Uint32 access,
      ffi.Uint32 offsetHigh,
      ffi.Uint32 offsetLow,
      ffi.IntPtr bytesToMap,
    );
typedef _MapViewOfFile =
    ffi.Pointer<ffi.Void> Function(
      ffi.Pointer<ffi.Void> mapping,
      int access,
      int offsetHigh,
      int offsetLow,
      int bytesToMap,
    );

typedef _UnmapViewOfFileNative = ffi.Int32 Function(ffi.Pointer<ffi.Void> view);
typedef _UnmapViewOfFile = int Function(ffi.Pointer<ffi.Void> view);

typedef _CloseHandleNative = ffi.Int32 Function(ffi.Pointer<ffi.Void> h);
typedef _CloseHandle = int Function(ffi.Pointer<ffi.Void> h);

typedef _GetCurrentProcessIdNative = ffi.Uint32 Function();
typedef _GetCurrentProcessId = int Function();

final class _CopyDataStruct extends ffi.Struct {
  @ffi.IntPtr()
  external int dwData;

  @ffi.Uint32()
  external int cbData;

  external ffi.Pointer<ffi.Void> lpData;
}
