// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teleport_cluster_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeleportClusterEntity {

 String get id; String get name; String get proxyAddr; TeleportAuthMethod get authMethod; String get username; Map<String, dynamic> get metadata; DateTime? get certExpiresAt; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of TeleportClusterEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeleportClusterEntityCopyWith<TeleportClusterEntity> get copyWith => _$TeleportClusterEntityCopyWithImpl<TeleportClusterEntity>(this as TeleportClusterEntity, _$identity);

  /// Serializes this TeleportClusterEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeleportClusterEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.proxyAddr, proxyAddr) || other.proxyAddr == proxyAddr)&&(identical(other.authMethod, authMethod) || other.authMethod == authMethod)&&(identical(other.username, username) || other.username == username)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.certExpiresAt, certExpiresAt) || other.certExpiresAt == certExpiresAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,proxyAddr,authMethod,username,const DeepCollectionEquality().hash(metadata),certExpiresAt,createdAt,updatedAt);

@override
String toString() {
  return 'TeleportClusterEntity(id: $id, name: $name, proxyAddr: $proxyAddr, authMethod: $authMethod, username: $username, metadata: $metadata, certExpiresAt: $certExpiresAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TeleportClusterEntityCopyWith<$Res>  {
  factory $TeleportClusterEntityCopyWith(TeleportClusterEntity value, $Res Function(TeleportClusterEntity) _then) = _$TeleportClusterEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String proxyAddr, TeleportAuthMethod authMethod, String username, Map<String, dynamic> metadata, DateTime? certExpiresAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$TeleportClusterEntityCopyWithImpl<$Res>
    implements $TeleportClusterEntityCopyWith<$Res> {
  _$TeleportClusterEntityCopyWithImpl(this._self, this._then);

  final TeleportClusterEntity _self;
  final $Res Function(TeleportClusterEntity) _then;

/// Create a copy of TeleportClusterEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? proxyAddr = null,Object? authMethod = null,Object? username = null,Object? metadata = null,Object? certExpiresAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,proxyAddr: null == proxyAddr ? _self.proxyAddr : proxyAddr // ignore: cast_nullable_to_non_nullable
as String,authMethod: null == authMethod ? _self.authMethod : authMethod // ignore: cast_nullable_to_non_nullable
as TeleportAuthMethod,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,certExpiresAt: freezed == certExpiresAt ? _self.certExpiresAt : certExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TeleportClusterEntity].
extension TeleportClusterEntityPatterns on TeleportClusterEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeleportClusterEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeleportClusterEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeleportClusterEntity value)  $default,){
final _that = this;
switch (_that) {
case _TeleportClusterEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeleportClusterEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TeleportClusterEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String proxyAddr,  TeleportAuthMethod authMethod,  String username,  Map<String, dynamic> metadata,  DateTime? certExpiresAt,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeleportClusterEntity() when $default != null:
return $default(_that.id,_that.name,_that.proxyAddr,_that.authMethod,_that.username,_that.metadata,_that.certExpiresAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String proxyAddr,  TeleportAuthMethod authMethod,  String username,  Map<String, dynamic> metadata,  DateTime? certExpiresAt,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TeleportClusterEntity():
return $default(_that.id,_that.name,_that.proxyAddr,_that.authMethod,_that.username,_that.metadata,_that.certExpiresAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String proxyAddr,  TeleportAuthMethod authMethod,  String username,  Map<String, dynamic> metadata,  DateTime? certExpiresAt,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TeleportClusterEntity() when $default != null:
return $default(_that.id,_that.name,_that.proxyAddr,_that.authMethod,_that.username,_that.metadata,_that.certExpiresAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeleportClusterEntity implements TeleportClusterEntity {
  const _TeleportClusterEntity({required this.id, required this.name, required this.proxyAddr, this.authMethod = TeleportAuthMethod.local, this.username = '', final  Map<String, dynamic> metadata = const {}, this.certExpiresAt, required this.createdAt, required this.updatedAt}): _metadata = metadata;
  factory _TeleportClusterEntity.fromJson(Map<String, dynamic> json) => _$TeleportClusterEntityFromJson(json);

@override final  String id;
@override final  String name;
@override final  String proxyAddr;
@override@JsonKey() final  TeleportAuthMethod authMethod;
@override@JsonKey() final  String username;
 final  Map<String, dynamic> _metadata;
@override@JsonKey() Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}

@override final  DateTime? certExpiresAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of TeleportClusterEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeleportClusterEntityCopyWith<_TeleportClusterEntity> get copyWith => __$TeleportClusterEntityCopyWithImpl<_TeleportClusterEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeleportClusterEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeleportClusterEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.proxyAddr, proxyAddr) || other.proxyAddr == proxyAddr)&&(identical(other.authMethod, authMethod) || other.authMethod == authMethod)&&(identical(other.username, username) || other.username == username)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.certExpiresAt, certExpiresAt) || other.certExpiresAt == certExpiresAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,proxyAddr,authMethod,username,const DeepCollectionEquality().hash(_metadata),certExpiresAt,createdAt,updatedAt);

@override
String toString() {
  return 'TeleportClusterEntity(id: $id, name: $name, proxyAddr: $proxyAddr, authMethod: $authMethod, username: $username, metadata: $metadata, certExpiresAt: $certExpiresAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TeleportClusterEntityCopyWith<$Res> implements $TeleportClusterEntityCopyWith<$Res> {
  factory _$TeleportClusterEntityCopyWith(_TeleportClusterEntity value, $Res Function(_TeleportClusterEntity) _then) = __$TeleportClusterEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String proxyAddr, TeleportAuthMethod authMethod, String username, Map<String, dynamic> metadata, DateTime? certExpiresAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$TeleportClusterEntityCopyWithImpl<$Res>
    implements _$TeleportClusterEntityCopyWith<$Res> {
  __$TeleportClusterEntityCopyWithImpl(this._self, this._then);

  final _TeleportClusterEntity _self;
  final $Res Function(_TeleportClusterEntity) _then;

/// Create a copy of TeleportClusterEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? proxyAddr = null,Object? authMethod = null,Object? username = null,Object? metadata = null,Object? certExpiresAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_TeleportClusterEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,proxyAddr: null == proxyAddr ? _self.proxyAddr : proxyAddr // ignore: cast_nullable_to_non_nullable
as String,authMethod: null == authMethod ? _self.authMethod : authMethod // ignore: cast_nullable_to_non_nullable
as TeleportAuthMethod,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,certExpiresAt: freezed == certExpiresAt ? _self.certExpiresAt : certExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
