// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'known_host_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KnownHostEntity {

 String get id; String get hostname; int get port; String get keyType; String get fingerprint; bool get trusted; DateTime get firstSeenAt; DateTime get lastSeenAt;
/// Create a copy of KnownHostEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KnownHostEntityCopyWith<KnownHostEntity> get copyWith => _$KnownHostEntityCopyWithImpl<KnownHostEntity>(this as KnownHostEntity, _$identity);

  /// Serializes this KnownHostEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KnownHostEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.hostname, hostname) || other.hostname == hostname)&&(identical(other.port, port) || other.port == port)&&(identical(other.keyType, keyType) || other.keyType == keyType)&&(identical(other.fingerprint, fingerprint) || other.fingerprint == fingerprint)&&(identical(other.trusted, trusted) || other.trusted == trusted)&&(identical(other.firstSeenAt, firstSeenAt) || other.firstSeenAt == firstSeenAt)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hostname,port,keyType,fingerprint,trusted,firstSeenAt,lastSeenAt);

@override
String toString() {
  return 'KnownHostEntity(id: $id, hostname: $hostname, port: $port, keyType: $keyType, fingerprint: $fingerprint, trusted: $trusted, firstSeenAt: $firstSeenAt, lastSeenAt: $lastSeenAt)';
}


}

/// @nodoc
abstract mixin class $KnownHostEntityCopyWith<$Res>  {
  factory $KnownHostEntityCopyWith(KnownHostEntity value, $Res Function(KnownHostEntity) _then) = _$KnownHostEntityCopyWithImpl;
@useResult
$Res call({
 String id, String hostname, int port, String keyType, String fingerprint, bool trusted, DateTime firstSeenAt, DateTime lastSeenAt
});




}
/// @nodoc
class _$KnownHostEntityCopyWithImpl<$Res>
    implements $KnownHostEntityCopyWith<$Res> {
  _$KnownHostEntityCopyWithImpl(this._self, this._then);

  final KnownHostEntity _self;
  final $Res Function(KnownHostEntity) _then;

/// Create a copy of KnownHostEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? hostname = null,Object? port = null,Object? keyType = null,Object? fingerprint = null,Object? trusted = null,Object? firstSeenAt = null,Object? lastSeenAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hostname: null == hostname ? _self.hostname : hostname // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,keyType: null == keyType ? _self.keyType : keyType // ignore: cast_nullable_to_non_nullable
as String,fingerprint: null == fingerprint ? _self.fingerprint : fingerprint // ignore: cast_nullable_to_non_nullable
as String,trusted: null == trusted ? _self.trusted : trusted // ignore: cast_nullable_to_non_nullable
as bool,firstSeenAt: null == firstSeenAt ? _self.firstSeenAt : firstSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [KnownHostEntity].
extension KnownHostEntityPatterns on KnownHostEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KnownHostEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KnownHostEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KnownHostEntity value)  $default,){
final _that = this;
switch (_that) {
case _KnownHostEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KnownHostEntity value)?  $default,){
final _that = this;
switch (_that) {
case _KnownHostEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String hostname,  int port,  String keyType,  String fingerprint,  bool trusted,  DateTime firstSeenAt,  DateTime lastSeenAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KnownHostEntity() when $default != null:
return $default(_that.id,_that.hostname,_that.port,_that.keyType,_that.fingerprint,_that.trusted,_that.firstSeenAt,_that.lastSeenAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String hostname,  int port,  String keyType,  String fingerprint,  bool trusted,  DateTime firstSeenAt,  DateTime lastSeenAt)  $default,) {final _that = this;
switch (_that) {
case _KnownHostEntity():
return $default(_that.id,_that.hostname,_that.port,_that.keyType,_that.fingerprint,_that.trusted,_that.firstSeenAt,_that.lastSeenAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String hostname,  int port,  String keyType,  String fingerprint,  bool trusted,  DateTime firstSeenAt,  DateTime lastSeenAt)?  $default,) {final _that = this;
switch (_that) {
case _KnownHostEntity() when $default != null:
return $default(_that.id,_that.hostname,_that.port,_that.keyType,_that.fingerprint,_that.trusted,_that.firstSeenAt,_that.lastSeenAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KnownHostEntity implements KnownHostEntity {
  const _KnownHostEntity({required this.id, required this.hostname, required this.port, required this.keyType, required this.fingerprint, this.trusted = true, required this.firstSeenAt, required this.lastSeenAt});
  factory _KnownHostEntity.fromJson(Map<String, dynamic> json) => _$KnownHostEntityFromJson(json);

@override final  String id;
@override final  String hostname;
@override final  int port;
@override final  String keyType;
@override final  String fingerprint;
@override@JsonKey() final  bool trusted;
@override final  DateTime firstSeenAt;
@override final  DateTime lastSeenAt;

/// Create a copy of KnownHostEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KnownHostEntityCopyWith<_KnownHostEntity> get copyWith => __$KnownHostEntityCopyWithImpl<_KnownHostEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KnownHostEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KnownHostEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.hostname, hostname) || other.hostname == hostname)&&(identical(other.port, port) || other.port == port)&&(identical(other.keyType, keyType) || other.keyType == keyType)&&(identical(other.fingerprint, fingerprint) || other.fingerprint == fingerprint)&&(identical(other.trusted, trusted) || other.trusted == trusted)&&(identical(other.firstSeenAt, firstSeenAt) || other.firstSeenAt == firstSeenAt)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hostname,port,keyType,fingerprint,trusted,firstSeenAt,lastSeenAt);

@override
String toString() {
  return 'KnownHostEntity(id: $id, hostname: $hostname, port: $port, keyType: $keyType, fingerprint: $fingerprint, trusted: $trusted, firstSeenAt: $firstSeenAt, lastSeenAt: $lastSeenAt)';
}


}

/// @nodoc
abstract mixin class _$KnownHostEntityCopyWith<$Res> implements $KnownHostEntityCopyWith<$Res> {
  factory _$KnownHostEntityCopyWith(_KnownHostEntity value, $Res Function(_KnownHostEntity) _then) = __$KnownHostEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String hostname, int port, String keyType, String fingerprint, bool trusted, DateTime firstSeenAt, DateTime lastSeenAt
});




}
/// @nodoc
class __$KnownHostEntityCopyWithImpl<$Res>
    implements _$KnownHostEntityCopyWith<$Res> {
  __$KnownHostEntityCopyWithImpl(this._self, this._then);

  final _KnownHostEntity _self;
  final $Res Function(_KnownHostEntity) _then;

/// Create a copy of KnownHostEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? hostname = null,Object? port = null,Object? keyType = null,Object? fingerprint = null,Object? trusted = null,Object? firstSeenAt = null,Object? lastSeenAt = null,}) {
  return _then(_KnownHostEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hostname: null == hostname ? _self.hostname : hostname // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,keyType: null == keyType ? _self.keyType : keyType // ignore: cast_nullable_to_non_nullable
as String,fingerprint: null == fingerprint ? _self.fingerprint : fingerprint // ignore: cast_nullable_to_non_nullable
as String,trusted: null == trusted ? _self.trusted : trusted // ignore: cast_nullable_to_non_nullable
as bool,firstSeenAt: null == firstSeenAt ? _self.firstSeenAt : firstSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
