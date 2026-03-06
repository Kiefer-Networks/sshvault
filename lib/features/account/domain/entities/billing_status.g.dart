// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BillingStatus _$BillingStatusFromJson(Map<String, dynamic> json) =>
    _BillingStatus(
      active: json['active'] as bool? ?? false,
      provider: json['provider'] as String?,
    );

Map<String, dynamic> _$BillingStatusToJson(_BillingStatus instance) =>
    <String, dynamic>{'active': instance.active, 'provider': instance.provider};
