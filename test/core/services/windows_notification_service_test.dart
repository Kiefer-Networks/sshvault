/// Unit tests for [WindowsNotificationService].
///
/// We do NOT bring up the real `local_notifier` plugin (it requires the
/// Win32 ToastNotificationManager and a registered AUMID — neither is
/// available under `flutter test`). Instead we cover:
///
///   1. Linux / macOS passthrough: `show()` is a no-op on non-Windows
///      hosts, so callers can use the service from cross-platform code
///      without crashing.
///   2. The `WindowsNotificationAction` data class round-trips its
///      `label` and `tag` exactly — view-models route on the tag prefix,
///      so any silent mutation here would break the action handlers.
///   3. The action stream is a broadcast stream and survives multiple
///      listeners attaching / detaching (the `dispose()` contract).
///
/// We deliberately keep the public surface small enough that the
/// platform-specific code path can be verified by integration tests on
/// Windows runners without rewriting these unit tests.
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:sshvault/core/services/windows_notification_service.dart';

void main() {
  group('WindowsNotificationAction', () {
    test('preserves label and tag verbatim', () {
      const action = WindowsNotificationAction(
        label: 'Disconnect',
        tag: 'disconnect:abc-123',
      );

      expect(action.label, 'Disconnect');
      expect(action.tag, 'disconnect:abc-123');
    });

    test('tags carrying colons round-trip without truncation', () {
      // The router relies on splitting at the first colon; tags must keep
      // any trailing colons intact so payloads like UUIDs stay correct.
      const action = WindowsNotificationAction(
        label: 'Reconnect',
        tag: 'reconnect:host:42',
      );

      expect(action.tag, 'reconnect:host:42');
    });
  });

  group('WindowsNotificationService — non-Windows passthrough', () {
    test('show() is a no-op on Linux / macOS', () async {
      // On non-Windows hosts the service short-circuits before touching
      // local_notifier — the call must complete without throwing.
      if (Platform.isWindows) {
        // Skip: Windows runner exercises the real path in integration tests.
        return;
      }

      final service = WindowsNotificationService();
      await service.show(
        id: 'session-1',
        title: 'Session active',
        body: 'host.example.com',
        actions: const [
          WindowsNotificationAction(label: 'Disconnect', tag: 'disconnect:s1'),
          WindowsNotificationAction(label: 'Show', tag: 'show:'),
        ],
      );
      // dismiss() of an unknown id must also be a no-op.
      await service.dismiss('session-1');
      await service.dispose();
    });

    test('actionStream is a broadcast stream', () async {
      final service = WindowsNotificationService();
      final stream = service.actionStream;

      // Two listeners may attach at the same time without throwing
      // "Bad state: Stream has already been listened to".
      final subA = stream.listen((_) {});
      final subB = stream.listen((_) {});

      await subA.cancel();
      await subB.cancel();
      await service.dispose();
    });

    test('dispose() closes the action stream cleanly', () async {
      final service = WindowsNotificationService();
      final completer = Completer<void>();
      final sub = service.actionStream.listen(
        (_) {},
        onDone: completer.complete,
      );

      await service.dispose();
      // onDone fires synchronously after dispose; await with a short
      // timeout so the test fails loudly if the contract regresses.
      await completer.future.timeout(const Duration(seconds: 1));
      await sub.cancel();
    });
  });

  group('AUMID constant', () {
    test('matches the value registered by Inno Setup', () {
      // The registry key written by `windows/installer.iss` is keyed by
      // this exact string. A drift in either direction would silently
      // break Action-Center icon resolution, so pin it here.
      expect(kSshVaultAumid, 'de.kiefer_networks.SSHVault');
    });
  });
}
