// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ServerFilter {

 String get searchQuery; String? get groupId; List<String> get tagIds; bool? get isActive;
/// Create a copy of ServerFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerFilterCopyWith<ServerFilter> get copyWith => _$ServerFilterCopyWithImpl<ServerFilter>(this as ServerFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerFilter&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&const DeepCollectionEquality().equals(other.tagIds, tagIds)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,searchQuery,groupId,const DeepCollectionEquality().hash(tagIds),isActive);

@override
String toString() {
  return 'ServerFilter(searchQuery: $searchQuery, groupId: $groupId, tagIds: $tagIds, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $ServerFilterCopyWith<$Res>  {
  factory $ServerFilterCopyWith(ServerFilter value, $Res Function(ServerFilter) _then) = _$ServerFilterCopyWithImpl;
@useResult
$Res call({
 String searchQuery, String? groupId, List<String> tagIds, bool? isActive
});




}
/// @nodoc
class _$ServerFilterCopyWithImpl<$Res>
    implements $ServerFilterCopyWith<$Res> {
  _$ServerFilterCopyWithImpl(this._self, this._then);

  final ServerFilter _self;
  final $Res Function(ServerFilter) _then;

/// Create a copy of ServerFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? searchQuery = null,Object? groupId = freezed,Object? tagIds = null,Object? isActive = freezed,}) {
  return _then(_self.copyWith(
searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,tagIds: null == tagIds ? _self.tagIds : tagIds // ignore: cast_nullable_to_non_nullable
as List<String>,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerFilter].
extension ServerFilterPatterns on ServerFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerFilter value)  $default,){
final _that = this;
switch (_that) {
case _ServerFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerFilter value)?  $default,){
final _that = this;
switch (_that) {
case _ServerFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String searchQuery,  String? groupId,  List<String> tagIds,  bool? isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerFilter() when $default != null:
return $default(_that.searchQuery,_that.groupId,_that.tagIds,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String searchQuery,  String? groupId,  List<String> tagIds,  bool? isActive)  $default,) {final _that = this;
switch (_that) {
case _ServerFilter():
return $default(_that.searchQuery,_that.groupId,_that.tagIds,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String searchQuery,  String? groupId,  List<String> tagIds,  bool? isActive)?  $default,) {final _that = this;
switch (_that) {
case _ServerFilter() when $default != null:
return $default(_that.searchQuery,_that.groupId,_that.tagIds,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _ServerFilter implements ServerFilter {
  const _ServerFilter({this.searchQuery = '', this.groupId, final  List<String> tagIds = const [], this.isActive}): _tagIds = tagIds;
  

@override@JsonKey() final  String searchQuery;
@override final  String? groupId;
 final  List<String> _tagIds;
@override@JsonKey() List<String> get tagIds {
  if (_tagIds is EqualUnmodifiableListView) return _tagIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tagIds);
}

@override final  bool? isActive;

/// Create a copy of ServerFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerFilterCopyWith<_ServerFilter> get copyWith => __$ServerFilterCopyWithImpl<_ServerFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerFilter&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&const DeepCollectionEquality().equals(other._tagIds, _tagIds)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,searchQuery,groupId,const DeepCollectionEquality().hash(_tagIds),isActive);

@override
String toString() {
  return 'ServerFilter(searchQuery: $searchQuery, groupId: $groupId, tagIds: $tagIds, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ServerFilterCopyWith<$Res> implements $ServerFilterCopyWith<$Res> {
  factory _$ServerFilterCopyWith(_ServerFilter value, $Res Function(_ServerFilter) _then) = __$ServerFilterCopyWithImpl;
@override @useResult
$Res call({
 String searchQuery, String? groupId, List<String> tagIds, bool? isActive
});




}
/// @nodoc
class __$ServerFilterCopyWithImpl<$Res>
    implements _$ServerFilterCopyWith<$Res> {
  __$ServerFilterCopyWithImpl(this._self, this._then);

  final _ServerFilter _self;
  final $Res Function(_ServerFilter) _then;

/// Create a copy of ServerFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? searchQuery = null,Object? groupId = freezed,Object? tagIds = null,Object? isActive = freezed,}) {
  return _then(_ServerFilter(
searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,tagIds: null == tagIds ? _self._tagIds : tagIds // ignore: cast_nullable_to_non_nullable
as List<String>,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
