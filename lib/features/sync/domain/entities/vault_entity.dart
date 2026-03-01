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
    return VaultEntity(
      version: json['version'] as int? ?? 0,
      blob: json['blob'] as String?,
      checksum: json['checksum'] as String?,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}
