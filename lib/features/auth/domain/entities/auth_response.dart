import 'package:sshvault/features/auth/domain/entities/user_entity.dart';

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
    String? expiresAt;
    final raw = json['expires_at'];
    if (raw is int) {
      expiresAt = DateTime.fromMillisecondsSinceEpoch(
        raw * 1000,
        isUtc: true,
      ).toIso8601String();
    } else if (raw is String) {
      expiresAt = raw;
    }

    return AuthResponse(
      user: UserEntity.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresAt: expiresAt,
    );
  }
}
