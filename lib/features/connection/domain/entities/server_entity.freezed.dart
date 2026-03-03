// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServerEntity {

 String get id; String get name; String get hostname; int get port; String get username; AuthMethod get authMethod; String get notes; int get color; String get iconName; bool get isActive; String? get groupId; String? get sshKeyId; int get sortOrder; String? get distroId; String? get distroName; List<TagEntity> get tags; String? get jumpHostId; String? get ownerId; String? get sharedWith; String? get permissions; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of ServerEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerEntityCopyWith<ServerEntity> get copyWith => _$ServerEntityCopyWithImpl<ServerEntity>(this as ServerEntity, _$identity);

  /// Serializes this ServerEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.hostname, hostname) || other.hostname == hostname)&&(identical(other.port, port) || other.port == port)&&(identical(other.username, username) || other.username == username)&&(identical(other.authMethod, authMethod) || other.authMethod == authMethod)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.color, color) || other.color == color)&&(identical(other.iconName, iconName) || other.iconName == iconName)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.sshKeyId, sshKeyId) || other.sshKeyId == sshKeyId)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.distroId, distroId) || other.distroId == distroId)&&(identical(other.distroName, distroName) || other.distroName == distroName)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.jumpHostId, jumpHostId) || other.jumpHostId == jumpHostId)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.sharedWith, sharedWith) || other.sharedWith == sharedWith)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,hostname,port,username,authMethod,notes,color,iconName,isActive,groupId,sshKeyId,sortOrder,distroId,distroName,const DeepCollectionEquality().hash(tags),jumpHostId,ownerId,sharedWith,permissions,createdAt,updatedAt]);

