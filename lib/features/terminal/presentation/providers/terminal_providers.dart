import 'dart:async';
import 'dart:convert';
import 'package:sshvault/features/host_key/domain/services/host_key_verifier.dart';

import 'package:dartssh2/dartssh2.dart';
import 'package:sshvault/core/ssh/agent_identities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';
import 'package:xterm/xterm.dart';

import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/core/routing/app_router.dart';
import 'package:sshvault/core/services/vpn_detector_service.dart';
import 'package:sshvault/core/storage/database_provider.dart';
import 'package:sshvault/features/connection/domain/entities/auth_method.dart';
import 'package:sshvault/features/connection/domain/entities/proxy_config.dart';
import 'package:sshvault/features/connection/domain/entities/proxy_credentials.dart';
import 'package:sshvault/features/connection/domain/entities/server_credentials.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/connection/domain/usecases/proxy_resolver.dart';
import 'package:sshvault/features/connection/presentation/providers/repository_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/core/services/terminal_notification_service.dart';
import 'package:sshvault/features/host_key/domain/entities/known_host_entity.dart';
import 'package:sshvault/features/host_key/presentation/providers/known_host_providers.dart';
import 'package:sshvault/features/host_key/presentation/widgets/host_key_verification_dialog.dart';
import 'package:sshvault/features/settings/presentation/providers/proxy_settings_provider.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/features/settings/domain/entities/app_settings_entity.dart';
import 'package:sshvault/features/terminal/data/services/ssh_service.dart';
import 'package:sshvault/features/terminal/data/services/remote_system_metrics_service.dart';
import 'package:sshvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:sshvault/features/terminal/presentation/models/terminal_theme_data.dart';

// ---------------------------------------------------------------------------
// SSH Service
// ---------------------------------------------------------------------------

final sshServiceProvider = Provider<SshService>((ref) => SshService());
final remoteSystemMetricsServiceProvider = Provider<RemoteSystemMetricsService>(
  (ref) => RemoteSystemMetricsService(),
);

final terminalNotificationProvider = Provider<TerminalNotificationService>(
  (ref) => TerminalNotificationService(),
);

// ---------------------------------------------------------------------------
// Session Manager
// ---------------------------------------------------------------------------

final sessionManagerProvider =
    NotifierProvider<SessionManagerNotifier, List<SshSessionEntity>>(
      SessionManagerNotifier.new,
    );

class SessionManagerNotifier extends Notifier<List<SshSessionEntity>> {
  static const _uuid = Uuid();
  // Transient status replaced once server name loads; no BuildContext available.
  static const _connectingPlaceholder = 'Connecting...';
  final Map<String, Timer> _metricsTimers = {};

  @override
  List<SshSessionEntity> build() {
    ref.listen<AsyncValue<AppSettingsEntity>>(settingsProvider, (_, _) {
      for (final session in state) {
        if (session.status == SshConnectionStatus.connected) {
          _startSystemMetricsRefresh(session);
        }
      }
    });
    ref.onDispose(() {
      for (final timer in _metricsTimers.values) {
        timer.cancel();
      }
      _metricsTimers.clear();
    });
    return [];
  }

  /// Opens a new session or switches to an existing one for the given server.
  Future<void> openSession(String serverId) async {
    // If session already exists for this server, just switch to it
    final existingIndex = state.indexWhere((s) => s.serverId == serverId);
    if (existingIndex >= 0) {
      ref.read(activeSessionIndexProvider.notifier).state = existingIndex;
      return;
    }

    // Create terminal instance
    final terminal = Terminal(maxLines: 10000);
    final sessionId = _uuid.v4();

    // Create session entity with "Connecting..." state
    final session = SshSessionEntity(
      id: sessionId,
      serverId: serverId,
      title: _connectingPlaceholder,
      terminal: terminal,
    );

    // Add to list immediately for instant feedback
    state = [...state, session];
    ref.read(activeSessionIndexProvider.notifier).state = state.length - 1;

    // Connect asynchronously
    await _connectSession(session);
  }

