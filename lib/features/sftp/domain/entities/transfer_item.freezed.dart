// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransferItem {

 String get id; String get sourcePath; String get destinationPath; TransferDirection get direction; TransferStatus get status; int get totalBytes; int get transferredBytes; String? get sourceServerId; String? get destinationServerId; String? get error; DateTime? get startedAt; DateTime? get completedAt;
/// Create a copy of TransferItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferItemCopyWith<TransferItem> get copyWith => _$TransferItemCopyWithImpl<TransferItem>(this as TransferItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferItem&&(identical(other.id, id) || other.id == id)&&(identical(other.sourcePath, sourcePath) || other.sourcePath == sourcePath)&&(identical(other.destinationPath, destinationPath) || other.destinationPath == destinationPath)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalBytes, totalBytes) || other.totalBytes == totalBytes)&&(identical(other.transferredBytes, transferredBytes) || other.transferredBytes == transferredBytes)&&(identical(other.sourceServerId, sourceServerId) || other.sourceServerId == sourceServerId)&&(identical(other.destinationServerId, destinationServerId) || other.destinationServerId == destinationServerId)&&(identical(other.error, error) || other.error == error)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,sourcePath,destinationPath,direction,status,totalBytes,transferredBytes,sourceServerId,destinationServerId,error,startedAt,completedAt);

