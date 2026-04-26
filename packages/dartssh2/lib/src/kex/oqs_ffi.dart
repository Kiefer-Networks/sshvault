/// Thin Dart FFI wrapper around the C [`liboqs`](https://github.com/open-quantum-safe/liboqs)
/// KEM API. Only the surface needed for SSH hybrid KEX is exposed:
/// keypair generation, encapsulation, and decapsulation.
///
/// This file is the only place in `dartssh2` that imports `dart:ffi`.
/// Higher-level KEX classes use [OqsKem] without ever touching FFI types
/// directly so they remain platform-agnostic at the source level.
///
/// Library resolution per platform:
///   - Android: `liboqs.so` (loaded from `jniLibs/<abi>/`)
///   - iOS / macOS: `OQS.framework` / `liboqs.dylib`
///   - Linux: `liboqs.so` (loaded from `bundle/lib/` via RPATH=$ORIGIN/lib)
///   - Windows: `liboqs.dll` (loaded from the same dir as the runner)
///   - Web: not supported — every entry point throws [UnsupportedError]
library;

import 'dart:ffi';
import 'dart:io' show Platform;
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

/// True when running on Flutter web (or any pure-JS Dart compile). The
/// `dart.library.io` environment flag is set when `dart:io` is
/// available, so its absence reliably signals web. Avoids depending on
/// `package:flutter` from this pure-Dart package.
const bool _kIsWeb = !bool.fromEnvironment('dart.library.io');

/// A snapshot of one liboqs KEM. Construct via [OqsKem.lookup]; callers
/// should reuse the returned instance rather than repeatedly constructing
/// it (FFI symbol lookup is the expensive step).
final class OqsKem {
  /// liboqs algorithm identifier — must match the names in
  /// `oqs/oqs.h` exactly. Examples: `'ML-KEM-768'`, `'sntrup761'`.
  final String algorithm;

  /// Length of the public key in bytes.
  final int publicKeyLength;

  /// Length of the secret key in bytes.
  final int secretKeyLength;

  /// Length of the encapsulated ciphertext in bytes.
  final int ciphertextLength;

  /// Length of the derived shared secret in bytes (always 32 for
  /// ML-KEM-768 and sntrup761).
  final int sharedSecretLength;

  final Pointer<Void> _kemHandle;

  OqsKem._({
    required this.algorithm,
    required this.publicKeyLength,
    required this.secretKeyLength,
    required this.ciphertextLength,
    required this.sharedSecretLength,
    required Pointer<Void> kemHandle,
  }) : _kemHandle = kemHandle;

  /// Looks up [algorithm] in liboqs and constructs an [OqsKem] descriptor.
  /// Throws [UnsupportedError] on platforms without FFI (web), or
  /// [StateError] when the dynamic library cannot be loaded or the
  /// algorithm is not built into the loaded liboqs.
  factory OqsKem.lookup(String algorithm) {
    if (_kIsWeb) {
      throw UnsupportedError(
        'Hybrid post-quantum KEX is not available on Flutter web — '
        'liboqs requires native FFI.',
      );
    }
    final lib = _OqsLib.instance;
    final algBytes = algorithm.toNativeUtf8();
    try {
      final handle = lib.kemNew(algBytes.cast());
      if (handle == nullptr) {
        throw StateError(
          'liboqs does not expose KEM "$algorithm". The loaded library '
          'was built without it — rebuild with -DOQS_ENABLE_KEM_${_envSuffix(algorithm)}=ON.',
        );
      }
      final descriptor = handle.cast<_OqsKemStruct>().ref;
      return OqsKem._(
        algorithm: algorithm,
        publicKeyLength: descriptor.lengthPublicKey,
        secretKeyLength: descriptor.lengthSecretKey,
        ciphertextLength: descriptor.lengthCiphertext,
        sharedSecretLength: descriptor.lengthSharedSecret,
        kemHandle: handle,
      );
    } finally {
      malloc.free(algBytes);
    }
  }

