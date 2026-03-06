class CouponRedeemResult {
  final bool syncGranted;
  final int syncDays;

  const CouponRedeemResult({required this.syncGranted, required this.syncDays});

  factory CouponRedeemResult.fromJson(Map<String, dynamic> json) {
    return CouponRedeemResult(
      syncGranted: json['sync_granted'] as bool? ?? false,
      syncDays: json['sync_days'] as int? ?? 0,
    );
  }
}