@override
String toString() {
  return 'TransferItem(id: $id, sourcePath: $sourcePath, destinationPath: $destinationPath, direction: $direction, status: $status, totalBytes: $totalBytes, transferredBytes: $transferredBytes, sourceServerId: $sourceServerId, destinationServerId: $destinationServerId, error: $error, startedAt: $startedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $TransferItemCopyWith<$Res>  {
  factory $TransferItemCopyWith(TransferItem value, $Res Function(TransferItem) _then) = _$TransferItemCopyWithImpl;
@useResult
$Res call({
 String id, String sourcePath, String destinationPath, TransferDirection direction, TransferStatus status, int totalBytes, int transferredBytes, String? sourceServerId, String? destinationServerId, String? error, DateTime? startedAt, DateTime? completedAt
});




}
/// @nodoc
class _$TransferItemCopyWithImpl<$Res>
    implements $TransferItemCopyWith<$Res> {
  _$TransferItemCopyWithImpl(this._self, this._then);

  final TransferItem _self;
  final $Res Function(TransferItem) _then;

/// Create a copy of TransferItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourcePath = null,Object? destinationPath = null,Object? direction = null,Object? status = null,Object? totalBytes = null,Object? transferredBytes = null,Object? sourceServerId = freezed,Object? destinationServerId = freezed,Object? error = freezed,Object? startedAt = freezed,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourcePath: null == sourcePath ? _self.sourcePath : sourcePath // ignore: cast_nullable_to_non_nullable
as String,destinationPath: null == destinationPath ? _self.destinationPath : destinationPath // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TransferDirection,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransferStatus,totalBytes: null == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int,transferredBytes: null == transferredBytes ? _self.transferredBytes : transferredBytes // ignore: cast_nullable_to_non_nullable
as int,sourceServerId: freezed == sourceServerId ? _self.sourceServerId : sourceServerId // ignore: cast_nullable_to_non_nullable
as String?,destinationServerId: freezed == destinationServerId ? _self.destinationServerId : destinationServerId // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferItem].
extension TransferItemPatterns on TransferItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferItem value)  $default,){
final _that = this;
switch (_that) {
case _TransferItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferItem value)?  $default,){
final _that = this;
switch (_that) {
case _TransferItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sourcePath,  String destinationPath,  TransferDirection direction,  TransferStatus status,  int totalBytes,  int transferredBytes,  String? sourceServerId,  String? destinationServerId,  String? error,  DateTime? startedAt,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferItem() when $default != null:
return $default(_that.id,_that.sourcePath,_that.destinationPath,_that.direction,_that.status,_that.totalBytes,_that.transferredBytes,_that.sourceServerId,_that.destinationServerId,_that.error,_that.startedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sourcePath,  String destinationPath,  TransferDirection direction,  TransferStatus status,  int totalBytes,  int transferredBytes,  String? sourceServerId,  String? destinationServerId,  String? error,  DateTime? startedAt,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _TransferItem():
return $default(_that.id,_that.sourcePath,_that.destinationPath,_that.direction,_that.status,_that.totalBytes,_that.transferredBytes,_that.sourceServerId,_that.destinationServerId,_that.error,_that.startedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sourcePath,  String destinationPath,  TransferDirection direction,  TransferStatus status,  int totalBytes,  int transferredBytes,  String? sourceServerId,  String? destinationServerId,  String? error,  DateTime? startedAt,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _TransferItem() when $default != null:
return $default(_that.id,_that.sourcePath,_that.destinationPath,_that.direction,_that.status,_that.totalBytes,_that.transferredBytes,_that.sourceServerId,_that.destinationServerId,_that.error,_that.startedAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc


class _TransferItem implements TransferItem {
  const _TransferItem({required this.id, required this.sourcePath, required this.destinationPath, required this.direction, required this.status, required this.totalBytes, this.transferredBytes = 0, this.sourceServerId, this.destinationServerId, this.error, this.startedAt, this.completedAt});
  

@override final  String id;
@override final  String sourcePath;
@override final  String destinationPath;
@override final  TransferDirection direction;
@override final  TransferStatus status;
@override final  int totalBytes;
@override@JsonKey() final  int transferredBytes;
@override final  String? sourceServerId;
@override final  String? destinationServerId;
@override final  String? error;
@override final  DateTime? startedAt;
@override final  DateTime? completedAt;

/// Create a copy of TransferItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferItemCopyWith<_TransferItem> get copyWith => __$TransferItemCopyWithImpl<_TransferItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferItem&&(identical(other.id, id) || other.id == id)&&(identical(other.sourcePath, sourcePath) || other.sourcePath == sourcePath)&&(identical(other.destinationPath, destinationPath) || other.destinationPath == destinationPath)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalBytes, totalBytes) || other.totalBytes == totalBytes)&&(identical(other.transferredBytes, transferredBytes) || other.transferredBytes == transferredBytes)&&(identical(other.sourceServerId, sourceServerId) || other.sourceServerId == sourceServerId)&&(identical(other.destinationServerId, destinationServerId) || other.destinationServerId == destinationServerId)&&(identical(other.error, error) || other.error == error)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,sourcePath,destinationPath,direction,status,totalBytes,transferredBytes,sourceServerId,destinationServerId,error,startedAt,completedAt);

@override
String toString() {
  return 'TransferItem(id: $id, sourcePath: $sourcePath, destinationPath: $destinationPath, direction: $direction, status: $status, totalBytes: $totalBytes, transferredBytes: $transferredBytes, sourceServerId: $sourceServerId, destinationServerId: $destinationServerId, error: $error, startedAt: $startedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$TransferItemCopyWith<$Res> implements $TransferItemCopyWith<$Res> {
  factory _$TransferItemCopyWith(_TransferItem value, $Res Function(_TransferItem) _then) = __$TransferItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String sourcePath, String destinationPath, TransferDirection direction, TransferStatus status, int totalBytes, int transferredBytes, String? sourceServerId, String? destinationServerId, String? error, DateTime? startedAt, DateTime? completedAt
});




}
/// @nodoc
class __$TransferItemCopyWithImpl<$Res>
    implements _$TransferItemCopyWith<$Res> {
  __$TransferItemCopyWithImpl(this._self, this._then);

  final _TransferItem _self;
  final $Res Function(_TransferItem) _then;

/// Create a copy of TransferItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourcePath = null,Object? destinationPath = null,Object? direction = null,Object? status = null,Object? totalBytes = null,Object? transferredBytes = null,Object? sourceServerId = freezed,Object? destinationServerId = freezed,Object? error = freezed,Object? startedAt = freezed,Object? completedAt = freezed,}) {
  return _then(_TransferItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourcePath: null == sourcePath ? _self.sourcePath : sourcePath // ignore: cast_nullable_to_non_nullable
as String,destinationPath: null == destinationPath ? _self.destinationPath : destinationPath // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TransferDirection,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransferStatus,totalBytes: null == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int,transferredBytes: null == transferredBytes ? _self.transferredBytes : transferredBytes // ignore: cast_nullable_to_non_nullable
as int,sourceServerId: freezed == sourceServerId ? _self.sourceServerId : sourceServerId // ignore: cast_nullable_to_non_nullable
as String?,destinationServerId: freezed == destinationServerId ? _self.destinationServerId : destinationServerId // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
