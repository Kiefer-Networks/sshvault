// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teleport_node_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeleportNodeEntity {

 String get id; String get clusterId; String get clusterName; String get hostname; String get addr; Map<String, String> get labels; String get osType;
/// Create a copy of TeleportNodeEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeleportNodeEntityCopyWith<TeleportNodeEntity> get copyWith => _$TeleportNodeEntityCopyWithImpl<TeleportNodeEntity>(this as TeleportNodeEntity, _$identity);

  /// Serializes this TeleportNodeEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeleportNodeEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.clusterId, clusterId) || other.clusterId == clusterId)&&(identical(other.clusterName, clusterName) || other.clusterName == clusterName)&&(identical(other.hostname, hostname) || other.hostname == hostname)&&(identical(other.addr, addr) || other.addr == addr)&&const DeepCollectionEquality().equals(other.labels, labels)&&(identical(other.osType, osType) || other.osType == osType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clusterId,clusterName,hostname,addr,const DeepCollectionEquality().hash(labels),osType);

@override
String toString() {
  return 'TeleportNodeEntity(id: $id, clusterId: $clusterId, clusterName: $clusterName, hostname: $hostname, addr: $addr, labels: $labels, osType: $osType)';
}


}

/// @nodoc
abstract mixin class $TeleportNodeEntityCopyWith<$Res>  {
  factory $TeleportNodeEntityCopyWith(TeleportNodeEntity value, $Res Function(TeleportNodeEntity) _then) = _$TeleportNodeEntityCopyWithImpl;
@useResult
$Res call({
 String id, String clusterId, String clusterName, String hostname, String addr, Map<String, String> labels, String osType
});




}
/// @nodoc
class _$TeleportNodeEntityCopyWithImpl<$Res>
    implements $TeleportNodeEntityCopyWith<$Res> {
  _$TeleportNodeEntityCopyWithImpl(this._self, this._then);

  final TeleportNodeEntity _self;
  final $Res Function(TeleportNodeEntity) _then;

/// Create a copy of TeleportNodeEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clusterId = null,Object? clusterName = null,Object? hostname = null,Object? addr = null,Object? labels = null,Object? osType = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clusterId: null == clusterId ? _self.clusterId : clusterId // ignore: cast_nullable_to_non_nullable
as String,clusterName: null == clusterName ? _self.clusterName : clusterName // ignore: cast_nullable_to_non_nullable
as String,hostname: null == hostname ? _self.hostname : hostname // ignore: cast_nullable_to_non_nullable
as String,addr: null == addr ? _self.addr : addr // ignore: cast_nullable_to_non_nullable
as String,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as Map<String, String>,osType: null == osType ? _self.osType : osType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TeleportNodeEntity].
extension TeleportNodeEntityPatterns on TeleportNodeEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeleportNodeEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeleportNodeEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeleportNodeEntity value)  $default,){
final _that = this;
switch (_that) {
case _TeleportNodeEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeleportNodeEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TeleportNodeEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String clusterId,  String clusterName,  String hostname,  String addr,  Map<String, String> labels,  String osType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeleportNodeEntity() when $default != null:
return $default(_that.id,_that.clusterId,_that.clusterName,_that.hostname,_that.addr,_that.labels,_that.osType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String clusterId,  String clusterName,  String hostname,  String addr,  Map<String, String> labels,  String osType)  $default,) {final _that = this;
switch (_that) {
case _TeleportNodeEntity():
return $default(_that.id,_that.clusterId,_that.clusterName,_that.hostname,_that.addr,_that.labels,_that.osType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String clusterId,  String clusterName,  String hostname,  String addr,  Map<String, String> labels,  String osType)?  $default,) {final _that = this;
switch (_that) {
case _TeleportNodeEntity() when $default != null:
return $default(_that.id,_that.clusterId,_that.clusterName,_that.hostname,_that.addr,_that.labels,_that.osType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeleportNodeEntity implements TeleportNodeEntity {
  const _TeleportNodeEntity({required this.id, required this.clusterId, required this.clusterName, required this.hostname, required this.addr, final  Map<String, String> labels = const {}, this.osType = ''}): _labels = labels;
  factory _TeleportNodeEntity.fromJson(Map<String, dynamic> json) => _$TeleportNodeEntityFromJson(json);

@override final  String id;
@override final  String clusterId;
@override final  String clusterName;
@override final  String hostname;
@override final  String addr;
 final  Map<String, String> _labels;
@override@JsonKey() Map<String, String> get labels {
  if (_labels is EqualUnmodifiableMapView) return _labels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_labels);
}

@override@JsonKey() final  String osType;

/// Create a copy of TeleportNodeEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeleportNodeEntityCopyWith<_TeleportNodeEntity> get copyWith => __$TeleportNodeEntityCopyWithImpl<_TeleportNodeEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeleportNodeEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeleportNodeEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.clusterId, clusterId) || other.clusterId == clusterId)&&(identical(other.clusterName, clusterName) || other.clusterName == clusterName)&&(identical(other.hostname, hostname) || other.hostname == hostname)&&(identical(other.addr, addr) || other.addr == addr)&&const DeepCollectionEquality().equals(other._labels, _labels)&&(identical(other.osType, osType) || other.osType == osType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clusterId,clusterName,hostname,addr,const DeepCollectionEquality().hash(_labels),osType);

@override
String toString() {
  return 'TeleportNodeEntity(id: $id, clusterId: $clusterId, clusterName: $clusterName, hostname: $hostname, addr: $addr, labels: $labels, osType: $osType)';
}


}

/// @nodoc
abstract mixin class _$TeleportNodeEntityCopyWith<$Res> implements $TeleportNodeEntityCopyWith<$Res> {
  factory _$TeleportNodeEntityCopyWith(_TeleportNodeEntity value, $Res Function(_TeleportNodeEntity) _then) = __$TeleportNodeEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String clusterId, String clusterName, String hostname, String addr, Map<String, String> labels, String osType
});




}
/// @nodoc
class __$TeleportNodeEntityCopyWithImpl<$Res>
    implements _$TeleportNodeEntityCopyWith<$Res> {
  __$TeleportNodeEntityCopyWithImpl(this._self, this._then);

  final _TeleportNodeEntity _self;
  final $Res Function(_TeleportNodeEntity) _then;

/// Create a copy of TeleportNodeEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clusterId = null,Object? clusterName = null,Object? hostname = null,Object? addr = null,Object? labels = null,Object? osType = null,}) {
  return _then(_TeleportNodeEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clusterId: null == clusterId ? _self.clusterId : clusterId // ignore: cast_nullable_to_non_nullable
as String,clusterName: null == clusterName ? _self.clusterName : clusterName // ignore: cast_nullable_to_non_nullable
as String,hostname: null == hostname ? _self.hostname : hostname // ignore: cast_nullable_to_non_nullable
as String,addr: null == addr ? _self.addr : addr // ignore: cast_nullable_to_non_nullable
as String,labels: null == labels ? _self._labels : labels // ignore: cast_nullable_to_non_nullable
as Map<String, String>,osType: null == osType ? _self.osType : osType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
