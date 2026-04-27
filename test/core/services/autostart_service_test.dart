// Unit tests for the Linux XDG autostart service.
//
// We point the service at a temp `XDG_CONFIG_HOME` so each test owns its
// filesystem state and can be re-run without polluting the real
// `~/.config/autostart/` directory.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:sshvault/core/services/autostart_service.dart';

void main() {
  // The service is gated to Linux at runtime. On other hosts (CI macOS,
  // Windows) we still verify the platform guard fires, but skip the
  // filesystem assertions because the implementation is a no-op there.
  group('AutostartService — platform gating', () {
    test('throws UnsupportedError on non-Linux hosts', () async {
      if (Platform.isLinux) return;
      const svc = AutostartService();
      expect(svc.isEnabled, throwsA(isA<UnsupportedError>()));
      expect(svc.enable, throwsA(isA<UnsupportedError>()));
      expect(svc.disable, throwsA(isA<UnsupportedError>()));
    });
  });

  group('AutostartService — Linux behaviour', () {
    late Directory tempDir;
    late AutostartService svc;

    setUp(() async {
      if (!Platform.isLinux) return;
      tempDir = await Directory.systemTemp.createTemp('sshvault_autostart_');
      svc = AutostartService(
        xdgConfigHomeOverride: tempDir.path,
        execOverride: '/usr/local/bin/sshvault',
        flatpakOverride: false,
      );
    });

    tearDown(() async {
      if (!Platform.isLinux) return;
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('isEnabled is false when no file exists', () async {
      if (!Platform.isLinux) return;
      expect(await svc.isEnabled(), isFalse);
    });

    test('enable() creates a valid .desktop file', () async {
      if (!Platform.isLinux) return;
      await svc.enable();

      final path =
          '${tempDir.path}/autostart/de.kiefer_networks.sshvault.desktop';
      final file = File(path);
      expect(await file.exists(), isTrue);

      final contents = await file.readAsString();
      expect(contents, startsWith('[Desktop Entry]'));
      expect(contents, contains('Type=Application'));
      expect(contents, contains('Name=SSHVault'));
      expect(contents, contains('Exec=/usr/local/bin/sshvault --minimized'));
      expect(contents, contains('Terminal=false'));
      expect(contents, contains('Hidden=false'));
      expect(contents, contains('X-GNOME-Autostart-enabled=true'));
      expect(await svc.isEnabled(), isTrue);
    });

    test('enable(minimized: false) omits the --minimized flag', () async {
      if (!Platform.isLinux) return;
      await svc.enable(minimized: false);
      final contents = await File(
        '${tempDir.path}/autostart/de.kiefer_networks.sshvault.desktop',
      ).readAsString();
      expect(contents, contains('Exec=/usr/local/bin/sshvault\n'));
      expect(contents, isNot(contains('--minimized')));
    });

    test('enable() is idempotent', () async {
      if (!Platform.isLinux) return;
      await svc.enable();
      await svc.enable();
      await svc.enable();
      expect(await svc.isEnabled(), isTrue);
      // Still exactly one entry.
      final dir = Directory('${tempDir.path}/autostart');
      final entries = await dir.list().toList();
      expect(entries, hasLength(1));
    });

    test('disable() removes the file by default', () async {
      if (!Platform.isLinux) return;
      await svc.enable();
      await svc.disable();
      expect(await svc.isEnabled(), isFalse);
      final file = File(
        '${tempDir.path}/autostart/de.kiefer_networks.sshvault.desktop',
      );
      expect(await file.exists(), isFalse);
    });

    test('disable() is idempotent', () async {
      if (!Platform.isLinux) return;
      await svc.disable(); // no-op when nothing is there
      await svc.enable();
      await svc.disable();
      await svc.disable(); // second time should be a no-op
      expect(await svc.isEnabled(), isFalse);
    });

    test('disable(deleteOnDisable=false) sets Hidden=true', () async {
      if (!Platform.isLinux) return;
      final keepSvc = AutostartService(
        xdgConfigHomeOverride: tempDir.path,
        execOverride: '/usr/local/bin/sshvault',
        flatpakOverride: false,
        deleteOnDisable: false,
      );
      await keepSvc.enable();
      await keepSvc.disable();

      final file = File(
        '${tempDir.path}/autostart/de.kiefer_networks.sshvault.desktop',
      );
      expect(await file.exists(), isTrue);
      final contents = await file.readAsString();
      expect(contents, contains('Hidden=true'));
      expect(await keepSvc.isEnabled(), isFalse);
    });

    test('Flatpak override emits flatpak run Exec line', () async {
      if (!Platform.isLinux) return;
      final flatSvc = AutostartService(
        xdgConfigHomeOverride: tempDir.path,
        flatpakOverride: true,
      );
      await flatSvc.enable();
      final contents = await File(
        '${tempDir.path}/autostart/de.kiefer_networks.sshvault.desktop',
      ).readAsString();
      expect(
        contents,
        contains('Exec=flatpak run de.kiefer_networks.sshvault --minimized'),
      );
      expect(contents, contains('X-Flatpak=de.kiefer_networks.sshvault'));
    });
  });

  group('escapeExecValue', () {
    test('passes safe paths through verbatim', () {
      expect(
        escapeExecValue('/usr/local/bin/sshvault'),
        '/usr/local/bin/sshvault',
      );
    });

    test('quotes paths containing spaces', () {
      expect(
        escapeExecValue('/opt/Some App/sshvault'),
        '"/opt/Some App/sshvault"',
      );
    });

    test('escapes embedded quotes and backslashes', () {
      expect(
        escapeExecValue(r'/weird/"quoted"/path with space'),
        r'"/weird/\"quoted\"/path with space"',
      );
    });

    test('doubles literal % per spec', () {
      expect(escapeExecValue('/path/%foo'), '/path/%%foo');
    });
  });

  group('buildDesktopFile', () {
    test('omits X-Flatpak when no app id is given', () {
      final out = buildDesktopFile(execLine: '/bin/sshvault --minimized');
      expect(out, contains('Exec=/bin/sshvault --minimized'));
      expect(out, isNot(contains('X-Flatpak=')));
    });

    test('includes X-Flatpak when an app id is given', () {
      final out = buildDesktopFile(
        execLine: 'flatpak run de.kiefer_networks.sshvault --minimized',
        flatpakAppId: 'de.kiefer_networks.sshvault',
      );
      expect(out, contains('X-Flatpak=de.kiefer_networks.sshvault'));
    });
  });
}
