import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'package:sshvault/app.dart';
import 'package:sshvault/core/cli/cli_parser.dart';
import 'package:sshvault/core/routing/app_router.dart';
import 'package:sshvault/core/services/dbus_service.dart';
import 'package:sshvault/core/services/file_drop_service.dart';
import 'package:sshvault/core/services/global_shortcut_service.dart';
import 'package:sshvault/core/services/headless_boot_service.dart';
import 'package:sshvault/core/services/hidpi_service.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/core/services/tray_service.dart';
import 'package:sshvault/core/services/window_state_service.dart';
import 'package:sshvault/core/storage/database.dart';
import 'package:sshvault/core/storage/database_provider.dart';
import 'package:sshvault/core/utils/ssh_url_handler.dart';
import 'package:sshvault/features/connection/presentation/providers/repository_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/terminal/presentation/providers/session_history_provider.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

/// Hard-coded version banner. Kept in sync with `pubspec.yaml` `version:`.
/// Printed by `--version` before any Flutter binding is initialized.
const String _kVersionBanner = 'SSHVault 1.11.0 (build 41)';

void main(List<String> args) async {
  // Parse argv first — pure-Dart, side-effect free, lets us short-circuit
  // before touching the database, DBus, or the Flutter binding.
  final cli = CliParser.parse(args);

  switch (cli.kind) {
    case CliInvocationKind.help:
      stdout.writeln(cli.usage);
      exit(0);
    case CliInvocationKind.version:
      stdout.writeln(_kVersionBanner);
      exit(0);
    case CliInvocationKind.error:
      stderr.writeln('sshvault: ${cli.errorMessage}');
      stderr.writeln();
      stderr.writeln(cli.usage);
      exit(64); // EX_USAGE
    case CliInvocationKind.quit:
      final ok = await sendDBusQuit();
      if (!ok) {
        stderr.writeln(
          'sshvault: no running instance to quit (DBus call failed).',
        );
        exit(1);
      }
      exit(0);
    case CliInvocationKind.listHosts:
      await _runListHostsAndExit();
      return; // unreachable
    case CliInvocationKind.exportVault:
      await _runHeadlessExportAndExit(cli.exportVaultPath!);
      return; // unreachable
    case CliInvocationKind.gui:
      // Fall through to normal boot.
      break;
  }

  WidgetsFlutterBinding.ensureInitialized();

  final log = LoggingService.instance;
  log.info('App', 'SSH Vault starting');

  // Linux only: enforce single-instance and accept external invocations from
  // KRunner / Rofi / Polybar. If another instance already owns the well-known
  // bus name, forward our argv (e.g. ssh://...) and exit cleanly before
  // touching the database or runApp.
  if (Platform.isLinux) {
    final result = await bootstrapSshVaultDBus(argv: args);
    if (result == DBusBootstrapResult.forwardedToExisting) {
      log.info('App', 'Forwarded args to running instance, exiting');
      exit(0);
    }
  }

  await AppDatabase.migrateDbLocationIfNeeded();

  // Detect "start minimized" intent from CLI / env so the tray service and
  // headless-boot service can decide whether to surface the window on first
  // run. Cheap to compute, safe everywhere (the flag is only consulted on
  // Linux / Windows). Set BEFORE runApp so the first window state is fully
  // determined before any provider initializes.
  final startMinimized =
      cli.minimized || Platform.environment['SSHVAULT_MINIMIZED'] == '1';
  HeadlessBootService.startMinimized = startMinimized;
  TrayService.startMinimized = startMinimized;

  // Shared container so we can dispatch the URL handler from outside the
  // widget tree. Reused by ProviderScope below.
  final container = ProviderContainer();

  // Desktop only (Linux/Windows/macOS): persist + restore window geometry.
  // Done BEFORE runApp / windowManager.show() so the saved size + position
  // is applied before the first frame to avoid a "flash" at the default
  // 1280x800. Storage is plumbed through the existing settings DAO so the
  // values round-trip through SettingsNotifier on the next boot.
  if (WindowStateService.isSupportedPlatform) {
    try {
      await windowManager.ensureInitialized();
      final dao = container.read(databaseProvider).appSettingsDao;
      WindowStateService.instance.bindStorage(
        read: (k) => dao.getValue(k),
        write: (k, v) => dao.setValue(k, v),
      );
      await WindowStateService.instance.restore();
      WindowStateService.instance.attachListeners();
    } catch (e) {
      // Non-fatal: on a broken plugin / missing native lib we still want
      // the app to come up at the default size.
      log.warning('App', 'Window state restore failed: $e');
    }
  }

  // Linux only: register the DBus service so external clients can drive us.
  // Done off the main path; failure is non-fatal. The `onQuit` callback is
  // hit when another process calls `Quit` over DBus (e.g. `sshvault --quit`).
  // `onNewConnection` / `onReopenLast` route the freedesktop
  // `org.freedesktop.Application.ActivateAction` calls into the live
  // navigator + session manager.
  if (Platform.isLinux) {
    unawaited(
      SshVaultDBusService.attach(
        container: container,
        onQuit: () {
          log.info('App', 'DBus Quit received, exiting');
          // Defer the actual exit so the DBus reply makes it back to the
          // caller before the process tears down.
          Future.delayed(const Duration(milliseconds: 50), () => exit(0));
        },
        onNewConnection: () {
          // .desktop Action "NewConnection" — push the new-host form on
          // top of the root navigator. Fall back silently if the navigator
          // isn't ready yet (very early activation racing the first frame).
          try {
            AppRouter.router.push('/server/new');
          } catch (e) {
            log.warning('App', 'NewConnection routing failed: $e');
          }
        },
        onReopenLast: () {
          // .desktop Action "ReopenLast" — re-open the host recorded in
          // the in-memory session-history provider. Best-effort.
          final hostId = container.read(sessionHistoryProvider);
          if (hostId == null || hostId.isEmpty) {
            log.info('App', 'ReopenLast: no last-active host on record');
            return;
          }
          unawaited(
            container.read(sessionManagerProvider.notifier).openSession(hostId),
          );
        },
      ),
    );
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const _LifecycleWrapper(child: SSHVaultApp()),
    ),
  );

  // After the first frame, dispatch any positional argv: ssh:// / sftp://
  // URL (xdg-open / desktop file %u), HOSTNAME, or user@host[:port].
  // The `--new-host` / `--reopen-last` flags are non-DBus fallbacks for the
  // .desktop Action= entries (the launcher prefers the DBus path when
  // available, but Exec= still has to do something useful).
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (cli.sshUrl != null) {
      SshUrlHandler.handleArgs(container, <String>[cli.sshUrl!]);
    } else if (cli.quickConnect != null) {
      // Reuse the URL handler by synthesising an ssh:// URL.
      final qc = cli.quickConnect!;
      final user = qc.username == null ? '' : '${qc.username}@';
      final host = qc.hostname.contains(':') ? '[${qc.hostname}]' : qc.hostname;
      SshUrlHandler.handleArgs(container, <String>[
        'ssh://$user$host:${qc.port}',
      ]);
    } else if (cli.hostNameMatch != null) {
      _connectByHostName(container, cli.hostNameMatch!);
    } else if (cli.newHost) {
      try {
        AppRouter.router.push('/server/new');
      } catch (e) {
        log.warning('App', '--new-host routing failed: $e');
      }
    } else if (cli.reopenLast) {
      final hostId = container.read(sessionHistoryProvider);
      if (hostId != null && hostId.isNotEmpty) {
        unawaited(
          container.read(sessionManagerProvider.notifier).openSession(hostId),
        );
      } else {
        log.info('App', '--reopen-last: no last-active host on record');
      }
    }
  });

  // Linux only: install system tray icon. Best-effort — failures are
  // logged but never block app start (e.g. headless test runner, missing
  // libayatana-appindicator on the host).
  if (Platform.isLinux) {
    unawaited(TrayService.instance.init(container));
  }

  // Linux / Windows: install the close-button intercept so that hitting
  // [×] hides the window when the user enabled "Close button minimizes to
  // tray". Always installed; the actual hide-vs-quit decision is made at
  // close time based on the live setting.
  if (Platform.isLinux || Platform.isWindows) {
    unawaited(HeadlessBootService.instance.installWindowCloseIntercept());
  }

  // If the user booted with `--minimized`, hide the native window now —
  // the tray surfaces it on demand. We schedule slightly after `runApp` so
  // the engine has fully initialized; the hide call is safe even if the
  // compositor already painted the first frame.
  if (startMinimized && (Platform.isLinux || Platform.isWindows)) {
    unawaited(
      Future<void>.delayed(const Duration(milliseconds: 50), () async {
        try {
          await windowManager.hide();
        } catch (e) {
          log.warning('App', 'Failed to hide window on minimized boot: $e');
        }
      }),
    );
  }

  // Linux only: hook up the C++ drag-and-drop bridge so dropped SSH key /
  // ssh_config / vault-export files surface the matching import UI.
  if (Platform.isLinux) {
    FileDropService.instance.init(rootNavigatorKey, container: container);
  }

  // Linux only: register the system-wide Quick Connect shortcut via the
  // org.freedesktop.portal.Desktop GlobalShortcuts portal. Failure (no
  // portal, sandboxed without `--talk-name`, XFCE) is reported via
  // [globalShortcutStatusProvider] so the Settings UI can show the
  // dbus-send fallback instructions instead.
  if (Platform.isLinux) {
    unawaited(
      container
          .read(globalShortcutServiceProvider)
          .register(container: container),
    );
  }

  // Linux only: listen for GDK monitor scale-factor changes so the app
  // re-rasterizes when the user drags the window between a 1x and 2x
  // monitor. Best-effort; the C++ side is a no-op on other platforms and
  // `init` short-circuits there too.
  if (Platform.isLinux) {
    HiDpiService.instance.init(container: container);
  }
}

