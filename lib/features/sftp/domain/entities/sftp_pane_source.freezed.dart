// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sftp_pane_source.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SftpPaneSource {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SftpPaneSource);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SftpPaneSource()';
}


}

/// @nodoc
class $SftpPaneSourceCopyWith<$Res>  {
$SftpPaneSourceCopyWith(SftpPaneSource _, $Res Function(SftpPaneSource) __);
}


/// Adds pattern-matching-related methods to [SftpPaneSource].
extension SftpPaneSourcePatterns on SftpPaneSource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SftpPaneSourceLocal value)?  local,TResult Function( SftpPaneSourceRemote value)?  remote,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SftpPaneSourceLocal() when local != null:
return local(_that);case SftpPaneSourceRemote() when remote != null:
return remote(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SftpPaneSourceLocal value)  local,required TResult Function( SftpPaneSourceRemote value)  remote,}){
final _that = this;
switch (_that) {
case SftpPaneSourceLocal():
return local(_that);case SftpPaneSourceRemote():
return remote(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SftpPaneSourceLocal value)?  local,TResult? Function( SftpPaneSourceRemote value)?  remote,}){
final _that = this;
switch (_that) {
case SftpPaneSourceLocal() when local != null:
return local(_that);case SftpPaneSourceRemote() when remote != null:
return remote(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  local,TResult Function( String serverId,  String serverName)?  remote,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SftpPaneSourceLocal() when local != null:
return local();case SftpPaneSourceRemote() when remote != null:
return remote(_that.serverId,_that.serverName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  local,required TResult Function( String serverId,  String serverName)  remote,}) {final _that = this;
switch (_that) {
case SftpPaneSourceLocal():
return local();case SftpPaneSourceRemote():
return remote(_that.serverId,_that.serverName);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  local,TResult? Function( String serverId,  String serverName)?  remote,}) {final _that = this;
switch (_that) {
case SftpPaneSourceLocal() when local != null:
return local();case SftpPaneSourceRemote() when remote != null:
return remote(_that.serverId,_that.serverName);case _:
  return null;

}
}

}

/// @nodoc


class SftpPaneSourceLocal implements SftpPaneSource {
  const SftpPaneSourceLocal();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SftpPaneSourceLocal);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SftpPaneSource.local()';
}


}




/// @nodoc


class SftpPaneSourceRemote implements SftpPaneSource {
  const SftpPaneSourceRemote({required this.serverId, required this.serverName});
  

 final  String serverId;
 final  String serverName;

/// Create a copy of SftpPaneSource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SftpPaneSourceRemoteCopyWith<SftpPaneSourceRemote> get copyWith => _$SftpPaneSourceRemoteCopyWithImpl<SftpPaneSourceRemote>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SftpPaneSourceRemote&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.serverName, serverName) || other.serverName == serverName));
}


@override
int get hashCode => Object.hash(runtimeType,serverId,serverName);

@override
String toString() {
  return 'SftpPaneSource.remote(serverId: $serverId, serverName: $serverName)';
}


}

/// @nodoc
abstract mixin class $SftpPaneSourceRemoteCopyWith<$Res> implements $SftpPaneSourceCopyWith<$Res> {
  factory $SftpPaneSourceRemoteCopyWith(SftpPaneSourceRemote value, $Res Function(SftpPaneSourceRemote) _then) = _$SftpPaneSourceRemoteCopyWithImpl;
@useResult
$Res call({
 String serverId, String serverName
});




}
/// @nodoc
class _$SftpPaneSourceRemoteCopyWithImpl<$Res>
    implements $SftpPaneSourceRemoteCopyWith<$Res> {
  _$SftpPaneSourceRemoteCopyWithImpl(this._self, this._then);

  final SftpPaneSourceRemote _self;
  final $Res Function(SftpPaneSourceRemote) _then;

/// Create a copy of SftpPaneSource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? serverId = null,Object? serverName = null,}) {
  return _then(SftpPaneSourceRemote(
serverId: null == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String,serverName: null == serverName ? _self.serverName : serverName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
