// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'snippet_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SnippetEntity {

 String get id; String get name; String get content; String get language; String get description; String? get groupId; int get sortOrder; List<TagEntity> get tags; List<SnippetVariableEntity> get variables; String? get ownerId; String? get sharedWith; String? get permissions; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of SnippetEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnippetEntityCopyWith<SnippetEntity> get copyWith => _$SnippetEntityCopyWithImpl<SnippetEntity>(this as SnippetEntity, _$identity);

  /// Serializes this SnippetEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SnippetEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.content, content) || other.content == content)&&(identical(other.language, language) || other.language == language)&&(identical(other.description, description) || other.description == description)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.variables, variables)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.sharedWith, sharedWith) || other.sharedWith == sharedWith)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,content,language,description,groupId,sortOrder,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(variables),ownerId,sharedWith,permissions,createdAt,updatedAt);

@override
String toString() {
  return 'SnippetEntity(id: $id, name: $name, content: $content, language: $language, description: $description, groupId: $groupId, sortOrder: $sortOrder, tags: $tags, variables: $variables, ownerId: $ownerId, sharedWith: $sharedWith, permissions: $permissions, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SnippetEntityCopyWith<$Res>  {
  factory $SnippetEntityCopyWith(SnippetEntity value, $Res Function(SnippetEntity) _then) = _$SnippetEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String content, String language, String description, String? groupId, int sortOrder, List<TagEntity> tags, List<SnippetVariableEntity> variables, String? ownerId, String? sharedWith, String? permissions, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$SnippetEntityCopyWithImpl<$Res>
    implements $SnippetEntityCopyWith<$Res> {
  _$SnippetEntityCopyWithImpl(this._self, this._then);

  final SnippetEntity _self;
  final $Res Function(SnippetEntity) _then;

/// Create a copy of SnippetEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? content = null,Object? language = null,Object? description = null,Object? groupId = freezed,Object? sortOrder = null,Object? tags = null,Object? variables = null,Object? ownerId = freezed,Object? sharedWith = freezed,Object? permissions = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<TagEntity>,variables: null == variables ? _self.variables : variables // ignore: cast_nullable_to_non_nullable
as List<SnippetVariableEntity>,ownerId: freezed == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String?,sharedWith: freezed == sharedWith ? _self.sharedWith : sharedWith // ignore: cast_nullable_to_non_nullable
as String?,permissions: freezed == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SnippetEntity].
extension SnippetEntityPatterns on SnippetEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SnippetEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SnippetEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SnippetEntity value)  $default,){
final _that = this;
switch (_that) {
case _SnippetEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SnippetEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SnippetEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String content,  String language,  String description,  String? groupId,  int sortOrder,  List<TagEntity> tags,  List<SnippetVariableEntity> variables,  String? ownerId,  String? sharedWith,  String? permissions,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SnippetEntity() when $default != null:
return $default(_that.id,_that.name,_that.content,_that.language,_that.description,_that.groupId,_that.sortOrder,_that.tags,_that.variables,_that.ownerId,_that.sharedWith,_that.permissions,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String content,  String language,  String description,  String? groupId,  int sortOrder,  List<TagEntity> tags,  List<SnippetVariableEntity> variables,  String? ownerId,  String? sharedWith,  String? permissions,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SnippetEntity():
return $default(_that.id,_that.name,_that.content,_that.language,_that.description,_that.groupId,_that.sortOrder,_that.tags,_that.variables,_that.ownerId,_that.sharedWith,_that.permissions,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String content,  String language,  String description,  String? groupId,  int sortOrder,  List<TagEntity> tags,  List<SnippetVariableEntity> variables,  String? ownerId,  String? sharedWith,  String? permissions,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SnippetEntity() when $default != null:
return $default(_that.id,_that.name,_that.content,_that.language,_that.description,_that.groupId,_that.sortOrder,_that.tags,_that.variables,_that.ownerId,_that.sharedWith,_that.permissions,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SnippetEntity implements SnippetEntity {
  const _SnippetEntity({required this.id, required this.name, required this.content, this.language = 'bash', this.description = '', this.groupId, this.sortOrder = 0, final  List<TagEntity> tags = const [], final  List<SnippetVariableEntity> variables = const [], this.ownerId, this.sharedWith, this.permissions, required this.createdAt, required this.updatedAt}): _tags = tags,_variables = variables;
  factory _SnippetEntity.fromJson(Map<String, dynamic> json) => _$SnippetEntityFromJson(json);

@override final  String id;
@override final  String name;
@override final  String content;
@override@JsonKey() final  String language;
@override@JsonKey() final  String description;
@override final  String? groupId;
@override@JsonKey() final  int sortOrder;
 final  List<TagEntity> _tags;
@override@JsonKey() List<TagEntity> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  List<SnippetVariableEntity> _variables;
@override@JsonKey() List<SnippetVariableEntity> get variables {
  if (_variables is EqualUnmodifiableListView) return _variables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_variables);
}

@override final  String? ownerId;
@override final  String? sharedWith;
@override final  String? permissions;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of SnippetEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SnippetEntityCopyWith<_SnippetEntity> get copyWith => __$SnippetEntityCopyWithImpl<_SnippetEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SnippetEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SnippetEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.content, content) || other.content == content)&&(identical(other.language, language) || other.language == language)&&(identical(other.description, description) || other.description == description)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._variables, _variables)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.sharedWith, sharedWith) || other.sharedWith == sharedWith)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,content,language,description,groupId,sortOrder,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_variables),ownerId,sharedWith,permissions,createdAt,updatedAt);

