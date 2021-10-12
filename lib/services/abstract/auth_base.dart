import '../../model/auth_user.dart';

abstract class AuthBase {
  Future<AuthUser?> currentUser();
  Future<AuthUser?> singInAnonymously();
  Future<bool> signOut();
  Future<AuthUser?> signInWithGoogle();
  Future<AuthUser?> signInWithFacebook();
  Future<AuthUser?> signInWithEmailandPassword(String email, String password);
  Future<AuthUser?> createUserWithEmailandPassword(
      String email, String password);
}
