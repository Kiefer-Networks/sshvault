// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServerEntity {

 String get id; String get name; String get hostname; int get port; String get username; AuthMethod get authMethod; String get notes; int get color; String get iconName; bool get isActive; String? get groupId; String? get sshKeyId; int get sortOrder; String? get distroId; String? get distroName;/// Operating system information detected after a successful SSH login.
/// These values are part of the encrypted vault payload and are optional
/// for servers created before OS detection was introduced.
@JsonKey(name: 'os_family') String? get osFamily;@JsonKey(name: 'os_name') String? get osName;@JsonKey(name: 'os_version') String? get osVersion;@JsonKey(name: 'os_pretty_name') String? get osPrettyName;@JsonKey(name: 'os_detected_at') DateTime? get osDetectedAt;/// JSON encoded [RemoteSystemMetrics], kept opaque inside the vault.
 String? get systemMetricsJson; List<TagEntity> get tags; String? get jumpHostId; String get postConnectCommands; bool get isFavorite; DateTime? get lastConnectedAt; ProxyType get proxyType; String get proxyHost; int get proxyPort; String? get proxyUsername; bool get useGlobalProxy; bool get requiresVpn; String? get ownerId; String? get sharedWith; String? get permissions; DateTime get createdAt; DateTime get updatedAt; DateTime? get deletedAt;
/// Create a copy of ServerEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerEntityCopyWith<ServerEntity> get copyWith => _$ServerEntityCopyWithImpl<ServerEntity>(this as ServerEntity, _$identity);

  /// Serializes this ServerEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ServerEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerEntity&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.hostname, _this.hostname) || other.hostname == _this.hostname)&&(identical(other.port, _this.port) || other.port == _this.port)&&(identical(other.username, _this.username) || other.username == _this.username)&&(identical(other.authMethod, _this.authMethod) || other.authMethod == _this.authMethod)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.iconName, _this.iconName) || other.iconName == _this.iconName)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.groupId, _this.groupId) || other.groupId == _this.groupId)&&(identical(other.sshKeyId, _this.sshKeyId) || other.sshKeyId == _this.sshKeyId)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder)&&(identical(other.distroId, _this.distroId) || other.distroId == _this.distroId)&&(identical(other.distroName, _this.distroName) || other.distroName == _this.distroName)&&(identical(other.osFamily, _this.osFamily) || other.osFamily == _this.osFamily)&&(identical(other.osName, _this.osName) || other.osName == _this.osName)&&(identical(other.osVersion, _this.osVersion) || other.osVersion == _this.osVersion)&&(identical(other.osPrettyName, _this.osPrettyName) || other.osPrettyName == _this.osPrettyName)&&(identical(other.osDetectedAt, _this.osDetectedAt) || other.osDetectedAt == _this.osDetectedAt)&&(identical(other.systemMetricsJson, _this.systemMetricsJson) || other.systemMetricsJson == _this.systemMetricsJson)&&const DeepCollectionEquality().equals(other.tags, _this.tags)&&(identical(other.jumpHostId, _this.jumpHostId) || other.jumpHostId == _this.jumpHostId)&&(identical(other.postConnectCommands, _this.postConnectCommands) || other.postConnectCommands == _this.postConnectCommands)&&(identical(other.isFavorite, _this.isFavorite) || other.isFavorite == _this.isFavorite)&&(identical(other.lastConnectedAt, _this.lastConnectedAt) || other.lastConnectedAt == _this.lastConnectedAt)&&(identical(other.proxyType, _this.proxyType) || other.proxyType == _this.proxyType)&&(identical(other.proxyHost, _this.proxyHost) || other.proxyHost == _this.proxyHost)&&(identical(other.proxyPort, _this.proxyPort) || other.proxyPort == _this.proxyPort)&&(identical(other.proxyUsername, _this.proxyUsername) || other.proxyUsername == _this.proxyUsername)&&(identical(other.useGlobalProxy, _this.useGlobalProxy) || other.useGlobalProxy == _this.useGlobalProxy)&&(identical(other.requiresVpn, _this.requiresVpn) || other.requiresVpn == _this.requiresVpn)&&(identical(other.ownerId, _this.ownerId) || other.ownerId == _this.ownerId)&&(identical(other.sharedWith, _this.sharedWith) || other.sharedWith == _this.sharedWith)&&(identical(other.permissions, _this.permissions) || other.permissions == _this.permissions)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ServerEntity;
  return Object.hashAll([runtimeType,_this.id,_this.name,_this.hostname,_this.port,_this.username,_this.authMethod,_this.notes,_this.color,_this.iconName,_this.isActive,_this.groupId,_this.sshKeyId,_this.sortOrder,_this.distroId,_this.distroName,_this.osFamily,_this.osName,_this.osVersion,_this.osPrettyName,_this.osDetectedAt,_this.systemMetricsJson,const DeepCollectionEquality().hash(_this.tags),_this.jumpHostId,_this.postConnectCommands,_this.isFavorite,_this.lastConnectedAt,_this.proxyType,_this.proxyHost,_this.proxyPort,_this.proxyUsername,_this.useGlobalProxy,_this.requiresVpn,_this.ownerId,_this.sharedWith,_this.permissions,_this.createdAt,_this.updatedAt,_this.deletedAt]);
}

