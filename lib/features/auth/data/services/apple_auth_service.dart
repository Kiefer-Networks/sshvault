import 'dart:math';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';

class AppleAuthResult {
  final String idToken;
  final String? rawNonce;

  const AppleAuthResult({required this.idToken, this.rawNonce});
}

class AppleAuthService {
  Future<Result<AppleAuthResult>> signIn() async {
    try {
      final rawNonce = _generateNonce();
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: rawNonce,
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        return const Err(AuthFailure('No identity token received from Apple'));
      }

      return Success(AppleAuthResult(idToken: idToken, rawNonce: rawNonce));
    } catch (e) {
      if (e is SignInWithAppleAuthorizationException &&
          e.code == AuthorizationErrorCode.canceled) {
        return const Err(AuthFailure('Sign in cancelled'));
      }
      return Err(AuthFailure('Apple sign in failed', cause: e));
    }
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }
}
