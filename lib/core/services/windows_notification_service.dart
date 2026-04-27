import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:window_manager/window_manager.dart';

/// AppUserModelID registered for SSHVault on Windows. Must match the value
/// written by the Inno Setup installer under
/// `HKCU\Software\Classes\AppUserModelId\<aumid>` so the Action Center can
/// resolve the toast back to our application icon and persist its history.
///
/// This constant is the single source of truth — changing it requires
/// updating `windows/installer.iss`, the runtime registrar, and any docs.
const String kSshVaultAumid = 'de.kiefer_networks.SSHVault';

// FFI bindings for `SetCurrentProcessExplicitAppUserModelID` from
// shell32.dll. We avoid pulling another high-level wrapper by going
// direct — this is the only call we need from shell32 on the boot path.
// `Utf16` comes from `package:ffi` (not `dart:ffi`); we therefore drop
// the `ffi.` prefix on it.
typedef _SetAumidNative = ffi.Int32 Function(ffi.Pointer<Utf16> appId);
typedef _SetAumidDart = int Function(ffi.Pointer<Utf16> appId);

/// Registers [kSshVaultAumid] as the current process's explicit
/// AppUserModelID. Call this once early in `main()` BEFORE
/// `LocalNotifier.setup()` so the Win32 toast plumbing already knows
/// which AUMID to attach to the toast notifier. No-ops on non-Windows.
///
/// The matching `HKCU\Software\Classes\AppUserModelId\<aumid>` registry
/// key is written by `windows/installer.iss`; without it Windows still
/// shows the toast but renders a generic icon and the Action Center
/// entry can't be re-launched into a fresh SSHVault.
Future<void> registerSshVaultAumid() async {
  if (!Platform.isWindows) return;
  try {
    final shell32 = ffi.DynamicLibrary.open('shell32.dll');
    final fn = shell32.lookupFunction<_SetAumidNative, _SetAumidDart>(
      'SetCurrentProcessExplicitAppUserModelID',
    );
    final aumidPtr = kSshVaultAumid.toNativeUtf16();
    try {
      fn(aumidPtr);
    } finally {
      malloc.free(aumidPtr);
    }
  } catch (_) {
    // shell32 missing or symbol unavailable on this build — toasts will
    // still surface, just without the rich AUMID-resolved metadata.
  }
}

/// Lightweight handle attached to each toast. Carries a free-form string
/// such as `"reconnect:HOST_ID"` or `"disconnect:SESSION_ID"`. The service
/// re-emits this verbatim on its [actionStream] when the user clicks the
/// matching button in the toast or in Windows Action Center; downstream
/// view-models pattern-match on the prefix.
class WindowsNotificationAction {
  /// Visible button label.
  final String label;

  /// Opaque payload routed to listeners when the button is invoked.
  final String tag;

  const WindowsNotificationAction({required this.label, required this.tag});
}

/// Wraps the `local_notifier` package (which uses
/// `Windows.UI.Notifications.ToastNotificationManager` under the hood) to
/// surface native Windows toasts that:
///
///   - render as proper Windows 10/11 toasts (no balloon fallback),
///   - persist in the Action Center keyed by [AppUserModelID](
///     https://learn.microsoft.com/en-us/windows/win32/shell/appids),
///   - support up to five action buttons,
///   - are deduplicated by stable string id (replace-on-show semantics).
///
/// On platforms other than Windows this class is intentionally a no-op so
/// callers can use it from cross-platform code; the existing
/// `flutter_local_notifications` plumbing continues to handle Linux and
/// macOS unchanged.
class WindowsNotificationService {
  /// Emits the [WindowsNotificationAction.tag] of every action that the user
  /// invokes (either by clicking a button on the live toast or from the
  /// Action Center). Subscribers — typically Riverpod listeners in
  /// view-models — pattern-match the tag prefix to dispatch the right
  /// command (`disconnect:`, `reconnect:`, `show:`).
  Stream<String> get actionStream => _actionController.stream;

  final StreamController<String> _actionController =
      StreamController<String>.broadcast();

  /// Active toasts keyed by caller-supplied id. Used to implement the
  /// replace-on-show contract (showing the same id replaces the previous
  /// notification both in the tray and in the Action Center) and to dispose
  /// resources from [dismiss].
  final Map<String, LocalNotification> _active = <String, LocalNotification>{};

  bool _initialized = false;

  /// Lazily initializes [LocalNotifier] with the SSHVault AUMID. Safe to
  /// call multiple times; the underlying setup runs at most once. Returns
  /// `false` on non-Windows hosts so callers can short-circuit.
  Future<bool> _ensureInitialized() async {
    if (!Platform.isWindows) return false;
    if (_initialized) return true;
    await localNotifier.setup(
      appName: 'SSHVault',
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );
    _initialized = true;
    return true;
  }

  /// Show or replace a toast.
  ///
  /// - [id] is opaque; passing the same id again replaces the previous
  ///   toast (both visually and in the Action Center).
  /// - [actions] become inline buttons. Their [WindowsNotificationAction.tag]
  ///   is what gets emitted on [actionStream]; the label is shown to the
  ///   user.
  /// - Tapping the toast body (not a button) brings the SSHVault window to
  ///   the front via `window_manager` so the user lands directly in the
  ///   terminal that triggered the notification.
  Future<void> show({
    required String id,
    required String title,
    required String body,
    List<WindowsNotificationAction> actions = const [],
  }) async {
    if (!await _ensureInitialized()) return;

    // Replace-by-id: tear down any prior toast with the same id so the
    // Action Center collapses them into a single entry instead of stacking
    // duplicates as the session list churns.
    await dismiss(id);

    final notification = LocalNotification(
      identifier: id,
      title: title,
      body: body,
      actions: actions
          .map((a) => LocalNotificationAction(text: a.label))
          .toList(growable: false),
    );

    notification.onClick = _bringWindowToFront;
    notification.onClickAction = (int index) {
      if (index < 0 || index >= actions.length) return;
      _actionController.add(actions[index].tag);
    };
    notification.onClose = (LocalNotificationCloseReason _) {
      _active.remove(id);
    };

    _active[id] = notification;
    await notification.show();
  }

  /// Dismiss a previously-shown toast. Removes it from the live tray and
  /// clears it from the Action Center. No-op if the id is unknown.
  Future<void> dismiss(String id) async {
    final existing = _active.remove(id);
    if (existing == null) return;
    try {
      await existing.close();
    } catch (_) {
      // local_notifier may throw if the notification is already gone; safe
      // to ignore — the tracking map is the source of truth.
    }
  }

  /// Brings the SSHVault window to the front. Used by the toast click
  /// callback so the user lands in the running app on click rather than
  /// the splash screen / tray.
  Future<void> _bringWindowToFront() async {
    try {
      await windowManager.show();
      await windowManager.focus();
    } catch (_) {
      // window_manager not initialized (e.g. headless boot) — ignore.
    }
  }

  /// Tear down resources. Closes the broadcast stream so listeners receive
  /// a clean done signal; called from the owning provider's dispose.
  Future<void> dispose() async {
    for (final entry in _active.values) {
      try {
        await entry.close();
      } catch (_) {}
    }
    _active.clear();
    await _actionController.close();
  }
}
