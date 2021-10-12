import '/services/abstract/auth_base.dart';
import '../../../model/auth_user.dart';

class FakeAuthenticationService implements AuthBase {
  String userID = "123123123123123213123123123";

  @override
  Future<AuthUser?> currentUser() async {
    return await Future.value(
        AuthUser(userID: userID, email: "fakeuser@fake.com"));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<AuthUser> singInAnonymously() async {
    return await Future.delayed(Duration(seconds: 2),
        () => AuthUser(userID: userID, email: "fakeuser@fake.com"));
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => AuthUser(
            userID: "google_user_id_123456", email: "fakeuser@fake.com"));
  }

  @override
  Future<AuthUser> signInWithFacebook() async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => AuthUser(
            userID: "facebook_user_id_123456", email: "fakeuser@fake.com"));
  }

  @override
  Future<AuthUser> createUserWithEmailandPassword(
      String email, String password) async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => AuthUser(
            userID: "created_user_id_123456", email: "fakeuser@fake.com"));
  }

  @override
  Future<AuthUser> signInWithEmailandPassword(
      String email, String password) async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => AuthUser(
            userID: "signIn_user_id_123456", email: "fakeuser@fake.com"));
  }
}
