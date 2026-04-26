import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/app.dart';
import 'package:sshvault/core/routing/app_router.dart';
import 'package:sshvault/core/services/dbus_service.dart';
import 'package:sshvault/core/services/file_drop_service.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/core/services/tray_service.dart';
import 'package:sshvault/core/storage/database.dart';
import 'package:sshvault/core/utils/ssh_url_handler.dart';

void main(List<String> args) async {
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

  // Detect "start minimized" intent from CLI / env so the tray service can
  // decide whether to surface the window on first run. Cheap to compute,
  // safe everywhere (the flag is only consulted on Linux).
  TrayService.startMinimized =
      args.contains('--minimized') ||
      Platform.environment['SSHVAULT_MINIMIZED'] == '1';

  // Shared container so we can dispatch the URL handler from outside the
  // widget tree. Reused by ProviderScope below.
  final container = ProviderContainer();

  // Linux only: register the DBus service so external clients can drive us.
  // Done off the main path; failure is non-fatal.
  if (Platform.isLinux) {
    unawaited(SshVaultDBusService.attach(container: container));
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const _LifecycleWrapper(child: SSHVaultApp()),
    ),
  );

  // After the first frame, dispatch any ssh://... / sftp://... URL passed
  // to the binary by xdg-open / desktop file %u.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    SshUrlHandler.handleArgs(container, args);
  });

  // Linux only: install system tray icon. Best-effort — failures are
  // logged but never block app start (e.g. headless test runner, missing
  // libayatana-appindicator on the host).
  if (Platform.isLinux) {
    unawaited(TrayService.instance.init(container));
  }

  // Linux only: hook up the C++ drag-and-drop bridge so dropped SSH key /
  // ssh_config / vault-export files surface the matching import UI.
  if (Platform.isLinux) {
    FileDropService.instance.init(rootNavigatorKey, container: container);
  }
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
