import 'dart:async';

import 'package:shellvault/core/network/api_client.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/services/logging_service.dart';

/// Periodically verifies server availability and identity via heartbeat.
///
/// Sends a signed heartbeat request every [interval] (default 60s).
/// If [maxFailures] consecutive heartbeats fail, invokes [onSessionExpired].
class HeartbeatService {
  static final _log = LoggingService.instance;
  static const _tag = 'Heartbeat';

  final ApiClient _apiClient;
  final Duration interval;
  final int maxFailures;
  final void Function()? onSessionExpired;

  Timer? _timer;
  int _consecutiveFailures = 0;
  bool _running = false;

  HeartbeatService({
    required ApiClient apiClient,
    this.interval = const Duration(seconds: 60),
    this.maxFailures = 3,
    this.onSessionExpired,
  }) : _apiClient = apiClient;

  /// Start periodic heartbeat checks with jitter to avoid thundering herd.
  void start() {
    if (_running) return;
    _running = true;
    _consecutiveFailures = 0;
    _log.info(_tag, 'Heartbeat started (interval: ${interval.inSeconds}s)');
    _scheduleNextBeat();
  }

  void _scheduleNextBeat() {
    if (!_running) return;
    // Add +/- 15% jitter to prevent synchronized heartbeats
    final jitterMs = (interval.inMilliseconds * 0.15).round();
    final rng = DateTime.now().microsecond;
    final offset = (rng % (jitterMs * 2 + 1)) - jitterMs;
    final nextInterval = Duration(
      milliseconds: interval.inMilliseconds + offset,
    );
    _timer = Timer(nextInterval, () async {
      await _beat();
      _scheduleNextBeat();
    });
  }

  /// Stop periodic heartbeat checks.
  void stop() {
    _timer?.cancel();
    _timer = null;
    _running = false;
    _consecutiveFailures = 0;
    _log.info(_tag, 'Heartbeat stopped');
  }

  /// Whether the heartbeat service is currently running.
  bool get isRunning => _running;

  /// Number of consecutive failures since last successful heartbeat.
  int get consecutiveFailures => _consecutiveFailures;

  Future<void> _beat() async {
    try {
      final result = await _apiClient.get('/health');
      if (result is Success) {
        if (_consecutiveFailures > 0) {
          _log.info(
            _tag,
            'Heartbeat recovered after $_consecutiveFailures failure(s)',
          );
        }
        _consecutiveFailures = 0;
      } else {
        _onFailure('Server returned error');
      }
    } catch (e) {
      _onFailure('$e');
    }
  }

  void _onFailure(String reason) {
    _consecutiveFailures++;
    _log.warning(
      _tag,
      'Heartbeat failed ($_consecutiveFailures/$maxFailures): $reason',
    );

    if (_consecutiveFailures >= maxFailures) {
      _log.error(_tag, 'Max heartbeat failures reached, terminating session');
      stop();
      onSessionExpired?.call();
    }
  }
}
