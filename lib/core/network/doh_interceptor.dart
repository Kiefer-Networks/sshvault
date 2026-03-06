import 'package:dio/dio.dart';
import 'package:sshvault/core/security/doh_resolver_service.dart';
import 'package:sshvault/core/services/logging_service.dart';

/// Dio interceptor that resolves request hostnames via DNS-over-HTTPS
/// before sending the request, replacing the URL with the resolved IP
/// and setting the Host header to preserve TLS SNI validation.
///
/// Falls back to standard DNS resolution if DoH fails, to avoid
/// blocking the entire app when DoH providers are unreachable.
class DohInterceptor extends Interceptor {
  static final _log = LoggingService.instance;
  static const _tag = 'DoH';

  final DohResolverService _resolver;

  /// Cached hostname-to-IP mappings to avoid resolving on every request.
  final Map<String, String> _resolvedHosts = {};

  DohInterceptor(this._resolver);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final uri = options.uri;
      final hostname = uri.host;

      // Skip DoH for IP addresses (already resolved)
      if (_isIpAddress(hostname)) {
        return handler.next(options);
      }

      // Check in-memory cache first
      var resolvedIp = _resolvedHosts[hostname];
      if (resolvedIp == null) {
        final result = await _resolver.resolveFirst(hostname);
        if (result.isSuccess) {
          resolvedIp = result.value;
          _resolvedHosts[hostname] = resolvedIp;
          _log.debug(_tag, 'Resolved $hostname via DoH (cached for session)');
        } else {
          _log.warning(
            _tag,
            'DoH resolution failed for $hostname — falling back to OS DNS',
          );
          return handler.next(options);
        }
      }

      // Replace hostname with resolved IP, preserve the Host header
      final resolvedUri = uri.replace(host: resolvedIp);
      options.path = resolvedUri.toString();
      options.baseUrl = '';
      options.headers['Host'] = hostname;

      _log.debug(_tag, 'Request to $hostname routed via DoH-resolved IP');
    } catch (e) {
      _log.warning(_tag, 'DoH interceptor error — falling back to OS DNS: $e');
    }
    handler.next(options);
  }

  /// Clear cached DNS resolutions. Call when network changes.
  void clearCache() {
    _resolvedHosts.clear();
    _resolver.clearCache();
  }

  static bool _isIpAddress(String host) {
    // Simple check for IPv4
    final parts = host.split('.');
    if (parts.length == 4) {
      return parts.every((p) => int.tryParse(p) != null);
    }
    // IPv6 check
    return host.contains(':');
  }
}
