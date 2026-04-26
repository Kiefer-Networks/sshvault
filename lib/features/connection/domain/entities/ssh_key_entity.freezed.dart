// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ssh_key_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SshKeyEntity {

 String get id; String get name; SshKeyType get keyType; String get fingerprint; String get publicKey; String get comment; int get linkedServerCount; String? get ownerId; String? get sharedWith; String? get permissions; DateTime get createdAt; DateTime get updatedAt; DateTime? get deletedAt;
/// Create a copy of SshKeyEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SshKeyEntityCopyWith<SshKeyEntity> get copyWith => _$SshKeyEntityCopyWithImpl<SshKeyEntity>(this as SshKeyEntity, _$identity);

  /// Serializes this SshKeyEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SshKeyEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.keyType, keyType) || other.keyType == keyType)&&(identical(other.fingerprint, fingerprint) || other.fingerprint == fingerprint)&&(identical(other.publicKey, publicKey) || other.publicKey == publicKey)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.linkedServerCount, linkedServerCount) || other.linkedServerCount == linkedServerCount)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.sharedWith, sharedWith) || other.sharedWith == sharedWith)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,keyType,fingerprint,publicKey,comment,linkedServerCount,ownerId,sharedWith,permissions,createdAt,updatedAt,deletedAt);

@override
String toString() {
  return 'SshKeyEntity(id: $id, name: $name, keyType: $keyType, fingerprint: $fingerprint, publicKey: $publicKey, comment: $comment, linkedServerCount: $linkedServerCount, ownerId: $ownerId, sharedWith: $sharedWith, permissions: $permissions, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class $SshKeyEntityCopyWith<$Res>  {
  factory $SshKeyEntityCopyWith(SshKeyEntity value, $Res Function(SshKeyEntity) _then) = _$SshKeyEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, SshKeyType keyType, String fingerprint, String publicKey, String comment, int linkedServerCount, String? ownerId, String? sharedWith, String? permissions, DateTime createdAt, DateTime updatedAt, DateTime? deletedAt
});




}
/// @nodoc
class _$SshKeyEntityCopyWithImpl<$Res>
    implements $SshKeyEntityCopyWith<$Res> {
  _$SshKeyEntityCopyWithImpl(this._self, this._then);

  final SshKeyEntity _self;
  final $Res Function(SshKeyEntity) _then;

/// Create a copy of SshKeyEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? keyType = null,Object? fingerprint = null,Object? publicKey = null,Object? comment = null,Object? linkedServerCount = null,Object? ownerId = freezed,Object? sharedWith = freezed,Object? permissions = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,keyType: null == keyType ? _self.keyType : keyType // ignore: cast_nullable_to_non_nullable
as SshKeyType,fingerprint: null == fingerprint ? _self.fingerprint : fingerprint // ignore: cast_nullable_to_non_nullable
as String,publicKey: null == publicKey ? _self.publicKey : publicKey // ignore: cast_nullable_to_non_nullable
as String,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,linkedServerCount: null == linkedServerCount ? _self.linkedServerCount : linkedServerCount // ignore: cast_nullable_to_non_nullable
as int,ownerId: freezed == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String?,sharedWith: freezed == sharedWith ? _self.sharedWith : sharedWith // ignore: cast_nullable_to_non_nullable
as String?,permissions: freezed == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SshKeyEntity].
extension SshKeyEntityPatterns on SshKeyEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SshKeyEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SshKeyEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SshKeyEntity value)  $default,){
final _that = this;
switch (_that) {
case _SshKeyEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SshKeyEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SshKeyEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  SshKeyType keyType,  String fingerprint,  String publicKey,  String comment,  int linkedServerCount,  String? ownerId,  String? sharedWith,  String? permissions,  DateTime createdAt,  DateTime updatedAt,  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SshKeyEntity() when $default != null:
return $default(_that.id,_that.name,_that.keyType,_that.fingerprint,_that.publicKey,_that.comment,_that.linkedServerCount,_that.ownerId,_that.sharedWith,_that.permissions,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  SshKeyType keyType,  String fingerprint,  String publicKey,  String comment,  int linkedServerCount,  String? ownerId,  String? sharedWith,  String? permissions,  DateTime createdAt,  DateTime updatedAt,  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _SshKeyEntity():
return $default(_that.id,_that.name,_that.keyType,_that.fingerprint,_that.publicKey,_that.comment,_that.linkedServerCount,_that.ownerId,_that.sharedWith,_that.permissions,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  SshKeyType keyType,  String fingerprint,  String publicKey,  String comment,  int linkedServerCount,  String? ownerId,  String? sharedWith,  String? permissions,  DateTime createdAt,  DateTime updatedAt,  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _SshKeyEntity() when $default != null:
return $default(_that.id,_that.name,_that.keyType,_that.fingerprint,_that.publicKey,_that.comment,_that.linkedServerCount,_that.ownerId,_that.sharedWith,_that.permissions,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SshKeyEntity implements SshKeyEntity {
  const _SshKeyEntity({required this.id, required this.name, required this.keyType, this.fingerprint = '', this.publicKey = '', this.comment = '', this.linkedServerCount = 0, this.ownerId, this.sharedWith, this.permissions, required this.createdAt, required this.updatedAt, this.deletedAt});
  factory _SshKeyEntity.fromJson(Map<String, dynamic> json) => _$SshKeyEntityFromJson(json);

@override final  String id;
@override final  String name;
@override final  SshKeyType keyType;
@override@JsonKey() final  String fingerprint;
@override@JsonKey() final  String publicKey;
@override@JsonKey() final  String comment;
@override@JsonKey() final  int linkedServerCount;
@override final  String? ownerId;
@override final  String? sharedWith;
@override final  String? permissions;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  DateTime? deletedAt;

/// Create a copy of SshKeyEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SshKeyEntityCopyWith<_SshKeyEntity> get copyWith => __$SshKeyEntityCopyWithImpl<_SshKeyEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SshKeyEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SshKeyEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.keyType, keyType) || other.keyType == keyType)&&(identical(other.fingerprint, fingerprint) || other.fingerprint == fingerprint)&&(identical(other.publicKey, publicKey) || other.publicKey == publicKey)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.linkedServerCount, linkedServerCount) || other.linkedServerCount == linkedServerCount)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.sharedWith, sharedWith) || other.sharedWith == sharedWith)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,keyType,fingerprint,publicKey,comment,linkedServerCount,ownerId,sharedWith,permissions,createdAt,updatedAt,deletedAt);

@override
String toString() {
  return 'SshKeyEntity(id: $id, name: $name, keyType: $keyType, fingerprint: $fingerprint, publicKey: $publicKey, comment: $comment, linkedServerCount: $linkedServerCount, ownerId: $ownerId, sharedWith: $sharedWith, permissions: $permissions, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$SshKeyEntityCopyWith<$Res> implements $SshKeyEntityCopyWith<$Res> {
  factory _$SshKeyEntityCopyWith(_SshKeyEntity value, $Res Function(_SshKeyEntity) _then) = __$SshKeyEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, SshKeyType keyType, String fingerprint, String publicKey, String comment, int linkedServerCount, String? ownerId, String? sharedWith, String? permissions, DateTime createdAt, DateTime updatedAt, DateTime? deletedAt
});




}
/// @nodoc
class __$SshKeyEntityCopyWithImpl<$Res>
    implements _$SshKeyEntityCopyWith<$Res> {
  __$SshKeyEntityCopyWithImpl(this._self, this._then);

  final _SshKeyEntity _self;
  final $Res Function(_SshKeyEntity) _then;

/// Create a copy of SshKeyEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? keyType = null,Object? fingerprint = null,Object? publicKey = null,Object? comment = null,Object? linkedServerCount = null,Object? ownerId = freezed,Object? sharedWith = freezed,Object? permissions = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,}) {
  return _then(_SshKeyEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,keyType: null == keyType ? _self.keyType : keyType // ignore: cast_nullable_to_non_nullable
as SshKeyType,fingerprint: null == fingerprint ? _self.fingerprint : fingerprint // ignore: cast_nullable_to_non_nullable
as String,publicKey: null == publicKey ? _self.publicKey : publicKey // ignore: cast_nullable_to_non_nullable
as String,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,linkedServerCount: null == linkedServerCount ? _self.linkedServerCount : linkedServerCount // ignore: cast_nullable_to_non_nullable
as int,ownerId: freezed == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String?,sharedWith: freezed == sharedWith ? _self.sharedWith : sharedWith // ignore: cast_nullable_to_non_nullable
as String?,permissions: freezed == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
