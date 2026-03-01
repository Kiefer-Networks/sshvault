// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_credentials.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServerCredentials {

 String? get password; String? get privateKey; String? get publicKey; String? get passphrase;
/// Create a copy of ServerCredentials
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerCredentialsCopyWith<ServerCredentials> get copyWith => _$ServerCredentialsCopyWithImpl<ServerCredentials>(this as ServerCredentials, _$identity);

  /// Serializes this ServerCredentials to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerCredentials&&(identical(other.password, password) || other.password == password)&&(identical(other.privateKey, privateKey) || other.privateKey == privateKey)&&(identical(other.publicKey, publicKey) || other.publicKey == publicKey)&&(identical(other.passphrase, passphrase) || other.passphrase == passphrase));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,password,privateKey,publicKey,passphrase);

@override
String toString() {
  return 'ServerCredentials(password: $password, privateKey: $privateKey, publicKey: $publicKey, passphrase: $passphrase)';
}


}

/// @nodoc
abstract mixin class $ServerCredentialsCopyWith<$Res>  {
  factory $ServerCredentialsCopyWith(ServerCredentials value, $Res Function(ServerCredentials) _then) = _$ServerCredentialsCopyWithImpl;
@useResult
$Res call({
 String? password, String? privateKey, String? publicKey, String? passphrase
});




}
/// @nodoc
class _$ServerCredentialsCopyWithImpl<$Res>
    implements $ServerCredentialsCopyWith<$Res> {
  _$ServerCredentialsCopyWithImpl(this._self, this._then);

  final ServerCredentials _self;
  final $Res Function(ServerCredentials) _then;

/// Create a copy of ServerCredentials
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? password = freezed,Object? privateKey = freezed,Object? publicKey = freezed,Object? passphrase = freezed,}) {
  return _then(_self.copyWith(
password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,privateKey: freezed == privateKey ? _self.privateKey : privateKey // ignore: cast_nullable_to_non_nullable
as String?,publicKey: freezed == publicKey ? _self.publicKey : publicKey // ignore: cast_nullable_to_non_nullable
as String?,passphrase: freezed == passphrase ? _self.passphrase : passphrase // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerCredentials].
extension ServerCredentialsPatterns on ServerCredentials {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerCredentials value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerCredentials() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerCredentials value)  $default,){
final _that = this;
switch (_that) {
case _ServerCredentials():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerCredentials value)?  $default,){
final _that = this;
switch (_that) {
case _ServerCredentials() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? password,  String? privateKey,  String? publicKey,  String? passphrase)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerCredentials() when $default != null:
return $default(_that.password,_that.privateKey,_that.publicKey,_that.passphrase);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? password,  String? privateKey,  String? publicKey,  String? passphrase)  $default,) {final _that = this;
switch (_that) {
case _ServerCredentials():
return $default(_that.password,_that.privateKey,_that.publicKey,_that.passphrase);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? password,  String? privateKey,  String? publicKey,  String? passphrase)?  $default,) {final _that = this;
switch (_that) {
case _ServerCredentials() when $default != null:
return $default(_that.password,_that.privateKey,_that.publicKey,_that.passphrase);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServerCredentials implements ServerCredentials {
  const _ServerCredentials({this.password, this.privateKey, this.publicKey, this.passphrase});
  factory _ServerCredentials.fromJson(Map<String, dynamic> json) => _$ServerCredentialsFromJson(json);

@override final  String? password;
@override final  String? privateKey;
@override final  String? publicKey;
@override final  String? passphrase;

/// Create a copy of ServerCredentials
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerCredentialsCopyWith<_ServerCredentials> get copyWith => __$ServerCredentialsCopyWithImpl<_ServerCredentials>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServerCredentialsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerCredentials&&(identical(other.password, password) || other.password == password)&&(identical(other.privateKey, privateKey) || other.privateKey == privateKey)&&(identical(other.publicKey, publicKey) || other.publicKey == publicKey)&&(identical(other.passphrase, passphrase) || other.passphrase == passphrase));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,password,privateKey,publicKey,passphrase);

@override
String toString() {
  return 'ServerCredentials(password: $password, privateKey: $privateKey, publicKey: $publicKey, passphrase: $passphrase)';
}


}

/// @nodoc
abstract mixin class _$ServerCredentialsCopyWith<$Res> implements $ServerCredentialsCopyWith<$Res> {
  factory _$ServerCredentialsCopyWith(_ServerCredentials value, $Res Function(_ServerCredentials) _then) = __$ServerCredentialsCopyWithImpl;
@override @useResult
$Res call({
 String? password, String? privateKey, String? publicKey, String? passphrase
});




}
/// @nodoc
class __$ServerCredentialsCopyWithImpl<$Res>
    implements _$ServerCredentialsCopyWith<$Res> {
  __$ServerCredentialsCopyWithImpl(this._self, this._then);

  final _ServerCredentials _self;
  final $Res Function(_ServerCredentials) _then;

/// Create a copy of ServerCredentials
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? password = freezed,Object? privateKey = freezed,Object? publicKey = freezed,Object? passphrase = freezed,}) {
  return _then(_ServerCredentials(
password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,privateKey: freezed == privateKey ? _self.privateKey : privateKey // ignore: cast_nullable_to_non_nullable
as String?,publicKey: freezed == publicKey ? _self.publicKey : publicKey // ignore: cast_nullable_to_non_nullable
as String?,passphrase: freezed == passphrase ? _self.passphrase : passphrase // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
