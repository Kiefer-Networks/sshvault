import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' show sha256;
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/services/logging_service.dart';

/// Client-side proof-of-work solver for rate-limiting protection.
///
/// The server issues a challenge (prefix + difficulty). The client must find
/// a nonce such that SHA-256(prefix + nonce) starts with [difficulty] zero bits.
///
/// This protects auth endpoints against brute force and credential stuffing
/// without requiring CAPTCHAs.
class ProofOfWorkService {
  static final _log = LoggingService.instance;
  static const _tag = 'PoW';

  /// Maximum number of iterations before giving up.
  static const int maxIterations = 10000000; // 10M

  /// Maximum difficulty the client will accept from the server.
  /// Prevents a malicious server from causing client-side DoS.
  static const int maxDifficulty = 24;

  /// Solve a proof-of-work challenge.
  ///
  /// [challenge] contains the server-issued prefix and required difficulty.
  /// Returns a [ProofOfWorkSolution] with the nonce and hash, or an error
  /// if the challenge cannot be solved within [maxIterations].
  /// Rejects challenges with difficulty exceeding [maxDifficulty].
  Future<Result<ProofOfWorkSolution>> solve(
    ProofOfWorkChallenge challenge,
  ) async {
    if (challenge.difficulty > maxDifficulty) {
      _log.error(
        _tag,
        'PoW difficulty ${challenge.difficulty} exceeds max $maxDifficulty',
      );
      return const Err(
        CryptoFailure('Server requested excessive PoW difficulty'),
      );
    }

    if (challenge.isExpired) {
      _log.error(_tag, 'PoW challenge already expired before solving');
      return const Err(CryptoFailure('PoW challenge has expired'));
    }
    _log.info(
      _tag,
      'Solving PoW challenge (difficulty=${challenge.difficulty}, '
      'prefix=${challenge.prefix.substring(0, min(8, challenge.prefix.length))}...)',
    );

    final sw = Stopwatch()..start();
    final prefixBytes = utf8.encode(challenge.prefix);

    for (var nonce = 0; nonce < maxIterations; nonce++) {
      final nonceBytes = utf8.encode(nonce.toString());
      final input = Uint8List(prefixBytes.length + nonceBytes.length);
      input.setRange(0, prefixBytes.length, prefixBytes);
      input.setRange(prefixBytes.length, input.length, nonceBytes);

      final hash = sha256.convert(input);

      if (_hasLeadingZeroBits(hash.bytes, challenge.difficulty)) {
        sw.stop();
        final solution = ProofOfWorkSolution(
          nonce: nonce.toString(),
          hash: _bytesToHex(hash.bytes),
          iterations: nonce + 1,
          durationMs: sw.elapsedMilliseconds,
        );

        _log.info(
          _tag,
          'PoW solved in ${sw.elapsedMilliseconds}ms '
          '(${nonce + 1} iterations)',
        );
        return Success(solution);
      }

      // Yield to event loop periodically to avoid blocking UI
      if (nonce > 0 && nonce % 100000 == 0) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    sw.stop();
    _log.error(
      _tag,
      'PoW failed: exceeded $maxIterations iterations '
      '(${sw.elapsedMilliseconds}ms)',
    );
    return const Err(
      CryptoFailure('Proof-of-work challenge could not be solved'),
    );
  }

  /// Verify a proof-of-work solution locally.
  ///
  /// Returns true if SHA-256(prefix + nonce) has the required leading zeros.
  bool verify(ProofOfWorkChallenge challenge, ProofOfWorkSolution solution) {
    final input = utf8.encode('${challenge.prefix}${solution.nonce}');
    final hash = sha256.convert(input);
    final hashHex = _bytesToHex(hash.bytes);

    if (hashHex != solution.hash) return false;
    return _hasLeadingZeroBits(hash.bytes, challenge.difficulty);
  }

  /// Check if a byte array has at least [bits] leading zero bits.
  static bool _hasLeadingZeroBits(List<int> bytes, int bits) {
    var remaining = bits;
    for (final byte in bytes) {
      if (remaining <= 0) return true;
      if (remaining >= 8) {
        if (byte != 0) return false;
        remaining -= 8;
      } else {
        // Check the top `remaining` bits
        final mask = (0xFF << (8 - remaining)) & 0xFF;
        return (byte & mask) == 0;
      }
    }
    return remaining <= 0;
  }

  static String _bytesToHex(List<int> bytes) {
    final sb = StringBuffer();
    for (final b in bytes) {
      sb.write(b.toRadixString(16).padLeft(2, '0'));
    }
    return sb.toString();
  }
}

/// A proof-of-work challenge issued by the server.
class ProofOfWorkChallenge {
  /// Server-issued prefix (typically includes a timestamp and request context).
  final String prefix;

  /// Required number of leading zero bits in the hash.
  final int difficulty;

  /// Challenge expiry timestamp (UTC).
  final DateTime? expiresAt;

  const ProofOfWorkChallenge({
    required this.prefix,
    required this.difficulty,
    this.expiresAt,
  });

  /// Whether this challenge has expired.
  bool get isExpired =>
      expiresAt != null && DateTime.now().toUtc().isAfter(expiresAt!);

  factory ProofOfWorkChallenge.fromJson(Map<String, dynamic> json) {
    final rawExpiry = json['expires_at'];
    DateTime? expiresAt;
    if (rawExpiry is int) {
      expiresAt = DateTime.fromMillisecondsSinceEpoch(
        rawExpiry * 1000,
        isUtc: true,
      );
    } else if (rawExpiry is String) {
      expiresAt = DateTime.tryParse(rawExpiry);
    }

    return ProofOfWorkChallenge(
      prefix: (json['challenge'] ?? json['prefix']) as String,
      difficulty: json['difficulty'] as int,
      expiresAt: expiresAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'challenge': prefix,
    'difficulty': difficulty,
    if (expiresAt != null)
      'expires_at': expiresAt!.millisecondsSinceEpoch ~/ 1000,
  };
}

/// The solution to a proof-of-work challenge.
class ProofOfWorkSolution {
  /// The nonce that satisfies the challenge.
  final String nonce;

  /// The resulting SHA-256 hash (hex-encoded).
  final String hash;

  /// Number of iterations taken.
  final int iterations;

  /// Time taken to solve in milliseconds.
  final int durationMs;

  const ProofOfWorkSolution({
    required this.nonce,
    required this.hash,
    required this.iterations,
    required this.durationMs,
  });

  Map<String, dynamic> toJson() => {'nonce': nonce, 'hash': hash};
}
