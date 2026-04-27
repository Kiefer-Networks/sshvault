// iOS / iPadOS host bridge for SSHVault.
//
// The Swift side (`ios/Runner/AppDelegate.swift`) forwards every incoming
// `ssh://` / `sftp://` / Universal Link URL over the
// `de.kiefer_networks.sshvault/ios` MethodChannel as `openUrl(<urlString>)`.
// This service installs the listener on the Dart side and pipes the URL
// into the existing [SshUrlHandler] so iOS, macOS, and CLI launches all
// share one routing path.
//
// On non-iOS hosts every entry point is a no-op so the file can be wired
// unconditionally from `main()` without a `Platform.isIOS` guard at the
// call site.
//
// URL buffering: the AppDelegate already buffers URLs that arrive before
// the Flutter engine is up. Once `didInitializeImplicitFlutterEngine`
// wires the channel and Dart calls [start], the Swift side drains the
// buffer by replaying each URL via `invokeMethod`.

library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/core/utils/ssh_url_handler.dart';
import 'package:sshvault/core/utils/ssh_url_parser.dart';

/// Method-channel name shared with `ios/Runner/AppDelegate.swift`.
/// Centralised here so a rename on either side is visible to grep.
const String kIosAppChannel = 'de.kiefer_networks.sshvault/ios';

/// Riverpod-friendly service that owns the iOS method channel and routes
/// inbound URL events into [SshUrlHandler]. Construct via
/// [iosAppServiceProvider] from your startup code; call [start] once the
/// [ProviderContainer] is ready so URL handling has access to the server
/// list provider.
class IosAppService {
  /// Production constructor — binds the real method channel.
  IosAppService() : _channel = const MethodChannel(kIosAppChannel);

  /// Test seam — lets unit tests inject a mock channel without spinning
  /// up the binary messenger machinery.
  @visibleForTesting
  IosAppService.test({required MethodChannel channel}) : _channel = channel;

  static const _tag = 'IosAppService';

  final MethodChannel _channel;

  ProviderContainer? _container;
  bool _started = false;

  /// True on iOS / iPadOS where the native plugin is reachable.
  bool get _isEnabled => !kIsWeb && Platform.isIOS;

  /// Wire the channel handler. Idempotent — calling twice is a no-op.
  /// On non-iOS hosts the call short-circuits before touching the channel.
  void start(ProviderContainer container) {
    if (_started) return;
    _container = container;
    _started = true;
    if (!_isEnabled) return;
    _channel.setMethodCallHandler(_onMethodCall);
  }

  /// Detach the handler. Useful for tests and (in principle) for hot-restart.
  Future<void> dispose() async {
    if (!_started) return;
    _started = false;
    if (_isEnabled) {
      _channel.setMethodCallHandler(null);
    }
    _container = null;
  }

  /// Exposed for unit tests so they can drive the dispatcher directly
  /// without going through the platform messenger.
  @visibleForTesting
  Future<dynamic> handleMethodCall(MethodCall call) => _onMethodCall(call);

  Future<dynamic> _onMethodCall(MethodCall call) async {
    final log = LoggingService.instance;
    switch (call.method) {
      case 'openUrl':
        final raw = call.arguments;
        if (raw is! String || raw.isEmpty) {
          log.warning(_tag, 'openUrl with non-string/empty argument: $raw');
          return null;
        }
        final parsed = SshUrl.parse(raw);
        if (parsed == null) {
          log.warning(_tag, 'openUrl: could not parse "$raw"');
          return null;
        }
        final container = _container;
        if (container == null) {
          log.warning(_tag, 'openUrl received before start() — dropping');
          return null;
        }
        log.info(_tag, 'Routing ${parsed.scheme} URL for ${parsed.hostname}');
        await SshUrlHandler.handle(container, parsed);
        return null;
      default:
        return null;
    }
  }
}

/// Riverpod provider for [IosAppService]. Created eagerly (auto-disposed
/// only at app shutdown) so the channel handler is installed exactly once
/// per process.
final iosAppServiceProvider = Provider<IosAppService>((ref) {
  final service = IosAppService();
  ref.onDispose(service.dispose);
  return service;
});
