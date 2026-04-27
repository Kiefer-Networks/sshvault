/// Windows taskbar integration for SSHVault.
///
/// Wraps the native `de.kiefer_networks.sshvault/taskbar` MethodChannel
/// (implemented in `windows/runner/taskbar_helper.{cpp,h}`) and surfaces
/// three high-level features:
///
///   1. [setSftpTransferProgress] — paints a progress bar over the taskbar
///      icon while a long SFTP upload/download is in flight.
///   2. [setSessionThumbnailButtons] — shows mini-buttons in the
///      window-preview popup ("Disconnect all", "Show terminal") whenever
///      at least one SSH session is active. Clicks are streamed via
///      [thumbButtonEvents] so ViewModels can react.
///   3. [flashOnFingerprintWarning] — flashes the taskbar to draw the
///      user's attention when a known-host mismatch alert fires.
///
/// All methods are no-ops on non-Windows platforms. Callers may still
/// guard at the call site (`if (Platform.isWindows)`) for clarity, but
/// it is not required: the service short-circuits internally.
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sshvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

/// Logical identifiers for the thumb-bar buttons we surface to the OS.
class TaskbarThumbButton {
  /// Disconnect every active SSH session.
  static const String disconnectAll = 'disconnect_all';

  /// Bring the main window forward and switch to the terminal tab.
  static const String showTerminal = 'show_terminal';

  const TaskbarThumbButton._();
}

/// Progress-bar visual states accepted by the native `setProgress` method.
///
/// Strings match the C++ side exactly, so don't rename without updating
/// `windows/runner/taskbar_helper.cpp`.
enum TaskbarProgressState {
  none,
  normal,
  paused,
  error,
  indeterminate;

  String get wireValue {
    switch (this) {
      case TaskbarProgressState.none:
        return 'none';
      case TaskbarProgressState.normal:
        return 'normal';
      case TaskbarProgressState.paused:
        return 'paused';
      case TaskbarProgressState.error:
        return 'error';
      case TaskbarProgressState.indeterminate:
        return 'indeterminate';
    }
  }
}

/// Singleton wrapper around the native taskbar channel.
class WindowsTaskbarService {
  /// Channel name shared with the C++ side.
  @visibleForTesting
  static const MethodChannel channel = MethodChannel(
    'de.kiefer_networks.sshvault/taskbar',
  );

  WindowsTaskbarService._();
  static final WindowsTaskbarService instance = WindowsTaskbarService._();

  final StreamController<String> _buttonClicks =
      StreamController<String>.broadcast();

  bool _handlerInstalled = false;
  bool _lastHasButtons = false;

  /// Emits the logical id of any thumb button the user clicks.
  Stream<String> get thumbButtonEvents => _buttonClicks.stream;

  /// Returns true on a host where the native bridge exists. Visible for
  /// override in unit tests so we can exercise the dispatch path on Linux.
  @visibleForTesting
  bool platformOverride = false;

  bool get _enabled {
    if (platformOverride) return true;
    if (kIsWeb) return false;
    return Platform.isWindows;
  }

  /// Install the inbound handler that routes `onThumbButtonClicked` from
  /// the native side onto [thumbButtonEvents]. Idempotent.
  void _ensureHandler() {
    if (_handlerInstalled) return;
    _handlerInstalled = true;
    channel.setMethodCallHandler((call) async {
      if (call.method == 'onThumbButtonClicked' && call.arguments is String) {
        _buttonClicks.add(call.arguments as String);
      }
      return null;
    });
  }

  /// Updates the taskbar progress overlay.
  ///
  /// [value] is clamped to 0..1. When [state] is `none` or `indeterminate`
  /// the value is ignored. Failures from the native side are swallowed —
  /// the taskbar visual is best-effort.
  Future<void> setProgress(TaskbarProgressState state, double value) async {
    if (!_enabled) return;
    final clamped = value.isNaN ? 0.0 : value.clamp(0.0, 1.0).toDouble();
    try {
      await channel.invokeMethod<void>('setProgress', <String, Object?>{
        'state': state.wireValue,
        'value': clamped,
      });
    } on PlatformException {
      // best-effort — ignore.
    } on MissingPluginException {
      // Channel not registered (e.g. running tests without the runner).
    }
  }

