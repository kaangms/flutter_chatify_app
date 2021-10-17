
import 'package:flutter_chatify_app/model/auth_user.dart';
import 'package:flutter_chatify_app/model/message.dart';
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

  @override
  Future<List<AuthUser>> getUserwithPagination(
      AuthUser? lastBroughtUser, int numberOfUserToFetch) {
    // ignore: todo
    // TODO: implement getUserwithPagination
    throw UnimplementedError();
  }

  @override
  Future<List<Message>> getAllConversations(String userID) {
    // ignore: todo
    // TODO: implement getAllConversations
    throw UnimplementedError();
  }

  @override
  Stream<List<Message>> getMessages(
      String currentUserID, String chattedUserId) {
    // ignore: todo
    // TODO: implement getMessages
    throw UnimplementedError();
  }

  @override
  Future<List<Message>> getMessagewithPagination(String currentUserID, String chattedUserId, Message lastReceivedMessage, int pageViewSendNumber) {
    // ignore: todo
    // TODO: implement getMessagewithPagination
    throw UnimplementedError();
  }

  @override
  Future<bool> saveMessage(Message messageToBeAdded) {
    // ignore: todo
    // TODO: implement saveMessage
    throw UnimplementedError();
  }
}
