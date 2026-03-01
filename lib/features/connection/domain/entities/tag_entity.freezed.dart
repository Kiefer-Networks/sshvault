// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tag_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TagEntity {

 String get id; String get name; int get color; String? get ownerId; String? get sharedWith; String? get permissions; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of TagEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagEntityCopyWith<TagEntity> get copyWith => _$TagEntityCopyWithImpl<TagEntity>(this as TagEntity, _$identity);

  /// Serializes this TagEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.sharedWith, sharedWith) || other.sharedWith == sharedWith)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,color,ownerId,sharedWith,permissions,createdAt,updatedAt);

@override
String toString() {
  return 'TagEntity(id: $id, name: $name, color: $color, ownerId: $ownerId, sharedWith: $sharedWith, permissions: $permissions, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TagEntityCopyWith<$Res>  {
  factory $TagEntityCopyWith(TagEntity value, $Res Function(TagEntity) _then) = _$TagEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, int color, String? ownerId, String? sharedWith, String? permissions, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$TagEntityCopyWithImpl<$Res>
    implements $TagEntityCopyWith<$Res> {
  _$TagEntityCopyWithImpl(this._self, this._then);

  final TagEntity _self;
  final $Res Function(TagEntity) _then;

/// Create a copy of TagEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? color = null,Object? ownerId = freezed,Object? sharedWith = freezed,Object? permissions = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,ownerId: freezed == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String?,sharedWith: freezed == sharedWith ? _self.sharedWith : sharedWith // ignore: cast_nullable_to_non_nullable
as String?,permissions: freezed == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TagEntity].
extension TagEntityPatterns on TagEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TagEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TagEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TagEntity value)  $default,){
final _that = this;
switch (_that) {
case _TagEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TagEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TagEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int color,  String? ownerId,  String? sharedWith,  String? permissions,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TagEntity() when $default != null:
return $default(_that.id,_that.name,_that.color,_that.ownerId,_that.sharedWith,_that.permissions,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int color,  String? ownerId,  String? sharedWith,  String? permissions,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TagEntity():
return $default(_that.id,_that.name,_that.color,_that.ownerId,_that.sharedWith,_that.permissions,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int color,  String? ownerId,  String? sharedWith,  String? permissions,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TagEntity() when $default != null:
return $default(_that.id,_that.name,_that.color,_that.ownerId,_that.sharedWith,_that.permissions,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TagEntity implements TagEntity {
  const _TagEntity({required this.id, required this.name, this.color = 0xFF6C63FF, this.ownerId, this.sharedWith, this.permissions, required this.createdAt, required this.updatedAt});
  factory _TagEntity.fromJson(Map<String, dynamic> json) => _$TagEntityFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  int color;
@override final  String? ownerId;
@override final  String? sharedWith;
@override final  String? permissions;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of TagEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TagEntityCopyWith<_TagEntity> get copyWith => __$TagEntityCopyWithImpl<_TagEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TagEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TagEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.sharedWith, sharedWith) || other.sharedWith == sharedWith)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,color,ownerId,sharedWith,permissions,createdAt,updatedAt);

@override
String toString() {
  return 'TagEntity(id: $id, name: $name, color: $color, ownerId: $ownerId, sharedWith: $sharedWith, permissions: $permissions, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TagEntityCopyWith<$Res> implements $TagEntityCopyWith<$Res> {
  factory _$TagEntityCopyWith(_TagEntity value, $Res Function(_TagEntity) _then) = __$TagEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int color, String? ownerId, String? sharedWith, String? permissions, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$TagEntityCopyWithImpl<$Res>
    implements _$TagEntityCopyWith<$Res> {
  __$TagEntityCopyWithImpl(this._self, this._then);

  final _TagEntity _self;
  final $Res Function(_TagEntity) _then;

/// Create a copy of TagEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? color = null,Object? ownerId = freezed,Object? sharedWith = freezed,Object? permissions = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_TagEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,ownerId: freezed == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String?,sharedWith: freezed == sharedWith ? _self.sharedWith : sharedWith // ignore: cast_nullable_to_non_nullable
as String?,permissions: freezed == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
