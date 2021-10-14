import 'package:flutter_chatify_app/locator.dart';
import 'package:flutter_chatify_app/model/auth_user.dart';
import 'package:flutter_chatify_app/services/abstract/auth_base.dart';
import 'package:flutter_chatify_app/services/concrete/fake_api/fake_auth_service.dart';
import 'package:flutter_chatify_app/services/concrete/firebase/firebase_auth_service.dart';
import 'package:flutter_chatify_app/services/concrete/firebase/firebase_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();

  FakeAuthenticationService _fakeAuthenticationService =
      locator<FakeAuthenticationService>();

  AppMode appMode = AppMode.RELEASE;
  List<AuthUser> allUserList = [];
  Map<String, String> userToken = Map<String, String>();
  @override
  Future<AuthUser?> createUserWithEmailandPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      var user = await _fakeAuthenticationService
          .createUserWithEmailandPassword(email, password);
      var result = await _firestoreDBService.saveUser(user);
      return result ? user : null;
    } else {
      var user = await _firebaseAuthService.createUserWithEmailandPassword(
          email, password);
      var result =
          user != null ? await _firestoreDBService.saveUser(user) : false;
      return result ? user : null;
    }
  }

  @override
  Future<AuthUser?> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.currentUser();
    } else {
      return await _firebaseAuthService.currentUser();
    }
  }

  @override
  Future<AuthUser?> signInWithEmailandPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      var user = await _fakeAuthenticationService.signInWithEmailandPassword(
          email, password);
      var result =
          // ignore: unnecessary_null_comparison
          user != null ? await _firestoreDBService.saveUser(user) : false;
      return result ? user : null;
    } else {
      var user = await _firebaseAuthService.signInWithEmailandPassword(
          email, password);
      var result =
          user != null ? await _firestoreDBService.saveUser(user) : false;
      return result ? user : null;
    }
  }

  @override
  Future<AuthUser?> signInWithFacebook() async {
    if (appMode == AppMode.DEBUG) {
      var user = await _fakeAuthenticationService.signInWithFacebook();
      var result =
          // ignore: unnecessary_null_comparison
          user != null ? await _firestoreDBService.saveUser(user) : false;
      return result ? user : null;
    } else {
      var user = await _firebaseAuthService.signInWithFacebook();
      var result =
          user != null ? await _firestoreDBService.saveUser(user) : false;
      return result ? user : null;
    }
  }

  @override
  Future<AuthUser?> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      var user = await _fakeAuthenticationService.signInWithGoogle();
      var result = await _firestoreDBService.saveUser(user);
      return result ? user : null;
    } else {
      var user = await _firebaseAuthService.signInWithGoogle();
      var result =
          user != null ? await _firestoreDBService.saveUser(user) : false;

      return result ? user : null;
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<AuthUser?> singInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.singInAnonymously();
    } else {
      return await _firebaseAuthService.singInAnonymously();
    }
  }
}
