// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sftp_pane_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SftpPaneState {

 SftpPaneSource get source; String get currentPath; List<SftpEntry> get entries; bool get isLoading; String? get error; Set<String> get selectedPaths; SortField get sortField; bool get sortAscending; bool get showHidden;
/// Create a copy of SftpPaneState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SftpPaneStateCopyWith<SftpPaneState> get copyWith => _$SftpPaneStateCopyWithImpl<SftpPaneState>(this as SftpPaneState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SftpPaneState&&(identical(other.source, source) || other.source == source)&&(identical(other.currentPath, currentPath) || other.currentPath == currentPath)&&const DeepCollectionEquality().equals(other.entries, entries)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other.selectedPaths, selectedPaths)&&(identical(other.sortField, sortField) || other.sortField == sortField)&&(identical(other.sortAscending, sortAscending) || other.sortAscending == sortAscending)&&(identical(other.showHidden, showHidden) || other.showHidden == showHidden));
}


@override
int get hashCode => Object.hash(runtimeType,source,currentPath,const DeepCollectionEquality().hash(entries),isLoading,error,const DeepCollectionEquality().hash(selectedPaths),sortField,sortAscending,showHidden);

@override
String toString() {
  return 'SftpPaneState(source: $source, currentPath: $currentPath, entries: $entries, isLoading: $isLoading, error: $error, selectedPaths: $selectedPaths, sortField: $sortField, sortAscending: $sortAscending, showHidden: $showHidden)';
}


}

/// @nodoc
abstract mixin class $SftpPaneStateCopyWith<$Res>  {
  factory $SftpPaneStateCopyWith(SftpPaneState value, $Res Function(SftpPaneState) _then) = _$SftpPaneStateCopyWithImpl;
@useResult
$Res call({
 SftpPaneSource source, String currentPath, List<SftpEntry> entries, bool isLoading, String? error, Set<String> selectedPaths, SortField sortField, bool sortAscending, bool showHidden
});


$SftpPaneSourceCopyWith<$Res> get source;

}
/// @nodoc
class _$SftpPaneStateCopyWithImpl<$Res>
    implements $SftpPaneStateCopyWith<$Res> {
  _$SftpPaneStateCopyWithImpl(this._self, this._then);

  final SftpPaneState _self;
  final $Res Function(SftpPaneState) _then;

/// Create a copy of SftpPaneState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? source = null,Object? currentPath = null,Object? entries = null,Object? isLoading = null,Object? error = freezed,Object? selectedPaths = null,Object? sortField = null,Object? sortAscending = null,Object? showHidden = null,}) {
  return _then(_self.copyWith(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as SftpPaneSource,currentPath: null == currentPath ? _self.currentPath : currentPath // ignore: cast_nullable_to_non_nullable
as String,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<SftpEntry>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,selectedPaths: null == selectedPaths ? _self.selectedPaths : selectedPaths // ignore: cast_nullable_to_non_nullable
as Set<String>,sortField: null == sortField ? _self.sortField : sortField // ignore: cast_nullable_to_non_nullable
as SortField,sortAscending: null == sortAscending ? _self.sortAscending : sortAscending // ignore: cast_nullable_to_non_nullable
as bool,showHidden: null == showHidden ? _self.showHidden : showHidden // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SftpPaneState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SftpPaneSourceCopyWith<$Res> get source {
  
  return $SftpPaneSourceCopyWith<$Res>(_self.source, (value) {
    return _then(_self.copyWith(source: value));
  });
}
}


/// Adds pattern-matching-related methods to [SftpPaneState].
extension SftpPaneStatePatterns on SftpPaneState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SftpPaneState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SftpPaneState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SftpPaneState value)  $default,){
final _that = this;
switch (_that) {
case _SftpPaneState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SftpPaneState value)?  $default,){
final _that = this;
switch (_that) {
case _SftpPaneState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SftpPaneSource source,  String currentPath,  List<SftpEntry> entries,  bool isLoading,  String? error,  Set<String> selectedPaths,  SortField sortField,  bool sortAscending,  bool showHidden)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SftpPaneState() when $default != null:
return $default(_that.source,_that.currentPath,_that.entries,_that.isLoading,_that.error,_that.selectedPaths,_that.sortField,_that.sortAscending,_that.showHidden);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SftpPaneSource source,  String currentPath,  List<SftpEntry> entries,  bool isLoading,  String? error,  Set<String> selectedPaths,  SortField sortField,  bool sortAscending,  bool showHidden)  $default,) {final _that = this;
switch (_that) {
case _SftpPaneState():
return $default(_that.source,_that.currentPath,_that.entries,_that.isLoading,_that.error,_that.selectedPaths,_that.sortField,_that.sortAscending,_that.showHidden);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SftpPaneSource source,  String currentPath,  List<SftpEntry> entries,  bool isLoading,  String? error,  Set<String> selectedPaths,  SortField sortField,  bool sortAscending,  bool showHidden)?  $default,) {final _that = this;
switch (_that) {
case _SftpPaneState() when $default != null:
return $default(_that.source,_that.currentPath,_that.entries,_that.isLoading,_that.error,_that.selectedPaths,_that.sortField,_that.sortAscending,_that.showHidden);case _:
  return null;

}
}

}

