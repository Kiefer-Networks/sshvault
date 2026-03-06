import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon_redeem_result.freezed.dart';
part 'coupon_redeem_result.g.dart';

@freezed
abstract class CouponRedeemResult with _$CouponRedeemResult {
  const factory CouponRedeemResult({@Default(false) bool syncGranted}) =
      _CouponRedeemResult;

  factory CouponRedeemResult.fromJson(Map<String, dynamic> json) =>
      _$CouponRedeemResultFromJson(json);
}