  Future<void> _connectSession(SshSessionEntity session) async {
    final generation = ++session.connectionGeneration;
    bool isCurrent() =>
        session.connectionGeneration == generation &&
        state.any((entry) => identical(entry, session));
    final sshService = ref.read(sshServiceProvider);
    final serverUseCases = ref.read(serverUseCasesProvider);
    final sshKeyUseCases = ref.read(sshKeyUseCasesProvider);

    try {
      // Load server data
      final serverResult = await serverUseCases.getServer(session.serverId);
      final server = serverResult.fold(
        onSuccess: (s) => s,
        onFailure: (f) => throw f,
      );

      // Update title
      session.title = server.name;
      _notifyChange();

      // Load credentials
      final credsResult = await serverUseCases.getCredentials(session.serverId);
      final credentials = credsResult.fold(
        onSuccess: (c) => c,
        onFailure: (f) => throw f,
      );

      // Load managed key if applicable
      String? managedPrivateKey;
      String? managedPassphrase;
      if (server.sshKeyId != null &&
          server.sshKeyId != kSshAgentSentinelKeyId &&
          server.authMethod != AuthMethod.password) {
        final keyResult = await sshKeyUseCases.getSshKeyPrivateKey(
          server.sshKeyId!,
        );
        managedPrivateKey = keyResult.fold(
          onSuccess: (k) => k,
          onFailure: (_) => null,
        );
        final passphraseResult = await sshKeyUseCases.getSshKeyPassphrase(
          server.sshKeyId!,
        );
        managedPassphrase = passphraseResult.fold(
          onSuccess: (p) => p,
          onFailure: (_) => null,
        );
      }

      // Load jump host if configured
      ServerEntity? jumpHost;
      ServerCredentials? jumpHostCredentials;
      String? jumpHostPrivateKey;
      String? jumpHostPassphrase;

      if (server.jumpHostId != null) {
        final jumpResult = await serverUseCases.getServer(server.jumpHostId!);
        jumpHost = jumpResult.fold(onSuccess: (s) => s, onFailure: (_) => null);
        if (jumpHost != null) {
          final jumpCredsResult = await serverUseCases.getCredentials(
            jumpHost.id,
          );
          jumpHostCredentials = jumpCredsResult.fold(
            onSuccess: (c) => c,
            onFailure: (_) => null,
          );
          if (jumpHost.sshKeyId != null &&
              jumpHost.sshKeyId != kSshAgentSentinelKeyId &&
              jumpHost.authMethod != AuthMethod.password) {
            final keyResult = await sshKeyUseCases.getSshKeyPrivateKey(
              jumpHost.sshKeyId!,
            );
            jumpHostPrivateKey = keyResult.fold(
              onSuccess: (k) => k,
              onFailure: (_) => null,
            );
            final passphraseResult = await sshKeyUseCases.getSshKeyPassphrase(
              jumpHost.sshKeyId!,
            );
            jumpHostPassphrase = passphraseResult.fold(
              onSuccess: (p) => p,
              onFailure: (_) => null,
            );
          }
        }
      }

      // Check VPN requirement
      if (server.requiresVpn) {
        final vpnActive = ref.read(vpnActiveProvider).value ?? false;
        if (!vpnActive) {
          session.terminal.write(
            '\r\n[Warning: VPN is not active but required for this server]\r\n',
          );
        }
      }

      if (!isCurrent()) return;
      session.status = SshConnectionStatus.authenticating;
      _notifyChange();

      // Resolve proxy
      final globalProxy = ref.read(globalProxyConfigProvider);
      final resolver = ProxyResolver();
      final proxyConfig = resolver.resolve(server, globalProxy);
      ProxyCredentials? proxyCredentials;
      if (proxyConfig != null && proxyConfig.type != ProxyType.none) {
        proxyCredentials = await ref.read(
          globalProxyCredentialsProvider.future,
        );
      }

      // Connect
      final result = await sshService.connect(
        server: server,
        credentials: credentials,
        forwardAgent:
            ref.read(settingsProvider).value?.sshAgentForwardByDefault ?? false,
        terminal: session.terminal,
        managedPrivateKey: managedPrivateKey,
        managedPassphrase: managedPassphrase,
        jumpHost: jumpHost,
        jumpHostCredentials: jumpHostCredentials,
        jumpHostPrivateKey: jumpHostPrivateKey,
        jumpHostPassphrase: jumpHostPassphrase,
        proxyConfig: proxyConfig,
        proxyCredentials: proxyCredentials,
        onVerifyHostKey: _buildHostKeyVerifier(server),
        onVerifyJumpHostKey: jumpHost != null
            ? _buildHostKeyVerifier(jumpHost)
            : null,
      );

      result.fold(
        onSuccess: (connection) {
          if (!isCurrent()) {
            connection.stdoutSubscription.cancel();
            connection.stderrSubscription.cancel();
            connection.client.close();
            connection.jumpHostClient?.close();
            return;
          }
          session.client = connection.client;
          session.jumpHostClient = connection.jumpHostClient;
          session.session = connection.session;
          session.stdoutSubscription = connection.stdoutSubscription;
          session.stderrSubscription = connection.stderrSubscription;
          session.status = SshConnectionStatus.connected;
          session.errorMessage = null;

          // Update last connected timestamp
          _updateLastConnectedAt(session.serverId);

          // Listen for session close
          connection.session.done.then((_) {
            if (isCurrent()) {
              session.status = SshConnectionStatus.disconnected;
              _metricsTimers.remove(session.id)?.cancel();
              session.cancelSubscriptions();
              _notifyChange();
            }
          });

          // Listen for title changes
          session.terminal.onTitleChange = (title) {
            session.title = title;
            _notifyChange();
          };

          // Persist OS detection before collecting the remaining system
          // metrics. Both operations update the complete encrypted server
          // entity; running them concurrently could make the older write
          // overwrite systemMetricsJson (or the OS fields), leaving the UI
          // with only the OS information.
          unawaited(_detectDistroAndStartMetrics(session));

          // Execute post-connect commands
          _executePostConnectCommands(session, server);
        },
        onFailure: (failure) {
          if (!isCurrent()) return;
          session.status = SshConnectionStatus.error;
          session.errorMessage = failure.message;
        },
      );

      _notifyChange();
    } catch (e) {
      if (!isCurrent()) return;
      session.status = SshConnectionStatus.error;
      session.errorMessage = errorMessage(e);
      _notifyChange();
    }
  }

