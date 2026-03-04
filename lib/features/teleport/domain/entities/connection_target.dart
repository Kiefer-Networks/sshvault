import 'package:shellvault/features/connection/domain/entities/server_entity.dart';
import 'package:shellvault/features/teleport/domain/entities/teleport_node_entity.dart';

/// Unified abstraction for anything the user can connect to.
///
/// Used in the server list / node list to display both manually configured SSH
/// servers and dynamically discovered Teleport nodes in a single view.
sealed class ConnectionTarget {
  String get displayName;
  String get hostname;
  int get port;
}

/// A manually configured SSH server from the local database.
class LocalServer extends ConnectionTarget {
  final ServerEntity server;

  LocalServer(this.server);

  @override
  String get displayName => server.name;

  @override
  String get hostname => server.hostname;

  @override
  int get port => server.port;
}

/// A Teleport node discovered from a Teleport cluster.
class TeleportNode extends ConnectionTarget {
  final TeleportNodeEntity node;

  TeleportNode(this.node);

  @override
  String get displayName => node.hostname;

  @override
  String get hostname => node.addr.contains(':') ? node.addr.split(':').first : node.addr;

  @override
  int get port => 0; // Teleport nodes connect via the proxy, not directly.
}
