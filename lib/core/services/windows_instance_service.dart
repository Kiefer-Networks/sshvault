// Windows single-instance bridge.
//
// The C++ side (`windows/runner/main.cpp`) creates a named mutex on launch.
// If the mutex already exists — i.e. another sshvault.exe is running — the
// secondary process broadcasts its argv to the primary's HWND via WM_COPYDATA
// and exits cleanly. The primary's `flutter_window.cpp` decodes the payload
// and dispatches it on the `de.kiefer_networks.sshvault/instance` MethodChannel
// as `onSecondInstance(List<String> argv)`.
//
// This service receives that call and routes the argv through the same
// machinery `main.dart` uses for the initial launch:
//
//   - `ssh://` / `sftp://` / `sshvault://` URLs → [SshUrlHandler]
//   - bare `HOSTNAME` → exact match against [serverListProvider]
//   - `user@host[:port]` → quick-connect, synthesised as an `ssh://` URL
//   - `--new-host` / `--reopen-last` → router pushes
//
// Anything else (flags like `--quit`, `--list-hosts`, `--export-vault`,
// `--help`, `--version`) is ignored: those are headless commands that should
// never be forwarded to a live GUI in the first place.
//
// The service is a no-op on non-Windows platforms so the wiring in
// `main.dart` can stay flat.

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sshvault/core/cli/cli_parser.dart';
import 'package:sshvault/core/routing/app_router.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/core/utils/ssh_url_handler.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/terminal/presentation/providers/session_history_provider.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

/// Singleton listener for the WM_COPYDATA argv broadcast from a secondary
/// sshvault.exe launch.
class WindowsInstanceService {
  WindowsInstanceService._();
  static final WindowsInstanceService instance = WindowsInstanceService._();

  static const _tag = 'WindowsInstance';

  /// Channel name shared with `windows/runner/flutter_window.cpp`.
  @visibleForTesting
  static const channelName = 'de.kiefer_networks.sshvault/instance';

  /// Method name invoked from native when a secondary instance forwards argv.
  @visibleForTesting
  static const methodName = 'onSecondInstance';

  @visibleForTesting
  static const MethodChannel methodChannel = MethodChannel(channelName);

  ProviderContainer? _container;
  bool _initialized = false;

  /// Disposable hook for tests — captures the parsed [CliInvocation] without
  /// touching the router or providers. When set, [_dispatch] short-circuits
  /// after invoking it, which is what the unit tests assert against.
  @visibleForTesting
  void Function(CliInvocation invocation, List<String> argv)? onArgvForTest;

  /// Wire the channel listener. Idempotent. On non-Windows platforms this is
  /// a no-op so callers can call it unconditionally.
  ///
  /// Must be called AFTER `runApp` so the Riverpod container, the router, and
  /// the native MethodChannel handler are all live by the time the first
  /// secondary launch arrives.
  void init({required ProviderContainer container}) {
    if (_initialized) return;
    if (!kIsWeb && !Platform.isWindows) return;
    _container = container;
    methodChannel.setMethodCallHandler(_handleCall);
    _initialized = true;
    LoggingService.instance.info(_tag, 'Single-instance bridge ready');
  }

  /// Test-only reset so each test gets a clean slate.
  @visibleForTesting
  void resetForTest() {
    if (_initialized) {
      methodChannel.setMethodCallHandler(null);
    }
    _initialized = false;
    _container = null;
    onArgvForTest = null;
  }

  Future<dynamic> _handleCall(MethodCall call) async {
    if (call.method != methodName) return null;
    final raw = call.arguments;
    final argv = <String>[
      if (raw is List)
        for (final v in raw)
          if (v is String) v,
    ];
    LoggingService.instance.info(_tag, 'Second instance argv: $argv');
    await _dispatch(argv);
    return null;
  }

  /// Public for tests. Parses [argv] with [CliParser] and dispatches the
  /// result the same way `main.dart` does on a fresh launch.
  @visibleForTesting
  Future<void> handleArgs(List<String> argv) => _dispatch(argv);

  Future<void> _dispatch(List<String> argv) async {
    final cli = CliParser.parse(argv);

    // Tests intercept here so they can assert on the parsed invocation
    // without driving the router / Riverpod graph.
    final hook = onArgvForTest;
    if (hook != null) {
      hook(cli, argv);
      return;
    }

    final container = _container;
    if (container == null) {
      LoggingService.instance.warning(
        _tag,
        'Container not bound — argv dropped',
      );
      return;
    }

    switch (cli.kind) {
      case CliInvocationKind.help:
      case CliInvocationKind.version:
      case CliInvocationKind.quit:
      case CliInvocationKind.listHosts:
      case CliInvocationKind.exportVault:
      case CliInvocationKind.importFiles:
      case CliInvocationKind.error:
        // These are headless / one-shot commands (or pure parse errors).
        // They should never reach a live GUI; the secondary process should
        // have handled (or rejected) them before forwarding. Drop on the
        // floor.
        LoggingService.instance.info(
          _tag,
          'Ignoring non-GUI invocation kind ${cli.kind.name}',
        );
        return;
      case CliInvocationKind.gui:
        await _dispatchGui(container, cli);
    }
  }

  Future<void> _dispatchGui(
    ProviderContainer container,
    CliInvocation cli,
  ) async {
    if (cli.sshUrl != null) {
      await SshUrlHandler.handleArgs(container, <String>[cli.sshUrl!]);
      return;
    }
    if (cli.quickConnect != null) {
      final qc = cli.quickConnect!;
      final user = qc.username == null ? '' : '${qc.username}@';
      final host = qc.hostname.contains(':') ? '[${qc.hostname}]' : qc.hostname;
      await SshUrlHandler.handleArgs(container, <String>[
        'ssh://$user$host:${qc.port}',
      ]);
      return;
    }
    if (cli.hostNameMatch != null) {
      await _connectByHostName(container, cli.hostNameMatch!);
      return;
    }
    if (cli.newHost) {
      try {
        AppRouter.router.push('/server/new');
      } catch (e) {
        LoggingService.instance.warning(_tag, '--new-host routing failed: $e');
      }
      return;
    }
    if (cli.reopenLast) {
      final hostId = container.read(sessionHistoryProvider);
      if (hostId == null || hostId.isEmpty) {
        LoggingService.instance.info(
          _tag,
          '--reopen-last: no last-active host on record',
        );
        return;
      }
      unawaited(
        container.read(sessionManagerProvider.notifier).openSession(hostId),
      );
      return;
    }
    // Bare `sshvault` with no args: nothing to do beyond raising the window
    // (already done in C++).
  }

  Future<void> _connectByHostName(
    ProviderContainer container,
    String name,
  ) async {
    final log = LoggingService.instance;
    try {
      final servers = await container.read(serverListProvider.future);
      final match = servers.where((s) => s.name == name);
      if (match.isEmpty) {
        log.warning(_tag, 'No server with name="$name", ignoring');
        return;
      }
      await container
          .read(sessionManagerProvider.notifier)
          .openSession(match.first.id);
    } catch (e) {
      log.warning(_tag, 'Failed to connect to "$name" by name: $e');
    }
  }
}
