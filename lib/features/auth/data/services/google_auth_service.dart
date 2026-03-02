import 'package:google_sign_in/google_sign_in.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';

class GoogleAuthService {
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await GoogleSignIn.instance.initialize();
    _initialized = true;
  }

  Future<Result<String>> signIn() async {
    try {
      await _ensureInitialized();

      final account = await GoogleSignIn.instance.authenticate(
        scopeHint: ['email'],
      );
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        return const Err(AuthFailure('No ID token received from Google'));
      }

      return Success(idToken);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return const Err(AuthFailure('Sign in cancelled'));
      }
      return Err(AuthFailure('Google sign in failed', cause: e));
    } catch (e) {
      return Err(AuthFailure('Google sign in failed', cause: e));
    }
  }

  Future<void> signOut() async {
    try {
      await _ensureInitialized();
      await GoogleSignIn.instance.signOut();
    } catch (_) {
      // Ignore sign-out errors
    }
  }
}
