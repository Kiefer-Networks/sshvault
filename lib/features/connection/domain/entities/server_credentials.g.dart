// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServerCredentials _$ServerCredentialsFromJson(Map<String, dynamic> json) =>
    _ServerCredentials(
      password: json['password'] as String?,
      privateKey: json['privateKey'] as String?,
      publicKey: json['publicKey'] as String?,
      passphrase: json['passphrase'] as String?,
    );

Map<String, dynamic> _$ServerCredentialsToJson(_ServerCredentials instance) =>
    <String, dynamic>{
      'password': instance.password,
      'privateKey': instance.privateKey,
      'publicKey': instance.publicKey,
      'passphrase': instance.passphrase,
    };
