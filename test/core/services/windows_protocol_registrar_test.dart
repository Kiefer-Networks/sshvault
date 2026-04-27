// Unit tests for the Windows ssh:// / sftp:// URL scheme + key file
// association registrar. We never touch the real Windows registry — every
// test runs against [_FakeRegistryBackend], an in-memory map that records
// the same write/read/delete calls the FFI layer would make. That lets
// these assertions run identically on Linux / macOS CI.

import 'package:flutter_test/flutter_test.dart';

import 'package:sshvault/core/services/windows_protocol_registrar.dart';

void main() {
  group('buildSshVaultRegistryEntries', () {
    const exe = r'C:\Program Files\SSHVault\sshvault.exe';
    final entries = buildSshVaultRegistryEntries(exe);

    test('registers ssh:// URL scheme with all four required values', () {
      // The classic Windows URL-protocol shape: marker + URL Protocol +
      // DefaultIcon + shell\open\command. Anything missing breaks the
      // shell handler.
      expect(
        entries,
        contains(
          const RegistryEntry(
            path: r'Software\Classes\ssh',
            data: 'URL:Secure Shell',
          ),
        ),
      );
      expect(
        entries,
        contains(
          const RegistryEntry(
            path: r'Software\Classes\ssh',
            name: 'URL Protocol',
            data: '',
          ),
        ),
      );
      expect(
        entries,
        contains(
          const RegistryEntry(
            path: r'Software\Classes\ssh\DefaultIcon',
            data: '$exe,0',
          ),
        ),
      );
      expect(
        entries,
        contains(
          const RegistryEntry(
            path: r'Software\Classes\ssh\shell\open\command',
            data: '"$exe" "%1"',
          ),
        ),
      );
    });

    test('registers sftp:// URL scheme with all four required values', () {
      expect(
        entries.any(
          (e) =>
              e.path == r'Software\Classes\sftp' &&
              e.name.isEmpty &&
              e.data == 'URL:SSH File Transfer Protocol',
        ),
        isTrue,
      );
      expect(
        entries.any(
          (e) => e.path == r'Software\Classes\sftp' && e.name == 'URL Protocol',
        ),
        isTrue,
      );
      expect(
        entries.any(
          (e) =>
              e.path == r'Software\Classes\sftp\shell\open\command' &&
              e.data == '"$exe" "%1"',
        ),
        isTrue,
      );
    });

    test('maps .pub / .pem / .ppk to their ProgIDs', () {
      expect(
        entries,
        contains(
          const RegistryEntry(
            path: r'Software\Classes\.pub',
            data: 'SSHVault.PublicKey',
          ),
        ),
      );
      expect(
        entries,
        contains(
          const RegistryEntry(
            path: r'Software\Classes\.pem',
            data: 'SSHVault.PEMKey',
          ),
        ),
      );
      expect(
        entries,
        contains(
          const RegistryEntry(
            path: r'Software\Classes\.ppk',
            data: 'SSHVault.PPKKey',
          ),
        ),
      );
    });

    test('ProgID open commands invoke --import-keys', () {
      const progIds = [
        'SSHVault.PublicKey',
        'SSHVault.PEMKey',
        'SSHVault.PPKKey',
      ];
      for (final id in progIds) {
        expect(
          entries.any(
            (e) =>
                e.path == 'Software\\Classes\\$id\\shell\\open\\command' &&
                e.data == '"$exe" --import-keys "%1"',
          ),
          isTrue,
          reason: '$id missing import-keys command',
        );
      }
    });

    test('every key path lives under HKCU\\Software\\Classes', () {
      for (final e in entries) {
        expect(
          e.path,
          startsWith(r'Software\Classes\'),
          reason: 'Entry $e leaks outside Software\\Classes',
        );
      }
    });
  });

  group('WindowsProtocolRegistrar (mocked FFI backend)', () {
    const exe = r'C:\Apps\sshvault\sshvault.exe';

    test('isRegistered returns false on a clean registry', () async {
      final fake = _FakeRegistryBackend();
      const registrar = WindowsProtocolRegistrar(
        exePathOverride: exe,
        platformIsWindowsOverride: true,
      );
      // Override via copy: `backendOverride` is final on the const ctor,
      // so build a fresh instance with both overrides.
      final r = WindowsProtocolRegistrar(
        exePathOverride: exe,
        backendOverride: fake,
        platformIsWindowsOverride: true,
      );
      expect(await r.isRegistered(), isFalse);
      // Sanity: the const-only registrar above is never used; assertion
      // below silences any lints about unused locals.
      expect(registrar.exePathOverride, exe);
    });

    test('register() writes every entry via the backend', () async {
      final fake = _FakeRegistryBackend();
      final r = WindowsProtocolRegistrar(
        exePathOverride: exe,
        backendOverride: fake,
        platformIsWindowsOverride: true,
      );

      await r.register();

      final expected = buildSshVaultRegistryEntries(exe);
      // Every entry must be in the fake's writes.
      for (final e in expected) {
        expect(
          fake.writes.any(
            (w) => w.path == e.path && w.name == e.name && w.data == e.data,
          ),
          isTrue,
          reason: 'Missing write for $e',
        );
      }
      // No extras either — the registrar must not leak unexpected keys.
      expect(fake.writes.length, expected.length);
    });

    test('isRegistered round-trips after register()', () async {
      final fake = _FakeRegistryBackend();
      final r = WindowsProtocolRegistrar(
        exePathOverride: exe,
        backendOverride: fake,
        platformIsWindowsOverride: true,
      );

      expect(await r.isRegistered(), isFalse);
      await r.register();
      expect(await r.isRegistered(), isTrue);
    });

    test('isRegistered detects a stale exe path mismatch', () async {
      final fake = _FakeRegistryBackend();
      // Pre-populate the registry with values that point at an OLD path
      // (simulating a portable build that was moved). The current binary
      // path is `exe`, so isRegistered must report false.
      for (final e in buildSshVaultRegistryEntries(r'C:\Old\sshvault.exe')) {
        await fake.writeString(e.path, e.name, e.data);
      }
      final r = WindowsProtocolRegistrar(
        exePathOverride: exe,
        backendOverride: fake,
        platformIsWindowsOverride: true,
      );
      expect(await r.isRegistered(), isFalse);
    });

    test('unregister() removes every owned root', () async {
      final fake = _FakeRegistryBackend();
      final r = WindowsProtocolRegistrar(
        exePathOverride: exe,
        backendOverride: fake,
        platformIsWindowsOverride: true,
      );
      await r.register();
      expect(await r.isRegistered(), isTrue);

      await r.unregister();
      // After unregister, no top-level root may remain.
      for (final root in kSshVaultRegistryRoots) {
        final present = fake.store.keys.any((k) => k.startsWith(root));
        expect(
          present,
          isFalse,
          reason: '$root still present after unregister',
        );
      }
    });

    test('non-Windows platform short-circuits to no-op', () async {
      final fake = _FakeRegistryBackend();
      final r = WindowsProtocolRegistrar(
        exePathOverride: exe,
        backendOverride: fake,
        platformIsWindowsOverride: false,
      );
      // isRegistered should treat non-Windows as "registered" so first-run
      // logic skips the prompt entirely.
      expect(await r.isRegistered(), isTrue);
      await r.register();
      await r.unregister();
      expect(fake.writes, isEmpty);
      expect(fake.deletes, isEmpty);
    });
  });
}

/// In-memory fake of the FFI registry backend. Records every write and
/// delete so tests can assert the exact key/path/data tuples.
class _FakeRegistryBackend implements WindowsRegistryBackend {
  /// Flattened key+name -> data, mirroring the Win32 model where every
  /// key has zero or more named values plus one unnamed `(default)` value.
  final Map<String, Map<String, String>> store =
      <String, Map<String, String>>{};
  final List<RegistryEntry> writes = <RegistryEntry>[];
  final List<String> deletes = <String>[];

  @override
  Future<bool> keyExists(String path) async => store.containsKey(path);

  @override
  Future<String?> readString(String path, String name) async {
    final values = store[path];
    if (values == null) return null;
    return values[name];
  }

  @override
  Future<void> writeString(String path, String name, String data) async {
    store.putIfAbsent(path, () => <String, String>{})[name] = data;
    writes.add(RegistryEntry(path: path, name: name, data: data));
  }

  @override
  Future<void> deleteTree(String path) async {
    deletes.add(path);
    store.removeWhere((key, _) => key == path || key.startsWith('$path\\'));
  }
}
