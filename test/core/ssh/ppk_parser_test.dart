import 'package:flutter_test/flutter_test.dart';
import 'package:sshvault/core/crypto/ssh_key_type.dart';
import 'package:sshvault/core/ssh/ppk_parser.dart';

// Real PPK fixtures generated against the published PPK v2/v3 spec
// (the same algorithms `puttygen` uses). v2 uses HMAC-SHA1 with a SHA-1
// derived MAC key; v3 uses Argon2id + HMAC-SHA-256.
//
// Pairs:
//   - PPK_V2_PLAIN_RSA           — unencrypted, RSA-2048
//   - PPK_V2_ENC_RSA             — passphrase "test123", RSA-2048
//   - PPK_V3_PLAIN_ED25519       — unencrypted, Ed25519
//   - PPK_V3_ENC_ED25519         — passphrase "test123", Ed25519, Argon2id
//   - PPK_V3_PLAIN_ECDSA_P256    — unencrypted, NIST P-256

const _ppkV2PlainRsa = '''PuTTY-User-Key-File-2: ssh-rsa
Encryption: none
Comment: rsa-v2-plain
Public-Lines: 6
AAAAB3NzaC1yc2EAAAADAQABAAABAQC1XuPM7CVTqtSIwCV14LvSO0ulKTtO+puM
9PT4+PGZYc0KHe7sSnui+nEm1sTlYwc0CycmStPCr2zKds1b2gGtdcOKtUqiesKw
kfP5/dvkkS6W0ASrgQndrmrDiPwXQJPB9fTflrYa/F/VIuMGlOF7LgCoaDIWxukL
5HU8qCrjl7MB4+/9gM9tIK6OJ1/bevvs37tkHOgihc/TS/KH1uAoUnUbpDQ4Q4+4
/6PkNyh49kuJtMsuo8slcLg+scalU0qCpCRjl8F9RLuRfOiUWxQ8wGERguTQcKGq
Ee8ccz0LyRrAvPhsXXRe+8K7fkibERPMy4jY37LuMEdxOhKdjcTT
Private-Lines: 14
AAABAE9DmJfqzkdZ/ceD/fsdy8fNnTohomdaU9fPCC61EVVArkzRFyVSSeVIwWHB
c8xyMmg2xZXRFunbI9b6A7a0OI53zI0WvPb0YpirOK6VGOAz6OIFKD1RyB+HReaN
u+pnkQuv86QxqAV0LWem9wPd1gsw6B2xZ86XgKrvXaM0NYY//Ytq+VAbeyQ2s7LQ
Pzmi01bf/mA+4x4jHOXQD26SmdcDF/gF4bo1pudC+4bpFIUK560yWe3sKLQ5dnZO
cLYlPmhl6m4MuFf/6XQYy9eG+1lPr/VA58fppl8c3V15fo0+bgucZ6S2ANrM/Kd7
89Z3qtQ2xR+5Z3nE6y1GAdUghyEAAACBAOlzYX97VLzHmrERxc2Dh0QuzG8aO8S2
k/YgyLostXpvahrByfhmpej7wwgE7cwUWzryvlK09Xth+FHwHpneT6H09myx5V9e
V1EsjKE3vyyZfol+rdOD9vK+XC3yCFyjM/B0LlP9MhvrvUxoVMpB7BDFsKl4sMLj
0CJ4X/JnDnFhAAAAgQDG47UG5l6v3HZzvbEyOXkEGUSDZzLOi6Hz3BfIQN6+Dms4
UXYBGEW9ZePwx8vcqYqUviWmLYA4oyc3xdvhrcvAEFP8OQJRRmi5y68dwa6wdv20
ZxqdTU1+zyaUgzI7NVYb5RzfKAns6dX5+V1eBj1H0PdU7MdyQgL3JjhYfF8+swAA
AIAB+/n+HZCVf50liW+ey2vBNoq5aq/avckHQBFYnoKoBKKaArox8SyOO5cqQ+ZH
e4D7vVvyfx/P1DgOxpTD1GESsaL8O3eoUJ2FV3AeJNth7ATGN51R6WwFv4rU4tV4
rUMM+yipssEPiBEtKUKIfS9nUIDUQHvfC3pdmtF+d7UmLg==
Private-MAC: dfed72ace8953ab26d8b82af980d345af9d01e72
''';

