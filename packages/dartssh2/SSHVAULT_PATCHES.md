# SSHVault compatibility layer on dartssh2 4.1.0

Source baseline: the published dartssh2 4.1.0 package from pub.dev, maintained
at https://github.com/vicajilau/dartssh2. Its LICENSE, README and CHANGELOG are
retained verbatim. Upstream transport, key exchange, channel, SFTP, and private
key implementations and their tests are used directly.

Local additions:

- HTTP CONNECT and SOCKS5 socket adapters, with `flush()` for the current
  SSHSocket contract. HTTP CONNECT retains a single socket subscription and
  preserves SSH bytes received together with the proxy response. SOCKS5 resolves
  proxy DNS hostnames before opening the connection.
- Teleport TLS/ALPN socket and certificate identity adapters. Certificate
  identities inherit current SSHKeyPair defaults.
- SSHAgentKeyPair compatibility adapter, backed by upstream SSHIdentity and
  public-key probing. No private key is exported from the agent.
- The old `src/ssh_forward.dart` import forwards to the upstream module.
- Public exports for those adapters, plus the socks5_proxy dependency.

The application normalizes upstream OpenSSH fingerprint text to the previous
raw SHA-256 digest before comparing stored host pins, and explicitly keeps a
SHA-2-only MAC proposal. Optional bespoke PQ code is archived in `legacy-pq/`;
it is not part of active negotiation. See the application audit for validation.