@override
String toString() {
  final _this = this as ServerEntity;
  return 'ServerEntity(id: ${_this.id}, name: ${_this.name}, hostname: ${_this.hostname}, port: ${_this.port}, username: ${_this.username}, authMethod: ${_this.authMethod}, notes: ${_this.notes}, color: ${_this.color}, iconName: ${_this.iconName}, isActive: ${_this.isActive}, groupId: ${_this.groupId}, sshKeyId: ${_this.sshKeyId}, sortOrder: ${_this.sortOrder}, distroId: ${_this.distroId}, distroName: ${_this.distroName}, osFamily: ${_this.osFamily}, osName: ${_this.osName}, osVersion: ${_this.osVersion}, osPrettyName: ${_this.osPrettyName}, osDetectedAt: ${_this.osDetectedAt}, systemMetricsJson: ${_this.systemMetricsJson}, tags: ${_this.tags}, jumpHostId: ${_this.jumpHostId}, postConnectCommands: ${_this.postConnectCommands}, isFavorite: ${_this.isFavorite}, lastConnectedAt: ${_this.lastConnectedAt}, proxyType: ${_this.proxyType}, proxyHost: ${_this.proxyHost}, proxyPort: ${_this.proxyPort}, proxyUsername: ${_this.proxyUsername}, useGlobalProxy: ${_this.useGlobalProxy}, requiresVpn: ${_this.requiresVpn}, ownerId: ${_this.ownerId}, sharedWith: ${_this.sharedWith}, permissions: ${_this.permissions}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, deletedAt: ${_this.deletedAt})';
}


}

