// Desktop (GNOME / KDE) appearance integration for SSHVault.
//
// Reads the user's preferred color scheme + accent color from the XDG
// `org.freedesktop.portal.Settings` portal and exposes it through Riverpod.
// Subscribes to `SettingChanged` signals so that changes made in
// gnome-control-center / KDE System Settings propagate live without an app
// restart.
//
// Why a portal and not `MediaQuery.platformBrightness`?
//   On GTK 3, Flutter's view brightness does not always pick up GNOME 42+'s
//   `prefers-color-scheme` change reliably (especially under Wayland after the
//   first frame). The portal gives us a deterministic value plus a signal we
//   can listen to. See:
//     https://flathub.org/apps/details/org.gnome.Settings
//     https://flatpak.github.io/xdg-desktop-portal/docs/doc-org.freedesktop.portal.Settings.html
//
// On non-Linux platforms or when the portal is unavailable (KDE without
// xdg-desktop-portal-kde, headless, no D-Bus session bus, …) every entrypoint
// degrades to a cheap no-op and the providers stay `null`, allowing callers
// to fall back to `MediaQuery`.

import 'dart:async';
import 'dart:io';
import 'dart:ui' show Brightness, Color;

import 'package:dbus/dbus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:sshvault/core/services/logging_service.dart';

/// Portal destination, object and interface for the freedesktop Settings portal.
const String _portalDestination = 'org.freedesktop.portal.Desktop';
const String _portalObjectPath = '/org/freedesktop/portal/desktop';
const String _portalSettingsInterface = 'org.freedesktop.portal.Settings';

/// Namespace + keys for the appearance settings as published by GNOME / KDE.
/// See: https://flatpak.github.io/xdg-desktop-portal/docs/doc-org.freedesktop.portal.Settings.html
const String _appearanceNamespace = 'org.freedesktop.appearance';
const String _keyColorScheme = 'color-scheme';
const String _keyAccentColor = 'accent-color';

/// Holds the desktop's preferred [Brightness], updated live via the portal.
///
/// `null` means "unknown / no-preference" — callers should fall back to
/// `MediaQuery.platformBrightness`.
final desktopColorSchemeProvider = StateProvider<Brightness?>((ref) => null);

/// Holds the desktop's accent color (GNOME 47+, KDE 6+), updated live via the
/// portal. `null` means the portal didn't expose one — callers should fall
/// back to their built-in brand color.
final desktopAccentColorProvider = StateProvider<Color?>((ref) => null);

/// Lifecycle owner for [DesktopAppearanceService] — auto-disposed when the
/// container is torn down. The provider is `keepAlive` because we want the
/// signal subscription to outlive transient widget rebuilds.
final desktopAppearanceServiceProvider = Provider<DesktopAppearanceService>((
  ref,
) {
  final service = DesktopAppearanceService(ref);
  ref.onDispose(service.dispose);
  // Kick off initialization eagerly. We don't await — the providers update
  // asynchronously as the portal replies / emits signals.
  // ignore: discarded_futures
  service.initialize();
  return service;
});

/// `@visibleForTesting` — variant of [desktopAppearanceServiceProvider] that
/// constructs the service WITHOUT calling [DesktopAppearanceService.initialize].
/// Tests should override this provider so they can inject signals manually.
final desktopAppearanceServiceTestProvider = Provider<DesktopAppearanceService>(
  (ref) {
    final service = DesktopAppearanceService(ref);
    ref.onDispose(service.dispose);
    return service;
  },
);

/// Subscribes to the XDG `org.freedesktop.portal.Settings` portal and
/// publishes the user's preferred color scheme + accent color to Riverpod.
///
/// Safe to construct on any platform — non-Linux invocations are no-ops.
class DesktopAppearanceService {
  static const _tag = 'DesktopAppearance';
  final _log = LoggingService.instance;

  final Ref _ref;

  /// Optional override factory for tests — returns a connected client.
  /// In production we use `DBusClient.session()`.
  final DBusClient Function()? _clientFactory;

