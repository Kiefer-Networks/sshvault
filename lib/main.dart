import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'package:sshvault/app.dart';
import 'package:sshvault/core/cli/cli_parser.dart';
import 'package:sshvault/core/routing/app_router.dart';
import 'package:sshvault/core/services/android_session_service.dart';
import 'package:sshvault/core/services/dbus_service.dart';
import 'package:sshvault/core/services/file_drop_service.dart';
import 'package:sshvault/core/services/global_shortcut_service.dart';
import 'package:sshvault/core/services/headless_boot_service.dart';
import 'package:sshvault/core/services/hidpi_service.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/core/services/tray_service.dart';
import 'package:sshvault/core/services/window_state_service.dart';
import 'package:sshvault/core/services/windows_chrome_service.dart';
import 'package:sshvault/core/services/windows_instance_service.dart';
import 'package:sshvault/core/services/windows_notification_service.dart';
import 'package:sshvault/core/services/windows_protocol_registrar.dart';
import 'package:sshvault/core/storage/database.dart';
import 'package:sshvault/core/storage/database_provider.dart';
import 'package:sshvault/core/utils/ssh_url_handler.dart';
import 'package:sshvault/features/connection/presentation/providers/repository_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
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
    case CliInvocationKind.importFiles:
      // Treat dropped key/config files like a GUI launch: the file-drop
      // service routes the paths into the right import flow once the
      // app is up.
      break;
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
      // Windows-only: register our AppUserModelID so toasts produced by
      // `WindowsNotificationService` resolve back to SSHVault in the Action
      // Center (icon, app name, persistence). Must run before the first
      // `LocalNotifier.setup()` call. The matching registry key is written
      // by the Inno Setup installer (see `windows/installer.iss`).
      if (Platform.isWindows) {
        await registerSshVaultAumid();
      }
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

  // Windows only: apply Mica + dark title bar + rounded corners BEFORE
  // runApp so the very first frame is fully styled — no white flash and
  // no light-mode title bar pop. Settings are read directly from the
  // app_settings DAO; the live theme listener in SSHVaultApp re-applies
  // when the user toggles light/dark or flips the toggles.
  if (Platform.isWindows) {
    try {
      final dao = container.read(databaseProvider).appSettingsDao;
      final theme = await dao.getValue('theme_mode');
      final useMica = (await dao.getValue('windows_mica_backdrop')) != 'false';
      final round = (await dao.getValue('windows_round_corners')) != 'false';
      // For "system" we fall back to dark-on-Windows since the platform
      // dispatcher is not yet available; SSHVaultApp will re-apply once
      // MediaQuery resolves the actual brightness.
      final dark = theme == 'dark' || theme == null || theme == 'system';
      await WindowsChromeService.instance.applyChrome(
        WindowsChromeOptions(
          backdrop: useMica ? WindowsBackdrop.mica : WindowsBackdrop.none,
          roundedCorners: round,
          darkTheme: dark,
        ),
      );
    } catch (e) {
      log.warning('App', 'Windows chrome apply failed: $e');
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

  // Windows only: install the single-instance bridge so that a duplicate
  // sshvault.exe launch (e.g. user double-clicked an ssh:// link while the
  // app is already running) forwards its argv to us via WM_COPYDATA instead
  // of starting a second Flutter engine. Wired AFTER runApp so the engine —
  // and therefore the MethodChannel handler in `flutter_window.cpp` — is
  // live by the time the listener registers.
  if (Platform.isWindows) {
    WindowsInstanceService.instance.init(container: container);
  }

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

  // Android only: keep SSH sessions alive in the background by promoting
  // them into a foreground service backed by a sticky LOW-importance
  // notification. The service mirrors the live `sessionManagerProvider`
  // count and exposes a "Disconnect all" action that routes back into
  // [SessionManagerNotifier.closeAllSessions] via the method channel.
  if (Platform.isAndroid) {
    AndroidSessionService(container: container).attach();
  }

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

  // Windows only: on first run, check whether the ssh:// / sftp:// URL
  // handlers and .pub / .pem / .ppk file associations are present in HKCU.
  // The Inno Setup installer writes them at install time; portable / zip
  // distributions don't, so we offer to register them once. The user's
  // decision is persisted via the [windowsProtocolRegistered] flag so the
  // dialog never reappears.
  if (Platform.isWindows) {
    unawaited(_maybePromptWindowsProtocolRegistration(container));
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

/// Windows-only first-run hook: detects whether the ssh:// / sftp:// URL
/// handlers and .pub / .pem / .ppk file associations are already registered
/// (Inno installer or a previous launch). If not, surfaces a one-time
/// confirmation dialog and writes the keys via [WindowsProtocolRegistrar].
///
/// All errors are swallowed and logged — the app must boot even when the
/// registry is unreachable. The persisted [windowsProtocolRegistered] flag
/// guarantees we never bother the user twice, regardless of outcome.
Future<void> _maybePromptWindowsProtocolRegistration(
  ProviderContainer container,
) async {
  final log = LoggingService.instance;
  try {
    final settings = await container.read(settingsProvider.future);
    if (settings.windowsProtocolRegistered) return;

    const registrar = WindowsProtocolRegistrar();
    if (await registrar.isRegistered()) {
      // Inno installer (or a prior run) already wrote the keys — flip the
      // flag so we don't reprobe on every boot.
      await container
          .read(settingsProvider.notifier)
          .setWindowsProtocolRegistered(true);
      return;
    }

    // Defer the dialog so the navigator is ready and the splash frame is
    // already drawn (avoids racing the first frame).
    await Future<void>.delayed(const Duration(milliseconds: 750));
    final navContext = rootNavigatorKey.currentContext;
    if (navContext == null) {
      log.warning(
        'App',
        'Windows protocol prompt skipped: navigator not ready',
      );
      return;
    }

    // The navigator's currentContext is the post-await source of truth here;
    // the context is owned by the persistent root navigator key so it does
    // not go stale between awaits the way a transient widget context would.
    final accept = await showDialog<bool>(
      // ignore: use_build_context_synchronously
      context: navContext,
      builder: (ctx) => AlertDialog(
        title: const Text('Register SSHVault as default ssh:// handler?'),
        content: const Text(
          'SSHVault can register itself as the default handler for '
          'ssh:// and sftp:// URLs and as the opener for SSH key files '
          '(.pub, .pem, .ppk). The change is per-user and can be reverted '
          'from Settings → Network at any time.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Register'),
          ),
        ],
      ),
    );

    final notifier = container.read(settingsProvider.notifier);
    if (accept == true) {
      try {
        await registrar.register();
        await notifier.setWindowsProtocolRegistered(true);
      } catch (e) {
        log.warning('App', 'Windows protocol registration failed: $e');
      }
    } else {
      // Persist the dismissal too — never re-prompt on subsequent launches.
      await notifier.setWindowsProtocolRegistered(true);
    }
  } catch (e) {
    log.warning('App', 'Windows protocol first-run hook failed: $e');
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
