import 'dart:math';
import 'dart:typed_data';

/// Shared cryptographic utility functions.
///
/// Centralizes common crypto operations to avoid duplication
/// and ensure consistent secure implementations.
abstract final class CryptoUtils {
  /// Constant-time comparison for byte lists.
  ///
  /// Prevents timing side-channel attacks by always comparing
  /// all bytes regardless of where mismatches occur.
  /// Returns `false` immediately only on length mismatch.
  static bool constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a[i] ^ b[i];
    }
    return result == 0;
  }

  /// Constant-time string comparison.
  ///
  /// Converts strings to code units and delegates to byte comparison.
  static bool constantTimeStringEquals(String a, String b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }

  /// Generates a [Uint8List] of [length] cryptographically secure random bytes.
  static Uint8List secureRandomBytes(int length) {
    final rng = Random.secure();
    return Uint8List.fromList(List.generate(length, (_) => rng.nextInt(256)));
  }

  /// Encodes a byte list to a lowercase hex string.
  static String bytesToHex(List<int> bytes) {
    final sb = StringBuffer();
    for (final b in bytes) {
      sb.write(b.toRadixString(16).padLeft(2, '0'));
    }
    return sb.toString();
  }

  /// Decodes a hex string to a [Uint8List].
  static Uint8List hexToBytes(String hex) {
    final result = Uint8List(hex.length ~/ 2);
    for (var i = 0; i < result.length; i++) {
      result[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return result;
  }

  /// Zeroes a [Uint8List] to remove sensitive key material from memory.
  static void zeroMemory(Uint8List data) {
    data.fillRange(0, data.length, 0);
  }
}
