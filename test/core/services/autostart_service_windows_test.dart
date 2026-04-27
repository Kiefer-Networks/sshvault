// Unit tests for the Windows Run-key autostart backend.
//
// These tests run on every host (Linux CI included) by injecting an
// in-memory [WindowsRegistryStub] so we never touch the real registry
// and don't need the FFI-loaded `advapi32.dll`. They verify the exact
// subkey path, value name, REG_SZ data and quoting that
// [AutostartService] would produce on a real Windows host.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:sshvault/core/services/autostart_service.dart';

/// Pure-Dart fake of [WindowsRegistryStub]. Stores values in a
/// `subkey -> valueName -> data` map so tests can read them back.
class _FakeRegistry implements WindowsRegistryStub {
  final Map<String, Map<String, String>> values = {};

  @override
  String? readString({required String subkey, required String valueName}) {
    return values[subkey]?[valueName];
  }

  @override
  void writeString({
    required String subkey,
    required String valueName,
    required String data,
  }) {
    values.putIfAbsent(subkey, () => {})[valueName] = data;
  }

  @override
  void deleteValue({required String subkey, required String valueName}) {
    values[subkey]?.remove(valueName);
  }
}

void main() {
  // The Windows backend dispatches off `Platform.isWindows`, so the
  // public AutostartService API can only be exercised end-to-end on a
  // Windows host. The behavioural tests below therefore split into:
  //   1. End-to-end (`AutostartService.enable/...`) — Windows only.
  //   2. Pure-helper unit tests (`buildWindowsRunValue`, registry stub)
  //      that run everywhere.

  group('buildWindowsRunValue (pure)', () {
    test('quotes the EXE path and appends --minimized', () {
      final v = buildWindowsRunValue(
        exe: r'C:\Program Files\SSHVault\sshvault.exe',
        minimized: true,
      );
      expect(v, r'"C:\Program Files\SSHVault\sshvault.exe" --minimized');
    });

    test('quotes the EXE path without --minimized when disabled', () {
      final v = buildWindowsRunValue(
        exe: r'C:\Program Files\SSHVault\sshvault.exe',
        minimized: false,
      );
      expect(v, r'"C:\Program Files\SSHVault\sshvault.exe"');
    });

    test('does not double-quote already-quoted paths', () {
      final v = buildWindowsRunValue(
        exe: r'"C:\Program Files\SSHVault\sshvault.exe"',
        minimized: true,
      );
      expect(v, r'"C:\Program Files\SSHVault\sshvault.exe" --minimized');
    });

    test('handles paths without spaces', () {
      final v = buildWindowsRunValue(
        exe: r'D:\Tools\sshvault.exe',
        minimized: true,
      );
      expect(v, r'"D:\Tools\sshvault.exe" --minimized');
    });

    test('trims surrounding whitespace before quoting', () {
      final v = buildWindowsRunValue(
        exe: '   C:\\App\\sshvault.exe   ',
        minimized: true,
      );
      expect(v, r'"C:\App\sshvault.exe" --minimized');
    });
  });

  group('windowsRunKeySubkey constant', () {
    test('points at the per-user Run key', () {
      expect(
        windowsRunKeySubkey,
        r'Software\Microsoft\Windows\CurrentVersion\Run',
      );
    });
    test('value name is SSHVault (matches Inno uninsdeletevalue)', () {
      expect(windowsRunValueName, 'SSHVault');
    });
  });

  group('AutostartService — Windows behaviour (stubbed registry)', () {
    // These tests mock the FFI layer entirely via WindowsRegistryStub,
    // so they only run on a real Windows host where `Platform.isWindows`
    // is true (the public API gates on the Platform check).
    late _FakeRegistry registry;
    late AutostartService svc;

    setUp(() {
      if (!Platform.isWindows) return;
      registry = _FakeRegistry();
      svc = AutostartService(
        execOverride: r'C:\Program Files\SSHVault\sshvault.exe',
        registryOverride: registry,
      );
    });

    test('isEnabled is false when the value is absent', () async {
      if (!Platform.isWindows) return;
      expect(await svc.isEnabled(), isFalse);
    });

    test('enable() writes the expected subkey + value + data', () async {
      if (!Platform.isWindows) return;
      await svc.enable(minimized: true);

      final stored = registry.values[windowsRunKeySubkey];
      expect(stored, isNotNull);
      expect(stored!.containsKey('SSHVault'), isTrue);
      expect(
        stored['SSHVault'],
        r'"C:\Program Files\SSHVault\sshvault.exe" --minimized',
      );
    });

    test('isEnabled becomes true after enable()', () async {
      if (!Platform.isWindows) return;
      await svc.enable(minimized: true);
      expect(await svc.isEnabled(), isTrue);
    });

    test('enable(minimized: false) omits the --minimized flag', () async {
      if (!Platform.isWindows) return;
      await svc.enable(minimized: false);
      expect(
        registry.values[windowsRunKeySubkey]!['SSHVault'],
        r'"C:\Program Files\SSHVault\sshvault.exe"',
      );
    });

    test('disable() removes the value', () async {
      if (!Platform.isWindows) return;
      await svc.enable(minimized: true);
      await svc.disable();
      expect(await svc.isEnabled(), isFalse);
      // The value should be gone, not just blanked.
      final m = registry.values[windowsRunKeySubkey];
      expect(m == null || !m.containsKey('SSHVault'), isTrue);
    });

    test('disable() is a no-op when nothing is registered', () async {
      if (!Platform.isWindows) return;
      // Should not throw.
      await svc.disable();
      expect(await svc.isEnabled(), isFalse);
    });

    test('enable() is idempotent', () async {
      if (!Platform.isWindows) return;
      await svc.enable(minimized: true);
      await svc.enable(minimized: true);
      // Single value, written twice — same data.
      expect(
        registry.values[windowsRunKeySubkey]!['SSHVault'],
        r'"C:\Program Files\SSHVault\sshvault.exe" --minimized',
      );
    });
  });

  group('AutostartService — non-Windows / non-Linux gating', () {
    test('throws UnsupportedError on macOS', () async {
      if (Platform.isLinux || Platform.isWindows) return;
      const svc = AutostartService();
      expect(svc.isEnabled, throwsA(isA<UnsupportedError>()));
      expect(svc.enable, throwsA(isA<UnsupportedError>()));
      expect(svc.disable, throwsA(isA<UnsupportedError>()));
    });
  });
}
