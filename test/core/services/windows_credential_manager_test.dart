// Unit tests for the Windows Credential Manager wrapper.
//
// These tests run on every host (Linux/macOS CI included). The real
// `advapi32.dll` calls are stubbed via [WincredFfi]; on the actual
// production code path the live FFI layer is exercised by integration
// tests on a Windows runner.

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:sshvault/core/services/windows_credential_manager.dart';

class _FakeWincredFfi implements WincredFfi {
  final Map<String, _FakeEntry> store = {};
  int readCalls = 0;
  int writeCalls = 0;
  int deleteCalls = 0;

  /// When non-null, [credRead] throws this on the next call.
  Object? throwOnNextRead;

  @override
  Uint8List? credRead(String target, int type) {
    readCalls++;
    final pending = throwOnNextRead;
    if (pending != null) {
      throwOnNextRead = null;
      throw pending;
    }
    final entry = store[target];
    if (entry == null) return null;
    expect(entry.type, type, reason: 'type mismatch on read');
    return Uint8List.fromList(entry.blob);
  }

  @override
  void credWrite(String target, String userName, Uint8List blob, int persist) {
    writeCalls++;
    store[target] = _FakeEntry(
      blob: Uint8List.fromList(blob),
      userName: userName,
      persist: persist,
      type: credTypeGeneric,
    );
  }

  @override
  bool credDelete(String target, int type) {
    deleteCalls++;
    return store.remove(target) != null;
  }
}

class _FakeEntry {
  _FakeEntry({
    required this.blob,
    required this.userName,
    required this.persist,
    required this.type,
  });
  final Uint8List blob;
  final String userName;
  final int persist;
  final int type;
}

void main() {
  group('WindowsCredentialManager (FFI stub)', () {
    late _FakeWincredFfi ffi;
    late WindowsCredentialManager mgr;

    setUp(() {
      ffi = _FakeWincredFfi();
      mgr = WindowsCredentialManager(ffi: ffi);
    });

    test('uses the documented target name constant', () {
      expect(kWindowsMasterKeyTarget, 'de.kiefer_networks.SSHVault.MasterKey');
    });

    test('write then read round-trips the blob bytes', () async {
      final payload = utf8.encode('correct horse battery staple');
      await mgr.write(kWindowsMasterKeyTarget, payload);

      expect(ffi.writeCalls, 1);
      final saved = ffi.store[kWindowsMasterKeyTarget]!;
      expect(saved.blob, payload);
      expect(saved.userName, kWindowsMasterKeyUserName);
      expect(saved.persist, credPersistLocalMachine);
      expect(saved.type, credTypeGeneric);

      final readBack = await mgr.read(kWindowsMasterKeyTarget);
      expect(readBack, payload);
    });

    test('readString decodes UTF-8 round-trips', () async {
      await mgr.writeString(kWindowsMasterKeyTarget, 'hellö wörld');
      final value = await mgr.readString(kWindowsMasterKeyTarget);
      expect(value, 'hellö wörld');
    });

    test('readString returns null for non-UTF-8 bytes', () async {
      // Invalid UTF-8 sequence (lone continuation byte).
      ffi.store[kWindowsMasterKeyTarget] = _FakeEntry(
        blob: Uint8List.fromList([0xC3, 0x28]),
        userName: kWindowsMasterKeyUserName,
        persist: credPersistLocalMachine,
        type: credTypeGeneric,
      );
      expect(await mgr.readString(kWindowsMasterKeyTarget), isNull);
    });

    test('read returns null when the target does not exist', () async {
      final value = await mgr.read('nonexistent');
      expect(value, isNull);
      expect(ffi.readCalls, 1);
    });

    test('delete removes the entry and reports success', () async {
      await mgr.write(kWindowsMasterKeyTarget, [1, 2, 3]);
      final deleted = await mgr.delete(kWindowsMasterKeyTarget);
      expect(deleted, isTrue);
      expect(ffi.store, isEmpty);
    });

    test('delete reports false when nothing to remove', () async {
      final deleted = await mgr.delete('nothing-here');
      expect(deleted, isFalse);
    });

    test('write defaults to CRED_PERSIST_LOCAL_MACHINE', () async {
      await mgr.write('t', [9]);
      expect(
        ffi.store['t']!.persist,
        credPersistLocalMachine,
        reason: 'Default persist must outlive logoff but not OS reinstall',
      );
    });

    test('persistLocalMachine: false uses session persistence', () async {
      await mgr.write('t', [9], persistLocalMachine: false);
      expect(ffi.store['t']!.persist, isNot(credPersistLocalMachine));
    });

    test('read propagates non-NotFound failures', () async {
      ffi.throwOnNextRead = WindowsCredentialException(
        'ACCESS_DENIED',
        errorCode: 5,
      );
      expect(
        () => mgr.read(kWindowsMasterKeyTarget),
        throwsA(isA<WindowsCredentialException>()),
      );
    });

    test('off-Windows: is gated by isSupported but stub still works', () {
      // The constructor allows full operation in tests via the injected
      // FFI; the production isSupported flag is documented as Windows-only.
      // We just assert the field exists and is a bool.
      expect(mgr.isSupported, isA<bool>());
    });
  });
}
