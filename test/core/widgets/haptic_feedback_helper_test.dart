import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sshvault/core/widgets/haptic_feedback_helper.dart';

/// Test scaffolding for [HapticFeedbackHelper].
///
/// The helper has three branches per call site:
///   1. Android — invokes the Material 3 method channel.
///   2. iOS — invokes `UINotificationFeedbackGenerator` (notify-* methods
///      only) before falling through to the stock `HapticFeedback` impacts.
///   3. Everything else — defers straight to Flutter's built-in
///      [HapticFeedback] API, which on iOS already routes through
///      `UIImpactFeedbackGenerator`.
///
/// We exercise each branch in isolation by flipping the `debugIs*Override`
/// seams on the helper. Real platform calls would crash the unit-test VM;
/// installing a [MethodChannel] mock handler lets us assert the
/// arguments without touching the OS.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() {
    HapticFeedbackHelper.debugIsAndroidOverride = null;
    HapticFeedbackHelper.debugIsIosOverride = null;
    messenger.setMockMethodCallHandler(HapticFeedbackHelper.channel, null);
    messenger.setMockMethodCallHandler(
      HapticFeedbackHelper.iosNotificationChannel,
      null,
    );
    messenger.setMockMethodCallHandler(SystemChannels.platform, null);
  });

  group('Android branch', () {
    test('tapConfirm forwards "confirm" to the Material 3 channel', () async {
      HapticFeedbackHelper.debugIsAndroidOverride = true;
      HapticFeedbackHelper.debugIsIosOverride = false;

      final calls = <MethodCall>[];
      messenger.setMockMethodCallHandler(HapticFeedbackHelper.channel, (
        call,
      ) async {
        calls.add(call);
        return true;
      });

      await HapticFeedbackHelper.tapConfirm();

      expect(calls, hasLength(1));
      expect(calls.single.method, 'performHaptic');
      expect(calls.single.arguments, <String, Object?>{'type': 'confirm'});
    });

    test('tapReject forwards "reject"', () async {
      HapticFeedbackHelper.debugIsAndroidOverride = true;
      HapticFeedbackHelper.debugIsIosOverride = false;

      final calls = <MethodCall>[];
      messenger.setMockMethodCallHandler(HapticFeedbackHelper.channel, (
        call,
      ) async {
        calls.add(call);
        return true;
      });

      await HapticFeedbackHelper.tapReject();

      expect(calls.single.arguments, <String, Object?>{'type': 'reject'});
    });

    test('gestureEnd forwards "gestureEnd"', () async {
      HapticFeedbackHelper.debugIsAndroidOverride = true;
      HapticFeedbackHelper.debugIsIosOverride = false;

      final calls = <MethodCall>[];
      messenger.setMockMethodCallHandler(HapticFeedbackHelper.channel, (
        call,
      ) async {
        calls.add(call);
        return true;
      });

      await HapticFeedbackHelper.gestureEnd();

      expect(calls.single.arguments, <String, Object?>{'type': 'gestureEnd'});
    });

    test(
      'falls back to Flutter HapticFeedback when native returns false',
      () async {
        HapticFeedbackHelper.debugIsAndroidOverride = true;
        HapticFeedbackHelper.debugIsIosOverride = false;

        messenger.setMockMethodCallHandler(
          HapticFeedbackHelper.channel,
          (_) async => false,
        );
        final platformCalls = <MethodCall>[];
        messenger.setMockMethodCallHandler(SystemChannels.platform, (
          call,
        ) async {
          platformCalls.add(call);
          return null;
        });

        await HapticFeedbackHelper.tapConfirm();

        // Flutter's HapticFeedback.lightImpact dispatches HapticFeedback
        // on the platform channel with a "HapticFeedbackType.lightImpact"
        // argument; we just assert *something* on that channel went out
        // so the test isn't coupled to private string constants.
        expect(
          platformCalls.any((c) => c.method == 'HapticFeedback.vibrate'),
          isTrue,
        );
      },
    );

    test(
      'swallows PlatformException and degrades to Flutter fallback',
      () async {
        HapticFeedbackHelper.debugIsAndroidOverride = true;
        HapticFeedbackHelper.debugIsIosOverride = false;

        messenger.setMockMethodCallHandler(
          HapticFeedbackHelper.channel,
          (_) async => throw PlatformException(code: 'boom'),
        );
        var fallbackHit = false;
        messenger.setMockMethodCallHandler(SystemChannels.platform, (
          call,
        ) async {
          if (call.method == 'HapticFeedback.vibrate') fallbackHit = true;
          return null;
        });

        await HapticFeedbackHelper.tapReject();

        expect(fallbackHit, isTrue);
      },
    );
  });

  group('iOS branch — notification haptics', () {
    test('notifySuccess forwards "success" to the iOS channel', () async {
      HapticFeedbackHelper.debugIsAndroidOverride = false;
      HapticFeedbackHelper.debugIsIosOverride = true;

      final calls = <MethodCall>[];
      messenger.setMockMethodCallHandler(
        HapticFeedbackHelper.iosNotificationChannel,
        (call) async {
          calls.add(call);
          return true;
        },
      );

      await HapticFeedbackHelper.notifySuccess();

      expect(calls, hasLength(1));
      expect(calls.single.method, 'notify');
      expect(calls.single.arguments, <String, Object?>{'type': 'success'});
    });

    test('notifyWarning forwards "warning"', () async {
      HapticFeedbackHelper.debugIsAndroidOverride = false;
      HapticFeedbackHelper.debugIsIosOverride = true;

      final calls = <MethodCall>[];
      messenger.setMockMethodCallHandler(
        HapticFeedbackHelper.iosNotificationChannel,
        (call) async {
          calls.add(call);
          return true;
        },
      );

      await HapticFeedbackHelper.notifyWarning();

      expect(calls.single.arguments, <String, Object?>{'type': 'warning'});
    });

    test('notifyError forwards "error"', () async {
      HapticFeedbackHelper.debugIsAndroidOverride = false;
      HapticFeedbackHelper.debugIsIosOverride = true;

      final calls = <MethodCall>[];
      messenger.setMockMethodCallHandler(
        HapticFeedbackHelper.iosNotificationChannel,
        (call) async {
          calls.add(call);
          return true;
        },
      );

      await HapticFeedbackHelper.notifyError();

      expect(calls.single.arguments, <String, Object?>{'type': 'error'});
    });

    test(
      'falls back to Flutter HapticFeedback when iOS bridge returns false',
      () async {
        HapticFeedbackHelper.debugIsAndroidOverride = false;
        HapticFeedbackHelper.debugIsIosOverride = true;

        messenger.setMockMethodCallHandler(
          HapticFeedbackHelper.iosNotificationChannel,
          (_) async => false,
        );
        var fallbackHit = false;
        messenger.setMockMethodCallHandler(SystemChannels.platform, (
          call,
        ) async {
          if (call.method == 'HapticFeedback.vibrate') fallbackHit = true;
          return null;
        });

        await HapticFeedbackHelper.notifyError();

        expect(fallbackHit, isTrue);
      },
    );

    test(
      'swallows MissingPluginException when the iOS plugin is absent',
      () async {
        HapticFeedbackHelper.debugIsAndroidOverride = false;
        HapticFeedbackHelper.debugIsIosOverride = true;

        // No mock handler for iosNotificationChannel — invokeMethod will
        // raise MissingPluginException, which the helper must absorb so
        // the call still completes and the Flutter fallback fires.
        var fallbackHit = false;
        messenger.setMockMethodCallHandler(SystemChannels.platform, (
          call,
        ) async {
          if (call.method == 'HapticFeedback.vibrate') fallbackHit = true;
          return null;
        });

        await HapticFeedbackHelper.notifySuccess();

        expect(fallbackHit, isTrue);
      },
    );

    test('iOS branch never hits the Android channel', () async {
      HapticFeedbackHelper.debugIsAndroidOverride = false;
      HapticFeedbackHelper.debugIsIosOverride = true;

      var androidHit = false;
      messenger.setMockMethodCallHandler(HapticFeedbackHelper.channel, (
        _,
      ) async {
        androidHit = true;
        return true;
      });
      messenger.setMockMethodCallHandler(
        HapticFeedbackHelper.iosNotificationChannel,
        (_) async => true,
      );

      await HapticFeedbackHelper.notifyWarning();

      expect(androidHit, isFalse);
    });
  });

  group('Other platforms', () {
    test(
      'tapConfirm skips the Android channel and uses Flutter fallback',
      () async {
        HapticFeedbackHelper.debugIsAndroidOverride = false;
        HapticFeedbackHelper.debugIsIosOverride = false;

        var nativeHit = false;
        messenger.setMockMethodCallHandler(HapticFeedbackHelper.channel, (
          _,
        ) async {
          nativeHit = true;
          return true;
        });
        var fallbackHit = false;
        messenger.setMockMethodCallHandler(SystemChannels.platform, (
          call,
        ) async {
          if (call.method == 'HapticFeedback.vibrate') fallbackHit = true;
          return null;
        });

        await HapticFeedbackHelper.tapConfirm();

        expect(nativeHit, isFalse);
        expect(fallbackHit, isTrue);
      },
    );

    test(
      'notifySuccess on non-iOS / non-Android uses Flutter fallback',
      () async {
        HapticFeedbackHelper.debugIsAndroidOverride = false;
        HapticFeedbackHelper.debugIsIosOverride = false;

        var iosHit = false;
        messenger.setMockMethodCallHandler(
          HapticFeedbackHelper.iosNotificationChannel,
          (_) async {
            iosHit = true;
            return true;
          },
        );
        var fallbackHit = false;
        messenger.setMockMethodCallHandler(SystemChannels.platform, (
          call,
        ) async {
          if (call.method == 'HapticFeedback.vibrate') fallbackHit = true;
          return null;
        });

        await HapticFeedbackHelper.notifySuccess();

        expect(iosHit, isFalse);
        expect(fallbackHit, isTrue);
      },
    );
  });
}
