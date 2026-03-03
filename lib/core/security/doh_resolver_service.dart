import 'dart:convert';
import 'dart:io';

import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/services/logging_service.dart';

/// DNS-over-HTTPS resolver to prevent DNS spoofing and cache poisoning.
///
/// Resolves hostnames using Cloudflare or Google DoH endpoints via JSON API.
/// Results are cached in memory with TTL support.
class DohResolverService {
  static final _log = LoggingService.instance;
  static const _tag = 'DoH';

  final DohProvider _provider;
  final Duration _cacheTtl;
  final HttpClient _httpClient;

  final Map<String, _CachedResult> _cache = {};

  DohResolverService({
    DohProvider provider = DohProvider.cloudflare,
    Duration cacheTtl = const Duration(minutes: 5),
    HttpClient? httpClient,
  })  : _provider = provider,
        _cacheTtl = cacheTtl,
        _httpClient = httpClient ?? HttpClient();

  /// Resolve a hostname to a list of IP addresses using DNS-over-HTTPS.
  ///
  /// Returns cached results if available and not expired.
  Future<Result<List<String>>> resolve(
    String hostname, {
    DnsRecordType type = DnsRecordType.a,
  }) async {
    final cacheKey = '$hostname:${type.value}';

    // Check cache
    final cached = _cache[cacheKey];
    if (cached != null && !cached.isExpired) {
      _log.debug(_tag, 'Cache hit for $hostname (${type.name})');
      return Success(cached.addresses);
    }

    _log.debug(
      _tag,
      'Resolving $hostname via ${_provider.name} (${type.name})',
    );

    try {
      final uri = Uri.parse(
        '${_provider.url}?name=$hostname&type=${type.name}',
      );

      final request = await _httpClient.getUrl(uri);
      request.headers.set('Accept', 'application/dns-json');

      final response = await request.close();
      if (response.statusCode != 200) {
        _log.error(
          _tag,
          'DoH query failed for $hostname: HTTP ${response.statusCode}',
        );
        return Err(
          NetworkFailure(
            'DNS-over-HTTPS query failed',
            statusCode: response.statusCode,
          ),
        );
      }

      final body = await response.transform(utf8.decoder).join();
      final json = jsonDecode(body) as Map<String, dynamic>;

      final status = json['Status'] as int? ?? -1;
      if (status != 0) {
        _log.warning(
          _tag,
          'DoH query for $hostname returned status $status (RCODE)',
        );
        return Err(
          NetworkFailure('DNS query failed with RCODE $status'),
        );
      }

      final answers = (json['Answer'] as List<dynamic>?) ?? [];
      final addresses = answers
          .where((a) => (a as Map<String, dynamic>)['type'] == type.value)
          .map((a) => (a as Map<String, dynamic>)['data'] as String)
          .toList();

      if (addresses.isEmpty) {
        _log.warning(_tag, 'No ${type.name} records found for $hostname');
        return Err(
          NetworkFailure('No DNS records found for $hostname'),
        );
      }

      // Cache result
      _cache[cacheKey] = _CachedResult(
        addresses: addresses,
        expiresAt: DateTime.now().add(_cacheTtl),
      );

      _log.info(
        _tag,
        'Resolved $hostname → ${addresses.length} ${type.name} record(s)',
      );
      return Success(addresses);
    } on SocketException catch (e) {
      _log.error(_tag, 'DoH connection failed for $hostname: $e');
      return Err(
        NetworkFailure('DoH connection failed', cause: e),
      );
    } catch (e) {
      _log.error(_tag, 'DoH resolution failed for $hostname: $e');
      return Err(
        NetworkFailure('DNS resolution failed', cause: e),
      );
    }
  }

  /// Resolve hostname and return the first IP address.
  Future<Result<String>> resolveFirst(
    String hostname, {
    DnsRecordType type = DnsRecordType.a,
  }) async {
    final result = await resolve(hostname, type: type);
    return result.map((addresses) => addresses.first);
  }

  /// Clear all cached DNS results.
  void clearCache() {
    _cache.clear();
    _log.debug(_tag, 'DoH cache cleared');
  }

  /// Remove expired entries from the cache.
  void pruneCache() {
    _cache.removeWhere((_, v) => v.isExpired);
  }

  /// Number of cached entries.
  int get cacheSize => _cache.length;

  /// Close the underlying HTTP client.
  void close() {
    _httpClient.close();
  }
}

/// DNS record types supported by the DoH resolver.
enum DnsRecordType {
  a(1, 'A'),
  aaaa(28, 'AAAA');

  final int value;
  final String name;

  const DnsRecordType(this.value, this.name);
}

/// DoH provider endpoints.
enum DohProvider {
  cloudflare('https://cloudflare-dns.com/dns-query'),
  google('https://dns.google/resolve');

  final String url;

  const DohProvider(this.url);
}

class _CachedResult {
  final List<String> addresses;
  final DateTime expiresAt;

  _CachedResult({required this.addresses, required this.expiresAt});

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
