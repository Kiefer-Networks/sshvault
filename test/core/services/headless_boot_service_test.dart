import 'package:flutter_test/flutter_test.dart';

import 'package:sshvault/core/services/headless_boot_service.dart';

void main() {
  group('HeadlessBootService', () {
    final boot = HeadlessBootService.instance;

    setUp(() {
      // Each test starts from a known-clean state so flag mutations from
      // earlier tests don't bleed across cases.
      boot.debugReset();
    });

    tearDown(() {
      boot.debugReset();
    });

    group('isHeadlessBoot', () {
      test('is false when startMinimized is off', () {
        HeadlessBootService.startMinimized = false;
        expect(boot.isHeadlessBoot, isFalse);
      });

      test('is true while startMinimized is on and window not surfaced', () {
        HeadlessBootService.startMinimized = true;
        expect(boot.isHeadlessBoot, isTrue);
      });

      test('flips to false after markWindowSurfaced()', () {
        HeadlessBootService.startMinimized = true;
        expect(boot.isHeadlessBoot, isTrue);
        boot.markWindowSurfaced();
        expect(boot.isHeadlessBoot, isFalse);
      });
    });

    group('applySettings', () {
      test('mirrors the close-to-tray flag from settings', () {
        boot.applySettings(closeToTraySetting: true);
        expect(boot.closeToTray, isTrue);
        boot.applySettings(closeToTraySetting: false);
        expect(boot.closeToTray, isFalse);
      });

      test('mirrors the resume-on-login flag from settings', () {
        boot.applySettings(resumeOnLoginSetting: true);
        expect(boot.resumeOnLogin, isTrue);
        boot.applySettings(resumeOnLoginSetting: false);
        expect(boot.resumeOnLogin, isFalse);
      });

      test('null arguments preserve the current flag value', () {
        boot.applySettings(
          closeToTraySetting: true,
          resumeOnLoginSetting: true,
        );
        boot.applySettings(); // both null
        expect(boot.closeToTray, isTrue);
        expect(boot.resumeOnLogin, isTrue);
      });
    });

    group('resumeSavedSessions', () {
      test('returns empty when not booted minimized', () async {
        HeadlessBootService.startMinimized = false;
        boot.resumeOnLogin = true;
        boot.wirePersistence(
          loadLastActiveHosts: () async => ['srv-1', 'srv-2'],
          openSession: (_) async {},
        );
        final result = await boot.resumeSavedSessions();
        expect(result, isEmpty);
      });

      test('returns empty when resumeOnLogin is off', () async {
        HeadlessBootService.startMinimized = true;
        boot.resumeOnLogin = false;
        boot.wirePersistence(
          loadLastActiveHosts: () async => ['srv-1'],
          openSession: (_) async {},
        );
        final result = await boot.resumeSavedSessions();
        expect(result, isEmpty);
      });

      test('returns empty when persistence is unwired', () async {
        HeadlessBootService.startMinimized = true;
        boot.resumeOnLogin = true;
        // No wirePersistence call.
        final result = await boot.resumeSavedSessions();
        expect(result, isEmpty);
      });

      test('opens every persisted host id when enabled', () async {
        HeadlessBootService.startMinimized = true;
        boot.resumeOnLogin = true;

        final opened = <String>[];
        boot.wirePersistence(
          loadLastActiveHosts: () async => ['srv-a', 'srv-b', 'srv-c'],
          openSession: (id) async => opened.add(id),
        );

        final result = await boot.resumeSavedSessions();
        expect(result, ['srv-a', 'srv-b', 'srv-c']);
        expect(opened, ['srv-a', 'srv-b', 'srv-c']);
      });

      test('continues past failing openers and reports all attempts', () async {
        HeadlessBootService.startMinimized = true;
        boot.resumeOnLogin = true;

        final opened = <String>[];
        boot.wirePersistence(
          loadLastActiveHosts: () async => ['ok-1', 'fail', 'ok-2'],
          openSession: (id) async {
            opened.add(id);
            if (id == 'fail') {
              throw StateError('simulated open failure');
            }
          },
        );

        final result = await boot.resumeSavedSessions();
        // Every host is reported, including the one that threw — the
        // service swallows the failure and keeps going.
        expect(result, ['ok-1', 'fail', 'ok-2']);
        expect(opened, ['ok-1', 'fail', 'ok-2']);
      });

      test('is a no-op when no hosts were persisted', () async {
        HeadlessBootService.startMinimized = true;
        boot.resumeOnLogin = true;

        var openCalls = 0;
        boot.wirePersistence(
          loadLastActiveHosts: () async => const [],
          openSession: (_) async => openCalls++,
        );

        final result = await boot.resumeSavedSessions();
        expect(result, isEmpty);
        expect(openCalls, 0);
      });
    });

    group('show/hide intercept flags', () {
      test('markWindowSurfaced is idempotent', () {
        HeadlessBootService.startMinimized = true;
        boot.markWindowSurfaced();
        boot.markWindowSurfaced();
        expect(boot.isHeadlessBoot, isFalse);
      });

      test('debugReset clears every flag', () {
        HeadlessBootService.startMinimized = true;
        boot.applySettings(
          closeToTraySetting: true,
          resumeOnLoginSetting: true,
        );
        boot.markWindowSurfaced();

        boot.debugReset();

        expect(HeadlessBootService.startMinimized, isFalse);
        expect(boot.closeToTray, isFalse);
        expect(boot.resumeOnLogin, isFalse);
        expect(boot.isHeadlessBoot, isFalse);
      });
    });
  });
}
