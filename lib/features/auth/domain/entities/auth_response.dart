import 'package:shellvault/features/auth/domain/entities/user_entity.dart';

class AuthResponse {
  final UserEntity user;
  final String accessToken;
  final String refreshToken;
  final String? expiresAt;

  const AuthResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    this.expiresAt,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: UserEntity.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresAt: json['expires_at'] as String?,
    );
  }
}
