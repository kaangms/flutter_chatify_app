import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_chatify_app/locator.dart';
import 'package:flutter_chatify_app/model/auth_user.dart';
import 'package:flutter_chatify_app/repository/user_repository.dart';
import 'package:flutter_chatify_app/services/abstract/auth_base.dart';

enum ViewState { Idle, Busy }

class UserModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;

  UserRepository _userRepository = locator<UserRepository>();

  AuthUser? _user;
  AuthUser? get user => this._user;
  ViewState get state => this._state;
  // set user(value) => this._user = value;
  set state(ViewState value) {
    this._state = value;
    notifyListeners();
  }

  UserModel() {
    currentUser();
  }
  String errorMessagePassword = '';
  String errorMessageEmail = '';

  @override
  Future<AuthUser?> createUserWithEmailandPassword(
      String email, String password) async {
    try {
      state = ViewState.Busy;

      if (_emailAndPasswordCheck(email, password)) {
        _user = await _userRepository.createUserWithEmailandPassword(
            email, password);
        return _user;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Viewmodeldeki current user hata' + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<AuthUser?> currentUser() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.currentUser();
      return _user;
    } catch (e) {
      debugPrint('Viewmodeldeki current user hata' + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<AuthUser?> signInWithEmailandPassword(
      String email, String password) async {
    try {
      state = ViewState.Busy;
      if (_emailAndPasswordCheck(email, password)) {
        _user =
            await _userRepository.signInWithEmailandPassword(email, password);
        return _user;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Viewmodeldeki current user hata' + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<AuthUser?> signInWithFacebook() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithFacebook();
      return _user;
    } catch (e) {
      debugPrint('Viewmodeldeki signInWithFacebook hata' + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<AuthUser?> signInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithGoogle();
      return _user;
    } catch (e) {
      debugPrint('Viewmodeldeki signInWithGoogle hata' + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      var result = await _userRepository.signOut();
      _user = null;
      return result;
    } catch (e) {
      debugPrint('Viewmodeldeki signOut hata' + e.toString());
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<AuthUser?> singInAnonymously() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.singInAnonymously();
      return _user;
    } catch (e) {
      debugPrint('Viewmodeldeki singInAnonymously user hata' + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  bool _emailAndPasswordCheck(String email, String password) {
    var result = true;
    if (password.length < 6) {
      errorMessagePassword = "En Az 6 Karekter Olmalı ";
      result = false;
    }
    if (!email.contains("@")) {
      errorMessageEmail = "Geçersiz Email Adresi";

      result = false;
    }
    return result;
  }

  Future<bool> updateUserName(String userID, String userName) async {
    return await _userRepository.updateUserName(userID, userName);
  }

  Future<bool> uploadFile(
    String userID,
    String fileType,
    File uploadFile,
  ) async {
    return await _userRepository.uploadFile(userID, fileType, uploadFile);
  }
}