  void closeSession(String sessionId) {
    final index = state.indexWhere((s) => s.id == sessionId);
    if (index < 0) return;

    final session = state[index];
    _metricsTimers.remove(sessionId)?.cancel();
    session.cancelSubscriptions();
    session.client?.close();
    session.closeJumpHost();

    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];

    // Adjust active index
    final activeIndex = ref.read(activeSessionIndexProvider);
    if (state.isEmpty) {
      ref.read(activeSessionIndexProvider.notifier).state = 0;
    } else if (activeIndex >= state.length) {
      ref.read(activeSessionIndexProvider.notifier).state = state.length - 1;
    } else if (activeIndex > index) {
      ref.read(activeSessionIndexProvider.notifier).state = activeIndex - 1;
    }
  }

  void closeAllSessions() {
    for (final session in state) {
      _metricsTimers.remove(session.id)?.cancel();
      session.cancelSubscriptions();
      session.client?.close();
      session.closeJumpHost();
    }
    state = [];
    ref.read(activeSessionIndexProvider.notifier).state = 0;
  }

  Future<void> reconnectSession(String sessionId) async {
    final index = state.indexWhere((s) => s.id == sessionId);
    if (index < 0) return;

    final session = state[index];

    // Cancel old subscriptions and close connection
    await session.cancelSubscriptions();
    session.client?.close();
    session.closeJumpHost();

    // Reset state
    session.client = null;
    _metricsTimers.remove(sessionId)?.cancel();
    session.jumpHostClient = null;
    session.session = null;
    session.status = SshConnectionStatus.connecting;
    session.errorMessage = null;
    _notifyChange();

    // Reconnect
    await _connectSession(session);
  }

  void _startSystemMetricsRefresh(SshSessionEntity session) {
    final settings = ref.read(settingsProvider).value;
    if (settings?.serverSystemInfoConsent != true ||
        session.client == null ||
        settings?.serverSystemInfoAutoRefresh != true) {
      _metricsTimers.remove(session.id)?.cancel();
      if (settings?.serverSystemInfoConsent != true || session.client == null) {
        return;
      }
    }
    _refreshSystemMetrics(session);
    if (settings!.serverSystemInfoAutoRefresh) {
      final seconds = settings.serverSystemInfoRefreshIntervalSecs
          .clamp(30, 86400)
          .toInt();
      _metricsTimers[session.id]?.cancel();
      _metricsTimers[session.id] = Timer.periodic(
        Duration(seconds: seconds),
        (_) => _refreshSystemMetrics(session),
      );
    }
  }

  Future<void> _detectDistroAndStartMetrics(SshSessionEntity session) async {
    await _detectDistro(session);
    if (state.any((s) => identical(s, session)) &&
        session.status == SshConnectionStatus.connected) {
      _startSystemMetricsRefresh(session);
    }
  }

  Future<void> _refreshSystemMetrics(SshSessionEntity session) async {
    final client = session.client;
    if (client == null || !state.any((s) => identical(s, session))) return;
    try {
      final metrics = await ref
          .read(remoteSystemMetricsServiceProvider)
          .collect(client);
      if (!state.any((s) => identical(s, session))) return;
      final result = await ref
          .read(serverUseCasesProvider)
          .getServer(session.serverId);
      await result.fold(
        onSuccess: (server) async {
          final update = await ref
              .read(serverUseCasesProvider)
              .updateServer(
                server.copyWith(
                  systemMetricsJson: jsonEncode(metrics.toJson()),
                  updatedAt: DateTime.now(),
                ),
                null,
              );
          update.fold(
            onSuccess: (_) {},
            onFailure: (failure) => LoggingService.instance.warning(
              'SessionManager',
              'Failed to persist system metrics for ${session.serverId}: $failure',
            ),
          );
        },
        onFailure: (failure) async => LoggingService.instance.warning(
          'SessionManager',
          'Could not load server before persisting system metrics: $failure',
        ),
      );
      ref.invalidate(serverDetailProvider(session.serverId));
      // The desktop pane normally watches serverDetailProvider, while the
      // list and mobile routes may still hold the previous entity. Invalidate
      // both caches so freshly collected values are visible everywhere.
      ref.invalidate(serverListProvider);
      ref.invalidate(folderGroupedServersProvider);
      _notifyChange();
    } catch (e) {
      LoggingService.instance.debug(
        'SessionManager',
        'System metrics collection failed: $e',
      );
    }
  }

  /// Manually re-collects system metrics for [serverId] right now, if a
  /// live, authenticated session for it exists. Backs the "Refresh" action
  /// in the host row/detail menus — without this, the only way to update
  /// stored disk/CPU/Proxmox info was waiting for the periodic
  /// auto-refresh (which most users don't even have enabled) or fully
  /// disconnecting and reconnecting. Returns `false` when there's no open
  /// session to collect through, so the caller can tell the user why
  /// nothing happened instead of refresh silently doing nothing.
  Future<bool> refreshMetricsNow(String serverId) async {
    final session = state
        .where((s) => s.serverId == serverId && s.client != null)
        .firstOrNull;
    if (session == null) return false;
    await _refreshSystemMetrics(session);
    return true;
  }

  Future<void> _detectDistro(SshSessionEntity session) async {
    if (session.client == null) return;
    final sshService = ref.read(sshServiceProvider);
    final distro = await sshService.detectDistro(session.client!);
    if (distro != null && state.any((s) => s.id == session.id)) {
      session.distroInfo = distro;
      _notifyChange();

      // Persist distro info on the server entity
      await _saveDistroInfo(session.serverId, distro);
    }
  }

  Future<void> _saveDistroInfo(String serverId, DistroInfo distro) async {
    try {
      final serverUseCases = ref.read(serverUseCasesProvider);
      final result = await serverUseCases.getServer(serverId);
      if (result.isSuccess) {
        final server = result.value;
        final unchanged =
            server.osFamily == distro.id &&
            server.osName == distro.name &&
            server.osVersion == distro.version &&
            server.osPrettyName == distro.prettyName;
        if (unchanged) return;
        final updated = server.copyWith(
          distroId: distro.id,
          distroName: distro.displayName,
          osFamily: _osFamilyFor(distro.id),
          osName: distro.name,
          osVersion: distro.version,
          osPrettyName: distro.prettyName,
          osDetectedAt: DateTime.now(),
        );
        await serverUseCases.updateServer(updated, null);
        ref.invalidate(serverDetailProvider(serverId));
      } else {
        final f = result.failure;
        LoggingService.instance.debug(
          'SessionManager',
          'Distribution detection failed: $f',
        );
      }
    } catch (e) {
      LoggingService.instance.debug(
        'SessionManager',
        'Distribution detection failed: $e',
      );
    }
  }

  String _osFamilyFor(String id) {
    final value = id.toLowerCase();
    if (value == 'windows') return 'windows';
    if (value.contains('darwin') || value.contains('mac')) return 'macos';
    if (value.contains('bsd')) return 'bsd';
    if (value == 'linux') return 'linux';
    return 'other';
  }

  Future<void> _updateLastConnectedAt(String serverId) async {
    try {
      final db = ref.read(databaseProvider);
      await db.serverDao.setLastConnectedAt(serverId, DateTime.now());
    } catch (e) {
      LoggingService.instance.warning(
        'SessionManager',
        'Failed to update last connected timestamp: $e',
      );
    }
  }

  Future<void> _executePostConnectCommands(
    SshSessionEntity session,
    ServerEntity server,
  ) async {
    final commands = server.postConnectCommands.trim();
    if (commands.isEmpty) return;
    await Future.delayed(const Duration(milliseconds: 500));
    for (final line in commands.split('\n')) {
      final cmd = line.trim();
      if (cmd.isEmpty) continue;
      session.terminal.textInput('$cmd\n');
      await Future.delayed(const Duration(milliseconds: 150));
    }
  }

  SSHHostkeyVerifyHandler _buildHostKeyVerifier(ServerEntity server) {
    return HostKeyVerifier(
      repository: ref.read(knownHostRepositoryProvider),
      hostname: server.hostname,
      port: server.port,
      confirm: (type, fingerprint, previous) => _showHostKeyDialog(
        server.hostname,
        server.port,
        type,
        fingerprint,
        previous,
      ),
      onStored: () => ref.invalidate(knownHostListProvider),
    ).verify;
  }

  Future<bool> _showHostKeyDialog(
    String hostname,
    int port,
    String keyType,
    String fingerprint,
    KnownHostEntity? existingHost,
  ) async {
    final context = rootNavigatorKey.currentContext;
    if (context == null) return false;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => HostKeyVerificationDialog(
        hostname: hostname,
        port: port,
        keyType: keyType,
        fingerprint: fingerprint,
        existingHost: existingHost,
      ),
    );
    return result ?? false;
  }

  void _notifyChange() {
    state = [...state];
  }
}