  DBusClient? _client;
  StreamSubscription<DBusSignal>? _signalSub;
  bool _disposed = false;

  DesktopAppearanceService(this._ref, {DBusClient Function()? clientFactory})
    : _clientFactory = clientFactory;

  /// Connects to the session bus, performs initial reads, and subscribes to
  /// `SettingChanged` signals. Errors are logged and swallowed — the providers
  /// simply stay `null`, signaling "no portal available; use MediaQuery".
  Future<void> initialize() async {
    if (_disposed) return;
    if (!Platform.isLinux) return;

    try {
      _client = (_clientFactory ?? DBusClient.session)();
    } catch (e) {
      _log.info(_tag, 'Session bus unavailable, skipping portal: $e');
      return;
    }

    // Initial read — both calls are best-effort: a missing key (e.g. accent
    // color on GNOME 46-) raises a D-Bus error that we treat as "no value".
    await _readColorScheme();
    await _readAccentColor();

    await _subscribeToChanges();
  }

  Future<void> _readColorScheme() async {
    final value = await _readSetting(_appearanceNamespace, _keyColorScheme);
    if (value == null) return;
    final brightness = _decodeColorScheme(value);
    if (brightness != _ref.read(desktopColorSchemeProvider)) {
      _ref.read(desktopColorSchemeProvider.notifier).state = brightness;
    }
  }

  Future<void> _readAccentColor() async {
    final value = await _readSetting(_appearanceNamespace, _keyAccentColor);
    if (value == null) return;
    final color = _decodeAccentColor(value);
    if (color != _ref.read(desktopAccentColorProvider)) {
      _ref.read(desktopAccentColorProvider.notifier).state = color;
    }
  }

  /// Calls `Settings.Read(namespace, key)` on the portal. The portal wraps the
  /// reply in a `v` (variant) — sometimes double-wrapped (`vv`) on older
  /// implementations — so we unwrap defensively.
  Future<DBusValue?> _readSetting(String namespace, String key) async {
    final client = _client;
    if (client == null) return null;
    try {
      final reply = await client.callMethod(
        destination: _portalDestination,
        path: DBusObjectPath(_portalObjectPath),
        interface: _portalSettingsInterface,
        name: 'Read',
        values: [DBusString(namespace), DBusString(key)],
      );
      if (reply.returnValues.isEmpty) return null;
      return _unwrapVariant(reply.returnValues.first);
    } on DBusMethodResponseException catch (e) {
      // "Requested setting not found" is normal for accent-color on GNOME 46-.
      _log.debug(_tag, 'Read $namespace.$key not available: ${e.errorName}');
      return null;
    } catch (e) {
      _log.warning(_tag, 'Read $namespace.$key failed: $e');
      return null;
    }
  }

  /// Subscribes to `SettingChanged(namespace, key, value)` and re-applies any
  /// matching change. We filter inside the handler so that one mis-matched
  /// rule (older portal versions don't always honor argument matching) won't
  /// cause us to miss updates.
  Future<void> _subscribeToChanges() async {
    final client = _client;
    if (client == null) return;
    try {
      final stream = DBusSignalStream(
        client,
        sender: _portalDestination,
        interface: _portalSettingsInterface,
        name: 'SettingChanged',
        path: DBusObjectPath(_portalObjectPath),
      );
      _signalSub = stream.listen(
        _onSettingChanged,
        onError: (Object e) =>
            _log.warning(_tag, 'SettingChanged stream error: $e'),
      );
    } catch (e) {
      _log.warning(_tag, 'Failed to subscribe to SettingChanged: $e');
    }
  }

  /// `@visibleForTesting` — feeds a synthetic signal through the same handler
  /// the live D-Bus subscription would use. Lets unit tests verify that a
  /// `SettingChanged` for `org.freedesktop.appearance.color-scheme` updates
  /// the corresponding Riverpod provider.
  void handleSignalForTest(DBusSignal signal) => _onSettingChanged(signal);