@override
String toString() {
  return 'ServerEntity(id: $id, name: $name, hostname: $hostname, port: $port, username: $username, authMethod: $authMethod, notes: $notes, color: $color, iconName: $iconName, isActive: $isActive, groupId: $groupId, sshKeyId: $sshKeyId, sortOrder: $sortOrder, distroId: $distroId, distroName: $distroName, tags: $tags, jumpHostId: $jumpHostId, ownerId: $ownerId, sharedWith: $sharedWith, permissions: $permissions, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ServerEntityCopyWith<$Res>  {
  factory $ServerEntityCopyWith(ServerEntity value, $Res Function(ServerEntity) _then) = _$ServerEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String hostname, int port, String username, AuthMethod authMethod, String notes, int color, String iconName, bool isActive, String? groupId, String? sshKeyId, int sortOrder, String? distroId, String? distroName, List<TagEntity> tags, String? jumpHostId, String? ownerId, String? sharedWith, String? permissions, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ServerEntityCopyWithImpl<$Res>
    implements $ServerEntityCopyWith<$Res> {
  _$ServerEntityCopyWithImpl(this._self, this._then);

  final ServerEntity _self;
  final $Res Function(ServerEntity) _then;

/// Create a copy of ServerEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? hostname = null,Object? port = null,Object? username = null,Object? authMethod = null,Object? notes = null,Object? color = null,Object? iconName = null,Object? isActive = null,Object? groupId = freezed,Object? sshKeyId = freezed,Object? sortOrder = null,Object? distroId = freezed,Object? distroName = freezed,Object? tags = null,Object? jumpHostId = freezed,Object? ownerId = freezed,Object? sharedWith = freezed,Object? permissions = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hostname: null == hostname ? _self.hostname : hostname // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,authMethod: null == authMethod ? _self.authMethod : authMethod // ignore: cast_nullable_to_non_nullable
as AuthMethod,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,iconName: null == iconName ? _self.iconName : iconName // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,sshKeyId: freezed == sshKeyId ? _self.sshKeyId : sshKeyId // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,distroId: freezed == distroId ? _self.distroId : distroId // ignore: cast_nullable_to_non_nullable
as String?,distroName: freezed == distroName ? _self.distroName : distroName // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<TagEntity>,jumpHostId: freezed == jumpHostId ? _self.jumpHostId : jumpHostId // ignore: cast_nullable_to_non_nullable
as String?,ownerId: freezed == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String?,sharedWith: freezed == sharedWith ? _self.sharedWith : sharedWith // ignore: cast_nullable_to_non_nullable
as String?,permissions: freezed == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerEntity].
extension ServerEntityPatterns on ServerEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerEntity value)  $default,){
final _that = this;
switch (_that) {
case _ServerEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ServerEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String hostname,  int port,  String username,  AuthMethod authMethod,  String notes,  int color,  String iconName,  bool isActive,  String? groupId,  String? sshKeyId,  int sortOrder,  String? distroId,  String? distroName,  List<TagEntity> tags,  String? jumpHostId,  String? ownerId,  String? sharedWith,  String? permissions,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerEntity() when $default != null:
return $default(_that.id,_that.name,_that.hostname,_that.port,_that.username,_that.authMethod,_that.notes,_that.color,_that.iconName,_that.isActive,_that.groupId,_that.sshKeyId,_that.sortOrder,_that.distroId,_that.distroName,_that.tags,_that.jumpHostId,_that.ownerId,_that.sharedWith,_that.permissions,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String hostname,  int port,  String username,  AuthMethod authMethod,  String notes,  int color,  String iconName,  bool isActive,  String? groupId,  String? sshKeyId,  int sortOrder,  String? distroId,  String? distroName,  List<TagEntity> tags,  String? jumpHostId,  String? ownerId,  String? sharedWith,  String? permissions,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ServerEntity():
return $default(_that.id,_that.name,_that.hostname,_that.port,_that.username,_that.authMethod,_that.notes,_that.color,_that.iconName,_that.isActive,_that.groupId,_that.sshKeyId,_that.sortOrder,_that.distroId,_that.distroName,_that.tags,_that.jumpHostId,_that.ownerId,_that.sharedWith,_that.permissions,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String hostname,  int port,  String username,  AuthMethod authMethod,  String notes,  int color,  String iconName,  bool isActive,  String? groupId,  String? sshKeyId,  int sortOrder,  String? distroId,  String? distroName,  List<TagEntity> tags,  String? jumpHostId,  String? ownerId,  String? sharedWith,  String? permissions,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ServerEntity() when $default != null:
return $default(_that.id,_that.name,_that.hostname,_that.port,_that.username,_that.authMethod,_that.notes,_that.color,_that.iconName,_that.isActive,_that.groupId,_that.sshKeyId,_that.sortOrder,_that.distroId,_that.distroName,_that.tags,_that.jumpHostId,_that.ownerId,_that.sharedWith,_that.permissions,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServerEntity implements ServerEntity {
  const _ServerEntity({required this.id, required this.name, required this.hostname, required this.port, required this.username, required this.authMethod, this.notes = '', required this.color, this.iconName = 'server', this.isActive = true, this.groupId, this.sshKeyId, this.sortOrder = 0, this.distroId, this.distroName, final  List<TagEntity> tags = const [], this.jumpHostId, this.ownerId, this.sharedWith, this.permissions, required this.createdAt, required this.updatedAt}): _tags = tags;
  factory _ServerEntity.fromJson(Map<String, dynamic> json) => _$ServerEntityFromJson(json);

@override final  String id;
@override final  String name;
@override final  String hostname;
@override final  int port;
@override final  String username;
@override final  AuthMethod authMethod;
@override@JsonKey() final  String notes;
@override final  int color;
@override@JsonKey() final  String iconName;
@override@JsonKey() final  bool isActive;
@override final  String? groupId;
@override final  String? sshKeyId;
@override@JsonKey() final  int sortOrder;
@override final  String? distroId;
@override final  String? distroName;
 final  List<TagEntity> _tags;
@override@JsonKey() List<TagEntity> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  String? jumpHostId;
@override final  String? ownerId;
@override final  String? sharedWith;
@override final  String? permissions;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of ServerEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerEntityCopyWith<_ServerEntity> get copyWith => __$ServerEntityCopyWithImpl<_ServerEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServerEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.hostname, hostname) || other.hostname == hostname)&&(identical(other.port, port) || other.port == port)&&(identical(other.username, username) || other.username == username)&&(identical(other.authMethod, authMethod) || other.authMethod == authMethod)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.color, color) || other.color == color)&&(identical(other.iconName, iconName) || other.iconName == iconName)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.sshKeyId, sshKeyId) || other.sshKeyId == sshKeyId)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.distroId, distroId) || other.distroId == distroId)&&(identical(other.distroName, distroName) || other.distroName == distroName)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.jumpHostId, jumpHostId) || other.jumpHostId == jumpHostId)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.sharedWith, sharedWith) || other.sharedWith == sharedWith)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,hostname,port,username,authMethod,notes,color,iconName,isActive,groupId,sshKeyId,sortOrder,distroId,distroName,const DeepCollectionEquality().hash(_tags),jumpHostId,ownerId,sharedWith,permissions,createdAt,updatedAt]);

