class BillingStatus {
  final bool active;
  final String provider;
  final String status;
  final bool teleportUnlocked;

  const BillingStatus({
    required this.active,
    this.provider = '',
    this.status = '',
    this.teleportUnlocked = false,
  });

  factory BillingStatus.fromJson(Map<String, dynamic> json) {
    return BillingStatus(
      active: json['active'] as bool? ?? false,
      provider: json['provider'] as String? ?? '',
      status: json['status'] as String? ?? '',
      teleportUnlocked: json['teleport_unlocked'] as bool? ?? false,
    );
  }
}
