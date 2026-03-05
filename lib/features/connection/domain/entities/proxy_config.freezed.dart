// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'proxy_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProxyConfig {

 ProxyType get type; String get host; int get port; String? get username;
/// Create a copy of ProxyConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProxyConfigCopyWith<ProxyConfig> get copyWith => _$ProxyConfigCopyWithImpl<ProxyConfig>(this as ProxyConfig, _$identity);

  /// Serializes this ProxyConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProxyConfig&&(identical(other.type, type) || other.type == type)&&(identical(other.host, host) || other.host == host)&&(identical(other.port, port) || other.port == port)&&(identical(other.username, username) || other.username == username));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,host,port,username);

@override
String toString() {
  return 'ProxyConfig(type: $type, host: $host, port: $port, username: $username)';
}


}

/// @nodoc
abstract mixin class $ProxyConfigCopyWith<$Res>  {
  factory $ProxyConfigCopyWith(ProxyConfig value, $Res Function(ProxyConfig) _then) = _$ProxyConfigCopyWithImpl;
@useResult
$Res call({
 ProxyType type, String host, int port, String? username
});




}
/// @nodoc
class _$ProxyConfigCopyWithImpl<$Res>
    implements $ProxyConfigCopyWith<$Res> {
  _$ProxyConfigCopyWithImpl(this._self, this._then);

  final ProxyConfig _self;
  final $Res Function(ProxyConfig) _then;

/// Create a copy of ProxyConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? host = null,Object? port = null,Object? username = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ProxyType,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProxyConfig].
extension ProxyConfigPatterns on ProxyConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProxyConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProxyConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProxyConfig value)  $default,){
final _that = this;
switch (_that) {
case _ProxyConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProxyConfig value)?  $default,){
final _that = this;
switch (_that) {
case _ProxyConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProxyType type,  String host,  int port,  String? username)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProxyConfig() when $default != null:
return $default(_that.type,_that.host,_that.port,_that.username);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProxyType type,  String host,  int port,  String? username)  $default,) {final _that = this;
switch (_that) {
case _ProxyConfig():
return $default(_that.type,_that.host,_that.port,_that.username);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProxyType type,  String host,  int port,  String? username)?  $default,) {final _that = this;
switch (_that) {
case _ProxyConfig() when $default != null:
return $default(_that.type,_that.host,_that.port,_that.username);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProxyConfig implements ProxyConfig {
  const _ProxyConfig({this.type = ProxyType.none, this.host = '', this.port = 1080, this.username});
  factory _ProxyConfig.fromJson(Map<String, dynamic> json) => _$ProxyConfigFromJson(json);

@override@JsonKey() final  ProxyType type;
@override@JsonKey() final  String host;
@override@JsonKey() final  int port;
@override final  String? username;

/// Create a copy of ProxyConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProxyConfigCopyWith<_ProxyConfig> get copyWith => __$ProxyConfigCopyWithImpl<_ProxyConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProxyConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProxyConfig&&(identical(other.type, type) || other.type == type)&&(identical(other.host, host) || other.host == host)&&(identical(other.port, port) || other.port == port)&&(identical(other.username, username) || other.username == username));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,host,port,username);

@override
String toString() {
  return 'ProxyConfig(type: $type, host: $host, port: $port, username: $username)';
}


}

/// @nodoc
abstract mixin class _$ProxyConfigCopyWith<$Res> implements $ProxyConfigCopyWith<$Res> {
  factory _$ProxyConfigCopyWith(_ProxyConfig value, $Res Function(_ProxyConfig) _then) = __$ProxyConfigCopyWithImpl;
@override @useResult
$Res call({
 ProxyType type, String host, int port, String? username
});




}
/// @nodoc
class __$ProxyConfigCopyWithImpl<$Res>
    implements _$ProxyConfigCopyWith<$Res> {
  __$ProxyConfigCopyWithImpl(this._self, this._then);

  final _ProxyConfig _self;
  final $Res Function(_ProxyConfig) _then;

/// Create a copy of ProxyConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? host = null,Object? port = null,Object? username = freezed,}) {
  return _then(_ProxyConfig(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ProxyType,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