@override
String toString() {
  return 'ServerEntity(id: $id, name: $name, hostname: $hostname, port: $port, username: $username, authMethod: $authMethod, notes: $notes, color: $color, iconName: $iconName, isActive: $isActive, groupId: $groupId, sshKeyId: $sshKeyId, sortOrder: $sortOrder, distroId: $distroId, distroName: $distroName, tags: $tags, jumpHostId: $jumpHostId, ownerId: $ownerId, sharedWith: $sharedWith, permissions: $permissions, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ServerEntityCopyWith<$Res> implements $ServerEntityCopyWith<$Res> {
  factory _$ServerEntityCopyWith(_ServerEntity value, $Res Function(_ServerEntity) _then) = __$ServerEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String hostname, int port, String username, AuthMethod authMethod, String notes, int color, String iconName, bool isActive, String? groupId, String? sshKeyId, int sortOrder, String? distroId, String? distroName, List<TagEntity> tags, String? jumpHostId, String? ownerId, String? sharedWith, String? permissions, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ServerEntityCopyWithImpl<$Res>
    implements _$ServerEntityCopyWith<$Res> {
  __$ServerEntityCopyWithImpl(this._self, this._then);

  final _ServerEntity _self;
  final $Res Function(_ServerEntity) _then;

/// Create a copy of ServerEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? hostname = null,Object? port = null,Object? username = null,Object? authMethod = null,Object? notes = null,Object? color = null,Object? iconName = null,Object? isActive = null,Object? groupId = freezed,Object? sshKeyId = freezed,Object? sortOrder = null,Object? distroId = freezed,Object? distroName = freezed,Object? tags = null,Object? jumpHostId = freezed,Object? ownerId = freezed,Object? sharedWith = freezed,Object? permissions = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ServerEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hostname: null == hostname ? _self.hostname : hostname // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,authMethod: null == authMethod ? _self.authMethod : authMethod // ignore: cast_nullable_to_non_nullable
as AuthMethod,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,iconName: null == iconName ? _self.iconName : iconName // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,sshKeyId: freezed == sshKeyId ? _self.sshKeyId : sshKeyId // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,distroId: freezed == distroId ? _self.distroId : distroId // ignore: cast_nullable_to_non_nullable
as String?,distroName: freezed == distroName ? _self.distroName : distroName // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<TagEntity>,jumpHostId: freezed == jumpHostId ? _self.jumpHostId : jumpHostId // ignore: cast_nullable_to_non_nullable
as String?,ownerId: freezed == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String?,sharedWith: freezed == sharedWith ? _self.sharedWith : sharedWith // ignore: cast_nullable_to_non_nullable
as String?,permissions: freezed == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