const _ppkV2EncRsa = '''PuTTY-User-Key-File-2: ssh-rsa
Encryption: aes256-cbc
Comment: rsa-v2-enc
Public-Lines: 6
AAAAB3NzaC1yc2EAAAADAQABAAABAQDb5/RMRQcjIPD38v4rzWmQKCcLgEsDnvW4
ubVGFcEwSVOoQdZs4mZFVJzq2rHeJ07VM+2ChMczsvRJGnp9CAH0Wn2uUdPpUUfM
n3X/Qr7oKJA7zP6g6sC5rZp5wOvCxWapMTJDJRhLnLfMlA1C0kwOO6iFA0HhnTw6
zpeCpR8RpapZ0cmbjeN2C9R7By4YCtq00k9/XwTdKEBk7CvY28Jj9URv+asSapWR
xeBH0psTCcPcSbZgM+JcMVmgnkAd7OHqOBA4bu/qGDzXAwZdUyQ6XZllBpWSIT3p
JZPo/UVj6Irmq4P4/eso9rLu8AUyQ6eKqOf6S/2EVKi65RVeDrIn
Private-Lines: 14
xaF8qHkuakMlxJb+v/dPXuGu+Tz2S6/ybNReFVWPz/It5EgOD+SkvmQFWcRmEBP6
PoUAI9CvscX+lS1jXGJG8YsjQa4qHBnpxouAUwWbHTuMsyJtfHlu+cGXxlsFWa+a
Z/tjFQsSR0u1Zre2uWAJpnKRlVhWPh6VoSNxqo8+E+dJP3sf/imdWjcznxB7ClqY
xNLG1XQwGW16g2xqfh+WNoJbKC4HRav+4qq8rknIFjylzgQBEDzHrAcdkrKKUjJU
96YOYX+sPWhejzy0hWsW1+6bu4SPrf09QsI7LcCXaFTQBfF59nMKLyIJVJwR9sqG
Q1a8XdMCSmpQeVER59NirNtd878MnT2ZgHDmd+v5il8kfo6N80C1iHQoorb3qI1B
3/5gugRn7RY0coZF/KsFY0VAue5M3isLddIT/4MnCjq6sMy3wpTqKUuxkYLwTc4Y
H5XGeFMF8HwU372aYieS7b8uut7sK0jbRctESmhQz9ZN9zF+11h4J/Y3pGveUOkc
8DyFHMT2hu5cJAOPEc7bgN/gNUcsEBfQdBT+LV1hBhXR3wx+KoIssv40w9Qv2Mgt
Pofec4PHRpJARHddTbOEAvf0P2EdZASUK38Y5A7Ym03uqGqWhh9H4xCcED1IYQyX
U2DRSQOqCp7Az2M/iFoJI4UssWNwkrMK0+RjVLjoLg+H5MXk9kd1/UhvKt2pFx6w
Rpu+xlsZWj56fG8swEAveTDD8QSBWx+BO36oxzmYsLiMmhdRoq/bKkJjLlgWhTiX
UtR3EmPsj0f++JP+wnL57i6UO3gY59LSu8iKrVu4X/Efthb+b8DOBoKfqi3LEspZ
buVw6VYBHYVPd/+POdLTH+fAFCxRAb4h09ZQ0H+B1h2K+CrSQQmrIwW9nD78qusQ
Private-MAC: 15f239a759212d7fa94b153ada26f66e04772fbc
''';

const _ppkV3PlainEd25519 = '''PuTTY-User-Key-File-3: ssh-ed25519
Encryption: none
Comment: ed25519-v3-plain
Public-Lines: 2
AAAAC3NzaC1lZDI1NTE5AAAAIL8aEwqKIHdNbCek+CyHRHXAja+UgBkliGOxRQDr
rc+/
Private-Lines: 1
AAAAIQDIcl+gIcIJoYx3rR82alCbhGOu1kD2vVZp6KxZz9nzRA==
Private-MAC: 428f9620a1182e59e3fc7dfc02021300246ef4d656740ebdd665e7e80d5ccefb
''';

const _ppkV3EncEd25519 = '''PuTTY-User-Key-File-3: ssh-ed25519
Encryption: aes256-cbc
Comment: ed25519-v3-enc
Key-Derivation: Argon2id
Argon2-Memory: 8192
Argon2-Passes: 8
Argon2-Parallelism: 1
Argon2-Salt: 26166e285936ba5856f7b7ea03b967be
Public-Lines: 2
AAAAC3NzaC1lZDI1NTE5AAAAIB1LCjcpIu0VwVLfQbazZa5zv/eOAg3E7lJKXXdG
xm7u
Private-Lines: 1
7jxal7GQCCu726N9XJYFkxo3cLWt+7KmSdHNTO35WQk3617XMkOGf9nNlEkpVhAd
Private-MAC: f9177266a25cc0d560608a82fd4f5776d0f3ab1428565ea140a39a44699474a9
''';

const _ppkV3PlainEcdsaP256 = '''PuTTY-User-Key-File-3: ecdsa-sha2-nistp256
Encryption: none
Comment: ecdsa-p256-v3-plain
Public-Lines: 3
AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHDgCDdEX3R5
lzI37N0V8+kdPy6N3CCeqwTi0eouaPEfhvT/PYOpQDHLpo6W6bbTxW+jUwlpz7NK
xVKccMwIFAo=
Private-Lines: 1
AAAAID8h90syS7Y3vXJc8gFpK/vR8UaL0IiZZl1ejTfUPop0
Private-MAC: 2eae3b250864fe83fb2dbc26ea23c5a928d30edcf1abc9a45f04b9f9be4660aa
''';

