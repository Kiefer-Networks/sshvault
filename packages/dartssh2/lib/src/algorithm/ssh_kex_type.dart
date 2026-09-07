import 'package:dartssh2/src/ssh_algorithm.dart';
import 'package:dartssh2/src/ssh_kex.dart';
import 'package:pointycastle/export.dart';

class SSHKexType extends SSHAlgorithm {
  static const x25519 = SSHKexType._(
    name: 'curve25519-sha256@libssh.org',
    digestFactory: digestSha256,
  );

  /// RFC 8731 name for the same algorithm as [x25519]. Servers hardened to a
  /// single kex commonly offer only this spelling, and OpenSSH matches names
  /// literally — without it the handshake dies with "no matching key exchange
  /// method found".
  static const x25519Rfc = SSHKexType._(
    name: 'curve25519-sha256',
    digestFactory: digestSha256,
  );

  static const nistp256 = SSHKexType._(
    name: 'ecdh-sha2-nistp256',
    digestFactory: digestSha256,
  );

  static const nistp384 = SSHKexType._(
    name: 'ecdh-sha2-nistp384',
    digestFactory: digestSha384,
  );

  static const nistp521 = SSHKexType._(
    name: 'ecdh-sha2-nistp521',
    digestFactory: digestSha512,
  );

  static const dhGexSha256 = SSHKexType._(
    name: 'diffie-hellman-group-exchange-sha256',
    digestFactory: digestSha256,
    isGroupExchange: true,
  );

  static const dhGexSha1 = SSHKexType._(
    name: 'diffie-hellman-group-exchange-sha1',
    digestFactory: digestSha1,
    isGroupExchange: true,
  );

  static const dh14Sha1 = SSHKexType._(
    name: 'diffie-hellman-group14-sha1',
    digestFactory: digestSha1,
  );

  static const dh14Sha256 = SSHKexType._(
    name: 'diffie-hellman-group14-sha256',
    digestFactory: digestSha256,
  );

  static const dh1Sha1 = SSHKexType._(
    name: 'diffie-hellman-group1-sha1',
    digestFactory: digestSha1,
  );

  static const mlkem768x25519Sha256 = SSHKexType._(
    name: 'mlkem768x25519-sha256', digestFactory: digestSha256, isHybrid: true,
  );
  static const sntrup761x25519Sha512 = SSHKexType._(
    name: 'sntrup761x25519-sha512@openssh.com', digestFactory: digestSha512, isHybrid: true,
  );

  const SSHKexType._({
    required this.name,
    required this.digestFactory,
    this.isGroupExchange = false,
    this.isHybrid = false,
  });

  /// The name of the algorithm. For example, `"ecdh-sha2-nistp256"`.
  @override
  final String name;

  final Digest Function() digestFactory;

  final bool isGroupExchange;
  final bool isHybrid;

  Digest createDigest() => digestFactory();
}

typedef SSHKexHybridFactory = SSHKexHybrid Function();
SSHKexHybridFactory? _mlkemFactory;
SSHKexHybridFactory? _sntrupFactory;
void registerMlkem768X25519Factory(SSHKexHybridFactory f) => _mlkemFactory = f;
void registerSntrup761X25519Factory(SSHKexHybridFactory f) => _sntrupFactory = f;
SSHKexHybrid createMlkem768X25519() => _mlkemFactory?.call() ?? (throw StateError('ML-KEM unavailable'));
SSHKexHybrid createSntrup761X25519() => _sntrupFactory?.call() ?? (throw StateError('sntrup unavailable'));

Digest digestSha1() => SHA1Digest();
Digest digestSha256() => SHA256Digest();
Digest digestSha384() => SHA384Digest();
Digest digestSha512() => SHA512Digest();
