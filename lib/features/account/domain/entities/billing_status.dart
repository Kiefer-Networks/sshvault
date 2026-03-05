class BillingStatus {
  final bool active;
  final String provider;
  final String status;
  final DateTime? periodEnd;

  const BillingStatus({
    required this.active,
    this.provider = '',
    this.status = '',
    this.periodEnd,
  });

  factory BillingStatus.fromJson(Map<String, dynamic> json) {
    DateTime? periodEnd;
    final sub = json['subscription'] as Map<String, dynamic>?;
    if (sub != null) {
      final raw = sub['current_period_end'];
      if (raw is String && raw.isNotEmpty) {
        periodEnd = DateTime.tryParse(raw);
      }
    }

    return BillingStatus(
      active: json['active'] as bool? ?? false,
      provider: json['provider'] as String? ?? '',
      status: json['status'] as String? ?? '',
      periodEnd: periodEnd,
    );
  }

  Map<String, dynamic> toJson() => {
    'active': active,
    'provider': provider,
    'status': status,
    if (periodEnd != null)
      'subscription': {'current_period_end': periodEnd!.toIso8601String()},
  };
}
