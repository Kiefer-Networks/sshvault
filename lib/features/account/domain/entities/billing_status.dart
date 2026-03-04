class BillingStatus {
  final bool active;
  final String provider;
  final String status;

  const BillingStatus({
    required this.active,
    this.provider = '',
    this.status = '',
  });

  factory BillingStatus.fromJson(Map<String, dynamic> json) {
    return BillingStatus(
      active: json['active'] as bool? ?? false,
      provider: json['provider'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }
}
