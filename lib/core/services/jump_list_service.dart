// Windows Jump List integration for SSHVault.
//
// Right-clicking the SSHVault entry in the Windows taskbar / Start menu pops
// up a jump list with three sections:
//
//   - **Tasks** (always visible)
//       * "Quick connect"        — invokes `sshvault.exe --new-host`
//       * "Reopen last session"  — invokes `sshvault.exe --reopen-last`
//
//   - **Frequent / Favorites** (custom category, populated from
//     `favoriteServersProvider`)
//       * "Connect to <name>"   — invokes `sshvault.exe <serverId>`
//
//   - **Recent** (filled by Windows itself when the running app calls
//     `SHAddToRecentDocs` on session open). The native helper exposes a
//     `markRecent(serverId, name)` shortcut for that.
//
// When the user clicks a jump-list entry, Windows spawns `sshvault.exe` with
// the configured arguments. The single-instance enforcement in
// `windows/runner/main.cpp` short-circuits the second launch, forwards argv to
// the running instance over `WM_COPYDATA`, and the existing
// `windows_instance_service.dart` listener routes the args to the right
// handler (host id → open session, `--new-host` → quick-connect dialog,
// `--reopen-last` → reopen the last session).
//
// Wiring on the C++ side lives in `windows/runner/jump_list_helper.cpp`,
// which exposes a method channel
// `de.kiefer_networks.sshvault/jumplist` with the methods:
//
//   - `setItems(List<Map<String,Object?>>)`
//   - `markRecent(String serverId, String name)`
//   - `clear()`
//
// On Linux, macOS, and any platform without the native helper this service is
// a complete no-op. `MissingPluginException` is treated as "the helper isn't
// wired yet" — we log once and stop.

library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';

/// CLI flag interpreted by `windows_instance_service.dart` for the
/// "Quick connect" task.
const String kJumpListNewHostArg = '--new-host';

/// CLI flag interpreted by `windows_instance_service.dart` for the
/// "Reopen last session" task.
const String kJumpListReopenLastArg = '--reopen-last';

/// Logical category of an item in the Windows Jump List.
enum JumpListItemKind {
  /// "Tasks" section — always-visible verbs ("Quick connect", "Reopen…").
  task,

  /// "Favorites" custom category — one entry per favorite server.
  favorite,
}

/// One entry pushed across the method channel to `setItems`.
///
/// Encoded as a `Map<String, Object?>` so the standard codec can carry it
/// without a custom binary codec on the C++ side.
@immutable
class JumpListItem {
  final JumpListItemKind kind;

  /// Visible label in the jump list ("Quick connect", "Connect to prod-1", …).
  final String label;

  /// Sub-text shown by Windows under the label. Optional.
  final String description;

  /// Argument string passed verbatim to `sshvault.exe`. Whitespace-bearing
  /// tokens MUST already be quoted by the caller.
  final String args;

  /// Optional .ico path used for the entry icon. The native helper falls
  /// back to the application icon when this is empty.
  final String iconPath;

  const JumpListItem({
    required this.kind,
    required this.label,
    required this.args,
    this.description = '',
    this.iconPath = '',
  });

  Map<String, Object?> toMap() => {
    'kind': kind.name,
    'label': label,
    'description': description,
    'args': args,
    'iconPath': iconPath,
  };

  @override
  bool operator ==(Object other) =>
      other is JumpListItem &&
      other.kind == kind &&
      other.label == label &&
      other.description == description &&
      other.args == args &&
      other.iconPath == iconPath;

  @override
  int get hashCode => Object.hash(kind, label, description, args, iconPath);
}

/// Singleton service that owns the Jump List.
class JumpListService {
  JumpListService._();
  static final JumpListService instance = JumpListService._();

  static const _tag = 'JumpList';

  /// Channel name shared with `windows/runner/jump_list_helper.cpp`.
  static const MethodChannel _channel = MethodChannel(
    'de.kiefer_networks.sshvault/jumplist',
  );

  /// Test seam — overridden by tests so we can assert which method was
  /// invoked with which payload without spinning up the full Flutter test
  /// binding's mock messenger machinery.
  @visibleForTesting
  Future<Object?> Function(String method, Object? args) invoker =
      _defaultInvoke;

  static Future<Object?> _defaultInvoke(String method, Object? args) {
    return _channel.invokeMethod(method, args);
  }

  bool _initialized = false;
  bool _disposed = false;
  bool _helperUnavailable = false;

  ProviderContainer? _container;
  ProviderSubscription? _favoritesSub;
  ProviderSubscription? _recentsSub;

  /// Last items pushed to the OS — exposed for testing and to avoid sending
  /// duplicate `setItems` calls when nothing meaningful changed.
  List<JumpListItem> _lastItems = const [];
  List<JumpListItem> get lastItems => List.unmodifiable(_lastItems);