void main() {
  group('PpkParser.looksLikePpk', () {
    test('detects v2 header', () {
      expect(PpkParser.looksLikePpk(_ppkV2PlainRsa), isTrue);
    });

    test('detects v3 header', () {
      expect(PpkParser.looksLikePpk(_ppkV3PlainEd25519), isTrue);
    });

    test('rejects PEM key', () {
      expect(
        PpkParser.looksLikePpk('-----BEGIN OPENSSH PRIVATE KEY-----\nfoo'),
        isFalse,
      );
    });
  });

  group('PpkParser.parse — unencrypted keys', () {
    test('PPK v2 RSA round-trips into OpenSSH', () async {
      final r = await PpkParser.parse(_ppkV2PlainRsa);
      expect(r.type, SshKeyType.rsa);
      expect(r.comment, 'rsa-v2-plain');
      expect(r.openSshPublicKey, startsWith('ssh-rsa '));
      expect(r.openSshPublicKey.endsWith(' rsa-v2-plain'), isTrue);
      expect(
        r.openSshPrivateKey,
        startsWith('-----BEGIN OPENSSH PRIVATE KEY-----'),
      );
      expect(r.fingerprint, startsWith('SHA256:'));
    });

    test('PPK v3 Ed25519 round-trips into OpenSSH', () async {
      final r = await PpkParser.parse(_ppkV3PlainEd25519);
      expect(r.type, SshKeyType.ed25519);
      expect(r.comment, 'ed25519-v3-plain');
      expect(r.openSshPublicKey, startsWith('ssh-ed25519 '));
      expect(
        r.openSshPrivateKey,
        startsWith('-----BEGIN OPENSSH PRIVATE KEY-----'),
      );
    });

    test('PPK v3 ECDSA P-256 round-trips into OpenSSH', () async {
      final r = await PpkParser.parse(_ppkV3PlainEcdsaP256);
      expect(r.type, SshKeyType.ecdsa256);
      expect(r.openSshPublicKey, startsWith('ecdsa-sha2-nistp256 '));
      expect(r.comment, 'ecdsa-p256-v3-plain');
    });
  });

  group('PpkParser.parse — encrypted keys', () {
    test('PPK v2 RSA decrypts with correct passphrase', () async {
      final r = await PpkParser.parse(_ppkV2EncRsa, passphrase: 'test123');
      expect(r.type, SshKeyType.rsa);
      expect(r.comment, 'rsa-v2-enc');
    });

    test('PPK v2 RSA rejects wrong passphrase', () async {
      expect(
        () => PpkParser.parse(_ppkV2EncRsa, passphrase: 'wrong'),
        throwsA(isA<PpkParseException>()),
      );
    });

    test('PPK v2 RSA refuses missing passphrase', () async {
      expect(
        () => PpkParser.parse(_ppkV2EncRsa),
        throwsA(isA<PpkParseException>()),
      );
    });

    test(
      'PPK v3 Ed25519 decrypts with Argon2id (correct passphrase)',
      () async {
        final r = await PpkParser.parse(
          _ppkV3EncEd25519,
          passphrase: 'test123',
        );
        expect(r.type, SshKeyType.ed25519);
        expect(r.comment, 'ed25519-v3-enc');
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'PPK v3 Ed25519 rejects wrong passphrase',
      () async {
        expect(
          () => PpkParser.parse(_ppkV3EncEd25519, passphrase: 'wrong'),
          throwsA(isA<PpkParseException>()),
        );
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );
  });

  group('PpkParser.parse — MAC tampering', () {
    test('rejects v2 key with corrupted MAC', () async {
      // Flip the last hex digit of the MAC line.
      final tampered = _ppkV2PlainRsa.replaceFirst(
        'Private-MAC: dfed72ace8953ab26d8b82af980d345af9d01e72',
        'Private-MAC: dfed72ace8953ab26d8b82af980d345af9d01e73',
      );
      expect(
        () => PpkParser.parse(tampered),
        throwsA(isA<PpkParseException>()),
      );
    });

    test('rejects v3 key with corrupted MAC', () async {
      final tampered = _ppkV3PlainEd25519.replaceFirst(
        '428f9620a1182e59e3fc7dfc02021300246ef4d656740ebdd665e7e80d5ccefb',
        '428f9620a1182e59e3fc7dfc02021300246ef4d656740ebdd665e7e80d5ccefc',
      );
      expect(
        () => PpkParser.parse(tampered),
        throwsA(isA<PpkParseException>()),
      );
    });
  });
}
