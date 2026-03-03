import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/auth/domain/entities/auth_response.dart';

abstract class AuthRepository {
  Future<Result<AuthResponse>> register(String email, String password);
  Future<Result<AuthResponse>> login(
    String email,
    String password, {
    String? deviceName,
  });
  Future<Result<void>> logout(String refreshToken);
  Future<Result<void>> forgotPassword(String email);
  Future<Result<void>> resetPassword(String token, String newPassword);
  Future<Result<void>> verifyEmail(String token);
}
