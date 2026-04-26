import 'dart:typed_data';

import 'package:dartssh2/src/kex/kex_dh.dart';
import 'package:dartssh2/src/ssh_algorithm.dart';
import 'package:dartssh2/src/ssh_message.dart';
import 'package:pointycastle/export.dart';

abstract class SSHKexUtils {
  /// The first algorithm on the client's name-list and is also supported by the
  /// server must be chosen. (rfc4253, section 7.1)
  static T? selectAlgorithm<T extends SSHAlgorithm>({
    required List<T> localAlgorithms,
    required List<String> remoteAlgorithms,
    required bool isServer,
  }) {
    if (isServer) {
      for (final clientAlgorithm in remoteAlgorithms) {
        final serverAlgorithm = localAlgorithms.getByName(clientAlgorithm);
        if (serverAlgorithm != null) {
          return serverAlgorithm;
        }
      }
    } else {
      for (final clientAlgorithm in localAlgorithms) {
        if (remoteAlgorithms.contains(clientAlgorithm.name)) {
          return clientAlgorithm;
        }
      }
    }
    return null;
  }

  static Uint8List computeExchangeHash({
    required Digest digest,
    SSHKexDH? groupExchange,
    required String clientVersion,
    required String serverVersion,
    required Uint8List clientKexInit,
    required Uint8List serverKexInit,
    required Uint8List hostKey,
    required Uint8List clientPublicKey,
    required Uint8List serverPublicKey,
    BigInt? sharedSecret,
    Uint8List? sharedSecretBytes,
  }) {
    assert(
      (sharedSecret == null) ^ (sharedSecretBytes == null),
      'Exactly one of sharedSecret (mpint) or sharedSecretBytes (raw) '
      'must be provided.',
    );

    final writer = SSHMessageWriter();
    writer.writeUtf8(clientVersion);
    writer.writeUtf8(serverVersion);
    writer.writeString(clientKexInit);
    writer.writeString(serverKexInit);
    writer.writeString(hostKey);

    if (groupExchange != null) {
      writer.writeUint32(SSHKexDH.gexMin);
      writer.writeUint32(SSHKexDH.gexPref);
      writer.writeUint32(SSHKexDH.gexMax);
      writer.writeMpint(groupExchange.p);
      writer.writeMpint(groupExchange.g);
    }

    writer.writeString(clientPublicKey);
    writer.writeString(serverPublicKey);
    if (sharedSecretBytes != null) {
      // Hybrid PQ KEX: shared secret encoded as a string (uint32 length
      // prefix + raw bytes), per OpenSSH PROTOCOL.mlkem768x25519 and
      // PROTOCOL.sntrup761x25519. Differs from classical KEX's mpint.
      writer.writeString(sharedSecretBytes);
    } else {
      writer.writeMpint(sharedSecret!);
    }

    final message = writer.takeBytes();
    digest.update(message, 0, message.length);
    final result = Uint8List(digest.digestSize);
    digest.doFinal(result, 0);
    return result;
  }

  /// Derive various keys from the exchange hash.
  static Uint8List deriveKey({
    required Digest digest,
    BigInt? sharedSecret,
    Uint8List? sharedSecretBytes,
    required Uint8List exchangeHash,
    required SSHDeriveKeyType keyType,
    required Uint8List sessionId,
    required int keySize,
  }) {
    assert(
      (sharedSecret == null) ^ (sharedSecretBytes == null),
      'Exactly one of sharedSecret or sharedSecretBytes must be provided.',
    );
    final result = BytesBuilder(copy: false);

    while (result.length < keySize) {
      final writer = SSHMessageWriter();
      if (sharedSecretBytes != null) {
        writer.writeString(sharedSecretBytes);
      } else {
        writer.writeMpint(sharedSecret!);
      }
      writer.writeBytes(exchangeHash);
      if (result.isEmpty) {
        writer.writeUint8(keyType.magicChar);
        writer.writeBytes(sessionId);
      } else {
        writer.writeBytes(result.toBytes());
      }

      final dataToHash = writer.takeBytes();
      digest.update(dataToHash, 0, dataToHash.length);
      final hash = Uint8List(digest.digestSize);
      digest.doFinal(hash, 0);
      result.add(hash);
    }

    return Uint8List.sublistView(result.takeBytes(), 0, keySize);
  }
}

enum SSHDeriveKeyType {
  clientIV,
  serverIV,
  clientKey,
  serverKey,
  clientMacKey,
  serverMacKey,
}

extension SSHDeriveKeyTypeX on SSHDeriveKeyType {
  /// The magic character used in ke derivation.
  int get magicChar {
    switch (this) {
      case SSHDeriveKeyType.clientIV:
        return 'A'.codeUnits.first;
      case SSHDeriveKeyType.serverIV:
        return 'B'.codeUnits.first;
      case SSHDeriveKeyType.clientKey:
        return 'C'.codeUnits.first;
      case SSHDeriveKeyType.serverKey:
        return 'D'.codeUnits.first;
      case SSHDeriveKeyType.clientMacKey:
        return 'E'.codeUnits.first;
      case SSHDeriveKeyType.serverMacKey:
        return 'F'.codeUnits.first;
    }
  }
}
