import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/core/services/logging_service.dart';

/// DNS-over-HTTPS resolver to prevent DNS spoofing and cache poisoning.
///
/// Resolves hostnames using configurable DoH endpoints via JSON API.
/// Results are cached in memory with TTL support.
class DohResolverService {
  static final _log = LoggingService.instance;
  static const _tag = 'DoH';

  final List<String> _urls;
  final Duration _cacheTtl;
  final HttpClient _httpClient;

  final Map<String, _CachedResult> _cache = {};

  DohResolverService({
    String? url,
    DohProvider provider = DohProvider.quad9,
    List<DohProvider>? providers,
    Duration cacheTtl = const Duration(minutes: 5),
    HttpClient? httpClient,
  }) : _urls = providers != null
           ? providers.map((p) => p.url).toList()
           : [url ?? provider.url],
       _cacheTtl = cacheTtl,
       _httpClient = httpClient ?? HttpClient()
         ..connectionTimeout = const Duration(seconds: 5);

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

    // Try each DoH provider in order until one succeeds
    Result<List<String>>? lastError;
    for (final baseUrl in _urls) {
      final result = await _resolveVia(baseUrl, hostname, type);
      if (result.isSuccess) return result;
      lastError = result;
    }

    return lastError!;
  }

  Future<Result<List<String>>> _resolveVia(
    String baseUrl,
    String hostname,
    DnsRecordType type,
  ) async {
    _log.debug(_tag, 'Resolving $hostname via $baseUrl (${type.name})');

    try {
      final uri = Uri.parse(
        '$baseUrl?name=${Uri.encodeComponent(hostname)}&type=${type.name}',
      );

      final request = await _httpClient
          .getUrl(uri)
          .timeout(const Duration(seconds: 5));
      request.headers.set('Accept', 'application/dns-json');

      final response = await request.close().timeout(
        const Duration(seconds: 5),
      );
      if (response.statusCode != 200) {
        _log.error(
          _tag,
          'DoH query failed for $hostname via $baseUrl: '
          'HTTP ${response.statusCode}',
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
          'DoH query for $hostname via $baseUrl returned status $status',
        );
        return Err(NetworkFailure('DNS query failed with RCODE $status'));
      }

      final answers = (json['Answer'] as List<dynamic>?) ?? [];
      final addresses = answers
          .where((a) => (a as Map<String, dynamic>)['type'] == type.value)
          .map((a) => (a as Map<String, dynamic>)['data'] as String)
          .where((addr) => InternetAddress.tryParse(addr) != null)
          .toList();

      if (addresses.isEmpty) {
        _log.warning(_tag, 'No ${type.name} records found for $hostname');
        return Err(NetworkFailure('No DNS records found for $hostname'));
      }

      // Cache result
      final cacheKey = '$hostname:${type.value}';
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
      _log.error(_tag, 'DoH connection failed for $hostname via $baseUrl: $e');
      return Err(NetworkFailure('DoH connection failed', cause: e));
    } on TimeoutException catch (e) {
      _log.error(_tag, 'DoH resolution timed out for $hostname via $baseUrl');
      return Err(NetworkFailure('DoH resolution timed out', cause: e));
    } catch (e) {
      _log.error(_tag, 'DoH resolution failed for $hostname via $baseUrl: $e');
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
        DohResolverService(provider: DohProvider.quad9, httpClient: httpClient),
        DohResolverService(
          provider: DohProvider.cloudflare,
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

    // Compare all successful results — return only the intersection
    var consensus = successResults.first;
    for (var i = 1; i < successResults.length; i++) {
      final intersection = consensus.intersection(successResults[i]);
      if (intersection.isEmpty) {
        _log.error(
          _tag,
          'DNS divergence detected for $hostname: '
          'no common IPs across resolvers',
        );
        return Err(
          DnsDivergence(
            hostname: hostname,
            resolverAIPs: successResults.first.toList(),
            resolverBIPs: successResults[i].toList(),
          ),
        );
      }
      consensus = intersection;
    }

    _log.info(
      _tag,
      'Cross-check passed for $hostname across ${successResults.length} resolvers '
      '(${consensus.length} consensus IP(s))',
    );
    return Success(consensus.toList());
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
///
/// Defaults are privacy-friendly European/non-profit providers:
/// - Quad9: Swiss non-profit, no logging, GDPR-compliant
/// - Mullvad: Swedish privacy company, no logging, GDPR-compliant
enum DohProvider {
  quad9('https://dns.quad9.net/dns-query'),
  cloudflare('https://cloudflare-dns.com/dns-query');

  final String url;

  const DohProvider(this.url);
}

class _CachedResult {
  final List<String> addresses;
  final DateTime expiresAt;

  _CachedResult({required this.addresses, required this.expiresAt});

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
