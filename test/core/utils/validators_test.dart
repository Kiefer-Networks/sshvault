import 'package:flutter_test/flutter_test.dart';
import 'package:sshvault/core/utils/validators.dart';

void main() {
  group('validateHostname', () {
    test('returns error for null', () {
      expect(Validators.validateHostname(null), isNotNull);
    });

    test('returns error for empty string', () {
      expect(Validators.validateHostname(''), isNotNull);
      expect(Validators.validateHostname('   '), isNotNull);
    });

    test('accepts valid hostnames', () {
      expect(Validators.validateHostname('example.com'), isNull);
      expect(Validators.validateHostname('sub.example.com'), isNull);
      expect(Validators.validateHostname('my-server.io'), isNull);
    });

    test('accepts valid IPv4 addresses', () {
      expect(Validators.validateHostname('192.168.1.1'), isNull);
      expect(Validators.validateHostname('10.0.0.1'), isNull);
      expect(Validators.validateHostname('255.255.255.255'), isNull);
      expect(Validators.validateHostname('0.0.0.0'), isNull);
    });

    test('rejects invalid IPv4 addresses', () {
      expect(Validators.validateHostname('256.1.1.1'), isNotNull);
      expect(Validators.validateHostname('1.2.3.999'), isNotNull);
    });

    test('accepts IPv6-like addresses (contains colon, no spaces)', () {
      expect(Validators.validateHostname('::1'), isNull);
      expect(Validators.validateHostname('fe80::1'), isNull);
    });

    test('rejects invalid hostnames', () {
      expect(Validators.validateHostname('not valid hostname'), isNotNull);
    });
  });

  group('validatePort', () {
    test('returns error for null/empty', () {
      expect(Validators.validatePort(null), isNotNull);
      expect(Validators.validatePort(''), isNotNull);
    });

    test('accepts valid ports', () {
      expect(Validators.validatePort('1'), isNull);
      expect(Validators.validatePort('22'), isNull);
      expect(Validators.validatePort('443'), isNull);
      expect(Validators.validatePort('8080'), isNull);
      expect(Validators.validatePort('65535'), isNull);
    });

    test('rejects out-of-range ports', () {
      expect(Validators.validatePort('0'), isNotNull);
      expect(Validators.validatePort('65536'), isNotNull);
      expect(Validators.validatePort('-1'), isNotNull);
    });

    test('rejects non-numeric values', () {
      expect(Validators.validatePort('abc'), isNotNull);
      expect(Validators.validatePort('22.5'), isNotNull);
    });
  });

  group('validateUsername', () {
    test('returns error for null/empty', () {
      expect(Validators.validateUsername(null), isNotNull);
      expect(Validators.validateUsername(''), isNotNull);
    });

    test('accepts valid usernames', () {
      expect(Validators.validateUsername('root'), isNull);
      expect(Validators.validateUsername('deploy_user'), isNull);
      expect(Validators.validateUsername('user-name'), isNull);
      expect(Validators.validateUsername('_service'), isNull);
      expect(Validators.validateUsername('user.name'), isNull);
    });

    test('rejects invalid usernames', () {
      expect(Validators.validateUsername('123start'), isNotNull);
      expect(Validators.validateUsername('-dash'), isNotNull);
      expect(Validators.validateUsername('.dot'), isNotNull);
    });

    test('rejects too-long usernames (>32 chars)', () {
      expect(Validators.validateUsername('a' * 33), isNotNull);
    });

    test('accepts max-length username (32 chars)', () {
      expect(Validators.validateUsername('a' * 32), isNull);
    });
  });

  group('validateServerName', () {
    test('returns error for null/empty', () {
      expect(Validators.validateServerName(null), isNotNull);
      expect(Validators.validateServerName(''), isNotNull);
    });

    test('accepts valid server names', () {
      expect(Validators.validateServerName('Production Server'), isNull);
      expect(Validators.validateServerName('dev-01'), isNull);
    });

    test('rejects names over 100 chars', () {
      expect(Validators.validateServerName('x' * 101), isNotNull);
    });

    test('accepts 100-char name', () {
      expect(Validators.validateServerName('x' * 100), isNull);
    });
  });

  group('validateRequired', () {
    test('returns error with field name for null/empty', () {
      final result = Validators.validateRequired(null, 'Email');
      expect(result, contains('Email'));
      expect(result, contains('required'));
    });

    test('returns null for non-empty value', () {
      expect(Validators.validateRequired('value', 'Field'), isNull);
    });
  });
}
