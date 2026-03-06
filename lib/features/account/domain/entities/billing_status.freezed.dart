// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'billing_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BillingStatus {

 bool get active; String? get provider;
/// Create a copy of BillingStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BillingStatusCopyWith<BillingStatus> get copyWith => _$BillingStatusCopyWithImpl<BillingStatus>(this as BillingStatus, _$identity);

  /// Serializes this BillingStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BillingStatus&&(identical(other.active, active) || other.active == active)&&(identical(other.provider, provider) || other.provider == provider));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,active,provider);

@override
String toString() {
  return 'BillingStatus(active: $active, provider: $provider)';
}


}

/// @nodoc
abstract mixin class $BillingStatusCopyWith<$Res>  {
  factory $BillingStatusCopyWith(BillingStatus value, $Res Function(BillingStatus) _then) = _$BillingStatusCopyWithImpl;
@useResult
$Res call({
 bool active, String? provider
});




}
/// @nodoc
class _$BillingStatusCopyWithImpl<$Res>
    implements $BillingStatusCopyWith<$Res> {
  _$BillingStatusCopyWithImpl(this._self, this._then);

  final BillingStatus _self;
  final $Res Function(BillingStatus) _then;

/// Create a copy of BillingStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? active = null,Object? provider = freezed,}) {
  return _then(_self.copyWith(
active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BillingStatus].
extension BillingStatusPatterns on BillingStatus {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BillingStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BillingStatus() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BillingStatus value)  $default,){
final _that = this;
switch (_that) {
case _BillingStatus():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BillingStatus value)?  $default,){
final _that = this;
switch (_that) {
case _BillingStatus() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool active,  String? provider)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BillingStatus() when $default != null:
return $default(_that.active,_that.provider);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool active,  String? provider)  $default,) {final _that = this;
switch (_that) {
case _BillingStatus():
return $default(_that.active,_that.provider);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool active,  String? provider)?  $default,) {final _that = this;
switch (_that) {
case _BillingStatus() when $default != null:
return $default(_that.active,_that.provider);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BillingStatus implements BillingStatus {
  const _BillingStatus({this.active = false, this.provider});
  factory _BillingStatus.fromJson(Map<String, dynamic> json) => _$BillingStatusFromJson(json);

@override@JsonKey() final  bool active;
@override final  String? provider;

/// Create a copy of BillingStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillingStatusCopyWith<_BillingStatus> get copyWith => __$BillingStatusCopyWithImpl<_BillingStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BillingStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillingStatus&&(identical(other.active, active) || other.active == active)&&(identical(other.provider, provider) || other.provider == provider));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,active,provider);

@override
String toString() {
  return 'BillingStatus(active: $active, provider: $provider)';
}


}

/// @nodoc
abstract mixin class _$BillingStatusCopyWith<$Res> implements $BillingStatusCopyWith<$Res> {
  factory _$BillingStatusCopyWith(_BillingStatus value, $Res Function(_BillingStatus) _then) = __$BillingStatusCopyWithImpl;
@override @useResult
$Res call({
 bool active, String? provider
});




}
/// @nodoc
class __$BillingStatusCopyWithImpl<$Res>
    implements _$BillingStatusCopyWith<$Res> {
  __$BillingStatusCopyWithImpl(this._self, this._then);

  final _BillingStatus _self;
  final $Res Function(_BillingStatus) _then;

/// Create a copy of BillingStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? active = null,Object? provider = freezed,}) {
  return _then(_BillingStatus(
active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
