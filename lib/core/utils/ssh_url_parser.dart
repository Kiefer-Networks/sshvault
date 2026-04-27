/// Parses `ssh://` and `sftp://` URLs as accepted by browsers, mail clients,
/// and PDF viewers when invoking the system URL handler.
///
/// The grammar accepted is a strict subset of RFC 3986:
///
///   scheme  := "ssh" | "sftp"
///   url     := scheme "://" [ user "@" ] host [ ":" port ] [ "/" path ]
///   host    := DNS name | IPv4 | "[" IPv6 "]"
///   port    := 1..65535
///
/// `parse` returns `null` for any input that does not match. It never throws.
class SshUrl {
  /// Always one of `ssh` or `sftp` (lower-cased).
  final String scheme;

  /// The user portion of the authority, or `null` if absent.
  final String? username;

  /// The hostname. For IPv6 literals the surrounding `[` `]` are stripped, so
  /// callers can plug it straight into a socket API.
  final String hostname;

  /// The TCP port. Defaults to 22 when the input had none.
  final int port;

  /// Optional path component (everything after the host[:port]/, leading
  /// slash stripped). `null` if the URL had no path.
  final String? path;

  const SshUrl({
    required this.scheme,
    required this.hostname,
    required this.port,
    this.username,
    this.path,
  });

  /// Whether the URL was an `sftp://` URL.
  bool get isSftp => scheme == 'sftp';

  // ── Internal regexes ────────────────────────────────────────────
  // Hostnames per RFC 1123: labels of letters/digits/hyphens, separated
  // by dots, total <= 253 chars. Single-label hostnames are allowed
  // (e.g. "myrouter") because URL handlers commonly receive them.
  static final _hostnameRegex = RegExp(
    r'^(?=.{1,253}$)([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)'
    r'(\.[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)*$',
  );

  static final _ipv4Regex = RegExp(
    r'^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$',
  );

  // Loose IPv6 — Dart's Uri parser already filtered the structural shape,
  // we only need to confirm it looks like an address (no spaces, only
  // hex digits / colons / IPv4-tail dots).
  static final _ipv6BodyRegex = RegExp(
    r'^[0-9a-fA-F:]+(\.\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})?$',
  );

  /// Accepts `ssh://...` or `sftp://...`. Returns `null` for anything else
  /// or for a URL whose components fail validation.
  static SshUrl? parse(String input) {
    if (input.isEmpty) return null;
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;

    final Uri uri;
    try {
      uri = Uri.parse(trimmed);
    } catch (_) {
      return null;
    }

    final scheme = uri.scheme.toLowerCase();
    if (scheme != 'ssh' && scheme != 'sftp') return null;

    final rawHost = uri.host;
    if (rawHost.isEmpty) return null;

    // Uri.host returns IPv6 literals already stripped of `[` `]`.
    // Distinguish IPv6 from DNS / IPv4 by the colon.
    final isIpv6 = rawHost.contains(':');
    if (isIpv6) {
      if (!_ipv6BodyRegex.hasMatch(rawHost)) return null;
      // Need at least one hex digit somewhere — `::` alone is not useful.
      if (!RegExp(r'[0-9a-fA-F]').hasMatch(rawHost)) return null;
    } else if (_ipv4Regex.hasMatch(rawHost)) {
      final parts = rawHost.split('.').map(int.parse);
      if (!parts.every((p) => p >= 0 && p <= 255)) return null;
    } else if (!_hostnameRegex.hasMatch(rawHost)) {
      return null;
    }

    // Port: Uri.parse returns 0 when none was given.
    int port;
    if (uri.hasPort) {
      port = uri.port;
      if (port < 1 || port > 65535) return null;
    } else {
      port = 22;
    }

    String? username;
    if (uri.userInfo.isNotEmpty) {
      // Drop any `:password` half — we do not accept passwords in URLs.
      final colon = uri.userInfo.indexOf(':');
      final user = colon < 0 ? uri.userInfo : uri.userInfo.substring(0, colon);
      if (user.isEmpty) return null;
      username = Uri.decodeComponent(user);
    }

    String? path;
    if (uri.path.isNotEmpty && uri.path != '/') {
      // Strip the single leading slash; preserve everything after.
      path = uri.path.startsWith('/') ? uri.path.substring(1) : uri.path;
      if (path.isEmpty) path = null;
    }

    return SshUrl(
      scheme: scheme,
      username: username,
      hostname: rawHost,
      port: port,
      path: path,
    );
  }

  @override
  String toString() =>
      'SshUrl(scheme: $scheme, username: $username, '
      'hostname: $hostname, port: $port, path: $path)';
}
