import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sshvault/core/crypto/ssh_key_type.dart';

part 'ssh_key_entity.freezed.dart';
part 'ssh_key_entity.g.dart';

@freezed
abstract class SshKeyEntity with _$SshKeyEntity {
  const factory SshKeyEntity({
    required String id,
    required String name,
    required SshKeyType keyType,
    @Default('') String fingerprint,
    @Default('') String publicKey,
    @Default('') String comment,
    @Default(0) int linkedServerCount,
    String? ownerId,
    String? sharedWith,
    String? permissions,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _SshKeyEntity;

  factory SshKeyEntity.fromJson(Map<String, dynamic> json) =>
      _$SshKeyEntityFromJson(json);
}
