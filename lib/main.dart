import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/app.dart';
import 'package:shellvault/core/services/logging_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final log = LoggingService.instance;
  log.info('App', 'SSH Vault starting');

  runApp(const ProviderScope(child: _LifecycleWrapper(child: ShellVaultApp())));
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