  void _onSettingChanged(DBusSignal signal) {
    if (_disposed) return;
    final values = signal.values;
    if (values.length < 3) return;
    final namespace = (values[0] is DBusString)
        ? (values[0] as DBusString).value
        : null;
    final key = (values[1] is DBusString)
        ? (values[1] as DBusString).value
        : null;
    if (namespace != _appearanceNamespace) return;

    final raw = _unwrapVariant(values[2]);
    if (raw == null) return;
    if (key == _keyColorScheme) {
      final brightness = _decodeColorScheme(raw);
      if (brightness != _ref.read(desktopColorSchemeProvider)) {
        _ref.read(desktopColorSchemeProvider.notifier).state = brightness;
      }
    } else if (key == _keyAccentColor) {
      final color = _decodeAccentColor(raw);
      if (color != _ref.read(desktopAccentColorProvider)) {
        _ref.read(desktopAccentColorProvider.notifier).state = color;
      }
    }
  }

  /// Decodes the `color-scheme` value (a `u`): 0 = no preference, 1 = prefer
  /// dark, 2 = prefer light. Anything else is treated as no-preference.
  ///
  /// `@visibleForTesting` — exposed so unit tests can verify decoding without
  /// having to spin up a real D-Bus server.
  static Brightness? decodeColorSchemeForTest(DBusValue value) =>
      _decodeColorScheme(value);

  /// `@visibleForTesting` companion for [decodeColorSchemeForTest].
  static Color? decodeAccentColorForTest(DBusValue value) =>
      _decodeAccentColor(value);

  /// `@visibleForTesting` — unwraps a `v` (variant), recursing through nested
  /// variants, the same way the live signal handler does.
  static DBusValue? unwrapVariantForTest(DBusValue value) =>
      _unwrapVariant(value);

  static Brightness? _decodeColorScheme(DBusValue value) {
    final raw = _asUint(value);
    if (raw == null) return null;
    return switch (raw) {
      1 => Brightness.dark,
      2 => Brightness.light,
      _ => null,
    };
  }

  /// Decodes the `accent-color` value: a `(ddd)` tuple of doubles in the
  /// `[0, 1]` range (RGB; alpha is implicit 1.0). GNOME 47+ may publish a
  /// 4-tuple `(dddd)` in the future — we accept both shapes.
  static Color? _decodeAccentColor(DBusValue value) {
    final tuple = _asStruct(value);
    if (tuple == null || tuple.length < 3) return null;
    final r = _asDouble(tuple[0]);
    final g = _asDouble(tuple[1]);
    final b = _asDouble(tuple[2]);
    if (r == null || g == null || b == null) return null;
    final a = tuple.length >= 4 ? (_asDouble(tuple[3]) ?? 1.0) : 1.0;
    // Per the spec, "no accent color" is signalled by negative values.
    if (r < 0 || g < 0 || b < 0) return null;
    return Color.fromARGB(
      (a.clamp(0.0, 1.0) * 255).round(),
      (r.clamp(0.0, 1.0) * 255).round(),
      (g.clamp(0.0, 1.0) * 255).round(),
      (b.clamp(0.0, 1.0) * 255).round(),
    );
  }

  /// Unwraps a `v` (variant) — recursing through nested variants.
  static DBusValue? _unwrapVariant(DBusValue value) {
    DBusValue current = value;
    var depth = 0;
    while (current is DBusVariant && depth < 4) {
      current = current.value;
      depth++;
    }
    return current;
  }

  static int? _asUint(DBusValue v) {
    if (v is DBusUint32) return v.value;
    if (v is DBusUint16) return v.value;
    if (v is DBusInt32) return v.value;
    return null;
  }

  static double? _asDouble(DBusValue v) {
    if (v is DBusDouble) return v.value;
    return null;
  }

  static List<DBusValue>? _asStruct(DBusValue v) {
    if (v is DBusStruct) return v.children.toList();
    if (v is DBusArray) return v.children.toList();
    return null;
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    try {
      await _signalSub?.cancel();
    } catch (_) {}
    _signalSub = null;
    try {
      await _client?.close();
    } catch (_) {}
    _client = null;
  }
}