/// @nodoc
abstract mixin class $ServerEntityCopyWith<$Res>  {
  factory $ServerEntityCopyWith(ServerEntity value, $Res Function(ServerEntity) _then) = _$ServerEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String hostname, int port, String username, AuthMethod authMethod, String notes, int color, String iconName, bool isActive, String? groupId, String? sshKeyId, int sortOrder, String? distroId, String? distroName,@JsonKey(name: 'os_family') String? osFamily,@JsonKey(name: 'os_name') String? osName,@JsonKey(name: 'os_version') String? osVersion,@JsonKey(name: 'os_pretty_name') String? osPrettyName,@JsonKey(name: 'os_detected_at') DateTime? osDetectedAt, String? systemMetricsJson, List<TagEntity> tags, String? jumpHostId, String postConnectCommands, bool isFavorite, DateTime? lastConnectedAt, ProxyType proxyType, String proxyHost, int proxyPort, String? proxyUsername, bool useGlobalProxy, bool requiresVpn, String? ownerId, String? sharedWith, String? permissions, DateTime createdAt, DateTime updatedAt, DateTime? deletedAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? hostname = null,Object? port = null,Object? username = null,Object? authMethod = null,Object? notes = null,Object? color = null,Object? iconName = null,Object? isActive = null,Object? groupId = freezed,Object? sshKeyId = freezed,Object? sortOrder = null,Object? distroId = freezed,Object? distroName = freezed,Object? osFamily = freezed,Object? osName = freezed,Object? osVersion = freezed,Object? osPrettyName = freezed,Object? osDetectedAt = freezed,Object? systemMetricsJson = freezed,Object? tags = null,Object? jumpHostId = freezed,Object? postConnectCommands = null,Object? isFavorite = null,Object? lastConnectedAt = freezed,Object? proxyType = null,Object? proxyHost = null,Object? proxyPort = null,Object? proxyUsername = freezed,Object? useGlobalProxy = null,Object? requiresVpn = null,Object? ownerId = freezed,Object? sharedWith = freezed,Object? permissions = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,}) {
  return _then(ServerEntity(
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
as String?,osFamily: freezed == osFamily ? _self.osFamily : osFamily // ignore: cast_nullable_to_non_nullable
as String?,osName: freezed == osName ? _self.osName : osName // ignore: cast_nullable_to_non_nullable
as String?,osVersion: freezed == osVersion ? _self.osVersion : osVersion // ignore: cast_nullable_to_non_nullable
as String?,osPrettyName: freezed == osPrettyName ? _self.osPrettyName : osPrettyName // ignore: cast_nullable_to_non_nullable
as String?,osDetectedAt: freezed == osDetectedAt ? _self.osDetectedAt : osDetectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,systemMetricsJson: freezed == systemMetricsJson ? _self.systemMetricsJson : systemMetricsJson // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<TagEntity>,jumpHostId: freezed == jumpHostId ? _self.jumpHostId : jumpHostId // ignore: cast_nullable_to_non_nullable
as String?,postConnectCommands: null == postConnectCommands ? _self.postConnectCommands : postConnectCommands // ignore: cast_nullable_to_non_nullable
as String,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,lastConnectedAt: freezed == lastConnectedAt ? _self.lastConnectedAt : lastConnectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,proxyType: null == proxyType ? _self.proxyType : proxyType // ignore: cast_nullable_to_non_nullable
as ProxyType,proxyHost: null == proxyHost ? _self.proxyHost : proxyHost // ignore: cast_nullable_to_non_nullable
as String,proxyPort: null == proxyPort ? _self.proxyPort : proxyPort // ignore: cast_nullable_to_non_nullable
as int,proxyUsername: freezed == proxyUsername ? _self.proxyUsername : proxyUsername // ignore: cast_nullable_to_non_nullable
as String?,useGlobalProxy: null == useGlobalProxy ? _self.useGlobalProxy : useGlobalProxy // ignore: cast_nullable_to_non_nullable
as bool,requiresVpn: null == requiresVpn ? _self.requiresVpn : requiresVpn // ignore: cast_nullable_to_non_nullable
as bool,ownerId: freezed == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String?,sharedWith: freezed == sharedWith ? _self.sharedWith : sharedWith // ignore: cast_nullable_to_non_nullable
as String?,permissions: freezed == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String hostname,  int port,  String username,  AuthMethod authMethod,  String notes,  int color,  String iconName,  bool isActive,  String? groupId,  String? sshKeyId,  int sortOrder,  String? distroId,  String? distroName, @JsonKey(name: 'os_family')  String? osFamily, @JsonKey(name: 'os_name')  String? osName, @JsonKey(name: 'os_version')  String? osVersion, @JsonKey(name: 'os_pretty_name')  String? osPrettyName, @JsonKey(name: 'os_detected_at')  DateTime? osDetectedAt,  String? systemMetricsJson,  List<TagEntity> tags,  String? jumpHostId,  String postConnectCommands,  bool isFavorite,  DateTime? lastConnectedAt,  ProxyType proxyType,  String proxyHost,  int proxyPort,  String? proxyUsername,  bool useGlobalProxy,  bool requiresVpn,  String? ownerId,  String? sharedWith,  String? permissions,  DateTime createdAt,  DateTime updatedAt,  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerEntity() when $default != null:
return $default(_that.id,_that.name,_that.hostname,_that.port,_that.username,_that.authMethod,_that.notes,_that.color,_that.iconName,_that.isActive,_that.groupId,_that.sshKeyId,_that.sortOrder,_that.distroId,_that.distroName,_that.osFamily,_that.osName,_that.osVersion,_that.osPrettyName,_that.osDetectedAt,_that.systemMetricsJson,_that.tags,_that.jumpHostId,_that.postConnectCommands,_that.isFavorite,_that.lastConnectedAt,_that.proxyType,_that.proxyHost,_that.proxyPort,_that.proxyUsername,_that.useGlobalProxy,_that.requiresVpn,_that.ownerId,_that.sharedWith,_that.permissions,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String hostname,  int port,  String username,  AuthMethod authMethod,  String notes,  int color,  String iconName,  bool isActive,  String? groupId,  String? sshKeyId,  int sortOrder,  String? distroId,  String? distroName, @JsonKey(name: 'os_family')  String? osFamily, @JsonKey(name: 'os_name')  String? osName, @JsonKey(name: 'os_version')  String? osVersion, @JsonKey(name: 'os_pretty_name')  String? osPrettyName, @JsonKey(name: 'os_detected_at')  DateTime? osDetectedAt,  String? systemMetricsJson,  List<TagEntity> tags,  String? jumpHostId,  String postConnectCommands,  bool isFavorite,  DateTime? lastConnectedAt,  ProxyType proxyType,  String proxyHost,  int proxyPort,  String? proxyUsername,  bool useGlobalProxy,  bool requiresVpn,  String? ownerId,  String? sharedWith,  String? permissions,  DateTime createdAt,  DateTime updatedAt,  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _ServerEntity():
return $default(_that.id,_that.name,_that.hostname,_that.port,_that.username,_that.authMethod,_that.notes,_that.color,_that.iconName,_that.isActive,_that.groupId,_that.sshKeyId,_that.sortOrder,_that.distroId,_that.distroName,_that.osFamily,_that.osName,_that.osVersion,_that.osPrettyName,_that.osDetectedAt,_that.systemMetricsJson,_that.tags,_that.jumpHostId,_that.postConnectCommands,_that.isFavorite,_that.lastConnectedAt,_that.proxyType,_that.proxyHost,_that.proxyPort,_that.proxyUsername,_that.useGlobalProxy,_that.requiresVpn,_that.ownerId,_that.sharedWith,_that.permissions,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String hostname,  int port,  String username,  AuthMethod authMethod,  String notes,  int color,  String iconName,  bool isActive,  String? groupId,  String? sshKeyId,  int sortOrder,  String? distroId,  String? distroName, @JsonKey(name: 'os_family')  String? osFamily, @JsonKey(name: 'os_name')  String? osName, @JsonKey(name: 'os_version')  String? osVersion, @JsonKey(name: 'os_pretty_name')  String? osPrettyName, @JsonKey(name: 'os_detected_at')  DateTime? osDetectedAt,  String? systemMetricsJson,  List<TagEntity> tags,  String? jumpHostId,  String postConnectCommands,  bool isFavorite,  DateTime? lastConnectedAt,  ProxyType proxyType,  String proxyHost,  int proxyPort,  String? proxyUsername,  bool useGlobalProxy,  bool requiresVpn,  String? ownerId,  String? sharedWith,  String? permissions,  DateTime createdAt,  DateTime updatedAt,  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _ServerEntity() when $default != null:
return $default(_that.id,_that.name,_that.hostname,_that.port,_that.username,_that.authMethod,_that.notes,_that.color,_that.iconName,_that.isActive,_that.groupId,_that.sshKeyId,_that.sortOrder,_that.distroId,_that.distroName,_that.osFamily,_that.osName,_that.osVersion,_that.osPrettyName,_that.osDetectedAt,_that.systemMetricsJson,_that.tags,_that.jumpHostId,_that.postConnectCommands,_that.isFavorite,_that.lastConnectedAt,_that.proxyType,_that.proxyHost,_that.proxyPort,_that.proxyUsername,_that.useGlobalProxy,_that.requiresVpn,_that.ownerId,_that.sharedWith,_that.permissions,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServerEntity implements ServerEntity {
  const _ServerEntity({required this.id, required this.name, required this.hostname, required this.port, required this.username, required this.authMethod, this.notes = '', required this.color, this.iconName = 'server', this.isActive = true, this.groupId, this.sshKeyId, this.sortOrder = 0, this.distroId, this.distroName, @JsonKey(name: 'os_family') this.osFamily, @JsonKey(name: 'os_name') this.osName, @JsonKey(name: 'os_version') this.osVersion, @JsonKey(name: 'os_pretty_name') this.osPrettyName, @JsonKey(name: 'os_detected_at') this.osDetectedAt, this.systemMetricsJson,  List<TagEntity> tags = const [], this.jumpHostId, this.postConnectCommands = '', this.isFavorite = false, this.lastConnectedAt, this.proxyType = ProxyType.none, this.proxyHost = '', this.proxyPort = 1080, this.proxyUsername, this.useGlobalProxy = true, this.requiresVpn = false, this.ownerId, this.sharedWith, this.permissions, required this.createdAt, required this.updatedAt, this.deletedAt}): _tags = tags;
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
/// Operating system information detected after a successful SSH login.
/// These values are part of the encrypted vault payload and are optional
/// for servers created before OS detection was introduced.
@override@JsonKey(name: 'os_family') final  String? osFamily;
@override@JsonKey(name: 'os_name') final  String? osName;
@override@JsonKey(name: 'os_version') final  String? osVersion;
@override@JsonKey(name: 'os_pretty_name') final  String? osPrettyName;
@override@JsonKey(name: 'os_detected_at') final  DateTime? osDetectedAt;
/// JSON encoded [RemoteSystemMetrics], kept opaque inside the vault.
@override final  String? systemMetricsJson;
 final  List<TagEntity> _tags;
@override@JsonKey() List<TagEntity> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  String? jumpHostId;
@override@JsonKey() final  String postConnectCommands;
@override@JsonKey() final  bool isFavorite;
@override final  DateTime? lastConnectedAt;
@override@JsonKey() final  ProxyType proxyType;
@override@JsonKey() final  String proxyHost;
@override@JsonKey() final  int proxyPort;
@override final  String? proxyUsername;
@override@JsonKey() final  bool useGlobalProxy;
@override@JsonKey() final  bool requiresVpn;
@override final  String? ownerId;
@override final  String? sharedWith;
@override final  String? permissions;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  DateTime? deletedAt;

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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.hostname, hostname) || other.hostname == hostname)&&(identical(other.port, port) || other.port == port)&&(identical(other.username, username) || other.username == username)&&(identical(other.authMethod, authMethod) || other.authMethod == authMethod)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.color, color) || other.color == color)&&(identical(other.iconName, iconName) || other.iconName == iconName)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.sshKeyId, sshKeyId) || other.sshKeyId == sshKeyId)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.distroId, distroId) || other.distroId == distroId)&&(identical(other.distroName, distroName) || other.distroName == distroName)&&(identical(other.osFamily, osFamily) || other.osFamily == osFamily)&&(identical(other.osName, osName) || other.osName == osName)&&(identical(other.osVersion, osVersion) || other.osVersion == osVersion)&&(identical(other.osPrettyName, osPrettyName) || other.osPrettyName == osPrettyName)&&(identical(other.osDetectedAt, osDetectedAt) || other.osDetectedAt == osDetectedAt)&&(identical(other.systemMetricsJson, systemMetricsJson) || other.systemMetricsJson == systemMetricsJson)&&const DeepCollectionEquality().equals(other.tags, _tags)&&(identical(other.jumpHostId, jumpHostId) || other.jumpHostId == jumpHostId)&&(identical(other.postConnectCommands, postConnectCommands) || other.postConnectCommands == postConnectCommands)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.lastConnectedAt, lastConnectedAt) || other.lastConnectedAt == lastConnectedAt)&&(identical(other.proxyType, proxyType) || other.proxyType == proxyType)&&(identical(other.proxyHost, proxyHost) || other.proxyHost == proxyHost)&&(identical(other.proxyPort, proxyPort) || other.proxyPort == proxyPort)&&(identical(other.proxyUsername, proxyUsername) || other.proxyUsername == proxyUsername)&&(identical(other.useGlobalProxy, useGlobalProxy) || other.useGlobalProxy == useGlobalProxy)&&(identical(other.requiresVpn, requiresVpn) || other.requiresVpn == requiresVpn)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.sharedWith, sharedWith) || other.sharedWith == sharedWith)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,name,hostname,port,username,authMethod,notes,color,iconName,isActive,groupId,sshKeyId,sortOrder,distroId,distroName,osFamily,osName,osVersion,osPrettyName,osDetectedAt,systemMetricsJson,const DeepCollectionEquality().hash(_tags),jumpHostId,postConnectCommands,isFavorite,lastConnectedAt,proxyType,proxyHost,proxyPort,proxyUsername,useGlobalProxy,requiresVpn,ownerId,sharedWith,permissions,createdAt,updatedAt,deletedAt]);
}

