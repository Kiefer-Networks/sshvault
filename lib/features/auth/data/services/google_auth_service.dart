import 'package:google_sign_in/google_sign_in.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<Result<String>> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        return const Err(AuthFailure('Sign in cancelled'));
      }

      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) {
        return const Err(AuthFailure('No ID token received from Google'));
      }

      return Success(idToken);
    } catch (e) {
      return Err(AuthFailure('Google sign in failed', cause: e));
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