// ---------------------------------------------------------------------------
// Active Session
// ---------------------------------------------------------------------------

final activeSessionIndexProvider = StateProvider<int>((ref) => 0);

final activeSessionProvider = Provider<SshSessionEntity?>((ref) {
  final sessions = ref.watch(sessionManagerProvider);
  final index = ref.watch(activeSessionIndexProvider);
  if (sessions.isEmpty || index >= sessions.length) return null;
  return sessions[index];
});

// ---------------------------------------------------------------------------
// Split Terminal
// ---------------------------------------------------------------------------

enum SplitMode { none, horizontal }

final splitModeProvider = StateProvider<SplitMode>((ref) => SplitMode.none);
final secondarySessionIndexProvider = StateProvider<int?>((ref) => null);

final secondarySessionProvider = Provider<SshSessionEntity?>((ref) {
  final sessions = ref.watch(sessionManagerProvider);
  final index = ref.watch(secondarySessionIndexProvider);
  if (index == null || sessions.isEmpty || index >= sessions.length) {
    return null;
  }
  return sessions[index];
});

// ---------------------------------------------------------------------------
// Terminal Theme
// ---------------------------------------------------------------------------

final terminalThemeKeyProvider =
    AsyncNotifierProvider<TerminalThemeKeyNotifier, TerminalThemeKey>(
      TerminalThemeKeyNotifier.new,
    );

