import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shellvault/core/crypto/nonce_counter.dart';

class FakeSecureStorage extends Fake implements FlutterSecureStorage {
  final Map<String, String> _store = {};
  bool shouldThrow = false;

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (shouldThrow) throw Exception('Storage unavailable');
    return _store[key];
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (shouldThrow) throw Exception('Storage unavailable');
    if (value != null) {
      _store[key] = value;
    } else {
      _store.remove(key);
    }
  }

  /// Expose the internal store for assertions.
  Map<String, String> get store => Map.unmodifiable(_store);

  /// Clear the in-memory store.
  void clear() => _store.clear();
}

void main() {
  late FakeSecureStorage fakeStorage;
  late NonceCounter sut;

  setUp(() {
    fakeStorage = FakeSecureStorage();
    sut = NonceCounter(storage: fakeStorage);
  });

  group('NonceCounter — basic nonce generation', () {
    test('generates a 12-byte nonce', () async {
      final nonce = await sut.next('test-key');
      expect(nonce.length, 12);
    });

    test('nonce format is 4-byte prefix + 8-byte counter', () async {
      final nonce = await sut.next('test-key');

      // The first call should produce counter=1 (big-endian uint64).
      // Bytes 4..11 should encode the value 1.
      final counterBytes = nonce.sublist(4, 12);
      // Only the last byte should be 1, all others 0
      expect(counterBytes.sublist(0, 7), everyElement(0));
      expect(counterBytes[7], 1);
    });

    test('prefix is exactly 4 bytes and persisted', () async {
      await sut.next('prefix-key');

      // The storage should contain the hex-encoded prefix
      final storedHex = fakeStorage.store['nonce_prefix_prefix-key'];
      expect(storedHex, isNotNull);
      // 4 bytes = 8 hex chars
      expect(storedHex!.length, 8);
    });

    test('counter is persisted after each call', () async {
      await sut.next('counter-key');
      final storedCounter = fakeStorage.store['nonce_counter_counter-key'];
      expect(storedCounter, '1');

      await sut.next('counter-key');
      final storedCounter2 = fakeStorage.store['nonce_counter_counter-key'];
      expect(storedCounter2, '2');
    });
  });

  group('NonceCounter — counter increments', () {
    test('counter increments on each call', () async {
      final nonce1 = await sut.next('inc-key');
      final nonce2 = await sut.next('inc-key');
      final nonce3 = await sut.next('inc-key');

      // Extract the counter portion (bytes 4..11)
      int extractCounter(Uint8List nonce) {
        var value = 0;
        for (var i = 4; i < 12; i++) {
          value = (value << 8) | nonce[i];
        }
        return value;
      }

      expect(extractCounter(nonce1), 1);
      expect(extractCounter(nonce2), 2);
      expect(extractCounter(nonce3), 3);
    });

    test('counter resumes from persisted value', () async {
      // Generate 5 nonces to set counter to 5
      for (var i = 0; i < 5; i++) {
        await sut.next('resume-key');
      }
      expect(fakeStorage.store['nonce_counter_resume-key'], '5');

      // Create a new NonceCounter instance with the same storage
      final sut2 = NonceCounter(storage: fakeStorage);
      final nonce = await sut2.next('resume-key');

      // Counter should continue from 5 -> 6
      var counterValue = 0;
      for (var i = 4; i < 12; i++) {
        counterValue = (counterValue << 8) | nonce[i];
      }
      expect(counterValue, 6);
      expect(fakeStorage.store['nonce_counter_resume-key'], '6');
    });
  });

  group('NonceCounter — unique nonces', () {
    test('successive nonces are unique', () async {
      final nonces = <String>[];
      for (var i = 0; i < 20; i++) {
        final nonce = await sut.next('unique-key');
        nonces.add(
          nonce.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
        );
      }

      // All nonces must be distinct
      expect(nonces.toSet().length, nonces.length);
    });

    test('nonces for different keyIds are unique', () async {
      final nonceA = await sut.next('key-a');
      final nonceB = await sut.next('key-b');

      // Different key IDs get different random prefixes, so nonces differ.
      // Even though both have counter=1, the prefix should be different.
      final hexA = nonceA
          .map((b) => b.toRadixString(16).padLeft(2, '0'))
          .join();
      final hexB = nonceB
          .map((b) => b.toRadixString(16).padLeft(2, '0'))
          .join();
      expect(hexA, isNot(equals(hexB)));
    });

    test('same keyId reuses the same prefix', () async {
      final nonce1 = await sut.next('stable-key');
      final nonce2 = await sut.next('stable-key');

      // Prefix (bytes 0..3) should be identical
      expect(nonce1.sublist(0, 4), equals(nonce2.sublist(0, 4)));
    });
  });

  group('NonceCounter — storage failure behavior', () {
    test('throws when storage is unavailable (fail-closed)', () async {
      fakeStorage.shouldThrow = true;

      expect(() => sut.next('fail-key'), throwsException);
    });

    test('storage failure does not persist any data', () async {
      fakeStorage.shouldThrow = true;
      try {
        await sut.next('no-persist');
      } catch (_) {
        // Expected
      }

      fakeStorage.shouldThrow = false;
      // Nothing was persisted
      expect(fakeStorage.store['nonce_prefix_no-persist'], isNull);
      expect(fakeStorage.store['nonce_counter_no-persist'], isNull);
    });

    test('recovers after storage becomes available again', () async {
      fakeStorage.shouldThrow = true;
      try {
        await sut.next('recover-key');
      } catch (_) {
        // Expected
      }

      fakeStorage.shouldThrow = false;
      final counterNonce = await sut.next('recover-key');
      expect(counterNonce.length, 12);

      // After recovery, counter should be persisted
      expect(fakeStorage.store['nonce_counter_recover-key'], '1');
    });
  });

  group('NonceCounter — edge cases', () {
    test('empty keyId works', () async {
      final nonce = await sut.next('');
      expect(nonce.length, 12);
      expect(fakeStorage.store['nonce_counter_'], '1');
    });

    test('keyId with special characters works', () async {
      final nonce = await sut.next('key/with:special@chars');
      expect(nonce.length, 12);
      expect(fakeStorage.store['nonce_counter_key/with:special@chars'], '1');
    });
  });
}