/// @nodoc


class _SftpPaneState implements SftpPaneState {
  const _SftpPaneState({required this.source, required this.currentPath, final  List<SftpEntry> entries = const [], this.isLoading = false, this.error, final  Set<String> selectedPaths = const {}, this.sortField = SortField.name, this.sortAscending = true, this.showHidden = false}): _entries = entries,_selectedPaths = selectedPaths;
  

@override final  SftpPaneSource source;
@override final  String currentPath;
 final  List<SftpEntry> _entries;
@override@JsonKey() List<SftpEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

@override@JsonKey() final  bool isLoading;
@override final  String? error;
 final  Set<String> _selectedPaths;
@override@JsonKey() Set<String> get selectedPaths {
  if (_selectedPaths is EqualUnmodifiableSetView) return _selectedPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedPaths);
}

@override@JsonKey() final  SortField sortField;
@override@JsonKey() final  bool sortAscending;
@override@JsonKey() final  bool showHidden;

/// Create a copy of SftpPaneState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SftpPaneStateCopyWith<_SftpPaneState> get copyWith => __$SftpPaneStateCopyWithImpl<_SftpPaneState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SftpPaneState&&(identical(other.source, source) || other.source == source)&&(identical(other.currentPath, currentPath) || other.currentPath == currentPath)&&const DeepCollectionEquality().equals(other._entries, _entries)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other._selectedPaths, _selectedPaths)&&(identical(other.sortField, sortField) || other.sortField == sortField)&&(identical(other.sortAscending, sortAscending) || other.sortAscending == sortAscending)&&(identical(other.showHidden, showHidden) || other.showHidden == showHidden));
}


@override
int get hashCode => Object.hash(runtimeType,source,currentPath,const DeepCollectionEquality().hash(_entries),isLoading,error,const DeepCollectionEquality().hash(_selectedPaths),sortField,sortAscending,showHidden);

@override
String toString() {
  return 'SftpPaneState(source: $source, currentPath: $currentPath, entries: $entries, isLoading: $isLoading, error: $error, selectedPaths: $selectedPaths, sortField: $sortField, sortAscending: $sortAscending, showHidden: $showHidden)';
}


}

/// @nodoc
abstract mixin class _$SftpPaneStateCopyWith<$Res> implements $SftpPaneStateCopyWith<$Res> {
  factory _$SftpPaneStateCopyWith(_SftpPaneState value, $Res Function(_SftpPaneState) _then) = __$SftpPaneStateCopyWithImpl;
@override @useResult
$Res call({
 SftpPaneSource source, String currentPath, List<SftpEntry> entries, bool isLoading, String? error, Set<String> selectedPaths, SortField sortField, bool sortAscending, bool showHidden
});


@override $SftpPaneSourceCopyWith<$Res> get source;

}
/// @nodoc
class __$SftpPaneStateCopyWithImpl<$Res>
    implements _$SftpPaneStateCopyWith<$Res> {
  __$SftpPaneStateCopyWithImpl(this._self, this._then);

  final _SftpPaneState _self;
  final $Res Function(_SftpPaneState) _then;

/// Create a copy of SftpPaneState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? source = null,Object? currentPath = null,Object? entries = null,Object? isLoading = null,Object? error = freezed,Object? selectedPaths = null,Object? sortField = null,Object? sortAscending = null,Object? showHidden = null,}) {
  return _then(_SftpPaneState(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as SftpPaneSource,currentPath: null == currentPath ? _self.currentPath : currentPath // ignore: cast_nullable_to_non_nullable
as String,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<SftpEntry>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,selectedPaths: null == selectedPaths ? _self._selectedPaths : selectedPaths // ignore: cast_nullable_to_non_nullable
as Set<String>,sortField: null == sortField ? _self.sortField : sortField // ignore: cast_nullable_to_non_nullable
as SortField,sortAscending: null == sortAscending ? _self.sortAscending : sortAscending // ignore: cast_nullable_to_non_nullable
as bool,showHidden: null == showHidden ? _self.showHidden : showHidden // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SftpPaneState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SftpPaneSourceCopyWith<$Res> get source {
  
  return $SftpPaneSourceCopyWith<$Res>(_self.source, (value) {
    return _then(_self.copyWith(source: value));
  });
}
}

// dart format on
