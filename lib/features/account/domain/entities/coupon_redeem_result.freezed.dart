// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coupon_redeem_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CouponRedeemResult {

 bool get syncGranted;
/// Create a copy of CouponRedeemResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CouponRedeemResultCopyWith<CouponRedeemResult> get copyWith => _$CouponRedeemResultCopyWithImpl<CouponRedeemResult>(this as CouponRedeemResult, _$identity);

  /// Serializes this CouponRedeemResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CouponRedeemResult&&(identical(other.syncGranted, syncGranted) || other.syncGranted == syncGranted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,syncGranted);

@override
String toString() {
  return 'CouponRedeemResult(syncGranted: $syncGranted)';
}


}

/// @nodoc
abstract mixin class $CouponRedeemResultCopyWith<$Res>  {
  factory $CouponRedeemResultCopyWith(CouponRedeemResult value, $Res Function(CouponRedeemResult) _then) = _$CouponRedeemResultCopyWithImpl;
@useResult
$Res call({
 bool syncGranted
});




}
/// @nodoc
class _$CouponRedeemResultCopyWithImpl<$Res>
    implements $CouponRedeemResultCopyWith<$Res> {
  _$CouponRedeemResultCopyWithImpl(this._self, this._then);

  final CouponRedeemResult _self;
  final $Res Function(CouponRedeemResult) _then;

/// Create a copy of CouponRedeemResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? syncGranted = null,}) {
  return _then(_self.copyWith(
syncGranted: null == syncGranted ? _self.syncGranted : syncGranted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CouponRedeemResult].
extension CouponRedeemResultPatterns on CouponRedeemResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CouponRedeemResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CouponRedeemResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CouponRedeemResult value)  $default,){
final _that = this;
switch (_that) {
case _CouponRedeemResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CouponRedeemResult value)?  $default,){
final _that = this;
switch (_that) {
case _CouponRedeemResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool syncGranted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CouponRedeemResult() when $default != null:
return $default(_that.syncGranted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool syncGranted)  $default,) {final _that = this;
switch (_that) {
case _CouponRedeemResult():
return $default(_that.syncGranted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool syncGranted)?  $default,) {final _that = this;
switch (_that) {
case _CouponRedeemResult() when $default != null:
return $default(_that.syncGranted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CouponRedeemResult implements CouponRedeemResult {
  const _CouponRedeemResult({this.syncGranted = false});
  factory _CouponRedeemResult.fromJson(Map<String, dynamic> json) => _$CouponRedeemResultFromJson(json);

@override@JsonKey() final  bool syncGranted;

/// Create a copy of CouponRedeemResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CouponRedeemResultCopyWith<_CouponRedeemResult> get copyWith => __$CouponRedeemResultCopyWithImpl<_CouponRedeemResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CouponRedeemResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CouponRedeemResult&&(identical(other.syncGranted, syncGranted) || other.syncGranted == syncGranted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,syncGranted);

@override
String toString() {
  return 'CouponRedeemResult(syncGranted: $syncGranted)';
}


}

/// @nodoc
abstract mixin class _$CouponRedeemResultCopyWith<$Res> implements $CouponRedeemResultCopyWith<$Res> {
  factory _$CouponRedeemResultCopyWith(_CouponRedeemResult value, $Res Function(_CouponRedeemResult) _then) = __$CouponRedeemResultCopyWithImpl;
@override @useResult
$Res call({
 bool syncGranted
});




}
/// @nodoc
class __$CouponRedeemResultCopyWithImpl<$Res>
    implements _$CouponRedeemResultCopyWith<$Res> {
  __$CouponRedeemResultCopyWithImpl(this._self, this._then);

  final _CouponRedeemResult _self;
  final $Res Function(_CouponRedeemResult) _then;

/// Create a copy of CouponRedeemResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? syncGranted = null,}) {
  return _then(_CouponRedeemResult(
syncGranted: null == syncGranted ? _self.syncGranted : syncGranted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
