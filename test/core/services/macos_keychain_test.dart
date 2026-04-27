// Unit tests for the macOS Keychain wrapper.
//
// These tests run on every host (Linux/Windows CI included). The real
// `Security.framework` calls are stubbed via [KeychainFfi]; on the actual
// production code path the live FFI layer is exercised by integration
// tests on a macOS runner.

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:sshvault/core/services/macos_keychain.dart';

class _FakeKeychainFfi implements KeychainFfi {
  /// Capture every dictionary the wrapper hands to the FFI layer so tests
  /// can assert on `kSecClass`, `kSecAttrService`, `kSecAttrAccount`, …
  /// without linking against `Security.framework`.
  final List<Map<String, Object?>> readQueries = [];
  final List<Map<String, Object?>> writeAttrs = [];
  final List<Uint8List> writeBlobs = [];
  final List<Map<String, Object?>> deleteQueries = [];

  /// Backing store keyed by (service, account) so multi-account tests
  /// don't collide.
  final Map<String, Uint8List> store = {};

  @override
  Uint8List? itemCopyMatching(Map<String, Object?> query) {
    readQueries.add(Map<String, Object?>.from(query));
    final key = _key(query);
    return store[key];
  }

  @override
  void itemAddOrUpdate(Map<String, Object?> attrs, Uint8List blob) {
    writeAttrs.add(Map<String, Object?>.from(attrs));
    writeBlobs.add(Uint8List.fromList(blob));
    store[_key(attrs)] = Uint8List.fromList(blob);
  }

  @override
  bool itemDelete(Map<String, Object?> query) {
    deleteQueries.add(Map<String, Object?>.from(query));
    return store.remove(_key(query)) != null;
  }

  static String _key(Map<String, Object?> q) =>
      '${q['kSecAttrService']}::${q['kSecAttrAccount']}';
}

void main() {
  group('MacosKeychain (FFI stub)', () {
    late _FakeKeychainFfi ffi;
    late MacosKeychain keychain;

    setUp(() {
      ffi = _FakeKeychainFfi();
      keychain = MacosKeychain(ffi: ffi);
    });

    test('exposes the documented service-name constant', () {
      expect(kMacosKeychainService, 'de.kiefer_networks.SSHVault');
    });

    test(
      'write builds the correct kSecClass / Service / Account dict',
      () async {
        await keychain.write('account-a', [1, 2, 3, 4]);

        expect(ffi.writeAttrs, hasLength(1));
        final attrs = ffi.writeAttrs.single;
        expect(attrs['kSecClass'], 'kSecClassGenericPassword');
        expect(attrs['kSecAttrService'], kMacosKeychainService);
        expect(attrs['kSecAttrAccount'], 'account-a');
        expect(
          attrs['kSecAttrAccessible'],
          KeychainAccessibility.afterFirstUnlockThisDeviceOnly,
          reason: 'Default must be device-bound',
        );
        expect(
          attrs.containsKey('kSecAttrSynchronizable'),
          isFalse,
          reason: 'Default writes must NOT opt into iCloud Keychain',
        );
        expect(ffi.writeBlobs.single, [1, 2, 3, 4]);
      },
    );

    test(
      'synchronizable=true switches accessibility + sets sync flag',
      () async {
        await keychain.write('account-a', [9, 9], synchronizable: true);

        final attrs = ffi.writeAttrs.single;
        expect(attrs['kSecAttrAccessible'], KeychainAccessibility.whenUnlocked);
        expect(attrs['kSecAttrSynchronizable'], isTrue);
      },
    );

    test('read builds a query with kSecReturnData/kSecMatchLimitOne', () async {
      await keychain.write('account-a', [7, 8, 9]);

      final value = await keychain.read('account-a');
      expect(value, [7, 8, 9]);

      expect(ffi.readQueries, hasLength(1));
      final q = ffi.readQueries.single;
      expect(q['kSecClass'], 'kSecClassGenericPassword');
      expect(q['kSecAttrService'], kMacosKeychainService);
      expect(q['kSecAttrAccount'], 'account-a');
      expect(q['kSecReturnData'], isTrue);
      expect(q['kSecMatchLimit'], 'kSecMatchLimitOne');
    });

    test('read returns null when the account does not exist', () async {
      final value = await keychain.read('missing');
      expect(value, isNull);
      expect(ffi.readQueries, hasLength(1));
    });

    test('delete builds a query without kSecReturnData', () async {
      await keychain.write('account-a', [1]);
      await keychain.delete('account-a');

      final q = ffi.deleteQueries.single;
      expect(q['kSecClass'], 'kSecClassGenericPassword');
      expect(q['kSecAttrService'], kMacosKeychainService);
      expect(q['kSecAttrAccount'], 'account-a');
      expect(q.containsKey('kSecReturnData'), isFalse);
      expect(ffi.store, isEmpty);
    });

    test('isSupported is true when an explicit FFI is injected', () {
      expect(keychain.isSupported, isTrue);
    });

    test('round-trips via List<int> input (not just Uint8List)', () async {
      await keychain.write('roundtrip', const [1, 2, 3]);
      final value = await keychain.read('roundtrip');
      expect(value, [1, 2, 3]);
    });

    test('custom service name flows through every dictionary', () async {
      final custom = MacosKeychain(ffi: ffi, service: 'com.example.test');
      await custom.write('a', [1]);
      await custom.read('a');
      await custom.delete('a');

      expect(ffi.writeAttrs.single['kSecAttrService'], 'com.example.test');
      expect(ffi.readQueries.single['kSecAttrService'], 'com.example.test');
      expect(ffi.deleteQueries.single['kSecAttrService'], 'com.example.test');
    });
  });
}
