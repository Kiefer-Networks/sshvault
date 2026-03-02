/// Supported SSH key types mirroring ssh-keygen options.
enum SshKeyType {
  rsa('RSA', 'ssh-rsa'),
  ecdsa256('ECDSA (nistp256)', 'ecdsa-sha2-nistp256'),
  ecdsa384('ECDSA (nistp384)', 'ecdsa-sha2-nistp384'),
  ecdsa521('ECDSA (nistp521)', 'ecdsa-sha2-nistp521'),
  ed25519('Ed25519', 'ssh-ed25519');

  final String displayName;
  final String sshName;

  const SshKeyType(this.displayName, this.sshName);

  /// Valid bit lengths for this key type (empty = fixed size).
  List<int> get allowedBitLengths => switch (this) {
    SshKeyType.rsa => [2048, 3072, 4096],
    _ => [],
  };

  /// Default bit length (0 = fixed size).
  int get defaultBitLength => switch (this) {
    SshKeyType.rsa => 4096,
    _ => 0,
  };

  /// Human-readable key size description.
  String get keySizeLabel => switch (this) {
    SshKeyType.rsa => 'Variable (2048–4096 bit)',
    SshKeyType.ecdsa256 => '256 bit (fixed)',
    SshKeyType.ecdsa384 => '384 bit (fixed)',
    SshKeyType.ecdsa521 => '521 bit (fixed)',
    SshKeyType.ed25519 => '256 bit (fixed)',
  };

  /// OpenSSH curve identifier (only for ECDSA).
  String? get curveName => switch (this) {
    SshKeyType.ecdsa256 => 'nistp256',
    SshKeyType.ecdsa384 => 'nistp384',
    SshKeyType.ecdsa521 => 'nistp521',
    _ => null,
  };
}

/// Options for SSH key generation.
class SshKeyOptions {
  final SshKeyType type;
  final int bits;
  final String comment;

  const SshKeyOptions({
    this.type = SshKeyType.ed25519,
    this.bits = 0,
    this.comment = 'shellvault-generated',
  });

  /// Effective bit length (uses type default when 0).
  int get effectiveBits => bits > 0 ? bits : type.defaultBitLength;
}
