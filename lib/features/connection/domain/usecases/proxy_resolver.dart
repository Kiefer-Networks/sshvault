import 'package:sshvault/features/connection/domain/entities/proxy_config.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';

class ProxyResolver {
  /// Resolves the effective proxy for a server.
  /// Priority: Server-specific proxy > Global proxy > none
  ProxyConfig? resolve(ServerEntity server, ProxyConfig? globalProxy) {
    if (server.proxyType != ProxyType.none) {
      return ProxyConfig(
        type: server.proxyType,
        host: server.proxyHost,
        port: server.proxyPort,
        username: server.proxyUsername,
      );
    }
    if (server.useGlobalProxy &&
        globalProxy != null &&
        globalProxy.type != ProxyType.none) {
      return globalProxy;
    }
    return null;
  }
}
