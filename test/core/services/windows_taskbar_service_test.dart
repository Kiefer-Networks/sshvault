// Unit tests for the Windows taskbar service. We override the platform
// detection so the service dispatches to its MethodChannel even on the
// Linux test runner, then verify the dispatched payloads match the
// contract that `windows/runner/taskbar_helper.cpp` expects.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sshvault/core/services/windows_taskbar_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late WindowsTaskbarService service;
  late List<MethodCall> calls;

  setUp(() {
    service = WindowsTaskbarService.instance;
    service.platformOverride = true;
    service.resetForTest();
    calls = <MethodCall>[];

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(WindowsTaskbarService.channel, (call) async {
          calls.add(call);
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(WindowsTaskbarService.channel, null);
    service.platformOverride = false;
  });

  group('WindowsTaskbarService.setProgress', () {
    test('forwards state + clamped value to the native channel', () async {
      await service.setProgress(TaskbarProgressState.normal, 0.42);

      expect(calls, hasLength(1));
      expect(calls.single.method, 'setProgress');
      final args = Map<String, Object?>.from(
        calls.single.arguments as Map<Object?, Object?>,
      );
      expect(args['state'], 'normal');
      expect(args['value'], 0.42);
    });

    test('clamps fraction to 0..1', () async {
      await service.setProgress(TaskbarProgressState.normal, 1.7);
      final args = Map<String, Object?>.from(
        calls.single.arguments as Map<Object?, Object?>,
      );
      expect(args['value'], 1.0);

      calls.clear();
      await service.setProgress(TaskbarProgressState.normal, -0.4);
      final args2 = Map<String, Object?>.from(
        calls.single.arguments as Map<Object?, Object?>,
      );
      expect(args2['value'], 0.0);
    });

    test('NaN value falls back to 0', () async {
      await service.setProgress(TaskbarProgressState.normal, double.nan);
      final args = Map<String, Object?>.from(
        calls.single.arguments as Map<Object?, Object?>,
      );
      expect(args['value'], 0.0);
    });
  });

  group('setSftpTransferProgress', () {
    test('null fraction emits state=none', () async {
      await service.setSftpTransferProgress(null);
      final args = Map<String, Object?>.from(
        calls.single.arguments as Map<Object?, Object?>,
      );
      expect(args['state'], 'none');
    });

    test('failed=true emits state=error', () async {
      await service.setSftpTransferProgress(0.5, failed: true);
      final args = Map<String, Object?>.from(
        calls.single.arguments as Map<Object?, Object?>,
      );
      expect(args['state'], 'error');
    });

    test('progress fraction emits state=normal', () async {
      await service.setSftpTransferProgress(0.7);
      final args = Map<String, Object?>.from(
        calls.single.arguments as Map<Object?, Object?>,
      );
      expect(args['state'], 'normal');
      expect(args['value'], 0.7);
    });
  });

  group('setSessionThumbnailButtons', () {
    test('hasActive=true installs disconnect+show-terminal buttons', () async {
      await service.setSessionThumbnailButtons(hasActive: true);

      expect(calls, hasLength(1));
      expect(calls.single.method, 'setThumbButtons');
      final list = calls.single.arguments as List<Object?>;
      expect(list, hasLength(2));
      final first = Map<String, Object?>.from(
        list[0]! as Map<Object?, Object?>,
      );
      final second = Map<String, Object?>.from(
        list[1]! as Map<Object?, Object?>,
      );
      expect(first['id'], TaskbarThumbButton.disconnectAll);
      expect(second['id'], TaskbarThumbButton.showTerminal);
      expect(first['enabled'], true);
    });

    test('hasActive=false sends an empty list', () async {
      // First go active so the second call is a real transition.
      await service.setSessionThumbnailButtons(hasActive: true);
      calls.clear();

      await service.setSessionThumbnailButtons(hasActive: false);
      expect(calls, hasLength(1));
      expect(calls.single.method, 'setThumbButtons');
      expect(calls.single.arguments, isEmpty);
    });

    test('repeating the same state is a no-op', () async {
      await service.setSessionThumbnailButtons(hasActive: true);
      await service.setSessionThumbnailButtons(hasActive: true);
      expect(calls, hasLength(1));
    });

    test('thumbButtonEvents stream emits on onThumbButtonClicked', () async {
      await service.setSessionThumbnailButtons(hasActive: true);

      final captured = <String>[];
      final sub = service.thumbButtonEvents.listen(captured.add);

      // Simulate the native side firing onThumbButtonClicked back at us.
      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
            WindowsTaskbarService.channel.name,
            const StandardMethodCodec().encodeMethodCall(
              const MethodCall(
                'onThumbButtonClicked',
                TaskbarThumbButton.disconnectAll,
              ),
            ),
            (_) {},
          );
      // Allow the broadcast stream to deliver.
      await Future<void>.delayed(Duration.zero);

      expect(captured, [TaskbarThumbButton.disconnectAll]);
      await sub.cancel();
    });
  });

  group('flashOnFingerprintWarning', () {
    test('dispatches flashTaskbar', () async {
      await service.flashOnFingerprintWarning();
      expect(calls, hasLength(1));
      expect(calls.single.method, 'flashTaskbar');
    });
  });

  group('platform gate', () {
    test('no-op when platformOverride is false on non-Windows', () async {
      service.platformOverride = false;
      await service.setProgress(TaskbarProgressState.normal, 0.5);
      await service.setSessionThumbnailButtons(hasActive: true);
      await service.flashOnFingerprintWarning();
      expect(calls, isEmpty);
    });
  });
}