  /// Wire up provider listeners and push the initial jump list. Safe to
  /// call repeatedly; the second invocation is a no-op. Returns
  /// immediately on non-Windows platforms.
  Future<void> init(ProviderContainer container) async {
    if (!_isWindows) return;
    if (_initialized) return;
    _container = container;

    _favoritesSub = container.listen(
      favoriteServersProvider,
      (_, _) => unawaited(_refresh()),
      fireImmediately: false,
    );
    _recentsSub = container.listen(
      recentServersProvider,
      (_, _) => unawaited(_refresh()),
      fireImmediately: false,
    );

    _initialized = true;
    LoggingService.instance.info(_tag, 'Jump list service initialized');
    await _refresh();
  }

  /// Stop listening to providers and clear the OS-level jump list.
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _favoritesSub?.close();
    _recentsSub?.close();
    if (_isWindows && _initialized && !_helperUnavailable) {
      try {
        await invoker('clear', null);
      } catch (_) {
        // best-effort
      }
    }
  }

  /// Inform Windows that a session for [server] just opened so the OS-managed
  /// "Recent" category gets populated. Backed by `SHAddToRecentDocs` on the
  /// C++ side. Safe to call from any platform — no-op when not on Windows.
  Future<void> markRecent(ServerEntity server) async {
    if (!_isWindows || _helperUnavailable) return;
    try {
      await invoker('markRecent', {
        'serverId': server.id,
        'name': server.name.isEmpty ? server.hostname : server.name,
      });
    } on MissingPluginException {
      _helperUnavailable = true;
      LoggingService.instance.warning(
        _tag,
        'Native jump-list helper not registered; SHAddToRecentDocs disabled',
      );
    } catch (e) {
      LoggingService.instance.warning(_tag, 'markRecent failed: $e');
    }
  }

  /// Force a rebuild from the current provider state. Public for testing.
  @visibleForTesting
  Future<void> refresh() => _refresh();

  Future<void> _refresh() async {
    if (!_isWindows || _container == null || _helperUnavailable) return;
    final favorites =
        _container!.read(favoriteServersProvider).value ?? const [];
    await _setItems(buildItems(favorites: favorites));
  }

  /// Pure builder used by tests and by [_refresh]. The order is significant:
  /// tasks first, favorites second — matches the Windows shell convention of
  /// fixed verbs above the custom category.
  static List<JumpListItem> buildItems({
    required List<ServerEntity> favorites,
  }) {
    final items = <JumpListItem>[
      const JumpListItem(
        kind: JumpListItemKind.task,
        label: 'Quick connect',
        description: 'Open the new-host dialog',
        args: kJumpListNewHostArg,
      ),
      const JumpListItem(
        kind: JumpListItemKind.task,
        label: 'Reopen last session',
        description: 'Restore the most recent SSH session',
        args: kJumpListReopenLastArg,
      ),
    ];
    for (final server in favorites) {
      final name = server.name.isEmpty ? server.hostname : server.name;
      items.add(
        JumpListItem(
          kind: JumpListItemKind.favorite,
          label: 'Connect to $name',
          description: server.hostname,
          args: _quoteArg(server.id),
        ),
      );
    }
    return items;
  }

  Future<void> _setItems(List<JumpListItem> items) async {
    if (_listsEqual(items, _lastItems)) return;
    _lastItems = List.unmodifiable(items);
    try {
      await invoker(
        'setItems',
        items.map((e) => e.toMap()).toList(growable: false),
      );
    } on MissingPluginException {
      _helperUnavailable = true;
      LoggingService.instance.warning(
        _tag,
        'Native jump-list helper not registered; setItems disabled',
      );
    } catch (e) {
      LoggingService.instance.warning(_tag, 'setItems failed: $e');
    }
  }

  /// Test-only reset so each test starts with a clean state.
  @visibleForTesting
  void resetForTest() {
    _favoritesSub?.close();
    _recentsSub?.close();
    _favoritesSub = null;
    _recentsSub = null;
    _container = null;
    _lastItems = const [];
    _initialized = false;
    _disposed = false;
    _helperUnavailable = false;
    invoker = _defaultInvoke;
  }

  static bool get _isWindows {
    // Guard `Platform.isWindows` behind kIsWeb so the analyzer doesn't think
    // we're trying to read the `dart:io` platform on web (where it throws).
    if (kIsWeb) return false;
    return Platform.isWindows;
  }

  static String _quoteArg(String arg) {
    if (arg.isEmpty) return '""';
    final needsQuotes = arg.contains(RegExp(r'\s|"'));
    if (!needsQuotes) return arg;
    final escaped = arg.replaceAll('"', r'\"');
    return '"$escaped"';
  }

  static bool _listsEqual(List<JumpListItem> a, List<JumpListItem> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
