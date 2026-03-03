import 'dart:convert';
import 'dart:io';

import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/services/logging_service.dart';

/// DNS-over-HTTPS resolver to prevent DNS spoofing and cache poisoning.
///
/// Resolves hostnames using configurable DoH endpoints via JSON API.
/// Results are cached in memory with TTL support.
class DohResolverService {
  static final _log = LoggingService.instance;
  static const _tag = 'DoH';

  final String _baseUrl;
  final Duration _cacheTtl;
  final HttpClient _httpClient;

  final Map<String, _CachedResult> _cache = {};

  DohResolverService({
    String? url,
    DohProvider provider = DohProvider.cloudflare,
    Duration cacheTtl = const Duration(minutes: 5),
    HttpClient? httpClient,
  }) : _baseUrl = url ?? provider.url,
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

    _log.debug(_tag, 'Resolving $hostname via $_baseUrl (${type.name})');

    try {
      final uri = Uri.parse('$_baseUrl?name=$hostname&type=${type.name}');

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
        return Err(NetworkFailure('DNS query failed with RCODE $status'));
      }

      final answers = (json['Answer'] as List<dynamic>?) ?? [];
      final addresses = answers
          .where((a) => (a as Map<String, dynamic>)['type'] == type.value)
          .map((a) => (a as Map<String, dynamic>)['data'] as String)
          .toList();

      if (addresses.isEmpty) {
        _log.warning(_tag, 'No ${type.name} records found for $hostname');
        return Err(NetworkFailure('No DNS records found for $hostname'));
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
      return Err(NetworkFailure('DoH connection failed', cause: e));
    } catch (e) {
      _log.error(_tag, 'DoH resolution failed for $hostname: $e');
      return Err(NetworkFailure('DNS resolution failed', cause: e));
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

  /// Cross-check DNS resolution across multiple providers.
  ///
  /// Queries providers in parallel and compares results.
  /// Returns the resolved addresses if they agree, or a [DnsDivergence]
  /// failure if the IP sets differ (possible DNS spoofing).
  ///
  /// If [dnsServerUrls] is provided and has at least 2 entries,
  /// those URLs are used instead of the built-in Cloudflare and Google
  /// defaults. This allows users to configure custom DoH servers.
  static Future<Result<List<String>>> crossCheck(
    String hostname, {
    DnsRecordType type = DnsRecordType.a,
    HttpClient? httpClient,
    List<String> dnsServerUrls = const [],
  }) async {
    final List<DohResolverService> resolvers;

    if (dnsServerUrls.length >= 2) {
      resolvers = dnsServerUrls
          .map((url) => DohResolverService(url: url, httpClient: httpClient))
          .toList();
    } else {
      resolvers = [
        DohResolverService(
          provider: DohProvider.cloudflare,
          httpClient: httpClient,
        ),
        DohResolverService(
          provider: DohProvider.google,
          httpClient: httpClient,
        ),
      ];
    }

    final results = await Future.wait(
      resolvers.map((r) => r.resolve(hostname, type: type)),
    );

    // Collect successful results
    final successResults = <Set<String>>[];
    Result<List<String>>? firstError;
    for (final r in results) {
      if (r is Success<List<String>>) {
        successResults.add(r.value.toSet());
      } else {
        firstError ??= r;
      }
    }

    // If all fail, return the first error
    if (successResults.isEmpty) {
      _log.error(_tag, 'All DoH resolvers failed for $hostname');
      return firstError!;
    }

    // If only one succeeded, return it with a warning
    if (successResults.length == 1) {
      _log.warning(
        _tag,
        'Only 1 of ${resolvers.length} DoH resolvers succeeded for $hostname',
      );
      return Success(successResults.first.toList());
    }

    // Compare all successful results — check pairwise overlap
    final first = successResults.first;
    for (var i = 1; i < successResults.length; i++) {
      final intersection = first.intersection(successResults[i]);
      if (intersection.isEmpty) {
        _log.error(
          _tag,
          'DNS divergence detected for $hostname: '
          'resolver[0]=$first, resolver[$i]=${successResults[i]}',
        );
        return Err(
          DnsDivergence(
            hostname: hostname,
            cloudflareIPs: first.toList(),
            googleIPs: successResults[i].toList(),
          ),
        );
      }
    }

    _log.info(
      _tag,
      'Cross-check passed for $hostname across ${successResults.length} resolvers',
    );
    return Success(first.toList());
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