/// Resolves [name] to a server with that exact `name` and opens a session.
/// Best-effort; logs and does nothing on miss.
Future<void> _connectByHostName(
  ProviderContainer container,
  String name,
) async {
  final log = LoggingService.instance;
  try {
    final servers = await container.read(serverListProvider.future);
    final match = servers.where((s) => s.name == name);
    if (match.isEmpty) {
      log.warning('App', 'No server with name="$name", ignoring CLI arg');
      return;
    }
    await container
        .read(sessionManagerProvider.notifier)
        .openSession(match.first.id);
  } catch (e) {
    log.warning('App', 'Failed to connect to "$name" by name: $e');
  }
}

/// Headless `--list-hosts`. Reads the DB, prints one name per line, exits 0.
Future<void> _runListHostsAndExit() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.migrateDbLocationIfNeeded();
  final container = ProviderContainer();
  try {
    final servers = await container.read(serverListProvider.future);
    for (final s in servers) {
      stdout.writeln(s.name);
    }
  } catch (e) {
    stderr.writeln('sshvault: --list-hosts failed: $e');
    exit(1);
  } finally {
    container.dispose();
  }
  exit(0);
}

/// Headless `--export-vault PATH`. Spins up a minimal Riverpod container,
/// runs the unencrypted JSON export, copies the result to [destination],
/// and exits.
Future<void> _runHeadlessExportAndExit(String destination) async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.migrateDbLocationIfNeeded();
  final container = ProviderContainer();
  try {
    final useCases = container.read(exportImportUseCasesProvider);
    final result = await useCases.exportToJson();
    final path = result.fold(
      onSuccess: (p) => p,
      onFailure: (f) {
        stderr.writeln('sshvault: export failed: ${f.message}');
        exit(1);
      },
    );
    if (path != destination) {
      try {
        await File(path).copy(destination);
      } catch (e) {
        stderr.writeln(
          'sshvault: export wrote to $path but could not copy to '
          '$destination: $e',
        );
        exit(1);
      }
    }
    stdout.writeln(destination);
  } catch (e) {
    stderr.writeln('sshvault: export crashed: $e');
    exit(1);
  } finally {
    container.dispose();
  }
  exit(0);
}

/// Observes app lifecycle events and logs them.
class _LifecycleWrapper extends StatefulWidget {
  final Widget child;
  const _LifecycleWrapper({required this.child});

  @override
  State<_LifecycleWrapper> createState() => _LifecycleWrapperState();
}

class _LifecycleWrapperState extends State<_LifecycleWrapper>
    with WidgetsBindingObserver {
  final _log = LoggingService.instance;
  static const _tag = 'Lifecycle';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _log.info(_tag, 'App initialized');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _log.info(_tag, 'App disposed');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _log.info(_tag, 'App resumed');
      case AppLifecycleState.paused:
        _log.info(_tag, 'App paused');
      case AppLifecycleState.inactive:
        _log.info(_tag, 'App inactive');
      case AppLifecycleState.detached:
        _log.info(_tag, 'App detached');
      case AppLifecycleState.hidden:
        _log.info(_tag, 'App hidden');
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
