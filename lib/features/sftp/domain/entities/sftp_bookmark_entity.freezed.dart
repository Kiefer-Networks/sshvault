// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sftp_bookmark_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SftpBookmarkEntity {

 String get id; String get serverId; String get path; String get label; int get sortOrder; DateTime get createdAt;
/// Create a copy of SftpBookmarkEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SftpBookmarkEntityCopyWith<SftpBookmarkEntity> get copyWith => _$SftpBookmarkEntityCopyWithImpl<SftpBookmarkEntity>(this as SftpBookmarkEntity, _$identity);

  /// Serializes this SftpBookmarkEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SftpBookmarkEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.path, path) || other.path == path)&&(identical(other.label, label) || other.label == label)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,serverId,path,label,sortOrder,createdAt);

@override
String toString() {
  return 'SftpBookmarkEntity(id: $id, serverId: $serverId, path: $path, label: $label, sortOrder: $sortOrder, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SftpBookmarkEntityCopyWith<$Res>  {
  factory $SftpBookmarkEntityCopyWith(SftpBookmarkEntity value, $Res Function(SftpBookmarkEntity) _then) = _$SftpBookmarkEntityCopyWithImpl;
@useResult
$Res call({
 String id, String serverId, String path, String label, int sortOrder, DateTime createdAt
});




}
/// @nodoc
class _$SftpBookmarkEntityCopyWithImpl<$Res>
    implements $SftpBookmarkEntityCopyWith<$Res> {
  _$SftpBookmarkEntityCopyWithImpl(this._self, this._then);

  final SftpBookmarkEntity _self;
  final $Res Function(SftpBookmarkEntity) _then;

/// Create a copy of SftpBookmarkEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? serverId = null,Object? path = null,Object? label = null,Object? sortOrder = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,serverId: null == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SftpBookmarkEntity].
extension SftpBookmarkEntityPatterns on SftpBookmarkEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SftpBookmarkEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SftpBookmarkEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SftpBookmarkEntity value)  $default,){
final _that = this;
switch (_that) {
case _SftpBookmarkEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SftpBookmarkEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SftpBookmarkEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String serverId,  String path,  String label,  int sortOrder,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SftpBookmarkEntity() when $default != null:
return $default(_that.id,_that.serverId,_that.path,_that.label,_that.sortOrder,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String serverId,  String path,  String label,  int sortOrder,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SftpBookmarkEntity():
return $default(_that.id,_that.serverId,_that.path,_that.label,_that.sortOrder,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String serverId,  String path,  String label,  int sortOrder,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SftpBookmarkEntity() when $default != null:
return $default(_that.id,_that.serverId,_that.path,_that.label,_that.sortOrder,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SftpBookmarkEntity implements SftpBookmarkEntity {
  const _SftpBookmarkEntity({required this.id, required this.serverId, required this.path, required this.label, this.sortOrder = 0, required this.createdAt});
  factory _SftpBookmarkEntity.fromJson(Map<String, dynamic> json) => _$SftpBookmarkEntityFromJson(json);

@override final  String id;
@override final  String serverId;
@override final  String path;
@override final  String label;
@override@JsonKey() final  int sortOrder;
@override final  DateTime createdAt;

/// Create a copy of SftpBookmarkEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SftpBookmarkEntityCopyWith<_SftpBookmarkEntity> get copyWith => __$SftpBookmarkEntityCopyWithImpl<_SftpBookmarkEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SftpBookmarkEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SftpBookmarkEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.path, path) || other.path == path)&&(identical(other.label, label) || other.label == label)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,serverId,path,label,sortOrder,createdAt);

@override
String toString() {
  return 'SftpBookmarkEntity(id: $id, serverId: $serverId, path: $path, label: $label, sortOrder: $sortOrder, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SftpBookmarkEntityCopyWith<$Res> implements $SftpBookmarkEntityCopyWith<$Res> {
  factory _$SftpBookmarkEntityCopyWith(_SftpBookmarkEntity value, $Res Function(_SftpBookmarkEntity) _then) = __$SftpBookmarkEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String serverId, String path, String label, int sortOrder, DateTime createdAt
});




}
/// @nodoc
class __$SftpBookmarkEntityCopyWithImpl<$Res>
    implements _$SftpBookmarkEntityCopyWith<$Res> {
  __$SftpBookmarkEntityCopyWithImpl(this._self, this._then);

  final _SftpBookmarkEntity _self;
  final $Res Function(_SftpBookmarkEntity) _then;

/// Create a copy of SftpBookmarkEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? serverId = null,Object? path = null,Object? label = null,Object? sortOrder = null,Object? createdAt = null,}) {
  return _then(_SftpBookmarkEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,serverId: null == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
