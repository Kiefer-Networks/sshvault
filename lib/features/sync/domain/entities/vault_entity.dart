class VaultEntity {
  final int version;
  final String? blob;
  final String? checksum;
  final DateTime? updatedAt;

  const VaultEntity({
    required this.version,
    this.blob,
    this.checksum,
    this.updatedAt,
  });

  factory VaultEntity.fromJson(Map<String, dynamic> json) {
    DateTime? updatedAt;
    // History entries use created_at for the time this vault version was saved.
    final raw = json['updated_at'] ?? json['created_at'];
    if (raw is int) {
      updatedAt = DateTime.fromMillisecondsSinceEpoch(raw * 1000, isUtc: true);
    } else if (raw is String) {
      updatedAt = DateTime.parse(raw);
    }

    return VaultEntity(
      version: json['version'] as int? ?? 0,
      blob: json['blob'] as String?,
      checksum: json['checksum'] as String?,
      updatedAt: updatedAt,
    );
  }
}
