import 'package:freezed_annotation/freezed_annotation.dart';

part 'billing_status.freezed.dart';
part 'billing_status.g.dart';

@freezed
abstract class BillingStatus with _$BillingStatus {
  const factory BillingStatus({@Default(false) bool active, String? provider}) =
      _BillingStatus;

  factory BillingStatus.fromJson(Map<String, dynamic> json) =>
      _$BillingStatusFromJson(json);
}
