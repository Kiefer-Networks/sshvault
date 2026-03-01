import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_credentials.freezed.dart';
part 'server_credentials.g.dart';

@freezed
abstract class ServerCredentials with _$ServerCredentials {
  const factory ServerCredentials({
    String? password,
    String? privateKey,
    String? publicKey,
    String? passphrase,
  }) = _ServerCredentials;

  factory ServerCredentials.fromJson(Map<String, dynamic> json) =>
      _$ServerCredentialsFromJson(json);
}
