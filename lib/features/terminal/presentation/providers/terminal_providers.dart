import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:xterm/xterm.dart';

import 'package:shellvault/core/storage/database_provider.dart';
import 'package:shellvault/features/connection/domain/entities/auth_method.dart';
import 'package:shellvault/features/connection/presentation/providers/repository_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/server_providers.dart';
import 'package:shellvault/features/terminal/data/services/ssh_service.dart';
import 'package:shellvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:shellvault/features/terminal/domain/entities/terminal_theme_data.dart';

// ---------------------------------------------------------------------------
// SSH Service
// ---------------------------------------------------------------------------

final sshServiceProvider = Provider<SshService>((ref) => SshService());

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
        onFailure: (f) => throw Exception(f.message),
      );

      // Update title
      session.title = server.name;
      _notifyChange();

      // Load credentials
      final credsResult =
          await serverUseCases.getCredentials(session.serverId);
      final credentials = credsResult.fold(
        onSuccess: (c) => c,
        onFailure: (f) => throw Exception(f.message),
      );

      // Load managed key if applicable
      String? managedPrivateKey;
      String? managedPassphrase;
      if (server.sshKeyId != null &&
          server.authMethod != AuthMethod.password) {
        final keyResult =
            await sshKeyUseCases.getSshKeyPrivateKey(server.sshKeyId!);
        managedPrivateKey = keyResult.fold(
          onSuccess: (k) => k,
          onFailure: (_) => null,
        );
        final passphraseResult =
            await sshKeyUseCases.getSshKeyPassphrase(server.sshKeyId!);
        managedPassphrase = passphraseResult.fold(
          onSuccess: (p) => p,
          onFailure: (_) => null,
        );
      }

      session.status = SshConnectionStatus.authenticating;
      _notifyChange();

      // Connect
      final result = await sshService.connect(
        server: server,
        credentials: credentials,
        terminal: session.terminal,
        managedPrivateKey: managedPrivateKey,
        managedPassphrase: managedPassphrase,
      );

      result.fold(
        onSuccess: (connection) {
          session.client = connection.client;
          session.session = connection.session;
          session.stdoutSubscription = connection.stdoutSubscription;
          session.stderrSubscription = connection.stderrSubscription;
          session.status = SshConnectionStatus.connected;
          session.errorMessage = null;

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
        },
        onFailure: (failure) {
          session.status = SshConnectionStatus.error;
          session.errorMessage = failure.message;
        },
      );

      _notifyChange();
    } catch (e) {
      session.status = SshConnectionStatus.error;
      session.errorMessage = e.toString();
      _notifyChange();
    }
  }

  void closeSession(String sessionId) {
    final index = state.indexWhere((s) => s.id == sessionId);
    if (index < 0) return;

    final session = state[index];
    session.cancelSubscriptions();
    session.client?.close();

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

    // Reset state
    session.client = null;
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
    final current = state.valueOrNull ?? _default;
    await setFontSize(current + 1);
  }

  Future<void> decrease() async {
    final current = state.valueOrNull ?? _default;
    await setFontSize(current - 1);
  }
}
