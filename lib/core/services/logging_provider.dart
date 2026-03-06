import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/services/logging_service.dart';

/// Provides the singleton [LoggingService] instance via Riverpod.
final loggingServiceProvider = Provider<LoggingService>((ref) {
  return LoggingService.instance;
});