  /// Generates a fresh KEM keypair using liboqs's CSPRNG.
  ({Uint8List publicKey, Uint8List secretKey}) keypair() {
    final lib = _OqsLib.instance;
    final pub = malloc.allocate<Uint8>(publicKeyLength);
    final sec = malloc.allocate<Uint8>(secretKeyLength);
    try {
      final rc = lib.kemKeypair(_kemHandle, pub, sec);
      _checkOqsRc(rc, 'OQS_KEM_keypair');
      return (
        publicKey: Uint8List.fromList(pub.asTypedList(publicKeyLength)),
        secretKey: Uint8List.fromList(sec.asTypedList(secretKeyLength)),
      );
    } finally {
      malloc.free(pub);
      malloc.free(sec);
    }
  }

  /// Encapsulates against [peerPublicKey], returning ciphertext to send
  /// to the peer and the locally-derived shared secret.
  ({Uint8List ciphertext, Uint8List sharedSecret}) encapsulate(
    Uint8List peerPublicKey,
  ) {
    if (peerPublicKey.length != publicKeyLength) {
      throw ArgumentError.value(
        peerPublicKey.length,
        'peerPublicKey.length',
        'expected $publicKeyLength bytes for $algorithm',
      );
    }
    final lib = _OqsLib.instance;
    final ct = malloc.allocate<Uint8>(ciphertextLength);
    final ss = malloc.allocate<Uint8>(sharedSecretLength);
    final pub = malloc.allocate<Uint8>(publicKeyLength);
    try {
      pub.asTypedList(publicKeyLength).setAll(0, peerPublicKey);
      final rc = lib.kemEncaps(_kemHandle, ct, ss, pub);
      _checkOqsRc(rc, 'OQS_KEM_encaps');
      return (
        ciphertext: Uint8List.fromList(ct.asTypedList(ciphertextLength)),
        sharedSecret: Uint8List.fromList(ss.asTypedList(sharedSecretLength)),
      );
    } finally {
      malloc.free(ct);
      malloc.free(ss);
      malloc.free(pub);
    }
  }

  /// Decapsulates [ciphertext] using [secretKey], returning the shared
  /// secret. Both buffers are passed by value (defensive copy in/out).
  Uint8List decapsulate(Uint8List ciphertext, Uint8List secretKey) {
    if (ciphertext.length != ciphertextLength) {
      throw ArgumentError.value(
        ciphertext.length,
        'ciphertext.length',
        'expected $ciphertextLength bytes for $algorithm',
      );
    }
    if (secretKey.length != secretKeyLength) {
      throw ArgumentError.value(
        secretKey.length,
        'secretKey.length',
        'expected $secretKeyLength bytes for $algorithm',
      );
    }
    final lib = _OqsLib.instance;
    final ct = malloc.allocate<Uint8>(ciphertextLength);
    final sec = malloc.allocate<Uint8>(secretKeyLength);
    final ss = malloc.allocate<Uint8>(sharedSecretLength);
    try {
      ct.asTypedList(ciphertextLength).setAll(0, ciphertext);
      sec.asTypedList(secretKeyLength).setAll(0, secretKey);
      final rc = lib.kemDecaps(_kemHandle, ss, ct, sec);
      _checkOqsRc(rc, 'OQS_KEM_decaps');
      return Uint8List.fromList(ss.asTypedList(sharedSecretLength));
    } finally {
      malloc.free(ct);
      malloc.free(sec);
      malloc.free(ss);
    }
  }

  /// Returns whether the bundled liboqs offers [algorithm]. Use to
  /// degrade gracefully when a build wasn't compiled with the requested
  /// KEM.
  static bool isAvailable(String algorithm) {
    try {
      OqsKem.lookup(algorithm);
      return true;
    } catch (_) {
      return false;
    }
  }
}

/// Maps an OpenSSH-style algorithm name to the env-var fragment liboqs
/// uses for the build flag. Only used for error messages.
String _envSuffix(String algorithm) {
  return algorithm.toUpperCase().replaceAll('-', '_').replaceAll(' ', '_');
}

void _checkOqsRc(int rc, String fn) {
  // OQS_SUCCESS == 0
  if (rc != 0) {
    throw StateError('$fn returned non-zero status $rc');
  }
}

