// HiDPI / per-monitor scale-factor bridge.
//
// The C++ side (`linux/runner/my_application.cc`) listens for GDK monitor
// scale-factor changes (e.g. dragging the window between a 1x external
// monitor and a 2x laptop panel) and forwards a single method call on the
// `de.kiefer_networks.sshvault/window` MethodChannel:
//
//   - `monitorScaleChanged(double scale)` — the new effective scale factor
//     for the monitor the toplevel window is currently on.
//
// This service receives those events and:
//
//   1. Updates [currentMonitorScaleProvider] so widgets that care about the
//      raw GTK scale (terminal renderer, host-card status pill) can react.
//   2. Calls `WidgetsBinding.instance.handleMetricsChanged()` which is the
//      official Flutter mechanism for forcing a relayout when window /
//      pixel-ratio metrics change. (The original spec referred to a
//      `dispatchAllLifecycleStateChange` API; that name does not exist in
//      stable Flutter — `handleMetricsChanged` is the supported equivalent.)
//
// On non-Linux platforms `init()` is a no-op so the rest of the app does
// not need to platform-gate consumers.

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';

/// The current GTK monitor scale factor reported by the C++ runner. Defaults
/// to `1.0` (i.e. no scaling) until the first event arrives. Consumers should
/// treat this as advisory — `MediaQuery.of(context).devicePixelRatio` remains
/// the source of truth for layout math; this provider only exists so widgets
/// can react instantly to a scale change without waiting for a full
/// rebuild-from-MediaQuery cycle.
final currentMonitorScaleProvider = StateProvider<double>((_) => 1.0);

/// User-overridable pixel ratio. `null` means "auto" — fall back to the
/// platform-provided device pixel ratio. Non-null forces the given value
/// regardless of what the OS reports. Used as an escape hatch for users on
/// misconfigured systems (Wayland fractional scaling glitches, NVIDIA
/// proprietary driver under X11, etc.).
///
/// Persisted via the settings provider; this Riverpod provider is just the
/// in-memory cache the widget tree reads from.
final forcedPixelRatioProvider = StateProvider<double?>((_) => null);

/// Singleton bridge between the C++ HiDPI layer and Flutter.
class HiDpiService {
  HiDpiService._();
  static final HiDpiService instance = HiDpiService._();

  static const _tag = 'HiDpi';
  static const _channel = MethodChannel('de.kiefer_networks.sshvault/window');

  ProviderContainer? _container;
  bool _initialized = false;
  ProviderSubscription<dynamic>? _settingsSub;

  /// Test hook: when set, [_dispatchMetrics] forwards here instead of
  /// touching `WidgetsBinding.instance` (which requires the binding to be
  /// initialized). Production code leaves this null.
  @visibleForTesting
  void Function()? onMetricsChangedForTest;

  /// Wires the bridge into the running app.
  ///
  /// [mirrorForcedPixelRatio] (default `true`) controls whether the service
  /// also listens on `settingsProvider` to keep [forcedPixelRatioProvider]
  /// in sync with the persisted user override. Tests pass `false` so they
  /// can exercise the method-channel path without booting the database
  /// stack the settings provider depends on.
  void init({
    ProviderContainer? container,
    bool mirrorForcedPixelRatio = true,
  }) {
    if (_initialized) return;
    if (!kIsWeb && !Platform.isLinux) return;
    _container = container;
    _channel.setMethodCallHandler(_handleCall);
    _initialized = true;
    LoggingService.instance.info(_tag, 'HiDPI scale bridge ready');

    // Mirror the persisted "Force pixel ratio" setting into the in-memory
    // [forcedPixelRatioProvider] so widgets pick it up before the user
    // opens the settings screen. We listen rather than read-once because
    // `settingsProvider` is an AsyncNotifier and may resolve after this.
    if (container != null && mirrorForcedPixelRatio) {
      _settingsSub = container.listen<dynamic>(settingsProvider, (
        previous,
        next,
      ) {
        try {
          final value = next?.value;
          if (value == null) return;
          final ratio = value.forcedPixelRatio as double;
          container.read(forcedPixelRatioProvider.notifier).state = ratio == 0
              ? null
              : ratio;
        } catch (e) {
          LoggingService.instance.warning(
            _tag,
            'forcedPixelRatio mirror failed: $e',
          );
        }
      }, fireImmediately: true);
    }
  }

  /// Test-only reset.
  @visibleForTesting
  void resetForTest() {
    if (_initialized) {
      _channel.setMethodCallHandler(null);
    }
    _settingsSub?.close();
    _settingsSub = null;
    _initialized = false;
    _container = null;
    onMetricsChangedForTest = null;
  }

  /// Public for tests so a fake MethodCall can be injected without going
  /// through the platform channel binary messenger.
  @visibleForTesting
  Future<dynamic> handleCallForTest(MethodCall call) => _handleCall(call);

  Future<dynamic> _handleCall(MethodCall call) async {
    switch (call.method) {
      case 'monitorScaleChanged':
        final args = call.arguments;
        double? scale;
        if (args is double) {
          scale = args;
        } else if (args is num) {
          scale = args.toDouble();
        }
        if (scale == null || scale <= 0) {
          LoggingService.instance.warning(
            _tag,
            'monitorScaleChanged ignored, bad arg: $args',
          );
          return null;
        }
        _setScale(scale);
        _dispatchMetrics();
        return null;
      default:
        return null;
    }
  }

  void _setScale(double scale) {
    final container = _container;
    if (container == null) return;
    try {
      final notifier = container.read(currentMonitorScaleProvider.notifier);
      if (notifier.state != scale) {
        notifier.state = scale;
        LoggingService.instance.info(_tag, 'monitor scale -> $scale');
      }
    } catch (e) {
      LoggingService.instance.warning(_tag, 'scale provider update failed: $e');
    }
  }

  void _dispatchMetrics() {
    final hook = onMetricsChangedForTest;
    if (hook != null) {
      hook();
      return;
    }
    // `handleMetricsChanged` walks the registered observers (RendererBinding,
    // WidgetsBinding) and triggers a layout/paint pass that re-reads the
    // device pixel ratio from the platform. This is the canonical hook for
    // pixel-ratio-aware re-rasterization.
    try {
      WidgetsBinding.instance.handleMetricsChanged();
    } catch (e) {
      LoggingService.instance.warning(_tag, 'handleMetricsChanged failed: $e');
    }
  }
}

/// Helper that returns the effective device pixel ratio for the given
/// [context], honoring a user-configured override when set.
///
/// Prefer this over reading `MediaQuery.of(context).devicePixelRatio`
/// directly when adjusting cosmetic sizes (terminal font, status pills) so
/// the user's "Force pixel ratio" override takes effect everywhere.
double effectiveDevicePixelRatio(BuildContext context, WidgetRef ref) {
  final forced = ref.watch(forcedPixelRatioProvider);
  if (forced != null && forced > 0) return forced;
  return MediaQuery.of(context).devicePixelRatio;
}
