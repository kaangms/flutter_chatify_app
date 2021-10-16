import 'package:flutter_chatify_app/model/auth_user.dart';
import 'package:flutter_chatify_app/services/abstract/db_base.dart';

class FakeDBService implements DBBase {
  @override
  Future<AuthUser?> readUser(String userID) {
    // ignore: todo
    // TODO: implement readUser
    throw UnimplementedError();
  }

  @override
  Future<bool> saveUser(AuthUser user) {
    // ignore: todo
    // TODO: implement saveUser
    throw UnimplementedError();
  }

  @override
  Future<bool> updateUserName(String userID, String newUserName) {
    // ignore: todo
    // TODO: implement updateUserName
    throw UnimplementedError();
  }

  @override
  Future<bool> updateProfilUrl(String userID, String profilPhotoURL) {
    // ignore: todo
    // TODO: implement updateProfilUrl
    throw UnimplementedError();
  }
}