/// Layout for `struct OQS_KEM` in `oqs/kem.h`. Only the size fields are
/// read by Dart; everything else stays opaque on the C side. Keep this
/// in sync with the liboqs version pinned in
/// `third_party/liboqs/`.
final class _OqsKemStruct extends Struct {
  external Pointer<Utf8> methodName;
  external Pointer<Utf8> algVersion;

  @Uint8()
  external int claimedNistLevel;
  @Uint8()
  external int indCca;

  @Size()
  external int lengthPublicKey;
  @Size()
  external int lengthSecretKey;
  @Size()
  external int lengthCiphertext;
  @Size()
  external int lengthSharedSecret;
  @Size()
  external int lengthKeypairSeed;

  // The remaining function pointers and trailing fields are not
  // accessed from Dart; FFI does not require them to be modelled.
}

typedef _KemNewC = Pointer<Void> Function(Pointer<Utf8> alg);
typedef _KemNewDart = Pointer<Void> Function(Pointer<Utf8> alg);

typedef _KemKeypairC = Int32 Function(
  Pointer<Void> kem,
  Pointer<Uint8> publicKey,
  Pointer<Uint8> secretKey,
);
typedef _KemKeypairDart = int Function(
  Pointer<Void> kem,
  Pointer<Uint8> publicKey,
  Pointer<Uint8> secretKey,
);

typedef _KemEncapsC = Int32 Function(
  Pointer<Void> kem,
  Pointer<Uint8> ciphertext,
  Pointer<Uint8> sharedSecret,
  Pointer<Uint8> publicKey,
);
typedef _KemEncapsDart = int Function(
  Pointer<Void> kem,
  Pointer<Uint8> ciphertext,
  Pointer<Uint8> sharedSecret,
  Pointer<Uint8> publicKey,
);

typedef _KemDecapsC = Int32 Function(
  Pointer<Void> kem,
  Pointer<Uint8> sharedSecret,
  Pointer<Uint8> ciphertext,
  Pointer<Uint8> secretKey,
);
typedef _KemDecapsDart = int Function(
  Pointer<Void> kem,
  Pointer<Uint8> sharedSecret,
  Pointer<Uint8> ciphertext,
  Pointer<Uint8> secretKey,
);

class _OqsLib {
  _OqsLib._(DynamicLibrary lib)
      : kemNew = lib.lookupFunction<_KemNewC, _KemNewDart>('OQS_KEM_new'),
        kemKeypair = lib
            .lookupFunction<_KemKeypairC, _KemKeypairDart>('OQS_KEM_keypair'),
        kemEncaps =
            lib.lookupFunction<_KemEncapsC, _KemEncapsDart>('OQS_KEM_encaps'),
        kemDecaps =
            lib.lookupFunction<_KemDecapsC, _KemDecapsDart>('OQS_KEM_decaps');

  final _KemNewDart kemNew;
  final _KemKeypairDart kemKeypair;
  final _KemEncapsDart kemEncaps;
  final _KemDecapsDart kemDecaps;

  static _OqsLib? _instance;
  static _OqsLib get instance => _instance ??= _OqsLib._(_openLibrary());

  static DynamicLibrary _openLibrary() {
    if (Platform.isAndroid || Platform.isLinux) {
      return DynamicLibrary.open('liboqs.so');
    }
    if (Platform.isMacOS) {
      // Prefer the framework form bundled by CocoaPods; fall back to a
      // plain dylib in `Contents/Frameworks/`.
      try {
        return DynamicLibrary.open('OQS.framework/OQS');
      } catch (_) {
        return DynamicLibrary.open('liboqs.dylib');
      }
    }
    if (Platform.isIOS) {
      // iOS uses `process()` because the framework is statically linked
      // into the application binary.
      return DynamicLibrary.process();
    }
    if (Platform.isWindows) {
      return DynamicLibrary.open('liboqs.dll');
    }
    throw UnsupportedError(
      'liboqs is not available on ${Platform.operatingSystem}',
    );
  }
}
