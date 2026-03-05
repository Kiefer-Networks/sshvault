import 'dart:async';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';
import 'package:xterm/xterm.dart';

import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/routing/app_router.dart';
import 'package:shellvault/core/services/vpn_detector_service.dart';
import 'package:shellvault/core/storage/database_provider.dart';
import 'package:shellvault/features/connection/domain/entities/auth_method.dart';
import 'package:shellvault/features/connection/domain/entities/proxy_config.dart';
import 'package:shellvault/features/connection/domain/entities/proxy_credentials.dart';
import 'package:shellvault/features/connection/domain/entities/server_credentials.dart';
import 'package:shellvault/features/connection/domain/entities/server_entity.dart';
import 'package:shellvault/features/connection/domain/usecases/proxy_resolver.dart';
import 'package:shellvault/features/connection/presentation/providers/repository_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/server_providers.dart';
import 'package:shellvault/core/services/terminal_notification_service.dart';
import 'package:shellvault/features/host_key/domain/entities/known_host_entity.dart';
import 'package:shellvault/features/host_key/presentation/providers/known_host_providers.dart';
import 'package:shellvault/features/host_key/presentation/widgets/host_key_verification_dialog.dart';
import 'package:shellvault/features/settings/presentation/providers/proxy_settings_provider.dart';
import 'package:shellvault/features/terminal/data/services/ssh_service.dart';
import 'package:shellvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:shellvault/features/terminal/domain/entities/terminal_theme_data.dart';

// ---------------------------------------------------------------------------
// SSH Service
// ---------------------------------------------------------------------------

final sshServiceProvider = Provider<SshService>((ref) => SshService());

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

  @override
  List<SshSessionEntity> build() => [];

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
      title: 'Connecting...',
      terminal: terminal,
    );

    // Add to list immediately for instant feedback
    state = [...state, session];
    ref.read(activeSessionIndexProvider.notifier).state = state.length - 1;

    // Connect asynchronously
    await _connectSession(session);
  }

  Future<void> _connectSession(SshSessionEntity session) async {
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
      if (server.sshKeyId != null && server.authMethod != AuthMethod.password) {
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
            if (state.any((s) => s.id == session.id)) {
              session.status = SshConnectionStatus.disconnected;
              session.cancelSubscriptions();
              _notifyChange();
            }
          });

          // Listen for title changes
          session.terminal.onTitleChange = (title) {
            session.title = title;
            _notifyChange();
          };

          // Detect distro in background
          _detectDistro(session);

          // Execute post-connect commands
          _executePostConnectCommands(session, server);
        },
        onFailure: (failure) {
          session.status = SshConnectionStatus.error;
          session.errorMessage = failure.message;
        },
      );

      _notifyChange();
    } catch (e) {
      session.status = SshConnectionStatus.error;
      session.errorMessage = errorMessage(e);
      _notifyChange();
    }
  }

  void closeSession(String sessionId) {
    final index = state.indexWhere((s) => s.id == sessionId);
    if (index < 0) return;

    final session = state[index];
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
    session.jumpHostClient = null;
    session.session = null;
    session.status = SshConnectionStatus.connecting;
    session.errorMessage = null;
    _notifyChange();

    // Reconnect
    await _connectSession(session);
  }

  Future<void> _detectDistro(SshSessionEntity session) async {
    if (session.client == null) return;
    final sshService = ref.read(sshServiceProvider);
    final distro = await sshService.detectDistro(session.client!);
    if (distro != null && state.any((s) => s.id == session.id)) {
      session.distroInfo = distro;
      _notifyChange();

      // Persist distro info on the server entity
      _saveDistroInfo(session.serverId, distro);
    }
  }

  Future<void> _saveDistroInfo(String serverId, DistroInfo distro) async {
    try {
      final serverUseCases = ref.read(serverUseCasesProvider);
      final result = await serverUseCases.getServer(serverId);
      result.fold(
        onSuccess: (server) async {
          if (server.distroId == distro.id) return;
          final updated = server.copyWith(
            distroId: distro.id,
            distroName: distro.displayName,
          );
          await serverUseCases.updateServer(updated, null);
          ref.invalidate(serverDetailProvider(serverId));
        },
        onFailure: (_) {},
      );
    } catch (_) {}
  }

  Future<void> _updateLastConnectedAt(String serverId) async {
    try {
      final db = ref.read(databaseProvider);
      await db.serverDao.setLastConnectedAt(serverId, DateTime.now());
    } catch (_) {}
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
    return (String type, Uint8List fingerprint) async {
      final hex = _fingerprintToHex(fingerprint);
      final repo = ref.read(knownHostRepositoryProvider);
      final existing = await repo.findByHostAndPort(
        server.hostname,
        server.port,
      );

      KnownHostEntity? known;
      if (existing.isSuccess) {
        known = existing.value;
      }

      if (known != null) {
        if (known.fingerprint == hex) {
          await repo.save(known.copyWith(lastSeenAt: DateTime.now()));
          return true;
        }
        // Key changed
        final accepted = await _showHostKeyDialog(
          server.hostname,
          server.port,
          type,
          hex,
          known,
        );
        if (accepted) {
          await repo.save(
            known.copyWith(
              keyType: type,
              fingerprint: hex,
              lastSeenAt: DateTime.now(),
            ),
          );
          ref.invalidate(knownHostListProvider);
        }
        return accepted;
      }

      // First connection — TOFU
      final accepted = await _showHostKeyDialog(
        server.hostname,
        server.port,
        type,
        hex,
        null,
      );
      if (accepted) {
        final now = DateTime.now();
        await repo.save(
          KnownHostEntity(
            id: _uuid.v4(),
            hostname: server.hostname,
            port: server.port,
            keyType: type,
            fingerprint: hex,
            firstSeenAt: now,
            lastSeenAt: now,
          ),
        );
        ref.invalidate(knownHostListProvider);
      }
      return accepted;
    };
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

  static String _fingerprintToHex(Uint8List bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(':');
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
  if (index == null || sessions.isEmpty || index >= sessions.length)
    return null;
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