class TerminalThemeKeyNotifier extends AsyncNotifier<TerminalThemeKey> {
  static const _key = 'terminal_theme';

  @override
  Future<TerminalThemeKey> build() async {
    final dao = ref.watch(databaseProvider).appSettingsDao;
    final value = await dao.getValue(_key);
    if (value == null) return TerminalThemeKey.defaultDark;
    return TerminalThemeKey.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TerminalThemeKey.defaultDark,
    );
  }

  Future<void> setTheme(TerminalThemeKey key) async {
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_key, key.name);
    ref.invalidateSelf();
  }
}

// ---------------------------------------------------------------------------
// Terminal Font Size
// ---------------------------------------------------------------------------

final terminalFontSizeProvider =
    AsyncNotifierProvider<TerminalFontSizeNotifier, double>(
      TerminalFontSizeNotifier.new,
    );

class TerminalFontSizeNotifier extends AsyncNotifier<double> {
  static const _key = 'terminal_font_size';
  static const _default = 14.0;
  static const _min = 8.0;
  static const _max = 24.0;

  @override
  Future<double> build() async {
    final dao = ref.watch(databaseProvider).appSettingsDao;
    final value = await dao.getValue(_key);
    if (value == null) return _default;
    return double.tryParse(value) ?? _default;
  }

  Future<void> setFontSize(double size) async {
    final clamped = size.clamp(_min, _max);
    final dao = ref.read(databaseProvider).appSettingsDao;
    await dao.setValue(_key, clamped.toString());
    ref.invalidateSelf();
  }

  Future<void> increase() async {
    final current = state.value ?? _default;
    await setFontSize(current + 1);
  }

  Future<void> decrease() async {
    final current = state.value ?? _default;
    await setFontSize(current - 1);
  }
}
