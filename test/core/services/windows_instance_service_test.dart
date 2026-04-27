// Unit tests for the Windows single-instance bridge.
//
// We exercise the public surface — the channel listener and the parsed-argv
// dispatcher — without needing a live Riverpod container, router, or native
// runner. The `onArgvForTest` hook captures the [CliInvocation] produced from
// each argv list so we can assert on routing decisions purely in-process.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sshvault/core/cli/cli_parser.dart';
import 'package:sshvault/core/services/windows_instance_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WindowsInstanceService.handleArgs (direct dispatch)', () {
    late WindowsInstanceService sut;
    late List<CliInvocation> captured;
    late List<List<String>> capturedArgv;

    setUp(() {
      sut = WindowsInstanceService.instance;
      sut.resetForTest();
      captured = [];
      capturedArgv = [];
      sut.onArgvForTest = (cli, argv) {
        captured.add(cli);
        capturedArgv.add(argv);
      };
    });

    tearDown(() {
      sut.resetForTest();
    });

    test('routes a bare ssh:// URL through the GUI URL branch', () async {
      await sut.handleArgs(<String>['ssh://malte@example.com:2222']);

      expect(captured, hasLength(1));
      expect(captured.single.kind, CliInvocationKind.gui);
      expect(captured.single.sshUrl, 'ssh://malte@example.com:2222');
      expect(captured.single.quickConnect, isNull);
      expect(captured.single.hostNameMatch, isNull);
    });

    test('routes a sftp:// URL through the GUI URL branch', () async {
      await sut.handleArgs(<String>['sftp://user@host']);

      expect(captured.single.kind, CliInvocationKind.gui);
      expect(captured.single.sshUrl, 'sftp://user@host');
    });

    test('routes user@host[:port] as a quick-connect target', () async {
      await sut.handleArgs(<String>['malte@bastion.example.com:2200']);

      expect(captured.single.kind, CliInvocationKind.gui);
      expect(captured.single.sshUrl, isNull);
      expect(captured.single.quickConnect, isNotNull);
      expect(captured.single.quickConnect!.username, 'malte');
      expect(captured.single.quickConnect!.hostname, 'bastion.example.com');
      expect(captured.single.quickConnect!.port, 2200);
    });

    test('routes a bare HOSTNAME as a name match', () async {
      await sut.handleArgs(<String>['production-bastion']);

      expect(captured.single.kind, CliInvocationKind.gui);
      expect(captured.single.hostNameMatch, 'production-bastion');
      expect(captured.single.sshUrl, isNull);
      expect(captured.single.quickConnect, isNull);
    });

    test('--new-host parses to a GUI invocation with newHost=true', () async {
      await sut.handleArgs(<String>['--new-host']);

      expect(captured.single.kind, CliInvocationKind.gui);
      expect(captured.single.newHost, isTrue);
      expect(captured.single.reopenLast, isFalse);
    });

    test(
      '--reopen-last parses to a GUI invocation with reopenLast=true',
      () async {
        await sut.handleArgs(<String>['--reopen-last']);

        expect(captured.single.kind, CliInvocationKind.gui);
        expect(captured.single.reopenLast, isTrue);
        expect(captured.single.newHost, isFalse);
      },
    );

    test(
      '--quit is parsed to CliInvocationKind.quit (not forwarded as GUI)',
      () async {
        await sut.handleArgs(<String>['--quit']);

        expect(captured.single.kind, CliInvocationKind.quit);
      },
    );

    test('--version is parsed to CliInvocationKind.version', () async {
      await sut.handleArgs(<String>['--version']);

      expect(captured.single.kind, CliInvocationKind.version);
    });

    test('empty argv is treated as a bare GUI launch', () async {
      await sut.handleArgs(const <String>[]);

      expect(captured.single.kind, CliInvocationKind.gui);
      expect(captured.single.hasPositional, isFalse);
      expect(captured.single.newHost, isFalse);
      expect(captured.single.reopenLast, isFalse);
    });

    test('garbage argv produces a CliInvocationKind.error result', () async {
      await sut.handleArgs(<String>['extra', 'positional', 'tokens']);

      expect(captured.single.kind, CliInvocationKind.error);
      expect(captured.single.errorMessage, isNotNull);
    });

    test('preserves the raw argv in the second hook argument', () async {
      await sut.handleArgs(<String>['ssh://user@host', '--minimized']);

      expect(capturedArgv.single, <String>['ssh://user@host', '--minimized']);
    });
  });

  group('WindowsInstanceService MethodChannel listener', () {
    late WindowsInstanceService sut;
    late List<CliInvocation> captured;

    setUp(() {
      sut = WindowsInstanceService.instance;
      sut.resetForTest();
      captured = [];
      // Install the channel listener manually — `init()` is a no-op outside
      // of Windows, but we want to exercise the message dispatch path.
      WindowsInstanceService.methodChannel.setMethodCallHandler((call) async {
        if (call.method != WindowsInstanceService.methodName) return null;
        final raw = call.arguments;
        final argv = <String>[
          if (raw is List)
            for (final v in raw)
              if (v is String) v,
        ];
        await sut.handleArgs(argv);
        return null;
      });
      sut.onArgvForTest = (cli, _) => captured.add(cli);
    });

    tearDown(() {
      WindowsInstanceService.methodChannel.setMethodCallHandler(null);
      sut.resetForTest();
    });

    test(
      'dispatches a sample argv list received over the method channel',
      () async {
        // Encode a fake `onSecondInstance(['ssh://user@host:2222'])` call in
        // the same wire format the native runner uses.
        const codec = StandardMethodCodec();
        final message = codec.encodeMethodCall(
          const MethodCall(WindowsInstanceService.methodName, <String>[
            'ssh://user@host:2222',
          ]),
        );

        await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .handlePlatformMessage(
              WindowsInstanceService.channelName,
              message,
              (_) {},
            );

        expect(captured, hasLength(1));
        expect(captured.single.kind, CliInvocationKind.gui);
        expect(captured.single.sshUrl, 'ssh://user@host:2222');
      },
    );

    test('ignores method calls that do not match onSecondInstance', () async {
      const codec = StandardMethodCodec();
      final message = codec.encodeMethodCall(
        const MethodCall('someOtherMethod', <String>['ignored']),
      );

      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
            WindowsInstanceService.channelName,
            message,
            (_) {},
          );

      expect(captured, isEmpty);
    });
  });
}