  /// Convenience used by the SFTP transfer manager. Pass a fraction in the
  /// 0..1 range while a transfer is active. Pass `null` (or call
  /// [clearSftpTransferProgress]) to remove the overlay once everything is
  /// done.
  Future<void> setSftpTransferProgress(
    double? fraction, {
    bool failed = false,
  }) async {
    if (failed) {
      await setProgress(TaskbarProgressState.error, fraction ?? 1.0);
      return;
    }
    if (fraction == null) {
      await setProgress(TaskbarProgressState.none, 0.0);
      return;
    }
    await setProgress(TaskbarProgressState.normal, fraction);
  }

  /// Removes any taskbar progress overlay.
  Future<void> clearSftpTransferProgress() =>
      setProgress(TaskbarProgressState.none, 0.0);

  /// Updates the thumbnail-toolbar buttons. With [hasActive] true we
  /// install the "Disconnect all" + "Show terminal" pair; otherwise we
  /// clear the toolbar.
  Future<void> setSessionThumbnailButtons({required bool hasActive}) async {
    if (!_enabled) return;
    _ensureHandler();
    if (hasActive == _lastHasButtons) return;
    _lastHasButtons = hasActive;

    final buttons = hasActive
        ? <Map<String, Object?>>[
            <String, Object?>{
              'id': TaskbarThumbButton.disconnectAll,
              'tooltip': 'Disconnect all sessions',
              'enabled': true,
            },
            <String, Object?>{
              'id': TaskbarThumbButton.showTerminal,
              'tooltip': 'Show terminal',
              'enabled': true,
            },
          ]
        : const <Map<String, Object?>>[];

    try {
      await channel.invokeMethod<void>('setThumbButtons', buttons);
    } on PlatformException {
      // ignore
    } on MissingPluginException {
      // ignore
    }
  }

  /// Briefly flashes the taskbar entry to alert the user. Used when a
  /// known-host (fingerprint) mismatch is detected so the warning isn't
  /// missed while focus is on another desktop / window.
  Future<void> flashOnFingerprintWarning() async {
    if (!_enabled) return;
    try {
      await channel.invokeMethod<void>('flashTaskbar');
    } on PlatformException {
      // ignore
    } on MissingPluginException {
      // ignore
    }
  }

  /// Tear-down for tests / shutdown.
  @visibleForTesting
  Future<void> dispose() async {
    await _buttonClicks.close();
  }

  /// Resets internal state so the next test starts from a clean slate.
  @visibleForTesting
  void resetForTest() {
    _lastHasButtons = false;
    _handlerInstalled = false;
  }
}

/// Riverpod hook that wires [sessionManagerProvider] into the taskbar
/// service: every transition of the active-session count between 0 and >=1
/// flips the thumbnail toolbar on / off.
///
/// Wiring is achieved as a side-effect of `ref.watch(...)` on this
/// provider — typically watched once from a top-level widget or
/// `ProviderContainer.read(...)` in `main.dart`. Doing it as a provider
/// keeps the lifecycle tied to the Riverpod scope (auto-cleanup on
/// container dispose) and avoids leaking listeners across hot-restart.
final windowsTaskbarSessionWiringProvider = Provider<void>((ref) {
  final svc = WindowsTaskbarService.instance;
  ref.listen<List<SshSessionEntity>>(sessionManagerProvider, (prev, next) {
    final wasActive = (prev ?? const <SshSessionEntity>[]).isNotEmpty;
    final isActive = next.isNotEmpty;
    if (wasActive == isActive) return;
    svc.setSessionThumbnailButtons(hasActive: isActive);
  }, fireImmediately: true);
});
