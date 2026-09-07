import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';

enum ServerReachability {
  /// DNS, routing or timeout failure: the host could not be reached.
  unreachable,

  /// The host answered with connection refused: the port is closed.
  portClosed,

  /// A TCP connection to the configured port succeeded.
  portOpen,
}

/// Checks TCP reachability and distinguishes an unreachable host from a
/// reachable host whose configured port is closed.
final serverReachabilityProvider = FutureProvider.autoDispose
    .family<ServerReachability, ServerEntity>((ref, server) async {
      try {
        final socket = await Socket.connect(
          server.hostname,
          server.port,
          timeout: const Duration(seconds: 3),
        );
        socket.destroy();
        return ServerReachability.portOpen;
      } on SocketException catch (error) {
        // ECONNREFUSED means DNS/routing worked and the host actively
        // rejected the port. Other errors (timeout, unreachable network,
        // failed name resolution) mean the host itself is unavailable.
        final code = error.osError?.errorCode;
        if (code == 61 || code == 111 || code == 10061) {
          return ServerReachability.portClosed;
        }
        return ServerReachability.unreachable;
      } on OSError {
        return ServerReachability.unreachable;
      }
    });
