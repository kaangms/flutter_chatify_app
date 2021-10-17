import 'package:flutter_chatify_app/model/auth_user.dart';
import 'package:flutter_chatify_app/model/message.dart';

abstract class DBBase {
  Future<bool> saveUser(AuthUser user);
  Future<AuthUser?> readUser(String userID);
  Future<bool> updateUserName(String userID, String newUserName);
  Future<bool> updateProfilUrl(String userID, String profilPhotoURL);
  Future<List<AuthUser>> getUserwithPagination(
      AuthUser? lastBroughtUser, int numberOfUserToFetch);
  Future<List<Message>> getAllConversations(String userID);
  Stream<List<Message>> getMessages(String currentUserID, String chattedUserID);
  Future<bool> saveMessage(Message messageToBeAdded);
  Future<List<Message>> getMessagewithPagination(
      String currentUserID,
      String chattedUserId,
      Message lastReceivedMessage,
      int pageViewSendNumber);
  // Future<DateTime> saatiGoster(String userID);
}