@override
String toString() {
    return 'ServerEntity(id: $id, name: $name, hostname: $hostname, port: $port, username: $username, authMethod: $authMethod, notes: $notes, color: $color, iconName: $iconName, isActive: $isActive, groupId: $groupId, sshKeyId: $sshKeyId, sortOrder: $sortOrder, distroId: $distroId, distroName: $distroName, osFamily: $osFamily, osName: $osName, osVersion: $osVersion, osPrettyName: $osPrettyName, osDetectedAt: $osDetectedAt, systemMetricsJson: $systemMetricsJson, tags: $tags, jumpHostId: $jumpHostId, postConnectCommands: $postConnectCommands, isFavorite: $isFavorite, lastConnectedAt: $lastConnectedAt, proxyType: $proxyType, proxyHost: $proxyHost, proxyPort: $proxyPort, proxyUsername: $proxyUsername, useGlobalProxy: $useGlobalProxy, requiresVpn: $requiresVpn, ownerId: $ownerId, sharedWith: $sharedWith, permissions: $permissions, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$ServerEntityCopyWith<$Res> implements $ServerEntityCopyWith<$Res> {
  factory _$ServerEntityCopyWith(_ServerEntity value, $Res Function(_ServerEntity) _then) = __$ServerEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String hostname, int port, String username, AuthMethod authMethod, String notes, int color, String iconName, bool isActive, String? groupId, String? sshKeyId, int sortOrder, String? distroId, String? distroName,@JsonKey(name: 'os_family') String? osFamily,@JsonKey(name: 'os_name') String? osName,@JsonKey(name: 'os_version') String? osVersion,@JsonKey(name: 'os_pretty_name') String? osPrettyName,@JsonKey(name: 'os_detected_at') DateTime? osDetectedAt, String? systemMetricsJson, List<TagEntity> tags, String? jumpHostId, String postConnectCommands, bool isFavorite, DateTime? lastConnectedAt, ProxyType proxyType, String proxyHost, int proxyPort, String? proxyUsername, bool useGlobalProxy, bool requiresVpn, String? ownerId, String? sharedWith, String? permissions, DateTime createdAt, DateTime updatedAt, DateTime? deletedAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? hostname = null,Object? port = null,Object? username = null,Object? authMethod = null,Object? notes = null,Object? color = null,Object? iconName = null,Object? isActive = null,Object? groupId = freezed,Object? sshKeyId = freezed,Object? sortOrder = null,Object? distroId = freezed,Object? distroName = freezed,Object? osFamily = freezed,Object? osName = freezed,Object? osVersion = freezed,Object? osPrettyName = freezed,Object? osDetectedAt = freezed,Object? systemMetricsJson = freezed,Object? tags = null,Object? jumpHostId = freezed,Object? postConnectCommands = null,Object? isFavorite = null,Object? lastConnectedAt = freezed,Object? proxyType = null,Object? proxyHost = null,Object? proxyPort = null,Object? proxyUsername = freezed,Object? useGlobalProxy = null,Object? requiresVpn = null,Object? ownerId = freezed,Object? sharedWith = freezed,Object? permissions = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,}) {
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
as String?,osFamily: freezed == osFamily ? _self.osFamily : osFamily // ignore: cast_nullable_to_non_nullable
as String?,osName: freezed == osName ? _self.osName : osName // ignore: cast_nullable_to_non_nullable
as String?,osVersion: freezed == osVersion ? _self.osVersion : osVersion // ignore: cast_nullable_to_non_nullable
as String?,osPrettyName: freezed == osPrettyName ? _self.osPrettyName : osPrettyName // ignore: cast_nullable_to_non_nullable
as String?,osDetectedAt: freezed == osDetectedAt ? _self.osDetectedAt : osDetectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,systemMetricsJson: freezed == systemMetricsJson ? _self.systemMetricsJson : systemMetricsJson // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<TagEntity>,jumpHostId: freezed == jumpHostId ? _self.jumpHostId : jumpHostId // ignore: cast_nullable_to_non_nullable
as String?,postConnectCommands: null == postConnectCommands ? _self.postConnectCommands : postConnectCommands // ignore: cast_nullable_to_non_nullable
as String,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,lastConnectedAt: freezed == lastConnectedAt ? _self.lastConnectedAt : lastConnectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,proxyType: null == proxyType ? _self.proxyType : proxyType // ignore: cast_nullable_to_non_nullable
as ProxyType,proxyHost: null == proxyHost ? _self.proxyHost : proxyHost // ignore: cast_nullable_to_non_nullable
as String,proxyPort: null == proxyPort ? _self.proxyPort : proxyPort // ignore: cast_nullable_to_non_nullable
as int,proxyUsername: freezed == proxyUsername ? _self.proxyUsername : proxyUsername // ignore: cast_nullable_to_non_nullable
as String?,useGlobalProxy: null == useGlobalProxy ? _self.useGlobalProxy : useGlobalProxy // ignore: cast_nullable_to_non_nullable
as bool,requiresVpn: null == requiresVpn ? _self.requiresVpn : requiresVpn // ignore: cast_nullable_to_non_nullable
as bool,ownerId: freezed == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
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
