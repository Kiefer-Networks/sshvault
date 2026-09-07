import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sshvault/features/connection/domain/entities/auth_method.dart';
import 'package:sshvault/features/connection/domain/entities/proxy_config.dart';
import 'package:sshvault/features/connection/domain/entities/tag_entity.dart';

part 'server_entity.freezed.dart';
part 'server_entity.g.dart';

@freezed
abstract class ServerEntity with _$ServerEntity {
  const factory ServerEntity({
    required String id,
    required String name,
    required String hostname,
    required int port,
    required String username,
    required AuthMethod authMethod,
    @Default('') String notes,
    required int color,
    @Default('server') String iconName,
    @Default(true) bool isActive,
    String? groupId,
    String? sshKeyId,
    @Default(0) int sortOrder,
    String? distroId,
    String? distroName,

    /// Operating system information detected after a successful SSH login.
    /// These values are part of the encrypted vault payload and are optional
    /// for servers created before OS detection was introduced.
    @JsonKey(name: 'os_family') String? osFamily,
    @JsonKey(name: 'os_name') String? osName,
    @JsonKey(name: 'os_version') String? osVersion,
    @JsonKey(name: 'os_pretty_name') String? osPrettyName,
    @JsonKey(name: 'os_detected_at') DateTime? osDetectedAt,

    /// JSON encoded [RemoteSystemMetrics], kept opaque inside the vault.
    String? systemMetricsJson,
    @Default([]) List<TagEntity> tags,
    String? jumpHostId,
    // Post-Connect
    @Default('') String postConnectCommands,
    // Dashboard
    @Default(false) bool isFavorite,
    DateTime? lastConnectedAt,
    // Proxy
    @Default(ProxyType.none) ProxyType proxyType,
    @Default('') String proxyHost,
    @Default(1080) int proxyPort,
    String? proxyUsername,
    @Default(true) bool useGlobalProxy,
    // VPN
    @Default(false) bool requiresVpn,
    // Sync
    String? ownerId,
    String? sharedWith,
    String? permissions,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _ServerEntity;

  factory ServerEntity.fromJson(Map<String, dynamic> json) =>
      _$ServerEntityFromJson(json);
}
