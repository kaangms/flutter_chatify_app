import 'dart:io';

import 'package:flutter_chatify_app/locator.dart';
import 'package:flutter_chatify_app/model/auth_user.dart';
import 'package:flutter_chatify_app/services/abstract/auth_base.dart';
import 'package:flutter_chatify_app/services/concrete/fake_api/fake_auth_service.dart';
import 'package:flutter_chatify_app/services/concrete/fake_api/fake_db_service.dart';
import 'package:flutter_chatify_app/services/concrete/fake_api/fake_storage_service.dart';
import 'package:flutter_chatify_app/services/concrete/firebase/firebase_auth_service.dart';
import 'package:flutter_chatify_app/services/concrete/firebase/firebase_db_service.dart';
import 'package:flutter_chatify_app/services/concrete/firebase/firebase_storage.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  FakeDBService _fakeDBService = locator<FakeDBService>();
  FakeStorageService _fakeStorageService = locator<FakeStorageService>();
  FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();
//_firestoreStorageService
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
      var user = await _firebaseAuthService.currentUser();
      var result = user != null
          ? await _firestoreDBService.readUser(user.userID!)
          : null;
      return result ?? user;
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
      return result ? await _firestoreDBService.readUser(user!.userID) : null;
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
      return result ? await _firestoreDBService.readUser(user!.userID) : null;
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
      return result ? await _firestoreDBService.readUser(user!.userID) : null;
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

  Future<bool> updateUserName(String userID, String userName) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeDBService.updateUserName(userID, userName);
    } else {
      return _firestoreDBService.updateUserName(userID, userName);
    }
  }

  Future<bool> uploadFile(
    String userID,
    String fileType,
    File uploadFile,
  ) async {
    if (appMode == AppMode.DEBUG) {
      await _fakeStorageService.uploadFile(userID, fileType, uploadFile);
      var result = _fakeDBService.updateProfilUrl(userID, "profilPhotoURL");
      return result;
    } else {
      var url = await _firebaseStorageService.uploadFile(
          userID, fileType, uploadFile);
      var result = _firestoreDBService.updateProfilUrl(userID, url);
      return result;
    }
  }
}