@override
String toString() {
  return 'SnippetEntity(id: $id, name: $name, content: $content, language: $language, description: $description, groupId: $groupId, sortOrder: $sortOrder, tags: $tags, variables: $variables, ownerId: $ownerId, sharedWith: $sharedWith, permissions: $permissions, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SnippetEntityCopyWith<$Res> implements $SnippetEntityCopyWith<$Res> {
  factory _$SnippetEntityCopyWith(_SnippetEntity value, $Res Function(_SnippetEntity) _then) = __$SnippetEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String content, String language, String description, String? groupId, int sortOrder, List<TagEntity> tags, List<SnippetVariableEntity> variables, String? ownerId, String? sharedWith, String? permissions, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$SnippetEntityCopyWithImpl<$Res>
    implements _$SnippetEntityCopyWith<$Res> {
  __$SnippetEntityCopyWithImpl(this._self, this._then);

  final _SnippetEntity _self;
  final $Res Function(_SnippetEntity) _then;

/// Create a copy of SnippetEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? content = null,Object? language = null,Object? description = null,Object? groupId = freezed,Object? sortOrder = null,Object? tags = null,Object? variables = null,Object? ownerId = freezed,Object? sharedWith = freezed,Object? permissions = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_SnippetEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<TagEntity>,variables: null == variables ? _self._variables : variables // ignore: cast_nullable_to_non_nullable
as List<SnippetVariableEntity>,ownerId: freezed == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String?,sharedWith: freezed == sharedWith ? _self.sharedWith : sharedWith // ignore: cast_nullable_to_non_nullable
as String?,permissions: freezed == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$SnippetVariableEntity {

 String get id; String get name; String get defaultValue; String get description; int get sortOrder;
/// Create a copy of SnippetVariableEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnippetVariableEntityCopyWith<SnippetVariableEntity> get copyWith => _$SnippetVariableEntityCopyWithImpl<SnippetVariableEntity>(this as SnippetVariableEntity, _$identity);

  /// Serializes this SnippetVariableEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SnippetVariableEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.description, description) || other.description == description)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,defaultValue,description,sortOrder);

@override
String toString() {
  return 'SnippetVariableEntity(id: $id, name: $name, defaultValue: $defaultValue, description: $description, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $SnippetVariableEntityCopyWith<$Res>  {
  factory $SnippetVariableEntityCopyWith(SnippetVariableEntity value, $Res Function(SnippetVariableEntity) _then) = _$SnippetVariableEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String defaultValue, String description, int sortOrder
});




}
/// @nodoc
class _$SnippetVariableEntityCopyWithImpl<$Res>
    implements $SnippetVariableEntityCopyWith<$Res> {
  _$SnippetVariableEntityCopyWithImpl(this._self, this._then);

  final SnippetVariableEntity _self;
  final $Res Function(SnippetVariableEntity) _then;

/// Create a copy of SnippetVariableEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? defaultValue = null,Object? description = null,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,defaultValue: null == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SnippetVariableEntity].
extension SnippetVariableEntityPatterns on SnippetVariableEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SnippetVariableEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SnippetVariableEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SnippetVariableEntity value)  $default,){
final _that = this;
switch (_that) {
case _SnippetVariableEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SnippetVariableEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SnippetVariableEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String defaultValue,  String description,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SnippetVariableEntity() when $default != null:
return $default(_that.id,_that.name,_that.defaultValue,_that.description,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String defaultValue,  String description,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _SnippetVariableEntity():
return $default(_that.id,_that.name,_that.defaultValue,_that.description,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String defaultValue,  String description,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _SnippetVariableEntity() when $default != null:
return $default(_that.id,_that.name,_that.defaultValue,_that.description,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SnippetVariableEntity implements SnippetVariableEntity {
  const _SnippetVariableEntity({required this.id, required this.name, this.defaultValue = '', this.description = '', this.sortOrder = 0});
  factory _SnippetVariableEntity.fromJson(Map<String, dynamic> json) => _$SnippetVariableEntityFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  String defaultValue;
@override@JsonKey() final  String description;
@override@JsonKey() final  int sortOrder;

/// Create a copy of SnippetVariableEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SnippetVariableEntityCopyWith<_SnippetVariableEntity> get copyWith => __$SnippetVariableEntityCopyWithImpl<_SnippetVariableEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SnippetVariableEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SnippetVariableEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.description, description) || other.description == description)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,defaultValue,description,sortOrder);

@override
String toString() {
  return 'SnippetVariableEntity(id: $id, name: $name, defaultValue: $defaultValue, description: $description, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$SnippetVariableEntityCopyWith<$Res> implements $SnippetVariableEntityCopyWith<$Res> {
  factory _$SnippetVariableEntityCopyWith(_SnippetVariableEntity value, $Res Function(_SnippetVariableEntity) _then) = __$SnippetVariableEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String defaultValue, String description, int sortOrder
});




}
/// @nodoc
class __$SnippetVariableEntityCopyWithImpl<$Res>
    implements _$SnippetVariableEntityCopyWith<$Res> {
  __$SnippetVariableEntityCopyWithImpl(this._self, this._then);

  final _SnippetVariableEntity _self;
  final $Res Function(_SnippetVariableEntity) _then;

/// Create a copy of SnippetVariableEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? defaultValue = null,Object? description = null,Object? sortOrder = null,}) {
  return _then(_SnippetVariableEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,defaultValue: null == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
