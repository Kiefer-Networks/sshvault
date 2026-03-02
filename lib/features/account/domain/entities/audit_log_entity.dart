class AuditLogEntity {
  final String id;
  final DateTime timestamp;
  final String level;
  final String category;
  final String action;
  final String actorEmail;
  final String resourceType;
  final String resourceId;
  final String ipAddress;
  final String requestId;
  final Map<String, dynamic> details;
  final int? durationMs;

  const AuditLogEntity({
    required this.id,
    required this.timestamp,
    required this.level,
    required this.category,
    required this.action,
    this.actorEmail = '',
    this.resourceType = '',
    this.resourceId = '',
    this.ipAddress = '',
    this.requestId = '',
    this.details = const {},
    this.durationMs,
  });

  factory AuditLogEntity.fromJson(Map<String, dynamic> json) {
    return AuditLogEntity(
      id: json['id'] as String? ?? '',
      timestamp:
          DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      level: json['level'] as String? ?? 'info',
      category: json['category'] as String? ?? '',
      action: json['action'] as String? ?? '',
      actorEmail: json['actor_email'] as String? ?? '',
      resourceType: json['resource_type'] as String? ?? '',
      resourceId: json['resource_id'] as String? ?? '',
      ipAddress: json['ip_address'] as String? ?? '',
      requestId: json['request_id'] as String? ?? '',
      details: (json['details'] as Map<String, dynamic>?) ?? {},
      durationMs: json['duration_ms'] as int?,
    );
  }
}

class AuditLogResult {
  final List<AuditLogEntity> logs;
  final int total;
  final int limit;
  final int offset;

  const AuditLogResult({
    required this.logs,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory AuditLogResult.fromJson(Map<String, dynamic> json) {
    final list = (json['audit_logs'] as List<dynamic>?) ?? [];
    return AuditLogResult(
      logs: list
          .map((e) => AuditLogEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      limit: json['limit'] as int? ?? 100,
      offset: json['offset'] as int? ?? 0,
    );
  }
}
