// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sftp_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SftpEntry {

 String get name; String get path; SftpEntryType get type; int get size; DateTime get modified; int? get permissions; String? get owner; String? get group; String? get linkTarget;
/// Create a copy of SftpEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SftpEntryCopyWith<SftpEntry> get copyWith => _$SftpEntryCopyWithImpl<SftpEntry>(this as SftpEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SftpEntry&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.type, type) || other.type == type)&&(identical(other.size, size) || other.size == size)&&(identical(other.modified, modified) || other.modified == modified)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.group, group) || other.group == group)&&(identical(other.linkTarget, linkTarget) || other.linkTarget == linkTarget));
}


@override
int get hashCode => Object.hash(runtimeType,name,path,type,size,modified,permissions,owner,group,linkTarget);

@override
String toString() {
  return 'SftpEntry(name: $name, path: $path, type: $type, size: $size, modified: $modified, permissions: $permissions, owner: $owner, group: $group, linkTarget: $linkTarget)';
}


}

/// @nodoc
abstract mixin class $SftpEntryCopyWith<$Res>  {
  factory $SftpEntryCopyWith(SftpEntry value, $Res Function(SftpEntry) _then) = _$SftpEntryCopyWithImpl;
@useResult
$Res call({
 String name, String path, SftpEntryType type, int size, DateTime modified, int? permissions, String? owner, String? group, String? linkTarget
});




}
/// @nodoc
class _$SftpEntryCopyWithImpl<$Res>
    implements $SftpEntryCopyWith<$Res> {
  _$SftpEntryCopyWithImpl(this._self, this._then);

  final SftpEntry _self;
  final $Res Function(SftpEntry) _then;

/// Create a copy of SftpEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? path = null,Object? type = null,Object? size = null,Object? modified = null,Object? permissions = freezed,Object? owner = freezed,Object? group = freezed,Object? linkTarget = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SftpEntryType,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,modified: null == modified ? _self.modified : modified // ignore: cast_nullable_to_non_nullable
as DateTime,permissions: freezed == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as int?,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,linkTarget: freezed == linkTarget ? _self.linkTarget : linkTarget // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SftpEntry].
extension SftpEntryPatterns on SftpEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SftpEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SftpEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SftpEntry value)  $default,){
final _that = this;
switch (_that) {
case _SftpEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SftpEntry value)?  $default,){
final _that = this;
switch (_that) {
case _SftpEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String path,  SftpEntryType type,  int size,  DateTime modified,  int? permissions,  String? owner,  String? group,  String? linkTarget)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SftpEntry() when $default != null:
return $default(_that.name,_that.path,_that.type,_that.size,_that.modified,_that.permissions,_that.owner,_that.group,_that.linkTarget);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String path,  SftpEntryType type,  int size,  DateTime modified,  int? permissions,  String? owner,  String? group,  String? linkTarget)  $default,) {final _that = this;
switch (_that) {
case _SftpEntry():
return $default(_that.name,_that.path,_that.type,_that.size,_that.modified,_that.permissions,_that.owner,_that.group,_that.linkTarget);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String path,  SftpEntryType type,  int size,  DateTime modified,  int? permissions,  String? owner,  String? group,  String? linkTarget)?  $default,) {final _that = this;
switch (_that) {
case _SftpEntry() when $default != null:
return $default(_that.name,_that.path,_that.type,_that.size,_that.modified,_that.permissions,_that.owner,_that.group,_that.linkTarget);case _:
  return null;

}
}

}

/// @nodoc


class _SftpEntry extends SftpEntry {
  const _SftpEntry({required this.name, required this.path, required this.type, required this.size, required this.modified, this.permissions, this.owner, this.group, this.linkTarget}): super._();
  

@override final  String name;
@override final  String path;
@override final  SftpEntryType type;
@override final  int size;
@override final  DateTime modified;
@override final  int? permissions;
@override final  String? owner;
@override final  String? group;
@override final  String? linkTarget;

/// Create a copy of SftpEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SftpEntryCopyWith<_SftpEntry> get copyWith => __$SftpEntryCopyWithImpl<_SftpEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SftpEntry&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.type, type) || other.type == type)&&(identical(other.size, size) || other.size == size)&&(identical(other.modified, modified) || other.modified == modified)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.group, group) || other.group == group)&&(identical(other.linkTarget, linkTarget) || other.linkTarget == linkTarget));
}


@override
int get hashCode => Object.hash(runtimeType,name,path,type,size,modified,permissions,owner,group,linkTarget);

@override
String toString() {
  return 'SftpEntry(name: $name, path: $path, type: $type, size: $size, modified: $modified, permissions: $permissions, owner: $owner, group: $group, linkTarget: $linkTarget)';
}


}

/// @nodoc
abstract mixin class _$SftpEntryCopyWith<$Res> implements $SftpEntryCopyWith<$Res> {
  factory _$SftpEntryCopyWith(_SftpEntry value, $Res Function(_SftpEntry) _then) = __$SftpEntryCopyWithImpl;
@override @useResult
$Res call({
 String name, String path, SftpEntryType type, int size, DateTime modified, int? permissions, String? owner, String? group, String? linkTarget
});




}
/// @nodoc
class __$SftpEntryCopyWithImpl<$Res>
    implements _$SftpEntryCopyWith<$Res> {
  __$SftpEntryCopyWithImpl(this._self, this._then);

  final _SftpEntry _self;
  final $Res Function(_SftpEntry) _then;

/// Create a copy of SftpEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? path = null,Object? type = null,Object? size = null,Object? modified = null,Object? permissions = freezed,Object? owner = freezed,Object? group = freezed,Object? linkTarget = freezed,}) {
  return _then(_SftpEntry(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SftpEntryType,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,modified: null == modified ? _self.modified : modified // ignore: cast_nullable_to_non_nullable
as DateTime,permissions: freezed == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as int?,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,linkTarget: freezed == linkTarget ? _self.linkTarget : linkTarget // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
