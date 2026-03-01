// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeviceEntity {

 String get id; String get name; String get platform;@JsonKey(name: 'last_sync') DateTime? get lastSync;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of DeviceEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceEntityCopyWith<DeviceEntity> get copyWith => _$DeviceEntityCopyWithImpl<DeviceEntity>(this as DeviceEntity, _$identity);

  /// Serializes this DeviceEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.lastSync, lastSync) || other.lastSync == lastSync)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,platform,lastSync,createdAt);

@override
String toString() {
  return 'DeviceEntity(id: $id, name: $name, platform: $platform, lastSync: $lastSync, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DeviceEntityCopyWith<$Res>  {
  factory $DeviceEntityCopyWith(DeviceEntity value, $Res Function(DeviceEntity) _then) = _$DeviceEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String platform,@JsonKey(name: 'last_sync') DateTime? lastSync,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$DeviceEntityCopyWithImpl<$Res>
    implements $DeviceEntityCopyWith<$Res> {
  _$DeviceEntityCopyWithImpl(this._self, this._then);

  final DeviceEntity _self;
  final $Res Function(DeviceEntity) _then;

/// Create a copy of DeviceEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? platform = null,Object? lastSync = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,lastSync: freezed == lastSync ? _self.lastSync : lastSync // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceEntity].
extension DeviceEntityPatterns on DeviceEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceEntity value)  $default,){
final _that = this;
switch (_that) {
case _DeviceEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String platform, @JsonKey(name: 'last_sync')  DateTime? lastSync, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceEntity() when $default != null:
return $default(_that.id,_that.name,_that.platform,_that.lastSync,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String platform, @JsonKey(name: 'last_sync')  DateTime? lastSync, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _DeviceEntity():
return $default(_that.id,_that.name,_that.platform,_that.lastSync,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String platform, @JsonKey(name: 'last_sync')  DateTime? lastSync, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DeviceEntity() when $default != null:
return $default(_that.id,_that.name,_that.platform,_that.lastSync,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceEntity implements DeviceEntity {
  const _DeviceEntity({required this.id, required this.name, this.platform = '', @JsonKey(name: 'last_sync') this.lastSync, @JsonKey(name: 'created_at') this.createdAt});
  factory _DeviceEntity.fromJson(Map<String, dynamic> json) => _$DeviceEntityFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  String platform;
@override@JsonKey(name: 'last_sync') final  DateTime? lastSync;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of DeviceEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceEntityCopyWith<_DeviceEntity> get copyWith => __$DeviceEntityCopyWithImpl<_DeviceEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.lastSync, lastSync) || other.lastSync == lastSync)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,platform,lastSync,createdAt);

@override
String toString() {
  return 'DeviceEntity(id: $id, name: $name, platform: $platform, lastSync: $lastSync, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DeviceEntityCopyWith<$Res> implements $DeviceEntityCopyWith<$Res> {
  factory _$DeviceEntityCopyWith(_DeviceEntity value, $Res Function(_DeviceEntity) _then) = __$DeviceEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String platform,@JsonKey(name: 'last_sync') DateTime? lastSync,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$DeviceEntityCopyWithImpl<$Res>
    implements _$DeviceEntityCopyWith<$Res> {
  __$DeviceEntityCopyWithImpl(this._self, this._then);

  final _DeviceEntity _self;
  final $Res Function(_DeviceEntity) _then;

/// Create a copy of DeviceEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? platform = null,Object? lastSync = freezed,Object? createdAt = freezed,}) {
  return _then(_DeviceEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,lastSync: freezed == lastSync ? _self.lastSync : lastSync // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
