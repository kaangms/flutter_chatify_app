import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chatify_app/model/auth_user.dart';
import 'package:flutter_chatify_app/services/abstract/auth_base.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<AuthUser?> createUserWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential _userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return _userCredential.user == null
          ? null
          : _userFromFirebase(_userCredential.user);
    } catch (e) {
      print('signInWithEmailandPassword-hata' + e.toString());
      return null;
    }
  }

  @override
  Future<AuthUser?> currentUser() async {
    try {
      var user = _firebaseAuth.currentUser;
      return _userFromFirebase(user);
    } catch (e) {
      print("-FirebaseAuthService-currentUser-hata" + e.toString());
      return null;
    }
  }

  AuthUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    } else {
     
      return AuthUser(
          userID: user.uid,
          email: user.email ?? user.providerData[0].email,
          userName: user.displayName);
    }
  }

  @override
  Future<AuthUser?> signInWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential _userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return _userCredential.user == null
          ? null
          : _userFromFirebase(_userCredential.user);
    } catch (e) {
      print('signInWithEmailandPassword-hata' + e.toString());
      return null;
    }
  }

  @override
  Future<AuthUser?> signInWithFacebook() async {
    try {
      LoginResult _facebookUser = await FacebookAuth.instance.login();

      if (_facebookUser.accessToken != null) {
        OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(_facebookUser.accessToken!.token);
        var _userCredential =
            await _firebaseAuth.signInWithCredential(facebookAuthCredential);
        return _userFromFirebase(_userCredential.user);
      } else
        return null;
    } catch (e) {
      print('signInWithGoogle-hata' + e.toString());
      return null;
    }
  }

  GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  Future<AuthUser?> signInWithGoogle() async {
    try {
      GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();
      if (_googleUser != null) {
        final GoogleSignInAuthentication _googleAuth =
            await _googleUser.authentication;
        if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
          final credential = GoogleAuthProvider.credential(
            accessToken: _googleAuth.accessToken,
            idToken: _googleAuth.idToken,
          );
          var _userCredential =
              await _firebaseAuth.signInWithCredential(credential);
          return _userFromFirebase(_userCredential.user);
        } else
          return null;
      } else
        return null;
    } catch (e) {
      print('signInWithGoogle-hata' + e.toString());
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      if (_googleSignIn.currentUser != null) {
        await _googleSignIn.signOut();
      }
      var _authFacebook = await FacebookAuth.instance;
      // ignore: unnecessary_null_comparison
      if (_authFacebook.accessToken != null) {
        await _authFacebook.logOut();
      }
      return true;
    } catch (e) {
      print('FirebaseAuthService-signOut-hata' + e.toString());
      return false;
    }
  }

  @override
  Future<AuthUser?> singInAnonymously() async {
    try {
      var userCredential = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(userCredential.user)!;
    } catch (e) {
      print("FirebaseAuthService-singInAnonymously-hata" + e.toString());
      return null;
    }
  }
}
