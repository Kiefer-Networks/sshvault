import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';

/// Checks TCP reachability of a server by attempting a socket connection.
final serverReachabilityProvider = FutureProvider.autoDispose
    .family<bool, ServerEntity>((ref, server) async {
      try {
        final socket = await Socket.connect(
          server.hostname,
          server.port,
          timeout: const Duration(seconds: 3),
        );
        socket.destroy();
        return true;
      } on SocketException {
        return false;
      } on OSError {
        return false;
      }
    });
